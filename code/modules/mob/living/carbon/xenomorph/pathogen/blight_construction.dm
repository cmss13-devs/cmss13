/datum/action/xeno_action/verb/place_pathogen_structure()
	set category = "Alien"
	set name = "Order Pathogen Construction"
	set hidden = TRUE
	var/action_name = "Order Pathogen (400)"
	handle_xeno_macro(src, action_name)


/datum/action/xeno_action/activable/place_pathogen_structure
	name = "Order Pathogen Construction (400)"
	action_icon_state = "morph_resin"
	macro_path = /datum/action/xeno_action/verb/place_pathogen_structure
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_5

/datum/action/xeno_action/activable/place_pathogen_structure/not_primary //so it doesn't screw other macros up
	ability_primacy = XENO_NOT_PRIMARY_ACTION


/datum/action/xeno_action/activable/place_pathogen_structure/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/creature = owner
	if(!creature.check_state())
		return FALSE

	if(isstorage(target.loc) || creature.contains(target) || istype(target, /atom/movable/screen))
		return FALSE

	var/datum/hive_status/pathogen/confluence = creature.hive
	if(!istype(confluence))
		to_chat(creature, SPAN_WARNING("We cannot reach the mycelial link!"))
		return FALSE

	if(SSticker?.mode?.hardcore)
		to_chat(creature, SPAN_XENOWARNING("The confluence is too inexperienced to design constructions."))
		return FALSE

	//Make sure construction is unrestricted
	if(IS_NORMAL_XENO(creature))
		if(!HAS_FLAG(confluence.hive_flags, XENO_CONSTRUCTION_NORMAL))
			to_chat(creature, SPAN_WARNING("Construction by normal sisters is currently restricted!"))
			return FALSE
	else if(IS_XENO_LEADER(creature))
		if(!HAS_FLAG(confluence.hive_flags, XENO_CONSTRUCTION_LEADERS))
			to_chat(creature, SPAN_WARNING("Construction by leader sisters is currently restricted!"))
			return FALSE
	/*
	else if(is_pathogen_overmind(creature))
		if(!HAS_FLAG(confluence.hive_flags, XENO_CONSTRUCTION_QUEEN))
			to_chat(creature, SPAN_WARNING("We are currently not allowed to designate construction!"))
			return FALSE
	*/
	else
		to_chat(creature, SPAN_DANGER("Something went wrong!"))
		CRASH("Something went wrong determining hive_pos during place_pathogen_structure!")

	var/turf/target_turf = get_turf(target)

	var/area/target_area = get_area(target_turf)
	if(isnull(target_area) || !(target_area.is_resin_allowed))
		if(!target_area || target_area.flags_area & AREA_UNWEEDABLE)
			to_chat(creature, SPAN_XENOWARNING("This area is unsuited to host the confluence!"))
			return
		to_chat(creature, SPAN_XENOWARNING("It's too early to spread the confluence this far."))
		return FALSE

	if(target_turf.z != creature.z)
		to_chat(creature, SPAN_XENOWARNING("This area is too far away to affect!"))
		return FALSE

	if(SSinterior.in_interior(creature))
		to_chat(creature, SPAN_XENOWARNING("It's too tight in here to build."))
		return FALSE

	if(!creature.check_alien_construction(target_turf))
		return FALSE

	var/choice = PATHOGEN_STRUCTURE_CORE
	if(confluence.hivecore_cooldown)
		to_chat(creature, SPAN_WARNING("The blight is still recovering from the death of the last core, wait until the blight has recovered!"))
		return FALSE
	if(confluence.has_structure(PATHOGEN_STRUCTURE_CORE) || !confluence.can_build_structure(PATHOGEN_STRUCTURE_CORE))
		choice = tgui_input_list(creature, "Choose a structure to build", "Build structure", confluence.hive_structure_types + "help", theme = "hive_status")
		if(!choice)
			return
		if(choice == "help")
			var/message = "Placing a construction node creates a template for special structures that can benefit the confluence, which require the insertion of plasma to construct the following:<br>"
			for(var/structure_name in confluence.hive_structure_types)
				var/datum/construction_template/xenomorph/structure_type = confluence.hive_structure_types[structure_name]
				message += "<b>[capitalize_first_letters(structure_name)]</b> - [initial(structure_type.description)]<br>"
			to_chat(creature, SPAN_NOTICE(message))
			return TRUE
	if(!creature.check_state(TRUE) || !creature.check_plasma(400))
		return FALSE
	var/structure_type = confluence.hive_structure_types[choice]
	var/datum/construction_template/xenomorph/structure_template = new structure_type()

	if(!spacecheck(creature, target_turf, structure_template))
		// spacecheck already cleans up the template
		return FALSE

	if(!do_after(creature, XENO_STRUCTURE_BUILD_TIME, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return FALSE

	if(!spacecheck(creature, target_turf, structure_template)) //doublechecking
		// spacecheck already cleans up the template
		return FALSE

	if(choice == PATHOGEN_STRUCTURE_CORE && target_area.unoviable_timer)
		to_chat(creature, SPAN_WARNING("This area does not feel right for you to build this in."))
		qdel(structure_template)
		return FALSE

	/*
	if((choice == PATHOGEN_STRUCTURE_CORE) && is_pathogen_overmind(creature) && confluence.has_structure(PATHOGEN_STRUCTURE_CORE))
		if(confluence.hive_location.hardcore || world.time > XENOMORPH_PRE_SETUP_CUTOFF)
			to_chat(creature, SPAN_WARNING("We can't rebuild this structure!"))
			qdel(structure_template)
			return FALSE
		if(alert(creature, "Are we sure that we want to move the confluence and destroy the old blight core?", , "Yes", "No") != "Yes")
			qdel(structure_template)
			return FALSE
		qdel(confluence.hive_location)
	else if(!confluence.can_build_structure(choice))
	*/
	if(!confluence.can_build_structure(choice))
		to_chat(creature, SPAN_WARNING("We can't build any more [choice]s for the hive."))
		qdel(structure_template)
		return FALSE

	if(QDELETED(target_turf))
		to_chat(creature, SPAN_WARNING("We cannot build here!"))
		qdel(structure_template)
		return FALSE

	var/queen_on_zlevel = !confluence.living_xeno_queen || SSmapping.same_z_map(confluence.living_xeno_queen.z, target_turf.z)
	if(!queen_on_zlevel)
		to_chat(creature, SPAN_WARNING("Our link to the Overmind is too weak here. She is on another world."))
		qdel(structure_template)
		return FALSE

	if(SSinterior.in_interior(creature))
		to_chat(creature, SPAN_WARNING("It's too tight in here to build."))
		qdel(structure_template)
		return FALSE

	if(target_turf.is_weedable < FULLY_WEEDABLE)
		to_chat(creature, SPAN_WARNING("\The [target_turf] can't support a [structure_template.name]!"))
		qdel(structure_template)
		return FALSE

	var/obj/effect/alien/weeds/weeds = locate() in target_turf
	if(weeds?.block_structures >= BLOCK_SPECIAL_STRUCTURES)
		to_chat(creature, SPAN_WARNING("\The [weeds] block the construction of any special structures!"))
		qdel(structure_template)
		return FALSE

	creature.use_plasma(400)
	creature.place_construction(target_turf, structure_template)

	return ..()

// XSS Spacecheck

/datum/action/xeno_action/activable/place_pathogen_structure/proc/spacecheck(mob/living/carbon/xenomorph/X, turf/T, datum/construction_template/xenomorph/tem)
	if(tem.block_range)
		for(var/turf/TA in range(tem.block_range, T))
			if(!X.check_alien_construction(TA, FALSE, TRUE, ignore_nest = TRUE))
				to_chat(X, SPAN_WARNING("We need more open space to build here."))
				qdel(tem)
				return FALSE
		if(!X.check_alien_construction(T, ignore_nest = TRUE))
			to_chat(X, SPAN_WARNING("We need more open space to build here."))
			qdel(tem)
			return FALSE
		var/obj/effect/alien/weeds/alien_weeds = locate() in T
		if(!alien_weeds || alien_weeds.weed_strength < WEED_LEVEL_HIVE || alien_weeds.linked_hive.hivenumber != X.hivenumber)
			to_chat(X, SPAN_WARNING("We can only shape on confluence blight. We must find a blight cluster or core before we start building!"))
			qdel(tem)
			return FALSE
		if(T.density)
			qdel(tem)
			to_chat(X, SPAN_WARNING("We need empty space to build this."))
			return FALSE
	return TRUE
