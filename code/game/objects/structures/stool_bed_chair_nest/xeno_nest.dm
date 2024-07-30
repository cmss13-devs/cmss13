
//Alium nests. Essentially beds with an unbuckle delay that only aliums can buckle mobs to.
/obj/structure/bed/nest
	name = "alien nest"
	desc = "It's a gruesome pile of thick, sticky resin shaped like a nest."
	icon = 'icons/mob/xenos/effects.dmi'
	icon_state = "nest"
	buildstacktype = null //can't be disassembled and doesn't drop anything when destroyed
	unacidable = TRUE
	health = 100
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE
	buckle_lying = 0
	var/on_fire = 0
	var/resisting = 0
	var/resisting_ready = 0
	var/nest_resist_time = 1200
	var/mob/dead/observer/ghost_of_buckled_mob =  null
	var/hivenumber = XENO_HIVE_NORMAL
	var/force_nest = FALSE

/obj/structure/bed/nest/Initialize(mapload, hive)
	. = ..()

	if (hive)
		hivenumber = hive

	set_hive_data(src, hivenumber)

	buckling_y = list("[NORTH]" = 27, "[SOUTH]" = -19, "[EAST]" = 3, "[WEST]" = 3)
	buckling_x = list("[NORTH]" = 0, "[SOUTH]" = 0, "[EAST]" = 18, "[WEST]" = -17)

	spawn_check() //nests mapped in without hosts shouldn't persist

/obj/structure/bed/nest/proc/spawn_check(check_count = 0)
	if(!buckled_mob || !locate(/mob/living/carbon) in get_turf(src))
		if(check_count > 3)
			qdel(src)
		else
			check_count++
			addtimer(CALLBACK(src, PROC_REF(spawn_check), check_count), 10 SECONDS)

