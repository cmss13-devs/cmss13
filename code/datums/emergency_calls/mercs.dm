


//Randomly-equipped mercenaries. May be friendly or hostile to the USCM, hostile to xenos.
/datum/emergency_call/mercs
	name = "Freelancers (Squad)"
	mob_max = 8
	probability = 20


/datum/emergency_call/mercs/New()
	. = ..()
	hostility = pick(75;FALSE,25;TRUE)
	arrival_message = "[MAIN_SHIP_NAME], this is Freelancer shuttle [pick(GLOB.alphabet_lowercase)][pick(GLOB.alphabet_lowercase)]-[rand(1, 99)] responding to your distress call. Prepare for boarding."
	if(hostility)
		objectives = "Ransack the [MAIN_SHIP_NAME] and kill anyone who gets in your way. Do what your Warlord says. Ensure your survival at all costs."
	else
		objectives = "Help the crew of the [MAIN_SHIP_NAME] in exchange for payment, and choose your payment well. Do what your Warlord says. Ensure your survival at all costs."

/datum/emergency_call/mercs/friendly //if admins want to specifically call in friendly ones
	name = "Friendly Freelancers (Squad)"
	mob_max = 8
	probability = 0

/datum/emergency_call/mercs/friendly/New()
	. = ..()
	hostility = FALSE
	arrival_message = "[MAIN_SHIP_NAME], this is Freelancer shuttle [pick(GLOB.alphabet_lowercase)][pick(GLOB.alphabet_lowercase)]-[rand(1, 99)] responding to your distress call. Prepare for boarding."
	objectives = "Help the crew of the [MAIN_SHIP_NAME] in exchange for payment, and choose your payment well. Do what your Warlord says. Ensure your survival at all costs."

/datum/emergency_call/mercs/hostile //ditto
	name = "Hostile Freelancers (Squad)"
	mob_max = 8
	probability = 0

/datum/emergency_call/mercs/hostile/New()
	. = ..()
	hostility = TRUE
	arrival_message = "[MAIN_SHIP_NAME], this is Freelancer shuttle [pick(GLOB.alphabet_lowercase)][pick(GLOB.alphabet_lowercase)]-[rand(1, 99)] responding to your distress call. Prepare for boarding."
	objectives = "Ransack the [MAIN_SHIP_NAME] and kill anyone who gets in your way. Do what your Warlord says. Ensure your survival at all costs."

/datum/emergency_call/mercs/print_backstory(mob/living/carbon/human/H)
	to_chat(H, SPAN_BOLD("You started off in the Neroid Sector as a colonist seeking work at one of the established colonies."))
	to_chat(H, SPAN_BOLD("The withdrawl of United American forces in the early 2180s, the system fell into disarray."))
	to_chat(H, SPAN_BOLD("Taking up arms as a mercenary, the Freelancers have become a powerful force of order in the system."))
	to_chat(H, SPAN_BOLD("While they are motivated primarily by money, many colonists see the Freelancers as the main forces of order in the Neroid Sector."))
	if(hostility)
		to_chat(H, SPAN_NOTICE(SPAN_BOLD("Despite this, you have been tasked to ransack the [MAIN_SHIP_NAME] and kill anyone who gets in your way.")))
		to_chat(H, SPAN_NOTICE(SPAN_BOLD("Any UPP, CLF or WY forces also responding are to be considered neutral parties unless proven hostile.")))
	else
		to_chat(H, SPAN_NOTICE(SPAN_BOLD("To this end, you have been contacted by Weyland-Yutani of the USCSS Royce to assist the [MAIN_SHIP_NAME]..")))
		to_chat(H, SPAN_NOTICE(SPAN_BOLD("Ensure they are not destroyed.</b>")))

