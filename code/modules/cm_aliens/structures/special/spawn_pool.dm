//Spawn Pool - Respawns dead xenos
/obj/effect/alien/resin/special/pool
	name = XENO_STRUCTURE_POOL
	desc = "A pool of primordial goop, reeking of sour smells. Home to many small, wriggling masses."
	icon_state = "pool"
	health = 900
	var/last_larva_time = 0
	var/last_surge_time = 0
	var/spawn_cooldown = 30 SECONDS
	var/surge_cooldown = 90 SECONDS
	var/surge_incremental_reduction = 3 SECONDS
	var/mob/melting_body

	var/damage_amount = 20

	luminosity = 3

/obj/effect/alien/resin/special/pool/update_icon()
	..()
	overlays.Cut()
	underlays.Cut()
	underlays += "[icon_state]_underlay"
	overlays += mutable_appearance(icon, "[icon_state]_overlay", layer = ABOVE_MOB_LAYER, plane = GAME_PLANE)
	if(linked_hive.stored_larva)
		overlays += mutable_appearance(icon,"[icon_state]_bubbling", layer = ABOVE_MOB_LAYER + 0.1, plane = GAME_PLANE)

/obj/effect/alien/resin/special/pool/New(loc, hive_ref)
	last_larva_time = world.time
	..(loc, hive_ref)
	if(isnull(linked_hive))
		linked_hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	linked_hive.spawn_pool = src

/obj/effect/alien/resin/special/pool/get_examine_text(mob/user)
	. = ..()
	if(isxeno(user) || isobserver(user))
		. += "It has [linked_hive.stored_larva] more larvae to grow."

/obj/effect/alien/resin/special/pool/attackby(obj/item/I, mob/user)
	if(!istype(I, /obj/item/grab) || !isxeno(user))
		return ..(I, user)

	var/larva_amount = 0 // The amount of larva they get

	var/obj/item/grab/G = I
	if(!iscarbon(G.grabbed_thing))
		return
	var/mob/living/carbon/M = G.grabbed_thing
	if(M.buckled)
		to_chat(user, SPAN_XENOWARNING("Unbuckle first!"))
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		if(H.is_revivable())
			to_chat(user, SPAN_XENOWARNING("This one is not suitable yet!"))
			return
		if(H.chestburst && H.stat != DEAD) // This isn't covered in H.is_revivable() as it returns FALSE if chestburst is TRUE
			to_chat(user, SPAN_XENOWARNING("Let this one burst first!"))
			return
		if(H.spawned_corpse)
			to_chat(user, SPAN_XENOWARNING("This one does not look suitable!"))
			return
		user.stop_pulling() // disrupt any grabs
		larva_amount++
	if(isxeno(M))
		if(!linked_hive || M.stat != DEAD)
			return

		if(SSticker.mode && !(SSticker.mode.flags_round_type & MODE_XVX))
			return // For now, disabled on gamemodes that don't support it (primarily distress signal)

		// Will probably allow for hives to slowly gain larva by killing hostile xenos and taking them to the spawnpool
		// A self sustaining cycle until one hive kills more of the other hive to tip the balance

		// Makes attacking hives very profitable if they can successfully wipe them out without suffering any significant losses
		var/mob/living/carbon/xenomorph/X = M
		if(X.hivenumber != linked_hive.hivenumber)
			if(isqueen(X))
				larva_amount = 5
			else
				larva_amount += max(X.tier, 1) // Now you always gain larva.
		else
			return
	if(melting_body)
		to_chat(user, SPAN_XENOWARNING("\The [src] is already processing a host! Using this one now would be a waste..."))
		return
	if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
		return
	visible_message(SPAN_DANGER("\The [src] splashes loudly as \the [M] is tossed in, bubbling uncontrollably!"))
	melting_body = M
	melting_body.setDir(SOUTH)
	melting_body.moveToNullspace()
	melting_body.pixel_x = 16
	melting_body.pixel_y = 19
	vis_contents += melting_body
	update_icon()
	new /obj/effect/overlay/temp/acid_pool_splash(loc)
	playsound(src, 'sound/effects/acidpool.ogg', 25, 1)

	linked_hive.stored_larva += larva_amount

	linked_hive.hive_ui.update_pooled_larva()

	melt_body()

/obj/effect/alien/resin/special/pool/process()
	if(!linked_hive)
		return

	for(var/mob/living/carbon/xenomorph/larva/L in range(2, src))
		if(!L.ckey && L.poolable && !QDELETED(L))
			visible_message(SPAN_XENODANGER("[L] quickly dives into the pool."))
			linked_hive.stored_larva++
			linked_hive.hive_ui.update_pooled_larva()
			qdel(L)

	if((last_larva_time + spawn_cooldown) < world.time && can_spawn_larva()) // every minute
		last_larva_time = world.time
		var/list/players_with_xeno_pref = get_alien_candidates()
		if(players_with_xeno_pref && players_with_xeno_pref.len && can_spawn_larva())
			spawn_pooled_larva(pick(players_with_xeno_pref))

	if(linked_hive.hijack_pooled_surge && (last_surge_time + surge_cooldown) < world.time)
		last_surge_time = world.time
		linked_hive.stored_larva++
		announce_dchat("The hive has gained another pooled larva! Use the Join As Xeno verb to take it.", src)
		if(surge_cooldown > 30 SECONDS) //mostly for sanity purposes
			surge_cooldown = surge_cooldown - surge_incremental_reduction //ramps up over time

