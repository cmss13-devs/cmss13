/datum/emergency_call/contractors/beacon
	name = "Military Contractors (Squad) (Friendly) (Beacon)"
	mob_max = 6
	max_engineers =  1
	max_medics = 1
	mob_min = 1
	spawn_max_amount = TRUE


/datum/emergency_call/contractors/beacon/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], this is USCSS Verloc with Vanguard's Arrow Incorporated, Primary Operations; we read your signal, leathernecks, and are coming to aid."
	objectives = "Ensure the survival of the [MAIN_SHIP_NAME], eliminate any hostiles, and assist the crew in any way possible."


/datum/emergency_call/contractors/beacon/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.


	var/mob/living/carbon/human/human = new(spawn_loc)

	if(mind)
		mind.transfer_to(human, TRUE)
	else
		human.create_hud()

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job && (!mind )))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are a Contractor Team Leader of Vanguard's Arrow Incorporated!"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/leader/beacon, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job && (!mind )))
		medics++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Contractor Medical Specialist of Vanguard's Arrow Incorporated!"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/medic/beacon, TRUE, TRUE)
	else if(engineers < max_engineers && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(mob.client, JOB_SQUAD_ENGI) && (spawning_mind))
		engineers++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Contractor Engineering Specialist of Vanguard's Arrow Incorporated!"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/engi/beacon, TRUE, TRUE)
	else(spawning_mind)
		to_chat(mob, SPAN_ROLE_HEADER("You are a Contractor of Vanguard's Arrow Incorporated!"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/standard/beacon, TRUE, TRUE)


/datum/emergency_call/contractors/beacon/print_backstory(mob/living/carbon/human/M)
	if(ishuman_strict(M))
		to_chat(M, SPAN_BOLD("You were born [pick(60;"in the United States", 20;"on Earth", 20;"on a colony")] to a [pick(75;"average", 15;"poor", 10;"well-established")] family."))
		to_chat(M, SPAN_BOLD("Joining the USCM gave you a lot of combat experience and useful skills but changed you."))
		to_chat(M, SPAN_BOLD("After getting out, you couldn't hold a job with the things you saw and did, deciding to put your skills to use you joined a Military Contractor firm."))
		to_chat(M, SPAN_BOLD("You are a skilled mercenary, making better pay than in the Corps."))
	else
		to_chat(M, SPAN_BOLD("You were brought online in a civilian factory."))
		to_chat(M, SPAN_BOLD("You were programmed with all of the medical and engineering knowledge a military fighting force support asset required."))
		to_chat(M, SPAN_BOLD("You were soon after bought by Vanguard's Arrow Incorporated(VAI) to act as support personnel."))
		to_chat(M, SPAN_BOLD("Some months after your purchase, you were assigned to the USCSS Inheritor, a VAI transport vessel."))
	to_chat(M, SPAN_BOLD("You are [pick(80;"unaware", 15;"faintly aware", 5;"knowledgeable")] of the xenomorph threat."))
	to_chat(M, SPAN_BOLD("You are employed by Vanguard's Arrow Incorporated(VAI), as a member of VAI Primary Operations(VAIPO)"))
	to_chat(M, SPAN_BOLD("You are stationed on-board the USCSS Inheritor, a part of VAIPO Task-Force Charlie."))
	to_chat(M, SPAN_BOLD("Under the directive of the VAI executive board, you have been assist in riot control, military aid, and to assist USCMC forces wherever possible."))
	to_chat(M, SPAN_BOLD("The USCSS Inheritor is staffed with crew of roughly three hundred military contractors, and fifty support personnel."))
	to_chat(M, SPAN_BOLD("Assist the USCMC Force of the [MAIN_SHIP_NAME] however you can."))
	to_chat(M, SPAN_BOLD("As a side-objective, VAI has been hired by an unknown benefactor to engage in corporate espionage and sabotage against Weyland-Yutani, avoid direct conflict; you aren't VAISO; but attempt to recover Wey-Yu secrets and plans if possible."))

	print_backstory(mob)

	sleep(10)
	if(!mind)
		human.free_for_ghosts()
	to_chat(human, SPAN_BOLD("Objectives: [objectives]"))
