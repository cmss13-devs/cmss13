/datum/emergency_call/contractors
	name = "Military Contractors (Squad) (Friendly)"
	mob_max = 7
	probability = 10

	max_engineers =  1
	max_medics = 1
	max_heavies = 1
	var/max_synths = 1
	var/synths = 0


/datum/emergency_call/contractors/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], this is USCSS Inheritor with Vanguard's Arrow Incorporated, Primary Operations; we are responding to your distress call and boarding in accordance with the Military Aid Act of 2177, authenticication code Lima-18153. "
	objectives = "Ensure the survival of the [MAIN_SHIP_NAME], eliminate any hostiles, and assist the crew in any way possible."


/datum/emergency_call/contractors/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are a Contractor Team Leader of Vanguard's Arrow Incorporated!"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/leader, TRUE, TRUE)
	else if(synths < max_synths && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_SYNTH) && mob.client.check_whitelist_status(WHITELIST_SYNTHETIC))
		synths++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Contractor Support Synthetic of Vanguard's Arrow Incorporated!"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/synth, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Contractor Medical Specialist of Vanguard's Arrow Incorporated!"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/medic, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(mob.client, JOB_SQUAD_SPECIALIST))
		heavies++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Contractor Machinegunner of Vanguard's Arrow Incorporated!"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/heavy, TRUE, TRUE)
	else if(engineers < max_engineers && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(mob.client, JOB_SQUAD_ENGI))
		engineers++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Contractor Engineering Specialist of Vanguard's Arrow Incorporated!"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/engi, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a Contractor of Vanguard's Arrow Incorporated!"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/standard, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)


/datum/emergency_call/contractors/print_backstory(mob/living/carbon/human/M)
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
	to_chat(M, SPAN_BOLD("As a side-objective, VAI has been hired by an unknown benefactor to engage in corporate espionage and sabotage against Weyland-Yutani, do not get into a fight, but attempt to recover Wey-Yu secrets and plans if possible."))


/datum/emergency_call/contractors/platoon
	name = "Military Contractors (Platoon) (Friendly)"
	mob_min = 7
	mob_max = 28
	probability = 0
	max_medics = 3
	max_heavies = 3
	max_engineers = 2
	max_synths = 2

/datum/emergency_call/contractors/covert
	name = "Military Contractors (Covert) (Friendly)"
	mob_max = 7
	probability = 10
	max_medics = 1
	max_engineers = 1
	max_heavies = 1
	max_synths = 1
	var/checked_objective = FALSE

/datum/emergency_call/contractors/covert/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], this is USCSS Samburan, with Vanguard's Arrow Incorporated, Special Operations; we are boarding in accordance with the 2177 Military Aid Act; authorisation code X-Ray 19601."
	objectives = "Assist USCMC forces in whatever way is possible, sabotage Weyland-Yutani efforts."

/datum/emergency_call/contractors/covert/proc/check_objective_info()
	if(objective_info)
		objectives = "Assist USCMC forces in whatever way is possible."
	objectives += "Sabotage Weyland-Yutani efforts."
	checked_objective = TRUE

/datum/emergency_call/contractors/covert/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	if(!checked_objective)
		check_objective_info()

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, JOB_SQUAD_LEADER, time_required_for_job))    //First one spawned is always the leader.
		leader = H
		to_chat(H, SPAN_ROLE_HEADER("You are a Covert Contractor Team Leader of Vanguard's Arrow Incorporated!"))
		arm_equipment(H, /datum/equipment_preset/contractor/covert/leader, TRUE, TRUE)
	else if(synths < max_synths && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_SYNTH) && H.client.check_whitelist_status(WHITELIST_SYNTHETIC))
		synths++
		to_chat(H, SPAN_ROLE_HEADER("You are a Contractor Support Synthetic of Vanguard's Arrow Incorporated!"))
		arm_equipment(H, /datum/equipment_preset/contractor/covert/synth, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(H.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(H, SPAN_ROLE_HEADER("You are a Covert Contractor Medical Specialist of Vanguard's Arrow Incorporated!"))
		arm_equipment(H, /datum/equipment_preset/contractor/covert/medic, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(H.client, JOB_SQUAD_SMARTGUN, time_required_for_job))
		heavies++
		to_chat(H, SPAN_ROLE_HEADER("You are a Covert Contractor Machinegunner of Vanguard's Arrow Incorporated!"))
		arm_equipment(H, /datum/equipment_preset/contractor/covert/heavy, TRUE, TRUE)
	else if(engineers < max_engineers && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(H.client, JOB_SQUAD_ENGI))
		engineers++
		to_chat(H, SPAN_ROLE_HEADER("You are a Covert Contractor Engineering Specialist of Vanguard's Arrow Incorporated!"))
		arm_equipment(H, /datum/equipment_preset/contractor/covert/engi, TRUE, TRUE)
	else
		to_chat(H, SPAN_ROLE_HEADER("You are a Covert Contractor of Vanguard's Arrow Incorporated!"))
		arm_equipment(H, /datum/equipment_preset/contractor/covert/standard, TRUE, TRUE)

	print_backstory(H)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)

