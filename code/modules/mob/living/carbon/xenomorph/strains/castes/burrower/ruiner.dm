/datum/xeno_strain/ruiner
	name = BURROWER_RUINER
	description = "Lose half of your plasma, some of your speed and your ability to burrow, make resin holes, and place constructions. In exchange, your claws become sharper and you gain greater bulk. With your new bulk and sharper claws, you can rip open holes in walls and expand them to destroy the wall entirely. Additionally, you gain a tiny buff to your armor and explosion resistance."
	flavor_description = "Let this one serve to remind our enemies that no structure, no matter how strong and stalwart it may be, can stop our hive."
	icon_state_prefix = "Ruiner"

	actions_to_remove = list (
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/onclick/place_trap,
		/datum/action/xeno_action/activable/burrow,
		)

/datum/xeno_strain/ruiner/apply_strain(mob/living/carbon/xenomorph/burrower/burrower)
	burrower.plasmapool_modifier = 0.5
	burrower.speed_modifier -= XENO_SPEED_SLOWMOD_TIER_2
	burrower.armor_modifier += XENO_ARMOR_MOD_VERY_SMALL
	burrower.explosivearmor_modifier += XENO_EXPOSIVEARMOR_MOD_SMALL
	burrower.claw_type = CLAW_TYPE_SHARP
	burrower.mob_size = MOB_SIZE_BIG

	burrower.recalculate_everything()
