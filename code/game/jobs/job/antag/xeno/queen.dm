/datum/job/antag/xenos/queen
	title = JOB_XENOMORPH_QUEEN
	role_ban_alternative = "Queen"
	supervisors = "Queen Mother"
	selection_class = "job_xeno_queen"
	total_positions = 1
	spawn_positions = 1

/datum/job/antag/xenos/queen/set_spawn_positions(count)
	return spawn_positions

/datum/job/antag/xenos/queen/transform_to_xeno(mob/new_player/NP, hive_index)
	SSticker.mode.pick_queen_spawn(NP.mind, hive_index)

/datum/job/antag/xenos/queen/announce_entry_message(mob/new_queen, account, whitelist_status)
	to_chat(new_queen, "<B>You are now the alien queen!</B>")
	to_chat(new_queen, "<B>Your job is to spread the hive.</B>")
	to_chat(new_queen, "<B>You should start by building a hive core.</B>")
	to_chat(new_queen, "Talk in Hivemind using <strong>;</strong> (e.g. ';Hello my children!')")

AddTimelock(/datum/job/antag/xenos/queen, list(
	JOB_XENO_ROLES = 10 HOURS,
	JOB_DRONE_ROLES = 5 HOURS,
	JOB_T3_ROLES = 3 HOURS,
))
