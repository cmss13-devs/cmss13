/datum/moba_item/rare/shredder_claws
	name = "Rending Claws"
	description = "<b>Armor Shred</b><br>Remove N% of the armor of anyone slashed. Stacks up to N, lasting N seconds since your last attack."
	icon_state = "red"
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
	description = "<b>Armor Shred</b><br>Remove [/datum/status_effect/stacking/rended_armor::shred_per_stack]% of the armor of anyone slashed. Stacks up to [/datum/status_effect/stacking/rended_armor::max_stacks], lasting [/datum/status_effect/stacking/rended_armor::delay_before_decay * 0.1] seconds since your last attack."

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
		rended = attacking.apply_status_effect(/datum/status_effect/stacking/rended_armor)
	rended.add_stacks(1)


// This should be programmed to do stuff once there's an acid damage caste
/datum/moba_item/rare/corrosive_acid
	name = "Corrosive Acid"
	icon_state = "red"
	gold_cost = MOBA_GOLD_PER_MINUTE * 2.75
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

/datum/moba_item/rare/corrosive_acid/apply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player, restore_plasma_health)
	. = ..()


/datum/moba_item/rare/corrosive_acid/unapply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player)
	. = ..()


/datum/moba_item/rare/corrosive_acid/proc/on_acid_hit()
	SIGNAL_HANDLER

	return


/datum/moba_item/rare/mageslayer
	name = "Acid Neutralizer"
	description = "<b>Cast Neutralizer</b><br>Reduce the AP of anyone hit by your slashes or physical abilities by N% for N seconds."
	icon_state = "red"
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
	description = "<b>Cast Neutralizer</b><br>Reduce the AP of anyone hit by your slashes or physical abilities by [(1 - /datum/status_effect/acid_neutralized::ap_mult) * 100]% for [/datum/status_effect/acid_neutralized::duration * 0.1] seconds."

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
	description = "<b>Emergency Hardening</b><br>Upon dropping below N% health, gain a shield that absorbs N (+N% bonus HP) damage and decays after N seconds. N second cooldown."
	icon_state = "red"
	gold_cost = MOBA_GOLD_PER_MINUTE * 2.25
	unique = TRUE
	instanced = TRUE
	component_items = list(
		/datum/moba_item/uncommon/viscious_slashes,
		/datum/moba_item/common/acid_armor_resist,
		/datum/moba_item/common/acid_armor_resist,
	)

	attack_speed = -1
	attack_damage = 35
	acid_armor = 12
	var/health_threshold = 0.35
	var/base_shield_damage = 250
	var/bonus_hp_mod = 0.6
	var/decay_time = 6 SECONDS
	var/cooldown_time = 90 SECONDS
	COOLDOWN_DECLARE(shield_cooldown)

/datum/moba_item/rare/steraks/New(datum/moba_player/creating_player)
	. = ..()
	description = "<b>Emergency Hardening</b><br>Upon dropping below [health_threshold * 100]% health, gain a shield that absorbs [base_shield_damage] (+[bonus_hp_mod * 100]% bonus HP) damage and decays after [decay_time * 0.1] seconds. [cooldown_time * 0.1] second cooldown."

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
