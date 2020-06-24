//Note: All the neurotoxin projectile items are stored in XenoProcs.dm
/mob/living/carbon/Xenomorph/proc/xeno_spit(atom/T)

	if(!check_state())
		return

	if(!isturf(loc))
		to_chat(src, SPAN_WARNING("You can't spit from here!"))
		return

	if(has_spat > world.time)
		to_chat(src, SPAN_WARNING("You must wait for your spit glands to refill."))
		return

	if(!check_plasma(ammo.spit_cost))
		return

	var/turf/current_turf = get_turf(src)

	if(!current_turf)
		return

	has_spat = world.time + caste.spit_delay + ammo.added_spit_delay
	use_plasma(ammo.spit_cost)
	cooldown_notification(caste.spit_delay + ammo.added_spit_delay, "spit")

	visible_message(SPAN_XENOWARNING("[src] spits at [T]!"), \
	SPAN_XENOWARNING("You spit at [T]!") )
	var/sound_to_play = pick(1, 2) == 1 ? 'sound/voice/alien_spitacid.ogg' : 'sound/voice/alien_spitacid2.ogg'
	playsound(src.loc, sound_to_play, 25, 1)

	var/obj/item/projectile/A = new /obj/item/projectile(initial(caste_name), src, current_turf)
	A.generate_bullet(ammo)
	A.permutated += src
	A.def_zone = get_limbzone_target()
	A.fire_at(T, src, src, ammo.max_range, ammo.shell_speed)

	return TRUE

/mob/living/carbon/Xenomorph/proc/cooldown_notification(cooldown, message)
	set waitfor = FALSE
	sleep(cooldown)
	switch(message)
		if("spit")
			to_chat(src, SPAN_NOTICE("You feel your neurotoxin glands swell with ichor. You can spit again."))
	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()



