/datum/moba_item/rare/shredder_claws
	name = "Rending Claws"
	description = "<br><b>Armor Shred</b><br>Remove N% of the armor of anyone slashed. Stacks up to N, lasting N seconds since your last attack."
	icon_state = "rending_claws"
	gold_cost = MOBA_GOLD_PER_MINUTE * 3
	unique = TRUE
	component_items = list(
		/datum/moba_item/uncommon/penetrating_claws,
		/datum/moba_item/common/sharp_claws,
		/datum/moba_item/common/sharp_claws,
		/datum/moba_item/common/strong_constitution,
	)

	health = 200
	attack_damage = 20

/datum/moba_item/rare/shredder_claws/New(datum/moba_player/creating_player)
	. = ..()
	description = "<br><b>Armor Shred</b><br>Remove [/datum/status_effect/stacking/rended_armor::shred_per_stack]% of the armor of anyone slashed. Stacks up to [/datum/status_effect/stacking/rended_armor::max_stacks], lasting [/datum/status_effect/stacking/rended_armor::delay_before_decay * 0.1] seconds since your last attack."

/datum/moba_item/rare/shredder_claws/apply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player, restore_plasma_health)
	. = ..()
	RegisterSignal(xeno, COMSIG_XENO_ALIEN_ATTACK, PROC_REF(on_attack))

/datum/moba_item/rare/shredder_claws/unapply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player)
	. = ..()
	UnregisterSignal(xeno, COMSIG_XENO_ALIEN_ATTACK)

/datum/moba_item/rare/shredder_claws/proc/on_attack(datum/source, mob/living/carbon/xenomorph/attacking, damage)
	SIGNAL_HANDLER

	var/datum/status_effect/stacking/rended_armor/rended = attacking.has_status_effect(/datum/status_effect/stacking/rended_armor)
	if(!rended)
		rended = attacking.apply_status_effect(/datum/status_effect/stacking/rended_armor, 1)
	else
		rended.add_stacks(1)


// This should be programmed to do stuff once there's an acid damage caste
/datum/moba_item/rare/corrosive_acid
	name = "Corrosive Acid"
	description = "<br><b>Deep Burns</b><br>Dealing acid damage to a target causes them to take acid damage equal to 2.5% of their max HP every 1 second for 3 seconds."
	icon_state = "corrosive_acid"
	gold_cost = MOBA_GOLD_PER_MINUTE * 3.125
	unique = TRUE
	component_items = list(
		/datum/moba_item/uncommon/special_acid,
		/datum/moba_item/common/enlarged_plasma,
		/datum/moba_item/common/concentrated_acid,
		/datum/moba_item/common/strong_constitution,
	)

	acid_power = 85
	health = 250
	plasma = 300
	plasma_regen = 6

/datum/moba_item/rare/corrosive_acid/apply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player, restore_plasma_health)
	. = ..()
	RegisterSignal(xeno, COMSIG_ATOM_FIRED_PROJECTILE_HIT, PROC_REF(on_acid_hit))
	RegisterSignal(xeno, COMSIG_MOBA_ACID_DAMAGE_DEALT, PROC_REF(on_acid_damage_deal))
	// If we find a way to do melee acid damage this'll need to be updated

/datum/moba_item/rare/corrosive_acid/unapply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player)
	. = ..()
	UnregisterSignal(xeno, COMSIG_ATOM_FIRED_PROJECTILE_HIT)

/datum/moba_item/rare/corrosive_acid/proc/on_acid_hit(mob/living/carbon/xenomorph/source, mob/living/hit, obj/projectile/shot)
	SIGNAL_HANDLER

	var/list/armorpen_list = list()
	SEND_SIGNAL(source, COMSIG_MOBA_GET_ACID_PENETRATION, armorpen_list)
	if((shot.ammo.flags_ammo_behavior|shot.projectile_override_flags) & AMMO_ACIDIC)
		hit.apply_status_effect(/datum/status_effect/corroding, 0.025, armorpen_list[1])

