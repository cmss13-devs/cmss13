/mob/living/carbon
	var/list/claimed_reward_categories = list()

/datum/battlepass_reward
	/// The name of this reward
	var/name = ""
	/// The iconfile that contains the image of this reward
	var/icon = 'core_ru/code/modules/battlepass/rewards/sprites/battlepass.dmi'
	/// The iconstate of the image of this reward
	var/icon_state = "coin_diamond"
	/// What category this item falls under (armor, toy, etc)
	var/category
	/// If this item can bypass the 1-per-category limit
	var/category_limit_bypass = FALSE
	var/lifeform_type = "Marine"

/datum/battlepass_reward/proc/can_claim(mob/target_mob)
	if(!iscarbon(target_mob))
		return FALSE

	var/mob/living/carbon/carbon_mob = target_mob

	if((category in carbon_mob.claimed_reward_categories) && !category_limit_bypass)
		return FALSE

	return TRUE

/datum/battlepass_reward/proc/on_claim(mob/target_mob)
	return

/datum/battlepass_reward/test
	name = "Debug"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "coin_diamond"
