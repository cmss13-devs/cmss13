/*
This component is for xenomorphs with a control headset grafted on.
*/

GLOBAL_LIST_EMPTY_TYPED(controlled_xenos, /mob/living/carbon/xenomorph)

/datum/component/xeno_control_headset
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/being_controlled = FALSE
	var/mob/controlling_human
	var/obj/item/clothing/head/control_headset_marine/controlling_set
	// 4 screens' worth of range without a tower
	var/maximum_range = 28
	var/point_slash_counter = 0

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

	// These signals are for gathering intel and research points.
	RegisterSignal(parent, COMSIG_XENO_ALIEN_ATTACK, PROC_REF(slashing_point_gain))
	RegisterSignal(SSdcs, COMSIG_GLOB_XENO_DEATH, PROC_REF(kill_points_gain))

/datum/component/xeno_control_headset/UnregisterFromParent()
	STOP_PROCESSING(SSdcs, src)
	UnregisterSignal(parent, list(
		COMSIG_XENO_DEATH,
		COMSIG_XENO_CONTROL_HEADSET_CONTROL,
		COMSIG_XENO_CONTROL_HEADSET_UNCONTROL,
		COMSIG_ATOM_EMP_ACT,
	))

// Every 10 xeno-on-xeno slashes, give a smidgen of intel and research points
/datum/component/xeno_control_headset/proc/slashing_point_gain(mob/parenter)
	point_slash_counter++
	if(point_slash_counter >= 10)
		point_gain(1)

// Every kill, give a bit of intel and research points
// Is there a better way to confirm a kill??
/datum/component/xeno_control_headset/proc/kill_points_gain(mob/corpse, datum/cause_data/cause, gibbed)
	// Check who actually killed 'em
	var/mob/murderer = cause.weak_mob.resolve()
	if(murderer != parent)
		return
	point_gain(3)

/datum/component/xeno_control_headset/proc/point_gain(point_multiplier = 1)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_SEND_RELAY_POINTS, point_multiplier)

/datum/component/xeno_control_headset/proc/take_control(mob/parenter, mob/controller, obj/item/control_set)
	SIGNAL_HANDLER

	var/mob/living/carbon/xenomorph/xeno = parent
	if(being_controlled)
		to_chat(controller, SPAN_NOTICE("[xeno] is already being controlled_xeno by [controlling_human]."))
		return

	controlling_human = controller
	controlling_set = control_set
	being_controlled = TRUE

	controlling_human.mind.transfer_to(xeno, TRUE)
	to_chat(xeno, SPAN_XENONOTICE("You have taken control of [xeno]."))
	ADD_TRAIT(parent, TRAIT_XENO_CONTROLLED, REF(src))

	RegisterSignal(controlling_human, list(COMSIG_MOB_DEATH), PROC_REF(lose_control))
	RegisterSignal(xeno, COMSIG_MOVABLE_MOVED, PROC_REF(check_distance))

/datum/component/xeno_control_headset/proc/check_distance(mob/living/carbon/xenomorph/controlled_xeno)
	SIGNAL_HANDLER

	var/true_max_range = maximum_range
	if(controlling_set.connected_tower)
		true_max_range = maximum_range * controlling_set.connected_tower.range_boost

	// bro
	if(controlled_xeno.z != controlling_human.z)
		lose_control()

	var/control_range = get_dist(controlled_xeno, controlling_human)

	if(control_range == true_max_range * 0.5)
		to_chat(controlled_xeno, SPAN_BOLDWARNING("Your headset's connection to your body is growing weak."))
	else if(control_range == true_max_range * 0.75)
		to_chat(controlled_xeno, SPAN_BOLDWARNING("Your headset's connection to your body is about to break!"))
	else if(control_range >= true_max_range)
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
