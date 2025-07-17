#define RESIN_CONSTRUCT 1
#define RESIN_DOOR 2
#define RESIN_WALL 3
#define RESIN_WALL_MEMBRANE 4
#define RESIN_FAST 5
#define RESIN_STICKY 6
#define RESIN_SPIKE 7
#define RESIN_ACIDPILLAR 8
#define RESIN_RECOVERY 9
#define RESIN_CLUSTER 10
#define RESIN_CORE 11
#define RESIN_PYLON 12
#define RESIN_EGGMORPH 13
#define RESIN_TRAP 14

/mob/living/carbon/xenomorph/proc/build_resin(atom/target, thick = FALSE, message = TRUE, use_plasma = TRUE, add_build_mod = 1)
	if(!selected_resin)
		return SECRETE_RESIN_FAIL

	var/datum/resin_construction/resin_construct = GLOB.resin_constructions_list[selected_resin]

	var/total_resin_cost = XENO_RESIN_BASE_COST + resin_construct.cost // Live, diet, shit code, repeat

	if(resin_construct.scaling_cost && use_plasma)
		var/area/target_area = get_area(target)
		if(target_area && target_area.openable_turf_count)
			var/density_ratio = target_area.current_resin_count / target_area.openable_turf_count
			if(density_ratio > 0.4)
				total_resin_cost = ceil(total_resin_cost * (density_ratio + 0.35) * 2)
				if(total_resin_cost > plasma_max && (XENO_RESIN_BASE_COST + resin_construct.cost) < plasma_max)
					total_resin_cost = plasma_max

	if(action_busy && !can_stack_builds)
		return SECRETE_RESIN_FAIL
	if(!check_state())
		return SECRETE_RESIN_FAIL
	if(use_plasma && !check_plasma(total_resin_cost))
		return SECRETE_RESIN_FAIL
	if(SSinterior.in_interior(src))
		to_chat(src, SPAN_XENOWARNING("It's too tight in here to build."))
		return SECRETE_RESIN_FAIL

	if(resin_construct.max_per_xeno != RESIN_CONSTRUCTION_NO_MAX)
		var/current_amount = length(built_structures[resin_construct.build_path])
		if(current_amount >= resin_construct.max_per_xeno)
			to_chat(src, SPAN_XENOWARNING("We've already built the maximum possible structures we can!"))
			return SECRETE_RESIN_FAIL

	var/turf/current_turf = get_turf(target)
	var/can_deconstruct = TRUE

	var/structure_kind = NONE
	if(istype(target, /obj/effect/alien/resin/construction))
		structure_kind = RESIN_CONSTRUCT
	else if(istype(target, /turf/closed/wall/resin/membrane)) // We must check this one before /turf/closed/wall/resin
		structure_kind = RESIN_WALL_MEMBRANE
	else if(istype(target, /turf/closed/wall/resin))
		structure_kind = RESIN_WALL
	else if(istype(target, /obj/structure/mineral_door/resin))
		structure_kind = RESIN_DOOR
	else if(istype(target, /obj/effect/alien/resin/sticky/fast))
		structure_kind = RESIN_FAST
	else if(istype(target, /obj/effect/alien/resin/sticky))
		structure_kind = RESIN_STICKY
	else if(istype(target, /obj/effect/alien/resin/spike))
		structure_kind = RESIN_SPIKE
	else if(istype(target, /obj/effect/alien/resin/acid_pillar))
		structure_kind = RESIN_ACIDPILLAR
	else if(istype(target, /obj/effect/alien/resin/special/recovery))
		structure_kind = RESIN_RECOVERY
	else if(istype(target, /obj/effect/alien/resin/special/cluster))
		structure_kind = RESIN_CLUSTER
	else if(istype(target, /obj/effect/alien/resin/special/pylon/core))
		structure_kind = RESIN_CORE
	else if(istype(target, /obj/effect/alien/resin/special/pylon))
		structure_kind = RESIN_PYLON
	else if(istype(target, /obj/effect/alien/resin/special/eggmorph))
		structure_kind = RESIN_EGGMORPH
	else if(istype(target, /obj/effect/alien/resin/trap))
		structure_kind = RESIN_TRAP

	if(extra_build_dist != IGNORE_BUILD_DISTANCE && get_dist(src, target) > caste.max_build_dist + extra_build_dist) // Hivelords and eggsac carriers have max_build_dist of 1, drones and queens 0
		to_chat(src, SPAN_XENOWARNING("We can't build from that far!"))
		return SECRETE_RESIN_FAIL

	if(thick) //hivelords can thicken existing resin structures.
		var/thickened = FALSE
		if(istype(target, /turf/closed/wall/resin))
			var/turf/closed/wall/resin/wall = target

			if(istype(target, /turf/closed/wall/resin/weak))
				to_chat(src, SPAN_XENOWARNING("[wall] is too flimsy to be reinforced."))
				return SECRETE_RESIN_FAIL

			for(var/datum/effects/xeno_structure_reinforcement/sf in wall.effects_list)
				to_chat(src, SPAN_XENOWARNING("The extra resin is preventing us from reinforcing [wall]. Wait until it elapse."))
				return SECRETE_RESIN_FAIL

			if(wall.hivenumber != hivenumber)
				to_chat(src, SPAN_XENOWARNING("[wall] doesn't belong to your hive!"))
				return SECRETE_RESIN_FAIL

			if(wall.type == /turf/closed/wall/resin)
				wall.ChangeTurf(/turf/closed/wall/resin/thick)
				total_resin_cost = XENO_THICKEN_WALL_COST
				thickened = TRUE
				can_deconstruct = FALSE
			else if(wall.type == /turf/closed/wall/resin/membrane)
				wall.ChangeTurf(/turf/closed/wall/resin/membrane/thick)
				total_resin_cost = XENO_THICKEN_MEMBRANE_COST
				thickened = TRUE
				can_deconstruct = FALSE
			else if(!can_deconstruct)
				to_chat(src, SPAN_XENOWARNING("[wall] can't be made thicker."))
				return SECRETE_RESIN_FAIL

		else if(istype(target, /obj/structure/mineral_door/resin))
			var/obj/structure/mineral_door/resin/door = target
			if(door.hivenumber != hivenumber)
				to_chat(src, SPAN_XENOWARNING("[door] doesn't belong to your hive!"))
				return SECRETE_RESIN_FAIL

			for(var/datum/effects/xeno_structure_reinforcement/sf in door.effects_list)
				to_chat(src, SPAN_XENOWARNING("The extra resin is preventing us from reinforcing [door]. Wait until it elapse."))
				return SECRETE_RESIN_FAIL

			if(door.hardness == 1.5) //non thickened
				var/oldloc = door.loc
				qdel(door)
				new /obj/structure/mineral_door/resin/thick (oldloc, door.hivenumber)
				total_resin_cost = XENO_THICKEN_DOOR_COST
				thickened = TRUE
				can_deconstruct = FALSE
			else if(!can_deconstruct)
				to_chat(src, SPAN_XENOWARNING("[door] can't be made thicker."))
				return SECRETE_RESIN_FAIL

		if(thickened)
			if(message)
				visible_message(SPAN_XENONOTICE("[src] regurgitates a thick substance and thickens [target]."),
					SPAN_XENONOTICE("We regurgitate some resin and thicken [target], using [total_resin_cost] plasma."), null, 5)
				if(use_plasma)
					use_plasma(total_resin_cost)
				playsound(loc, "alien_resin_build", 25)
			target.add_hiddenprint(src) //so admins know who thickened the walls
			return TRUE

	// Only those able to build at range can do extra stuff at range, and only not when adjacent to the target
	if(structure_kind && !Adjacent(target) && (extra_build_dist == IGNORE_BUILD_DISTANCE || caste.max_build_dist + extra_build_dist > 1))
		for(var/datum/effects/xeno_structure_reinforcement/sf in target.effects_list)
			to_chat(src, SPAN_XENOWARNING("The extra resin makes it difficult to deconstruct [target]. We should wait for it to wear off."))
			return SECRETE_RESIN_FAIL

		switch(structure_kind)
			if(RESIN_CONSTRUCT)
				var/obj/effect/alien/resin/construction/construct_target = target
				if(hivenumber != construct_target.linked_hive.hivenumber)
					return SECRETE_RESIN_FAIL

				if(a_intent == INTENT_HARM && can_deconstruct)

					if(!deconstruct_windup(target, 2 SECONDS)) // A bit unnecessary, but anti-grief crossed my mind
						return SECRETE_RESIN_FAIL

					construct_target.visible_message(SPAN_XENONOTICE("[construct_target] shudders and withdraws back into the weeds!"))
					playsound(target.loc, "alien_resin_break", 25)
					construct_target.health -= initial(construct_target.health) * 2
					construct_target.healthcheck()
				else
					construct_target.template.add_crystal(src)
				return TRUE

			// In practice, Membrane and Wall are treated as the same, but future modularity is good, so they are identified as seperate things
			if(RESIN_WALL to RESIN_WALL_MEMBRANE)
				var/turf/closed/wall/resin/resin_wall = target
				if(!can_deconstruct)
					return SECRETE_RESIN_FAIL

				if(resin_wall.hivenumber != hivenumber)
					to_chat(src, SPAN_XENOWARNING("We cannot deconstruct what doesn't belong to our hive!"))
					return SECRETE_RESIN_FAIL

				if(istype(target, /turf/closed/wall/resin/weak))
					to_chat(src, SPAN_XENOWARNING("[resin_wall] is too weak to be worth deconstructing."))
					return SECRETE_RESIN_FAIL

				if(!deconstruct_windup(target))
					return SECRETE_RESIN_FAIL

				resin_wall.visible_message(SPAN_XENONOTICE("[resin_wall] crumbles!"))
				to_chat(src, SPAN_XENONOTICE("We deconstruct [resin_wall]!"))
				playsound(get_turf(target), "alien_resin_break", 25)
				resin_wall.dismantle_wall()
				return TRUE

			if(RESIN_DOOR)
				var/obj/structure/mineral_door/resin/resin_door = target
				if(a_intent != INTENT_HARM && resin_door.hivenumber == hivenumber)
					if(resin_door.TryToSwitchState(src))
						if(resin_door.open)
							to_chat(src, SPAN_XENONOTICE("We focus our connection to the resin and remotely close the resin door."))
						else
							to_chat(src, SPAN_XENONOTICE("We focus our connection to the resin and remotely open the resin door."))
					return SECRETE_RESIN_FAIL // Opening and closing doors shouldn't evoke a normal length cooldown

				if(!can_deconstruct)
					return SECRETE_RESIN_FAIL

				if(resin_door.hivenumber != hivenumber)
					to_chat(src, SPAN_XENOWARNING("We cannot deconstruct what doesn't belong to our hive!"))
					return SECRETE_RESIN_FAIL

				if(!deconstruct_windup(target))
					return SECRETE_RESIN_FAIL

				resin_door.visible_message(SPAN_XENONOTICE("[resin_door] crumbles!"))
				to_chat(src, SPAN_XENONOTICE("We deconstruct [resin_door]!"))
				playsound(target.loc, "alien_resin_move", 25)
				resin_door.Dismantle(1)
				return TRUE

			if(RESIN_FAST to RESIN_STICKY)
				var/obj/effect/alien/resin/sticky/faststicky = target
				if(!can_deconstruct)
					return SECRETE_RESIN_FAIL

				if(hivenumber != faststicky.hivenumber)
					return SECRETE_RESIN_FAIL

				faststicky.visible_message(SPAN_XENONOTICE("[faststicky] crumbles!"))
				playsound(target.loc, "alien_resin_break", 25)
				faststicky.health -= initial(faststicky.health) * 2
				faststicky.healthcheck()
				return TRUE

			if(RESIN_SPIKE)
				var/obj/effect/alien/resin/spike/resin_spike = target
				if(!can_deconstruct)
					return SECRETE_RESIN_FAIL

				if(hivenumber != resin_spike.hivenumber)
					return SECRETE_RESIN_FAIL

				resin_spike.visible_message(SPAN_XENONOTICE("[resin_spike] crumbles!"))
				playsound(target.loc, "alien_resin_break", 25)
				resin_spike.health -= initial(resin_spike.health) * 2
				resin_spike.healthcheck()
				return TRUE

			if(RESIN_ACIDPILLAR)
				var/obj/effect/alien/resin/acid_pillar/acidpillar = target
				if(!can_deconstruct)
					return SECRETE_RESIN_FAIL

				if(hivenumber != acidpillar.hivenumber)
					return SECRETE_RESIN_FAIL

				if(!deconstruct_windup(target, 1 SECONDS))
					return SECRETE_RESIN_FAIL

				acidpillar.visible_message(SPAN_XENONOTICE("[acidpillar] crumbles!"))
				playsound(target.loc, "alien_resin_break", 25)
				acidpillar.health -= initial(acidpillar.health) * 2
				acidpillar.healthcheck()
				return TRUE

			if(RESIN_RECOVERY)
				var/obj/effect/alien/resin/special/recovery/recovery = target
				if(!can_deconstruct)
					return SECRETE_RESIN_FAIL

				if(hivenumber != recovery.linked_hive.hivenumber)
					return SECRETE_RESIN_FAIL

				if(!can_destroy_special())
					return SECRETE_RESIN_FAIL

				if(!deconstruct_windup(target, 4 SECONDS))
					return SECRETE_RESIN_FAIL

				recovery.visible_message(SPAN_XENONOTICE("[recovery] crumbles!"))
				playsound(target.loc, "alien_resin_break", 25)
				recovery.health -= initial(recovery.health) * 2
				recovery.healthcheck()
				return TRUE

			if(RESIN_CLUSTER)
				var/obj/effect/alien/resin/special/cluster/cluster = target

				if(hivenumber != cluster.linked_hive.hivenumber)
					return SECRETE_RESIN_FAIL

				if(a_intent == INTENT_HARM && can_deconstruct && can_destroy_special())
					if(!deconstruct_windup(target, 4 SECONDS))
						return SECRETE_RESIN_FAIL

					cluster.visible_message(SPAN_XENONOTICE("[cluster] crumbles!"))
					playsound(target.loc, "alien_resin_break", 25)
					cluster.health -= initial(cluster.health) * 2
					cluster.healthcheck()
				else
					cluster.do_repair(src)
				return TRUE

			// Much like Membranes and Walls, these are defined seperately for future modularity but treated as the same
			if(RESIN_CORE to RESIN_PYLON)
				var/obj/effect/alien/resin/special/pylon/resin_pylon = target
				if(hivenumber != resin_pylon.linked_hive.hivenumber)
					return SECRETE_RESIN_FAIL

				resin_pylon.do_repair(src)
				return TRUE

			if(RESIN_EGGMORPH)
				var/obj/effect/alien/resin/special/eggmorph/eggmorph = target
				if(!can_deconstruct)
					return SECRETE_RESIN_FAIL

				if(hivenumber != eggmorph.linked_hive.hivenumber)
					return SECRETE_RESIN_FAIL

				if(!can_destroy_special())
					return SECRETE_RESIN_FAIL

				if(!deconstruct_windup(target, 4 SECONDS))
					return SECRETE_RESIN_FAIL

				eggmorph.visible_message(SPAN_XENONOTICE("[eggmorph] crumbles!"))
				playsound(target.loc, "alien_resin_break", 25)
				eggmorph.health -= initial(eggmorph.health) * 2
				eggmorph.healthcheck()
				return TRUE

			if(RESIN_TRAP)
				var/obj/effect/alien/resin/trap/resin_trap = target
				if(!can_deconstruct)
					return SECRETE_RESIN_FAIL

				if((hivenumber != resin_trap.hivenumber))
					return SECRETE_RESIN_FAIL

				if(resin_trap.trap_type != RESIN_TRAP_EMPTY)
					to_chat(src, SPAN_XENOWARNING("This trap is filled with something, we cannot deconstruct it!"))
					return SECRETE_RESIN_FAIL

				resin_trap.visible_message(SPAN_XENONOTICE("[resin_trap] collapses in on itself!"))
				playsound(target.loc, "alien_resin_break", 25)
				resin_trap.health -= initial(resin_trap.health) * 2
				resin_trap.healthcheck()
				return TRUE

	if(!resin_construct.can_build_here(current_turf, src))
		return SECRETE_RESIN_FAIL

	var/wait_time = resin_construct.build_time * caste.build_time_mult * add_build_mod

	var/obj/effect/alien/weeds/alien_weeds = current_turf.weeds
	if(!alien_weeds || alien_weeds.secreting)
		return SECRETE_RESIN_FAIL

	var/obj/warning
	var/succeeded = TRUE
	if(resin_construct.build_overlay_icon)
		warning = new resin_construct.build_overlay_icon(current_turf)

	if(resin_construct.build_animation_effect)
		warning = new resin_construct.build_animation_effect(current_turf)

		switch(wait_time)
			if(1 SECONDS)
				warning.icon_state = "[warning.icon_state]Fast"
			if(4 SECONDS)
				warning.icon_state = "[warning.icon_state]Slow"

		update_icons(warning)

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

	if(!resin_construct.can_build_here(current_turf, src))
		return SECRETE_RESIN_FAIL

	if(use_plasma)
		use_plasma(total_resin_cost)
	if(message)
		if(Adjacent(target))
			visible_message(SPAN_XENONOTICE("[src] regurgitates a thick substance and shapes it into \a [resin_construct.construction_name]!"),
			SPAN_XENONOTICE("We regurgitate some resin and shape it into \a [resin_construct.construction_name][use_plasma ? " at the cost of a total [total_resin_cost] plasma" : ""]."), null, 5)
			playsound(loc, "alien_resin_build", 25)
		else
			target.visible_message(SPAN_XENONOTICE("The weeds begin pulsating wildly and secrete resin in the shape of \a [resin_construct.construction_name]!"))
			to_chat(src, SPAN_XENONOTICE("We focus [use_plasma ? "[total_resin_cost] of our plasma into" : "our will through"] the weeds below us and force the weeds to secrete resin in the shape of \a [resin_construct.construction_name]."))
			playsound(current_turf, "alien_resin_build", 25)

	var/atom/new_resin = resin_construct.build(current_turf, hivenumber, src)
	if(resin_construct.max_per_xeno != RESIN_CONSTRUCTION_NO_MAX)
		LAZYADD(built_structures[resin_construct.build_path], new_resin)
		RegisterSignal(new_resin, COMSIG_PARENT_QDELETING, PROC_REF(remove_built_structure))

	new_resin.add_hiddenprint(src) //so admins know who placed it

	var/area/resin_area = get_area(new_resin)
	if(resin_area && resin_area.linked_lz)
		new_resin.AddComponent(/datum/component/resin_cleanup)

	if(istype(new_resin, /turf/closed))
		for(var/mob/living/carbon/human/enclosed_human in new_resin.contents)
			if(enclosed_human.stat == DEAD && enclosed_human.is_revivable(TRUE))
				msg_admin_niche("[src.ckey]/([src]) has built a closed resin structure, [new_resin.name], on top of a dead human, [enclosed_human.ckey]/([enclosed_human]), at [new_resin.x],[new_resin.y],[new_resin.z] [ADMIN_JMP(new_resin)]")

	return SECRETE_RESIN_SUCCESS

