var/datum/subsystem/xevolution/SSxevolution

/datum/subsystem/xevolution
	name = "Evilution"
	wait = 1 MINUTES
	priority = SS_PRIORITY_INACTIVITY
	
	var/human_xeno_ratio_modifier = 0.4
	var/time_ratio_modifier = 0.4

	var/boost_power = 1
	var/boost_power_new = 1
	var/force_boost_power = FALSE

/datum/subsystem/xevolution/New()
	NEW_SS_GLOBAL(SSxevolution)

/datum/subsystem/xevolution/fire(resumed = FALSE)
	var/datum/hive_status/HS = hive_datum[XENO_HIVE_NORMAL]
	if(!HS)
		return
	var/total_xenos = HS.totalXenos.len
	var/total_larva = HS.stored_larva
	var/larva_spec = min(total_larva, sqrt(4*total_larva))
	var/living_player_list[] = ticker.mode.count_humans_and_xenos(EvacuationAuthority.get_affected_zlevels())
	var/num_humans = living_player_list[1]
	var/time_frame = world.time / (10 MINUTES)

	var/number_boost = (100+100*human_xeno_ratio_modifier*num_humans/total_xenos)*(100+100*time_ratio_modifier*time_frame)

	var/larva_boost = (number_boost * larva_spec) / (total_xenos * 10000)

	boost_power_new = 1 + larva_boost

	if(boost_power_new > 20)
		boost_power_new = 20

	if(!force_boost_power)
		boost_power = boost_power_new