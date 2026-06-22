/datum/emergency_call/pred/xeno/small
	name = "Hunting Grounds - Xenos - Small"
	hunt_name = "Serpents (small)"
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress/hunt_spawner/xeno
	mob_max = 4
	mob_min = 1
	hostility = TRUE
	max_xeno_t3 = 1
	max_xeno_t2 = 1

/datum/emergency_call/pred/xeno/med
	name = "Hunting Grounds - Xenos - Medium"
	hunt_name = "Serpents (group)"
	timer_mult = 1.2 // 24 minutes
	mob_max = 6
	mob_min = 3
	hostility = TRUE
	max_xeno_t3 = 3
	max_xeno_t2 = 1

/datum/emergency_call/pred/xeno/hard
	name = "Hunting Grounds - Xenos - Large"
	hunt_name = "Serpents (large)"
	timer_mult = 1.4 // 28 minutes
	mob_max = 8
	mob_min = 4
	hostility = TRUE
	max_xeno_t3 = 3
	max_xeno_t2 = 3
