//A class that holds the current DEFCON level and its associated uses

#define DEFCON_COST_CHEAP 1
#define DEFCON_COST_MODERATE 2
#define DEFCON_COST_PRICEY 4
#define DEFCON_COST_EXPENSIVE 6
#define DEFCON_COST_LUDICROUS 10
#define DEFCON_COST_MAX 12

#define DEFCON_POINT_GAIN_PER_LEVEL 2
#define DEFCON_MAX_LEVEL 5

var/global/datum/controller/defcon/defcon_controller

/datum/controller/defcon
	name = "DEFCON Level Accounting"
	var/current_defcon_level = 5 //IRL DEFCON goes from 5 to 1, so we preserve it here
	var/last_objectives_scored_points = 0
	var/last_objectives_total_points = 0
	var/last_objectives_completion_percentage = 0
	var/lists_initialized = 0

	//Percentage of objectives needed to reach the next DEFCON level
	//(ordered by DEFCON number, so things will be going in the opposite order!)
	var/list/defcon_level_triggers

	var/list/purchased_rewards = list()

	//Points given for reaching the next DEFCON level, for Command to spend
	//Starts with a few points to enable a bit of fun
	var/remaining_reward_points = DEFCON_POINT_GAIN_PER_LEVEL

/datum/controller/defcon/proc/check_defcon_percentage()
	if(current_defcon_level == 1)
		return "MAXIMUM"
	else
		if (!defcon_level_triggers)
			return 0
		var/percentage = last_objectives_scored_points / defcon_level_triggers[current_defcon_level -1] * 100
		return percentage


/datum/controller/defcon/proc/decrease_defcon_level()
	if(current_defcon_level > 1)
		current_defcon_level--
		remaining_reward_points += DEFCON_POINT_GAIN_PER_LEVEL + (DEFCON_POINT_GAIN_PER_LEVEL * (DEFCON_MAX_LEVEL - current_defcon_level))
		chemical_research_data.update_credits((6 - current_defcon_level)*2)
		announce_defcon_level()

/datum/controller/defcon/proc/check_defcon_level()
	var/list/objectives_status = objectives_controller.get_objective_completion_stats()
	last_objectives_scored_points = objectives_status["scored_points"]
	last_objectives_total_points = objectives_status["total_points"]
	last_objectives_completion_percentage = last_objectives_scored_points / last_objectives_total_points

	if(current_defcon_level > 1)
		if(last_objectives_scored_points > defcon_level_triggers[current_defcon_level - 1])
			decrease_defcon_level()
	if(round_statistics)
		round_statistics.defcon_level = current_defcon_level
		round_statistics.objective_points = last_objectives_scored_points
		round_statistics.total_objective_points = last_objectives_total_points

/datum/controller/defcon/proc/announce_defcon_level()
	//Send ARES message about new DEFCON level
	var/name = "ALMAYER DEFCON LEVEL LOWERED"
	var/input = "THREAT ASSESSMENT LEVEL INCREASED TO [last_objectives_completion_percentage*100]%.\n\nShip DEFCON level lowered to [current_defcon_level]. Additional assets have been authorised to handle the situation."
	marine_announcement(input, name, 'sound/AI/commandreport.ogg')

/datum/controller/defcon/proc/list_and_purchase_rewards()
	var/list/rewards_for_purchase = available_rewards()
	if(rewards_for_purchase.len == 0)
		to_chat(usr, "No additional assets have been authorised at this point. Increase the threat assessment level to enable further assets.")
	var/pick = input("Which asset would you like to enable?") as null|anything in rewards_for_purchase
	if(!pick)
		return
	if(defcon_reward_list[pick].apply_reward(src))
		to_chat(usr, "Asset granted!")
		defcon_reward_list[pick].announce_reward()
	else
		to_chat(usr, "Asset granting failed!")
	return

//Lists rewards available for purchase
/datum/controller/defcon/proc/available_rewards()
	var/list/can_purchase = list()
	if(!remaining_reward_points) //No points - can't buy anything
		return can_purchase

	for(var/str in defcon_reward_list)
		if (can_purchase_reward(defcon_reward_list[str]))
			can_purchase += str //can purchase!

	return can_purchase

