var/datum/subsystem/perf_logging/SSperf_logging

#define PERF_LOGGING_WAIT	600

/datum/subsystem/perf_logging
	name = "Perf Logging"
	wait = PERF_LOGGING_WAIT
	flags = SS_BACKGROUND | SS_FIRE_IN_LOBBY | SS_DISABLE_FOR_TESTING
	priority = SS_PRIORITY_PERFLOGGING

	var/wait_for_start = MINUTES_5
	var/current_timer = 0
	var/datum/entity/mc_round/round
	var/list/datum/entity/mc_controller/controller_assoc

/datum/subsystem/perf_logging/New()
	NEW_SS_GLOBAL(SSperf_logging)

/datum/subsystem/perf_logging/Initialize()
	if(!round)
		INVOKE_ASYNC(src, /datum/subsystem/perf_logging.proc/true_initialize)


/datum/subsystem/perf_logging/proc/true_initialize()
	while(!SSentity_manager.ready)
		stoplag()
	round = SSentity_manager.select(/datum/entity/mc_round)
	round.map_name = "[map_tag]"
	round.save()
	round.sync()
	if(!Master)
		return // UH OH
	controller_assoc = list()
	for(var/datum/subsystem/SS in Master.subsystems)
		var/datum/entity/mc_controller/C = SSentity_manager.select_by_key(/datum/entity/mc_controller, "[SS.type]")
		C.wait_time = SS.wait
		C.save()
		controller_assoc[SS.type] = C

/datum/subsystem/perf_logging/fire(resumed = FALSE)
	if(world.time < wait_for_start)
		return // skipperino, too early
	if(!Master)
		return // UH OH
	current_timer++
	var/total_cost = 0
	for(var/datum/subsystem/SS in Master.subsystems)
		if(SS.slow_cost < 0.1)
			continue // we don't give a cluck about things that have 0, and this will save on DB time
		var/datum/entity/mc_controller/C = controller_assoc[SS.type]
		if(!C.id)
			continue // skip not loaded ID
		var/datum/entity/mc_record/record = SSentity_manager.select(/datum/entity/mc_record)
		record.round_time = current_timer
		record.round_id = round.id
		record.controller_id = C.id
		total_cost += SS.slow_cost
		record.time_taken = SS.slow_cost * 10
		record.save()
		record.detach()
	
	var/datum/entity/mc_timing_info/timing_info = SSentity_manager.select(/datum/entity/mc_timing_info)
	timing_info.total_time_taken = total_cost * 10
	timing_info.round_id = round.id
	timing_info.round_time = current_timer
	timing_info.client_count = length(clients)
	timing_info.human_count = length(processable_human_list)
	timing_info.xeno_count = length(xeno_mob_list)
	timing_info.save()
	timing_info.detach()