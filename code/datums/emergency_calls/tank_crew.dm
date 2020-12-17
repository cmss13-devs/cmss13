

//whiskey outpost extra marines
/datum/emergency_call/tank_crew
	name = "Vehicle Crew Cryo Reinforcements"
	mob_max = 2
	mob_min = 2
	probability = 0
	objectives = "Assist the USCM forces"
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_cryo
	shuttle_id = ""

/datum/emergency_call/tank_crew/create_member(datum/mind/M)
	set waitfor = 0
	if(map_tag == MAP_WHISKEY_OUTPOST)
		name_of_spawn = /obj/effect/landmark/ert_spawns/distress_wo
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc)) return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	sleep(5)
	arm_equipment(H, "USCM Vehicle Crewman (CRMN)", TRUE, TRUE)
	to_chat(H, "<font size='3'>\red You are a vehicle crewman in the USCM, you are here to assist in the defence of the [map_tag]. Listen to the chain of command.</B>")

	sleep(10)
	to_chat(H, "<B>Objectives:</b> [objectives]")

	GLOB.data_core.manifest_inject(H) //Put people in crew manifest