/datum/moba_item/rare/corrosive_acid/proc/on_acid_damage_deal(mob/living/carbon/xenomorph/source, mob/living/hit)
	SIGNAL_HANDLER

	var/list/armorpen_list = list()
	SEND_SIGNAL(source, COMSIG_MOBA_GET_ACID_PENETRATION, armorpen_list)
	hit.apply_status_effect(/datum/status_effect/corroding, 0.025, armorpen_list[1])


/datum/moba_item/rare/mageslayer
	name = "Acid Neutralizer"
	description = "<br><b>Cast Neutralizer</b><br>Reduce the AP of anyone hit by your slashes or physical abilities by N% for N seconds."
	icon_state = "acid_neutralizer"
	gold_cost = MOBA_GOLD_PER_MINUTE * 2.25
	unique = TRUE
	component_items = list(
		/datum/moba_item/uncommon/viscious_slashes,
		/datum/moba_item/common/acid_armor_resist,
		/datum/moba_item/common/acid_armor_resist,
	)

	attack_speed = -1
	attack_damage = 35
	acid_armor = 12

/datum/moba_item/rare/mageslayer/New(datum/moba_player/creating_player)
	. = ..()
	description = "<br><b>Cast Neutralizer</b><br>Reduce the AP of anyone hit by your slashes or physical abilities by [(1 - /datum/status_effect/acid_neutralized::ap_mult) * 100]% for [/datum/status_effect/acid_neutralized::duration * 0.1] seconds."

/datum/moba_item/rare/mageslayer/apply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player, restore_plasma_health)
	. = ..()
	RegisterSignal(xeno, COMSIG_XENO_PHYSICAL_ABILITY_HIT, PROC_REF(on_ability_hit))
	RegisterSignal(xeno, COMSIG_XENO_ALIEN_ATTACK, PROC_REF(on_attack))

/datum/moba_item/rare/mageslayer/unapply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player)
	. = ..()
	UnregisterSignal(xeno, list(COMSIG_XENO_PHYSICAL_ABILITY_HIT, COMSIG_XENO_ALIEN_ATTACK))

/datum/moba_item/rare/mageslayer/proc/on_attack(datum/source, mob/living/carbon/xenomorph/attacking, damage)
	SIGNAL_HANDLER

	attacking.apply_status_effect(/datum/status_effect/acid_neutralized)

/datum/moba_item/rare/mageslayer/proc/on_ability_hit(datum/source, mob/living/carbon/attacking)
	SIGNAL_HANDLER

	attacking.apply_status_effect(/datum/status_effect/acid_neutralized)


/datum/moba_item/rare/steraks
	name = "High-Stress Carapace Hardening"
	description = "<br><b>Emergency Hardening</b><br>Upon dropping below N% health, gain a shield that absorbs N (+N% bonus HP) damage and decays after N seconds. N second cooldown."
	icon_state = "high_stress_carapace_hardening"
	gold_cost = MOBA_GOLD_PER_MINUTE * 2
	unique = TRUE
	instanced = TRUE
	component_items = list(
		/datum/moba_item/uncommon/viscious_slashes,
		/datum/moba_item/common/strong_constitution,
		/datum/moba_item/common/strong_constitution,
		/datum/moba_item/common/armor_fortification,
	)

	health = 400
	attack_damage = 30
	armor = 10
	var/health_threshold = 0.35
	var/base_shield_damage = 250
	var/bonus_hp_mod = 0.6
	var/decay_time = 6 SECONDS
	var/cooldown_time = 90 SECONDS
	COOLDOWN_DECLARE(shield_cooldown)

/datum/moba_item/rare/steraks/New(datum/moba_player/creating_player)
	. = ..()
	description = "<br><b>Emergency Hardening</b><br>Upon dropping below [health_threshold * 100]% health, gain a shield that absorbs [base_shield_damage] (+[bonus_hp_mod * 100]% bonus HP) damage and decays after [decay_time * 0.1] seconds. [cooldown_time * 0.1] second cooldown."

/datum/moba_item/rare/steraks/handle_pass_data_write(mob/living/carbon/xenomorph/xeno, datum/cause_data/causedata)
	var/list/datum/moba_player/datum_list = list()
	SEND_SIGNAL(xeno, COMSIG_MOBA_GET_PLAYER_DATUM, datum_list)
	datum_list[1].held_item_pass_data["steraks_shield_cd"] = shield_cooldown

