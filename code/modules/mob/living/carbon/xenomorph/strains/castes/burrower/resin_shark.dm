/datum/xeno_strain/resin_shark
	name = BURROWER_RESIN_SHARK
	description = "bleh bleh bleh"
	flavor_description = "bleh bleh bleh"
	icon_state_prefix = "Resin Shark"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/onclick/build_tunnel,
		/datum/action/xeno_action/onclick/place_trap,
		/datum/action/xeno_action/activable/burrow,
		/datum/action/xeno_action/onclick/tremor,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/sweep,
		/datum/action/xeno_action/activable/chomp,
		/datum/action/xeno_action/onclick/submerge,
	)

/datum/xeno_strain/resin_shark/apply_strain(mob/living/carbon/xenomorph/burrower/burrower)
	burrower.plasmapool_modifier = 1000
	burrower.health_modifier -= XENO_HEALTH_MOD_MED
	burrower.speed_modifier += XENO_SPEED_FASTMOD_TIER_1
	burrower.armor_modifier += XENO_ARMOR_MOD_LARGE
	burrower.attack_speed_modifier -= 2

	burrower.recalculate_everything()
