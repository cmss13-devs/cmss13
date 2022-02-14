/datum/xeno_mutator/praetorian_oppressor
	// Dread it, run from it, destiny still arrives.. or should I say, I do
	name = "STRAIN: Praetorian - Oppressor"
	description = "You abandon your speed to gain a powerful hook ability. Your slashes deal increased damage to prone targets, and you gain a powerful punch that devastates weakened opponents and makes your other abilities recharge faster."
	flavor_description = "Dread it. Run from it. The Hive still arrives. Or, more accurately, you do."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_PRAETORIAN)
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
		/datum/action/xeno_action/activable/corrosive_acid,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/prae_abduct,
		/datum/action/xeno_action/activable/oppressor_punch,
		/datum/action/xeno_action/activable/tail_lash
	)
	behavior_delegate_type = /datum/behavior_delegate/oppressor_praetorian
	keystone = TRUE

/datum/xeno_mutator/praetorian_oppressor/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Praetorian/P = MS.xeno

	P.damage_modifier -= XENO_DAMAGE_MOD_SMALL
	P.explosivearmor_modifier += XENO_EXPOSIVEARMOR_MOD_SMALL
	P.small_explosives_stun = FALSE
	P.speed_modifier += XENO_SPEED_SLOWMOD_TIER_5
	P.plasma_types = list(PLASMA_NEUROTOXIN, PLASMA_CHITIN)
	P.claw_type = CLAW_TYPE_SHARP

	mutator_update_actions(P)

	MS.recalculate_actions(description, flavor_description)

	apply_behavior_holder(P)

	P.recalculate_everything()
	P.mutation_type = PRAETORIAN_OPPRESSOR

/datum/behavior_delegate/oppressor_praetorian
	name = "Oppressor Praetorian Behavior Delegate"
	var/tearing_damage = 15

/datum/behavior_delegate/oppressor_praetorian/melee_attack_additional_effects_target(mob/living/carbon/H)

	if(H.stat == DEAD)
		return

	if(!(H.knocked_down || H.frozen || H.slowed))
		return

	H.apply_armoured_damage(get_xeno_damage_slash(H, tearing_damage), ARMOR_MELEE, BRUTE, bound_xeno.zone_selected ? bound_xeno.zone_selected : "chest")
	H.visible_message(SPAN_DANGER("[bound_xeno] tears into [H]!"))
	playsound(bound_xeno, 'sound/weapons/alien_tail_attack.ogg', 25, TRUE)
	return