/obj/structure/bed/nest/afterbuckle(mob/current_mob)
	. = ..()
	if(. && current_mob.pulledby)
		current_mob.pulledby.stop_pulling()
		resisting = FALSE //just in case
		resisting_ready = FALSE

	if(buckled_mob == current_mob)
		current_mob.pixel_y = buckling_y["[dir]"]
		current_mob.pixel_x = buckling_x["[dir]"]
		current_mob.dir = turn(dir, 180)
		ADD_TRAIT(current_mob, TRAIT_UNDENSE, XENO_NEST_TRAIT)
		pixel_y = buckling_y["[dir]"]
		pixel_x = buckling_x["[dir]"]
		if(dir == SOUTH)
			buckled_mob.layer = ABOVE_TURF_LAYER
			if(ishuman(current_mob))
				var/mob/living/carbon/human/current_human = current_mob
				for(var/obj/limb/current_mobs_limb in current_human.limbs)
					current_mobs_limb.layer = TURF_LAYER
		update_icon()
		return

	current_mob.pixel_y = initial(buckled_mob.pixel_y)
	current_mob.pixel_x = initial(buckled_mob.pixel_x)
	REMOVE_TRAIT(current_mob, TRAIT_UNDENSE, XENO_NEST_TRAIT)
	if(dir == SOUTH)
		current_mob.layer = initial(current_mob.layer)
		if(!ishuman(current_mob))
			var/mob/living/carbon/human/current_human = current_mob
			for(var/obj/limb/current_mobs_limb in current_human.limbs)
				current_mobs_limb.layer =  initial(current_mobs_limb.layer)
	if(!QDESTROYING(src))
		qdel(src)

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
			to_chat(user, SPAN_XENOWARNING("We shouldn't interfere with the nest, leave that to the drones."))
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
			if(!buckled_mob)
				return
			buckled_mob.visible_message(SPAN_NOTICE("\The [user] pulls \the [buckled_mob] free from \the [src]!"), SPAN_NOTICE("\The [user] pulls you free from \the [src]."), SPAN_NOTICE("You hear squelching."))
			playsound(loc, "alien_resin_move", 50)
			if(ishuman(buckled_mob))
				var/mob/living/carbon/human/H = buckled_mob
				log_interact(user, H, "[key_name(user)] unnested [key_name(H)] at [get_area_name(loc)]")
			unbuckle()
			return
		if(is_sharp(W))
			user.visible_message(SPAN_NOTICE("\The [user] starts cutting through the resin binding \the [buckled_mob] in place..."), SPAN_NOTICE("You start cutting through the resin binding \the [buckled_mob] in place..."))
			if(!do_after(user, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
				return
			if(!buckled_mob)
				return
			buckled_mob.visible_message(SPAN_NOTICE("\The [user] pulls \the [buckled_mob] free from \the [src]!"), SPAN_NOTICE("\The [user] pulls you free from \the [src]."), SPAN_NOTICE("You hear squelching."))
			playsound(loc, "alien_resin_move", 50)
			if(ishuman(buckled_mob))
				var/mob/living/carbon/human/H = buckled_mob
				log_interact(user, H, "[key_name(user)] unnested [key_name(H)] at [get_area_name(loc)]")
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

	if(user.body_position == LYING_DOWN || user.is_mob_incapacitated())
		return

	if(isxeno(user))
		var/mob/living/carbon/xenomorph/X = user
		if(!X.hive.unnesting_allowed && !isxeno_builder(X) && HIVE_ALLIED_TO_HIVE(X.hivenumber, hivenumber))
			to_chat(X, SPAN_XENOWARNING("We shouldn't interfere with the nest, leave that to the drones."))
			return
	else if(iscarbon(user))
		var/mob/living/carbon/H = user
		if(HIVE_ALLIED_TO_HIVE(H.hivenumber, hivenumber))
			to_chat(H, SPAN_XENOWARNING("We shouldn't interfere with the nest, leave that to the drones."))
			return

	if(ishuman(buckled_mob) && isxeno(user))
		var/mob/living/carbon/human/H = buckled_mob
		if(H.recently_nested)
			to_chat(user, SPAN_WARNING("[H] was nested recently. Wait a bit."))
			return
		if(H.stat != DEAD)
			if(alert(user, "[H] is still alive and kicking! Are we sure we want to remove them from the nest?", "Confirmation", "Yes", "No") != "Yes")
				return
			if(!buckled_mob || !user.Adjacent(H) || user.is_mob_incapacitated(FALSE))
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
		if(isxeno(user))
			msg_admin_niche("[key_name(user)] unnested [key_name(H)] at [get_location_in_text(H)] [ADMIN_JMP(loc)]")
		log_interact(user, H, "[key_name(user)] unnested [key_name(H)] at [get_area_name(loc)]")
	unbuckle()
	return

/mob/living/carbon/human/proc/start_nesting_cooldown()
	recently_nested = TRUE
	addtimer(VARSET_CALLBACK(src, recently_nested, FALSE), 5 SECONDS)

/obj/structure/bed/nest/buckle_mob(mob/mob, mob/user)
	. = FALSE
	if(!isliving(mob) || islarva(user) || (get_dist(src, user) > 1) || user.is_mob_incapacitated(FALSE))
		return

	if(isxeno(mob))
		to_chat(user, SPAN_WARNING("We can't buckle our sisters."))
		return

	if(buckled_mob)
		to_chat(user, SPAN_WARNING("There's already someone in [src]."))
		return

	if(mob.mob_size > MOB_SIZE_HUMAN)
		to_chat(user, SPAN_WARNING("\The [mob] is too big to fit in [src]."))
		return

	if(!isxeno(user) || issynth(mob))
		to_chat(user, SPAN_WARNING("Gross! We're not touching that stuff."))
		return

	if(isyautja(mob) && !force_nest)
		to_chat(user, SPAN_WARNING("\The [mob] seems to be wearing some kind of resin-resistant armor!"))
		return

	if(mob == user)
		return

	var/mob/living/carbon/human/human = null
	if(ishuman(mob))
		human = mob
		if(human.body_position != LYING_DOWN) //Don't ask me why is has to be
			to_chat(user, SPAN_WARNING("[mob] is resisting, ground them."))
			return

	var/securing_time = 15
	// Don't increase the nesting time for monkeys and other species
	if(ishuman_strict(mob))
		securing_time = 75

	user.visible_message(SPAN_WARNING("[user] pins [mob] into [src], preparing the securing resin."),
	SPAN_WARNING("[user] pins [mob] into [src], preparing the securing resin."))
	var/M_loc = mob.loc
	if(!do_after(user, securing_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		return
	if(mob.loc != M_loc)
		return

	if(buckled_mob) //Just in case
		to_chat(user, SPAN_WARNING("There's already someone in [src]."))
		return

	if(human) //Improperly stunned Marines won't be nested
		if(human.body_position != LYING_DOWN) //Don't ask me why is has to be
			to_chat(user, SPAN_WARNING("[mob] is resisting, ground them."))
			return

	do_buckle(mob, user)
	ADD_TRAIT(mob, TRAIT_NESTED, TRAIT_SOURCE_BUCKLE)
	ADD_TRAIT(mob, TRAIT_NO_STRAY, TRAIT_SOURCE_BUCKLE)
	SEND_SIGNAL(mob, COMSIG_MOB_NESTED, user)

	if(!human)
		return TRUE

	//Disabling motion detectors and other stuff they might be carrying
	human.start_nesting_cooldown()
	human.disable_special_flags()
	human.disable_lights()
	human.disable_special_items()

	if(human.client)
		human.do_ghost()

	return TRUE

/obj/structure/bed/nest/send_buckling_message(mob/M, mob/user)
	M.visible_message(SPAN_XENONOTICE("[user] secretes a thick, vile resin, securing [M] into [src]!"), \
	SPAN_XENONOTICE("[user] drenches you in a foul-smelling resin, trapping you in [src]!"), \
	SPAN_NOTICE("You hear squelching."))
	playsound(loc, "alien_resin_move", 50)

/obj/structure/bed/nest/unbuckle(mob/user)
	if(!buckled_mob)
		return
	resisting = FALSE
	resisting_ready = FALSE
	buckled_mob.pixel_y = 0
	buckled_mob.old_y = 0
	REMOVE_TRAIT(buckled_mob, TRAIT_NESTED, TRAIT_SOURCE_BUCKLE)
	REMOVE_TRAIT(buckled_mob, TRAIT_NO_STRAY, TRAIT_SOURCE_BUCKLE)
	var/mob/living/carbon/human/buckled_human = buckled_mob

	var/mob/dead/observer/G = ghost_of_buckled_mob
	var/datum/mind/M = G?.mind
	ghost_of_buckled_mob = null

	. = ..() //Very important that this comes after, since it deletes the nest and clears ghost_of_buckled_mob

	if(!istype(buckled_human) || !istype(G) || !istype(M) || buckled_human.undefibbable || buckled_human.mind || M.original != buckled_human || buckled_human.chestburst)
		return // Zealous checking as most is handled by ghost code
	to_chat(G, FONT_SIZE_HUGE(SPAN_DANGER("You have been freed from your nest and may go back to your body! (Look for 'Re-enter Corpse' in Ghost verbs, or <a href='?src=\ref[G];reentercorpse=1'>click here</a>!)")))
	sound_to(G, 'sound/effects/attackblob.ogg')
	if(buckled_human.client?.prefs.toggles_flashing & FLASH_UNNEST)
		window_flash(buckled_human.client)
	G.can_reenter_corpse = TRUE

/obj/structure/bed/nest/ex_act(power)
	if(power >= EXPLOSION_THRESHOLD_VLOW)
		deconstruct(FALSE)

/obj/structure/bed/nest/update_icon()
	overlays.Cut()
	if(on_fire)
		overlays += "alien_fire"
	if(buckled_mob)
		overlays += image(icon_state = "nest_overlay", dir = buckled_mob.dir, layer = ABOVE_MOB_LAYER, pixel_y = 1)

/obj/structure/bed/nest/proc/healthcheck()
	if(health <= 0)
		deconstruct()

/obj/structure/bed/nest/fire_act()
	on_fire = TRUE
	if(on_fire)
		update_icon()
		QDEL_IN(src, rand(225, 400))


/obj/structure/bed/nest/attack_alien(mob/living/carbon/xenomorph/M)
	if(islarva(M)) //Larvae can't do shit
		return
	if(M.a_intent == INTENT_HARM && !buckled_mob) //can't slash nest with an occupant.
		M.animation_attack_on(src)
		M.visible_message(SPAN_DANGER("\The [M] claws at \the [src]!"), \
		SPAN_DANGER("We claw at \the [src]."))
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
	deconstruct()

/obj/structure/bed/nest/Destroy()
	unbuckle()
	ghost_of_buckled_mob = null
	return ..()

/obj/structure/bed/nest/structure
	name = "thick alien nest"
	desc = "A very thick nest, oozing with a thick sticky substance."
	layer = ABOVE_SPECIAL_RESIN_STRUCTURE_LAYER
	icon_state = "pred_nest"
	force_nest = TRUE
	var/obj/effect/alien/resin/special/nest/linked_structure

/obj/structure/bed/nest/structure/Initialize(mapload, hive, obj/effect/alien/resin/special/nest/to_link)
	. = ..()
	buckling_y = list("[NORTH]" = -19, "[SOUTH]" = 27, "[EAST]" = 3, "[WEST]" = 3)
	buckling_x = list("[NORTH]" = 0, "[SOUTH]" = 0, "[EAST]" = -17, "[WEST]" = 18)

	if(to_link)
		linked_structure = to_link
		health = linked_structure.health

/obj/structure/bed/nest/structure/Destroy()
	. = ..()
	if(linked_structure)
		linked_structure.pred_nest = null
		QDEL_NULL(linked_structure)

/obj/structure/bed/nest/structure/attack_hand(mob/user)
	if(!isxeno(user))
		to_chat(user, SPAN_NOTICE("The sticky resin is too strong for you to do anything to this nest"))
		return FALSE
	. = ..()

/obj/structure/bed/nest/structure/afterbuckle(mob/current_mob)
	. = ..()
	switch(buckled_mob.dir)
		if(NORTH)
			buckled_mob.dir = SOUTH
		if(SOUTH)
			buckled_mob.dir = NORTH
		if(EAST)
			buckled_mob.dir = WEST
		if(WEST)
			buckled_mob.dir = EAST
