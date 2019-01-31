#define MUTATOR_COST_CHEAP 2
#define MUTATOR_COST_MODERATE 3
#define MUTATOR_COST_EXPENSIVE 6

#define MUTATOR_GAIN_PER_QUEEN_LEVEL 6
#define MUTATOR_GAIN_PER_XENO_LEVEL 6
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
	var/keystone = FALSE //Xeno can only take one Keystone mutator
	var/flaw = FALSE //Flaws give you points back, but you can only take one of them
	var/list/caste_whitelist = list() //List of the only castes that can buy this mutator

/datum/xeno_mutator/New()
	. = ..()
	name = "[name] ([cost] points)"


/datum/xeno_mutator/proc/apply_mutator(datum/mutator_set/MS)
	if(!MS.can_purchase_mutator(name))
		return 0
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

/datum/xeno_mutator/health_flaw
	name = "FLAW - Weaken health"
	description = "Your internals weaken."
	cost = -MUTATOR_COST_EXPENSIVE
	flaw = TRUE

/datum/xeno_mutator/health_flaw/apply_mutator(datum/mutator_set/MS)
	. = ..()
	if(. == 0)
		return
	MS.health_multiplier *= 0.9
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

/datum/xeno_mutator/plasma_flaw
	name = "FLAW - Weaken plasma"
	description = "Your bile sacks contract."
	cost = -MUTATOR_COST_EXPENSIVE
	flaw = TRUE

/datum/xeno_mutator/plasma_flaw/apply_mutator(datum/mutator_set/MS)
	. = ..()
	if(. == 0)
		return
	MS.plasma_multiplier *= 0.85
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

/datum/xeno_mutator/damage_flaw
	//Stronger claws
	name = "FLAW - Weaken damage"
	description = "Your claws become dull."
	cost = -MUTATOR_COST_EXPENSIVE
	flaw = TRUE

/datum/xeno_mutator/damage_flaw/apply_mutator(datum/mutator_set/MS)
	. = ..()
	if(. == 0)
		return
	MS.damage_multiplier *= 0.93
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

/datum/xeno_mutator/armor_flaw
	//Strong armour
	name = "FLAW - Weaken armor"
	description = "Your hide thins."
	cost = -MUTATOR_COST_EXPENSIVE
	flaw = TRUE

/datum/xeno_mutator/armor_flaw/apply_mutator(datum/mutator_set/MS)
	. = ..()
	if(. == 0)
		return
	MS.armor_multiplier *= 1.1
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
	MS.speed_multiplier *= 0.9
	MS.recalculate_stats(description)

/datum/xeno_mutator/speed_flaw
	//Faster xenos
	name = "FLAW - Weaken speed"
	description = "Your tendons grow weaker."
	cost = -MUTATOR_COST_EXPENSIVE
	flaw = TRUE

/datum/xeno_mutator/speed_flaw/apply_mutator(datum/mutator_set/MS)
	. = ..()
	if(. == 0)
		return
	MS.speed_multiplier *= 1.1
	MS.recalculate_stats(description)

/datum/xeno_mutator/acid
	//Stronger acid
	name = "Boost acid"
	description = "Your acid strengthens."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Burrower", "Drone", "Hivelord", "Praetorian", "Queen", "Sentinel", "Spitter") //Only for acid classes, except for Boiler

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

/datum/xeno_mutator/pheromones_flaw
	name = "FLAW - Weaken pheromones"
	description = "Your pheromones weaken."
	cost = -MUTATOR_COST_EXPENSIVE
	flaw = TRUE
	caste_whitelist = list("Carrier", "Drone", "Hivelord", "Praetorian", "Queen") //Only for pheromone-givers

/datum/xeno_mutator/pheromones_flaw/apply_mutator(datum/mutator_set/MS)
	. = ..()
	if(. == 0)
		return
	MS.pheromones_boost_level -= 0.5
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
	MS.weed_boost_level += 2
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
	name = "KEYSTONE - Wider gas"
	description = "Your gas pressure increases."
	cost = MUTATOR_COST_EXPENSIVE
	unique = TRUE //Can only buy once
	individual_only = TRUE //Only for individuals
	caste_whitelist = list("Boiler") //Only for Boiler
	keystone = TRUE

/datum/xeno_mutator/wider_gas/apply_mutator(datum/mutator_set/individual_mutators/MS)
	if(!istype(MS))
		return 0
	. = ..()
	if(. == 0)
		return
	MS.gas_boost_level += 1
	MS.recalculate_actions(description)

/datum/xeno_mutator/lingering_gas
	//Boiler gas lasts longer before dissipating
	name = "KEYSTONE - Lingering gas"
	description = "Your gas thickens."
	cost = MUTATOR_COST_EXPENSIVE
	unique = TRUE //Can only buy once
	individual_only = TRUE //Only for individuals
	caste_whitelist = list("Boiler") //Only for Boiler
	keystone = TRUE

