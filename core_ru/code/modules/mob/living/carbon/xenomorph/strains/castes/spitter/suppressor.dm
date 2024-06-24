/datum/xeno_strain/suppressor
	name = "STRAIN: Spitter - Suppressor"
	description = "Ты обмениваешь свою способность источать кислоту на возможность плеваться липкой резиной, цель которой - затруднять движение хостов, а в некоторых случаях и залатывать раны твоих сестёр."
	flavor_description = "Беги от неё, прячься от неё - смерть всё равно настигнет каждого хоста, рано или поздно. И твоя роль - подавить их сопротивление перед неизбежным!"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/tail_stab/spitter,
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/onclick/charge_spit,
		/datum/action/xeno_action/activable/spray_acid/spitter,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/onclick/charge_spit/suppressor,
		/datum/action/xeno_action/onclick/shift_spits/suppressor,
	)

/datum/xeno_strain/suppressor/apply_strain(mob/living/carbon/xenomorph/spitter/spitter)
	spitter.acid_level = 1
	spitter.melee_damage_lower = XENO_DAMAGE_TIER_2
	spitter.melee_damage_upper = XENO_DAMAGE_TIER_2
	spitter.armor_modifier -= XENO_ARMOR_MOD_VERY_SMALL
	spitter.health_modifier += XENO_HEALTH_MOD_MED
	spitter.ammo = GLOB.ammo_list[/datum/ammo/xeno/sticky] /// ummm a bit hacky but we need it cus acid spit still remains in some var's
	spitter.spit_types = list(/datum/ammo/xeno/sticky, /datum/ammo/xeno/sticky/heal)
	spitter.caste.spit_types = list(/datum/ammo/xeno/sticky, /datum/ammo/xeno/sticky/heal)

	spitter.recalculate_everything()
