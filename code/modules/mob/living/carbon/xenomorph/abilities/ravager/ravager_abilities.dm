
// Rav charge
/datum/action/xeno_action/activable/pounce/charge
	ability_description = "Charge through obstacles. Super empowered hits add an unblockable slash, knockdown and fling."
	ability_stats_type = /datum/xeno_ability_stats/charge
	name = "Charge"
	action_icon_state = "charge"
	action_text = "charge"
	macro_path = /datum/action/xeno_action/verb/verb_charge_rav
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 14 SECONDS
	plasma_cost = 25

	// Pounce config
	distance = 5
	knockdown = FALSE // Should we knock down the target?
	slash = FALSE // Do we slash upon reception?
	freeze_self = FALSE // Should we freeze ourselves after the lunge?
	should_destroy_objects = TRUE   // Only used for ravager charge
	cooldown_message = "Our legs are ready for another charge!"

XENO_ABILITY_STATS(charge, datum/action/xeno_action/activable/pounce/charge)
	var/fling_distance = /datum/behavior_delegate/ravager_base::fling_distance
	return list(
		XENO_STAT_TILES(distance, "Range"),
		XENO_STAT_VALUE("Super empowered knockback", fling_distance, "crowd_control", " tiles."),
	)

// Base ravager shield ability
/datum/action/xeno_action/onclick/empower
	ability_description = "Gain a shield, then trigger again for extra shield and slash damage per nearby enemy. Enough enemies grant super empowerment."
	ability_stats_type = /datum/xeno_ability_stats/empower
	name = "Empower"
	action_icon_state = "empower"
	macro_path = /datum/action/xeno_action/verb/verb_empower
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	plasma_cost = 50
	xeno_cooldown = 18 SECONDS

	// Config values (mutable)
	var/empower_range = 4
	var/max_targets = 6
	var/main_empower_base_shield = 0
	var/initial_activation_shield = 50
	var/shield_per_human = 50
	var/time_until_timeout = 6 SECONDS
	var/super_empower_duration = 5 SECONDS
	var/super_empower_fade_duration = 1.5 SECONDS

	// State
	var/activated_once = FALSE
	cooldown_message = "We have enough energy to shield ourselves again!"

XENO_ABILITY_STATS(empower, datum/action/xeno_action/onclick/empower)
	var/threshold = /datum/behavior_delegate/ravager_base::super_empower_threshold
	return list(
		XENO_STAT_SHIELD(initial_activation_shield, "Initial shield"),
		XENO_STAT_DURATION(time_until_timeout, "Automatic trigger"),
		XENO_STAT_VALUE("Enemies for super empowerment", threshold, null, "."),
		XENO_STAT_VALUE("Super empowerment duration", (XENO_ABILITY_VALUE(ability, super_empower_duration) + XENO_ABILITY_VALUE(ability, super_empower_fade_duration)) * 0.1, null, "s."),
	)

// Rav "Scissor Cut"
/datum/action/xeno_action/activable/scissor_cut
	ability_description = "Cut enemies in a line. Super empowered hits also inflict a heavy slow."
	ability_stats_type = /datum/xeno_ability_stats/scissor_cut
	name = "Scissor Cut"
	action_icon_state = "rav_scissor_cut"
	macro_path = /datum/action/xeno_action/verb/verb_scissorcut
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 6 SECONDS
	plasma_cost = 25

	// Config
	var/base_damage = 40
	var/cut_range = 4

	var/superslow_duration = 3 SECONDS

XENO_ABILITY_STATS(scissor_cut, datum/action/xeno_action/activable/scissor_cut)
	return list(
		XENO_STAT_BRUTE(base_damage, "Base brute damage"),
		XENO_STAT_TILES(cut_range, "Range"),
		XENO_STAT_CONTROL_DURATION(superslow_duration, "Super empowered heavy slow"),
	)

//// BERSERKER ACTIONS

/datum/action/xeno_action/onclick/apprehend
	ability_stats_type = /datum/xeno_ability_stats/onclick_apprehend
	ability_description = "Gain a burst of speed and slow the next target you slash."
	name = "Apprehend"
	action_icon_state = "rav_enrage"
	macro_path = /datum/action/xeno_action/verb/verb_apprehend
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	plasma_cost = 0
	xeno_cooldown = 18 SECONDS

	// Config values
	var/speed_buff = 0.75
	var/buff_duration = 5 SECONDS
	cooldown_message = "Our muscles and tendons feel limber!"

XENO_ABILITY_STATS(onclick_apprehend, datum/action/xeno_action/onclick/apprehend)
	return list(
		XENO_STAT_DURATION(buff_duration, "Duration"),
	)


/datum/action/xeno_action/activable/clothesline
	ability_stats_type = /datum/xeno_ability_stats/activable_clothesline
	ability_description = "Fling a target and heal yourself. Spending rage increases the healing."
	name = "Clothesline"
	action_icon_state = "rav_clothesline"
	macro_path = /datum/action/xeno_action/verb/verb_clothesline
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	plasma_cost = 0
	xeno_cooldown = 16 SECONDS

	// Config values
	var/base_heal = 75
	var/additional_healing_enraged = 100
	var/base_damage = 20
	var/fling_dist_base = 4
	var/daze_amount = 2
	cooldown_message = "We crave blood! REND AND TEAR!"

XENO_ABILITY_STATS(activable_clothesline, datum/action/xeno_action/activable/clothesline)
	return list(
		XENO_STAT_BRUTE(base_damage, "Base brute damage"),
		XENO_STAT_HEALTH(base_heal, "Healing"),
		XENO_STAT_HEALTH(additional_healing_enraged, "Extra healing with rage"),
		XENO_STAT_VALUE("Knockback", XENO_ABILITY_VALUE(ability, fling_dist_base), "crowd_control", " tiles."),
	)