/datum/xeno_mutator/lingering_gas/apply_mutator(datum/mutator_set/individual_mutators/MS)
	if(!istype(MS))
		return 0
	. = ..()
	if(. == 0)
		return
	MS.gas_life_multiplier *= 1.5
	MS.recalculate_actions(description)

/datum/xeno_mutator/faster_maturation
	//Faster evolution and maturation
	name = "KEYSTONE - Faster maturation"
	description = "The Hive matures faster."
	cost = MUTATOR_COST_EXPENSIVE
	unique = TRUE //Can only buy once
	hive_only = TRUE //It's only on hive level, otherwise all xenos that want to evolve would take it first level just to evolve faster...
	keystone = TRUE

/datum/xeno_mutator/faster_maturation/apply_mutator(datum/mutator_set/hive_mutators/MS)
	if(!istype(MS))
		return 0
	. = ..()
	if(. == 0)
		return
	MS.maturation_multiplier *= 0.9
	MS.recalculate_maturation(description)

/datum/xeno_mutator/faster_maturation_flaw
	name = "FLAW - Slower maturation"
	description = "The Hive matures slower."
	cost = -MUTATOR_COST_EXPENSIVE
	hive_only = TRUE
	flaw = TRUE

/datum/xeno_mutator/faster_maturation_flaw/apply_mutator(datum/mutator_set/hive_mutators/MS)
	if(!istype(MS))
		return 0
	. = ..()
	if(. == 0)
		return
	MS.maturation_multiplier *= 1.1
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
	name = "KEYSTONE - Greater carry capacity"
	description = "You are able to carry more."
	cost = MUTATOR_COST_EXPENSIVE
	unique = TRUE //Can only buy once
	individual_only = TRUE //Only for individuals
	caste_whitelist = list("Carrier") //Only for Carriers
	keystone = TRUE

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
	name = "KEYSTONE - Longer pounce"
	description = "You are able to pounce further."
	cost = MUTATOR_COST_EXPENSIVE
	unique = TRUE //Can only buy once
	individual_only = TRUE //Only for individuals
	caste_whitelist = list("Runner", "Lurker", "Ravager") //Only for pouncing castes
	keystone = TRUE

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
	name = "Boost tackle"
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

/datum/xeno_mutator/better_tackle_flaw
	name = "FLAW - Weaker tackle"
	description = "You grow worse at tackling."
	cost = -MUTATOR_COST_EXPENSIVE
	flaw = TRUE

/datum/xeno_mutator/better_tackle_flaw/apply_mutator(datum/mutator_set/MS)
	. = ..()
	if(. == 0)
		return
	MS.tackle_chance_multiplier *= 0.9
	MS.tackle_strength_bonus -= 1
	MS.recalculate_stats(description)

/datum/xeno_mutator/resilient_larva
	//Larva grows faster and can burst more larva
	name = "KEYSTONE - Resilient larva"
	description = "The larva grow faster and more numerous."
	cost = MUTATOR_COST_EXPENSIVE
	unique = TRUE //Can only buy once
	hive_only = TRUE //It's only on hive level, otherwise all xenos that want to evolve would take it first level just to evolve faster...
	keystone = TRUE

/datum/xeno_mutator/resilient_larva/apply_mutator(datum/mutator_set/hive_mutators/MS)
	if(!istype(MS))
		return 0
	. = ..()
	if(. == 0)
		return
	MS.larva_gestation_multiplier *= 1.2
	MS.bonus_larva_spawn_chance = 10 //10% chance to spawn an extra larva
	MS.recalculate_hive(description)

/datum/xeno_mutator/acid_claws
	//Turns brute claw damage into burn damage
	name = "KEYSTONE - Acid-tipped claws"
	description = "Your claws secrete acid."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Burrower", "Drone", "Hivelord", "Praetorian", "Queen", "Sentinel", "Spitter", "Boiler") //Only for acid classes
	keystone = TRUE

/datum/xeno_mutator/acid_claws/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if(. == 0)
		return
	MS.acid_claws = TRUE //turns claws acid, damage is calcualted elsewhere
	MS.recalculate_stats(description)

/datum/xeno_mutator/regenerate_off_weeds
	//Xeno can regenerate / heal off weeds
	name = "KEYSTONE - Regenerate off weeds"
	description = "You can regenerate off weeds."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	keystone = TRUE

/datum/xeno_mutator/regenerate_off_weeds/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if(. == 0)
		return
	MS.need_weeds = FALSE //we don't need weeds anymore to heal or regenerate plasma
	MS.recalculate_actions(description)

/datum/xeno_mutator/faster_charge_buildup
	//Turns brute claw damage into burn damage
	name = "KEYSTONE - Faster charge buildup"
	description = "Your charge builds up faster."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Crusher") //Only for Crusher (since Queen doesn't have a charge anymore)
	keystone = TRUE

/datum/xeno_mutator/faster_charge_buildup/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if(. == 0)
		return

	MS.charge_speed_buildup_multiplier *= 1.2
	MS.charge_turfs_to_charge_delta -= 1
	MS.recalculate_stats(description)