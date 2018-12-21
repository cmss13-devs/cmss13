//A class that holds mutators for a given Xeno hive
//Each time a Queen matures, the hive gets more points
//Each time a Queen dies, the mutators are reset

//The class contains a lot of variables that are applied to various xenos' stats and actions

#define MUTATOR_COST_CHEAP 2
#define MUTATOR_COST_MODERATE 3
#define MUTATOR_COST_EXPENSIVE 6

#define MUTATOR_GAIN_PER_QUEEN_LEVEL 6
#define MUTATOR_GAIN_PER_XENO_LEVEL 6


/datum/mutator_set
	var/remaining_points = 0 //How many points the xeno / hive still has to spend on mutators
	var/list/purchased_mutators = list() //List of purchased mutators
	var/user_level = -1 //Level of the Queen for Hive or the individual xeno. Starting at -1 so at tier 0 you'd get some mutators to play with

	//Variables that affect the xeno / all xenos of the hive:
	var/health_multiplier = 1.0
	var/plasma_multiplier = 1.0
	var/plasma_gain_multiplier = 1.0
	var/speed_boost = 0.0
	var/damage_multiplier = 1.0
	var/armor_multiplier = 1.0
	var/acid_boost_level = 0
	var/pheromones_boost_level = 0
	var/weed_boost_level = 0

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
		usr << "You can't afford any more mutators."
	var/pick = input("Which mutator would you like to purchase?") as null|anything in mutators_for_purchase
	if(!pick)
		return
	if(xeno_mutator_list[pick].apply_mutator(src))
		usr << "Mutation complete!"
	else
		usr << "Mutation failed!"
	return

/datum/mutator_set/proc/can_purchase_mutator(var/mutator_name)
	var/datum/xeno_mutator/XM = xeno_mutator_list[mutator_name]
	if(user_level < XM.required_level)
		return FALSE //xeno doesn't meet the level requirements
	if(remaining_points < XM.cost)
		return FALSE //mutator is too expensive
	if(XM.unique)
		if(XM.name in purchased_mutators)
			return FALSE //unique mutator already purchased
	return TRUE

//Lists mutators available for purchase
/datum/mutator_set/proc/available_mutators()
	var/list/can_purchase = list()
	if(!remaining_points) //No points - can't buy anything
		return can_purchase

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
	if(hive.living_xeno_queen.hardcore)
		usr << "<span class='warning'>No time for that, must KILL!</span>"
		return
	if(!hive.living_xeno_queen.ovipositor)
		usr << "You must be in Ovipositor to purchase Hive Mutators."
		return
	. = ..()

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

	//Resetting variables
	remaining_points = 0
	user_level = -1
	health_multiplier = 1.0
	plasma_multiplier = 1.0
	plasma_gain_multiplier = 1.0
	speed_boost = 0.0
	damage_multiplier = 1.0
	armor_multiplier = 1.0
	acid_boost_level = 0
	pheromones_boost_level = 0
	weed_boost_level = 0
	
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
			X << "<span class='xenoannounce'>Queen's influence wanes. You feel weak!</span>"
			playsound(X.loc, "alien_help", 25)
			X.xeno_jitter(15)

/datum/mutator_set/hive_mutators/recalculate_everything(var/description)
	for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
		if(X.hivenumber == hive.hivenumber)
			X.recalculate_everything()
			X << "<span class='xenoannounce'>Queen has granted the Hive a boon! [description]</span>"
			X.xeno_jitter(15)
/datum/mutator_set/hive_mutators/recalculate_stats(var/description)
	for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
		if(X.hivenumber == hive.hivenumber)
			X.recalculate_stats()
			X << "<span class='xenoannounce'>Queen has granted the Hive a boon! [description]</span>"
			X.xeno_jitter(15)
/datum/mutator_set/hive_mutators/recalculate_actions(var/description)
	for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
		if(X.hivenumber == hive.hivenumber)
			X.recalculate_actions()
			X << "<span class='xenoannounce'>Queen has granted the Hive a boon! [description]</span>"
			X.xeno_jitter(15)
