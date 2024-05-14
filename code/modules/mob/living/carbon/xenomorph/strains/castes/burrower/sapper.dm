/datum/xeno_strain/sapper
	name = BURROWER_SAPPER
	description = "Lose half of your plasma, some speed and some of your abilities to burrow, trap and construct, in exchange for being able to slash holes in up to reinforced walls and tear open holed walls entirely. Additionally, you gain buffs to your explosive resistance and armor as well as gaining the ability to spray weak acid."
	flavor_description = "No matter how stalwart their defences may be, remind our enemies that nothing endures the hive."
	icon_state_prefix = "Sapper"

	actions_to_remove = list (
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/onclick/place_trap,
		/datum/action/xeno_action/activable/burrow,
		)

	actions_to_add = list (
		/datum/action/xeno_action/activable/spray_acid/sapper,	//third macro
	)

/datum/xeno_strain/sapper/apply_strain(mob/living/carbon/xenomorph/burrower/burrower)
	burrower.plasmapool_modifier = 0.5
	burrower.speed_modifier += XENO_SPEED_SLOWMOD_TIER_5
	burrower.armor_modifier += XENO_ARMOR_MOD_SMALL
	burrower.explosivearmor_modifier += XENO_EXPOSIVEARMOR_MOD_MED
	burrower.small_explosives_stun = FALSE
	burrower.claw_type = CLAW_TYPE_VERY_SHARPS
	burrower.mob_size = MOB_SIZE_BIG

	burrower.recalculate_everything()
