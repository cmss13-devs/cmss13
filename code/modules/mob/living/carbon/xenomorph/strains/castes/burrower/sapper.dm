/datum/xeno_strain/sapper
	name = BURROWER_SAPPER
	description = "Lose half of your plasma and some of your abilities, including burrowing and trapping, in exchange for being able to slash holes in un-reinforced walls and tear already holed walls open entirely. Additionally, your acid becomes as powerful as a boilers and you gain buffs to your explosive resistance and armor."
	flavor_description = "No matter how stalwart the defences of our enemies may be, remind them that nothing endures the hive."
	icon_state_prefix = "Sapper"

	actions_to_remove = list (
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/onclick/place_trap,
		/datum/action/xeno_action/activable/burrow,
		/datum/action/xeno_action/activable/corrosive_acid
		)

	actions_to_add = list (
		/datum/action/xeno_action/activable/corrosive_acid/strong
	)

/datum/xeno_strain/sapper/apply_strain(mob/living/carbon/xenomorph/burrower/burrower)
	burrower.plasmapool_modifier = 0.5
	burrower.armor_modifier += XENO_ARMOR_MOD_SMALL
	burrower.explosivearmor_modifier += XENO_EXPOSIVEARMOR_MOD_MED
	burrower.claw_type = CLAW_TYPE_SHARP
	burrower.mob_size = MOB_SIZE_BIG

	burrower.recalculate_everything()