/datum/moba_item/rare/steraks/handle_pass_data_read(datum/moba_player/player)
	shield_cooldown = player.held_item_pass_data["steraks_shield_cd"]

/datum/moba_item/rare/steraks/apply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player, restore_plasma_health)
	. = ..()
	RegisterSignal(xeno, COMSIG_MOB_TAKE_DAMAGE, PROC_REF(on_damage))

/datum/moba_item/rare/steraks/unapply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player)
	. = ..()
	UnregisterSignal(xeno, COMSIG_MOB_TAKE_DAMAGE)

/datum/moba_item/rare/steraks/proc/on_damage(mob/living/carbon/xenomorph/source, list/damagedata)
	SIGNAL_HANDLER

	if(!COOLDOWN_FINISHED(src, shield_cooldown))
		return

	if(source.health > (source.getMaxHealth() * health_threshold))
		return

	var/list/bonus_hp_list = list()
	SEND_SIGNAL(source, COMSIG_MOBA_GET_BONUS_HP, bonus_hp_list)

	COOLDOWN_START(src, shield_cooldown, cooldown_time)
	source.add_xeno_shield(base_shield_damage + (bonus_hp_list[1] * bonus_hp_mod), XENO_SHIELD_SOURCE_STERAKS, duration = decay_time, add_shield_on = TRUE, max_shield = INFINITY)


/datum/moba_item/rare/furious_haste
	name = "Oversized Adrenal Glands"
	description = "<br><b>Furious Haste</b><br>Gain N movespeed upon slashing an enemy, stacking up to N times. Decays after N seconds."
	icon_state = "oversized_adrenal"
	gold_cost = MOBA_GOLD_PER_MINUTE * 2
	unique = TRUE
	component_items = list(
		/datum/moba_item/uncommon/heightened_senses,
		/datum/moba_item/uncommon/viscious_slashes,
		/datum/moba_item/common/mending_carapace,
	)

	ability_cooldown_reduction = 0.75
	attack_damage = 35
	health_regen = 8

/datum/moba_item/rare/furious_haste/New(datum/moba_player/creating_player)
	. = ..()
	description = "<br><b>Furious Haste</b><br>Gain [/datum/status_effect/stacking/furious_haste::movespeed_per_stack] movespeed upon slashing an enemy, stacking up to [/datum/status_effect/stacking/furious_haste::max_stacks] times. Decays after [/datum/status_effect/stacking/furious_haste::delay_before_decay * 0.1] seconds."

/datum/moba_item/rare/furious_haste/apply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player, restore_plasma_health)
	. = ..()
	RegisterSignal(xeno, COMSIG_XENO_ALIEN_ATTACK, PROC_REF(on_attack))

/datum/moba_item/rare/furious_haste/unapply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player)
	. = ..()
	UnregisterSignal(xeno, COMSIG_XENO_ALIEN_ATTACK)

/datum/moba_item/rare/furious_haste/proc/on_attack(mob/living/carbon/xenomorph/source, mob/living/carbon/xenomorph/attacking, damage)
	SIGNAL_HANDLER

	var/datum/status_effect/stacking/furious_haste/haste = source.has_status_effect(/datum/status_effect/stacking/furious_haste)
	if(!haste)
		haste = source.apply_status_effect(/datum/status_effect/stacking/furious_haste, 1)
	else
		haste.add_stacks(1)

/datum/moba_item/rare/blood_fury
	name = "Uninhibited Fury"
	description = "<br><b>Kill Frenzy</b><br>Killing an enemy reduces your cooldowns by N seconds or N%, whichever is better."
	icon_state = "uninhibited_fury"
	gold_cost = MOBA_GOLD_PER_MINUTE * 3.25
	unique = TRUE
	component_items = list(
		/datum/moba_item/uncommon/heightened_senses,
		/datum/moba_item/uncommon/penetrating_claws,
	)

	ability_cooldown_reduction = 0.85
	speed = -0.2
	attack_speed = -1
	slash_penetration = 12
	var/second_reduction = 8 SECONDS
	var/percent_reduction = 0.2

