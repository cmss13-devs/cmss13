/datum/caste_datum/spitter
	available_strains = list(
			/datum/xeno_strain/suppressor,
		)

/datum/xeno_strain/suppressor
	name = "Suppressor"
	description = "You lose your ability to spit your acid, in exchange you get ability to spit stiky resin for heal your sisters and slow hosts"
	flavor_description = "Run, Hide - death will come to every host anyway, early or late. And you chosen - suppress them all!"

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
