SUBSYSTEM_DEF(round_recording)
	name     = "Round Recording"
	wait     = 5 SECONDS
	priority = SS_PRIORITY_ROUND_RECORDING
	flags    = SS_KEEP_TIMING

	var/list/currentrun
	var/datum/round_recorder/recorder

/datum/controller/subsystem/round_recording/Initialize()
	recorder = new()
	can_fire = FALSE
	return ..()

// use CONFIG_GET(flag/record_rounds)

/datum/controller/subsystem/round_recording/stat_entry(msg)
	msg = recorder ? "SS#: [recorder.snapshots] T: [LAZYLEN(recorder.tracked_players)]" : "Disabled"
	return ..()

/datum/controller/subsystem/round_recording/fire(resumed = FALSE)
	can_fire = FALSE
	return

/*	if(!recorder)
		return

	if(SSticker.current_state != GAME_STATE_PLAYING)
		return

	if(!resumed)
		recorder.snapshot()

		if(!recorder.tracked_players)
			return
		currentrun = recorder.tracked_players.Copy()

	while(currentrun.len)
		var/mob/M = currentrun[currentrun.len]
		currentrun.len--

		// Try to stop the tracking
		if(!M || M.disposed)
			recorder.stop_tracking(M)
			continue

		recorder.snapshot_player(M)

		if (MC_TICK_CHECK)
			return*/