/datum/moba_item/rare/blood_fury/New(datum/moba_player/creating_player)
	. = ..()
	description = "<br><b>Kill Frenzy</b><br>Killing an enemy reduces your cooldowns by [second_reduction * 0.1] seconds or [percent_reduction * 100]%, whichever is better."

/datum/moba_item/rare/blood_fury/apply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player, restore_plasma_health)
	. = ..()
	RegisterSignal(xeno, COMSIG_MOB_KILLED_MOB, PROC_REF(on_kill))

/datum/moba_item/rare/blood_fury/unapply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player)
	. = ..()
	UnregisterSignal(xeno, COMSIG_MOB_KILLED_MOB)

/datum/moba_item/rare/blood_fury/proc/on_kill(mob/living/carbon/xenomorph/source, mob/killed_mob)
	SIGNAL_HANDLER

	if(!HAS_TRAIT(killed_mob, TRAIT_MOBA_PARTICIPANT))
		return

	for(var/datum/action/xeno_action/action in source.actions)
		var/time_left = max(action.current_cooldown_start_time + action.current_cooldown_duration - world.time, 0)
		if(!action.owner || time_left <= 0 || action.cooldown_timer_id == TIMER_ID_NULL)
			continue

		var/flat_reduction = max(time_left - second_reduction, 0)
		var/mult_reduction = max(time_left * (1 - percent_reduction), 0)
		var/best_time_left = min(flat_reduction, mult_reduction)

		deltimer(action.cooldown_timer_id)
		action.cooldown_timer_id = addtimer(CALLBACK(action, TYPE_PROC_REF(/datum/action/xeno_action, on_cooldown_end)), best_time_left, TIMER_UNIQUE|TIMER_STOPPABLE)
		action.current_cooldown_duration = best_time_left
		break

/datum/moba_item/rare/hubris // Absurdly expensive "win more" item that should just win you the game if you keep up the kills
	name = "Queen Mother's Hubris"
	description = "<br><b>Body Stacking</b><br>Killing an enemy grants you 10 + (4 x total enemies killed while holding this) extra attack damage for 90 seconds."
	icon_state = "queen_mothers_hubris"
	gold_cost = MOBA_GOLD_PER_MINUTE * 1
	unique = TRUE
	instanced = TRUE
	component_items = list(
		/datum/moba_item/uncommon/viscious_slashes,
		/datum/moba_item/uncommon/viscious_slashes,
		/datum/moba_item/uncommon/penetrating_claws,
		/datum/moba_item/uncommon/heightened_senses,
	)

	ability_cooldown_reduction = 0.8
	attack_damage = 55
	slash_penetration = 10
	speed = -0.1
	var/kills = 0

/datum/moba_item/rare/hubris/apply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player, restore_plasma_health)
	. = ..()
	RegisterSignal(xeno, COMSIG_MOB_KILLED_MOB, PROC_REF(on_kill))

/datum/moba_item/rare/hubris/unapply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player)
	. = ..()
	UnregisterSignal(xeno, COMSIG_MOB_KILLED_MOB)

/datum/moba_item/rare/hubris/handle_pass_data_write(mob/living/carbon/xenomorph/xeno, datum/cause_data/causedata)
	var/list/datum/moba_player/datum_list = list()
	SEND_SIGNAL(xeno, COMSIG_MOBA_GET_PLAYER_DATUM, datum_list)
	datum_list[1].held_item_pass_data["hubris_kills"] = kills

/datum/moba_item/rare/hubris/handle_pass_data_read(datum/moba_player/player)
	kills = player.held_item_pass_data["hubris_kills"]

/datum/moba_item/rare/hubris/proc/on_kill(mob/living/carbon/xenomorph/source, mob/killed_mob)
	SIGNAL_HANDLER

	if(!HAS_TRAIT(killed_mob, TRAIT_MOBA_PARTICIPANT))
		return

	kills++

	source.apply_status_effect(/datum/status_effect/hubris, 10 + (4 * kills))