/datum/controller/defcon/proc/can_purchase_reward(var/datum/defcon_reward/dr)
	if(current_defcon_level > dr.minimum_defcon_level)
		return FALSE //required DEFCON level not reached
	if(remaining_reward_points < dr.cost)
		return FALSE //reward is too expensive
	if(dr.unique)
		if(dr.name in purchased_rewards)
			return FALSE //unique reward already purchased
	return TRUE

/datum/controller/defcon/proc/initialize_level_triggers_by_map()
	// Sometimes map_tag won't be populated 
	if (!map_tag)
		return FALSE 
	
	// Leaving debug messages here in case this code has bugs. 
	// Without these, it is -literally- impossible to debug this 
	// as this code can sometimes execute before world initialization.
	//text2file("DEFCON lists began initialization","data/defcon_log.txt")
	//text2file("Map tag: [map_tag]", "data/defcon_log.txt")
	if (map_tag == MAP_PRISON_STATION || map_tag == MAP_SOROKYNE_STRATA)
		defcon_level_triggers = list(3750, 2600, 1450, 875, 0.0)
	else if (map_tag == MAP_ICE_COLONY || map_tag == MAP_DESERT_DAM || map_tag == MAP_CORSAT)
		defcon_level_triggers = list(3300, 2100, 1450, 580, 0.0)
	else if (map_tag == MAP_BIG_RED)
		defcon_level_triggers = list(4750, 3500, 2000, 1000, 0.0)
	else 
		// Defaults 
		// Currently just LV 
		defcon_level_triggers = list(5500, 4500, 3000, 1000, 0.0)
	//text2file("Listing level triggers:","data/defcon_log.txt")
	//for (var/i in defcon_level_triggers)
		//text2file("Defcon level trigger: [i]","data/defcon_log.txt")
	lists_initialized = 1
	return TRUE 

//A class for rewarding the next DEFCON level being reached
/datum/defcon_reward
	var/name = "Reward"
	var/cost = null //Cost to get this reward
	var/minimum_defcon_level = 5 //DEFCON needs to be at this level or LOWER
	var/unique = FALSE //Whether the reward is unique or not
	var/announcement_message = "YOU SHOULD NOT BE SEEING THIS MESSAGE. TELL A DEV." //Message to be shared after a reward is purchased

/datum/defcon_reward/proc/announce_reward()
	//Send ARES message about special asset authorisation
	var/name = "ALMAYER SPECIAL ASSETS AUTHORISED"
	marine_announcement(announcement_message, name, 'sound/misc/notice2.ogg')

/datum/defcon_reward/New()
	. = ..()
	name = "($[cost * DEFCON_TO_MONEY_MULTIPLIER]) [name]"

/datum/defcon_reward/proc/apply_reward(var/datum/controller/defcon/d)
	if(d.remaining_reward_points < cost)
		return 0
	d.remaining_reward_points -= cost
	d.purchased_rewards += name
	return 1

/datum/defcon_reward/supply_points
	name = "Additional Supply Budget"
	cost = DEFCON_COST_MODERATE
	minimum_defcon_level = 5
	announcement_message = "Additional Supply Budget has been authorised for this operation."

/datum/defcon_reward/supply_points/apply_reward(var/datum/controller/defcon/d)
	. = ..()
	if(. == 0)
		return
	supply_controller.points += 200

/datum/defcon_reward/dropship_part_fabricator_points
	name = "Additional Dropship Part Fabricator Points"
	cost = DEFCON_COST_MODERATE
	minimum_defcon_level = 5
	announcement_message = "Additional Dropship Part Fabricator Points have been authorised for this operation."

/datum/defcon_reward/dropship_part_fabricator_points/apply_reward(var/datum/controller/defcon/d)
	. = ..()
	if(. == 0)
		return
	supply_controller.dropship_points += 1600 //Enough for both fuel enhancers, or about 3.5 fatties

/datum/defcon_reward/ob_he
	name = "Additional OB projectiles - HE x2"
	cost = DEFCON_COST_CHEAP
	minimum_defcon_level = 5
	announcement_message = "Additional Orbital Bombardment ornaments (HE, count:2) have been delivered to Requisitions' ASRS."

