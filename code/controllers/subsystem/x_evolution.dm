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
	var/datum/hive_status/HS
	for(var/hivenumber in GLOB.hive_datum)
		HS = GLOB.hive_datum[hivenumber]
		boost_power[HS.hivenumber] = 1
		overridden_power[HS.hivenumber] = FALSE
	return SS_INIT_SUCCESS

/datum/controller/subsystem/xevolution/fire(resumed = FALSE)
	var/datum/hive_status/HS
	for(var/hivenumber in GLOB.hive_datum)
		HS = GLOB.hive_datum[hivenumber]
		if(!HS)
			continue

		if(overridden_power[HS.hivenumber])
			continue

		if(!HS.dynamic_evolution)
			boost_power[HS.hivenumber] = HS.evolution_rate + HS.evolution_bonus
			HS.hive_ui.update_burrowed_larva()
			continue

		var/boost_power_new
		// Minimum of 5 evo until 10 minutes have passed.
		if((world.time - SSticker.round_start_time) < XENO_ROUNDSTART_PROGRESS_TIME_2)
			boost_power_new = max(boost_power_new, XENO_ROUNDSTART_PROGRESS_AMOUNT)
		else
			boost_power_new = 1

			//Add on any bonuses from thie hivecore after applying upgrade progress
			boost_power_new += (0.5 * HS.has_special_structure(XENO_STRUCTURE_CORE))

		boost_power_new = clamp(boost_power_new, BOOST_POWER_MIN, BOOST_POWER_MAX)

		boost_power_new += HS.evolution_bonus
		if(!force_boost_power)
			boost_power[HS.hivenumber] = boost_power_new

		//Update displayed Evilution, which is under larva apparently
		HS.hive_ui.update_burrowed_larva()

/datum/controller/subsystem/xevolution/proc/get_evolution_boost_power(hivenumber)
	return boost_power[hivenumber]

/datum/controller/subsystem/xevolution/proc/override_power(hivenumber, power, override)
	var/datum/hive_status/hive_status = GLOB.hive_datum[hivenumber]
	boost_power[hivenumber] = power
	overridden_power[hivenumber] = override
	hive_status.hive_ui.update_burrowed_larva()

#undef EVOLUTION_INCREMENT_TIME
#undef BOOST_POWER_MIN
#undef BOOST_POWER_MAX
