	/**
	  *
	  * Does the surgery initiation. Returns TRUE if the triggering attack should be halted.
	  *
	  */

/proc/initiate_surgery_moment(obj/item/tool, mob/living/carbon/target, obj/limb/affecting, mob/living/user)
	if(!tool && !(affecting.status & LIMB_UNCALIBRATED_PROSTHETIC))
		return FALSE
	var/target_zone = user.zone_selected
	var/list/available_surgeries = list()
	var/list/valid_steps = list() //Steps that could be performed, if we had the right tool.

	var/turf/open/T = get_turf(target)
	if(!istype(user.loc, /turf/open))
		to_chat(user, SPAN_WARNING("You can't perform surgery here!"))
		return FALSE
	else
		if(!istype(T) || !T.supports_surgery)
			if(tool.flags_item & CAN_DIG_SHRAPNEL) //Both shrapnel removal and prosthetic repair shouldn't be affected by being on the dropship.
				tool.dig_out_shrapnel_check(target, user)
				return TRUE //Otherwise you get 'poked' by the knife.
			if(HAS_TRAIT(tool, TRAIT_TOOL_BLOWTORCH) && affecting)
				return FALSE
			if(!(tool.type in SURGERY_TOOLS_NO_INIT_MSG))
				to_chat(user, SPAN_WARNING("You can't perform surgery under these bad conditions!"))
			return FALSE

	var/obj/limb/surgery_limb = target.get_limb(target_zone)
	if(surgery_limb)
		var/obj/item/blocker = target.get_sharp_obj_blocker(surgery_limb)
		if(blocker)
			to_chat(user, SPAN_WARNING("[blocker] [target] is wearing restricts your access to the surgical site, take it off!"))
			return

	if(user.action_busy) //already doing an action
		return FALSE

	for(var/datum/surgery/surgeryloop as anything in GLOB.surgeries_by_zone_and_depth[target_zone][target.incision_depths[target_zone]])
		//Skill check.
		if((target.mob_flags & EASY_SURGERY) ? !skillcheck(user, SKILL_SURGERY, SKILL_SURGERY_NOVICE) : !skillcheck(user, SKILL_SURGERY, surgeryloop.required_surgery_skill))
			continue

		//Lying and self-surgery checks.
		if(surgeryloop.lying_required && target.body_position != LYING_DOWN)
			continue

		if(!surgeryloop.self_operable && target == user)
			continue

		//Species check.
		if(!is_type_in_typecache(target, GLOB.surgical_patient_types["[surgeryloop]"]))
			continue

		//Limb checks.
		if(affecting)
			if(surgeryloop.requires_bodypart)
				if(affecting.status & LIMB_DESTROYED)
					continue
			else
				if(ishuman(target))//otherwise breaks when trying to op xeno
					if(!(affecting.status & LIMB_DESTROYED) && ishuman(target))
						continue

					if(affecting.parent && affecting.parent.status & LIMB_DESTROYED && ishuman(target))
						continue

			if(surgeryloop.requires_bodypart_type && !(affecting.status & surgeryloop.requires_bodypart_type))
				continue

		else if(surgeryloop.requires_bodypart) //mob with no limb in surgery zone when we need a limb
			continue

		//Surgery-specific requirements.
		if(!surgeryloop.can_start(user, target, affecting, tool))
			continue

		//Tool checks.
		var/datum/surgery_step/current_step = GLOB.surgery_step_list[surgeryloop.steps[1]]

		if(!current_step.tool_check(user, tool, surgeryloop))
			valid_steps += current_step
			if(current_step.skip_step_criteria(user, target, target_zone, tool, surgeryloop) && length(surgeryloop.steps) > 1)
				var/datum/surgery_step/next_step = GLOB.surgery_step_list[surgeryloop.steps[2]]
				if(!next_step.tool_check(user, tool, surgeryloop))
					valid_steps += next_step
					continue
			else
				continue
		available_surgeries[surgeryloop.name] = surgeryloop //Add it to the list.
	if(!length(available_surgeries))
		if(!tool)
			return FALSE

		if(target.incision_depths[target_zone] == SURGERY_DEPTH_SURFACE ? is_surgery_init_tool(tool) : is_surgery_tool(tool))
			if(target == user && ((!user.hand && (target_zone in list("r_arm", "r_hand"))) || (user.hand && (target_zone in list("l_arm", "l_hand")))))
				to_chat(user, SPAN_WARNING("You can't perform surgery on the same \
					[target_zone == "r_hand"||target_zone == "l_hand" ? "hand":"arm"] you're using!"))
				return FALSE
			if(!length(valid_steps))
				if(ishuman(target))
					var/limbname = affecting?.status & LIMB_DESTROYED ? "the stump of [target]'s [affecting.display_name]" : "[target]'s [parse_zone(target_zone)]"
					if(target.incision_depths[target_zone] != SURGERY_DEPTH_SURFACE)
						to_chat(user, SPAN_WARNING("You don't know of any operations you could perform in the [target.incision_depths[target_zone]] incision on [limbname]."))
					else
						to_chat(user, SPAN_WARNING("You don't know of any operations you could begin on [limbname]."))
					return FALSE
				if(isxeno(target))
					to_chat(user, SPAN_WARNING("You don't know any operations you could perform on this body part of a xenomorph."))
			var/hint_msg
			for(var/datum/surgery_step/current_step as anything in valid_steps)
				if(hint_msg)
					if(current_step == valid_steps[length(valid_steps)])
						hint_msg += ", or [current_step.desc]"
					else
						hint_msg += ", [current_step.desc]"
				else
					hint_msg = "You can't [current_step.desc] with \the [tool]"
			if(!isnull(hint_msg))
				to_chat(user, SPAN_WARNING("[hint_msg]."))
		return FALSE

	var/datum/surgery/surgeryinstance
	if(length(available_surgeries) == 1)
		surgeryinstance = available_surgeries[available_surgeries[1]]
	else
		surgeryinstance = available_surgeries[tgui_input_list(user, "Begin which procedure?", "Surgery", sortList(available_surgeries))]
		//we check that the surgery is still doable after the input() wait.
		if(!surgeryinstance || QDELETED(user) || user.is_mob_incapacitated() || !user.Adjacent(target) || tool != user.get_active_hand() || target_zone != user.zone_selected)
			return TRUE

		if(target.active_surgeries[target_zone])
			return TRUE //during the input() another surgery was started at the same location.

		if(target == user && ((!user.hand && (target_zone in list("r_arm", "r_hand"))) || (user.hand && (target_zone in list("l_arm", "l_hand")))))
			to_chat(user, SPAN_WARNING("You can't perform surgery on the same \
				[target_zone == "r_hand"||target_zone == "l_hand" ? "hand":"arm"] you're using!"))
			return TRUE

		if(surgeryinstance.lying_required && target.body_position != LYING_DOWN)
			return TRUE

		if(surgery_limb)
			var/obj/item/blocker = target.get_sharp_obj_blocker(surgery_limb)
			if(blocker)
				to_chat(user, SPAN_WARNING("[blocker] [target] is wearing restricts your access to the surgical site, take it off!"))
				return

		if(affecting)
			if(surgeryinstance.requires_bodypart)
				if(affecting.status & LIMB_DESTROYED)
					return TRUE
			else
				if(!(affecting.status & LIMB_DESTROYED))
					return TRUE
				if(affecting.parent && affecting.parent.status & LIMB_DESTROYED)
					return TRUE

			if(surgeryinstance.requires_bodypart_type && !(affecting.status & surgeryinstance.requires_bodypart_type))
				return TRUE
		else if(target && surgeryinstance.requires_bodypart)
			return TRUE
		if(!surgeryinstance.can_start(user, target, affecting, tool))
			return TRUE
	var/datum/surgery/procedure = new surgeryinstance.type(target, target_zone, affecting)
	#ifdef DEBUG_SURGERY_INIT
	message_admins("[procedure.name] started.")
	#endif
	procedure.attempt_next_step(user, tool)
	return TRUE
