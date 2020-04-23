#define MUTATOR_GAIN_PER_QUEEN_LEVEL 6
#define MUTATOR_GAIN_PER_XENO_LEVEL 3

//A class that holds mutators for a given Xeno hive
//Each time a Queen matures, the hive gets more points
//Each time a Queen dies, the mutators are reset

//The class contains a lot of variables that are applied to various xenos' stats and actions
/datum/mutator_set
	var/remaining_points = 0 //How many points the xeno / hive still has to spend on mutators
	var/list/purchased_mutators = list() //List of purchased mutators
	var/user_level = -1 //Level of the Queen for Hive or the individual xeno. Starting at -1 so at tier 0 you'd get some mutators to play with

	var/tackle_chance_multiplier = 1.0
	var/tackle_strength_bonus = 0

//Functions to be overloaded to call for when something gets updated on the xenos
/datum/mutator_set/proc/recalculate_everything(var/description)
/datum/mutator_set/proc/recalculate_stats(var/description)
/datum/mutator_set/proc/recalculate_actions(var/description)
/datum/mutator_set/proc/recalculate_pheromones(var/description)
/datum/mutator_set/proc/give_feedback(var/description)


/datum/mutator_set/proc/purchase_mutator(var/name)
	return FALSE

/datum/mutator_set/proc/list_and_purchase_mutators()
	var/list/mutators_for_purchase = available_mutators()
	if(mutators_for_purchase.len == 0)
		to_chat(usr, "You can't take another strain.")
	var/pick = input("Which strain would you like to purchase?") as null|anything in mutators_for_purchase
	if(!pick)
		return FALSE
	if(alert(usr, "[xeno_mutator_list[pick].description]\n\nConfirm mutation?", "Strain purchase", "Yes", "No") == "No")		return
	if(xeno_mutator_list[pick].apply_mutator(src))
		to_chat(usr, "Mutation complete!")
		return TRUE
	else
		to_chat(usr, "Mutation failed!")
		return FALSE
	return FALSE

/datum/mutator_set/proc/can_purchase_mutator(var/mutator_name)
	var/datum/xeno_mutator/XM = xeno_mutator_list[mutator_name]
	if(user_level < XM.required_level)
		return FALSE //xeno doesn't meet the level requirements
	if(remaining_points < XM.cost)
		return FALSE //mutator is too expensive
	if(XM.unique)
		if(XM.name in purchased_mutators)
			return FALSE //unique mutator already purchased
	if(XM.keystone)
		for(var/name in purchased_mutators)
			if(xeno_mutator_list[name].keystone)
				return FALSE //We already have a keystone mutator
	if(XM.flaw)
		for(var/name in purchased_mutators)
			if(xeno_mutator_list[name].flaw)
				return FALSE //We already have a flaw mutator
	return TRUE

//Lists mutators available for purchase
/datum/mutator_set/proc/available_mutators()
	var/list/can_purchase = list()

	for(var/str in xeno_mutator_list)
		if (can_purchase_mutator(str))
			can_purchase += str //can purchase!

	return can_purchase

//Mutators applying to the Hive as a whole
/datum/mutator_set/hive_mutators
	var/datum/hive_status/hive //Which hive do these mutators apply to. Need this to affect variables there
	var/leader_count_boost = 0
	var/maturation_multiplier = 1.0
	var/tier_slot_multiplier = 1.0
	var/larva_gestation_multiplier = 1.0
	var/bonus_larva_spawn_chance = 0

/datum/mutator_set/hive_mutators/list_and_purchase_mutators()
	if(!hive || !hive.living_xeno_queen)
		return //somehow Queen is not set but this function was called...
	if(hive.living_xeno_queen.is_dead())
		return //Dead xenos can't mutate!
	if(hive.living_xeno_queen.hardcore)
		to_chat(usr, SPAN_WARNING("No time for that, must KILL!"))
		return
	if(!hive.living_xeno_queen.ovipositor)
		to_chat(usr, "You must be in Ovipositor to purchase Hive Mutators.")
		return
	. = ..()
	if (. == TRUE && purchased_mutators.len)
		var/m = purchased_mutators[purchased_mutators.len]
		log_mutator("[hive.living_xeno_queen.name] purchased Hive Mutator '[m]'")

