/datum/surgery_step
	var/name
	/**Description of the surgery used for need-different-tool messages,
	format: (You could/can't )["sever the bone in the patient's limb"]( with \the [tool], or )[next step desc]. Can't refer to outside vars as step datums are global.**/
	var/desc

	/**Associative list, tools and their step time multiplier. tools_typecache is assigned from from first to last, so if you have a
	more specific subtype and its parent in the same list, place the subtype last to override the general parent.
	Some are shared defines, some are set on the tool that uses them.**/
	var/list/tools = list()
	/**Assoc. list. This is generated on init and is something like an inverse typecache. All types and subtypes of valid tools are in it, associated to the
	parent tool type. Example: for an item type /wxy/z, tool_check() returns tools_cache[/wxy/z]. If /wxy is in tools, this will == /wxy; otherwise it == NULL.**/
	var/list/tools_cache = list()

	/**Does the surgery step accept an open hand? If true and the surgeon uses their hand, doesn't check for tools. If wanting to make a
	surgery where a hand can do it but tools are faster, give it a long default time and its tools modifiers above 100.**/
	var/accept_hand = FALSE
	///Does the surgery step accept any item? If true, ignores tools.
	var/accept_any_item = FALSE
	/**How long does the step take as a baseline? Modified by the surgeon's skills, the tool used, and, if the parent surgery requires the patient
	to be lying down, the surface the patient is buckled to or resting on: surgery table, field surgical bed, rollerbed, table, open ground etc.**/
	var/time = 10
	///Whether this step continuously repeats as long as a criteria is met. If TRUE, consider setting skip_step_criteria() or using a failure() override to return TRUE to allow it to be canceled or skipped.
	var/repeat_step = FALSE
	///preop means "in Progress" sound
	var/preop_sound
	///Sound of success
	var/success_sound
	///failure >:(
	var/failure_sound

/datum/surgery_step/New()
	. = ..()
	for(var/tool_path in tools)
		var/list/templist = typesof(tool_path)
		for(var/iteration in templist)
			tools_cache[iteration] = tool_path

