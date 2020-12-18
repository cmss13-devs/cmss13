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



/mob/living/carbon/Xenomorph/proc/build_resin(var/atom/A, var/thick = FALSE, var/message = TRUE)
	var/datum/resin_construction/RC = resin_build_order[selected_resin]

	var/total_resin_cost = XENO_RESIN_BASE_COST + RC.cost // Live, diet, shit code, repeat

	if(action_busy)
		return FALSE
	if(!check_state())
		return FALSE
	if(!check_plasma(total_resin_cost))
		return FALSE
	if(interior_manager && interior_manager.interior_z == z)
		to_chat(src, SPAN_XENOWARNING("It's too tight in here to build."))
		return FALSE

	var/turf/current_turf = get_turf(A)

	if(extra_build_dist != IGNORE_BUILD_DISTANCE && get_dist(src, A) > src.caste.max_build_dist + extra_build_dist) // Hivelords have max_build_dist of 1, drones and queens 0
		current_turf = get_turf(src)
	else if(thick) //hivelords can thicken existing resin structures.
		var/thickened = FALSE
		if(istype(A, /turf/closed/wall/resin))
			var/turf/closed/wall/resin/WR = A
			if (WR.hivenumber != hivenumber)
				to_chat(src, SPAN_XENOWARNING("[WR] doesn't belong to your hive!"))
				return FALSE

			if(WR.walltype == WALL_RESIN)
				WR.ChangeTurf(/turf/closed/wall/resin/thick)
			else if(WR.walltype == WALL_MEMBRANE)
				WR.ChangeTurf(/turf/closed/wall/resin/membrane/thick)
			else
				to_chat(src, SPAN_XENOWARNING("[WR] can't be made thicker."))
				return FALSE
			thickened = TRUE

		else if(istype(A, /obj/structure/mineral_door/resin))
			var/obj/structure/mineral_door/resin/DR = A
			if (DR.hivenumber != hivenumber)
				to_chat(src, SPAN_XENOWARNING("[DR] doesn't belong to your hive!"))
				return FALSE

			if(DR.hardness == 1.5) //non thickened
				var/oldloc = DR.loc
				qdel(DR)
				new /obj/structure/mineral_door/resin/thick (oldloc, DR.hivenumber)
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
	
	if (!RC.can_build_here(current_turf, src))
		return FALSE

	var/wait_time = RC.build_time * caste.build_time_mult

	var/obj/effect/alien/weeds/alien_weeds = locate() in current_turf
	alien_weeds.secreting = TRUE
	alien_weeds.update_icon()

	if(!do_after(src, wait_time, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, alien_weeds))
		alien_weeds.secreting = FALSE
		alien_weeds.update_icon()

		return FALSE

	alien_weeds.secreting = FALSE
	alien_weeds.update_icon()

	if (!RC.can_build_here(current_turf, src))
		return FALSE

	use_plasma(total_resin_cost)
	if(message)
		visible_message(SPAN_XENONOTICE("[src] regurgitates a thick substance and shapes it into \a [RC.construction_name]!"), \
			SPAN_XENONOTICE("You regurgitate some resin and shape it into \a [RC.construction_name], using a total [total_resin_cost] plasma."), null, 5)
		playsound(loc, "alien_resin_build", 25)

	var/atom/new_resin = RC.build(current_turf, hivenumber)

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