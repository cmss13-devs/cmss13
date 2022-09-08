/datum/job/antag/xenos/king
	title = JOB_XENOMORPH_KING
	role_ban_alternative = "King"
	supervisors = "King Mother"
	selection_class = "job_xeno_king"
	total_positions = 1
	spawn_positions = 1

/datum/job/antag/xenos/king/set_spawn_positions(var/count)
	return spawn_positions

/datum/job/antag/xenos/king/transform_to_xeno(var/mob/new_player/NP, var/hive_index)
	SSticker.mode.pick_king_spawn(NP.mind, hive_index)

/datum/job/antag/xenos/king/announce_entry_message(var/mob/new_king, var/account, var/whitelist_status)
	to_chat(new_king, "<B>You are now the alien king!</B>")
	to_chat(new_king, "<B>Your job is to spread the hive.</B>")
	to_chat(new_king, "<B>You should start by building a hive core.</B>")
	to_chat(new_king, "Talk in Hivemind using <strong>;</strong> (e.g. ';Hello my children!')")

AddTimelock(/datum/job/antag/xenos/king, list(
	JOB_XENO_ROLES = 10 HOURS
))
