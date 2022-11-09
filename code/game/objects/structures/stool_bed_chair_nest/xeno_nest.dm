
//Alium nests. Essentially beds with an unbuckle delay that only aliums can buckle mobs to.
/obj/structure/bed/nest
	name = "alien nest"
	desc = "It's a gruesome pile of thick, sticky resin shaped like a nest."
	icon = 'icons/mob/hostiles/Effects.dmi'
	icon_state = "nest"
	buckling_y = 6
	buildstacktype = null //can't be disassembled and doesn't drop anything when destroyed
	unacidable = TRUE
	health = 100
	var/on_fire = 0
	var/resisting = 0
	var/resisting_ready = 0
	var/nest_resist_time = 1200
	var/mob/dead/observer/ghost_of_buckled_mob =  null
	var/hivenumber = XENO_HIVE_NORMAL
	layer = RESIN_STRUCTURE_LAYER

	var/force_nest = FALSE

/obj/structure/bed/nest/Initialize(mapload, hive)
	. = ..()

	if (hive)
		hivenumber = hive

	set_hive_data(src, hivenumber)

/obj/structure/bed/nest/alpha
	color = "#ff4040"
	hivenumber = XENO_HIVE_ALPHA

/obj/structure/bed/nest/forsaken
	color = "#cc8ec4"
	hivenumber = XENO_HIVE_FORSAKEN

