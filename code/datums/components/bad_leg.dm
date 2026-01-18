//not variables to save on overhead

#define MESSAGE_COOLDOWN 1.5 SECONDS

/// Maximum amount of steps you can take until you get stunned from pain.
#define MAX_STEPS 30

/datum/component/bad_leg
	dupe_mode = COMPONENT_DUPE_UNIQUE
	/// Tracker for steps walked.
	var/steps_walking
	/// Holds the last time a message was sent to prevent spam.
	var/last_message_time
	/// The bound action to reduce steps tracker.
	var/datum/action/human_action/rest_legs/bound_action
	/// Bound human.
	var/mob/living/carbon/human/parent_human
	/// Bound limb.
	var/obj/limb/affected_limb

/datum/component/bad_leg/Initialize(forced_limb)
	. = ..()
	parent_human = parent
	if(!istype(parent_human))
		return COMPONENT_INCOMPATIBLE

	var/chosen_leg = forced_limb ? forced_limb : "l_leg" // always left leg by default first because i'm lazy and dont know how to add options to quirks
	affected_limb = parent_human.get_limb(chosen_leg)
	if(!affected_limb || affected_limb.status & LIMB_ROBOT)
		chosen_leg = "r_leg"
		affected_limb = parent_human.get_limb(chosen_leg)
	if(!affected_limb || affected_limb.status & LIMB_ROBOT)
		to_chat(parent_human, SPAN_NOTICE("You feel a strange, uncomfortable phantom sensation where your [chosen_leg] used to be."))
		qdel(src)

/datum/component/bad_leg/Destroy(force, silent)
	handle_qdel()
	. = ..()


/datum/component/bad_leg/RegisterWithParent()
	..()
	RegisterSignal(parent_human, COMSIG_MOVABLE_MOVED, PROC_REF(stumble))
	RegisterSignal(parent_human, COMSIG_PARENT_QDELETING, PROC_REF(handle_qdel))
	give_action(parent_human, /datum/action/human_action/rest_legs, null, null, src)

/datum/component/bad_leg/proc/handle_qdel()
	SIGNAL_HANDLER
	QDEL_NULL(bound_action)
	parent_human = null
	affected_limb = null

/datum/component/bad_leg/UnregisterFromParent()
	..()
	if(parent_human)
		UnregisterSignal(parent_human, COMSIG_MOVABLE_MOVED, PROC_REF(stumble))
		bound_action?.unique_remove_action(parent_human, /datum/action/human_action/rest_legs, src)


/datum/component/bad_leg/proc/stumble(mob/living/carbon/human/parent_human)
	SIGNAL_HANDLER

	///This prevents weird shit like corpses being dragged triggering the messages.
	if(parent_human.stat || parent_human.buckled && !HAS_TRAIT(parent_human, TRAIT_USING_WHEELCHAIR) || parent_human.is_mob_incapacitated() || parent_human.is_mob_restrained())
		return

	if(parent_human.throwing == TRUE)
		return // unaffected on throws

	if(HAS_TRAIT(parent_human, TRAIT_USING_WHEELCHAIR))
		if(last_message_time + MESSAGE_COOLDOWN * 10 < world.time) //longer cooldown if using wheelchairs.
			parent_human.visible_message(SPAN_NOTICE("[parent_human] wheels \himself with \his wheelchair."), SPAN_NOTICE("Your wheelchair lets you move while resting your [affected_limb.display_name], lessening the suffering on it."))
			last_message_time = world.time
		steps_walking = max(steps_walking - 1, 0)
		return

	if(HAS_TRAIT(parent_human, TRAIT_HOLDS_CANE))
		if(last_message_time + MESSAGE_COOLDOWN * 10 < world.time) //longer cooldown if using canes
			parent_human.visible_message(SPAN_NOTICE("[parent_human] paces \his movement with \his cane."), SPAN_NOTICE("Your cane lets you pace your movement, lessening the suffering on your [affected_limb.display_name]."))
			last_message_time = world.time
		steps_walking = max(steps_walking - 1, 0)
		return

	steps_walking++

	switch(steps_walking)
		if(MAX_STEPS * 0.3 to MAX_STEPS * 0.6)
			if(last_message_time + MESSAGE_COOLDOWN < world.time)
				to_chat(parent_human, SPAN_WARNING("Your damaged [affected_limb.display_name] skips half a step as you lose control of it from the increasing pain."))
				last_message_time = world.time
		if(MAX_STEPS * 0.6 to MAX_STEPS - 1)
			if(last_message_time + MESSAGE_COOLDOWN < world.time)
				to_chat(parent_human, SPAN_DANGER("You stumble for an agonizing moment as your [affected_limb.display_name] rebels against you. You feel like you need to take a breath before walking again."))
				last_message_time = world.time
		if(MAX_STEPS to INFINITY)
			to_chat(parent_human, SPAN_HIGHDANGER("Your [affected_limb.display_name] jerks wildly from incoherent pain!"))
			steps_walking = POSITIVE(steps_walking - MAX_STEPS * 0.3) //pity reduction
			INVOKE_ASYNC(parent_human, TYPE_PROC_REF(/mob/living/carbon/human, emote), "pain")
			var/stun_time = 2.5
			parent_human.Shake(pixelshiftx = 32, pixelshifty = 0, duration = stun_time SECONDS)
			parent_human.apply_effect(stun_time, STUN)
			addtimer(CALLBACK(src, PROC_REF(rest_legs_pain), parent_human, FALSE), stun_time SECONDS)
			return

	INVOKE_ASYNC(src, PROC_REF(rest_legs), parent_human, FALSE)

