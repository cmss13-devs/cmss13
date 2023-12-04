//Best ert ever

/datum/emergency_call/souto
	name = "Souto Man"
	mob_max = 1
	mob_min = 1
	objectives = "Party like it's 1999!"
	probability = 0

/datum/emergency_call/souto/New()
	arrival_message = "Give a round of applause for the marine who sent in ten-thousand Souto tabs to get me here! [MAIN_SHIP_NAME], Souto Man's here to party with YOU!"
	return ..()

/datum/emergency_call/souto/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	arm_equipment(H, /datum/equipment_preset/other/souto, TRUE, TRUE)

	to_chat(H, role_header("You are Souto Man! You should bring awareness to the Souto brand!"))
	to_chat(H, role_body("Your job is to party hard and share Souto. Make sure those marines are never thirsty again!"))

	sleep(1 SECONDS)
	to_chat(H, role_header("Your objectives are:"))
	to_chat(H, role_body("[objectives]"))

/datum/emergency_call/souto/cryo
	name = "Souto Man (Cryo)"
	probability = 0
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_cryo
	shuttle_id = ""
