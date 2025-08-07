/datum/emergency_call/goon
	name = "Weyland-Yutani Corporate Security (Squad)"
	mob_max = 6
	probability = 0
	home_base = /datum/lazy_template/ert/weyland_station

/datum/emergency_call/goon/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], this is a Weyland-Yutani Corporate Security shuttle inbound to your distress beacon. We are coming to help."
	objectives = "Secure the Corporate Liaison and the [MAIN_SHIP_NAME]'s Commanding Officer, and eliminate any hostile threats. Do not damage Wey-Yu property."

/datum/emergency_call/goon/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Corporate Security Lead!"))
		arm_equipment(mob, /datum/equipment_preset/goon/lead, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Corporate Security Officer!"))
		arm_equipment(mob, /datum/equipment_preset/goon/standard, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)

/datum/emergency_call/goon/print_backstory(mob/living/carbon/human/M)
	to_chat(M, SPAN_BOLD("You were born [pick(75;"in Europe", 15;"in Asia", 10;"on Mars")] to a poor family."))
	to_chat(M, SPAN_BOLD("Joining the ranks of Weyland-Yutani was all you could do to keep yourself and your loved ones fed."))
	to_chat(M, SPAN_BOLD("You have no idea what a xenomorph is."))
	to_chat(M, SPAN_BOLD("You are a simple security officer employed by Weyland-Yutani to guard their outposts and colonies."))
	to_chat(M, SPAN_BOLD("You heard about the original distress signal ages ago, but you have only just gotten permission from corporate to enter the area."))
	to_chat(M, SPAN_BOLD("Ensure no damage is incurred against Weyland-Yutani. Make sure the CL is safe."))

/datum/emergency_call/goon/chem_retrieval
	name = "Weyland-Yutani Goon (Chemical Investigation Squad)"
	mob_max = 6
	mob_min = 2
	max_medics = 1
	var/checked_objective = FALSE

/datum/emergency_call/goon/chem_retrieval/New()
	..()
	dispatch_message = "[MAIN_SHIP_NAME], this is USCSS Royce. Our squad is boarding to retrieve all samples of a chemical recently scanned from your research department. You should already have received a significant sum of money for your department's discovery. In return we ask that you cooperate and provide everything related to the chemical to our retrieval team."
	objectives = "Secure all documents, samples, and chemicals containing the property DNA_Disintegrating from [MAIN_SHIP_NAME] research department and return them to Response Team Station."

/datum/emergency_call/goon/chem_retrieval/proc/check_objective_info()
	if(objective_info)
		objectives = "Secure all documents, samples and chemicals related to [objective_info] from [MAIN_SHIP_NAME] research department and return them to Response Team Station."
	objectives += "Assume at least 30 units are located within the department. If they can not make more that should be all. Cooperate with the onboard CL to ensure all who know the complete recipe are kept silenced with a contract of confidentiality. All humans who have ingested the chemical must be brought back dead or alive. Viral scan is required for any humans who is suspected of ingestion. You must not deploy to the colony without explicit permission from PMC Dispatch. The professor may call for PMC back up if things get out of hand."
	checked_objective = TRUE

/datum/emergency_call/goon/chem_retrieval/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Corporate Security Lead!"))
		arm_equipment(mob, /datum/equipment_preset/goon/lead, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Corporate Research Consultant!"))
		arm_equipment(mob, /datum/equipment_preset/goon/researcher, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Corporate Security Officer!"))
		arm_equipment(mob, /datum/equipment_preset/goon/standard, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)

/datum/emergency_call/goon/chem_retrieval/print_backstory(mob/living/carbon/human/backstory_human)
	if(backstory_human.job == JOB_WY_RESEARCHER)
		to_chat(backstory_human, SPAN_BOLD("You were born [pick(75;"in Europe", 15;"in Asia", 10;"on Mars")] to a wealthy family."))
		to_chat(backstory_human, SPAN_BOLD("Joining the ranks of Weyland-Yutani was the perfect way to further your research goals."))
		to_chat(backstory_human, SPAN_BOLD("You have a very in depth understanding of xenomorphs."))
		to_chat(backstory_human, SPAN_BOLD("You are a well educated scientist employed by Weyland-Yutani to study various non-humans."))
		to_chat(backstory_human, SPAN_BOLD("You heard about the original distress signal ages ago, but you have only just gotten permission from corporate to enter the area."))
		to_chat(backstory_human, SPAN_BOLD("Your only goal is to recover the chemical aboard the Almayer. Do whatever you have to do."))
	else
		to_chat(backstory_human, SPAN_BOLD("You were born [pick(75;"in Europe", 15;"in Asia", 10;"on Mars")] to a poor family."))
		to_chat(backstory_human, SPAN_BOLD("Joining the ranks of Weyland-Yutani was all you could do to keep yourself and your loved ones fed."))
		to_chat(backstory_human, SPAN_BOLD("You have had a basic brief on xenomorphs."))
		to_chat(backstory_human, SPAN_BOLD("You are a simple security officer employed by Weyland-Yutani to guard their outposts and colonies."))
		to_chat(backstory_human, SPAN_BOLD("You heard about the original distress signal ages ago, but you have only just gotten permission from corporate to enter the area."))
		to_chat(backstory_human, SPAN_BOLD("Ensure no damage is incurred against Weyland-Yutani. Make sure the researcher is kept safe and follow their instructions."))

/datum/emergency_call/goon/bodyguard
	name = "Weyland-Yutani Goon (Executive Bodyguard Detail)"
	mob_max = 1
	mob_min = 1

/datum/emergency_call/goon/bodyguard/New()
	..()
	dispatch_message = "[MAIN_SHIP_NAME], this is a Weyland-Yutani Corporate Security Protection Detail shuttle inbound to the Liaison's Beacon."
	objectives = "Protect the Corporate Liaison and follow his commands, unless it goes against Company policy. Do not damage Wey-Yu property."

/datum/emergency_call/goon/bodyguard/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Corporate Security Lead!"))
		arm_equipment(mob, /datum/equipment_preset/goon/lead, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a Weyland-Yutani Corporate Security Officer!"))
		arm_equipment(mob, /datum/equipment_preset/goon/standard, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)

/datum/emergency_call/goon/bodyguard/print_backstory(mob/living/carbon/human/M)
	to_chat(M, SPAN_BOLD("You were born [pick(75;"in Europe", 15;"in Asia", 10;"on Mars")] to a poor family."))
	to_chat(M, SPAN_BOLD("Joining the ranks of Weyland-Yutani was all you could do to keep yourself and your loved ones fed."))
	to_chat(M, SPAN_BOLD("You have no idea what a xenomorph is."))
	to_chat(M, SPAN_BOLD("You are a simple security officer employed by Weyland-Yutani to guard their Executives from all Divisions alike."))
	to_chat(M, SPAN_BOLD("You were sent to act as the Executives bodyguard on the [MAIN_SHIP_NAME], you have gotten permission from corporate to enter the area."))
	to_chat(M, SPAN_BOLD("Ensure no damage is incurred against Weyland-Yutani. Make sure the CL is safe."))

/datum/emergency_call/goon/platoon
	name = "Weyland-Yutani Corporate Security (Platoon)"
	mob_min = 8
	mob_max = 25
	probability = 0