/mob/living/carbon/Xenomorph/proc/build_resin(atom/A, thick=FALSE, message=TRUE)

	var/base_resin_cost = 50
	var/additional_resin_cost = 0
	var/total_resin_cost = 0

	var/resin_to_build = selected_resin

	switch(resin_to_build)
		if(RESIN_DOOR)
			if(thick)
				additional_resin_cost = 125
			else
				additional_resin_cost = 100//total 150 & 175 thick
		if(RESIN_WALL)
			if(thick)
				additional_resin_cost = 150
			else
				additional_resin_cost = 100//total 150 & 200 thick
		if(RESIN_MEMBRANE)
			if(thick)
				additional_resin_cost = 100
			else
				additional_resin_cost = 75//total cost 125 & 150 thick
		if(RESIN_NEST)
			additional_resin_cost = 75//total 125
		if(RESIN_STICKY)
			additional_resin_cost = 35//total 85
		if(RESIN_FAST)
			additional_resin_cost = 15//total 65

	total_resin_cost = base_resin_cost + additional_resin_cost//live, diet, shit code, repeat

	if(action_busy)
		return FALSE
	if(!check_state())
		return FALSE
	if(!check_plasma(total_resin_cost))
		return FALSE

	var/turf/current_turf = get_turf(A)

	// Xeno ressource collection
	/*var/obj/structure/resource_node/plasma/target_node = locate() in current_turf
	if(target_node && get_dist(src, current_turf) <= max(1, src.caste.max_build_dist)) // Building resource collectors
		var/obj/effect/alien/resin/collector/alien_blocker = locate() in current_turf
		var/obj/structure/machinery/collector/marine_blocker = locate() in current_turf
		if(alien_blocker || marine_blocker)
			to_chat(src, SPAN_WARNING("There is already another collector here!"))
			return FALSE
		if(!target_node.growth_level)
			to_chat(src, SPAN_WARNING("This resource is not ready yet!"))
			return FALSE
		resin_to_build = RESIN_COLLECTOR */
	if(get_dist(src, A) > src.caste.max_build_dist + extra_build_dist) // Hivelords have max_build_dist of 1, drones and queens 0
		current_turf = get_turf(src)
	else if(thick) //hivelords can thicken existing resin structures.
		var/thickened = FALSE
		if(istype(A, /turf/closed/wall/resin))
			var/turf/closed/wall/resin/WR = A
			if(WR.walltype == WALL_RESIN)
				var/prev_old_turf = WR.old_turf
				WR.ChangeTurf(/turf/closed/wall/resin/thick)
				WR.old_turf = prev_old_turf
			else if(WR.walltype == WALL_MEMBRANE)
				var/prev_old_turf = WR.old_turf
				WR.ChangeTurf(/turf/closed/wall/resin/membrane/thick)
				WR.old_turf = prev_old_turf
			else
				to_chat(src, SPAN_XENOWARNING("[WR] can't be made thicker."))
				return FALSE
			thickened = TRUE

		else if(istype(A, /obj/structure/mineral_door/resin))
			var/obj/structure/mineral_door/resin/DR = A
			if(DR.hardness == 1.5) //non thickened
				var/oldloc = DR.loc
				qdel(DR)
				new /obj/structure/mineral_door/resin/thick (oldloc)
			else
				to_chat(src, SPAN_XENOWARNING("[DR] can't be made thicker."))
				return FALSE
			thickened = TRUE

		if(thickened)
			if(message)
				visible_message(SPAN_XENONOTICE("[src] regurgitates a thick substance and thickens [A]."), \
					SPAN_XENONOTICE("You regurgitate some resin and thicken [A], using [total_resin_cost] plasma"), null, 5)
				use_plasma(total_resin_cost)
				playsound(loc, "alien_resin_build", 25)
			A.add_hiddenprint(src) //so admins know who thickened the walls
			return TRUE

	var/mob/living/carbon/Xenomorph/blocker = locate() in current_turf
	if(blocker && blocker != src && blocker.stat != DEAD)
		to_chat(src, SPAN_WARNING("Can't do that with [blocker] in the way!"))
		return FALSE

	if(!istype(current_turf) || !current_turf.is_weedable())
		to_chat(src, SPAN_WARNING("You can't do that here."))
		return FALSE

	var/area/AR = get_area(current_turf)
	if(istype(AR,/area/shuttle/drop1/lz1) || istype(AR,/area/shuttle/drop2/lz2)) //Bandaid for atmospherics bug when Xenos build around the shuttles
		to_chat(src, SPAN_WARNING("You sense this is not a suitable area for expanding the hive."))
		return FALSE

	var/obj/effect/alien/weeds/alien_weeds = locate() in current_turf

	if(!alien_weeds)
		to_chat(src, SPAN_WARNING("You can only shape on weeds. Find some resin before you start building!"))
		return FALSE

	if(resin_to_build != RESIN_COLLECTOR && !check_alien_construction(current_turf))
		return FALSE

	if(resin_to_build == RESIN_DOOR)
		var/wall_support = FALSE
		for(var/D in cardinal)
			var/turf/T = get_step(current_turf,D)
			if(T)
				if(T.density)
					wall_support = TRUE
					break
				else if(locate(/obj/structure/mineral_door/resin) in T)
					wall_support = TRUE
					break
		if(!wall_support)
			to_chat(src, SPAN_WARNING("Resin doors need a wall or resin door next to them to stand up."))
			return FALSE

	if(resin_to_build == RESIN_NEST)
		if(!(alien_weeds.weed_strength >= WEED_LEVEL_HIVE))
			to_chat(src, SPAN_WARNING("These weeds are not strong enough to hold the nest."))
			return

	var/wait_time = caste.build_time

	alien_weeds.secreting = TRUE
	alien_weeds.update_icon()

	if(!do_after(src, wait_time, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		alien_weeds.secreting = FALSE
		alien_weeds.update_icon()

		return FALSE

	alien_weeds.secreting = FALSE
	alien_weeds.update_icon()

	blocker = locate() in current_turf
	if(blocker && blocker != src && blocker.stat != DEAD)
		return FALSE

	if(!check_state())
		return FALSE
	if(!check_plasma(total_resin_cost))
		return FALSE

	if(!istype(current_turf) || !current_turf.is_weedable())
		return FALSE

	AR = get_area(current_turf)
	if(istype(AR,/area/shuttle/drop1/lz1 || istype(AR,/area/shuttle/drop2/lz2))) //Bandaid for atmospherics bug when Xenos build around the shuttles
		return FALSE

	alien_weeds = locate() in current_turf
	if(!alien_weeds)
		return FALSE

	if(resin_to_build != RESIN_COLLECTOR && !check_alien_construction(current_turf))
		return FALSE

	if(resin_to_build == RESIN_DOOR)
		var/wall_support = FALSE
		for(var/D in cardinal)
			var/turf/T = get_step(current_turf,D)
			if(T)
				if(T.density)
					wall_support = TRUE
					break
				else if(locate(/obj/structure/mineral_door/resin) in T)
					wall_support = TRUE
					break
		if(!wall_support)
			to_chat(src, SPAN_WARNING("Resin doors need a wall or resin door next to them to stand up."))
			return FALSE

	use_plasma(total_resin_cost)
	if(message)
		visible_message(SPAN_XENONOTICE("[src] regurgitates a thick substance and shapes it into \a [resin2text(resin_to_build, thick)]!"), \
			SPAN_XENONOTICE("You regurgitate some resin and shape it into \a [resin2text(resin_to_build, thick)], using a total [total_resin_cost] plasma."), null, 5)
		playsound(loc, "alien_resin_build", 25)

	var/atom/new_resin

	switch(resin_to_build)
		if(RESIN_DOOR)
			if(thick)
				new_resin = new /obj/structure/mineral_door/resin/thick(current_turf)
			else
				new_resin = new /obj/structure/mineral_door/resin(current_turf)
		if(RESIN_WALL)
			if(thick)
				current_turf.ChangeTurf(/turf/closed/wall/resin/thick)
			else
				current_turf.ChangeTurf(/turf/closed/wall/resin)
			new_resin = current_turf
		if(RESIN_MEMBRANE)
			if(thick)
				current_turf.ChangeTurf(/turf/closed/wall/resin/membrane/thick)
			else
				current_turf.ChangeTurf(/turf/closed/wall/resin/membrane)
			new_resin = current_turf
		if(RESIN_NEST)
			new_resin = new /obj/structure/bed/nest(current_turf)
		if(RESIN_STICKY)
			new_resin = new /obj/effect/alien/resin/sticky(current_turf)
		if(RESIN_FAST)
			new_resin = new /obj/effect/alien/resin/sticky/fast(current_turf)
		// Xeno ressource collection
		/*if(RESIN_COLLECTOR)
			new_resin = new /obj/effect/alien/resin/collector(current_turf, hive, target_node)*/

	new_resin.add_hiddenprint(src) //so admins know who placed it
	return TRUE

/mob/living/carbon/Xenomorph/proc/place_construction(var/turf/current_turf, var/datum/construction_template/xenomorph/structure_template)
	if(!structure_template || !check_state() || action_busy)
		return

	var/area/current_area = get_area(current_turf)
	var/obj/effect/alien/resin/construction/new_structure = new(current_turf, hive)
	new_structure.set_template(structure_template)
	hive.add_construction(new_structure)

	visible_message(SPAN_XENONOTICE("A thick substance emerges from the ground and shapes into \a [new_structure]."), \
		SPAN_XENONOTICE("You designate a new [structure_template] construction."), null, 5)
	playsound(new_structure, "alien_resin_build", 25)

	if(hive.living_xeno_queen)
		xeno_message("Hive: A new <b>[structure_template]<b> construction has been designated at [sanitize(current_area)]!", 3, hivenumber)