/obj/structure/bed/nest/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		if(ismob(G.grabbed_thing))
			var/mob/M = G.grabbed_thing
			to_chat(user, SPAN_NOTICE("You place \the [M] on \the [src]."))
			M.forceMove(loc)
		return TRUE
	if(W.flags_item & NOBLUDGEON)
		return
	if(iscarbon(user))
		var/mob/living/carbon/carbon = user
		if(HIVE_ALLIED_TO_HIVE(carbon.hivenumber, hivenumber))
			to_chat(user, SPAN_XENOWARNING("You shouldn't interfere with the nest, leave that to the drones."))
			return
	if(buckled_mob)
		if(iswelder(W))
			var/obj/item/tool/weldingtool/WT = W
			if(!WT.isOn())
				to_chat(user, SPAN_WARNING("You need to turn \the [W] on before you can unnest someone!"))
				return
			playsound(loc, 'sound/items/weldingtool_weld.ogg', 25)
			user.visible_message(SPAN_NOTICE("\The [user] starts burning through the resin binding \the [buckled_mob] in place..."), SPAN_NOTICE("You start burning through the resin binding \the [buckled_mob] in place..."))
			if(!do_after(user, 1 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE) || !WT.isOn())
				return
			buckled_mob.visible_message(SPAN_NOTICE("\The [user] pulls \the [buckled_mob] free from \the [src]!"), SPAN_NOTICE("\The [user] pulls you free from \the [src]."), SPAN_NOTICE("You hear squelching."))
			playsound(loc, "alien_resin_move", 50)
			if(ishuman(buckled_mob))
				var/mob/living/carbon/human/H = buckled_mob
				user.attack_log += "\[[time_stamp()]\]<font color='orange'> Unnested [key_name(H)] at [get_location_in_text(H)]</font>"
				H.attack_log += "\[[time_stamp()]\]<font color='orange'> Unnested by [key_name(user)] at [get_location_in_text(H)]</font>"
			unbuckle()
			return
		if(is_sharp(W))
			user.visible_message(SPAN_NOTICE("\The [user] starts cutting through the resin binding \the [buckled_mob] in place..."), SPAN_NOTICE("You start cutting through the resin binding \the [buckled_mob] in place..."))
			if(!do_after(user, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
				return
			buckled_mob.visible_message(SPAN_NOTICE("\The [user] pulls \the [buckled_mob] free from \the [src]!"), SPAN_NOTICE("\The [user] pulls you free from \the [src]."), SPAN_NOTICE("You hear squelching."))
			playsound(loc, "alien_resin_move", 50)
			if(ishuman(buckled_mob))
				var/mob/living/carbon/human/H = buckled_mob
				user.attack_log += "\[[time_stamp()]\]<font color='orange'> Unnested [key_name(H)] at [get_location_in_text(H)]</font>"
				H.attack_log += "\[[time_stamp()]\]<font color='orange'> Unnested by [key_name(user)] at [get_location_in_text(H)]</font>"
			unbuckle()
			return
	health = max(0, health - W.force)
	playsound(loc, "alien_resin_break", 25)
	user.animation_attack_on(src)
	user.visible_message(SPAN_WARNING("\The [user] hits \the [src] with \the [W]!"), \
	SPAN_WARNING("You hit \the [src] with \the [W]!"))
	healthcheck()

/obj/structure/bed/nest/manual_unbuckle(mob/living/user)
	if(!(buckled_mob && buckled_mob.buckled == src && buckled_mob != user))
		return

	if(user.stat || user.lying || user.is_mob_restrained())
		return

	if(isXeno(user))
		var/mob/living/carbon/Xenomorph/X = user
		if(!X.hive.unnesting_allowed && !isXenoBuilder(X) && HIVE_ALLIED_TO_HIVE(X.hivenumber, hivenumber))
			to_chat(X, SPAN_XENOWARNING("You shouldn't interfere with the nest, leave that to the drones."))
			return
	else if(iscarbon(user))
		var/mob/living/carbon/H = user
		if(HIVE_ALLIED_TO_HIVE(H.hivenumber, hivenumber))
			to_chat(H, SPAN_XENOWARNING("You shouldn't interfere with the nest, leave that to the drones."))
			return

	if(ishuman(buckled_mob) && isXeno(user))
		var/mob/living/carbon/human/H = buckled_mob
		if(H.recently_nested)
			to_chat(user, SPAN_WARNING("[H] was nested recently. Wait a bit."))
			return
		if(H.stat != DEAD)
			if(alert(user, "[H] is still alive and kicking! Are you sure you want to remove them from the nest?", "Confirmation", "Yes", "No") == "No")
				return
			if(!buckled_mob || !user.Adjacent(H) || user.stat || user.lying || user.is_mob_restrained())
				return

	if(ishuman(user))
		user.visible_message(SPAN_NOTICE("\The [user] starts pulling \the [buckled_mob] free from the resin binding them in place..."), SPAN_NOTICE("You start pulling \the [buckled_mob] free from the resin binding them in place..."))
		if(!do_after(user, 8 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
			return
	buckled_mob.visible_message(SPAN_NOTICE("\The [user] pulls \the [buckled_mob] free from \the [src]!"),\
	SPAN_NOTICE("\The [user] pulls you free from \the [src]."),\
	SPAN_NOTICE("You hear squelching."))
	playsound(loc, "alien_resin_move", 50)
	if(ishuman(buckled_mob))
		var/mob/living/carbon/human/H = buckled_mob
		user.attack_log += "\[[time_stamp()]\]<font color='orange'> Unnested [key_name(H)] at [get_location_in_text(H)]</font>"
		H.attack_log += "\[[time_stamp()]\]<font color='orange'> Unnested by [key_name(user)] at [get_location_in_text(H)]</font>"
	unbuckle()
	return

/mob/living/carbon/human/proc/start_nesting_cooldown()
	recently_nested = TRUE
	addtimer(VARSET_CALLBACK(src, recently_nested, FALSE), 5 SECONDS)

/obj/structure/bed/nest/buckle_mob(mob/M as mob, mob/user as mob)
	if(!isliving(M) || isXenoLarva(user) || (get_dist(src, user) > 1) || (M.loc != loc) || user.is_mob_restrained() || user.stat || user.lying || M.buckled || !iscarbon(user))
		return

	if(isXeno(M))
		to_chat(user, SPAN_WARNING("You can't buckle your sisters."))
		return

	if(buckled_mob)
		to_chat(user, SPAN_WARNING("There's already someone in [src]."))
		return

	if(M.mob_size > MOB_SIZE_HUMAN)
		to_chat(user, SPAN_WARNING("\The [M] is too big to fit in [src]."))
		return

	if(!isXeno(user) || isSynth(M))
		to_chat(user, SPAN_WARNING("Gross! You're not touching that stuff."))
		return

	if(isYautja(M) && !force_nest)
		to_chat(user, SPAN_WARNING("\The [M] seems to be wearing some kind of resin-resistant armor!"))
		return

	if(M == user)
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.lying) //Don't ask me why is has to be
			to_chat(user, SPAN_WARNING("[M] is resisting, ground them."))
			return

	var/securing_time = 15
	// Don't increase the nesting time for monkeys and other species
	if(isHumanStrict(M))
		securing_time = 75

	user.visible_message(SPAN_WARNING("[user] pins [M] into [src], preparing the securing resin."),
	SPAN_WARNING("[user] pins [M] into [src], preparing the securing resin."))
	var/M_loc = M.loc
	if(!do_after(user, securing_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		return
	if(M.loc != M_loc)
		return

	if(buckled_mob) //Just in case
		to_chat(user, SPAN_WARNING("There's already someone in [src]."))
		return

	if(ishuman(M)) //Improperly stunned Marines won't be nested
		var/mob/living/carbon/human/H = M
		if(!H.lying) //Don't ask me why is has to be
			to_chat(user, SPAN_WARNING("[M] is resisting, ground them."))
			return

	do_buckle(M, user)
	ADD_TRAIT(M, TRAIT_NESTED, TRAIT_SOURCE_BUCKLE)

	if(!ishuman(M))
		return

	//Disabling motion detectors and other stuff they might be carrying
	var/mob/living/carbon/human/H = M
	H.start_nesting_cooldown()
	H.disable_special_flags()
	H.disable_lights()
	H.disable_special_items()

	if(H.mind)
		var/choice = alert(M, "You have no possibility of escaping unless freed by your fellow marines, do you wish to Ghost? If you are freed while ghosted, you will be given the choice to return to your body.", ,"Ghost", "Remain")
		if(choice == "Ghost")
			// Ask to ghostize() so they can reenter, to leave mind and such intact
			ghost_of_buckled_mob = M.ghostize(can_reenter_corpse = TRUE)
			ghost_of_buckled_mob?.can_reenter_corpse = FALSE // Just don't for now

/obj/structure/bed/nest/send_buckling_message(mob/M, mob/user)
	M.visible_message(SPAN_XENONOTICE("[user] secretes a thick, vile resin, securing [M] into [src]!"), \
	SPAN_XENONOTICE("[user] drenches you in a foul-smelling resin, trapping you in [src]!"), \
	SPAN_NOTICE("You hear squelching."))
	playsound(loc, "alien_resin_move", 50)

/obj/structure/bed/nest/afterbuckle(mob/M)
	. = ..()
	if(. && M.pulledby)
		M.pulledby.stop_pulling()
		resisting = 0 //just in case
		resisting_ready = 0
	update_icon()

/obj/structure/bed/nest/unbuckle(mob/user)
	if(!buckled_mob)
		return
	resisting = FALSE
	resisting_ready = FALSE
	buckled_mob.pixel_y = 0
	buckled_mob.old_y = 0
	REMOVE_TRAIT(buckled_mob, TRAIT_NESTED, TRAIT_SOURCE_BUCKLE)
	var/mob/living/carbon/human/H = buckled_mob

	. = ..()

	var/mob/dead/observer/G = ghost_of_buckled_mob
	var/datum/mind/M = G?.mind
	ghost_of_buckled_mob = null
	if(!istype(H) || !istype(G) || !istype(M) || H.undefibbable || H.mind || M.original != H || H.chestburst)
		return // Zealous checking as most is handled by ghost code
	to_chat(G, FONT_SIZE_HUGE(SPAN_DANGER("You have been freed from your nest and may go back to your body! (Look for 'Re-enter Corpse' in Ghost verbs, or <a href='?src=\ref[G];reentercorpse=1'>click here</a>!)")))
	sound_to(G, 'sound/effects/attackblob.ogg')
	if(H.client?.prefs.toggles_flashing & FLASH_UNNEST)
		window_flash(H.client)
	G.can_reenter_corpse = TRUE
	return

/obj/structure/bed/nest/ex_act(var/power)
	if(power >= EXPLOSION_THRESHOLD_VLOW)
		qdel(src)

/obj/structure/bed/nest/update_icon()
	overlays.Cut()
	if(on_fire)
		overlays += "alien_fire"
	if(buckled_mob)
		overlays += image("icon_state"="nest_overlay","layer"=LYING_LIVING_MOB_LAYER + 0.1)


/obj/structure/bed/nest/proc/healthcheck()
	if(health <= 0)
		density = 0
		qdel(src)

/obj/structure/bed/nest/fire_act()
	on_fire = TRUE
	if(on_fire)
		update_icon()
		QDEL_IN(src, rand(225, 400))


/obj/structure/bed/nest/attack_alien(mob/living/carbon/Xenomorph/M)
	if(isXenoLarva(M)) //Larvae can't do shit
		return
	if(M.a_intent == INTENT_HARM && !buckled_mob) //can't slash nest with an occupant.
		M.animation_attack_on(src)
		M.visible_message(SPAN_DANGER("\The [M] claws at \the [src]!"), \
		SPAN_DANGER("You claw at \the [src]."))
		playsound(loc, "alien_resin_break", 25)
		health -= (M.melee_damage_upper + 25) //Beef up the damage a bit
		healthcheck()
		return XENO_ATTACK_ACTION

	attack_hand(M)
	return XENO_NONCOMBAT_ACTION

/obj/structure/bed/nest/attack_animal(mob/living/M as mob)
	M.visible_message(SPAN_DANGER("\The [M] tears at \the [src]!"), \
		SPAN_DANGER("You tear at \the [src]."))
	playsound(loc, "alien_resin_break", 25)
	health -= 40
	healthcheck()

/obj/structure/bed/nest/flamer_fire_act()
	qdel(src)

/obj/structure/bed/nest/Destroy()
	unbuckle()
	ghost_of_buckled_mob = null
	return ..()

/obj/structure/bed/nest/structure
	name = "thick alien nest"
	desc = "A very thick nest, oozing with a thick sticky substance."
	layer = ABOVE_SPECIAL_RESIN_STRUCTURE_LAYER

	force_nest = TRUE
	var/obj/effect/alien/resin/special/nest/linked_structure

/obj/structure/bed/nest/structure/Initialize(mapload, hive, obj/effect/alien/resin/special/nest/to_link)
	. = ..()

	if(to_link)
		linked_structure = to_link
		health = linked_structure.health

/obj/structure/bed/nest/structure/Destroy()
	. = ..()
	if(linked_structure)
		linked_structure.pred_nest = null
		QDEL_NULL(linked_structure)

/obj/structure/bed/nest/structure/attack_hand(mob/user)
	if(!isXeno(user))
		to_chat(user, SPAN_NOTICE("The sticky resin is too strong for you to do anything to this nest"))
		return FALSE
	. = ..()
