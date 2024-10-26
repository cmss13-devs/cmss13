	/**
	  *
	  * Base surgery datum and procs. There is an important distinction between surgery datums and surgery steps.
	  * The surgery is a separate instance for each individual operation; the steps are shared globally.
	  * datum/surgery and datum/surgery_step are intertwined. The surgery calls the step which modifies the surgery.
	  * Defines are in __DEFINES/human.dm and __DEFINES/surgery.dm.
	  *
	  */

/datum/surgery
	var/name = "surgery"
	///When initiating surgeries, this defines their order when listed in initiation selector or 'you can't use this tool for anything, but could x, y, or z' messages.
	var/priority = SURGERY_PRIORITY_MODERATE
	var/desc = "surgery description"
	///List of steps in the surgery.
	var/list/steps = list()
	/**List of possible locations the surgery can be performed on. This is target zones: DEFENSE_ZONES_LIVING lists all options. ALL_LIMBS doesn't include eyes/mouth.
	Note also that steps don't check this and it is possible to include a step that can't be performed on a target limb.**/
	var/list/possible_locs = ALL_LIMBS
	///What species can this be performed on?
	var/list/target_mobtypes = list(/mob/living/carbon/human)
	///How deep the incision must be before this operation is a valid option.
	var/invasiveness = list(SURGERY_DEPTH_SHALLOW)
	///Status flag(s) required on the target limb to perform an operation. NONE for any limb type. (FLAG|FLAG) is an OR check, granular this-but-not-this or this-and-this checks should be in can_start()
	var/requires_bodypart_type = LIMB_ORGANIC|LIMB_SYNTHSKIN
	///TRUE if the surgery requires a non-destroyed limb; FALSE if it requires a destroyed one, or doesn't need a limb.
	var/requires_bodypart = TRUE
	///Does the victim needs to be lying down? Surgeries that can be performed while standing aren't affected by the surface the patient is on.
	var/lying_required = TRUE
	///Can the surgery be performed on yourself?
	var/self_operable = FALSE
	///How strong a level of anesthesia is needed to avoid risking pain causing a step to fail?
	var/pain_reduction_required = PAIN_REDUCTION_FULL
	///How much training is needed to do this surgery?
	var/required_surgery_skill = SKILL_SURGERY_TRAINED

	var/step_in_progress = FALSE
	///The step the surgery is currently on. When status > number of steps, the surgery ends.
	var/status = 1
	var/mob/living/carbon/target
	///The limb the surgery is being performed on. If designing a surgery for a species without limbs, this var won't be usable.
	var/obj/limb/affected_limb
	///The location this instance of the surgery is being performed on.
	var/location = "chest"

/datum/surgery/New(surgery_target, surgery_location, surgery_limb)
	..()
	if(surgery_target)
		target = surgery_target
		if(surgery_location)
			location = surgery_location
			target.active_surgeries[surgery_location] = src
		else
			CRASH("Surgery [src] created with a patient ([surgery_target]) but no target location.")
		if(surgery_limb)
			affected_limb = surgery_limb

/datum/surgery/Destroy()
	affected_limb = null
	if(target)
		target.active_surgeries[location] = null
	target = null
	. = ..()

///Catch-all proc for additional preconditions for starting the surgery. Return FALSE if the surgery can't be done.
/datum/surgery/proc/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	return TRUE
	//Might add the surgery computer later

///Used on attackby and attackhand; TRUE means it stops the attack there, FALSE means it performs an item/open hand attack. CHECK OPENHAND ATTACK IS BLOCKED PROPERLY
/datum/surgery/proc/attempt_next_step(mob/user, obj/item/tool, repeating)
	if(step_in_progress)
		if(!user.action_busy) //Otherwise, assume it's the same person.
			to_chat(user, SPAN_WARNING("Someone is already performing surgery on [target]'s [affected_limb.display_name]!"))
			return FALSE

		return TRUE //So that you don't poke them with a tool you're already using.

	if(user.action_busy)
		to_chat(user, SPAN_WARNING("You're too busy to perform surgery on [user == target ? "yourself" : "[target]"]!"))
		return FALSE

	if((target.mob_flags & EASY_SURGERY) ? !skillcheck(user, SKILL_SURGERY, SKILL_SURGERY_NOVICE) : !skillcheck(user, SKILL_SURGERY, required_surgery_skill))
		to_chat(user, SPAN_WARNING("This operation is more complex than you're trained for!"))
		return FALSE

	if(target.pulledby?.grab_level == GRAB_CARRY)
		if(target.pulledby == user)
			to_chat(user, SPAN_WARNING("You need to set [target] down before you can operate on \him!"))
		else
			to_chat(user, SPAN_WARNING("You can't operate on [target], \he is being carried by [target.pulledby]!"))
		return FALSE

	if(lying_required && target.body_position != LYING_DOWN)
		to_chat(user, SPAN_WARNING("[user == target ? "You need" : "[target] needs"] to be lying down for this operation!"))
		return FALSE
	if(user == target)
		if(!self_operable)
			to_chat(user, SPAN_WARNING("You can't perform this operation on yourself!"))
			return FALSE
		if((!user.hand && (user.zone_selected in list("r_arm", "r_hand"))) || (user.hand && (user.zone_selected in list("l_arm", "l_hand"))))
			to_chat(user, SPAN_WARNING("You can't perform surgery on the same \
				[user.zone_selected == "r_hand"||user.zone_selected == "l_hand" ? "hand":"arm"] you're using!"))
			return FALSE
	var/datum/surgery_step/current_step = GLOB.surgery_step_list[steps[status]]
	if(current_step)
		if(current_step.attempt_step(user, target, user.zone_selected, tool, src, repeating)) //First, try this step.
			return TRUE
		var/datum/surgery_step/next_step
		if(current_step.skip_step_criteria(user, target, user.zone_selected, tool, src) && status < length(steps)) //If that doesn't work but the step is optional and not the last in the list, try the next step.
			next_step = GLOB.surgery_step_list[steps[status + 1]]
			if(next_step.attempt_step(user, target, user.zone_selected, tool, src, skipped = TRUE))
				return TRUE
		if(tool && is_surgery_tool(tool)) //Just because you used the wrong tool doesn't mean you meant to whack the patient with it...
			if(next_step)
				to_chat(user, SPAN_WARNING("You can't [current_step.desc] with \the [tool], or [next_step.desc]."))
			else
				to_chat(user, SPAN_WARNING("You can't [current_step.desc] with \the [tool]."))
			return FALSE //...but you might be wanting to use it on them anyway. If on help intent, the help-intent safety will apply for this attack.
	return FALSE

