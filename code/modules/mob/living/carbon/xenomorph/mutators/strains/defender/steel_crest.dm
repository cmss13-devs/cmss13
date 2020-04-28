/datum/xeno_mutator/steel_crest 
	name = "STRAIN: Defender - Steel Crest"
	description = "In exchange for your tail sweep and some of your damage, you gain the ability to move while in Fortify. Your headbutt can now be used while your crest is lowered. It also reaches further and does more damage."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Defender") 
	keystone = TRUE

/datum/xeno_mutator/steel_crest/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Defender/D = MS.xeno
	D.mutation_type = DEFENDER_STEELCREST
	D.remove_action("Tail Sweep")
	D.armor_modifier -= XENO_ARMOR_MOD_SMALL
	D.speed_modifier += XENO_SPEED_MOD_SMALL
	D.damage_modifier -= XENO_DAMAGE_MOD_VERYSMALL
	D.spiked = TRUE
	if(D.fortify)
		D.ability_speed_modifier += 2.5
	MS.recalculate_actions(description, flavor_description)
	D.recalculate_stats()