/datum/mutator_set/hive_mutators/proc/user_levelled_up(var/new_level)
	if(user_level == new_level || new_level == -1) //-1 is for Predaliens
		return //nothing to level up!
	if(user_level > new_level)
		//Something went wrong!
		log_debug("Invalid mutator level-up! Let the devs know!")
		return
	remaining_points += MUTATOR_GAIN_PER_QUEEN_LEVEL * (new_level - user_level)
	user_level = new_level

/datum/mutator_set/hive_mutators/can_purchase_mutator(var/mutator_name)
	if (..() == FALSE)
		return FALSE //Can't buy it regardless
	var/datum/xeno_mutator/XM = xeno_mutator_list[mutator_name]
	if(XM.individual_only)
		return FALSE //We can't buy individual mutators on a Hive level
	return TRUE

//Called when the Queen dies
// This isn't currently used, but if anyone wants to, expect it to be broken because
// I haven't made any effort to integrate it into the new system (Fourkhan, 5/11/19)
/datum/mutator_set/hive_mutators/proc/reset_mutators()
	if(purchased_mutators.len == 0)
		//No mutators purchased, nothing to reset!
		return

	var/depowered = FALSE
	for(var/name in purchased_mutators)
		if(!xeno_mutator_list[name].death_persistent)
			purchased_mutators -= name
			depowered = TRUE

	if(!depowered)
		return //We haven't lost anything

	tackle_chance_multiplier = 1.0
	tackle_strength_bonus = 0

	leader_count_boost = 0
	maturation_multiplier = 1.0
	tier_slot_multiplier = 1.0
	larva_gestation_multiplier = 1.0
	bonus_larva_spawn_chance = 0

	for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
		if(X.hivenumber == hive.hivenumber)
			X.recalculate_everything()
			to_chat(X, SPAN_XENOANNOUNCE("Queen's influence wanes. You feel weak!"))
			playsound(X.loc, "alien_help", 25)
			X.xeno_jitter(15)

/datum/mutator_set/hive_mutators/recalculate_everything(var/description)
	for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
		if(X.hivenumber == hive.hivenumber)
			X.recalculate_everything()
			to_chat(X, SPAN_XENOANNOUNCE("Queen has granted the Hive a boon! [description]"))
			X.xeno_jitter(15)
/datum/mutator_set/hive_mutators/recalculate_stats(var/description)
	for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
		if(X.hivenumber == hive.hivenumber)
			X.recalculate_stats()
			to_chat(X, SPAN_XENOANNOUNCE("Queen has granted the Hive a boon! [description]"))
			X.xeno_jitter(15)
/datum/mutator_set/hive_mutators/recalculate_actions(var/description)
	for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
		if(X.hivenumber == hive.hivenumber)
			X.recalculate_actions()
			to_chat(X, SPAN_XENOANNOUNCE("Queen has granted the Hive a boon! [description]"))
			X.xeno_jitter(15)
/datum/mutator_set/hive_mutators/recalculate_pheromones(var/description)
	for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
		if(X.hivenumber == hive.hivenumber)
			X.recalculate_pheromones()
			to_chat(X, SPAN_XENOANNOUNCE("Queen has granted the Hive a boon! [description]"))
			X.xeno_jitter(15)
/datum/mutator_set/hive_mutators/proc/recalculate_maturation(var/description)
	for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
		if(X.hivenumber == hive.hivenumber)
			X.recalculate_maturation()
			to_chat(X, SPAN_XENOANNOUNCE("Queen has granted the Hive a boon! [description]"))
			X.xeno_jitter(15)
