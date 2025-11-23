/*
This component is for xenomorphs with a control headset grafted on.
*/

GLOBAL_LIST_EMPTY_TYPED(controlled_xenos, /mob/living/carbon/xenomorph)

/datum/component/xeno_control_headset
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/being_controlled = FALSE
	var/mob/controlling_human
	// 4 screens' worth of range
	var/maximum_range = 28

/datum/component/xeno_control_headset/Initialize()
	if(!isxeno(parent))
		return COMPONENT_INCOMPATIBLE
	GLOB.controlled_xenos += parent
	give_action(parent, /datum/action/lose_control)
	. = ..()

/datum/component/xeno_control_headset/RegisterWithParent()
	START_PROCESSING(SSdcs, src)
	RegisterSignal(parent, list(COMSIG_XENO_DEATH, COMSIG_XENO_CONTROL_HEADSET_UNCONTROL, COMSIG_ATOM_EMP_ACT), PROC_REF(lose_control))
	RegisterSignal(parent, COMSIG_XENO_CONTROL_HEADSET_CONTROL, PROC_REF(take_control))

/datum/component/xeno_control_headset/UnregisterFromParent()
	STOP_PROCESSING(SSdcs, src)
	UnregisterSignal(parent, list(
		COMSIG_XENO_DEATH,
		COMSIG_XENO_CONTROL_HEADSET_CONTROL,
		COMSIG_XENO_CONTROL_HEADSET_UNCONTROL,
		COMSIG_ATOM_EMP_ACT,
	))

/datum/component/xeno_control_headset/proc/take_control(mob/parenter, mob/controller)
	SIGNAL_HANDLER

	var/mob/living/carbon/xenomorph/xeno = parent
	if(being_controlled)
		to_chat(controller, SPAN_NOTICE("[xeno] is already being controlled_xeno by [controlling_human]."))
		return

	controlling_human = controller
	being_controlled = TRUE

	controlling_human.mind.transfer_to(xeno, TRUE)
	to_chat(xeno, SPAN_XENONOTICE("You have taken control of [xeno]."))
	ADD_TRAIT(parent, TRAIT_XENO_CONTROLLED, REF(src))

	RegisterSignal(controlling_human, list(COMSIG_MOB_DEATH), PROC_REF(lose_control))
	RegisterSignal(xeno, COMSIG_MOVABLE_MOVED, PROC_REF(check_distance))

/datum/component/xeno_control_headset/proc/check_distance(mob/living/carbon/xenomorph/controlled_xeno)
	SIGNAL_HANDLER

	// bro
	if(controlled_xeno.z != controlling_human.z)
		lose_control()

	switch(get_dist(controlled_xeno, controlling_human))
		if(maximum_range * 0.5)
			to_chat(controlled_xeno, SPAN_BOLDWARNING("Your headset's connection to your body is growing weak."))
		if(maximum_range * 0.75)
			to_chat(controlled_xeno, SPAN_BOLDWARNING("Your headset's connection to your body is about to break!"))
		if(maximum_range to INFINITY)
			to_chat(controlled_xeno, SPAN_BOLDWARNING("You've lost your connection to this body!"))
			lose_control()

/datum/component/xeno_control_headset/proc/lose_control()
	SIGNAL_HANDLER

	if(!being_controlled)
		return

	// what if they gib??
	var/mob/living/carbon/xenomorph/controlled_xeno = parent
	controlled_xeno.mind.transfer_to(controlling_human, TRUE)
	REMOVE_TRAIT(controlled_xeno, TRAIT_XENO_CONTROLLED, REF(src))
	to_chat(controlling_human, SPAN_NOTICE("You have lost control of [controlled_xeno]!"))
	being_controlled = FALSE
	controlling_human = null
