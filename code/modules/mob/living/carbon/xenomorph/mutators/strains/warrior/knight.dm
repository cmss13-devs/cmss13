/datum/xeno_mutator/knight
	name = "STRAIN: Warrior - Knight"
	description = "You forfeit all your abilities and ways to pummel hosts into oblivion and instead gain the powerful ability to face them al head-on, for a time."
	flavor_description = "With fealty, loyalty, and a thorough application of your claws, there is nothing that can oppose you."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_WARRIOR) //Only warrior.
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/warrior_punch,
		/datum/action/xeno_action/activable/lunge,
		/datum/action/xeno_action/activable/fling
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/tail_stab/tail_trip,
		/datum/action/xeno_action/activable/pike, //evolving should kill ur node
		/datum/action/xeno_action/onclick/bulwark, //design doc. can leap around marines, be a cqc menace, run around them?. passflags dont work
		/datum/action/xeno_action/activable/pounce/leap,
		/datum/action/xeno_action/activable/plant_holdfast
	)
	behavior_delegate_type = /datum/behavior_delegate/warrior_knight
	keystone = TRUE

/datum/xeno_mutator/knight/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (!.)
		return

	var/mob/living/carbon/Xenomorph/Warrior/Knight = MS.xeno
	Knight.speed_modifier -= XENO_SPEED_FASTMOD_TIER_1
	Knight.health_modifier += XENO_HEALTH_MOD_SMALL
	Knight.armor_modifier += XENO_ARMOR_MOD_SMALL
	Knight.claw_type = CLAW_TYPE_SHARP
	mutator_update_actions(Knight)
	MS.recalculate_actions(description, flavor_description)
	Knight.recalculate_everything()

	Knight.mutation_type = WARRIOR_KNIGHT
	GLOB.living_knight_list += WEAKREF(Knight)

	apply_behavior_delegate(Knight)
	var/datum/behavior_delegate/warrior_knight/knight_delegate = Knight.behavior_delegate
	Knight.RegisterSignal(knight_delegate, list(COMSIG_MOB_DEATH, COMSIG_PARENT_QDELETING), /datum/behavior_delegate/warrior_knight/.proc/remove_ref)
	Knight.RegisterSignal(Knight, list(COMSIG_MOVABLE_MOVED,COMSIG_HOLDFAST_NODE_PULSE), /mob/living/carbon/Xenomorph/Warrior/.proc/delegate_handler)
	//knight_delegate.RegisterSignal(knight_delegate, COMSIG_HOLDFAST_NODE_PULSE, /datum/behavior_delegate/warrior_knight/.proc/check_node_buff)

/datum/behavior_delegate/warrior_knight/proc/remove_ref()
	SIGNAL_HANDLER
	GLOB.living_knight_list -= WEAKREF(bound_xeno)

/mob/living/carbon/Xenomorph/Warrior/proc/delegate_handler()
	SIGNAL_HANDLER
	var/datum/behavior_delegate/warrior_knight/knight_delegate = src.behavior_delegate
	knight_delegate.check_node_buff()

	// We check if the woyar has ran off from node distance
/datum/behavior_delegate/warrior_knight/proc/check_node_buff()
	SIGNAL_HANDLER

	var/passed_dist_check = FALSE
	var/mob/living/carbon/Xenomorph/Warrior/Knight = bound_xeno

	var/obj/effect/alien/resin/special/recovery/holdfast/holdfast_node
	for(var/datum/weakref/ref as anything in GLOB.existing_holdfast_list)
		holdfast_node = ref.resolve()

		if(!holdfast_node || QDELETED(holdfast_node))
			GLOB.existing_holdfast_list -= WEAKREF(holdfast_node)
			continue

		// if they're near the holdfast node, stop iterating through the existing nodes as it's meaningless now
		if(get_dist(Knight, holdfast_node) <= 4)
			if(abilities_enhanced == FALSE)
				buff()
				holdfast_node.buff_fx()
			passed_dist_check = TRUE // no matter what at this point we know the check passed
			break

	if(passed_dist_check == FALSE && abilities_enhanced == TRUE) //if they werent near ANY nodes... remove the buff (if applicable)
		debuff()
		if(!isnull(bound_node)) //this happens cuz it's sent inmediately afted destroy override nulls it FIX IT!!
			holdfast_node.debuff_fx()

/datum/behavior_delegate/warrior_knight // caste color - cyan? find smth that matches woyer purple?
	name = "Warrior Knight Behavior Delegate"

	 /// If the Knight has chess-leaped onto a victim - they have been owned and will be stomped on. This var is jank meant to bypass bad pounce code.
	var/owned = FALSE

	 /// If the Knight is near a holdfast node, and thus has had its abilities enhanced.
	var/abilities_enhanced = FALSE

	 /// The Knight's placed holdfast node, variable is used to make sure it can only place one.
	var/obj/effect/alien/resin/special/recovery/holdfast/bound_node
	COOLDOWN_DECLARE(toggle_msg_cd) // 20 SECONDS - reduces chat spam

/datum/behavior_delegate/warrior_knight/proc/buff()

	abilities_enhanced = TRUE

	if(COOLDOWN_FINISHED(src, toggle_msg_cd))
		bound_xeno.visible_message(SPAN_DANGER("\The [bound_xeno] begins faintly glowing a dull cyan."), SPAN_DANGER("A zealous feeling comes over you as you approach the holdfast node. Your abilities are now enhanced."))
		COOLDOWN_START(src, toggle_msg_cd, 14 SECONDS)
	var/color = "#4ADBC1"
	var/alpha = 30
	color += num2text(alpha, 2, 16)
	bound_xeno.add_filter("holdfast_buff", 1, list("type" = "outline", "color" = color, "size" = 2))

/datum/behavior_delegate/warrior_knight/proc/debuff()

	abilities_enhanced = FALSE

	if(COOLDOWN_FINISHED(src, toggle_msg_cd))
		bound_xeno.visible_message(SPAN_DANGER("\The [bound_xeno] ceases glowing."), SPAN_DANGER("Your feeling of ardor dissipates. Your abilities weaken and are no longer enhanced."))
		COOLDOWN_START(src, toggle_msg_cd, 14 SECONDS)
	bound_xeno.remove_filter("holdfast_buff")