/datum/emergency_call/mercs/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	H.name = H.real_name
	M.transfer_to(H, TRUE)
	H.job = "Mercenary"

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = H
		arm_equipment(H, /datum/equipment_preset/other/freelancer/leader, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are the Freelancer leader!"))
	else if(medics < max_medics && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(H.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		arm_equipment(H, /datum/equipment_preset/other/freelancer/medic, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Freelancer Medic!"))
	else
		arm_equipment(H, /datum/equipment_preset/other/freelancer/standard, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Freelancer Mercenary!"))
	print_backstory(H)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)

/datum/emergency_call/mercs/platoon
	name = "Freelancers (Platoon)"
	mob_min = 8
	mob_max = 30
	probability = 0
	max_medics = 3

/datum/emergency_call/heavy_mercs
	name = "Elite Mercenaries (Random Alignment)"
	mob_min = 4
	mob_max = 8
	probability = 0
	max_medics = 1
	max_engineers = 1
	max_heavies = 1

/datum/emergency_call/heavy_mercs/New()
	. = ..()
	hostility = pick(75;FALSE,25;TRUE)
	arrival_message = "[MAIN_SHIP_NAME], this is Elite Freelancer shuttle [pick(GLOB.alphabet_lowercase)][pick(GLOB.alphabet_lowercase)]-[rand(1, 99)] responding to your distress call. Prepare for boarding."
	if(hostility)
		objectives = "Ransack the [MAIN_SHIP_NAME] and kill anyone who gets in your way. Do what your Captain says. Ensure your survival at all costs."
	else
		objectives = "Help the crew of the [MAIN_SHIP_NAME] in exchange for payment, and choose your payment well. Do what your Captain says. Ensure your survival at all costs."

/datum/emergency_call/heavy_mercs/hostile
	name = "Elite Mercenaries (HOSTILE to USCM)"

/datum/emergency_call/heavy_mercs/hostile/New()
	. = ..()
	hostility = TRUE
	arrival_message = "[MAIN_SHIP_NAME], this is Elite Freelancer shuttle [pick(GLOB.alphabet_lowercase)][pick(GLOB.alphabet_lowercase)]-[rand(1, 99)] responding to your distress call. Prepare for boarding."
	objectives = "Ransack the [MAIN_SHIP_NAME] and kill anyone who gets in your way. Do what your Captain says. Ensure your survival at all costs."

/datum/emergency_call/heavy_mercs/friendly
	name = "Elite Mercenaries (Friendly)"

/datum/emergency_call/heavy_mercs/friendly/New()
	. = ..()
	hostility = FALSE
	arrival_message = "[MAIN_SHIP_NAME], this is Elite Freelancer shuttle [pick(GLOB.alphabet_lowercase)][pick(GLOB.alphabet_lowercase)]-[rand(1, 99)] responding to your distress call. Prepare for boarding."
	objectives = "Help the crew of the [MAIN_SHIP_NAME] in exchange for payment, and choose your payment well. Do what your Captain says. Ensure your survival at all costs."

/datum/emergency_call/heavy_mercs/print_backstory(mob/living/carbon/human/H)
	to_chat(H, SPAN_BOLD("You started off in the Neroid Sector as an experienced miner seeking work at one of the established colonies."))
	to_chat(H, SPAN_BOLD("The withdrawl of United American forces in the early 2180s, the system fell into disarray."))
	to_chat(H, SPAN_BOLD("Taking up arms as a mercenary, the Freelancers have become a powerful force of order in the system."))
	to_chat(H, SPAN_BOLD("While they are motivated primarily by money, many colonists see the Freelancers as the main forces of order in the Neroid Sector."))
	if(hostility)
		to_chat(H, SPAN_NOTICE(SPAN_BOLD("Despite this, you have been specially tasked to ransack the [MAIN_SHIP_NAME] and kill anyone who gets in your way.")))
		to_chat(H, SPAN_NOTICE(SPAN_BOLD("Any UPP, CLF or WY forces also responding are to be considered neutral parties unless proven hostile.")))
	else
		to_chat(H, SPAN_NOTICE(SPAN_BOLD("To this end, you have been contacted by Weyland-Yutani of the USCSS Royce to assist the [MAIN_SHIP_NAME]..")))
		to_chat(H, SPAN_NOTICE(SPAN_BOLD("Ensure they are not destroyed.</b>")))

/datum/emergency_call/heavy_mercs/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	H.name = H.real_name
	M.transfer_to(H, TRUE)
	H.job = "Mercenary"

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, JOB_SQUAD_LEADER, time_required_for_job))    //First one spawned is always the leader.
		leader = H
		arm_equipment(H, /datum/equipment_preset/other/elite_merc/leader, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are the Elite Mercenary leader!"))
	else if(medics < max_medics && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(H.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		arm_equipment(H, /datum/equipment_preset/other/elite_merc/medic, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are an Elite Mercenary Medic!"))
	else if(engineers < max_engineers && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(H.client, JOB_SQUAD_ENGI, time_required_for_job))
		engineers++
		arm_equipment(H, /datum/equipment_preset/other/elite_merc/engineer, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are an Elite Mercenary Engineer!"))
	else if(heavies < max_heavies && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(H.client, JOB_SQUAD_SMARTGUN, time_required_for_job))
		heavies++
		arm_equipment(H, /datum/equipment_preset/other/elite_merc/heavy, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are an Elite Mercenary Specialist!"))
	else
		arm_equipment(H, /datum/equipment_preset/other/elite_merc/standard, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are an Elite Mercenary!"))
	print_backstory(H)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)
