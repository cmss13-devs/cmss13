/datum/job/antag
	selection_class = "job_antag"
	supervisors =   "antagonists"
	late_joinable = FALSE

/datum/timelock/xeno
	name = "Xenomorph"

/datum/timelock/xeno/can_play(client/C)
	return C.get_total_xeno_playtime() >= time_required
	
/datum/timelock/xeno/get_role_requirement(client/C)
	return time_required - C.get_total_xeno_playtime()