/datum/mutator_set/hive_mutators/recalculate_pheromones(var/description)
	for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
		if(X.hivenumber == hive.hivenumber)
			X.recalculate_pheromones()
			X << "<span class='xenoannounce'>Queen has granted the Hive a boon! [description]</span>"
			X.xeno_jitter(15)
/datum/mutator_set/hive_mutators/proc/recalculate_maturation(var/description)
	for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
		if(X.hivenumber == hive.hivenumber)
			X.recalculate_maturation()
			X << "<span class='xenoannounce'>Queen has granted the Hive a boon! [description]</span>"
			X.xeno_jitter(15)
/datum/mutator_set/hive_mutators/proc/recalculate_hive(var/description)
	hive.recalculate_hive()
	give_feedback(description)
/datum/mutator_set/hive_mutators/give_feedback(var/description)
	for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
		if(X.hivenumber == hive.hivenumber)
			X << "<span class='xenoannounce'>Queen has granted the Hive a boon! [description]</span>"
			X.xeno_jitter(15)


//Mutators applying to an individual xeno
/datum/mutator_set/individual_mutators
	var/mob/living/carbon/Xenomorph/xeno
	var/gas_boost_level = 0
	var/pull_multiplier = 1.0
	var/carry_boost_level = 0
	var/egg_laying_multiplier = 1.0
	var/pounce_boost = 0

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

/datum/mutator_set/individual_mutators/recalculate_everything(var/description)
	xeno.recalculate_everything()
	xeno << "<span class='xenoannounce'>[description]</span>"
	xeno.xeno_jitter(15)
/datum/mutator_set/individual_mutators/recalculate_stats(var/description)
	xeno.recalculate_stats()
	xeno << "<span class='xenoannounce'>[description]</span>"
	xeno.xeno_jitter(15)
/datum/mutator_set/individual_mutators/recalculate_actions(var/description)
	xeno.recalculate_actions()
	xeno << "<span class='xenoannounce'>[description]</span>"
	xeno.xeno_jitter(15)
/datum/mutator_set/individual_mutators/recalculate_pheromones(var/description)
	xeno.recalculate_pheromones()
	xeno << "<span class='xenoannounce'>[description]</span>"
	xeno.xeno_jitter(15)
/datum/mutator_set/individual_mutators/give_feedback(var/description)
	xeno << "<span class='xenoannounce'>[description]</span>"
	xeno.xeno_jitter(15)

/mob/living/carbon/Xenomorph/Queen/verb/purchase_hive_mutators()
	set name = "Purchase Hive Mutators"
	set desc = "Purchase Mutators affecting the entire Hive."
	set category = "Alien"
	if(hardcore)
		usr << "<span class='warning'>No time for that, must KILL!</span>"
		return
	src.hive.mutators.list_and_purchase_mutators()

/mob/living/carbon/Xenomorph/verb/purchase_mutators()
	set name = "Purchase Mutators"
	set desc = "Purchase Mutators for yourself."
	set category = "Alien"
	if(hardcore)
		usr << "<span class='warning'>No time for that, must KILL!</span>"
		return
	src.mutators.list_and_purchase_mutators()

/mob/living/carbon/Xenomorph/verb/list_mutators()
	set name = "List Mutators"
	set desc = "List Mutators that apply to you."
	set category = "Alien"
	if(hardcore)
		usr << "<span class='warning'>No time for that, must KILL!</span>"
		return
	src << "<span class='xenoannounce'>Mutators</span>"
	src << "Personal mutators:"
	if(!src.mutators.purchased_mutators || !src.mutators.purchased_mutators.len)
		src << "-"
	else
		for(var/m in src.mutators.purchased_mutators)
			src << m
	src << "Hive mutators:"
	if(!src.hive.mutators.purchased_mutators || !src.hive.mutators.purchased_mutators.len)
		src << "-"
	else
		for(var/m in src.hive.mutators.purchased_mutators)
			src << m