#undef RESIN_CONSTRUCT
#undef RESIN_DOOR
#undef RESIN_WALL
#undef RESIN_WALL_MEMBRANE
#undef RESIN_FAST
#undef RESIN_STICKY
#undef RESIN_SPIKE
#undef RESIN_ACIDPILLAR
#undef RESIN_RECOVERY
#undef RESIN_CLUSTER
#undef RESIN_CORE
#undef RESIN_PYLON
#undef RESIN_EGGMORPH
#undef RESIN_TRAP

/mob/living/carbon/xenomorph/proc/deconstruct_windup(atom/target, delay = 2 SECONDS)
	target.visible_message(SPAN_XENONOTICE("[target] starts to shudder!"))
	to_chat(src, SPAN_XENOWARNING("We channel our focus on deconstructing [target]!"))
	if(!do_after(src, delay, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, target))
		target.visible_message(SPAN_XENONOTICE("[target] stops shuddering!"))
		to_chat(src, SPAN_XENONOTICE("We stop focusing on deconstructing [target]!"))
		return FALSE

	return TRUE

/mob/living/carbon/xenomorph/proc/remove_built_structure(atom/A)
	SIGNAL_HANDLER
	LAZYREMOVE(built_structures[A.type], A)
	if(!built_structures[A.type])
		built_structures -= A.type

