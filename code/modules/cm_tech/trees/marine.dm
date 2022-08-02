GLOBAL_LIST_EMPTY(marine_leaders)

// THE MARINE TECH TREE
/datum/techtree/marine
	name = TREE_MARINE
	flags = TREE_FLAG_MARINE

	background_icon_locked = "marine"

	var/mob/living/carbon/human/leader
	var/mob/living/carbon/human/dead_leader
	var/job_cannot_be_overriden = list(
		JOB_XO,
		JOB_CO
	)

	var/faction = FACTION_MARINE

/datum/techtree/marine/New()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_POST_SETUP, .proc/setup_leader)

/datum/techtree/marine/proc/setup_leader(datum/source)
	SIGNAL_HANDLER
	if(length(GLOB.marine_leaders))
		var/mob/M = GLOB.marine_leaders[JOB_CO]
		if(!M)
			M = GLOB.marine_leaders[JOB_XO]
		if(M)
			transfer_leader_to(M)

/datum/techtree/marine/generate_tree()
	. = ..()
	for(var/i in GLOB.tech_controls_marine)
		var/obj/structure/machinery/computer/tech_control/TC = i
		TC.attached_tree = src

/datum/techtree/marine/has_access(var/mob/M, var/access_required)
	switch(access_required)
		if(TREE_ACCESS_VIEW)
			if(M.faction == faction)
				return TRUE
		if(TREE_ACCESS_MODIFY)
			if(skillcheck(M, SKILL_INTEL, SKILL_INTEL_TRAINED))
				return TRUE

	return FALSE

/datum/techtree/marine/can_attack(var/mob/living/carbon/H)
	return !ishuman(H)

/datum/techtree/marine/proc/transfer_leader_to(var/mob/living/carbon/human/H)
	if(!H)
		return
	remove_leader()

	RegisterSignal(H, COMSIG_MOVABLE_MOVED, .proc/handle_zlevel_check)
	RegisterSignal(H, COMSIG_MOB_DEATH, .proc/handle_death)

	leader = H

/datum/techtree/marine/proc/remove_leader()
	if(!leader)
		return
	UnregisterSignal(leader, list(
		COMSIG_MOB_DEATH,
		COMSIG_MOVABLE_MOVED
	))
	leader = null

/datum/techtree/marine/proc/handle_death(var/mob/living/carbon/human/H)
	SIGNAL_HANDLER
	if((H.job in job_cannot_be_overriden) && (!dead_leader || !dead_leader.check_tod()))
		RegisterSignal(H, COMSIG_PARENT_QDELETING, .proc/cleanup_dead_leader)
		RegisterSignal(H, COMSIG_HUMAN_REVIVED, .proc/readd_leader)
		dead_leader = H
	remove_leader()

/datum/techtree/marine/proc/cleanup_dead_leader(var/mob/living/carbon/human/H)
	SIGNAL_HANDLER
	if(dead_leader == H)
		dead_leader = null

/datum/techtree/marine/proc/readd_leader(var/mob/living/carbon/human/H)
	SIGNAL_HANDLER
	if(H != dead_leader)
		stack_trace("Non-leader attempted to be re-added back to command.")
		return
	remove_dead_leader()
	transfer_leader_to(H)

/datum/techtree/marine/proc/handle_zlevel_check(var/mob/living/carbon/human/H)
	SIGNAL_HANDLER
	if(!is_mainship_level(H.z))
		remove_leader()

/datum/techtree/marine/proc/remove_dead_leader()
	if(!dead_leader)
		return

	UnregisterSignal(dead_leader, list(
		COMSIG_HUMAN_REVIVED,
		COMSIG_PARENT_QDELETING
	))
	dead_leader = null

GLOBAL_LIST_EMPTY(tech_controls_marine)

/obj/structure/machinery/computer/tech_control
	name = "tech control console"
	desc = "A console used to make tech purchases."

	icon_state = "techweb"

	req_access = list(ACCESS_MARINE_BRIDGE)
	density = TRUE
	anchored = TRUE
	wrenchable = FALSE

	var/datum/techtree/marine/attached_tree

/obj/structure/machinery/computer/tech_control/Initialize()
	. = ..()
	GLOB.tech_controls_marine += src
	if(SStechtree.initialized)
		attached_tree = GET_TREE(TREE_MARINE)

/obj/structure/machinery/computer/tech_control/Destroy()
	GLOB.tech_controls_marine -= src
	attached_tree = null
	return ..()

// Disallow deconstructing
/obj/structure/machinery/computer/tech_control/attackby(obj/item/I, mob/user)
	return

/obj/structure/machinery/computer/tech_control/attack_hand(var/mob/M)
	. = ..()

	if(!skillcheck(M, SKILL_INTEL, SKILL_INTEL_TRAINED) && SSmapping.configs[GROUND_MAP].map_name != MAP_WHISKEY_OUTPOST)
		to_chat(M, SPAN_WARNING("You don't have the training to use \the [src]."))
		return

	if(!attached_tree)
		return

	var/datum/techtree/tree = GET_TREE(TREE_MARINE)
	tree.enter_mob(usr, FALSE)

/obj/structure/machinery/computer/view_objectives
	name = "Intel Database Computer"
	desc = "An USCM Intel Computer for consulting the current Intel database."
	icon_state = "terminal1_old"
	unslashable = TRUE
	unacidable = TRUE


/obj/structure/machinery/computer/view_objectives/attack_hand(mob/living/user)
	if(!user || !istype(user) || !user.mind || !user.mind.objective_memory)
		return FALSE
	if(!powered())
		to_chat(user, SPAN_WARNING("This computer has no power!"))
		return FALSE
	if(!intel_system)
		to_chat(user, SPAN_WARNING("The computer doesn't seem to be connected to anything..."))
		return FALSE
	if(user.action_busy)
		return FALSE

	user.mind.view_objective_memories(src)

/datum/techtree/marine/on_tier_change(datum/tier/oldtier)
	if(tier.tier < 2)
		return //No need to announce tier updates for tier 1
	var/name = "ALMAYER DEFCON LEVEL INCREASED"
	var/input = "THREAT ASSESSMENT LEVEL INCREASED TO LEVEL [tier.tier].\n\nLEVEL [tier.tier] assets have been authorised to handle the situation."
	marine_announcement(input, name, 'sound/AI/commandreport.ogg')