//Individual mutator
/datum/xeno_mutator
	var/name = "Mutator name" //Name of the mutator, should be short but informative
	var/description = "Mutator description" //Description to be displayed on purchase
	var/cost = MUTATOR_COST_CHEAP //How expensive the mutator is
	var/required_level = 0 //Level of xeno upgrade required to unlock
	var/unique = TRUE //True if you can only buy it once
	var/death_persistent = FALSE //True if the mutators persists after Queen death (aka, mostly for "once ever" mutators)
	var/hive_only = FALSE //Hive-only mutators
	var/individual_only = FALSE //Individual-only mutators
	var/list/caste_whitelist = list() //List of the only castes that can buy this mutator

/datum/xeno_mutator/New()
	. = ..()
	name = "[name] ([cost] points)"


/datum/xeno_mutator/proc/apply_mutator(datum/mutator_set/MS)
	if(MS.remaining_points < cost)
		return 0
	MS.remaining_points -= cost
	MS.purchased_mutators += name
	return 1

/datum/xeno_mutator/health
	//Boosts xeno health
	name = "Boost health"
	description = "Your internals harden and grow stronger."
	cost = MUTATOR_COST_EXPENSIVE

/datum/xeno_mutator/health/apply_mutator(datum/mutator_set/MS)
	. = ..()
	if(. == 0)
		return
	MS.health_multiplier *= 1.1
	MS.recalculate_stats(description)

/datum/xeno_mutator/plasma
	//Boosts xeno plasma
	name = "Boost plasma"
	description = "Your bile sacks expand."
	cost = MUTATOR_COST_EXPENSIVE

/datum/xeno_mutator/plasma/apply_mutator(datum/mutator_set/MS)
	. = ..()
	if(. == 0)
		return
	MS.plasma_multiplier *= 1.2
	MS.recalculate_stats(description)

/datum/xeno_mutator/larva
	//Gives hive an infusion of larva
	name = "Get an infusion of larva"
	description = "New larvae join the Hive."
	hive_only = TRUE
	unique = TRUE //Can only buy once
	cost = MUTATOR_COST_EXPENSIVE
	death_persistent = TRUE

/datum/xeno_mutator/larva/apply_mutator(datum/mutator_set/hive_mutators/MS)
	if(!istype(MS))
		return 0
	. = ..()
	if(. == 0)
		return
	MS.hive.stored_larva += 5
	MS.give_feedback(description)

/datum/xeno_mutator/damage
	//Stronger claws
	name = "Boost damage"
	description = "Your claws sharpen."
	cost = MUTATOR_COST_EXPENSIVE

/datum/xeno_mutator/damage/apply_mutator(datum/mutator_set/MS)
	. = ..()
	if(. == 0)
		return
	MS.damage_multiplier *= 1.075
	MS.recalculate_stats(description)

/datum/xeno_mutator/armor
	//Strong armour
	name = "Boost armor"
	description = "Your hide thickens."
	cost = MUTATOR_COST_EXPENSIVE

/datum/xeno_mutator/armor/apply_mutator(datum/mutator_set/MS)
	. = ..()
	if(. == 0)
		return
	MS.armor_multiplier *= 0.90
	MS.recalculate_stats(description)

/datum/xeno_mutator/speed
	//Faster xenos
	name = "Boost speed"
	description = "Your tendons grow stronger."
	unique = TRUE //You can only buy it once, otherwise it would be too OP - SS13 combat is too reliant on speed
	cost = MUTATOR_COST_EXPENSIVE

/datum/xeno_mutator/speed/apply_mutator(datum/mutator_set/MS)
	. = ..()
	if(. == 0)
		return
	MS.speed_boost -= 0.2 //not a multiplier since speed is both positive and negative :P
	MS.recalculate_stats(description)

/datum/xeno_mutator/acid
	//Stronger acid
	name = "Boost acid"
	description = "Your acid strengthens."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Drone", "Hivelord", "Praetorian", "Queen", "Sentinel", "Spitter") //Only for acid classes, except for Boiler

