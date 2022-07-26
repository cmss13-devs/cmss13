/datum/emergency_call/pmc
	name = "Military Contractors (Squad)"
	mob_max = 11
	probability = 10
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pmc
	item_spawn = /obj/effect/landmark/ert_spawns/distress_pmc/item

	max_engineers =  1
	max_medics = 2
	max_heavies = 2
	max_synths = 1


/datum/emergency_call/contractors/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], this is USCSS Marlow responding to your distress call. We are boarding, with authorisation provided by the 2178 Military Contract Act"
	objectives = "Assure the survival of the [MAIN_SHIP_NAME], eliminate any hostiles, and assistant the crew in any way possible."


/datum/emergency_call/pmc/create_member(datum/mind/M, var/turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are a contractor team leader!"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/leader, TRUE, TRUE)
	else if(synths < max_synths && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_SYNTH) && RoleAuthority.roles_whitelist[H.ckey] & WHITELIST_SYNTHETIC)
		synths++
		to_chat(H, SPAN_ROLE_HEADER("You are a synthetic owned by the VASC Private Military Company, a small PMC group based in the United Americas!"))
		arm_equipment(H, /datum/equipment_preset/contractor/duty/synth, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(mob, SPAN_ROLE_HEADER("You are a contractor medical specialist!"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/medic, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(mob.client, JOB_SQUAD_SPECIALIST))
		heavies++
		to_chat(mob, SPAN_ROLE_HEADER("You are a contractor machinegunner!"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/heavy, TRUE, TRUE)
	else if(engineers < max_engineers && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(mob.client, JOB_SQUAD_ENGI))
		engineers++
		to_chat(mob, SPAN_ROLE_HEADER("You are a contractor engineering specialist!"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/engi, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a contractor mercenary!"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)


/datum/emergency_call/contractors/print_backstory(mob/living/carbon/human/M)
	if(isHumanStrict(M))
		to_chat(M, SPAN_BOLD("You were born [pick(60;"in the United States", 20;"on Earth", 20;"on a colony")] to a [pick(75;"average", 15;"poor", 10;"well-established")] family."))
		to_chat(M, SPAN_BOLD("Joining the USCM gave you a lot of combat experience and useful skills but changed you."))
		to_chat(M, SPAN_BOLD("After getting out, you couldn't hold a job with the things you saw and did, deciding to put your skills to use you joined a Military Contractor firm."))
		to_chat(M, SPAN_BOLD("You are a skilled mercenary, making better pay than in the Corps."))
	else
		to_chat(M, SPAN_BOLD("You were brought online in a civilian manufactory."))
		to_chat(M, SPAN_BOLD("You were programmed with all of the medical and engineering knowledge a military fighting force support asset required."))
		to_chat(M, SPAN_BOLD("You were soon after bought by the Vanguard's Arrow Security Consulting Agency to act as support personnel."))
		to_chat(M, SPAN_BOLD("Some months after your purchase, you were assigned to the USCSS Marlow, a VASC transport vessel."))
	to_chat(M, SPAN_BOLD("You are [pick(80;"unaware", 15;"faintly aware", 5;"knowledgeable")] of the xenomorph threat."))
	to_chat(M, SPAN_BOLD("You are part of Vanguard's Arrow Security Consulting Agency(VASC), as a member of Foxtrot-Five team."))
	to_chat(M, SPAN_BOLD("Foxtrot-Five team is stationed on-board the USCSS Marlow, a relatively large surplus military ship that is stationed on at the outer edges of Tychon's Rift. "))
	to_chat(M, SPAN_BOLD("Under the directive of the Vanguard's Arrow executive board, you have been assist in riot control, military aid, and preform paid contract work for smaller companies."))
	to_chat(M, SPAN_BOLD("The USCSS Marlow contains a crew of roughly three hundred military contractors, and fifty support personnel."))
	to_chat(M, SPAN_BOLD("Assist the USCMC Force of the [MAIN_SHIP_NAME] however you can."))
	to_chat(M, SPAN_BOLD("As a side-objective, the Vanguard's Arrow agency has been hired to assist in sabotage efforts against Weyland-Yutani, do not openly engage W-Y forces but attempt to find out and stop their plans."))


/datum/emergency_call/contractors/platoon
	name = "Military Contractors (Platoon)"
	mob_min = 11
	mob_max = 41
	probability = 0
	max_medics = 4
	max_heavies = 3
	max_engineers = 2
	max_synths = 2

/datum/emergency_call/contractors/covert
	name = "Military Contractors (Covert)"
	mob_max = 11
	probability = 0
	max_medics = 2
	max_engineers = 1
	max_heavies = 1
	max_synths = 1
	var/checked_objective = FALSE

/datum/emergency_call/contractors/covert/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], this is USCSS Marlow. Our squad is boarding in compliance with the 2178 Military Contract act."
	objectives = "Assist USCMC forces in whatever way is possible, sabotage Weyland-Yutani efforts."

/datum/emergency_call/contractors/covert/proc/check_objective_info()
	if(objective_info)
		objectives = "Assist USCMC forces in whatever way is possible."
	objectives += "Sabotage Weyland-Yutani efforts."
	checked_objective = TRUE

/datum/emergency_call/contractors/covert/create_member(datum/mind/M, var/turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	if(!checked_objective)
		check_objective_info()

	var/mob/living/carbon/human/H = new(spawn_loc)
	H.key = M.key
	if(H.client)
		H.client.change_view(world_view_size)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, JOB_SQUAD_LEADER, time_required_for_job))       //First one spawned is always the leader.
		leader = H
		to_chat(H, SPAN_ROLE_HEADER("You are a covert contractor team leader!"))
		arm_equipment(H, /datum/equipment_preset/contractor/covert_leader, TRUE, TRUE)
	else if(synths < max_synths && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_SYNTH) && RoleAuthority.roles_whitelist[H.ckey] & WHITELIST_SYNTHETIC)
		synths++
		to_chat(H, SPAN_ROLE_HEADER("You are a synthetic owned by the VASC Private Military Company, a small PMC group based in the United Americas!"))
		arm_equipment(H, /datum/equipment_preset/contractor/covert_synth, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(H.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(H, SPAN_ROLE_HEADER("You are a covert contractor medical specialist!"))
		arm_equipment(H, /datum/equipment_preset/contractor/covert_medic, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(H.client, JOB_SQUAD_SMARTGUN, time_required_for_job))
		heavies++
		to_chat(H, SPAN_ROLE_HEADER("You are a covert contractor machinegunner!"))
		arm_equipment(H, /datum/equipment_preset/covert_machinegunner, TRUE, TRUE)
	else if(engineers < max_engineers && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(mob.client, JOB_SQUAD_ENGI))
		engineers++
		to_chat(H, SPAN_ROLE_HEADER("You are a covert contractor engineering specialist!"))
		arm_equipment(H, /datum/equipment_preset/contractor/covert_engi, TRUE, TRUE)
	else
		to_chat(H, SPAN_ROLE_HEADER("You are a covert contractor mercenary!"))
		arm_equipment(H, /datum/equipment_preset/contractor/covert_standard, TRUE, TRUE)

	print_backstory(H)

	addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, H, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)
/obj/effect/landmark/ert_spawns/distress_pmc
	name = "Distress_PMC"

/obj/effect/landmark/ert_spawns/distress_pmc/item
	name = "Distress_PMCitem"
