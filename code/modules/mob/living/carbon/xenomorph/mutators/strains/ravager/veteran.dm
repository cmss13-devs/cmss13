/datum/xeno_mutator/veteran
	name = "STRAIN: Ravager - Veteran"
	description = "In exchange for your armor and some health, you gain the ability to charge forward, slash off limbs, and move faster."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Ravager")  	// Only Ravager.
	mutator_actions_to_remove = list("Empower (100)")
	mutator_actions_to_add = list(/datum/action/xeno_action/activable/charge)
	keystone = TRUE

/datum/xeno_mutator/veteran/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return	

	var/mob/living/carbon/Xenomorph/Ravager/R = MS.xeno
	R.armor_modifier -= XENO_MEDIUM_ARMOR + XENO_ARMOR_MOD_VERYSMALL //Remove armour
	R.speed_modifier -= XENO_SPEED_MOD_ULTRA
	R.evasion_modifier += XENO_EVASION_MOD_VERYLARGE
	R.damage_modifier += XENO_DAMAGE_MOD_SMALL
	R.health_modifier -= XENO_HEALTH_MOD_VERYLARGE
	R.explosivearmor_modifier -= XENO_EXPOSIVEARMOR_MOD_SMALL
	R.mutation_type = RAVAGER_VETERAN
	R.overheal = 0
	R.overlay_overheal()
	mutator_update_actions(R)
	MS.recalculate_actions(description)
	R.recalculate_everything()

/datum/action/xeno_action/activable/charge
	name = "Charge (20)"
	action_icon_state = "charge"
	ability_name = "charge"
	macro_path = /datum/action/xeno_action/verb/verb_charge_rav
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/charge/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Ravager/X = owner
	X.Pounce(A)
	..()

/datum/action/xeno_action/activable/charge/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/Ravager/X = owner
	return !X.used_pounce

/datum/action/xeno_action/verb/verb_charge_rav()
	set category = "Alien"
	set name = "Charge"
	set hidden = 1
	var/action_name = "Charge (20)"
	handle_xeno_macro(src, action_name) 