/datum/xeno_mutator/acid/apply_mutator(datum/mutator_set/MS)
	. = ..()
	if(. == 0)
		return
	MS.acid_boost_level += 1 //acid is one step stronger
	MS.recalculate_actions(description)

/datum/xeno_mutator/pheromones
	//Stronger pheromones
	name = "Boost pheromones"
	description = "Your pheromones strengthen."
	cost = MUTATOR_COST_EXPENSIVE
	unique = TRUE //Can only buy once
	caste_whitelist = list("Carrier", "Drone", "Hivelord", "Praetorian", "Queen") //Only for pheromone-givers

/datum/xeno_mutator/pheromones/apply_mutator(datum/mutator_set/MS)
	. = ..()
	if(. == 0)
		return
	MS.pheromones_boost_level += 0.5
	MS.recalculate_pheromones(description)

/datum/xeno_mutator/hardy_weeds
	//Weeds spread further, faster, and are tougher
	name = "Faster weeds"
	description = "Your weeds grow more rapidly."
	cost = MUTATOR_COST_EXPENSIVE
	unique = TRUE //Can only buy once
	caste_whitelist = list("Burrower", "Carrier", "Drone", "Hivelord", "Queen") //Only for weed-layers

/datum/xeno_mutator/hardy_weeds/apply_mutator(datum/mutator_set/MS)
	. = ..()
	if(. == 0)
		return
	MS.weed_boost_level += 1
	MS.recalculate_actions(description)

/datum/xeno_mutator/more_leaders
	//Hive can support more leaders
	name = "More Leaders"
	description = "The Hive can support more leaders."
	cost = MUTATOR_COST_EXPENSIVE
	unique = TRUE //Can only buy once
	hive_only = TRUE

/datum/xeno_mutator/more_leaders/apply_mutator(datum/mutator_set/hive_mutators/MS)
	if(!istype(MS))
		return 0
	. = ..()
	if(. == 0)
		return
	MS.leader_count_boost += 3
	MS.recalculate_hive(description)

/datum/xeno_mutator/wider_gas
	//Boiler gas spreads further
	name = "Wider gas"
	description = "Your gas pressure increases."
	cost = MUTATOR_COST_EXPENSIVE
	unique = TRUE //Can only buy once
	individual_only = TRUE //Only for individuals
	caste_whitelist = list("Boiler") //Only for Boiler

/datum/xeno_mutator/wider_gas/apply_mutator(datum/mutator_set/individual_mutators/MS)
	if(!istype(MS))
		return 0
	. = ..()
	if(. == 0)
		return
	MS.gas_boost_level += 1
	MS.recalculate_actions(description)

/datum/xeno_mutator/faster_maturation
	//Faster evolution and maturation
	name = "Faster maturation"
	description = "The Hive matures faster."
	cost = MUTATOR_COST_EXPENSIVE
	unique = TRUE //Can only buy once
	hive_only = TRUE //It's only on hive level, otherwise all xenos that want to evolve would take it first level just to evolve faster...

/datum/xeno_mutator/faster_maturation/apply_mutator(datum/mutator_set/hive_mutators/MS)
	if(!istype(MS))
		return 0
	. = ..()
	if(. == 0)
		return
	MS.maturation_multiplier *= 0.9
	MS.recalculate_maturation(description)
/*
/datum/xeno_mutator/more_tier_slots
	//Faster evolution and maturation
	name = "More T2, T3 slots"
	description = "More of stronger sisters may evolve in the Hive."
	cost = MUTATOR_COST_EXPENSIVE
	unique = TRUE //Can only buy once
	hive_only = TRUE

/datum/xeno_mutator/more_tier_slots/apply_mutator(datum/mutator_set/hive_mutators/MS)
	if(!istype(MS))
		return 0
	. = ..()
	if(. == 0)
		return
	MS.tier_slot_multiplier *= 0.9
	MS.recalculate_hive(description)
*/
/datum/xeno_mutator/faster_pulling
	//Boiler gas spreads further
	name = "Faster pulling"
	description = "You can now pull faster."
	cost = MUTATOR_COST_EXPENSIVE
	unique = TRUE //Can only buy once
	individual_only = TRUE //Only for individuals