/obj/effect/alien/resin/special/pool/proc/melt_body(iterations = 3)
	if(!melting_body)
		return

	melting_body.pixel_y--
	playsound(src, 'sound/bullets/acid_impact1.ogg', 25)
	iterations--
	if(!iterations)
		vis_contents.Cut()

		for(var/atom/movable/A in melting_body.contents_recursive()) // Get rid of any unacidable objects so we don't delete them
			if(isitem(A))
				var/obj/item/item = A
				if(item.is_objective && item.unacidable)
					item.forceMove(get_step(loc, pick(alldirs)))

		QDEL_NULL(melting_body)
	else
		addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/effect/alien/resin/special/pool, melt_body), iterations), 2 SECONDS)

/obj/effect/alien/resin/special/pool/proc/can_spawn_larva()
	if(linked_hive.hardcore)
		return FALSE

	return linked_hive.stored_larva

/obj/effect/alien/resin/special/pool/proc/spawn_pooled_larva(mob/xeno_candidate)
	if(can_spawn_larva() && xeno_candidate)
		var/mob/living/carbon/xenomorph/larva/new_xeno = spawn_hivenumber_larva(loc, linked_hive.hivenumber)
		if(isnull(new_xeno))
			return FALSE

		new_xeno.visible_message(SPAN_XENODANGER("A larva suddenly emerges from \the [src]!"),
		SPAN_XENODANGER("You emerge from \the [src] and awaken from your slumber. For the Hive!"))
		msg_admin_niche("[key_name(new_xeno)] emerged from \a [src]. (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")
		playsound(new_xeno, 'sound/effects/xeno_newlarva.ogg', 50, 1)
		if(!SSticker.mode.transfer_xeno(xeno_candidate, new_xeno))
			qdel(new_xeno)
			return FALSE
		to_chat(new_xeno, SPAN_XENOANNOUNCE("You are a xenomorph larva awakened from slumber!"))
		playsound(new_xeno, 'sound/effects/xeno_newlarva.ogg', 50, 1)
		if(new_xeno.client)
			if(new_xeno.client?.prefs.toggles_flashing & FLASH_POOLSPAWN)
				window_flash(new_xeno.client)

		linked_hive.stored_larva--
		linked_hive.hive_ui.update_pooled_larva()

		return TRUE
	return FALSE

/obj/effect/alien/resin/special/pool/Destroy()
	linked_hive.spawn_pool = null
	vis_contents.Cut()
	QDEL_NULL(melting_body)
	if(linked_hive.hijack_pooled_surge)
		visible_message(SPAN_XENODANGER("You hear something resembling a scream from [src] as it's destroyed!"))
		xeno_message(SPAN_XENOANNOUNCE("Psychic pain storms throughout the hive as the spawn pool is destroyed! You will no longer gain pooled larva over time."), 3, linked_hive.hivenumber)
		linked_hive.hijack_pooled_surge = FALSE

	for(var/turf/T in range(1, src))
		var/obj/effect/xenomorph/spray/spray = new /obj/effect/xenomorph/spray(T)
		spray.cause_data = create_cause_data(src.name)

	. = ..()

/obj/effect/alien/resin/special/pool/Crossed(mob/AM)
	. = ..()

	if(!ishuman(AM) || AM.stat == DEAD)
		return

	var/mob/living/carbon/human/H = AM

	H.emote("pain")
	if(prob(20))
		to_chat(H, SPAN_DANGER("You trip into the pool!"))
		H.KnockDown(5)
	do_human_damage(H)

/obj/effect/alien/resin/special/pool/proc/do_human_damage(mob/living/carbon/human/H)
	if(H.loc != loc)
		return

	playsound(H, get_sfx("acid_sizzle"), 30)
	addtimer(CALLBACK(src, PROC_REF(do_human_damage), H), 3 SECONDS, TIMER_UNIQUE)

	if(H.lying)
		for(var/i in DEFENSE_ZONES_LIVING)
			H.apply_armoured_damage(damage_amount * 0.35, ARMOR_BIO, BURN, i)
		return
	H.apply_armoured_damage(damage_amount * 0.4, ARMOR_BIO, BURN, "l_foot")
	H.apply_armoured_damage(damage_amount * 0.4, ARMOR_BIO, BURN, "r_foot")
	H.apply_armoured_damage(damage_amount * 0.4, ARMOR_BIO, BURN, "l_leg")
	H.apply_armoured_damage(damage_amount * 0.4, ARMOR_BIO, BURN, "r_leg")


