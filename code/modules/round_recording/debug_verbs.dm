/client/proc/debug_game_history()
	set name = "Debug Round Recorder"
	set category = "Debug"

	if (!admin_holder || !(usr.client.admin_holder.rights & R_DEBUG))
		return

	var/datum/round_recorder/recorder = SSround_recording.recorder
	if(isnull(recorder))
		to_chat(src, "The round recorder datum is either not initialized yet or it was deleted")

	debug_variables(recorder)
