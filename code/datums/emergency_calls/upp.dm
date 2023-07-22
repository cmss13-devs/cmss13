

//UPP Strike Team
/datum/emergency_call/upp
	name = "UPP Naval Infantry (Squad)"
	mob_max = 9
	probability = 10
	shuttle_id = "Distress_UPP"
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_upp
	item_spawn = /obj/effect/landmark/ert_spawns/distress_upp/item
	//1 leader, 1 engineer, 2 medics, 1 specialist, 5 soldiers
	max_medics = 2
	max_engineers = 1
	max_heavies = 1
	max_smartgunners = 0
	var/heavy_pick = TRUE // whether heavy should count as either a minigunner or shotgunner
	hostility = TRUE
	var/max_synths = 1
	var/synths = 0

/datum/emergency_call/upp/New()
	..()
	arrival_message = "T*is i* UP* d^sp^*ch`. STr*&e teaM, #*u are cLe*% for a*pr*%^h. Pr*mE a*l wE*p^ns )0r c|*$e @u*r*r$ c0m&*t."
	objectives = "Eliminate the UA Forces to ensure the UPP prescence in this sector is continued. Listen to your superior officers and take over the [MAIN_SHIP_NAME] at all costs."


/datum/emergency_call/upp/print_backstory(mob/living/carbon/human/M)
	if(ishuman_strict(M))
		to_chat(M, SPAN_BOLD("You grew up in relatively simple family in [pick(75;"Eurasia", 25;"a famished UPP colony")] with few belongings or luxuries."))
		to_chat(M, SPAN_BOLD("The family you grew up with were [pick(50;"getting by", 25;"impoverished", 25;"starving")] and you were one of [pick(10;"two", 20;"three", 20;"four", 30;"five", 20;"six")] children."))
		to_chat(M, SPAN_BOLD("You come from a long line of [pick(40;"crop-harvesters", 20;"soldiers", 20;"factory workers", 5;"scientists", 15;"engineers")], and quickly enlisted to improve your living conditions."))
		to_chat(M, SPAN_BOLD("Following your enlistment to the UPP military at the age of 17, you were assigned to the 17th 'Smoldering Sons' battalion (six hundred strong) under the command of Colonel Ganbaatar."))
	else
		to_chat(M, SPAN_BOLD("You were brought online in a UPP engineering facility, knowing only your engineers for the first few weeks for your pseudo-life."))
		to_chat(M, SPAN_BOLD("You were programmed with all of the medical and combat experience a military fighting force support asset required."))
		to_chat(M, SPAN_BOLD("Throughout your career, your engineers, and later, your UPP compatriots, treated you like a tool, and only that."))
		to_chat(M, SPAN_BOLD("Some weeks after your unit integration, you were assigned to the 17th 'Smoldering Sons' battalion (six hundred strong) under the command of Colonel Ganbaatar."))
	to_chat(M, SPAN_BOLD("You were shipped off with the battalion to one of the UPP's most remote territories, a gas giant designated MV-35 in the Anglo-Japanese Arm, in the Neroid Sector."))
	to_chat(M, SPAN_BOLD("For the past 14 months, you and the rest of the Smoldering Sons have been stationed at MV-35's only facility, the helium refinery, Altai Station."))
	to_chat(M, SPAN_BOLD("As MV-35 and Altai Station are the only UPP-held zones in the Neroid Sector for many lightyears, you have spent most of your military career holed up in crammed quarters in near darkness, waiting for supply shipments and transport escort deployments."))
	to_chat(M, SPAN_BOLD("With the recent arrival of the enemy USCM battalion the 'Falling Falcons' and their flagship, the [MAIN_SHIP_NAME], the UPP has felt threatened in the sector."))
	to_chat(M, SPAN_BOLD("In an effort to protect the vulnerable MV-35 from the encroaching UA/USCM imperialists, the leadership of your battalion has opted this to be the best opportunity to strike at the Falling Falcons to catch them off guard."))
	to_chat(M, SPAN_WARNING(FONT_SIZE_BIG("Glory to Colonel Ganbaatar.")))
	to_chat(M, SPAN_WARNING(FONT_SIZE_BIG("Glory to the Smoldering Sons.")))
	to_chat(M, SPAN_WARNING(FONT_SIZE_BIG("Glory to the UPP.")))

///////////////////UPP///////////////////////////

/datum/emergency_call/upp/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = H
		arm_equipment(H, /datum/equipment_preset/upp/leader, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are an Officer of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
	else if(synths < max_synths && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_SYNTH) && RoleAuthority.roles_whitelist[H.ckey] & WHITELIST_SYNTHETIC)
		synths++
		to_chat(H, SPAN_ROLE_HEADER("You are a Combat Synthetic of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
		arm_equipment(H, /datum/equipment_preset/upp/synth, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(H.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(H, SPAN_ROLE_HEADER("You are a Medic of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
		arm_equipment(H, /datum/equipment_preset/upp/medic, TRUE, TRUE)
	else if(engineers < engineers && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(H.client, JOB_SQUAD_ENGI, time_required_for_job))
		engineers++
		to_chat(H, SPAN_ROLE_HEADER("You are a Sapper of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
		arm_equipment(H, /datum/equipment_preset/upp/sapper, TRUE, TRUE)
	else if(heavies < max_heavies && ((!heavy_pick && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_HEAVY)) || (heavy_pick && HAS_FLAG(H.client.prefs.toggles_ert, (PLAY_HEAVY|PLAY_SMARTGUNNER)))) && check_timelock(H.client, heavy_pick ? list(JOB_SQUAD_SPECIALIST, JOB_SQUAD_SMARTGUN) : JOB_SQUAD_SPECIALIST, time_required_for_job))
		heavies++
		to_chat(H, SPAN_ROLE_HEADER("You are a Sergeant of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
		var/equipment_path = /datum/equipment_preset/upp/specialist
		if(heavy_pick)
			if(HAS_FLAG(H.client.prefs.toggles_ert, PLAY_HEAVY) && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_SMARTGUNNER))
				equipment_path = pick(/datum/equipment_preset/upp/specialist, /datum/equipment_preset/upp/minigunner)
			else if(HAS_FLAG(H.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && !HAS_FLAG(H.client.prefs.toggles_ert, PLAY_HEAVY))
				equipment_path = /datum/equipment_preset/upp/minigunner
		arm_equipment(H, equipment_path, TRUE, TRUE)
	else if(smartgunners < max_smartgunners && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(H.client, JOB_SQUAD_SMARTGUN, time_required_for_job))
		smartgunners++
		to_chat(H, SPAN_ROLE_HEADER("You are a sergeant of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
		arm_equipment(H, /datum/equipment_preset/upp/minigunner, TRUE, TRUE)
	else
		to_chat(H, SPAN_ROLE_HEADER("You are a soldier of the Union of Progressive People, a powerful socialist state that rivals the United Americas!"))
		arm_equipment(H, /datum/equipment_preset/upp/soldier, TRUE, TRUE)

	print_backstory(H)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)



/datum/emergency_call/upp/platoon
	name = "UPP Naval Infantry (Platoon)"
	mob_min = 4
	mob_max = 30
	probability = 0
	max_medics = 3
	max_heavies = 1
	max_smartgunners = 1
	max_engineers = 2
	max_synths = 1
	heavy_pick = FALSE

/obj/effect/landmark/ert_spawns/distress_upp
	name = "Distress_UPP"

/obj/effect/landmark/ert_spawns/distress_upp/item
	name = "Distress_UPPItem"
