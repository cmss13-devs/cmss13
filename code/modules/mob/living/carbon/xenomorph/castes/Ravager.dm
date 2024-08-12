/datum/caste_datum/ravager
	caste_type = XENO_CASTE_RAVAGER
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_6
	melee_damage_upper = XENO_DAMAGE_TIER_6
	melee_vehicle_damage = XENO_DAMAGE_TIER_7 //Queen and Ravs have extra multiplier when dealing damage in multitile_interaction.dm
	max_health = XENO_HEALTH_TIER_9
	plasma_gain = XENO_PLASMA_GAIN_TIER_9
	plasma_max = XENO_PLASMA_TIER_3
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_8
	armor_deflection = XENO_ARMOR_TIER_2
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_3
	heal_standing = 0.66

	tackle_min = 2
	tackle_max = 5
	tackle_chance = 35
	tacklestrength_min = 4
	tacklestrength_max = 5

	evolution_allowed = FALSE
	deevolves_to = list(XENO_CASTE_LURKER)
	caste_desc = "A brutal, devastating front-line attacker."
	fire_immunity = FIRE_IMMUNITY_NO_DAMAGE|FIRE_IMMUNITY_XENO_FRENZY
	attack_delay = -1

	available_strains = list(
		/datum/xeno_strain/berserker,
		/datum/xeno_strain/hedgehog,
	)
	behavior_delegate_type = /datum/behavior_delegate/ravager_base

	minimum_evolve_time = 15 MINUTES

	minimap_icon = "ravager"

/mob/living/carbon/xenomorph/ravager
	caste_type = XENO_CASTE_RAVAGER
	name = XENO_CASTE_RAVAGER
	desc = "A huge, nasty red alien with enormous scythed claws."
	icon = 'icons/mob/xenos/ravager.dmi'
	icon_size = 64
	icon_state = "Ravager Walking"
	plasma_types = list(PLASMA_CATECHOLAMINE)
	mob_size = MOB_SIZE_BIG
	drag_delay = 6 //pulling a big dead xeno is hard
	tier = 3
	pixel_x = -16
	old_x = -16
	claw_type = CLAW_TYPE_VERY_SHARP
	organ_value = 3000
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/pounce/charge,
		/datum/action/xeno_action/onclick/empower,
		/datum/action/xeno_action/activable/scissor_cut,
		/datum/action/xeno_action/onclick/tacmap,
	)

	icon_xeno = 'icons/mob/xenos/ravager.dmi'
	icon_xenonid = 'icons/mob/xenonids/ravager.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Ravager_1","Ravager_2","Ravager_3")
	weed_food_states_flipped = list("Ravager_1","Ravager_2","Ravager_3")


// Mutator delegate for base ravager
/datum/behavior_delegate/ravager_base
	var/shield_decay_time = 15 SECONDS // Time in deciseconds before our shield decays
	var/slash_charge_cdr = 3 SECONDS // Amount to reduce charge cooldown by per slash
	var/knockdown_amount = 1.3
	var/fling_distance = 3
	var/empower_targets = 0
	var/super_empower_threshold = 3
	var/dmg_buff_per_target = 2

/datum/behavior_delegate/ravager_base/melee_attack_modify_damage(original_damage, mob/living/carbon/carbon)
	var/damage_plus
	if(empower_targets)
		damage_plus = dmg_buff_per_target * empower_targets

	return original_damage + damage_plus

/datum/behavior_delegate/ravager_base/melee_attack_additional_effects_self()
	..()

	var/datum/action/xeno_action/activable/pounce/charge/cAction = get_action(bound_xeno, /datum/action/xeno_action/activable/pounce/charge)
	if (!cAction.action_cooldown_check())
		cAction.reduce_cooldown(slash_charge_cdr)

/datum/behavior_delegate/ravager_base/append_to_stat()
	. = list()
	var/shield_total = 0
	for (var/datum/xeno_shield/xeno_shield in bound_xeno.xeno_shields)
		if (xeno_shield.shield_source == XENO_SHIELD_SOURCE_RAVAGER)
			shield_total += xeno_shield.amount

	. += "Empower Shield: [shield_total]"
	. += "Bonus Slash Damage: [dmg_buff_per_target * empower_targets]"

/datum/behavior_delegate/ravager_base/on_life()
	var/datum/xeno_shield/rav_shield
	for (var/datum/xeno_shield/xeno_shield in bound_xeno.xeno_shields)
		if (xeno_shield.shield_source == XENO_SHIELD_SOURCE_RAVAGER)
			rav_shield = xeno_shield
			break

	if (rav_shield && ((rav_shield.last_damage_taken + shield_decay_time) < world.time))
		QDEL_NULL(rav_shield)
		to_chat(bound_xeno, SPAN_XENODANGER("We feel our shield decay!"))
		bound_xeno.overlay_shields()
