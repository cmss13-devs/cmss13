/datum/action/xeno_action/activable/blockade
	name = "Place Blockade"
	action_icon_state = "place_blockade"
	ability_name = "place blockade"
	plasma_cost = 300
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 15 SECONDS

	var/obj/effect/alien/resin/resin_pillar/pillar_type = /obj/effect/alien/resin/resin_pillar
	var/time_taken = 1 SECONDS

	var/brittle_time = 5 SECONDS
	var/decay_time = 5 SECONDS


/datum/action/xeno_action/activable/weed_nade
	name = "Lob Resin"
	action_icon_state = "prae_dodge"
	plasma_cost = 300
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 10 SECONDS

	var/explode_delay = 1 SECONDS
	var/priming_delay = 1 SECONDS

