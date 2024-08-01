

/datum/emergency_call/vaipo/beacon
	name = "VAIPO (Beacon Reinforcements)"
	mob_max = 5
	mob_min = 1
	max_engineers = 1
	max_medics = 1
	spawn_max_amount = TRUE

/datum/emergency_call/vaipo/beacon/New()
	..()
	objectives = "Assist the USCM forces"
	arrival_message = "[MAIN_SHIP_NAME], this is USCSS Verloc with Vanguard's Arrow Incorporated, Primary Operations; we read your signal, leathernecks, and are coming to aid in accordance with the Military Aid Act of 2177."

/datum/emergency_call/vaipo/beacon/create_member(datum/mind/mind, turf/override_spawn_loc)
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
		announce_dchat("Some VAIPO were not taken, use the Join As Freed Mob verb to take one of them.")



	if(!leader && (!mind || (HAS_FLAG(human.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(human.client, JOB_SQUAD_LEADER, time_required_for_job))))
		leader = human
		arm_equipment(human, /datum/equipment_preset/contractor/duty/leader/beacon, mind == null, TRUE)
		to_chat(human, SPAN_ROLE_HEADER("You are a Squad Leader in VAIPO"))
	else if (medics < max_medics && (!mind || (HAS_FLAG(human.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(human.client, JOB_SQUAD_MEDIC, time_required_for_job))))
		medics++
		arm_equipment(human, /datum/equipment_preset/contractor/duty/medic/beacon, mind == null, TRUE)
		to_chat(human, SPAN_ROLE_HEADER("You are a Combat Medic in VAIPO"))
	else if (engineers < max_engineers && (!mind || (HAS_FLAG(human.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(human.client, JOB_SQUAD_ENGI, time_required_for_job))))
		engineers++
		arm_equipment(human, /datum/equipment_preset/contractor/duty/engi/beacon,  mind == null, TRUE)
		to_chat(human, SPAN_ROLE_HEADER("You are an Engineer in VAIPO"))
	else
		arm_equipment(human, /datum/equipment_preset/contractor/duty/standard/beacon,  mind == null, TRUE)
		to_chat(human, SPAN_ROLE_HEADER("You are a Riflemen in VAIPO"))

		print_backstory(human)

	sleep(10)
	if(!mind)
		human.free_for_ghosts()
	to_chat(human, SPAN_BOLD("Objectives: [objectives]"))



/datum/emergency_call/vaipo/beacon/print_backstory(mob/living/carbon/human/human)
	if(ishuman_strict(human))
		to_chat(human, SPAN_BOLD("You were born [pick(60;"in the United States", 20;"on Earth", 20;"on a colony")] to a [pick(75;"average", 15;"poor", 10;"well-established")] family."))
		to_chat(human, SPAN_BOLD("Joining the USCM gave you a lot of combat experience and useful skills but changed you."))
		to_chat(human, SPAN_BOLD("After getting out, you couldn't hold a job with the things you saw and did, deciding to put your skills to use you joined a Military Contractor firm."))
		to_chat(human, SPAN_BOLD("You are a skilled mercenary, making better pay than in the Corps."))
	else
		to_chat(human, SPAN_BOLD("You were brought online in a civilian factory."))
		to_chat(human, SPAN_BOLD("You were programmed with all of the medical and engineering knowledge a military fighting force support asset required."))
		to_chat(human, SPAN_BOLD("You were soon after bought by Vanguard's Arrow Incorporated(VAI) to act as support personnel."))
		to_chat(human, SPAN_BOLD("Some months after your purchase, you were assigned to the USCSS Inheritor, a VAI transport vessel."))
	to_chat(human, SPAN_BOLD("You are [pick(80;"unaware", 15;"faintly aware", 5;"knowledgeable")] of the xenomorph threat."))
	to_chat(human, SPAN_BOLD("You are employed by Vanguard's Arrow Incorporated(VAI), as a member of VAI Primary Operations(VAIPO)"))
	to_chat(human, SPAN_BOLD("You are stationed on-board the USCSS Inheritor, a part of VAIPO Task-Force Charlie."))
	to_chat(human, SPAN_BOLD("Under the directive of the VAI executive board, you have been assist in riot control, military aid, and to assist USCMC forces wherever possible."))
	to_chat(human, SPAN_BOLD("The USCSS Inheritor is staffed with crew of roughly three hundred military contractors, and fifty support personnel."))
	to_chat(human, SPAN_BOLD("Assist the USCMC Force of the [MAIN_SHIP_NAME] however you can."))
	to_chat(human, SPAN_BOLD("As a side-objective, VAI has been hired by an unknown benefactor to engage in corporate espionage and sabotage against Weyland-Yutani, avoid direct conflict; you aren't VAISO; but attempt to recover Wey-Yu secrets and plans if possible."))
	to_chat(human, SPAN_BOLD("Your Task Force has been on patrol within the Neroid sector, and recieved a call for reinforcements from the USS Almayer."))
