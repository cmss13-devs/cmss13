/datum/xeno_strain/vanguard
	name = PRAETORIAN_VANGUARD
	description = "You forfeit all of your acid-based abilities and some health for some extra speed and a rechargable shield that can block one attack. Use your Pierce from up to three paces away to stab through talls, while stabbing through two or more will completely recharge your shield. Use your charge to plow through enemies and use it again to unleash a powerful AoE slash that reaches up to three paces. You also have a Cleave ability, amplified by your shield, which you can toggle to either immobilize or fling a target away."
	flavor_description = "Fearless you are born, fearless you serve, fearless you die. This one will become my Vanguard"
	icon_state_prefix = "Vanguard"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
		/datum/action/xeno_action/activable/corrosive_acid,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/pierce,
		/datum/action/xeno_action/activable/pounce/prae_dash,
		/datum/action/xeno_action/activable/cleave,
		/datum/action/xeno_action/onclick/toggle_cleave,
	)

	behavior_delegate_type = /datum/behavior_delegate/praetorian_vanguard

/datum/xeno_strain/vanguard/apply_strain(mob/living/carbon/xenomorph/praetorian/prae)
	prae.speed_modifier += XENO_SPEED_FASTMOD_TIER_3
	prae.health_modifier -= XENO_HEALTH_MOD_MED
	prae.claw_type = CLAW_TYPE_SHARP

	prae.recalculate_everything()

/datum/behavior_delegate/praetorian_vanguard
	name = "Praetorian Vanguard Behavior Delegate"

	// Config
	var/shield_recharge_time = 200  // 20 seconds to recharge 1-hit shield
	var/pierce_spin_time = 10   // 1 second to use pierce
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

	addtimer(CALLBACK(src, PROC_REF(next_pierce_normal)), pierce_spin_time)
	return

/datum/behavior_delegate/praetorian_vanguard/proc/next_pierce_normal()
	var/datum/action/xeno_action/activable/pierce/pAction = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/activable/pierce)
	if (istype(pAction))
		pAction.should_spin_instead = FALSE
	return

/datum/behavior_delegate/praetorian_vanguard/proc/regen_shield()
	var/mob/living/carbon/xenomorph/praetorian = bound_xeno
	var/datum/xeno_shield/vanguard/found_shield = null
	last_shield_regen_time = world.time
	for (var/datum/xeno_shield/vanguard/vanguard_shield in praetorian.xeno_shields)
		if (vanguard_shield.shield_source == XENO_SHIELD_SOURCE_VANGUARD_PRAE)
			found_shield = vanguard_shield
			break

	if (found_shield)
		qdel(found_shield)

		praetorian.add_xeno_shield(800, XENO_SHIELD_SOURCE_VANGUARD_PRAE, /datum/xeno_shield/vanguard)

	else
		var/datum/xeno_shield/vanguard/new_shield = praetorian.add_xeno_shield(800, XENO_SHIELD_SOURCE_VANGUARD_PRAE, /datum/xeno_shield/vanguard)
		bound_xeno.explosivearmor_modifier += 1.5*XENO_EXPOSIVEARMOR_MOD_VERY_LARGE
		bound_xeno.recalculate_armor()
		new_shield.explosive_armor_amount = 1.5*XENO_EXPOSIVEARMOR_MOD_VERY_LARGE
		to_chat(praetorian, SPAN_XENOHIGHDANGER("We feel our defensive shell regenerate! It will block one hit!"))

	var/datum/action/xeno_action/activable/cleave/caction = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/activable/cleave)
	if (istype(caction))
		caction.buffed = TRUE
