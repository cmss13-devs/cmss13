/mob/living/carbon/Xenomorph/proc/build_resin(var/atom/A, var/thick = FALSE, var/message = TRUE, var/use_plasma = TRUE, var/add_build_mod = 1)
	if(!selected_resin)
		return SECRETE_RESIN_FAIL

	var/datum/resin_construction/RC = GLOB.resin_constructions_list[selected_resin]

	var/total_resin_cost = XENO_RESIN_BASE_COST + RC.cost // Live, diet, shit code, repeat

	if(action_busy && !can_stack_builds)
		return SECRETE_RESIN_FAIL
	if(!check_state())
		return SECRETE_RESIN_FAIL
	if(use_plasma && !check_plasma(total_resin_cost))
		return SECRETE_RESIN_FAIL
	if(GLOB.interior_manager.interior_z == z)
		to_chat(src, SPAN_XENOWARNING("It's too tight in here to build."))
		return SECRETE_RESIN_FAIL

	if(RC.max_per_xeno != RESIN_CONSTRUCTION_NO_MAX)
		var/current_amount = length(built_structures[RC.build_path])
		if(current_amount >= RC.max_per_xeno)
			to_chat(src, SPAN_XENOWARNING("You've already built the maximum possible structures you can!"))
			return SECRETE_RESIN_FAIL

	var/turf/current_turf = get_turf(A)

	if(extra_build_dist != IGNORE_BUILD_DISTANCE && get_dist(src, A) > src.caste.max_build_dist + extra_build_dist) // Hivelords and eggsac carriers have max_build_dist of 1, drones and queens 0
		to_chat(src, SPAN_XENOWARNING("You can't build from that far!"))
		return SECRETE_RESIN_FAIL
	else if(thick) //hivelords can thicken existing resin structures.
		var/thickened = FALSE
		if(istype(A, /turf/closed/wall/resin))
			var/turf/closed/wall/resin/WR = A

			if(istype(A, /turf/closed/wall/resin/weak))
				to_chat(src, SPAN_XENOWARNING("[WR] is too flimsy to be reinforced."))
				return SECRETE_RESIN_FAIL

			for(var/datum/effects/xeno_structure_reinforcement/sf in WR.effects_list)
				to_chat(src, SPAN_XENOWARNING("The extra resin is preventing you from reinforcing [WR]. Wait until it elapse."))
				return SECRETE_RESIN_FAIL

			if (WR.hivenumber != hivenumber)
				to_chat(src, SPAN_XENOWARNING("[WR] doesn't belong to your hive!"))
				return SECRETE_RESIN_FAIL

			if(WR.type == /turf/closed/wall/resin)
				WR.ChangeTurf(/turf/closed/wall/resin/thick)
				total_resin_cost = XENO_THICKEN_WALL_COST
			else if(WR.type == /turf/closed/wall/resin/membrane)
				WR.ChangeTurf(/turf/closed/wall/resin/membrane/thick)
				total_resin_cost = XENO_THICKEN_MEMBRANE_COST
			else
				to_chat(src, SPAN_XENOWARNING("[WR] can't be made thicker."))
				return SECRETE_RESIN_FAIL
			thickened = TRUE

		else if(istype(A, /obj/structure/mineral_door/resin))
			var/obj/structure/mineral_door/resin/DR = A
			if (DR.hivenumber != hivenumber)
				to_chat(src, SPAN_XENOWARNING("[DR] doesn't belong to your hive!"))
				return SECRETE_RESIN_FAIL

			for(var/datum/effects/xeno_structure_reinforcement/sf in DR.effects_list)
				to_chat(src, SPAN_XENOWARNING("The extra resin is preventing you from reinforcing [DR]. Wait until it elapse."))
				return SECRETE_RESIN_FAIL

			if(DR.hardness == 1.5) //non thickened
				var/oldloc = DR.loc
				qdel(DR)
				new /obj/structure/mineral_door/resin/thick (oldloc, DR.hivenumber)
				total_resin_cost = XENO_THICKEN_DOOR_COST
			else
				to_chat(src, SPAN_XENOWARNING("[DR] can't be made thicker."))
				return SECRETE_RESIN_FAIL
			thickened = TRUE

		if(thickened)
			if(message)
				visible_message(SPAN_XENONOTICE("[src] regurgitates a thick substance and thickens [A]."), \
					SPAN_XENONOTICE("You regurgitate some resin and thicken [A], using [total_resin_cost] plasma."), null, 5)
				if(use_plasma)
					use_plasma(total_resin_cost)
				playsound(loc, "alien_resin_build", 25)
			A.add_hiddenprint(src) //so admins know who thickened the walls
			return TRUE

	if (!RC.can_build_here(current_turf, src))
		return SECRETE_RESIN_FAIL

	var/wait_time = RC.build_time * caste.build_time_mult * add_build_mod

	var/obj/effect/alien/weeds/alien_weeds = current_turf.weeds
	if(!alien_weeds)
		return

	var/obj/warning
	var/succeeded = TRUE
	if(RC.build_overlay_icon)
		warning = new RC.build_overlay_icon(current_turf)

	alien_weeds.secreting = TRUE
	alien_weeds.update_icon()

	if(!do_after(src, wait_time, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, alien_weeds))
		succeeded = FALSE

	qdel(warning)

	if(!QDELETED(alien_weeds))
		alien_weeds.secreting = FALSE
		alien_weeds.update_icon()

	if(!succeeded)
		return SECRETE_RESIN_INTERRUPT

	if (!RC.can_build_here(current_turf, src))
		return SECRETE_RESIN_FAIL

	if(use_plasma)
		use_plasma(total_resin_cost)
	if(message)
		visible_message(SPAN_XENONOTICE("[src] regurgitates a thick substance and shapes it into \a [RC.construction_name]!"), \
			SPAN_XENONOTICE("You regurgitate some resin and shape it into \a [RC.construction_name][use_plasma ? " at the cost of a total [total_resin_cost] plasma" : ""]."), null, 5)
		playsound(loc, "alien_resin_build", 25)

	var/atom/new_resin = RC.build(current_turf, hivenumber, src)
	if(RC.max_per_xeno != RESIN_CONSTRUCTION_NO_MAX)
		LAZYADD(built_structures[RC.build_path], new_resin)
		RegisterSignal(new_resin, COMSIG_PARENT_QDELETING, .proc/remove_built_structure)

	new_resin.add_hiddenprint(src) //so admins know who placed it
	return SECRETE_RESIN_SUCCESS

/mob/living/carbon/Xenomorph/proc/remove_built_structure(var/atom/A)
	SIGNAL_HANDLER
	LAZYREMOVE(built_structures[A.type], A)
	if(!built_structures[A.type])
		built_structures -= A.type

/mob/living/carbon/Xenomorph/proc/place_construction(var/turf/current_turf, var/datum/construction_template/xenomorph/structure_template)
	if(!structure_template || !check_state() || action_busy)
		return

	var/current_area_name = get_area_name(current_turf)
	var/obj/effect/alien/resin/construction/new_structure = new(current_turf, hive)
	new_structure.set_template(structure_template)
	hive.add_construction(new_structure)

	visible_message(SPAN_XENONOTICE("A thick substance emerges from the ground and shapes into \a [new_structure]."), \
		SPAN_XENONOTICE("You designate a new [structure_template] construction."), null, 5)
	playsound(new_structure, "alien_resin_build", 25)

	if(hive.living_xeno_queen)
		xeno_message("Hive: A new <b>[structure_template]<b> construction has been designated at [sanitize(current_area_name)]!", 3, hivenumber)
