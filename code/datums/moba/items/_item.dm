GLOBAL_LIST_EMPTY(moba_item_desc_dict)

/datum/moba_item
	var/name = ""
	var/gold_cost = 0
	var/description = ""
	var/icon_state = ""
	/// If TRUE, a player can only hold one of this item at a time.
	var/unique = FALSE

	var/health = 0
	var/health_regen = 0
	var/plasma = 0
	var/plasma_regen = 0
	var/armor = 0
	var/acid_armor = 0
	/// Negative is better
	var/speed = 0
	/// Negative is better. Each 1 is a 10th a second of delay
	var/attack_speed = 0
	var/attack_damage = 0
	/// Diminishing, multiplier (0.25 would cut down the remaining cooldown by 75%)
	var/ability_cooldown_reduction = 0

	var/amount_armor_applied = 0
	var/amount_acid_armor_applied = 0

/datum/moba_item/New()
	. = ..()
	if(!GLOB.moba_item_desc_dict[type])
		description = "Cost: [gold_cost] [MOBA_GOLD_NAME_SHORT]"
		if(health)
			description += "<br>Health: +[health]"
		if(health_regen)
			description += "<br>Health Regen: +[health_regen]"
		if(plasma)
			description += "<br>Plasma: +[plasma]"
		if(plasma_regen)
			description += "<br>Plasma Regen: +[plasma_regen]"
		if(armor)
			description += "<br>Armor: +[armor]"
		if(acid_armor)
			description += "<br>Acid Armor: +[acid_armor]"
		if(speed)
			description += "<br>Movement Delay: [speed]"
		if(attack_speed)
			description += "<br>Attack Speed Modifier: [attack_speed]"
		if(attack_damage)
			description += "<br>Damage: +[attack_damage]"
		if(ability_cooldown_reduction)
			description += "<br>Cooldown Reduction: x[ability_cooldown_reduction * 100]%"
		GLOB.moba_item_desc_dict[type] = description
	else
		description = GLOB.moba_item_desc_dict[type]


/datum/moba_item/proc/apply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player, restore_plasma_health = FALSE)
	SHOULD_CALL_PARENT(TRUE)

	apply_health(xeno, player, component, restore_plasma_health)
	apply_health_regen(xeno, player, component)
	apply_plasma(xeno, player, restore_plasma_health)
	apply_plasma_regen(xeno, player, component)
	apply_armor(xeno, player)
	apply_acid_armor(xeno, player)
	apply_speed(xeno, player)
	apply_attack_speed(xeno, player)
	apply_attack_damage(xeno, player)
	apply_ability_cooldown_reduction(xeno, player)

/datum/moba_item/proc/unapply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player)
	SHOULD_CALL_PARENT(TRUE)

	xeno.maxHealth -= health
	component.bonus_hp -= health
	component.healing_value_standing -= health_regen
	component.healing_value_resting -= health_regen * MOBA_RESTING_HEAL_MULTIPLIER
	xeno.plasma_max -= plasma
	component.healing_value_standing -= plasma_regen
	component.healing_value_resting -= plasma_regen * MOBA_RESTING_HEAL_MULTIPLIER
	xeno.armor_deflection_buff -= amount_armor_applied
	xeno.acid_armor_buff -= amount_acid_armor_applied
	xeno.ability_speed_modifier -= speed
	xeno.attack_speed_modifier -= attack_speed
	xeno.melee_damage_lower -= attack_damage
	xeno.melee_damage_upper -= attack_damage
	if(ability_cooldown_reduction)
		xeno.cooldown_reduction_percentage = xeno.cooldown_reduction_percentage * (1 / ability_cooldown_reduction)

	amount_armor_applied = 0
	amount_acid_armor_applied = 0

/datum/moba_item/proc/apply_health(mob/living/carbon/xenomorph/xeno, datum/moba_player/player, datum/component/moba_player/component, restore_plasma_health = FALSE)
	xeno.maxHealth += health
	if(restore_plasma_health)
		xeno.health += health
	component.bonus_hp += health

/datum/moba_item/proc/apply_health_regen(mob/living/carbon/xenomorph/xeno, datum/moba_player/player, datum/component/moba_player/component)
	component.healing_value_standing += health_regen
	component.healing_value_resting += health_regen * MOBA_RESTING_HEAL_MULTIPLIER

/datum/moba_item/proc/apply_plasma(mob/living/carbon/xenomorph/xeno, datum/moba_player/player, restore_plasma_health = FALSE)
	xeno.plasma_max += plasma
	if(restore_plasma_health)
		xeno.plasma_stored += plasma

/datum/moba_item/proc/apply_plasma_regen(mob/living/carbon/xenomorph/xeno, datum/moba_player/player, datum/component/moba_player/component)
	component.healing_value_standing += plasma_regen
	component.healing_value_resting += plasma_regen * MOBA_RESTING_HEAL_MULTIPLIER

/datum/moba_item/proc/apply_armor(mob/living/carbon/xenomorph/xeno, datum/moba_player/player)
	//amount_armor_applied = armor * (1 - (xeno.armor_deflection_buff / 100))
	amount_armor_applied = armor
	xeno.armor_deflection_buff += amount_armor_applied

/datum/moba_item/proc/apply_acid_armor(mob/living/carbon/xenomorph/xeno, datum/moba_player/player)
	//amount_acid_armor_applied = acid_armor * (1 - (xeno.acid_armor_buff / 100))
	amount_acid_armor_applied = acid_armor
	xeno.acid_armor_buff += amount_acid_armor_applied

/datum/moba_item/proc/apply_speed(mob/living/carbon/xenomorph/xeno, datum/moba_player/player)
	xeno.ability_speed_modifier += speed // yes this is the right var

/datum/moba_item/proc/apply_attack_speed(mob/living/carbon/xenomorph/xeno, datum/moba_player/player)
	xeno.attack_speed_modifier += attack_speed

/datum/moba_item/proc/apply_attack_damage(mob/living/carbon/xenomorph/xeno, datum/moba_player/player)
	xeno.melee_damage_lower += attack_damage
	xeno.melee_damage_upper += attack_damage

/datum/moba_item/proc/apply_ability_cooldown_reduction(mob/living/carbon/xenomorph/xeno, datum/moba_player/player)
	xeno.cooldown_reduction_percentage = xeno.cooldown_reduction_percentage + ((1 - xeno.cooldown_reduction_percentage) * (1 - ability_cooldown_reduction))
	// This took me a hot minute on a whiteboard to figure out
	// This is all because cooldown_reduction_percentage isn't just a straight multiplier on the cooldown, it's 1 minus this number.
