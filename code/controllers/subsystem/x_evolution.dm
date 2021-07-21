#define BOOST_POWER_MAX 20
#define BOOST_POWER_MIN 1
#define EVOLUTION_INCREMENT_TIME (30 MINUTES) // Evolution increases by 1 every 25 minutes.

SUBSYSTEM_DEF(xevolution)
	name = "Evilution"
	wait = 1 MINUTES
	priority = SS_PRIORITY_INACTIVITY

	var/human_xeno_ratio_modifier = 0.4
	var/time_ratio_modifier = 0.4

	var/list/boost_power = list()
	var/force_boost_power = FALSE // Debugging only

/datum/controller/subsystem/xevolution/Initialize(start_timeofday)
	var/datum/hive_status/HS
	for(var/hivenumber in GLOB.hive_datum)
		HS = GLOB.hive_datum[hivenumber]
		boost_power[HS.hivenumber] = 1
	return ..()

/datum/controller/subsystem/xevolution/fire(resumed = FALSE)
	var/datum/hive_status/HS
	for(var/hivenumber in GLOB.hive_datum)
		HS = GLOB.hive_datum[hivenumber]
		if(!HS)
			continue

		if(!HS.dynamic_evolution)
			boost_power[HS.hivenumber] = HS.evolution_rate + HS.evolution_bonus
			HS.hive_ui.update_pooled_larva()
			continue

		var/boost_power_new
		// Minimum of 5 evo until 10 minutes have passed.
		if((world.time - SSticker.round_start_time) < XENO_ROUNDSTART_PROGRESS_TIME_2)
			boost_power_new = max(boost_power_new, XENO_ROUNDSTART_PROGRESS_AMOUNT)
		else
			//boost_power_new = Floor(10 * (world.time - XENO_ROUNDSTART_PROGRESS_TIME_2 - SSticker.round_start_time) / EVOLUTION_INCREMENT_TIME) / 10
			boost_power_new = 1

			//Add on any bonuses from evopods after applying upgrade progress
			boost_power_new += (0.25 * HS.has_special_structure(XENO_STRUCTURE_EVOPOD))

		boost_power_new = Clamp(boost_power_new, BOOST_POWER_MIN, BOOST_POWER_MAX)

		boost_power_new += HS.evolution_bonus
		if(!force_boost_power)
			boost_power[HS.hivenumber] = boost_power_new

		//Update displayed Evilution, which is under larva apparently
		HS.hive_ui.update_pooled_larva()

/datum/controller/subsystem/xevolution/proc/get_evolution_boost_power(var/hivenumber)
	return boost_power[hivenumber]

#undef EVOLUTION_INCREMENT_TIME
#undef BOOST_POWER_MIN
#undef BOOST_POWER_MAX
