/datum/caste_datum/ravager
	caste_name = "Ravager"
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_6
	melee_damage_upper = XENO_DAMAGE_TIER_6
	max_health = XENO_HEALTH_TIER_6
	plasma_gain = XENO_PLASMA_GAIN_TIER_9
	plasma_max = XENO_PLASMA_TIER_3
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_8
	armor_deflection = XENO_ARMOR_TIER_3
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_3
	heal_standing = 0.66

	tackle_min = 2
	tackle_max = 5
	tackle_chance = 35
	tacklestrength_min = 4
	tacklestrength_max = 5
	
	evolution_allowed = FALSE
	deevolves_to = "Lurker"
	caste_desc = "A brutal, devastating front-line attacker."
	fire_immune = TRUE
	attack_delay = -1

	behavior_delegate_type = /datum/behavior_delegate/ravager_base

/mob/living/carbon/Xenomorph/Ravager
	caste_name = "Ravager"
	name = "Ravager"
	desc = "A huge, nasty red alien with enormous scythed claws."
	icon_source = "alien_ravager"
	icon_size = 64
	icon_state = "Ravager Walking"
	plasma_types = list(PLASMA_CATECHOLAMINE)
	var/used_charge = 0
	mob_size = MOB_SIZE_BIG
	drag_delay = 6 //pulling a big dead xeno is hard
	tier = 3
	pixel_x = -16
	old_x = -16
	mutation_type = RAVAGER_NORMAL
	claw_type = CLAW_TYPE_VERY_SHARP

	actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/empower,
		/datum/action/xeno_action/activable/pounce/charge,
		/datum/action/xeno_action/activable/scissor_cut
		)

// Mutator delegate for base ravager
/datum/behavior_delegate/ravager_base
	var/damage_per_shield_hp = 0.10
	var/shield_decay_time = 150 // Time in deciseconds before our shield decays
	var/slash_charge_cdr = 20 // Amount to reduce charge cooldown by per slash
	var/min_shield_buffed_abilities = 150
	var/knockdown_amount = 2
	var/fling_distance = 3

/datum/behavior_delegate/ravager_base/melee_attack_modify_damage(original_damage, atom/A = null)
	var/shield_total = 0
	for (var/datum/xeno_shield/XS in bound_xeno.xeno_shields)
		if (XS.shield_source == XENO_SHIELD_SOURCE_RAVAGER) 
			shield_total += XS.amount
	
	return original_damage + damage_per_shield_hp*shield_total

/datum/behavior_delegate/ravager_base/melee_attack_additional_effects_self()
	var/datum/action/xeno_action/activable/pounce/charge/cAction = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/activable/pounce/charge)
	if (!cAction.action_cooldown_check())
		cAction.reduce_cooldown(slash_charge_cdr)

/datum/behavior_delegate/ravager_base/append_to_stat()
	var/shield_total = 0
	for (var/datum/xeno_shield/XS in bound_xeno.xeno_shields)
		if (XS.shield_source == XENO_SHIELD_SOURCE_RAVAGER) 
			shield_total += XS.amount

	stat("Empower Shield:", "[shield_total]")
	stat("Bonus Slash Damage:", "[shield_total*damage_per_shield_hp]")

/datum/behavior_delegate/ravager_base/on_life()
	var/datum/xeno_shield/rav_shield 
	for (var/datum/xeno_shield/XS in bound_xeno.xeno_shields)
		if (XS.shield_source == XENO_SHIELD_SOURCE_RAVAGER) 
			rav_shield = XS
			break 

	if (rav_shield && ((rav_shield.last_damage_taken + shield_decay_time) < world.time))
		bound_xeno.xeno_shields -= rav_shield
		QDEL_NULL(rav_shield)
		to_chat(bound_xeno, SPAN_XENODANGER("You feel your shield decay!"))
		bound_xeno.overlay_shields()