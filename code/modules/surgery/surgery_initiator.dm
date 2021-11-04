#define DEBUG_SURGERY_INIT FALSE

	/**
	  *
	  * Does the surgery initiation. Returns TRUE if the triggering attack should be halted.
	  *
	  */

proc/initiate_surgery_moment(obj/item/tool, mob/living/carbon/target, obj/limb/affecting, mob/living/user)
	#if DEBUG_SURGERY_INIT
	message_staff("Initiating surgery. Tool = [tool], Target = [target], Target Limb = [affecting], Surgeon = [user].")
	#endif

	var/target_zone = user.zone_selected
	var/list/available_surgeries = list()
	var/list/valid_steps = list() //Steps that could be performed, if we had the right tool.

	if(user.action_busy) //already doing an action
		#if DEBUG_SURGERY_INIT
		message_staff("Already performing timed action, aborting.")
		#endif
		return FALSE

	for(var/datum/surgery/surgeryloop as anything in GLOB.surgeries_by_zone_and_depth[target_zone][target.incision_depths[target_zone]])
		#if DEBUG_SURGERY_INIT
		message_staff("----------------------------------------------")
		message_staff("Currently evaluated operation = [surgeryloop].")
		#endif

		//Skill check.
		if((target.mob_flags & EASY_SURGERY) ? !skillcheck(user, SKILL_SURGERY, SKILL_SURGERY_NOVICE) : !skillcheck(user, SKILL_SURGERY, surgeryloop.required_surgery_skill))
			#if DEBUG_SURGERY_INIT
			message_staff("Not trained to perform this operation, skipping.")
			#endif
			continue

		//Lying and self-surgery checks.
		if(surgeryloop.lying_required && !target.lying)
			#if DEBUG_SURGERY_INIT
			message_staff("This operation needs a prone target and the target isn't, skipping.")
			#endif
			continue
		if(!surgeryloop.self_operable && target == user)
			#if DEBUG_SURGERY_INIT
			message_staff("This operation isn't self-operable and the user is the target, skipping.")
			#endif
			continue

		//Species check.
		if(!is_type_in_typecache(target, GLOB.surgical_patient_types["[surgeryloop]"]))
			#if DEBUG_SURGERY_INIT
			message_staff("The target mob is of the wrong type, skipping.")
			#endif
			continue

		//Limb checks.
		if(affecting)
			if(surgeryloop.requires_bodypart)
				if(affecting.status & LIMB_DESTROYED)
					#if DEBUG_SURGERY_INIT
					message_staff("This operation needs an intact bodypart and the target part is destroyed, skipping.")
					#endif
					continue
			else
				if(!(affecting.status & LIMB_DESTROYED))
					#if DEBUG_SURGERY_INIT
					message_staff("This operation requires a destroyed bodypart and the target part is intact, skipping.")
					#endif
					continue
				if(affecting.parent && affecting.parent.status & LIMB_DESTROYED)
					#if DEBUG_SURGERY_INIT
					message_staff("This operation requires a destroyed bodypart but its parent is also destroyed, skipping.")
					#endif
					continue
			if(surgeryloop.requires_bodypart_type && !(affecting.status & surgeryloop.requires_bodypart_type))
				#if DEBUG_SURGERY_INIT
				message_staff("This operation has requires_bodypart_type and the target part's status doesn't include it, skipping.")
				#endif
				continue
		else if(surgeryloop.requires_bodypart) //mob with no limb in surgery zone when we need a limb
			#if DEBUG_SURGERY_INIT
			message_staff("No bodypart in this zone and this operation needs one, skipping.")
			#endif
			continue

		//Surgery-specific requirements.
		if(!surgeryloop.can_start(user, target, affecting, tool))
			#if DEBUG_SURGERY_INIT
			message_staff("can_start failed, skipping.")
			#endif
			continue


		//Tool checks.
		var/datum/surgery_step/current_step = GLOB.surgery_step_list[surgeryloop.steps[1]]
		
		if(!current_step.tool_check(user, tool, surgeryloop))
			valid_steps += current_step
			if(current_step.skip_step_criteria(user, target, target_zone, tool, surgeryloop) && length(surgeryloop.steps) > 1)
				var/datum/surgery_step/next_step = GLOB.surgery_step_list[surgeryloop.steps[2]]
				if(!next_step.tool_check(user, tool, surgeryloop))
					valid_steps += next_step
					#if DEBUG_SURGERY_INIT
					message_staff("Cannot perform this operation's optional first step with this tool and cannot perform the second step either, skipping and adding them to hint list.")
					#endif
					continue
			else
				#if DEBUG_SURGERY_INIT
				message_staff("Cannot perform or skip this operation's first step using this tool, skipping and adding it to the hint list.")
				#endif
				continue

		available_surgeries[surgeryloop.name] = surgeryloop //Add it to the list.

	if(!length(available_surgeries))
		#if DEBUG_SURGERY_INIT
		message_staff("No valid surgeries found.")
		#endif
		if(!tool)
			return FALSE

		if(target.incision_depths[target_zone] == SURGERY_DEPTH_SURFACE ? is_surgery_init_tool(tool) : is_surgery_tool(tool))
			if(target == user && ((!user.hand && (target_zone in list("r_arm", "r_hand"))) || (user.hand && (target_zone in list("l_arm", "l_hand")))))
				to_chat(user, SPAN_WARNING("You can't perform surgery on the same \
					[target_zone == "r_hand"||target_zone == "l_hand" ? "hand":"arm"] you're using!"))
				return FALSE

			if(!length(valid_steps))
				var/limbname = affecting?.status & LIMB_DESTROYED ? "the stump of [target]'s [affecting.display_name]" : "[target]'s [parse_zone(target_zone)]"
				if(target.incision_depths[target_zone] != SURGERY_DEPTH_SURFACE)
					to_chat(user, SPAN_WARNING("You don't know of any operations you could perform in the [target.incision_depths[target_zone]] incision on [limbname]."))
				else
					to_chat(user, SPAN_WARNING("You don't know of any operations you could begin on [limbname]."))
				return FALSE

			var/hint_msg
			for(var/datum/surgery_step/current_step as anything in valid_steps)
				if(hint_msg)
					if(current_step == valid_steps[length(valid_steps)])
						hint_msg += ", or [current_step.desc]"
					else
						hint_msg += ", [current_step.desc]"
				else
					hint_msg = "You can't [current_step.desc] with \the [tool]"
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

		if(surgeryinstance.lying_required && !target.lying)
			return TRUE

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
	#if DEBUG_SURGERY_INIT
	message_staff("[procedure.name] started.")
	#endif
	procedure.attempt_next_step(user, tool)
	return TRUE

#undef DEBUG_SURGERY_INIT
