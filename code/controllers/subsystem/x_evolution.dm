#define BOOST_POWER_MAX 20
#define BOOST_POWER_MIN 1
#define EVOLUTION_INCREMENT_TIME (30 MINUTES) // Evolution increases by 1 every 25 minutes.

SUBSYSTEM_DEF(xevolution)
	name = "Evilution" //This is not a typo, do not change it.
	wait = 1 MINUTES
	priority = SS_PRIORITY_INACTIVITY

	var/human_xeno_ratio_modifier = 0.4
	var/time_ratio_modifier = 0.4

	var/list/boost_power = list()
	var/list/overridden_power = list()
	var/force_boost_power = FALSE // Debugging only

/datum/controller/subsystem/xevolution/Initialize(start_timeofday)
	for(var/faction_to_get in GLOB.FACTION_LIST_XENOMORPH)
		boost_power[faction_to_get] = 1
		overridden_power[faction_to_get] = FALSE
	return SS_INIT_SUCCESS

/datum/controller/subsystem/xevolution/fire(resumed = FALSE)
	for(var/faction_to_get in GLOB.FACTION_LIST_XENOMORPH)
		var/datum/faction/faction = GLOB.faction_datums[faction_to_get]
		var/datum/faction_module/hive_mind/faction_module = faction.get_faction_module(FACTION_MODULE_HIVE_MIND)
		if(overridden_power[faction_to_get])
			continue

		if(!faction_module.dynamic_evolution)
			boost_power[faction_to_get] = faction_module.evolution_rate + faction_module.evolution_bonus
			faction_module.hive_ui.update_burrowed_larva()
			continue

		var/boost_power_new
		// Minimum of 5 evo until 10 minutes have passed.
		if((world.time - SSticker.round_start_time) < XENO_ROUNDSTART_PROGRESS_TIME_2)
			boost_power_new = max(boost_power_new, XENO_ROUNDSTART_PROGRESS_AMOUNT)
		else
			boost_power_new = 1

			//Add on any bonuses from thie hivecore after applying upgrade progress
			boost_power_new += (0.5 * faction_module.has_special_structure(XENO_STRUCTURE_CORE))

		boost_power_new = clamp(boost_power_new, BOOST_POWER_MIN, BOOST_POWER_MAX)

		boost_power_new += faction_module.evolution_bonus
		if(!force_boost_power)
			boost_power[faction_to_get] = boost_power_new

		//Update displayed Evilution, which is under larva apparently
		faction_module.hive_ui.update_burrowed_larva()

/datum/controller/subsystem/xevolution/proc/get_evolution_boost_power(faction_to_get)
	return boost_power[faction_to_get]

/datum/controller/subsystem/xevolution/proc/override_power(faction_to_get, power, override)
	var/datum/faction_module/hive_mind/faction_module = GLOB.faction_datums[faction_to_get].get_faction_module(FACTION_MODULE_HIVE_MIND)
	boost_power[faction_to_get] = power
	overridden_power[faction_to_get] = override
	faction_module.hive_ui.update_burrowed_larva()

#undef EVOLUTION_INCREMENT_TIME
#undef BOOST_POWER_MIN
#undef BOOST_POWER_MAX
