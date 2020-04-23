/datum/caste_datum/ravager
	caste_name = "Ravager"
	upgrade_name = "Young"
	tier = 3
	upgrade = 0

	melee_damage_lower = XENO_DAMAGE_MEDIUMHIGH
	melee_damage_upper = XENO_DAMAGE_MEDIUMHIGH
	max_health = XENO_HEALTH_VERYHIGH + XENO_HEALTH_MOD_MED
	plasma_gain = XENO_PLASMA_GAIN_VERYHIGH
	plasma_max = XENO_PLASMA_LOW
	xeno_explosion_resistance = XENO_ULTRA_EXPLOSIVE_ARMOR
	armor_deflection = XENO_MEDIUM_ARMOR
	armor_hardiness_mult = XENO_ARMOR_FACTOR_CRUSHER
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_MEDIUM
	speed_mod = XENO_SPEED_MOD_LARGE

	tackle_chance = 35
	
	evolution_allowed = FALSE
	deevolves_to = "Lurker"
	caste_desc = "A brutal, devastating front-line attacker."
	fire_immune = 1
	attack_delay = -1

	behavior_delegate_type = /datum/behavior_delegate/ravager_base


/datum/caste_datum/ravager/mature
	upgrade_name = "Mature"
	caste_desc = "A brutal, devastating front-line attacker. It looks a little more dangerous."
	upgrade = 1
	tackle_chance = 40

/datum/caste_datum/ravager/elder
	upgrade_name = "Elder"
	caste_desc = "A brutal, devastating front-line attacker. It looks pretty strong."
	upgrade = 2

	tacklemin = 4
	tacklemax = 5
	tackle_chance = 45

/datum/caste_datum/ravager/ancient
	upgrade_name = "Ancient"
	caste_desc = "As I walk through the valley of the shadow of death"
	upgrade = 3

	tacklemin = 4
	tacklemax = 5
	tackle_chance = 50

/datum/caste_datum/ravager/primordial
	upgrade_name = "Primordial"
	caste_desc = "This thing's scythes are bigger than a fucking building!"
	upgrade = 4

	tacklemin = 6
	tacklemax = 7
	tackle_chance = 55

/mob/living/carbon/Xenomorph/Ravager
	caste_name = "Ravager"
	name = "Ravager"
	desc = "A huge, nasty red alien with enormous scythed claws."
	icon = 'icons/mob/xenos/xenomorph_64x64.dmi'
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
	var/damage_per_shield_hp = 0.05
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
		qdel(rav_shield)
		rav_shield = null
		to_chat(bound_xeno, SPAN_XENODANGER("You feel your shield decay!"))
		bound_xeno.overlay_shields()