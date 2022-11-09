/datum/action/xeno_action/onclick/deevolve
	name = "De-Evolve a Xenomorph (500)"
	action_icon_state = "xeno_deevolve"
	plasma_cost = 500

/datum/action/xeno_action/onclick/remove_eggsac
	name = "Remove Eggsac"
	action_icon_state = "grow_ovipositor"
	plasma_cost = 0

/datum/action/xeno_action/onclick/grow_ovipositor
	name = "Grow Ovipositor (500)"
	action_icon_state = "grow_ovipositor"
	plasma_cost = 500
	xeno_cooldown = 5 MINUTES
	cooldown_message = "You are ready to grow an ovipositor again."
	no_cooldown_msg = FALSE // Needed for onclick actions

/datum/action/xeno_action/onclick/set_xeno_lead
	name = "Choose/Follow Xenomorph Leaders"
	action_icon_state = "xeno_lead"
	plasma_cost = 0
	xeno_cooldown = 3 SECONDS

/datum/action/xeno_action/activable/queen_heal
	name = "Heal Xenomorph (600)"
	action_icon_state = "heal_xeno"
	ability_name = "xenomorph heal"
	plasma_cost = 600
	macro_path = /datum/action/xeno_action/verb/verb_heal_xeno
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 8 SECONDS

/datum/action/xeno_action/activable/expand_weeds
	name = "Expand Weeds (50)"
	action_icon_state = "plant_weeds"
	ability_name = "weed expansion"
	plasma_cost = 50
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 0.5 SECONDS

	var/node_plant_cooldown = 7 SECONDS
	var/node_plant_plasma_cost = 300
	var/turf_build_cooldown = 7 SECONDS

/datum/action/xeno_action/onclick/banish
	name = "Banish a Xenomorph (500)"
	action_icon_state = "xeno_banish"
	plasma_cost = 500

/datum/action/xeno_action/onclick/readmit
	name = "Readmit a Xenomorph (100)"
	action_icon_state = "xeno_readmit"
	plasma_cost = 100

/datum/action/xeno_action/activable/secrete_resin/remote/queen
	name = "Projected Resin (100)"
	action_icon_state = "secrete_resin"
	ability_name = "projected resin"
	plasma_cost = 100
	xeno_cooldown = 2 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_5

	care_about_adjacency = FALSE
	build_speed_mod = 1

	var/boosted = FALSE

/datum/action/xeno_action/activable/secrete_resin/remote/queen/give_to(mob/L)
	. = ..()
	SSticker.OnRoundstart(CALLBACK(src, .proc/apply_queen_build_boost))

/datum/action/xeno_action/activable/secrete_resin/remote/queen/proc/apply_queen_build_boost()
	var/boost_duration = 30 MINUTES
	// In the event secrete_resin is given after round start
	if(SSticker.round_start_time)
		boost_duration = (30 MINUTES) - (world.time - SSticker.round_start_time)
	if(boost_duration > 0)
		boosted = TRUE
		xeno_cooldown = 0
		plasma_cost = 0
		RegisterSignal(owner, COMSIG_XENO_THICK_RESIN_BYPASS, .proc/override_secrete_thick_resin)
		addtimer(CALLBACK(src, .proc/disable_boost), boost_duration)

/datum/action/xeno_action/activable/secrete_resin/remote/queen/proc/disable_boost()
	xeno_cooldown = 2 SECONDS
	plasma_cost = 100
	boosted = FALSE
	UnregisterSignal(owner, COMSIG_XENO_THICK_RESIN_BYPASS)

	if(owner)
		to_chat(owner, SPAN_XENODANGER("Your boosted building has been disabled!"))

/datum/action/xeno_action/activable/secrete_resin/remote/queen/proc/override_secrete_thick_resin()
	return COMPONENT_THICK_BYPASS

/datum/action/xeno_action/activable/bombard/queen
	// Range and other config
	interrupt_flags = NO_FLAGS
	xeno_cooldown = 4 SECONDS

	charges = 0

/datum/action/xeno_action/activable/bombard/queen/give_to(mob/living/carbon/Xenomorph/Queen/Q)
	. = ..()
	if(!Q.ovipositor)
		hide_from(Q)
	RegisterSignal(Q, COMSIG_QUEEN_MOUNT_OVIPOSITOR, .proc/handle_mount_ovipositor)
	RegisterSignal(Q, COMSIG_QUEEN_DISMOUNT_OVIPOSITOR, .proc/handle_dismount_ovipositor)

