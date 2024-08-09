

/datum/emergency_call/upp/beacon
	name = "UPP (Beacon Reinforcements)"
	mob_max = 5
	mob_min = 1
	max_engineers = 1
	max_medics = 1
	home_base = /datum/lazy_template/ert/upp_station
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_upp
	item_spawn = /obj/effect/landmark/ert_spawns/distress_upp/item
	spawn_max_amount = TRUE

/datum/emergency_call/upp/beacon/New()
	..()
	objectives = "Assist the USCM forces"
	arrival_message = "[MAIN_SHIP_NAME], this is the SSV Haldin of the Union of Progressive Peoples. We hear your call for reinforcements and are sending our forces to assist you under International Law as outlined by the Treaty of Canton."

/datum/emergency_call/upp/beacon/create_member(datum/mind/mind, turf/override_spawn_loc)
	set waitfor = 0
	if(SSmapping.configs[GROUND_MAP].map_name == MAP_WHISKEY_OUTPOST)
		name_of_spawn = /obj/effect/landmark/ert_spawns/distress_wo
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc)) return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/human = new(spawn_loc)

	if(mind)
		mind.transfer_to(human, TRUE)
	else
		human.create_hud()

	if(mob_max > length(members))
		announce_dchat("Some UPP were not taken, use the Join As Freed Mob verb to take one of them.")



	if(!leader && (!mind || (HAS_FLAG(human.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(human.client, JOB_SQUAD_LEADER, time_required_for_job))))
		leader = human
		arm_equipment(human, /datum/equipment_preset/upp/beacon/leader, mind == null, TRUE)
		to_chat(human, SPAN_ROLE_HEADER("You are a Squad Leader in the UPP"))
	else if (medics < max_medics && (!mind || (HAS_FLAG(human.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(human.client, JOB_SQUAD_MEDIC, time_required_for_job))))
		medics++
		arm_equipment(human, /datum/equipment_preset/upp/beacon/medic,  mind == null, TRUE)
		to_chat(human, SPAN_ROLE_HEADER("You are a Medic in the UPP"))
	else if (engineers < max_engineers && (!mind || (HAS_FLAG(human.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(human.client, JOB_SQUAD_ENGI, time_required_for_job))))
		engineers++
		arm_equipment(human, /datum/equipment_preset/upp/beacon/sapper,  mind == null, TRUE)
		to_chat(human, SPAN_ROLE_HEADER("You are a Sapper in the UPP"))
	else
		arm_equipment(human, /datum/equipment_preset/upp/beacon/soldier,  mind == null, TRUE)
		to_chat(human, SPAN_ROLE_HEADER("You are a Soldier in the UPP"))

	print_backstory(human)

	sleep(10)
	if(!mind)
		human.free_for_ghosts()
	to_chat(human, SPAN_BOLD("Objectives: [objectives]"))


/datum/emergency_call/upp/beacon/print_backstory(mob/living/carbon/human/human)
	if(ishuman_strict(human))
		to_chat(human, SPAN_BOLD("You grew up in relatively simple family in [pick(75;"Eurasia", 25;"a famished UPP colony")] with few belongings or luxuries."))
		to_chat(human, SPAN_BOLD("The family you grew up with were [pick(50;"getting by", 25;"impoverished", 25;"starving")] and you were one of [pick(10;"two", 20;"three", 20;"four", 30;"five", 20;"six")] children."))
		to_chat(human, SPAN_BOLD("You come from a long line of [pick(40;"crop-harvesters", 20;"soldiers", 20;"factory workers", 5;"scientists", 15;"engineers")], and quickly enlisted to improve your living conditions."))
		to_chat(human, SPAN_BOLD("Following your enlistment to the UPP military at the age of 17, you were assigned to the 17th 'Smoldering Sons' battalion (six hundred strong) under the command of Colonel Ganbaatar."))
	else
		to_chat(human, SPAN_BOLD("You were brought online in a UPP engineering facility, knowing only your engineers for the first few weeks for your pseudo-life."))
		to_chat(human, SPAN_BOLD("You were programmed with all of the medical and combat experience a military fighting force support asset required."))
		to_chat(human, SPAN_BOLD("Throughout your career, your engineers, and later, your UPP compatriots, treated you like [pick(75;"a tool, and only that.", 25;"a person, despite your purpose.")]"))
		to_chat(human, SPAN_BOLD("Some weeks after your unit integration, you were assigned to the 17th 'Smoldering Sons' battalion (six hundred strong) under the command of Colonel Ganbaatar."))
	to_chat(human, SPAN_BOLD("You were shipped off with the battalion to one of the UPP's most remote territories, a gas giant designated MV-35 in the Anglo-Japanese Arm, in the Neroid Sector."))
	to_chat(human, SPAN_BOLD("For the past 14 months, you and the rest of the Smoldering Sons have been stationed at MV-35's only facility, the helium refinery, Altai Station."))
	to_chat(human, SPAN_BOLD("As MV-35 and Altai Station are the only UPP-held zones in the Neroid Sector for many lightyears, you have spent most of your military career holed up in crammed quarters in near darkness, waiting for supply shipments and transport escort deployments."))
	to_chat(human, SPAN_BOLD("With the recent arrival of the USCM battalion the 'Falling Falcons' and their flagship, the [MAIN_SHIP_NAME], the UPP has felt threatened in the sector."))
	to_chat(human, SPAN_BOLD("Despite your mistrust, you've received an open transmission about a Xenomorph outbreak and are coming to assist the USCM."))