/datum/moba_item/rare/echo_shard
	name = "Extrasensory Time Dilation"
	description = "<br><b>Active</b><br>Instantly recharge your most recently used non-ultimate ability. Cooldown N seconds."
	icon_state = "extrasensory_time_dilation"
	gold_cost = MOBA_GOLD_PER_MINUTE * 3.5
	instanced = TRUE
	active = TRUE
	unique = TRUE
	active_action_icon_state = "chamber_swap" // the most placeholder of placeholders
	active_cooldown_time = 30 SECONDS
	component_items = list(
		/datum/moba_item/uncommon/special_acid,
		/datum/moba_item/common/superior_stamina,
		/datum/moba_item/common/enlarged_plasma,
		/datum/moba_item/common/enlarged_plasma,
	)

	acid_power = 55
	ability_cooldown_reduction = 0.85
	plasma = 750
	plasma_regen = 8
	var/datum/action/xeno_action/most_recent_ability

/datum/moba_item/rare/echo_shard/apply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player, restore_plasma_health)
	. = ..()
	RegisterSignal(xeno, COMSIG_XENO_USE_XENO_ACTION, PROC_REF(on_ability_use))

/datum/moba_item/rare/echo_shard/unapply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player)
	. = ..()
	UnregisterSignal(xeno, COMSIG_XENO_USE_XENO_ACTION)

/datum/moba_item/rare/echo_shard/proc/on_ability_use(mob/living/carbon/xenomorph/source, datum/action/xeno_action/xeno_ability)
	SIGNAL_HANDLER

	var/datum/component/moba_action/action_comp = xeno_ability.GetComponent(/datum/component/moba_action)
	if(!action_comp)
		return

	if(action_comp.is_ultimate || !xeno_ability.xeno_cooldown)
		return

	most_recent_ability = xeno_ability

/datum/moba_item/rare/echo_shard/active_action_use()
	if(!most_recent_ability || (most_recent_ability.cooldown_timer_id == TIMER_ID_NULL))
		return FALSE
	most_recent_ability.end_cooldown()
	most_recent_ability.owner.balloon_alert_to_viewers("dilates time for [most_recent_ability.name]")
	most_recent_ability = null
	return TRUE

/datum/moba_item/rare/thornmail
	name = "Piercing Spines"
	description = "<br><b>Spiked</b><br>When you take damage from an attack, deal 15 (+60% Armor) physical damage to whoever attacked you and apply healing disruption for 3.5 seconds."
	icon_state = "piercing_spines"
	gold_cost = MOBA_GOLD_PER_MINUTE * 3
	unique = TRUE
	component_items = list(
		/datum/moba_item/uncommon/steel_carapace,
		/datum/moba_item/common/mending_carapace,
		/datum/moba_item/common/strong_constitution,
		/datum/moba_item/common/armor_fortification,
	)

	armor = 25
	acid_armor = 5
	health = 450
	health_regen = 5
	var/base_damage_to_deal = 15
	var/antiheal_time = 3.5 SECONDS

/datum/moba_item/rare/thornmail/apply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player, restore_plasma_health)
	. = ..()
	RegisterSignal(xeno, COMSIG_XENO_ALIEN_ATTACKED, PROC_REF(on_attacked))

/datum/moba_item/rare/thornmail/unapply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player)
	. = ..()
	UnregisterSignal(xeno, COMSIG_XENO_ALIEN_ATTACKED)

/datum/moba_item/rare/thornmail/proc/on_attacked(mob/living/carbon/xenomorph/source, mob/living/carbon/xenomorph/attacking_xeno)
	SIGNAL_HANDLER

	var/add_amount = floor((source.armor_deflection + source.armor_deflection_buff - source.armor_deflection_debuff) * floor(source.armor_integrity / source.armor_integrity_max) * 0.6) //zonenote i'm sus on this proc getting me the right number so check later
	attacking_xeno.apply_armoured_damage(base_damage_to_deal + add_amount, ARMOR_MELEE, BRUTE)
	attacking_xeno.apply_status_effect(/datum/status_effect/antiheal, /datum/status_effect/antiheal::healing_reduction, antiheal_time)
