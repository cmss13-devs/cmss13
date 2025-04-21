
//Weyland-Yutani PMCs. Friendly to USCM, hostile to xenos.
/datum/emergency_call/pmc
	name = "Weyland-Yutani PMC (Squad)"
	mob_max = 6
	probability = 20
	shuttle_id = MOBILE_SHUTTLE_ID_ERT2
	home_base = /datum/lazy_template/ert/weyland_station
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pmc
	item_spawn = /obj/effect/landmark/ert_spawns/distress_pmc/item

	max_smartgunners = 1
	max_medics = 2
	max_heavies = 1
	var/max_synths = 1
	var/synths = 0


/datum/emergency_call/pmc/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], this is USCSS Royce responding to your distress call. We are boarding. Any hostile actions will be met with lethal force."
	objectives = "Secure the Corporate Liaison and the [MAIN_SHIP_NAME]'s Commanding Officer, and eliminate any hostile threats. Do not damage Wey-Yu property."


/datum/emergency_call/pmc/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani PMC Squad Leader!"))
		arm_equipment(mob, /datum/equipment_preset/pmc/pmc_leader, TRUE, TRUE)
	else if(synths < max_synths && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_SYNTH) && mob.client.check_whitelist_status(WHITELIST_SYNTHETIC))
		synths++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani PMC Support Synthetic!"))
		arm_equipment(mob, /datum/equipment_preset/pmc/synth, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani PMC Medic!"))
		arm_equipment(mob, /datum/equipment_preset/pmc/pmc_medic, TRUE, TRUE)
	else if(smartgunners < max_smartgunners && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(mob.client, JOB_SQUAD_SMARTGUN))
		smartgunners++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani PMC Heavy Gunner!"))
		arm_equipment(mob, /datum/equipment_preset/pmc/pmc_gunner, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(mob.client, JOB_SQUAD_SPECIALIST))
		heavies++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani PMC Sniper!"))
		arm_equipment(mob, /datum/equipment_preset/pmc/pmc_sniper, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani PMC Operator!"))
		arm_equipment(mob, /datum/equipment_preset/pmc/pmc_standard, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)


/datum/emergency_call/pmc/print_backstory(mob/living/carbon/human/M)
	if(ishuman_strict(M))
		to_chat(M, SPAN_BOLD("You were born [pick(75;"in Europe", 15;"in Asia", 10;"on Mars")] to a [pick(75;"well-off", 15;"well-established", 10;"average")] family."))
		to_chat(M, SPAN_BOLD("Joining the ranks of Weyland-Yutani has proven to be very profitable for you."))
		to_chat(M, SPAN_BOLD("While you are officially an employee, much of your work is off the books. You work as a skilled mercenary."))
		to_chat(M, SPAN_BOLD("You are [pick(50;"unaware of the xenomorph threat", 15;"acutely aware of the xenomorph threat", 10;"well-informed of the xenomorph threat")]"))
	else
		to_chat(M, SPAN_BOLD("You were brought online in a Weyland-Yutani synthetic production facility, knowing only your engineers for the first few weeks for your pseudo-life."))
		to_chat(M, SPAN_BOLD("You were programmed with standard synthetic skills as per facility and geneva protocol."))
		to_chat(M, SPAN_BOLD("Throughout your service, you gained recognition as a capable unit and your model was given equipment upgrades which USCM models lack."))
		to_chat(M, SPAN_BOLD("You were given all available information about the xenomorph threat apart from classified data reserved for special employees."))
	to_chat(M, SPAN_BOLD("You are part of  Weyland-Yutani Task Force Oberon that arrived in 2182 following the UA withdrawl of the Neroid Sector."))
	to_chat(M, SPAN_BOLD("Task-force Oberon is stationed aboard the USCSS Royce, a powerful Weyland-Yutani cruiser that patrols the outer edges of the Neroid Sector. "))
	to_chat(M, SPAN_BOLD("Under the directive of Weyland-Yutani board member Johan Almric, you act as private security for Weyland-Yutani science teams."))
	to_chat(M, SPAN_BOLD("The USCSS Royce contains a crew of roughly two hundred PMCs, and one hundred scientists and support personnel."))
	to_chat(M, SPAN_BOLD("Ensure no damage is incurred against Weyland-Yutani. Make sure the CL is safe."))
	to_chat(M, SPAN_BOLD("Deny Weyland-Yutani's involvement and do not trust the UA/USCM forces."))


/datum/emergency_call/pmc/platoon
	name = "Weyland-Yutani PMC (Platoon)"
	mob_min = 8
	mob_max = 25
	probability = 0
	max_medics = 2
	max_heavies = 2
	max_smartgunners = 2
	max_synths = 1

/datum/emergency_call/pmc/chem_retrieval
	name = "Weyland-Yutani PMC (Chemical Investigation Squad)"
	mob_max = 6
	mob_min = 2
	probability = 0
	max_medics = 2
	max_smartgunners = 1
	var/checked_objective = FALSE

/datum/emergency_call/pmc/chem_retrieval/New()
	..()
	dispatch_message = "[MAIN_SHIP_NAME], this is USCSS Royce. We are sending a second squad aboard to retrieve all samples of a chemical recently scanned from your research department. If you do not cooperate, the team is authorized to use lethal force and terminate the research department."
	objectives = "Secure all documents, samples and chemicals containing the property DNA_Disintegrating from [MAIN_SHIP_NAME] research department."

/datum/emergency_call/pmc/chem_retrieval/proc/check_objective_info()
	if(objective_info)
		objectives = "Secure all documents, samples and chemicals related to [objective_info] from [MAIN_SHIP_NAME] research department."
	objectives += "Assume at least 30 units are located within the department. If they can not make more that should be all. Cooperate with the onboard Wey-Yu researcher to ensure all who know the complete recipe are kept silenced with a contract of confidentiality. All humans who have ingested the chemical must be brought back dead or alive. Viral scan is required for any humans who is suspected of ingestion. Full termination of the department is authorized if they do not cooperate, but this should be avoided UNLESS ABSOLUTELY NECESSARY."
	checked_objective = TRUE

/datum/emergency_call/pmc/chem_retrieval/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	if(!checked_objective)
		check_objective_info()

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, JOB_SQUAD_LEADER, time_required_for_job))    //First one spawned is always the leader.
		leader = H
		to_chat(H, SPAN_ROLE_HEADER("You are a Weyland-Yutani PMC Squad Leader!"))
		arm_equipment(H, /datum/equipment_preset/pmc/pmc_lead_investigator, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(H.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(H, SPAN_ROLE_HEADER("You are a Weyland-Yutani PMC Medical Investigator!"))
		arm_equipment(H, /datum/equipment_preset/pmc/pmc_med_investigator, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(H.client, JOB_SQUAD_SMARTGUN, time_required_for_job))
		heavies++
		to_chat(H, SPAN_ROLE_HEADER("You are a Weyland-Yutani PMC Heavy Gunner!"))
		arm_equipment(H, /datum/equipment_preset/pmc/pmc_gunner, TRUE, TRUE)
	else
		to_chat(H, SPAN_ROLE_HEADER("You are a Weyland-Yutani PMC Detainer!"))
		arm_equipment(H, /datum/equipment_preset/pmc/pmc_detainer, TRUE, TRUE)

	print_backstory(H)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)

/obj/effect/landmark/ert_spawns/distress_pmc
	name = "Distress_PMC"
	icon_state = "spawn_distress_pmc"

/obj/effect/landmark/ert_spawns/distress_pmc/item
	name = "Distress_PMCitem"
	icon_state = "distress_item"
