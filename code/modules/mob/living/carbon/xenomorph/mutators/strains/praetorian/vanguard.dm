/datum/xeno_mutator/vanguard
	name = "STRAIN: Praetorian - Vanguard"
	description = "You forfeit some durability to gain an ability that pierces through the talls, a dash that flies over their heads and can be followed up with a sweeping slash to the surrounding area by using it again, and an ability that can fling or immobilize at your choice. You gain a shield that blocks one attack; while the shield is active your cleave has a magnified effect."
	flavor_description = "...They shall be the finest warriors among my children, my Vanguard against the tallhosts. And they shall know no fear."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_PRAETORIAN) //Only praetorian.
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
		/datum/action/xeno_action/activable/corrosive_acid,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/pierce,
		/datum/action/xeno_action/activable/pounce/prae_dash,
		/datum/action/xeno_action/activable/cleave,
		/datum/action/xeno_action/onclick/toggle_cleave
	)
	behavior_delegate_type = /datum/behavior_delegate/praetorian_vanguard
	keystone = TRUE

/datum/xeno_mutator/vanguard/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Praetorian/P = MS.xeno
	P.speed_modifier += XENO_SPEED_FASTMOD_TIER_3
	P.health_modifier -= XENO_HEALTH_MOD_MED
	P.claw_type = CLAW_TYPE_SHARP
	mutator_update_actions(P)
	MS.recalculate_actions(description, flavor_description)
	P.recalculate_everything()

	P.mutation_type = PRAETORIAN_VANGUARD

	apply_behavior_holder(P)

/datum/behavior_delegate/praetorian_vanguard
	name = "Praetorian Vanguard Behavior Delegate"

	// Config
	var/shield_recharge_time = 200     // 20 seconds to recharge 1-hit shield
	var/pierce_spin_time = 10          // 1 second to use pierce
	var/shield_decay_cleave_time = 15   // How long you have to buffed cleave after the shield fully decays

	// State
	var/last_combat_time = 0
	var/last_shield_regen_time = 0

/datum/behavior_delegate/praetorian_vanguard/on_life()
	if (last_shield_regen_time <= last_combat_time &&  last_combat_time + shield_recharge_time <= world.time)
		regen_shield()


/datum/behavior_delegate/praetorian_vanguard/on_hitby_projectile(ammo)
	last_combat_time = world.time
	return

/datum/behavior_delegate/praetorian_vanguard/melee_attack_additional_effects_self()
	..()

	last_combat_time = world.time

/datum/behavior_delegate/praetorian_vanguard/proc/next_pierce_spin()
	var/datum/action/xeno_action/activable/pierce/pAction = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/activable/pierce)
	if (istype(pAction))
		pAction.should_spin_instead = TRUE

	addtimer(CALLBACK(src, .proc/next_pierce_normal), pierce_spin_time)
	return

/datum/behavior_delegate/praetorian_vanguard/proc/next_pierce_normal()
	var/datum/action/xeno_action/activable/pierce/pAction = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/activable/pierce)
	if (istype(pAction))
		pAction.should_spin_instead = FALSE
	return

/datum/behavior_delegate/praetorian_vanguard/proc/regen_shield()
	var/mob/living/carbon/Xenomorph/X = bound_xeno
	var/datum/xeno_shield/vanguard/found_shield = null
	last_shield_regen_time = world.time
	for (var/datum/xeno_shield/vanguard/XS in X.xeno_shields)
		if (XS.shield_source == XENO_SHIELD_SOURCE_VANGUARD_PRAE)
			found_shield = XS
			break

	if (found_shield)
		qdel(found_shield)

		X.add_xeno_shield(800, XENO_SHIELD_SOURCE_VANGUARD_PRAE, /datum/xeno_shield/vanguard)

	else
		var/datum/xeno_shield/vanguard/new_shield = X.add_xeno_shield(800, XENO_SHIELD_SOURCE_VANGUARD_PRAE, /datum/xeno_shield/vanguard)
		bound_xeno.explosivearmor_modifier += 1.5*XENO_EXPOSIVEARMOR_MOD_VERYLARGE
		bound_xeno.recalculate_armor()
		new_shield.explosive_armor_amount = 1.5*XENO_EXPOSIVEARMOR_MOD_VERYLARGE
		to_chat(X, SPAN_XENOHIGHDANGER("You feel your defensive shell regenerate! It will block one hit!"))

	var/datum/action/xeno_action/activable/cleave/cAction = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/activable/cleave)
	if (istype(cAction))
		cAction.buffed = TRUE





