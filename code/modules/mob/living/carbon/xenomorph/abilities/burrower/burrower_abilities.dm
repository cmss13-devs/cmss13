// Burrower Abilities

// Burrow
/datum/action/xeno_action/activable/burrow
	ability_stats_type = /datum/xeno_ability_stats/burrow
	ability_description = "Burrow underground to move unseen, or resurface to attack."
	name = "Burrow"
	action_icon_state = "agility_on"
	macro_path = /datum/action/xeno_action/verb/verb_burrow
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3

XENO_ABILITY_STATS(burrow, datum/action/xeno_action/activable/burrow)
	var/duration = /datum/caste_datum/burrower::burrow_duration
	var/cooldown = /datum/caste_datum/burrower::burrow_cooldown
	return list(
		XENO_STAT_VALUE("Underground duration", duration * 0.1, null, "s."),
		XENO_STAT_VALUE("Burrow cooldown", cooldown * 0.1, null, "s."),
	)

/datum/action/xeno_action/activable/burrow/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xenomorph = owner

	if(!action_cooldown_check())
		return

	if(HAS_TRAIT(xenomorph, TRAIT_ABILITY_BURROWED))
		xenomorph.tunnel(get_turf(A))
	else
		xenomorph.burrow()
	return ..()

/datum/action/xeno_action/onclick/tremor
	ability_stats_type = /datum/xeno_ability_stats/tremor
	var/impact_radius = 3
	var/knockdown_duration = 1
	var/slow_duration = 1
	ability_description = "Shake the ground to disrupt the footing of nearby enemies."
	name = "Tremor (100)"
	action_icon_state = "stomp"
	macro_path = /datum/action/xeno_action/verb/verb_tremor
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 30 SECONDS
	plasma_cost = 100
	cooldown_message = "Our legs are no longer tired. We can shake the ground again."

XENO_ABILITY_STATS(tremor, datum/action/xeno_action/onclick/tremor)
	return list(
		XENO_STAT_TILES(impact_radius, "Radius"),
		XENO_STAT_CONTROL_LEGACY(knockdown_duration, "Knockdown"),
		XENO_STAT_VALUE("Slow", XENO_ABILITY_VALUE(ability, slow_duration) * /datum/controller/subsystem/human::wait * 0.1, "crowd_control", "s."),
	)

/datum/action/xeno_action/onclick/build_tunnel
	ability_description = "Dig a tunnel entrance that sisters can travel through."
	name = "Dig Tunnel (200)"
	action_icon_state = "build_tunnel"
	plasma_cost = 200
	macro_path = /datum/action/xeno_action/verb/verb_dig_tunnel
	action_type = XENO_ACTION_ACTIVATE //doesn't really need a macro
	xeno_cooldown =  4 MINUTES
	cooldown_message = "We are no longer exhausted. We can dig a tunnel again."
