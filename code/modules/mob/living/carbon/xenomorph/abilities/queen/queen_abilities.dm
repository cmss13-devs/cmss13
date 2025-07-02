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
	plasma_cost = 600
	macro_path = /datum/action/xeno_action/verb/verb_heal_xeno
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 8 SECONDS

/datum/action/xeno_action/onclick/screech
	name = "Screech (250)"
	action_icon_state = "screech"
	macro_path = /datum/action/xeno_action/verb/verb_screech
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 50 SECONDS
	plasma_cost = 250
	cooldown_message = "You feel your throat muscles vibrate. You are ready to screech again."
	no_cooldown_msg = FALSE // Needed for onclick actions
	ability_primacy = XENO_SCREECH

/datum/action/xeno_action/onclick/queen_tacmap
	name = "View Xeno Tacmap"
	action_icon_state = "toggle_queen_zoom"
	plasma_cost = 0


/datum/action/xeno_action/activable/queen_give_plasma
	name = "Give Plasma (400)"
	action_icon_state = "queen_give_plasma"
	plasma_cost = 400
	macro_path = /datum/action/xeno_action/verb/verb_plasma_xeno
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 12 SECONDS

/datum/action/xeno_action/onclick/queen_word
	name = "Word of the Queen (50)"
	action_icon_state = "queen_word"
	plasma_cost = 50
	xeno_cooldown = 10 SECONDS

/datum/action/xeno_action/activable/gut
	name = "Gut (200)"
	action_icon_state = "gut"
	macro_path = /datum/action/xeno_action/verb/verb_gut
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 15 MINUTES
	plasma_cost = 200
	cooldown_message = "You feel your anger return. You are ready to gut again."

/datum/action/xeno_action/activable/expand_weeds
	name = "Expand Weeds (50)"
	action_icon_state = "plant_weeds"
	plasma_cost = 50
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 0.5 SECONDS

	var/node_plant_cooldown = 7 SECONDS
	var/node_plant_plasma_cost = 300
	var/turf_build_cooldown = 10 SECONDS

/datum/action/xeno_action/onclick/manage_hive
	name = "Manage The Hive"
	action_icon_state = "xeno_readmit"
	plasma_cost = 0

/datum/action/xeno_action/onclick/send_thoughts // and prayers
	name = "Psychic Communication"
	action_icon_state = "psychic_whisper"
	plasma_cost = 0

/datum/action/xeno_action/activable/secrete_resin/remote/queen
	name = "Projected Resin (100)"
	action_icon_state = "secrete_resin"
	plasma_cost = 100
	xeno_cooldown = 2 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_5

	care_about_adjacency = FALSE
	build_speed_mod = 1.2

	var/boosted = FALSE

/datum/action/xeno_action/activable/secrete_resin/remote/queen/use_ability(atom/target_atom, mods)
	if(boosted)
		var/area/target_area = get_area(target_atom)
		if(!target_area)
			return

		if(target_area.linked_lz && istype(SSticker.mode, /datum/game_mode/colonialmarines))
			to_chat(owner, SPAN_XENONOTICE("It's too early to spread the hive this far."))
			return

	return ..()

/datum/action/xeno_action/activable/secrete_resin/remote/queen/give_to(mob/L)
	. = ..()
	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(apply_queen_build_boost)))

// queenos don't need weeds under them to build on ovi
/datum/action/xeno_action/activable/secrete_resin/remote/queen/can_remote_build()
	return TRUE

/datum/action/xeno_action/activable/secrete_resin/remote/queen/proc/apply_queen_build_boost()
	var/boost_duration = 30 MINUTES
	// In the event secrete_resin is given after round start
	if(SSticker.round_start_time)
		boost_duration = (30 MINUTES) - (world.time - SSticker.round_start_time)
	if(boost_duration > 0)
		boosted = TRUE
		xeno_cooldown = 0
		plasma_cost = 0
		build_speed_mod = 1
		thick = TRUE // Allow queen to remotely thicken structures.
		RegisterSignal(owner, COMSIG_XENO_THICK_RESIN_BYPASS, PROC_REF(override_secrete_thick_resin))
		addtimer(CALLBACK(src, PROC_REF(disable_boost)), boost_duration)

/datum/action/xeno_action/activable/secrete_resin/remote/queen/proc/disable_boost()
	xeno_cooldown = 3 SECONDS
	plasma_cost = 100
	boosted = FALSE
	thick = FALSE
	UnregisterSignal(owner, COMSIG_XENO_THICK_RESIN_BYPASS)

	if(owner)
		to_chat(owner, SPAN_XENOHIGHDANGER("Your boosted building has been disabled!"))

