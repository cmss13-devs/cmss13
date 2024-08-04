//USCM Provost
/datum/emergency_call/inspection_provost
	name = "Inspection - USCM Provost - ML knowledge and MP playtime required."
	mob_max = 2
	mob_min = 1
	probability = 0

/datum/emergency_call/inspection_provost/New()
	..()
	objectives = "Investigate any issues with ML enforcement on the [MAIN_SHIP_NAME]."

/datum/emergency_call/inspection_provost/remove_nonqualifiers(list/datum/mind/candidates_list)
	var/list/datum/mind/candidates_clean = list()
	for(var/datum/mind/single_candidate in candidates_list)
		if(check_timelock(single_candidate.current?.client, JOB_POLICE, time_required_for_job))
			candidates_clean.Add(single_candidate)
			continue
		if(single_candidate.current)
			to_chat(single_candidate.current, SPAN_WARNING("You didn't qualify for the ERT beacon because you don't have enough playtime (5 Hours) as military police!"))
	return candidates_clean

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
	home_base = /datum/lazy_template/ert/weyland_station
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

/datum/emergency_call/inspection_wy/lawyer
	name = "Lawyers - Corporate"
	mob_max = 2
	mob_min = 1
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pmc
	item_spawn = /obj/effect/landmark/ert_spawns/distress_pmc/item
	probability = 0

/datum/emergency_call/inspection_wy/lawyer/New()
	..()
	objectives = "Make sure the crew of the [MAIN_SHIP_NAME] is aware of your presence. Investigate who the Corporate Liaison reported for breaking their contract and any review other Company assets and make sure they remain loyal to the Company. Make a detailed report back to Corporate."

/datum/emergency_call/inspection_wy/lawyer/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/T = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(T))
		return FALSE

	var/mob/living/carbon/human/H = new(T)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, list(JOB_SQUAD_LEADER), time_required_for_job))
		leader = H
		arm_equipment(H, /datum/equipment_preset/wy/exec_supervisor/lawyer, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Weyland-Yutani Lead Corporate Attorney!"))
		to_chat(H, SPAN_ROLE_BODY("While officially the Corporate Affairs Division does mundane paperwork for Weyland-Yutani, in practice you serve as both official and unofficial investigators into conduct of Company and non-Company personnel. You are being dispatched to the [MAIN_SHIP_NAME] to make sure that the USCM abides by it's signed contracts provided by the local Liaison and that they have not forgotten the real hand that feeds them."))
		to_chat(H, SPAN_ROLE_BODY("Remember the USCM personnel on the ship may not appreciate your presence there. Should the Liaison be in jail, you are to act as legal counsel in any way. Your basic duty is to make a detailed report of anything involving the Liaison, any other WY personnel and of course any contract violations on board the ship."))
		to_chat(H, SPAN_WARNING("You are to avoid open conflict with the Marines. Retreat and make a report if they are outright hostile. Ahelp if you have any more questions or wish to release this character for other players."))
	else
		arm_equipment(H, /datum/equipment_preset/wy/exec_spec/lawyer, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Weyland-Yutani Corporate Attorney!"))
		to_chat(H, SPAN_ROLE_BODY("While officially the Corporate Affairs Division does mundane paperwork for Weyland-Yutani, in practice you serve as both official and unofficial investigators into conduct of Company and non-Company personnel. The Lead Attorney is in charge, your duty is to provide counsel and any other form of assistance you can render to make sure your mission is a success."))
		to_chat(H, SPAN_ROLE_BODY("Remember that the USCM, or at least some parts of it, may be hostile towards your presence on the ship. You and the Lead Attorney are to avoid open conflict with the Marines. Your main priority is making sure that you both survive to write the report the Company is due."))
		to_chat(H, SPAN_WARNING("You are to avoid open conflict with the Marines. Retreat and make a report if they are outright hostile. Ahelp if you have any more questions or wish to release this character for other players."))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)


// Colonial Marshals - UA Law Enforcement / Investigative Federal Agents which usually watch over Colonies. Also a good option for prisoner transfers, investigating corporate corruption, survivor rescues, or illict trade practices(black market).
/datum/emergency_call/inspection_cmb
	name = "Inspection - Colonial Marshals Investigation Team"
	mob_max = 4
	mob_min = 1
	probability = 0
	home_base = /datum/lazy_template/ert/weyland_station

	var/max_synths = 1
	var/synths = 0

	var/will_spawn_icc_liaison
	var/icc_liaison

	var/will_spawn_cmb_observer
	var/cmb_observer

/datum/emergency_call/inspection_cmb/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], this is Anchorpoint Station with the Colonial Marshal Bureau. Be advised, a CMB transport vessel is preparing to board you, submitting Federal docking clearances now. Standby."
	objectives = "Get your instructions from the CMB Office at Anchorpoint Station, and carry out your orders. Ensure that Colonial assets are safe and in your custody. Do not enforce or override Marine Law on a Marine Ship unless requested, as it's outside of your juristiction."

	will_spawn_icc_liaison = prob(90)
	will_spawn_cmb_observer = prob(10)

