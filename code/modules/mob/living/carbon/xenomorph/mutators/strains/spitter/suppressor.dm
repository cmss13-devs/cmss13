/datum/xeno_mutator/Suppressor
	name = "STRAIN: Spitter - Suppressor"
	description = "Ты обмениваешь свою способность источать кислоту на возможность плеваться липкой резиной, цель которой - затруднять движение хостов, а в некоторых случаях и залатывать раны твоих сестёр."
	flavor_description = "Беги от неё, прячься от неё - смерть всё равно настигнет каждого хоста, рано или поздно. И твоя роль - подавить их сопротивление перед неизбежным!"
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_SPITTER)
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/tail_stab/spitter,
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/onclick/charge_spit,
		/datum/action/xeno_action/activable/spray_acid/spitter,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/onclick/charge_spit/suppressor,
		/datum/action/xeno_action/onclick/shift_spits/suppressor,
	)
	keystone = TRUE

/datum/xeno_mutator/Suppressor/apply_mutator(datum/mutator_set/individual_mutators/mutator_set)
	. = ..()
	if (. == FALSE)
		return

	var/mob/living/carbon/xenomorph/spitter/spitter = mutator_set.xeno

	spitter.acid_level = 1
	spitter.melee_damage_lower = XENO_DAMAGE_TIER_2
	spitter.melee_damage_upper = XENO_DAMAGE_TIER_2
	spitter.armor_modifier -= XENO_ARMOR_MOD_VERY_SMALL
	spitter.health_modifier += XENO_HEALTH_MOD_MED
	spitter.ammo = GLOB.ammo_list[/datum/ammo/xeno/sticky] /// ummm a bit hacky but we need it cus acid spit still remains in some var's
	spitter.spit_types = list(/datum/ammo/xeno/sticky, /datum/ammo/xeno/sticky/heal)
	spitter.caste.spit_types = list(/datum/ammo/xeno/sticky, /datum/ammo/xeno/sticky/heal)

	mutator_update_actions(spitter)
	spitter.recalculate_everything()
	mutator_set.recalculate_actions(description, flavor_description)
	spitter.mutation_icon_state = SPITTER_SUPPRESSOR // replace this if you add custom sprites for this
	spitter.mutation_type = SPITTER_SUPPRESSOR