/datum/xeno_mutator/faster_pulling/apply_mutator(datum/mutator_set/individual_mutators/MS)
	if(!istype(MS))
		return 0
	. = ..()
	if(. == 0)
		return
	MS.pull_multiplier *= 0.75 //0.75 felt a bit too weak to be worth it, 0.5 is definitely noticeable
	MS.recalculate_actions(description)

/datum/xeno_mutator/more_carrier_capacity
	//Gives Carrier more carry capacity
	name = "Greater carry capacity"
	description = "You are able to carry more."
	cost = MUTATOR_COST_EXPENSIVE
	unique = TRUE //Can only buy once
	individual_only = TRUE //Only for individuals
	caste_whitelist = list("Carrier") //Only for Carriers

/datum/xeno_mutator/more_carrier_capacity/apply_mutator(datum/mutator_set/individual_mutators/MS)
	if(!istype(MS))
		return 0
	. = ..()
	if(. == 0)
		return
	MS.carry_boost_level += 2
	MS.recalculate_actions(description)

/datum/xeno_mutator/faster_egg_laying
	//Makes Queen lay eggs faster (for when you have more than one Carrier for example)
	name = "Faster egg laying"
	description = "Your ovipositor swells."
	cost = MUTATOR_COST_EXPENSIVE
	unique = TRUE //Can only buy once
	individual_only = TRUE //Only for individuals
	caste_whitelist = list("Queen") //Only for Queens

/datum/xeno_mutator/faster_egg_laying/apply_mutator(datum/mutator_set/individual_mutators/MS)
	if(!istype(MS))
		return 0
	. = ..()
	if(. == 0)
		return
	MS.egg_laying_multiplier *= 2.0
	MS.give_feedback(description)

/datum/xeno_mutator/longer_pounce
	//Gives Carrier more carry capacity
	name = "Longer pounce"
	description = "You are able to punce further."
	cost = MUTATOR_COST_EXPENSIVE
	unique = TRUE //Can only buy once
	individual_only = TRUE //Only for individuals
	caste_whitelist = list("Runner", "Lurker", "Ravager") //Only for pouncing castes

/datum/xeno_mutator/longer_pounce/apply_mutator(datum/mutator_set/individual_mutators/MS)
	if(!istype(MS))
		return 0
	. = ..()
	if(. == 0)
		return
	MS.pounce_boost += 2
	MS.recalculate_actions(description)

/datum/xeno_mutator/better_tackle
	//Increases tackle chance and so on
	name = "Better tackle"
	description = "You grow better at tackling."
	cost = MUTATOR_COST_EXPENSIVE
	unique = TRUE //Can only buy once

/datum/xeno_mutator/better_tackle/apply_mutator(datum/mutator_set/MS)
	. = ..()
	if(. == 0)
		return
	MS.tackle_chance_multiplier *= 1.1
	MS.tackle_strength_bonus += 1
	MS.recalculate_stats(description)

/datum/xeno_mutator/resilient_larva
	//Faster evolution and maturation
	name = "Resilient larva"
	description = "The larva grow faster and more numerous."
	cost = MUTATOR_COST_EXPENSIVE
	unique = TRUE //Can only buy once
	hive_only = TRUE //It's only on hive level, otherwise all xenos that want to evolve would take it first level just to evolve faster...

/datum/xeno_mutator/resilient_larva/apply_mutator(datum/mutator_set/hive_mutators/MS)
	if(!istype(MS))
		return 0
	. = ..()
	if(. == 0)
		return
	MS.larva_gestation_multiplier *= 1.2
	MS.bonus_larva_spawn_chance = 10 //10% chance to spawn an extra larva
	MS.recalculate_hive(description)