#define EVISCERATE_DAMAGE_LEVELS list(5, 10, 25, 45, 70)
/datum/action/xeno_action/activable/eviscerate
	ability_stats_type = /datum/xeno_ability_stats/activable_eviscerate
	ability_description = "Wind up in place, then slash nearby enemies and heal for each one hit. Spending rage increases the area of effect and damage."
	name = "Eviscerate"
	action_icon_state = "rav_eviscerate"
	macro_path = /datum/action/xeno_action/verb/verb_eviscerate
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 0
	xeno_cooldown = 23 SECONDS
	cooldown_message = "WE FEEL SO INCREDIBLY INFURIATED! KILL EVERYTHING!"

	// Config values
	var/activation_delay = 2 SECONDS

	var/base_damage = 25
	var/damage_at_rage_levels = EVISCERATE_DAMAGE_LEVELS
	var/lifesteal_per_marine = 50
	var/max_lifesteal = 250
	var/range_at_rage_levels = list(1, 1, 1, 2, 2)
	var/windup_reduction_at_rage_levels = list(0, 2, 4, 6, 10)


XENO_ABILITY_STATS(activable_eviscerate, datum/action/xeno_action/activable/eviscerate)
	var/list/damages = ispath(ability) ? EVISCERATE_DAMAGE_LEVELS : ability.damage_at_rage_levels
	return list(
		xeno_stat_row("Brute damage by rage", list(xeno_description_value(min(damages), "brute"), " to ", xeno_description_value(max(damages), "brute"), ".")),
		xeno_stat_row("Healing per nearby enemy", list(xeno_description_value(XENO_ABILITY_VALUE(ability, lifesteal_per_marine), "health"), ", capped at ", xeno_description_value(XENO_ABILITY_VALUE(ability, max_lifesteal), "health"), ".")),
	)

////// HEDGEHOG ABILITIES

/datum/action/xeno_action/onclick/spike_shield
	ability_stats_type = /datum/xeno_ability_stats/onclick_spike_shield
	ability_description = "Spend shards on a temporary shield that sprays bone shards when hit."
	name = "Spike Shield (150 shards)"
	action_icon_state = "rav_shard_shield"
	macro_path = /datum/action/xeno_action/verb/verb_spike_shield
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	plasma_cost = 0
	xeno_cooldown = 9 SECONDS + 2.5 SECONDS // Left operand is the actual CD, right operand is the buffer for the shield duration

	// Config values
	var/shield_duration = 2.5 SECONDS
	var/shield_amount = 500 // Shield HP amount
	var/shield_shrapnel_amount = 7  // How much shrapnel each shield hit should spawn
	var/shard_cost = 150 // Minimum spikes to use this ability
	var/shield_active = FALSE // Is our shield active.
	var/real_hp_per_shield_hp = 0.5 // How many real HP we get for each shield HP

XENO_ABILITY_STATS(onclick_spike_shield, datum/action/xeno_action/onclick/spike_shield)
	return list(
		XENO_STAT_NUMBER(shard_cost, "Shard cost"),
		XENO_STAT_SHIELD(shield_amount, "Shield"),
		XENO_STAT_VALUE("Duration", XENO_ABILITY_VALUE(ability, shield_duration) * 0.1, "shield", "s."),
	)

/datum/action/xeno_action/activable/rav_spikes
	ability_stats_type = /datum/xeno_ability_stats/activable_rav_spikes
	ability_description = "Spend shards to fire spikes that slow prey and hurt them when they move."
	name = "Fire Spikes (75 shards)"
	action_icon_state = "rav_spike"
	macro_path = /datum/action/xeno_action/verb/verb_fire_spikes
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	plasma_cost = 0
	xeno_cooldown = 10 SECONDS

	// Config
	var/shard_cost = 75
	var/ammo_type = /datum/ammo/xeno/bone_chips

XENO_ABILITY_STATS(activable_rav_spikes, datum/action/xeno_action/activable/rav_spikes)
	var/datum/ammo/ammo = XENO_ABILITY_VALUE(ability, ammo_type)
	return list(
		XENO_STAT_NUMBER(shard_cost, "Shard cost"),
	) + projectile_stats(ammo)

/datum/action/xeno_action/onclick/spike_shed
	ability_stats_type = /datum/xeno_ability_stats/onclick_spike_shed
	ability_description = "Burst shards in all directions and gain speed. Shard generation pauses afterward."
	name = "Spike Shed (50 shards)"
	action_icon_state = "rav_shard_shed"
	macro_path = /datum/action/xeno_action/verb/verb_shed_spikes
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 0
	xeno_cooldown = 30 SECONDS
	cooldown_message = "If we feel threatened, we can shed our shards again."

	// Config values
	var/shard_cost = 50
	var/ammo_type = /datum/ammo/xeno/bone_chips/spread
	var/shrapnel_amount = 40

XENO_ABILITY_STATS(onclick_spike_shed, datum/action/xeno_action/onclick/spike_shed)
	var/datum/ammo/ammo = XENO_ABILITY_VALUE(ability, ammo_type)
	return list(
		XENO_STAT_NUMBER(shard_cost, "Shard cost"),
		XENO_STAT_NUMBER(shrapnel_amount, "Fragments"),
	) + projectile_stats(ammo)

#undef EVISCERATE_DAMAGE_LEVELS