/datum/mutator_set/hive_mutators/proc/recalculate_hive(var/description)
	hive.recalculate_hive()
	give_feedback(description)
/datum/mutator_set/hive_mutators/give_feedback(var/description)
	for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
		if(X.hivenumber == hive.hivenumber)
			to_chat(X, SPAN_XENOANNOUNCE("Queen has granted the Hive a boon! [description]"))
			X.xeno_jitter(15)

//Mutators applying to an individual xeno
/datum/mutator_set/individual_mutators
	var/mob/living/carbon/Xenomorph/xeno
	var/pull_multiplier = 1.0
	var/egg_laying_multiplier = 1.0
	var/need_weeds = TRUE
	//Strains Below
	remaining_points = 6


/datum/mutator_set/individual_mutators/Dispose()
	if(xeno)
		xeno.mutators = null
		xeno = null
	. = ..()

/datum/mutator_set/individual_mutators/list_and_purchase_mutators()
	. = ..()
	if (. == TRUE && purchased_mutators.len)
		var/m = purchased_mutators[purchased_mutators.len]
		log_mutator("[xeno.name] purchased Mutator '[m]'")

/datum/mutator_set/individual_mutators/proc/user_levelled_up(var/new_level)
	if(xeno.hardcore)
		remaining_points = 0
		return
	if(user_level == new_level || new_level == -1) //-1 is for Predaliens
		return //nothing to level up!
	if(user_level > new_level)
		//Something went wrong!
		log_debug("Invalid mutator level-up! Let the devs know!")
		return
	remaining_points += MUTATOR_GAIN_PER_XENO_LEVEL * (new_level - user_level)
	user_level = new_level

/datum/mutator_set/individual_mutators/can_purchase_mutator(var/mutator_name)
	if (..() == FALSE)
		return FALSE //Can't buy it regardless
	var/datum/xeno_mutator/XM = xeno_mutator_list[mutator_name]
	if(XM.hive_only)
		return FALSE //We can't buy Hive mutators on an individual level
	if(XM.caste_whitelist && (XM.caste_whitelist.len > 0) && !(xeno.caste_name in XM.caste_whitelist))
		return FALSE //We are not on the whitelist
	return TRUE

/datum/mutator_set/individual_mutators/recalculate_actions(var/description, var/flavor_description = null)
	xeno.recalculate_actions()
	to_chat(xeno, SPAN_XENOANNOUNCE("[description]"))
	if (flavor_description != null)
		to_chat(xeno, SPAN_XENOLEADER("[flavor_description]"))
	xeno.xeno_jitter(15)


/mob/living/carbon/Xenomorph/Queen/verb/purchase_hive_mutators()
	set name = "Purchase Hive Mutators"
	set desc = "Purchase Mutators affecting the entire Hive."
	set category = "Alien"
	if(hardcore)
		to_chat(usr, SPAN_WARNING("No time for that, must KILL!"))
		return
	src.hive.mutators.list_and_purchase_mutators()

/mob/living/carbon/Xenomorph/verb/purchase_strains()
	set name = "Purchase Strains"
	set desc = "Purchase Strains for yourself."
	set category = "Alien"
	if(hardcore)
		to_chat(usr, SPAN_WARNING("No time for that, must KILL!"))
		return
	if(is_dead())
		return //Dead xenos can't mutate!
	src.mutators.list_and_purchase_mutators()

/mob/living/carbon/Xenomorph/verb/list_mutators()
	set name = "List Strains"
	set desc = "List your current Strain, if any."
	set category = "Alien"
	if(hardcore)
		to_chat(usr, SPAN_WARNING("No time for that, must KILL!"))
		return
	to_chat(src, SPAN_XENOANNOUNCE("Strain:"))
	if(!src.mutators.purchased_mutators || !src.mutators.purchased_mutators.len)
		to_chat(src, "-")
	else
		for(var/m in src.mutators.purchased_mutators)
			to_chat(src, m)