/datum/action/xeno_action/activable/bombard/queen/remove_from(mob/living/carbon/Xenomorph/X)
	. = ..()
	UnregisterSignal(X, list(
		COMSIG_QUEEN_MOUNT_OVIPOSITOR,
		COMSIG_QUEEN_DISMOUNT_OVIPOSITOR,
	))

/datum/action/xeno_action/activable/bombard/queen/proc/handle_mount_ovipositor(mob/living/carbon/Xenomorph/Queen/Q)
	SIGNAL_HANDLER
	unhide_from(Q)

/datum/action/xeno_action/activable/bombard/queen/proc/handle_dismount_ovipositor(mob/living/carbon/Xenomorph/Queen/Q)
	SIGNAL_HANDLER
	hide_from(Q)

/datum/action/xeno_action/activable/bombard/queen/get_bombard_source()
	var/mob/hologram/queen/H = owner?.client?.eye
	if(istype(H))
		return H
	return owner

/datum/action/xeno_action/activable/place_queen_beacon
	name = "Place Queen Beacon"
	action_icon_state = "place_queen_beacon"
	ability_name = "place queen beacon"
	plasma_cost = 0
	action_type = XENO_ACTION_CLICK

	charges = 0

	var/datum/hive_status/hive
	var/list/transported_xenos

/datum/action/xeno_action/activable/place_queen_beacon/give_to(mob/living/carbon/Xenomorph/Queen/Q)
	. = ..()
	hive = Q.hive
	if(!Q.ovipositor)
		hide_from(Q)
	RegisterSignal(Q, COMSIG_QUEEN_MOUNT_OVIPOSITOR, .proc/handle_mount_ovipositor)
	RegisterSignal(Q, COMSIG_QUEEN_DISMOUNT_OVIPOSITOR, .proc/handle_dismount_ovipositor)

/datum/action/xeno_action/activable/place_queen_beacon/remove_from(mob/living/carbon/Xenomorph/X)
	. = ..()
	hive = null
	UnregisterSignal(X, list(
		COMSIG_QUEEN_MOUNT_OVIPOSITOR,
		COMSIG_QUEEN_DISMOUNT_OVIPOSITOR,
	))

/datum/action/xeno_action/activable/place_queen_beacon/proc/handle_mount_ovipositor(mob/living/carbon/Xenomorph/Queen/Q)
	SIGNAL_HANDLER
	unhide_from(Q)

/datum/action/xeno_action/activable/place_queen_beacon/proc/handle_dismount_ovipositor(mob/living/carbon/Xenomorph/Queen/Q)
	SIGNAL_HANDLER
	hide_from(Q)


/datum/action/xeno_action/activable/blockade
	name = "Place Blockade"
	action_icon_state = "place_blockade"
	ability_name = "place blockade"
	plasma_cost = 300
	action_type = XENO_ACTION_CLICK

	var/obj/effect/alien/resin/resin_pillar/pillar_type = /obj/effect/alien/resin/resin_pillar
	var/time_taken = 6 SECONDS
	charges = 0

	var/brittle_time = 45 SECONDS
	var/decay_time = 45 SECONDS

/datum/action/xeno_action/activable/blockade/give_to(mob/living/carbon/Xenomorph/Queen/Q)
	. = ..()
	if(!Q.ovipositor)
		hide_from(Q)
	RegisterSignal(Q, COMSIG_QUEEN_MOUNT_OVIPOSITOR, .proc/handle_mount_ovipositor)
	RegisterSignal(Q, COMSIG_QUEEN_DISMOUNT_OVIPOSITOR, .proc/handle_dismount_ovipositor)

/datum/action/xeno_action/activable/blockade/remove_from(mob/living/carbon/Xenomorph/X)
	. = ..()
	UnregisterSignal(X, list(
		COMSIG_QUEEN_MOUNT_OVIPOSITOR,
		COMSIG_QUEEN_DISMOUNT_OVIPOSITOR,
	))

/datum/action/xeno_action/activable/blockade/proc/handle_mount_ovipositor(mob/living/carbon/Xenomorph/Queen/Q)
	SIGNAL_HANDLER
	unhide_from(Q)

/datum/action/xeno_action/activable/blockade/proc/handle_dismount_ovipositor(mob/living/carbon/Xenomorph/Queen/Q)
	SIGNAL_HANDLER
	hide_from(Q)