/**Whether this step is optional and can be skipped if it isn't the last step. There must be a step after it to skip to. As this may be used when
initiating a surgery and deciding whether to skip the first step, it must be able to work without reference to the parent surgery's status,
affected_limb, or location vars. Also, in that case there may be a wait between passing the check and beginning the step while the user picks a surgery.**/
/datum/surgery_step/proc/skip_step_criteria(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	return FALSE

///Used by repeating steps to determine whether to keep looping. tool_type may be a typepath or simply '1'.
/datum/surgery_step/proc/repeat_step_criteria(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	return FALSE

///Checks the given tool, if any, against the step's tools list, and returns one of three options: the tool list key, TRUE, or FALSE to fail the surgery.
/datum/surgery_step/proc/tool_check(mob/user, obj/item/tool, datum/surgery/surgery)
	if(!tool)
		if(accept_hand)
			return TRUE ///obj/limb/hand ?
	else
		if(accept_any_item)
			return TRUE
		else
			return tools_cache[tool.type]
	return FALSE

///does any extra checks that is is SUBTYPED to perform
/datum/surgery_step/proc/extra_checks(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, repeating, skipped)
	return TRUE

///The proc that actually performs the step.
/datum/surgery_step/proc/attempt_step(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, repeating, skipped)
	var/tool_type = tool_check(user, tool, surgery) //A boolean, a key to the tools list for duration multipliers, and a faster method than istype() for steps to test tools.
	if(!tool_type) //Can't perform the step.
		return FALSE

	var/turf/open/T = get_turf(target)
	if(!istype(user.loc, /turf/open))
		to_chat(user, SPAN_WARNING("You can't perform surgery here!"))
		return FALSE
	else
		if(!istype(T) || !T.supports_surgery)
			if(!(tool.type in SURGERY_TOOLS_NO_INIT_MSG))
				to_chat(user, SPAN_WARNING("You can't perform surgery under these bad conditions!"))
			return FALSE

	if(!extra_checks(user, target, target_zone, tool, surgery, repeating, skipped))
		return FALSE // you must put the failure to_chat inside the checks

	var/obj/limb/surgery_limb = target.get_limb(target_zone)
	if(surgery_limb)
		var/obj/item/blocker = target.get_sharp_obj_blocker(surgery_limb)
		if(blocker)
			to_chat(user, SPAN_WARNING("[blocker] [target] is wearing restricts your access to the surgical site, take it off!"))
			return

	var/step_duration = time
	var/self_surgery
	var/tool_modifier
	var/surface_modifier
	var/failure_penalties = 0

	//Skill speed modifier.
	step_duration *= user.get_skill_duration_multiplier(SKILL_SURGERY)

	if(user == target) //Self-surgery speed modifier.
		self_surgery = TRUE
		step_duration *= SELF_SURGERY_SLOWDOWN

	if(ispath(tool_type)) //Tool speed modifier. This means hand & any item are 100% efficient as surgical tools.
		tool_modifier = tools[tool_type]
		step_duration *= tool_modifier

	if(surgery.lying_required) //Surgery surface modifier.
		surface_modifier = target.buckled?.surgery_duration_multiplier //If they're buckled, use the surface modifier of the thing they're buckled to.
		if(!surface_modifier)
			surface_modifier = SURGERY_SURFACE_MULT_AWFUL //Surgery on a completely unsuitable surface takes twice as long.
			for(var/obj/surface in get_turf(target)) //Otherwise, get the lowest surface modifier of objects on their turf.
				if(surface_modifier > surface.surgery_duration_multiplier)
					surface_modifier = surface.surgery_duration_multiplier

		step_duration *= surface_modifier

	var/list/human_modifiers = list("surgery_speed" = 1.0, "pain_reduction" = 0)
	SEND_SIGNAL(user, COMSIG_HUMAN_SURGERY_APPLY_MODIFIERS, human_modifiers)
	step_duration *= human_modifiers["surgery_speed"]

	var/try_to_fail
	if(user.a_intent != INTENT_HELP)
		try_to_fail = TRUE
		user.a_intent_change(INTENT_HELP) //So that stabbing your patient to death takes deliberate malice.
	else if(!repeating) //Looping steps only play the start message on the first iteration; deliberate failure only plays the failure message.
		preop(user, target, target_zone, tool, tool_type, surgery)
		var/list/message = new() //Duration hint messages.

		if(self_surgery)
			message += "[pick("performing surgery", "working")] on [pick("yourself", "your own body")] is [pick("awkward", "tricky")]"

		switch(tool_modifier) //Implicitly means tool exists as accept_any_item item or accept_hand would = 1x. No message for 1x - that's the default.
			if(SURGERY_TOOL_MULT_SUBOPTIMAL)
				message += "this tool is[pick("n't ideal", " not the best")]"
			if(SURGERY_TOOL_MULT_SUBSTITUTE)
				message += "this tool is[pick("n't suitable", " a bad fit", " difficult to use")]"
			if(SURGERY_TOOL_MULT_BAD_SUBSTITUTE)
				message += "this tool is [pick("awful", "barely usable")]"
				failure_penalties += 1
			if(SURGERY_TOOL_MULT_AWFUL)
				message += "this tool is [pick("awful", "barely usable")]"
				failure_penalties += 2

		switch(surface_modifier)
			if(SURGERY_SURFACE_MULT_ADEQUATE)
				message += "[pick("it isn't easy, working", "it's tricky to perform complex surgeries", "this would be quicker if you weren't working")] [pick("in the field", "under these conditions", "without a proper surgical theatre")]"
			if(SURGERY_SURFACE_MULT_UNSUITED)
				message += "[pick("it's difficult to work", "it's slow going, working", "you need to take your time")] in these [pick("primitive", "rough", "crude")] conditions"
				failure_penalties += 1
			if(SURGERY_SURFACE_MULT_AWFUL)
				message += "[pick("you need to work slowly and carefully", "you need to be very careful", "this is delicate work, especially")] [pick("in these", "under such")] [pick("terrible", "awful", "utterly unsuitable")] conditions"
				failure_penalties += 2

		if(length(message))
			to_chat(user, SPAN_WARNING("[capitalize(english_list(message, final_comma_text = ","))]."))

	var/advance //Whether to continue to the next step afterwards.
	var/pain_failure_chance = max(0, (target.pain?.feels_pain ? surgery.pain_reduction_required - target.pain.reduction_pain : 0) * 2 - human_modifiers["pain_reduction"]) //Each extra pain unit increases the chance by 2

	// Skill compensation for difficult conditions/tools
	if(skillcheck(user, SKILL_SURGERY, SKILL_SURGERY_EXPERT))
		failure_penalties -= 2 // will ultimately be -3
	if(skillcheck(user, SKILL_SURGERY, SKILL_SURGERY_TRAINED))
		failure_penalties -= 1

	var/surgery_failure_chance = SURGERY_FAILURE_IMPOSSIBLE
	if(failure_penalties == 1)
		surgery_failure_chance = SURGERY_FAILURE_UNLIKELY
	else if(failure_penalties == 2)
		surgery_failure_chance = SURGERY_FAILURE_POSSIBLE
	else if(failure_penalties > 2)
		surgery_failure_chance = SURGERY_FAILURE_LIKELY

	play_preop_sound(user, target, target_zone, tool, surgery)

	if(tool?.flags_item & ANIMATED_SURGICAL_TOOL) //If we have an animated tool sprite, run it while we do any do_afters.
		tool.icon_state += "_on"

	if(try_to_fail)
		if(failure(user, target, target_zone, tool, tool_type, surgery)) //Disarm intent deliberately fails the step harmfully.
			advance = TRUE
			play_failure_sound(user, target, target_zone, tool, surgery)

	else if(target.stat == CONSCIOUS && prob(pain_failure_chance)) //Pain can cause a step to fail.
		do_after(user, max(rand(step_duration * 0.1, step_duration * 0.5), 0.5), INTERRUPT_ALL|INTERRUPT_DIFF_INTENT,
				BUSY_ICON_FRIENDLY, target, INTERRUPT_MOVED, BUSY_ICON_MEDICAL) //Brief do_after so that the pain interrupt doesn't happen instantly.
		to_chat(user, SPAN_DANGER("[target] moved during the surgery! Use anesthetics or painkillers!"))
		to_chat(target, SPAN_DANGER("The pain was too much, you couldn't hold still!"))
		if(failure(user, target, target_zone, tool, tool_type, surgery)) //Failure returns TRUE if the step should complete anyway.
			advance = TRUE
		target.emote("pain")
		play_failure_sound(user, target, target_zone, tool, surgery)

	else if(prob(surgery_failure_chance))
		do_after(user, max(rand(step_duration * 0.1, step_duration * 0.5), 0.5), INTERRUPT_ALL|INTERRUPT_DIFF_INTENT,
				BUSY_ICON_FRIENDLY, target, INTERRUPT_MOVED, BUSY_ICON_MEDICAL) //Brief do_after so that the interrupt doesn't happen instantly.
		user.visible_message(SPAN_DANGER("[user] is struggling to perform surgery."),
		SPAN_DANGER("You are struggling to perform the surgery with these tools and conditions!"))
		if(failure(user, target, target_zone, tool, tool_type, surgery)) //Failure returns TRUE if the step should complete anyway.
			advance = TRUE
		target.emote("pain")
		play_failure_sound(user, target, target_zone, tool, surgery)
		msg_admin_niche("[user] failed a [surgery] step on [target] because of [failure_penalties] failure possibility penalties ([surgery_failure_chance]%)")

	else //Help intent.
		if(do_after(user, step_duration, INTERRUPT_ALL|INTERRUPT_DIFF_INTENT, BUSY_ICON_FRIENDLY,target,INTERRUPT_MOVED,BUSY_ICON_MEDICAL))
			success(user, target, target_zone, tool, tool_type, surgery)
			SEND_SIGNAL(user, COMSIG_HUMAN_SURGERY_STEP_SUCCESS, target, surgery, tool)
			advance = TRUE
			play_success_sound(user, target, target_zone, tool, surgery)
			if(repeat_step && repeat_step_criteria(user, target, target_zone, tool, tool_type, surgery))
				surgery.step_in_progress = FALSE
				INVOKE_ASYNC(surgery, TYPE_PROC_REF(/datum/surgery, attempt_next_step), user, tool, TRUE)
				return TRUE
		else if(surgery.status != 1 && failure(user, target, target_zone, tool, tool_type, surgery)) //Failing the first step while on help intent doesn't risk harming the patient.
			advance = TRUE

	if(tool?.flags_item & ANIMATED_SURGICAL_TOOL) //Don't want to reset sprites on things like lighters, welding torches etc.
		tool.icon_state = initial(tool.icon_state)
		tool.update_icon() // in order to not reset shit too far.

	if(advance)
		if(skipped) //Skipped previous step.
			surgery.status += 2
		else
			surgery.status++
		if(surgery.status > length(surgery.steps))
			complete(target, surgery)

	else if(surgery.status == 1) //Aborting or unproductively failing the first step cancels the surgery.
		complete(target, surgery, TRUE)

	surgery.step_in_progress = FALSE
	return TRUE

///This is used for beginning-step narration. tool_type may be a typepath or simply '1'.
/datum/surgery_step/proc/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_NOTICE("[user] begins to perform surgery on [target]."),
		SPAN_NOTICE("You begin to perform surgery on [target]..."))

/// Plays Preop Sounds
/datum/surgery_step/proc/play_preop_sound(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!preop_sound)
		return
	playsound(get_turf(target), preop_sound, vol = 40, sound_range = 1)

///This is used for end-step narration and relevant success changes - whatever the step is meant to do, if it isn't just flavour. tool_type may be a typepath or simply '1'.
/datum/surgery_step/proc/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_NOTICE("[user] succeeds!"),
			SPAN_NOTICE("You succeed."))

/// Plays the selected success sound
/datum/surgery_step/proc/play_success_sound(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!success_sound)
		return
	playsound(get_turf(target), success_sound, vol = 40, sound_range = 1)

/**This is used for failed-step narration and relevant failure changes, often damage etc. If it returns TRUE, the step succeeds anyway.
tool_type may be a typepath or simply '1'. Note that a first step done on help-intent doesn't call failure(), it just ends harmlessly.**/
/datum/surgery_step/proc/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_NOTICE("[user] fails to finish the surgery"),
			SPAN_NOTICE("You fail to finish the surgery"))
	return FALSE

/// Plays the failure sound
/datum/surgery_step/proc/play_failure_sound(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!failure_sound)
		return
	playsound(get_turf(target), failure_sound, vol = 40, sound_range = 1)

///Finishes the surgery and removes it from the target's lists.
/datum/surgery_step/proc/complete(mob/living/carbon/target, datum/surgery/surgery, cancelled)
	target.active_surgeries[surgery.location] = null
