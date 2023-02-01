//USCM Provost
/datum/emergency_call/inspection_provost
	name = "Inspection - USCM Provost - ML knowledge required."
	mob_max = 2
	mob_min = 1
	probability = 0

/datum/emergency_call/inspection_provost/New()
	..()
	objectives = "Investigate any issues with ML enforcement on the [MAIN_SHIP_NAME]."


/datum/emergency_call/inspection_provost/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/T = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(T))
		return FALSE

	var/mob/living/carbon/human/H = new(T)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, list(JOB_WARDEN, JOB_CHIEF_POLICE), time_required_for_job))
		leader = H
		arm_equipment(H, /datum/equipment_preset/uscm_event/provost/inspector, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are an Inspector of the USCM Provost Office!"))
		to_chat(H, SPAN_ROLE_BODY("You are being dispatched to the [MAIN_SHIP_NAME] to investigate an undisclosed issue with ML enforcement. The Provost Office may provide more details, but you should head for the Brig to assess the situation."))
		to_chat(H, SPAN_ROLE_BODY("You have the final say on ML enforcement in your AO, but are still obligated to follow it. Use this authority to set things right and make sure that justice is served!"))
		to_chat(H, SPAN_WARNING("This role requires familiarity with Marine Law and Standard Operating Procedure. Ahelp if you have any questions or wish to surrender the character to someone else."))
	else
		arm_equipment(H, /datum/equipment_preset/uscm_event/provost/enforcer, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are an Enforcer of the USCM Provost Office!"))
		to_chat(H, SPAN_ROLE_BODY("You are being assigned as part escort, part assistant and part law enforcer to the Inspector that is being dispatched to the [MAIN_SHIP_NAME]"))
		to_chat(H, SPAN_ROLE_BODY("You are not expected to enforce ML on the ship, however the Inspector may ask you to perform MP duties as part of their investigation in which case you are obligated to act like any other MP."))
		to_chat(H, SPAN_WARNING("This role requires familiarity with Marine Law and Standard Operating Procedure. Ahelp if you have any questions or wish to surrender the character to someone else."))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)


/datum/emergency_call/inspection_provost/spawn_items()
	var/turf/drop_spawn

	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/storage/box/handcuffs(drop_spawn)
	new /obj/item/storage/box/handcuffs(drop_spawn)

//USCM High Command
/datum/emergency_call/inspection_hc
	name = "Inspection - USCM High Command"
	mob_max = 2
	mob_min = 1
	probability = 0

/datum/emergency_call/inspection_hc/New()
	..()
	objectives = "Inspect and evaluate the [MAIN_SHIP_NAME] and its crew."


/datum/emergency_call/inspection_hc/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/T = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(T))
		return FALSE

	var/mob/living/carbon/human/H = new(T)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, list(JOB_SO), time_required_for_job))
		leader = H
		arm_equipment(H, /datum/equipment_preset/uscm_ship/so, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are an Inspector sent by the USCM High Command!"))
		to_chat(H, SPAN_ROLE_BODY("An inspection is scheduled for the [MAIN_SHIP_NAME] during their current assignment. High Command may have other directives for you that they will relay via radio."))
		to_chat(H, SPAN_ROLE_BODY("Tour the ship, monitor the organization, effectiveness and SOP compliance of its respective departments, interview its crew and find any issues. Relay the results of your inspection to both the Officer in Command of the ship and USCM High Command."))
		to_chat(H, SPAN_WARNING("Remember, your inspection may not interrupt regular operation of the ship and you do not have privileges to make Marine Law enforcement related calls. Ahelp if you have any questions of you wish to offer the role to someone else."))
	else
		arm_equipment(H, /datum/equipment_preset/uscm/engineer_equipped, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are part of an inspection team sent by the USCM High Command!"))
		to_chat(H, SPAN_ROLE_BODY("An inspection is scheduled for the [MAIN_SHIP_NAME] during their current assignment. You serve both as security detail to the officer performing the inspection and their assistant should they need your expertise."))
		to_chat(H, SPAN_ROLE_BODY("Follow the inspector as they perform their duties on the ship. Feel free to offer your insight if you feel like you have any and help then as they request it. Remember, while you do not answer directly to the officers on the ship, you still need to respect their position."))
		to_chat(H, SPAN_WARNING("Remember, you may not interrupt regular operation and are expected to follow orders of the Inspector at all times. Ahelp if you have any questions of you wish to offer the role to someone else."))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)

//UAAC-TIS
/datum/emergency_call/inspection_tis
	name = "Inspection - UA Allied Command TIS - ML Knowledge Required"
	mob_max = 2
	mob_min = 1
	probability = 0

/datum/emergency_call/inspection_tis/New()
	..()
	objectives = "Await detailed directives from your Handler. Remember that you may, but do not have to, investigate any ML or SOP related issues during your time on the [MAIN_SHIP_NAME]."

/datum/emergency_call/inspection_tis/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/T = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(T))
		return FALSE

	var/mob/living/carbon/human/H = new(T)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, list(JOB_INTEL,JOB_WARDEN), time_required_for_job))
		leader = H
		arm_equipment(H, /datum/equipment_preset/uscm_event/uaac/tis/io, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are an Intelligence Officer working for the UAAC-TIS!"))
		to_chat(H, SPAN_ROLE_BODY("The UAAC-TIS, also known as the Three Eyes, is responsible for the collection, collation and delivery of Intelligence across UA assets. Your Handler will contact you about the exact nature of your mission on board the [MAIN_SHIP_NAME]."))
		to_chat(H, SPAN_ROLE_BODY("While you do not have any direct authority over the USCM, the TIS mandate also allows you to investigate any perceived abuse of the Law, be it written or implied. Remember, you have the authority to make calls on ML should the crew of the Almayer request it or your Handler order you to resolve ML issues."))
		to_chat(H, SPAN_WARNING("Remember that you cannot take antagonistic action unless specifically allowed by your Handler. You are also expected to know ML and SOP. Ahelp if you have any questions or wish to release this mob for other players."))
	else
		arm_equipment(H, /datum/equipment_preset/uscm_event/provost/enforcer, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are an Enforcer of the USCM Provost Office!"))
		to_chat(H, SPAN_ROLE_BODY("You have been assigned as an escort for an UAAC-TIS Officer being dispatched to the [MAIN_SHIP_NAME]. Technically, the TIS has no direct authority over you, however you have been ordered to follow the instructions of the TIS Officer."))
		to_chat(H, SPAN_ROLE_BODY("You are not expected to enforce ML on the ship and are generally expected to follow the instruction of the Officer you are protecting. Remember that should they start acting in a way that you believe puts the USCM in danger, you are not obligated to follow their orders and should report this to the Provost at once."))
		to_chat(H, SPAN_WARNING("This role requires familiarity with Marine Law and Standard Operating Procedure. Ahelp if you have any questions or wish to surrender the character to someone else."))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)

/datum/emergency_call/inspection_tis/spawn_items()
	var/turf/drop_spawn

	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/storage/box/handcuffs(drop_spawn)
	new /obj/item/storage/box/handcuffs(drop_spawn)

//Weyland-Yutani
/datum/emergency_call/inspection_wy
	name = "Inspection - Corporate"
	mob_max = 2
	mob_min = 1
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pmc
	item_spawn = /obj/effect/landmark/ert_spawns/distress_pmc/item
	probability = 0

/datum/emergency_call/inspection_wy/New()
	..()
	objectives = "Make sure the crew of the [MAIN_SHIP_NAME] is aware of your presence. Investigate the Corporate Liaison and any other Company assets and make sure they remain loyal to the Company. Make a detailed report back to Dispatch."

/datum/emergency_call/inspection_wy/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/T = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(T))
		return FALSE

	var/mob/living/carbon/human/H = new(T)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, list(JOB_SQUAD_LEADER), time_required_for_job))
		leader = H
		arm_equipment(H, /datum/equipment_preset/pmc/pmc_lead_investigator, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Weyland Yutani PMC Inspector!"))
		to_chat(H, SPAN_ROLE_BODY("While officially your outfit does mundane security work for Weyland-Yutani, in practice you serve as both official and unofficial investigators into conduct of Company personnel. You are being dispatched to the [MAIN_SHIP_NAME] to make sure that the local Liaison has not forgotten their priorities or worse, thought to bite the hand that feeds them."))
		to_chat(H, SPAN_ROLE_BODY("Remember the USCM personnel on the ship may not appreciate your presence there. Should the Liaison be in jail, you are not to act as legal counsel in any way unless instructed to do so by Dispatch. Your basic duty is to make a detailed report of anything involving the Liaison and any other WY personnel on board the ship."))
		to_chat(H, SPAN_WARNING("Unless ordered otherwise by Dispatch, you are to avoid open conflict with the Marines. Retreat and make a report if they are outright hostile. Ahelp if you have any more questions or wish to release this character for other players."))
	else
		arm_equipment(H, /datum/equipment_preset/pmc/pmc_detainer, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are part of a Weyland-Yutani PMC Investigation Team!"))
		to_chat(H, SPAN_ROLE_BODY("While officially your outfit does mundane security work for Weyland-Yutani, in practice you serve as both official and unofficial investigators into conduct of Company personnel. The Lead Investigator is in charge, your duty is to provide backup, counsel and any other form of assistance you can render to make sure their mission is a success."))
		to_chat(H, SPAN_ROLE_BODY("Remember that the USCM, or at least some parts of it, may be hostile towards your presence on the ship. Unless ordered otherwise by Dispatch, you and your Team Leader are to avoid open conflict with the Marines. Your main priority is making sure that your Lead survives to write the report they are due."))
		to_chat(H, SPAN_WARNING("Unless ordered otherwise by Dispatch, you are to avoid open conflict with the Marines. Your priority is the safety of your team, if the ship gets to hot, your best bet is evacuation. Ahelp if you have any more questions or wish to release this character for other players."))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)

/datum/emergency_call/inspection_wy/spawn_items()
	var/turf/drop_spawn

	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/storage/box/handcuffs(drop_spawn)
	new /obj/item/storage/box/handcuffs(drop_spawn)
