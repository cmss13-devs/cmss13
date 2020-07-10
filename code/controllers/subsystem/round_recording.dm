var/datum/subsystem/round_recording/SSround_recording

/datum/subsystem/round_recording
	name     = "Round Recording"
	wait     = SS_WAIT_ROUND_RECORDING
	priority = SS_PRIORITY_ROUND_RECORDING
	flags    = SS_KEEP_TIMING

	var/list/currentrun
	var/datum/round_recorder/recorder

/datum/subsystem/round_recording/New()
	NEW_SS_GLOBAL(SSround_recording)
	recorder = new()

/datum/subsystem/round_recording/Initialize()

	can_fire = FALSE
	return

	var/list/lines = file2list("config/round_recording.txt")

	var/record_rounds = FALSE
	if(!lines || !length(lines))
		return

	for(var/line in lines)
		// Ignore empty lines
		if(!length(line))
			continue
		// Ignore comment lines
		if(copytext(line,1,2) == "#")
			continue

		// Get the config option
		var/list/config = splittext(line, " ")
		if(!config || length(config) < 2)
			continue

		if(config[1] == "record_rounds")
			record_rounds = config[2] == "1" ? TRUE : FALSE
			break

	if(!record_rounds)
		pause()
	..()

/datum/subsystem/round_recording/stat_entry()
	..(recorder ? "SS#: [recorder.snapshots] T: [LAZYLEN(recorder.tracked_players)]" : "Disabled")

/datum/subsystem/round_recording/fire(resumed = FALSE)
	can_fire = FALSE
	return

	if(!recorder)
		return

	if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
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
			return
