
//UPP COMMANDOS
/datum/emergency_call/upp_commando
	name = "UPP Commandos (!DEATHSQUAD!)"
	mob_max = 6
	probability = 0
	objectives = "Stealthily assault the ship. Use your silenced weapons, tranquilizers, and night vision to get the advantage on the enemy. Take out the power systems, comms and engine. Stick together and keep a low profile."
	shuttle_id = MOBILE_SHUTTLE_ID_ERT3
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_upp
	item_spawn = /obj/effect/landmark/ert_spawns/distress_upp/item
	hostility = TRUE

/datum/emergency_call/upp_commando/print_backstory(mob/living/carbon/human/M)
	to_chat(M, SPAN_BOLD("You grew up in relativly simple family in [pick(75;"Eurasia", 25;"a famished UPP colony")] with few belongings or luxuries."))
	to_chat(M, SPAN_BOLD("The family you grew up with were [pick(50;"getting by", 25;"impoverished", 25;"starving")] and you were one of [pick(10;"two", 20;"three", 20;"four", 30;"five", 20;"six")] children."))
	to_chat(M, SPAN_BOLD("You come from a long line of [pick(40;"crop-harvesters", 20;"soldiers", 20;"factory workers", 5;"scientists", 15;"engineers")], and quickly enlisted to improve your living conditions."))
	to_chat(M, SPAN_BOLD("Following your enlistment UPP military at the age of 17 you were assigned to the 17th 'Smoldering Sons' battalion (six hundred strong) under the command of Colonel Ganbaatar."))
	to_chat(M, SPAN_BOLD("You were shipped off with the battalion to one of the UPP's most remote territories, a gas giant designated MV-35 in the Anglo-Japanese Arm, in the Neroid Sector."))
	to_chat(M, SPAN_BOLD("For the past 14 months, you and the rest of the Smoldering Sons have been stationed at MV-35's only facility, the helium refinery, Altai Station."))
	to_chat(M, SPAN_BOLD("As MV-35 and Altai Station are the only UPP-held zones in the Neroid Sector for many lightyears, you have spent most of your military career holed up in crammed quarters in near darkness, waiting for supply shipments and transport escort deployments."))
	to_chat(M, SPAN_BOLD("With the recent arrival of the enemy USCM battalion the 'Falling Falcons' and their flagship, the [MAIN_SHIP_NAME], the UPP has felt threatened in the sector."))
	to_chat(M, SPAN_BOLD("In an effort to protect the vunerable MV-35 from the emproaching UA/USCM imperialists, the leadership of your battalion has opted this the best opportunity to strike at the Falling Falcons to catch them off guard."))
	to_chat(M, SPAN_WARNING(FONT_SIZE_BIG("Glory to Colonel Ganbaatar.")))
	to_chat(M, SPAN_WARNING(FONT_SIZE_BIG("Glory to the Smoldering Sons.")))
	to_chat(M, SPAN_WARNING(FONT_SIZE_BIG("Glory to the UPP.")))
	to_chat(M, SPAN_NOTICE(" Use say :3 <text> to speak in your native tongue."))
	to_chat(M, SPAN_NOTICE(" This allows you to speak privately with your fellow UPP allies."))
	to_chat(M, SPAN_NOTICE(" Utilize it with your radio to prevent enemy radio interceptions."))

/datum/emergency_call/upp_commando/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, JOB_SQUAD_LEADER, time_required_for_job))    //First one spawned is always the leader.
		leader = H
		arm_equipment(H, /datum/equipment_preset/upp/commando/leader, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Commando Team Leader of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
	else if(medics < max_medics && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(H.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(H, SPAN_ROLE_HEADER("You are a Commando Medic of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
		arm_equipment(H, /datum/equipment_preset/upp/commando/medic, TRUE, TRUE)
	else
		to_chat(H, SPAN_ROLE_HEADER("You are a Commando of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
		arm_equipment(H, /datum/equipment_preset/upp/commando, TRUE, TRUE)
	print_backstory(H)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)

/datum/emergency_call/upp_commando/low_threat
	name = "UPP Commandos"

/datum/emergency_call/upp_commando/create_member(datum/mind/mind, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/person = new(spawn_loc)
	mind.transfer_to(person, TRUE)

	if(!leader && HAS_FLAG(person.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(person.client, JOB_SQUAD_LEADER, time_required_for_job))    //First one spawned is always the leader.
		leader = person
		arm_equipment(person, /datum/equipment_preset/upp/commando/leader/low_threat, TRUE, TRUE)
		to_chat(person, SPAN_ROLE_HEADER("You are a Commando Team Leader of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
	else if(medics < max_medics && HAS_FLAG(person.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(person.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(person, SPAN_ROLE_HEADER("You are a Commando Medic of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
		arm_equipment(person, /datum/equipment_preset/upp/commando/medic/low_threat, TRUE, TRUE)
	else
		to_chat(person, SPAN_ROLE_HEADER("You are a Commando of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
		arm_equipment(person, /datum/equipment_preset/upp/commando/low_threat, TRUE, TRUE)
	print_backstory(person)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), person, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)