/datum/action/xeno_action/activable/secrete_resin/remote/queen/proc/override_secrete_thick_resin()
	return COMPONENT_THICK_BYPASS

/datum/action/xeno_action/activable/bombard/queen
	// Range and other config
	interrupt_flags = NO_FLAGS
	xeno_cooldown = 4 SECONDS

	charges = 0

/datum/action/xeno_action/activable/bombard/queen/give_to(mob/living/carbon/xenomorph/queen/Q)
	. = ..()
	if(!Q.ovipositor)
		hide_from(Q)
	RegisterSignal(Q, COMSIG_QUEEN_MOUNT_OVIPOSITOR, PROC_REF(handle_mount_ovipositor))
	RegisterSignal(Q, COMSIG_QUEEN_DISMOUNT_OVIPOSITOR, PROC_REF(handle_dismount_ovipositor))

/datum/action/xeno_action/activable/bombard/queen/remove_from(mob/living/carbon/xenomorph/X)
	. = ..()
	UnregisterSignal(X, list(
		COMSIG_QUEEN_MOUNT_OVIPOSITOR,
		COMSIG_QUEEN_DISMOUNT_OVIPOSITOR,
	))

/datum/action/xeno_action/activable/bombard/queen/proc/handle_mount_ovipositor(mob/living/carbon/xenomorph/queen/Q)
	SIGNAL_HANDLER
	unhide_from(Q)

/datum/action/xeno_action/activable/bombard/queen/proc/handle_dismount_ovipositor(mob/living/carbon/xenomorph/queen/Q)
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
	plasma_cost = 0
	action_type = XENO_ACTION_CLICK

	charges = 0

	var/datum/hive_status/hive
	var/list/transported_xenos

/datum/action/xeno_action/activable/place_queen_beacon/give_to(mob/living/carbon/xenomorph/queen/Q)
	. = ..()
	hive = Q.hive
	if(!Q.ovipositor)
		hide_from(Q)
	RegisterSignal(Q, COMSIG_QUEEN_MOUNT_OVIPOSITOR, PROC_REF(handle_mount_ovipositor))
	RegisterSignal(Q, COMSIG_QUEEN_DISMOUNT_OVIPOSITOR, PROC_REF(handle_dismount_ovipositor))

/datum/action/xeno_action/activable/place_queen_beacon/remove_from(mob/living/carbon/xenomorph/X)
	. = ..()
	hive = null
	UnregisterSignal(X, list(
		COMSIG_QUEEN_MOUNT_OVIPOSITOR,
		COMSIG_QUEEN_DISMOUNT_OVIPOSITOR,
	))

/datum/action/xeno_action/activable/place_queen_beacon/proc/handle_mount_ovipositor(mob/living/carbon/xenomorph/queen/Q)
	SIGNAL_HANDLER
	unhide_from(Q)

/datum/action/xeno_action/activable/place_queen_beacon/proc/handle_dismount_ovipositor(mob/living/carbon/xenomorph/queen/Q)
	SIGNAL_HANDLER
	hide_from(Q)


/datum/action/xeno_action/activable/blockade
	name = "Place Blockade"
	action_icon_state = "place_blockade"
	plasma_cost = 300
	action_type = XENO_ACTION_CLICK

	var/obj/effect/alien/resin/resin_pillar/pillar_type = /obj/effect/alien/resin/resin_pillar
	var/time_taken = 6 SECONDS
	charges = 0

	var/brittle_time = 45 SECONDS
	var/decay_time = 45 SECONDS

/datum/action/xeno_action/activable/blockade/give_to(mob/living/carbon/xenomorph/queen/Q)
	. = ..()
	if(!Q.ovipositor)
		hide_from(Q)
	RegisterSignal(Q, COMSIG_QUEEN_MOUNT_OVIPOSITOR, PROC_REF(handle_mount_ovipositor))
	RegisterSignal(Q, COMSIG_QUEEN_DISMOUNT_OVIPOSITOR, PROC_REF(handle_dismount_ovipositor))

/datum/action/xeno_action/activable/blockade/remove_from(mob/living/carbon/xenomorph/X)
	. = ..()
	UnregisterSignal(X, list(
		COMSIG_QUEEN_MOUNT_OVIPOSITOR,
		COMSIG_QUEEN_DISMOUNT_OVIPOSITOR,
	))

/datum/action/xeno_action/activable/blockade/proc/handle_mount_ovipositor(mob/living/carbon/xenomorph/queen/Q)
	SIGNAL_HANDLER
	unhide_from(Q)

/datum/action/xeno_action/activable/blockade/proc/handle_dismount_ovipositor(mob/living/carbon/xenomorph/queen/Q)
	SIGNAL_HANDLER
	hide_from(Q)
