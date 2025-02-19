SUBSYSTEM_DEF(perf_logging)
	name = "Perf Logging"
	wait = 60 SECONDS
	flags = SS_NO_INIT | SS_KEEP_TIMING
	priority = SS_PRIORITY_PERFLOGGING
	var/datum/entity/mc_round/round
	var/list/datum/entity/mc_controller/controller_assoc = list()
	var/list/datum/controller/subsystem/currentrun
	var/ord = 0 // Amount of measurements
	var/tcost = 0 // Total cost for current tick

/datum/controller/subsystem/perf_logging/fire(resumed = FALSE)
	if(SSticker?.current_state < GAME_STATE_PLAYING)
		return // Not started yet
	if(!SSentity_manager?.ready)
		return // DB not ready
	if(!round) // Init
		start_logging()
		return
	if(!resumed)
		ord++
		tcost = 0
		currentrun = list()  // Pre-filter by cost
		for(var/I in Master.subsystems)
			var/datum/controller/subsystem/SS = I
			if(SS?.cost > 0.1)
				currentrun += SS

	while(length(currentrun))
		var/datum/controller/subsystem/SS = currentrun[length(currentrun)]
		currentrun.len--
		var/datum/entity/mc_controller/C = controller_assoc[SS.type]
		new_record(SS, C)
		tcost += SS.cost
		if(MC_TICK_CHECK)
			return
	update_mc_timing()

/// Setup to begin performance logging when game starts
/datum/controller/subsystem/perf_logging/proc/start_logging()
	SHOULD_NOT_SLEEP(TRUE)
	var/datum/map_config/ground = SSmapping.configs[GROUND_MAP]
	if(!ground)
		return
	ord = 0
	round = SSentity_manager.round
	round.map_name = ground.map_name
	var/datum/entity/mc_controller/C
	for(var/datum/controller/subsystem/SS in Master.subsystems)
		C = SSentity_manager.select_by_key(/datum/entity/mc_controller, "[SS.type]")
		if(!C)
			continue
		C.wait_time = SS.wait
		C.save()
		controller_assoc[SS.type] = C

/// Insert a new timing record for a single subsystem
/datum/controller/subsystem/perf_logging/proc/new_record(datum/controller/subsystem/SS, datum/entity/mc_controller/C)
	SHOULD_NOT_SLEEP(TRUE)
	if(!C?.id)
		return // Skip ones that were never taken for recording to begin with
	var/datum/entity/mc_record/record = SSentity_manager.select(/datum/entity/mc_record)
	record.round_time = ord
	record.round_id = round.id
	record.controller_id = C.id
	record.time_taken = SS.cost * (1 SECONDS) // tick_lag?
	record.save() && record.detach()

/// Insert a new timing record for the MC as a whole
/datum/controller/subsystem/perf_logging/proc/update_mc_timing()
	SHOULD_NOT_SLEEP(TRUE)
	var/datum/entity/mc_timing_info/timing_info = SSentity_manager.select(/datum/entity/mc_timing_info)
	timing_info.total_time_taken = tcost * (1 SECONDS)
	timing_info.round_id = round.id
	timing_info.round_time = ord
	timing_info.client_count = length(GLOB.clients)
	timing_info.human_count = length(SShuman.processable_human_list)
	timing_info.xeno_count = length(GLOB.xeno_mob_list)
	timing_info.save() && timing_info.detach()

/datum/controller/subsystem/perf_logging/stat_entry(msg)
	if(round)
		msg = "ACTIVE | Round: [round.id] | Time: #[ord]"
	else
		msg = "INACTIVE"
	return ..()
