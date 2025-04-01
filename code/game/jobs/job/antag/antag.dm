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

/// counts drone caste evo time as well
/datum/timelock/drone
	name = "Drone and drone evolutions"

/datum/timelock/drone/can_play(client/C)
	return C.get_total_drone_playtime() >= time_required

/datum/timelock/drone/get_role_requirement(client/C)
	return time_required - C.get_total_drone_playtime()

/// t3 and queen time
/datum/timelock/tier3
	name = "Tier three castes"

/datum/timelock/tier3/can_play(client/C)
	return C.get_total_t3_playtime() >= time_required

/datum/timelock/tier3/get_role_requirement(client/C)
	return time_required - C.get_total_t3_playtime()