/datum/component/bad_leg/proc/rest_legs_pain(mob/living/parent_human, action = FALSE)
	to_chat(parent_human, SPAN_NOTICE("You can move again, but you should probably rest for a bit."))
	rest_legs(parent_human, action)

/datum/component/bad_leg/proc/rest_legs(mob/living/parent_human, action = FALSE)

	if(!steps_walking)
		bound_action.in_use = FALSE
		if(!action)
			return FALSE
		to_chat(parent_human, SPAN_WARNING("Your [affected_limb.display_name] seems to be as stable as it's going to get."))
		return FALSE

	var/show_icon = action ? BUSY_ICON_FRIENDLY : NO_BUSY_ICON
	bound_action.in_use = TRUE
	if(!do_after(parent_human, 1.5 SECONDS, INTERRUPT_MOVED, show_icon))
		bound_action.in_use = FALSE
		if(!action)
			return FALSE
		to_chat(parent_human, SPAN_WARNING("You need to stand still to rest your [affected_limb.display_name] for a moment."))
		return FALSE

	if(action)
		to_chat(parent_human, SPAN_HELPFUL("The pain in your [affected_limb.display_name] [ (steps_walking > MAX_STEPS * 0.3) ? "slightly abates" : "subsides"] after your short rest."))
	steps_walking = max(steps_walking - MAX_STEPS * 0.3, 0)
	bound_action.in_use = FALSE
	rest_legs(parent_human, action)
	return TRUE

/datum/action/human_action/rest_legs
	name = "Rest Leg"
	action_icon_state = "stumble"
	var/in_use = FALSE
	var/datum/component/bad_leg/bound_component

/datum/action/human_action/rest_legs/New(target, override_icon_state, datum/component/bad_leg/bound_component)
	. = ..()
	if(bound_component)
		name = "Rest [bound_component.affected_limb.display_name]"
		src.bound_component = bound_component
		src.bound_component.bound_action = src
	else
		CRASH("No bound wound to link action")

/datum/action/human_action/rest_legs/action_activate()
	. = ..()
	var/mob/living/carbon/human/homan = owner
	if(in_use)
		to_chat(homan, SPAN_WARNING("You're already doing that!"))
		return
	in_use = bound_component.rest_legs(homan, TRUE)

// Needs unique remove action due to possibility of two of these on the same mob.
/datum/action/human_action/rest_legs/proc/unique_remove_action(mob/mob, action_path, datum/component/bad_leg/bound_component)
	for(var/datum/action/acton as anything in mob.actions)
		if(acton.type == action_path && src.bound_component == bound_component)
			acton.remove_from(mob)
			return acton

#undef MESSAGE_COOLDOWN

#undef MAX_STEPS