/datum/emergency_call/inspection_cmb/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob?.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are the Colonial Marshal!"))
		arm_equipment(mob, /datum/equipment_preset/cmb/leader, TRUE, TRUE)
	else if(synths < max_synths && HAS_FLAG(mob?.client.prefs.toggles_ert, PLAY_SYNTH) && mob.client.check_whitelist_status(WHITELIST_SYNTHETIC))
		synths++
		to_chat(mob, SPAN_ROLE_HEADER("You are a CMB Investigative Synthetic!"))
		arm_equipment(mob, /datum/equipment_preset/cmb/synth, TRUE, TRUE)
	else if(!icc_liaison && will_spawn_icc_liaison && check_timelock(mob.client, JOB_CORPORATE_LIAISON, time_required_for_job))
		icc_liaison = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are a CMB-attached Interstellar Commerce Commission Liaison!"))
		arm_equipment(mob, /datum/equipment_preset/cmb/liaison, TRUE, TRUE)
	else if(!cmb_observer && will_spawn_cmb_observer)
		cmb_observer = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are an Interstellar Human Rights Observer!"))
		arm_equipment(mob, /datum/equipment_preset/cmb/observer, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a CMB Deputy!"))
		arm_equipment(mob, /datum/equipment_preset/cmb/standard, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)


/datum/emergency_call/inspection_cmb/print_backstory(mob/living/carbon/human/M)
	if(M == leader)
		to_chat(M, SPAN_BOLD("You are the Colonial Marshal, originally from [pick(70;"The United Americas", 20;"Sol", 10;"a colony on the frontier")]."))
		to_chat(M, SPAN_BOLD("You started in the Marshals through [pick(50; "pursuing a career during college", 40;"working for law enforcement", 10;"being recruited for your skills")]."))
		to_chat(M, SPAN_BOLD("Rising through positions across the galaxy, you have become renown for your steadfast commitment to justice, fighting against crime and corruption alike."))
		to_chat(M, SPAN_BOLD("You have interstellar jurisdiction as a CMB Official to enforce Colonial and Earth law, but you cannot and should not override Marine Law on a Marine Ship."))
		to_chat(M, SPAN_BOLD("The laws of Earth stretch beyond the Sol. Where others are tempted and fall to corruption, you stay steadfast in your morals."))
		to_chat(M, SPAN_BOLD("Corporate Officers chase after paychecks and promotions, but you are motivated to do your sworn duty and care for the population, no matter how far or isolated a colony may be."))
		to_chat(M, SPAN_BOLD("You've seen a lot during your time in the Neroid Sector, but you're here because you're the best, doing the right thing to make the frontier a better place."))
		to_chat(M, SPAN_BOLD("Despite being stretched thin, the stalwart oath of the Marshals has continued to keep communities safe, with the CMB well respected by many. You are the representation of that oath, serve with distinction."))
	else if(issynth(M))
		to_chat(M, SPAN_BOLD("Despite being an older model, you are well regarded among your peers for your keen senses and alertness."))
		to_chat(M, SPAN_BOLD("In addition to law enforcement procedures, you are programmed to be an absolute expert in locating evidence, analyzing chemicals and investigating crimes."))
		to_chat(M, SPAN_BOLD("You do not enforce or comply with Marine Law, however you have an understanding of it."))
		to_chat(M, SPAN_BOLD("After receiving a software and law update in Sol, you were stationed at Anchorpoint Station to assist with CMB units on the frontier."))
		to_chat(M, SPAN_BOLD("Although combat is not expected, you are carrying light munition and equipment reserves of the team in your backpack, should they be needed."))
		to_chat(M, SPAN_BOLD("Despite being stretched thin, the stalwart oath of the Marshals has continued to keep communities safe, with the CMB well respected by many. You are a representation of that oath, serve with distinction."))
	else if(M == icc_liaison)
		to_chat(M, SPAN_BOLD("You are an Interstellar Commerce Liaison, originally from [pick(70;"The United Americas", 25;"Sol", 5;"a colony on the frontier")]."))
		to_chat(M, SPAN_BOLD("You are [pick(30; "skeptical", 40;"ambicable", 30;"supportive")] of Weyland-Yutani."))
		to_chat(M, SPAN_BOLD("Your headset is equipped with several frequencies, including a gifted key from The ICC's parent company, Weyland-Yutani, to try to incentivize your support. Use it for communication."))
		to_chat(M, SPAN_BOLD("As the ICC Agent attached to the CMB Office at Anchorpoint Station, your job is to observe and ensure fair trade practices. Inspect and document cargo shipments for suspected illict activity as needed. You should coordinate with the Marshals, and command(preferably for a warrant) in order to make arrests if necessary."))
		to_chat(M, SPAN_BOLD("Serving alongside such reputable men has made you a more virtuous person, especially compared to the Corporate Liaisons of other heavy-weight organizations."))
		to_chat(M, SPAN_BOLD("Work with the Colonial Marshals in their investigations and report to command if you suspect smuggling or illicit trade is happening."))
	else if(M == cmb_observer)
		to_chat(M, SPAN_BOLD("You are an Interstellar Human Rights Observer, originally from [pick(50;"The United Americas", 10;"Europe", 10;"Luna", 20;"Sol", 10;"a colony on the frontier")]."))
		to_chat(M, SPAN_BOLD("You are [pick(60; "skeptical", 40;"ambicable", 10;"supportive")] of Weyland-Yutani and their practices."))
		to_chat(M, SPAN_BOLD("You are [pick(40; "skeptical", 30;"ambicable", 30;"supportive")] with the USCM's actions on the frontier."))
		to_chat(M, SPAN_BOLD("Through a lot of hard work, your organization managed to convince the Colonial Marshals to take you to the frontier for an article about the quality of life there."))
		to_chat(M, SPAN_BOLD("Observe the Feds in their adventures and keep an eye out for any inhumane acts from others. The Neroid Sector is full of atrocities on every side."))
		to_chat(M, SPAN_BOLD("Do not instigate or start any confrontations. You are an observer, and you do not wage wars. Only intervene in medical emergencies."))
	else
		to_chat(M, SPAN_BOLD("You are a CMB Deputy, originally from [pick(70;"The United Americas", 20;"Sol", 10;"a colony on the frontier")]."))
		to_chat(M, SPAN_BOLD("You joined the Marshals through [pick(50; "pursuing a career during college", 40;"working for law enforcement", 10;"being recruited for your skills")]."))
		to_chat(M, SPAN_BOLD("Following the lead of your Marshal, you have become renown for your steadfast commitment to justice, fighting against crime and corruption alike."))
		to_chat(M, SPAN_BOLD("You have interstellar jurisdiction as a CMB Official to enforce Colonial and Earth law, but you cannot and should not override Marine Law on a Marine Ship."))
		to_chat(M, SPAN_BOLD("You have been stationed at Anchorpoint Station for [pick(80;"several months", 10;"only a week", 10;"years")] investigating henious crimes among the frontier."))
		to_chat(M, SPAN_BOLD("The laws of arth stretch beyond the Sol. Where others fall to corruption, you stay steadfast in your morals."))
		to_chat(M, SPAN_BOLD("Corporate Officers chase after paychecks and promotions, but you are motivated to do your sworn duty and care for the population, no matter how far or isolated a colony may be."))
		to_chat(M, SPAN_BOLD("Despite being stretched thin, the stalwart oath of the Marshals has continued to keep communities safe, with the CMB well respected by many. You are a representation of that oath, serve with distinction."))

/datum/emergency_call/inspection_cmb/black_market
	name = "Inspection - Colonial Marshals Ledger Investigation Team"
	mob_max = 3 //Marshal, Deputy, ICC CL
	mob_min = 2
	shuttle_id = MOBILE_SHUTTLE_ID_ERT2

	max_synths = 0
	will_spawn_icc_liaison = TRUE
	will_spawn_cmb_observer = FALSE

/datum/emergency_call/inspection_cmb/black_market/New()
	..()
	dispatch_message = "Third Fleet High Command to [MAIN_SHIP_NAME], we have received inconsistent supply manifests and irregularities on the ASRS system aboard your ship, and have requested a CMB Investigation Team to board and clear you of any wrongdoing."
	arrival_message = "Incoming Transmission: [MAIN_SHIP_NAME], this is Anchorpoint Station with the Colonial Marshal Bureau. Be advised, we are dispatching a team of Marshals to board with you by request of GSO-91. Submitting authorized docking clearances, over."
	objectives = "Investigate the inconsistencies aboard the [MAIN_SHIP_NAME]'s ASRS. In the case of illegal activity, collect evidence, and submit a report to the CMB Command at Anchorpoint Station. If required, the ICC Liaison's Tradeband is capable of fixing ASRS computers. Work with the [MAIN_SHIP_NAME]'s military police force."

/datum/emergency_call/inspection_cmb/black_market/create_member(datum/mind/current_mind, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	current_mind.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob?.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are the Colonial Marshal!"))
		arm_equipment(mob, /datum/equipment_preset/cmb/leader, TRUE, TRUE)
	else if(!icc_liaison && will_spawn_icc_liaison && check_timelock(mob.client, JOB_CORPORATE_LIAISON, time_required_for_job))
		icc_liaison = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are a CMB-attached Interstellar Commerce Commission Liaison!"))
		arm_equipment(mob, /datum/equipment_preset/cmb/liaison/black_market, TRUE, TRUE) //ICC CL gets a custom item
	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a CMB Deputy!"))
		arm_equipment(mob, /datum/equipment_preset/cmb/standard, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)
