/proc/begin_game_recording()
	var/datum/round_recorder/recorder = SSround_recording.recorder
	if(recorder)
		recorder.start_game()

/proc/end_game_recording()
	var/datum/round_recorder/recorder = SSround_recording.recorder
	if(recorder)
		recorder.end_game()