/mob/living/carbon/xenomorph/proc/place_construction(turf/current_turf, datum/construction_template/xenomorph/structure_template)
	if(!structure_template || !check_state() || action_busy)
		return

	var/current_area_name = get_area_name(current_turf)
	var/obj/effect/alien/resin/construction/new_structure = new(current_turf, hive)
	new_structure.set_template(structure_template)
	hive.add_construction(new_structure)

	var/max_constructions = hive.hive_structures_limit[structure_template.name]
	var/remaining_constructions = max_constructions - hive.get_structure_count(structure_template.name)
	visible_message(SPAN_XENONOTICE("A thick substance emerges from the ground and shapes into \a [new_structure]."),
		SPAN_XENONOTICE("We designate a new [structure_template] construction. ([remaining_constructions]/[max_constructions] remaining)"), null, 5)
	playsound(new_structure, "alien_resin_build", 25)

	if(hive.living_xeno_queen)
		xeno_message("Hive: A new <b>[structure_template]<b> construction has been designated at [sanitize_area(current_area_name)]!", 3, hivenumber)

/mob/living/carbon/xenomorph/proc/make_marker(turf/target_turf)
	if(!target_turf)
		return FALSE
	if(istype(target_turf, /turf/open/space/transit))
		to_chat(src, SPAN_NOTICE("What would that achieve?!"))
		return
	var/found_weeds = FALSE
	if(!selected_mark)
		to_chat(src, SPAN_NOTICE("We must have a meaning for the mark before you can make it."))
		hive.mark_ui.open_mark_menu(src)
		return FALSE

	if(!SSmapping.same_z_map(z, target_turf.loc.z))
		to_chat(src, SPAN_XENOWARNING("Our mind cannot reach that far."))
		return

	if(!(istype(target_turf)) || target_turf.density)
		return FALSE
	for(var/atom/movable/AM  in target_turf.contents)
		if(istype(AM, /obj/effect/alien/weeds))
			found_weeds = TRUE
		if(AM.density || istype(AM, /obj/effect/alien/resin))
			to_chat(src, SPAN_XENONOTICE("Theres not enough space there for a resin mark."))
			return FALSE

	var/obj/effect/alien/resin/marker/NM = new /obj/effect/alien/resin/marker(target_turf, src)
	playsound(target_turf, "alien_resin_build", 25)

	if(!found_weeds)
		to_chat(src, SPAN_XENOMINORWARNING("We made the resin mark on ground with no weeds, it will break soon without any."))

	if(isqueen(src))
		NM.color = "#7a21c4"
	else
		NM.color = "#db6af1"
	if(hive.living_xeno_queen)
		var/current_area_name = get_area_name(target_turf)

		for(var/mob/living/carbon/xenomorph/X in hive.totalXenos)
			to_chat(X, SPAN_XENOANNOUNCE("[src.name] has declared: [NM.mark_meaning.desc] in [sanitize_area(current_area_name)]! (<a href='byond://?src=\ref[X];overwatch=1;target=\ref[NM]'>Watch</a>) (<a href='byond://?src=\ref[X];track=1;target=\ref[NM]'>Track</a>)"))
			//this is killing the tgui chat and I dont know why
	return TRUE
