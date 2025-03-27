// 40 gold per AD
// 2.66 gold per health
// 80 gold per health regen
// 20 gold per AP
// 1.152 gold per plasma
// 80 gold per plasma regen
// 96 gold per armor
// 96 gold per acid armor
// 56 gold per 1% cooldown reduction
// 112 gold per slash penetration
// 112 gold per acid penetration
// 100 gold per 0.1 movespeed
// 90 gold per 1% lifesteal
// 500 gold per 1 attack speed

// USUALLY SINGLETONS. SEE `instanced` VARIABLE
/datum/moba_item
	var/name = ""
	// Does not include cost of any components
	var/gold_cost = 0
	// Set at runtime
	var/total_gold_cost = 0
	// Set at runtime unless set manually
	var/sell_value = -1
	/// What item types are used to make this item
	var/list/component_items = list()
	var/description = ""
	var/icon_state = ""
	/// If TRUE, a player can only hold one of this item at a time.
	var/unique = FALSE
	/// If TRUE, this should be a unique object instead of a singleton, thus we can do things like hold data on it
	var/instanced = FALSE
	var/tier = 0

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
	/// Used purely for the scaling of certain abilities
	var/acid_power = 0
	/// 1 = full lifesteal
	var/lifesteal = 0
	/// Flat armor pen, acid and regular
	var/slash_penetration = 0
	/// Same as above but for acid attacks
	var/acid_penetration = 0

/datum/moba_item/New(datum/moba_player/creating_player)
	. = ..()
	gold_cost = floor(gold_cost)
	if(instanced && creating_player)
		set_total_gold_cost()
		set_description()
		RegisterSignal(creating_player.get_tied_xeno(), COMSIG_MOB_DEATH, PROC_REF(handle_pass_data_write)) //zonenote look into moving to qdel or smth
		handle_pass_data_read(creating_player)

/datum/moba_item/proc/set_total_gold_cost()
	total_gold_cost = get_recursive_gold_cost()
	if(sell_value == -1)
		sell_value = total_gold_cost * MOBA_ITEM_SELLBACK_VALUE

/datum/moba_item/proc/get_recursive_gold_cost()
	var/return_gold = gold_cost
	for(var/type in component_items)
		var/datum/moba_item/item = SSmoba.item_dict[type]
		return_gold += item.get_recursive_gold_cost()
	return return_gold

/datum/moba_item/proc/get_factored_cost(list/datum/moba_item/item_list)
	return get_recursive_factored_cost(item_list.Copy())

/datum/moba_item/proc/get_recursive_factored_cost(list/datum/moba_item/item_list)
	var/cost = gold_cost

	for(var/item_path in component_items)
		var/datum/moba_item/located_item = locate(item_path) in item_list
		if(located_item)
			item_list -= located_item
			continue
		cost += SSmoba.item_dict[item_path].get_recursive_factored_cost(item_list)

	return cost

/datum/moba_item/proc/get_recursive_held_components(list/datum/moba_item/item_list)
	var/list/return_list = list()

	for(var/item_path in component_items)
		var/datum/moba_item/located_item = locate(item_path) in item_list
		if(located_item)
			return_list += located_item
			item_list -= located_item
			continue
		return_list += SSmoba.item_dict[item_path].get_recursive_held_components(item_list)

	return return_list

/datum/moba_item/proc/set_description()
	//description = "Cost: [total_gold_cost] [MOBA_GOLD_NAME_SHORT]"
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
	if(acid_power)
		description += "<br>Acid Power: +[acid_power]"
	if(attack_damage)
		description += "<br>Damage: +[attack_damage]"
	if(ability_cooldown_reduction)
		description += "<br>Cooldown Reduction: +[(1 - ability_cooldown_reduction) * 100]%"
	if(lifesteal)
		description += "<br>Lifesteal: [lifesteal * 100]%"
	if(slash_penetration)
		description += "<br>Physical Damage Armor Penetration: [slash_penetration]"
	if(acid_penetration)
		description += "<br>Acid Damage Armor Penetration: [acid_penetration]"

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
	if(ability_cooldown_reduction)
		apply_ability_cooldown_reduction(xeno, player)
	apply_acid_power(xeno, player, component)
	apply_lifesteal(xeno, player, component)
	apply_penetration(xeno, player, component)

/datum/moba_item/proc/unapply_stats(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/component, datum/moba_player/player)
	SHOULD_CALL_PARENT(TRUE)

	xeno.maxHealth -= health
	component.bonus_hp -= health
	component.healing_value_standing -= health_regen
	component.healing_value_resting -= health_regen * MOBA_RESTING_HEAL_MULTIPLIER
	xeno.plasma_max -= plasma
	component.plasma_value_standing -= plasma_regen
	component.plasma_value_resting -= plasma_regen * MOBA_RESTING_HEAL_MULTIPLIER
	xeno.armor_deflection_buff -= armor
	xeno.acid_armor_buff -= acid_armor
	xeno.ability_speed_modifier -= speed
	xeno.attack_speed_modifier -= attack_speed
	xeno.melee_damage_lower -= attack_damage
	xeno.melee_damage_upper -= attack_damage
	component.remove_ap(acid_power)
	if(ability_cooldown_reduction)
		xeno.cooldown_reduction_percentage = xeno.cooldown_reduction_percentage * (1 / ability_cooldown_reduction)
	component.lifesteal -= lifesteal
	component.slash_penetration -= slash_penetration
	component.acid_penetration -= acid_penetration

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
	xeno.armor_deflection_buff += armor

/datum/moba_item/proc/apply_acid_armor(mob/living/carbon/xenomorph/xeno, datum/moba_player/player)
	xeno.acid_armor_buff += acid_armor

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

/datum/moba_item/proc/apply_acid_power(mob/living/carbon/xenomorph/xeno, datum/moba_player/player, datum/component/moba_player/component)
	component.add_ap(acid_power)

/datum/moba_item/proc/apply_lifesteal(mob/living/carbon/xenomorph/xeno, datum/moba_player/player, datum/component/moba_player/component)
	component.lifesteal += lifesteal

/datum/moba_item/proc/apply_penetration(mob/living/carbon/xenomorph/xeno, datum/moba_player/player, datum/component/moba_player/component)
	component.slash_penetration += slash_penetration
	component.acid_penetration += acid_penetration

/datum/moba_item/proc/handle_pass_data_write(mob/living/carbon/xenomorph/xeno, datum/cause_data/causedata)
	SIGNAL_HANDLER

	return

/datum/moba_item/proc/handle_pass_data_read(datum/moba_player/player)

	return

/datum/moba_item/common
	tier = 1

/datum/moba_item/uncommon
	tier = 2

/datum/moba_item/rare
	tier = 3
