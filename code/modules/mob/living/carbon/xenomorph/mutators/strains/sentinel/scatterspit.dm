/datum/xeno_mutator/scatterspit
	name = "STRAIN: Sentinel - Scatterspitter"
	description = "You exchange your spit varieties, corrosive acid and some speed to gain a bit of armor and a potent, shotgun-like neurotoxic spit."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Sentinel") 
	mutator_actions_to_remove = list("Toggle Spit Type", "Corrosive Acid (75)")
	keystone = TRUE

/datum/xeno_mutator/scatterspit/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return
	
	var/mob/living/carbon/Xenomorph/Sentinel/S = MS.xeno
	S.speed_modifier += XENO_SPEED_MOD_VERYLARGE
	S.mutation_type = SENTINEL_SCATTERSPIT
	S.armor_modifier += XENO_ARMOR_MOD_MED
	S.explosivearmor_modifier += XENO_EXPOSIVEARMOR_MOD_VERYSMALL
	S.ammo = ammo_list[/datum/ammo/xeno/toxin/shotgun]

	mutator_update_actions(S)
	MS.recalculate_actions(description, flavor_description)
	S.recalculate_everything()

