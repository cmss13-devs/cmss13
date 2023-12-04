

//whiskey outpost extra marines
/datum/emergency_call/tank_crew
	name = "Vehicle Crew Cryo Reinforcements"
	mob_max = 2
	mob_min = 2
	probability = 0
	objectives = "Assist the USCM forces"
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_cryo
	shuttle_id = ""

/datum/emergency_call/tank_crew/create_member(datum/mind/M, turf/override_spawn_loc)
	set waitfor = 0
	if(SSmapping.configs[GROUND_MAP].map_name == MAP_WHISKEY_OUTPOST)
		name_of_spawn = /obj/effect/landmark/ert_spawns/distress_wo
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc)) return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	sleep(5)
	arm_equipment(H, /datum/equipment_preset/uscm/tank/full, TRUE, TRUE)
	to_chat(H, role_header("You are a Vehicle Crewman in the USCM"))
	to_chat(H, role_body("You are here to assist in the defence of [SSmapping.configs[GROUND_MAP].map_name]. Listen to the chain of command."))
	to_chat(H, role_header("If you wish to cryo or ghost upon spawning in, you must ahelp and inform staff so you can be replaced."))

	sleep(1 SECONDS)
	to_chat(H, role_header("Your objectives are:"))
	to_chat(H, role_body("[objectives]"))

	GLOB.data_core.manifest_inject(H) //Put people in crew manifest
