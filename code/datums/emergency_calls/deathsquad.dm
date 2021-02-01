


//Deathsquad Commandos
/datum/emergency_call/death
	name = "Weston Deathsquad"
	mob_max = 8
	mob_min = 5
	arrival_message = "Intercepted Transmission: '!`2*%slau#*jer t*h$em a!l%. le&*ve n(o^ w&*nes%6es.*v$e %#d ou^'"
	objectives = "Wipe out everything. Ensure there are no traces of the infestation or any witnesses."
	probability = 0
	shuttle_id = "Distress_PMC"
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pmc
	item_spawn = /obj/effect/landmark/ert_spawns/distress_pmc/item
	max_medics = 1
	max_heavies = 2



// DEATH SQUAD--------------------------------------------------------------------------------
/datum/emergency_call/death/create_member(datum/mind/M)
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)
	H.set_skills(/datum/skills/commando/deathsquad)

	if(!leader)       //First one spawned is always the leader.
		leader = H
		to_chat(H, SPAN_ROLE_HEADER("You are the Deathsquad Leader!"))
		to_chat(H, SPAN_ROLE_BODY("You must clear out any traces of the infestation and its survivors."))
		to_chat(H, SPAN_ROLE_BODY("Follow any orders directly from Weston-Yamada!"))
		arm_equipment(H, "Weston-Yamada Deathsquad Leader", TRUE, TRUE)
	else if(medics < max_medics)
		medics++
		to_chat(H, SPAN_ROLE_HEADER("You are a Deathsquad Medic!"))
		to_chat(H, SPAN_ROLE_BODY("You must clear out any traces of the infestation and its survivors."))
		to_chat(H, SPAN_ROLE_BODY("Follow any orders directly from Weston-Yamada!"))
		arm_equipment(H, "Weston-Yamada Deathsquad Medic", TRUE, TRUE)
	else if(heavies < max_heavies)
		heavies++
		to_chat(H, SPAN_ROLE_HEADER("You are a Deathsquad Terminator!"))
		to_chat(H, SPAN_ROLE_BODY("You must clear out any traces of the infestation and its survivors."))
		to_chat(H, SPAN_ROLE_BODY("Follow any orders directly from Weston-Yamada!"))
		arm_equipment(H, "Weston-Yamada Deathsquad Terminator", TRUE, TRUE)
	else
		to_chat(H, SPAN_ROLE_HEADER("You are a Deathsquad Commando!"))
		to_chat(H, SPAN_ROLE_BODY("You must clear out any traces of the infestation and its survivors."))
		to_chat(H, SPAN_ROLE_BODY("Follow any orders directly from Weston-Yamada!"))
		arm_equipment(H, "Weston-Yamada Deathsquad", TRUE, TRUE)

	addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)
