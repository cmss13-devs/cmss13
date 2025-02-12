/datum/moba_item
	var/name = ""
	var/gold_cost = 0

	var/health = 0
	/// Adds to a multiplier
	var/health_regen = 0
	var/plasma = 0
	/// Adds to a multiplier
	var/plasma_regen = 0
	/// Diminishing
	var/armor = 0
	/// Diminishing
	var/acid_armor = 0
	/// Negative is better
	var/speed = 0
	/// Each 0.1 is a tenth of a second less delay. Negative is better
	var/attack_speed = 0
	var/attack_damage = 0

	var/amount_armor_applied = 0
	var/amount_acid_armor_applied = 0

/datum/moba_item/proc/apply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player, restore_plasma_health = FALSE)
	SHOULD_CALL_PARENT(TRUE)

	apply_health(xeno, player, restore_plasma_health)
	apply_health_regen(xeno, player)
	apply_plasma(xeno, player, restore_plasma_health)
	apply_plasma_regen(xeno, player)
	apply_armor(xeno, player)
	apply_acid_armor(xeno, player)
	apply_speed(xeno, player)
	apply_attack_speed(xeno, player)
	apply_attack_damage(xeno, player)

/datum/moba_item/proc/unapply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player)
	SHOULD_CALL_PARENT(TRUE)

	xeno.maxHealth -= health
	xeno.regeneration_multiplier -= health_regen
	xeno.plasma_max -= plasma
	xeno.plasma_regeneration_mult -= plasma_regen
	xeno.armor_deflection_buff -= amount_armor_applied
	xeno.acid_armor_buff -= amount_acid_armor_applied
	xeno.ability_speed_modifier -= speed
	xeno.attack_speed_modifier -= attack_speed
	xeno.melee_damage_lower -= attack_damage
	xeno.melee_damage_upper -= attack_damage

	amount_armor_applied = 0
	amount_acid_armor_applied = 0

/datum/moba_item/proc/apply_health(mob/living/carbon/xenomorph/xeno, datum/moba_player/player, restore_plasma_health = FALSE)
	xeno.maxHealth += health
	if(restore_plasma_health)
		xeno.health += health

/datum/moba_item/proc/apply_health_regen(mob/living/carbon/xenomorph/xeno, datum/moba_player/player)
	xeno.regeneration_multiplier += health_regen

/datum/moba_item/proc/apply_plasma(mob/living/carbon/xenomorph/xeno, datum/moba_player/player, restore_plasma_health = FALSE)
	xeno.plasma_max += plasma
	if(restore_plasma_health)
		xeno.plasma_stored += plasma

/datum/moba_item/proc/apply_plasma_regen(mob/living/carbon/xenomorph/xeno, datum/moba_player/player)
	xeno.plasma_regeneration_mult += plasma_regen

/datum/moba_item/proc/apply_armor(mob/living/carbon/xenomorph/xeno, datum/moba_player/player)
	amount_armor_applied = armor * (1 - (xeno.armor_deflection_buff / 100))
	xeno.armor_deflection_buff += amount_armor_applied

/datum/moba_item/proc/apply_acid_armor(mob/living/carbon/xenomorph/xeno, datum/moba_player/player)
	amount_acid_armor_applied = acid_armor * (1 - (xeno.acid_armor_buff / 100))
	xeno.acid_armor_buff += amount_acid_armor_applied

/datum/moba_item/proc/apply_speed(mob/living/carbon/xenomorph/xeno, datum/moba_player/player)
	xeno.ability_speed_modifier += speed // yes this is the right var

/datum/moba_item/proc/apply_attack_speed(mob/living/carbon/xenomorph/xeno, datum/moba_player/player)
	xeno.attack_speed_modifier += attack_speed

/datum/moba_item/proc/apply_attack_damage(mob/living/carbon/xenomorph/xeno, datum/moba_player/player)
	xeno.melee_damage_lower += attack_damage
	xeno.melee_damage_upper += attack_damage
