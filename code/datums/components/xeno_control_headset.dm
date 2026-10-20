/*
This component is for xenomorphs with a control headset grafted on.
*/

/datum/component/xeno_control_headset
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/being_controlled = FALSE
	var/mob/controlling_human
	var/obj/item/clothing/head/control_headset_xeno/xeno_set
	var/obj/item/clothing/head/control_headset_marine/controlling_set
	// 6 screens' worth of range
	var/maximum_range = 42
	var/point_slash_counter = 0
	/// Things that a human wouldn't be able to do when puppeting a xeno around. Removed on insertion of the headset.
	var/static/list/actions_to_remove = list(
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/secrete_resin,
		/datum/action/xeno_action/activable/transfer_plasma,
		/datum/action/xeno_action/onclick/autoweeding_toggle,
	)

/datum/component/xeno_control_headset/Initialize(obj/item/clothing/head/control_headset_xeno/xeno_set_arg)
	if(!isxeno(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/carbon/xenomorph/parent_xeno = parent
	// Remove things that a human controlling a xeno probably shouldn't be able to do
	// The headset installation is an irreversible process, and the creature is necessarily braindead anyways. So removing anything permanently isn't a problem.
	for(var/datum/action/action in parent_xeno.actions)
		if(action.type in actions_to_remove)
			remove_action(parent_xeno, action.type)

	parent_xeno.bubble_icon = "robot"
	parent_xeno.speaking_noise = 'sound/effects/radiostatic.ogg'

	// ???
	remove_verb(parent_xeno, /mob/living/carbon/xenomorph/verb/view_tacmaps)
	give_action(parent, /datum/action/lose_control)
	xeno_set = xeno_set_arg
	. = ..()

/datum/component/xeno_control_headset/RegisterWithParent()
	START_PROCESSING(SSdcs, src)
	RegisterSignal(parent, list(COMSIG_XENO_DEATH, COMSIG_XENO_CONTROL_HEADSET_UNCONTROL, COMSIG_ATOM_EMP_ACT), PROC_REF(lose_control))
	RegisterSignal(parent, COMSIG_XENO_CONTROL_HEADSET_CONTROL, PROC_REF(take_control))

	RegisterSignal(parent, COMSIG_LIVING_SPEAK, PROC_REF(handle_speech))

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
	SIGNAL_HANDLER
	point_slash_counter++
	if(point_slash_counter >= 10)
		point_gain(1)

// Every kill, give a bit of intel and research points
// Is there a better way to confirm a kill??
/datum/component/xeno_control_headset/proc/kill_points_gain(mob/corpse, datum/cause_data/cause, gibbed)
	SIGNAL_HANDLER
	// Check who actually killed 'em
	var/mob/murderer = cause.weak_mob.resolve()
	if(murderer != parent)
		return
	point_gain(3)

/datum/component/xeno_control_headset/proc/point_gain(point_multiplier = 1)
	var/intel_point_gain = OBJECTIVE_LOW_VALUE * point_multiplier
	var/datum/techtree/tree = GET_TREE(TREE_MARINE)
	tree.add_points(intel_point_gain)

	var/biomass_points_gain = 200 * point_multiplier
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_BIOMASS_GAIN, biomass_points_gain)
	to_chat(parent, SPAN_NOTICE("Your headset informs you that enough data has been acquired to increase intel and research points!"))
	// todo msgs

/datum/component/xeno_control_headset/proc/take_control(mob/parenter, mob/controller, obj/item/control_set)
	SIGNAL_HANDLER

	// todo check args to ensure controling set delivery

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

	RegisterSignal(controlling_human, list(COMSIG_MOB_DEATH, COMSIG_MOB_LOGOUT), PROC_REF(lose_control))
	RegisterSignal(xeno, COMSIG_MOVABLE_MOVED, PROC_REF(check_distance))

/datum/component/xeno_control_headset/proc/check_distance(mob/living/carbon/xenomorph/controlled_xeno)
	SIGNAL_HANDLER

	// this has become a lot more finicky since z-levels...
	if(controlled_xeno.z != controlling_human.z)
		lose_control()

	var/control_range = get_dist(controlled_xeno, controlling_human)

	if(control_range == maximum_range * 0.5)
		to_chat(controlled_xeno, SPAN_BOLDWARNING("Your headset's connection to your body is growing weak."))
	else if(control_range == maximum_range * 0.75)
		to_chat(controlled_xeno, SPAN_BOLDWARNING("Your headset's connection to your body is about to break!"))
	else if(control_range >= maximum_range)
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

	UnregisterSignal(controlling_human, COMSIG_MOB_DEATH)
	UnregisterSignal(controlled_xeno, COMSIG_MOVABLE_MOVED)

	being_controlled = FALSE
	controlling_human = null

/datum/component/xeno_control_headset/proc/handle_speech(name, message)
	SIGNAL_HANDLER
	var/mob/living/carbon/xenomorph/parent_xeno = parent

	var/list/mob/viewers = get_mobs_in_view(7, parent_xeno)
	parent_xeno.langchat_speech(message, viewers, controlling_human.get_default_language(), controlling_human.langchat_color, FALSE)
	to_chat(viewers, "[SPAN_BOLD("[parent_xeno]'s voice synthesizer says,")] \"[message]\"") // Someone removed the robot span so it doesn't get one.
	parent_xeno.show_speech_bubble(viewers, parent_xeno.bubble_icon + parent_xeno.say_test(message), bubble_prefix = TRUE)

	return COMPONENT_OVERRIDE_SPEAK