/datum/defcon_reward/ob_he/apply_reward(var/datum/controller/defcon/d)
	. = ..()
	if(. == 0)
		return

	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = supply_controller.ordernum
	supply_controller.ordernum++
	O.object = supply_controller.supply_packs["OB HE Crate"]
	O.orderedby = MAIN_AI_SYSTEM

	supply_controller.shoppinglist += O

/datum/defcon_reward/ob_cluster
	name = "Additional OB projectiles - Cluster x2"
	cost = DEFCON_COST_CHEAP
	minimum_defcon_level = 5
	announcement_message = "Additional Orbital Bombardment ornaments (Cluster, count:2) have been delivered to Requisitions' ASRS."

/datum/defcon_reward/ob_cluster/apply_reward(var/datum/controller/defcon/d)
	. = ..()
	if(. == 0)
		return

	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = supply_controller.ordernum
	supply_controller.ordernum++
	O.object = supply_controller.supply_packs["OB Cluster Crate"]
	O.orderedby = MAIN_AI_SYSTEM

	supply_controller.shoppinglist += O

/datum/defcon_reward/ob_incendiary
	name = "Additional OB projectiles - Incendiary x2"
	cost = DEFCON_COST_CHEAP
	minimum_defcon_level = 5
	announcement_message = "Additional Orbital Bombardment ornaments (Incendiary, count:2) have been delivered to Requisitions' ASRS."

/datum/defcon_reward/ob_incendiary/apply_reward(var/datum/controller/defcon/d)
	. = ..()
	if(. == 0)
		return

	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = supply_controller.ordernum
	supply_controller.ordernum++
	O.object = supply_controller.supply_packs["OB Incendiary Crate"]
	O.orderedby = MAIN_AI_SYSTEM

	supply_controller.shoppinglist += O

/datum/defcon_reward/cryo_squad
	name = "Wake up additional troops"
	cost = DEFCON_COST_PRICEY
	minimum_defcon_level = 3
	unique = TRUE
	announcement_message = "Additional troops are being taken out of cryo."

/datum/defcon_reward/cryo_squad/apply_reward(var/datum/controller/defcon/d)
	if (!ticker  || !ticker.mode)
		return

	. = ..()
	if(. == 0)
		return

	ticker.mode.get_specific_call("Marine Cryo Reinforcements (Squad)", FALSE, FALSE)

/datum/defcon_reward/tank_points
	name = "Additional Tank Part Fabricator Points"
	cost = DEFCON_COST_EXPENSIVE
	minimum_defcon_level = 2
	unique = TRUE
	announcement_message = "Additional Tank Part Fabricator Points have been authorised for this operation."

/datum/defcon_reward/tank_points/apply_reward(var/datum/controller/defcon/d)
	. = ..()
	if(. == 0)
		return
	supply_controller.tank_points += 3000 //Enough for full kit + ammo

/datum/defcon_reward/spec_kits
	name = "Four Specialist Kits"
	cost = DEFCON_COST_EXPENSIVE
	minimum_defcon_level = 2
	unique = TRUE
	announcement_message = "Specialist kits have been delievered to Requisitions' ASRS."

/datum/defcon_reward/spec_kits/apply_reward(var/datum/controller/defcon/d)
	. = ..()
	if(. == 0)
		return

	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = supply_controller.ordernum
	supply_controller.ordernum++
	O.object = supply_controller.supply_packs["Specialist Kits"]
	O.orderedby = MAIN_AI_SYSTEM

	supply_controller.shoppinglist += O

/datum/defcon_reward/nuke
	name = "Planetary nuke"
	cost = DEFCON_COST_LUDICROUS
	minimum_defcon_level = 1
	unique = TRUE
	announcement_message = "Planetary nuke has been been delivered to Requisitions' ASRS."

/datum/defcon_reward/nuke/apply_reward(var/datum/controller/defcon/d)
	. = ..()
	if(. == 0)
		return

	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = supply_controller.ordernum
	supply_controller.ordernum++
	O.object = supply_controller.supply_packs["Operational Nuke"]
	O.orderedby = MAIN_AI_SYSTEM

	supply_controller.shoppinglist += O

/datum/defcon_reward/nuke/announce_reward(var/announcement_message)
	//Send ARES message about special asset authorisation
	var/name = "STRATEGIC NUKE AUTHORISED"
	marine_announcement(announcement_message, name, 'sound/misc/notice1.ogg')
