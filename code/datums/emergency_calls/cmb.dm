// The Colonial Marshal Bureau, a UA Federal investigative/law enforcement functionary from Sol which oversees many colonies among the frontier. They are friendly to USCM.
/datum/emergency_call/cmb
	name = "CMB - Colonial Marshals Patrol Team (Friendly)"
	mob_max = 5
	probability = 10
	home_base = /datum/lazy_template/ert/weyland_station

	var/max_synths = 1
	var/synths = 0

	var/will_spawn_icc_liaison
	var/icc_liaison

	var/will_spawn_cmb_observer
	var/cmb_observer


/datum/emergency_call/cmb/New()
	..()
	arrival_message = "Incoming Transmission: [MAIN_SHIP_NAME], this is Anchorpoint Station with the Colonial Marshal Bureau. We are receiving your distress signal and are dispatching a nearby team to board with you now. Standby."
	objectives = "Investigate the distress signal aboard the [MAIN_SHIP_NAME], and assist the crew with rescue if possible. If necessary, a contingent of our Colonial Marines may be ready to act as a QRF to reinforce you."

	will_spawn_icc_liaison = prob(50)
	will_spawn_cmb_observer = prob(20)

/datum/emergency_call/cmb/create_member(datum/mind/M, turf/override_spawn_loc)
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


/datum/emergency_call/cmb/print_backstory(mob/living/carbon/human/M)
	if(M == leader)
		to_chat(M, SPAN_BOLD("You are the Colonial Marshal, originally from [pick(70;"The United Americas", 20;"Sol", 10;"a colony on the frontier")]."))
		to_chat(M, SPAN_BOLD("You started in the Marshals through [pick(50; "pursuing a career during college", 40;"working for law enforcement", 10;"being recruited for your skills")]."))
		to_chat(M, SPAN_BOLD("Rising through positions across the galaxy, you have become renown for your steadfast commitment to justice, fighting against crime and corruption alike."))
		to_chat(M, SPAN_BOLD("Enroute to a [pick(20; "homicide", 20;"corporate corruption investigation", 10; "hostage situation", 10;"terrorist attack", 10;"prisoner transfer", 10;"drug raid", 10;"barricaded fugitive situation", 5;"suspected smuggling incident", 5;"human trafficking situation" )] you were diverted by your command at Anchorpoint Station to the [MAIN_SHIP_NAME] because of a distress beacon."))
		to_chat(M, SPAN_BOLD("The laws of Earth stretch beyond the Sol. Where others are tempted and fall to corruption, you stay steadfast in your morals."))
		to_chat(M, SPAN_BOLD("Corporate Officers chase after paychecks and promotions, but you are motivated to do your sworn duty and care for the population, no matter how far or isolated a colony may be."))
		to_chat(M, SPAN_BOLD("You've seen a lot during your time in the Neroid Sector, but you're here because you're the best, doing the right thing to make the frontier a better place."))
		to_chat(M, SPAN_BOLD("Despite being stretched thin, the stalwart oath of the Marshals has continued to keep communities safe, with the CMB well respected by many. You are the representation of that oath, serve with distinction."))
	else if(issynth(M))
		to_chat(M, SPAN_BOLD("Despite being an older model, you are well regarded among your peers for your keen senses and alertness."))
		to_chat(M, SPAN_BOLD("In addition to law enforcement procedures, you are programmed to be an absolute expert in locating evidence, analyzing chemicals and investigating crimes."))
		to_chat(M, SPAN_BOLD("You do not enforce or comply with Marine Law, however you have an understanding of it."))
		to_chat(M, SPAN_BOLD("After receiving a software and law update in Sol, you were stationed at Anchorpoint Station to assist with CMB units on the frontier."))
		to_chat(M, SPAN_BOLD("While enroute to an investigation you were diverted by your command to the [MAIN_SHIP_NAME] because of a distress beacon."))
		to_chat(M, SPAN_BOLD("Should it be required, you are currently carrying the light munition and equipment reserves in your backpack to be given to your team."))
		to_chat(M, SPAN_BOLD("Despite being stretched thin, the stalwart oath of the Marshals has continued to keep communities safe, with the CMB well respected by many. You are a representation of that oath, serve with distinction."))
	else if(M == icc_liaison)
		to_chat(M, SPAN_BOLD("You are an Interstellar Commerce Liaison, originally from [pick(70;"The United Americas", 25;"Sol", 5;"a colony on the frontier")]."))
		to_chat(M, SPAN_BOLD("You are [pick(30; "skeptical", 40;"ambicable", 30;"supportive")] of Weyland-Yutani."))
		to_chat(M, SPAN_BOLD("Your headset is equipped with several frequencies, including a gifted key from The ICC's parent company, Weyland-Yutani, to try to incentivize your support. Use it for communication."))
		to_chat(M, SPAN_BOLD("As the ICC Agent attached to the CMB Office at Anchorpoint Station, your job is to observe and ensure fair trade practices."))
		to_chat(M, SPAN_BOLD("Serving alongside such reputable men has made you a more virtuous person, especially compared to the Corporate Liaisons of other heavy-weight organizations."))
		to_chat(M, SPAN_BOLD("Work with the Colonial Marshals in their investigations and report to command if you suspect smuggling or illicit trade is happening."))
		to_chat(M, SPAN_BOLD("You were on your way to a crime scene when your ship was diverted to the [MAIN_SHIP_NAME] because of a distress beacon."))
	else if(M == cmb_observer)
		to_chat(M, SPAN_BOLD("You are an Interstellar Human Rights Observer, originally from [pick(50;"The United Americas", 10;"Europe", 10;"Luna", 20;"Sol", 10;"a colony on the frontier")]."))
		to_chat(M, SPAN_BOLD("You are [pick(60; "skeptical", 40;"ambicable", 10;"supportive")] of Weyland-Yutani and their practices."))
		to_chat(M, SPAN_BOLD("You are [pick(40; "skeptical", 30;"ambicable", 30;"supportive")] of the USCM's actions on the frontier."))
		to_chat(M, SPAN_BOLD("Through a lot of hard work, your organization managed to convince the Colonial Marshals to take you to the frontier for an article about the quality of life there."))
		to_chat(M, SPAN_BOLD("Observe the Feds in their adventures and keep an eye out for any inhumane acts from others. The Neroid Sector is full of atrocities on every side."))
		to_chat(M, SPAN_BOLD("Do not instigate or start any confrontations. You are an observer, and you do not wage wars. Only intervene in medical emergencies."))
		to_chat(M, SPAN_BOLD("You were on your way to a crime scene when your ship was diverted to the [MAIN_SHIP_NAME] because of a distress beacon."))
	else
		to_chat(M, SPAN_BOLD("You are a CMB Deputy, originally from [pick(70;"The United Americas", 20;"Sol", 10;"a colony on the frontier")]."))
		to_chat(M, SPAN_BOLD("You joined the Marshals through [pick(50; "pursuing a career during college", 40;"working for law enforcement", 10;"being recruited for your skills")]."))
		to_chat(M, SPAN_BOLD("Following the lead of your Marshal, you have become renown for your steadfast commitment to justice, fighting against crime and corruption alike."))
		to_chat(M, SPAN_BOLD("While enroute to an investigation you were diverted by your command at Anchorpoint Station to the [MAIN_SHIP_NAME] because of a distress beacon."))
		to_chat(M, SPAN_BOLD("You have been stationed at Anchorpoint Station for [pick(80;"several months", 10;"only a week", 10;"years")] investigating henious crimes among the frontier."))
		to_chat(M, SPAN_BOLD("The laws of arth stretch beyond the Sol. Where others fall to corruption, you stay steadfast in your morals."))
		to_chat(M, SPAN_BOLD("Corporate Officers chase after paychecks and promotions, but you are motivated to do your sworn duty and care for the population, no matter how far or isolated a colony may be."))
		to_chat(M, SPAN_BOLD("Despite being stretched thin, the stalwart oath of the Marshals has continued to keep communities safe, with the CMB well respected by many. You are a representation of that oath, serve with distinction."))


// A Nearby Colonial Marshal patrol team responding to Marshals in Distress.
/datum/emergency_call/cmb/alt
	name = "CMB - Patrol Team - Marshals in Distress (Friendly)"
	mob_max = 5
	mob_min = 1
	probability = 0

/datum/emergency_call/cmb/alt/New()
	..()
	arrival_message = "CMB Team, this is Anchorpoint Station. We have confirmed you are in distress. Routing nearby units to assist!"
	objectives = "Patrol Unit 5807, we have nearby Marshals in Distress! Locate and assist them immediately."

// Anchorpoint Station Colonial Marines, use this primarily for reinforcing or evacuating the CMB, as the CMB themselves are not equipped to handle heavy engagements.
/datum/emergency_call/cmb/anchorpoint
	name = "CMB - Anchorpoint Station Colonial Marine QRF (Friendly)"
	mob_max = 6
	mob_min = 3
	max_medics = 1
	max_engineers = 1
	max_smartgunners = 1
	probability = 0

/datum/emergency_call/cmb/anchorpoint/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], this is Anchorpoint Station. Be advised, a QRF Team of our Colonial Marines is currently attempting to board you. Open your ports, transmitting docking codes now. Standby."
	objectives = "QRF Team. You are here to reinforce the CMB team we deployed earlier. Make contact and work with the CMB Marshal and their deputies. Facilitate their protection and evacuation if necessary. Secondary Objective: Investigate the reason for distress aboard the [MAIN_SHIP_NAME], and assist the crew if possible."

/datum/emergency_call/cmb/anchorpoint/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob?.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are the Marine Fireteam Leader of Anchorpoint Station!"))
		arm_equipment(mob, /datum/equipment_preset/uscm/cmb/leader, TRUE, TRUE) // placeholder
	else if(smartgunners < max_smartgunners && HAS_FLAG(mob?.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(mob.client, JOB_SQUAD_SMARTGUN, time_required_for_job))
		smartgunners++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Smartgunner of Anchorpoint Station!"))
		arm_equipment(mob, /datum/equipment_preset/uscm/cmb/smartgunner, TRUE, TRUE)
	else if (medics < max_medics && HAS_FLAG(mob?.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Marine Corpsman of Anchorpoint Station!"))
		arm_equipment(mob, /datum/equipment_preset/uscm/cmb/medic, TRUE, TRUE)
	else if(engineers < max_engineers && HAS_FLAG(mob?.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(mob.client, JOB_SQUAD_ENGI, time_required_for_job))
		engineers++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Technical Specialist of Anchorpoint Station!"))
		arm_equipment(mob, /datum/equipment_preset/uscm/cmb/rto, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a Marine Rifleman of Anchorpoint Station!"))
		arm_equipment(mob, /datum/equipment_preset/uscm/cmb, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)


/datum/emergency_call/cmb/anchorpoint/print_backstory(mob/living/carbon/human/M)
	if(M == leader)
		to_chat(M, SPAN_BOLD("You are the Anchorpoint QRF Fireteam Leader, originally from [pick(70;"The United Americas", 20;"Sol", 10;"a colony on the frontier")]."))
		to_chat(M, SPAN_BOLD("You've served on The Station for [pick(50; "a Sol year, and a tour of duty", 40;"a couple months", 10;"six years, three tours")]."))
		to_chat(M, SPAN_BOLD("Living, training and working alongside Colonial Marshals at Anchorpoint Station has kept you well disciplined, and you've always felt proud to be the cavalry."))
		to_chat(M, SPAN_BOLD("During your time at Anchorpoint, you [pick(20; "had your life saved by a Colonial Marshal", 20;"quelled a corporate riot", 10; "defended the station against a UPP incursion", 10;"experienced a pathogenic outbreak", 10;"assisted the Colonial Marshals during an enacted martial law", 10;"were deployed to the [MAIN_SHIP_NAME], and understand its layout", 10;"assisted the Colonial Marshals with barricaded fugitive situation", 5;"helped the ICC take down a suspected smuggling ring", 5;"helped take down a human trafficking scheme alongside the Colonial Marshals" )]."))
		to_chat(M, SPAN_BOLD("Working on conjunction with the Colonial Marshals on many incidents has created a comradery between your organizations. The Marshals handle investigations and policing, while you come in to get the job done during riots or incursions. Any job where heavy lifting was required, you were there."))
		to_chat(M, SPAN_BOLD("You were activated as a part of a Quick Reaction Force to reinforce Colonial Marshals in distress."))
		to_chat(M, SPAN_BOLD("You weren't sure if it was a false alarm or not. Turns out it isn't..."))
		to_chat(M, SPAN_BOLD("Now it looks like the time to be the cavalry is once more upon you. Brief your men, move 'em out!"))
	else if(M == smartgunners)
		to_chat(M, SPAN_BOLD("You are the Anchorpoint QRF Team Smartgunner, originally from [pick(70;"The United Americas", 20;"Sol", 10;"a colony on the frontier")]."))
		to_chat(M, SPAN_BOLD("You've served on The Station for [pick(45; "a Sol year, and a tour of duty", 20;"a couple months", 5;"six long years, three consecutive tours")]."))
		to_chat(M, SPAN_BOLD("Living, training and working alongside Colonial Marshals at Anchorpoint Station has kept you well disciplined, and you've always felt proud to be the cavalry."))
		to_chat(M, SPAN_BOLD("During your time at Anchorpoint, you [pick(20; "had your life saved by a Colonial Marshal", 20;"quelled a corporate riot", 10; "defended the station against a UPP incursion", 10;"experienced a pathogenic outbreak", 10;"assisted the Colonial Marshals during an enacted martial law", 10;"were deployed to the [MAIN_SHIP_NAME], and understand its layout", 10;"assisted the Colonial Marshals with barricaded fugitive situation", 5;"helped the ICC take down a suspected smuggling ring", 5;"helped take down a human trafficking scheme alongside the Colonial Marshals" )]."))
		to_chat(M, SPAN_BOLD("Working on conjunction with the Colonial Marshals on many incidents has created a comradery between your organizations. The Marshals handle investigations and policing, while you come in to get the job done during riots or incursions. Any job where heavy lifting was required, you were there."))
		to_chat(M, SPAN_BOLD("You were activated as a part of a Quick Reaction Force to reinforce Colonial Marshals in distress."))
		to_chat(M, SPAN_BOLD("You weren't sure if it was a false alarm or not. Turns out it isn't... But you've been waiting for an excuse to let loose that M56."))
		to_chat(M, SPAN_BOLD("Now it looks like the time to be the cavalry is once more upon you. Let's rock!"))
	else if(M == medics)
		to_chat(M, SPAN_BOLD("You are the Anchorpoint QRF Team Corpsman, originally from [pick(70;"The United Americas", 20;"Sol", 10;"a colony on the frontier")]."))
		to_chat(M, SPAN_BOLD("You've served on The Station for [pick(45; "a Sol year, and a tour of duty", 20;"a couple months", 5;"six long years, three consecutive tours")]."))
		to_chat(M, SPAN_BOLD("Living, training and working alongside Colonial Marshals at Anchorpoint Station has kept you well disciplined, and you've always felt proud to be the cavalry."))
		to_chat(M, SPAN_BOLD("During your time at Anchorpoint, you [pick(20; "had your life saved by a Colonial Marshal", 20;"quelled a corporate riot", 10; "defended the station against a UPP incursion", 10;"experienced a pathogenic outbreak", 10;"assisted the Colonial Marshals during an enacted martial law", 10;"were deployed to the [MAIN_SHIP_NAME], and understand its layout", 10;"assisted the Colonial Marshals with barricaded fugitive situation", 5;"helped the ICC take down a suspected smuggling ring", 5;"helped take down a human trafficking scheme alongside the Colonial Marshals" )]."))
		to_chat(M, SPAN_BOLD("Working on conjunction with the Colonial Marshals on many incidents has created a comradery between your organizations. The Marshals handle investigations and policing, while you come in to get the job done during riots or incursions. Any job where heavy lifting was required, you were there."))
		to_chat(M, SPAN_BOLD("You were activated as a part of a Quick Reaction Force to reinforce Colonial Marshals in distress."))
		to_chat(M, SPAN_BOLD("You weren't sure if it was a false alarm or not. Turns out it isn't..."))
		to_chat(M, SPAN_BOLD("Now it looks like the time to be the cavalry is once more upon you."))
	else if(M == engineers)
		to_chat(M, SPAN_BOLD("You are the Anchorpoint QRF Team Technical Specialist, originally from [pick(70;"The United Americas", 20;"Sol", 10;"a colony on the frontier")]."))
		to_chat(M, SPAN_BOLD("You've served on The Station for [pick(45; "a Sol year, and a tour of duty", 20;"a couple months", 5;"six long years, three consecutive tours")]."))
		to_chat(M, SPAN_BOLD("Living, training and working alongside Colonial Marshals at Anchorpoint Station has kept you well disciplined, and you've always felt proud to be the cavalry."))
		to_chat(M, SPAN_BOLD("During your time at Anchorpoint, you [pick(20; "had your life saved by a Colonial Marshal", 20;"quelled a corporate riot", 10; "defended the station against a UPP incursion", 10;"experienced a pathogenic outbreak", 10;"assisted the Colonial Marshals during an enacted martial law", 10;"were deployed to the [MAIN_SHIP_NAME], and understand its layout", 10;"assisted the Colonial Marshals with barricaded fugitive situation", 5;"helped the ICC take down a suspected smuggling ring", 5;"helped take down a human trafficking scheme alongside the Colonial Marshals" )]."))
		to_chat(M, SPAN_BOLD("Working on conjunction with the Colonial Marshals on many incidents has created a comradery between your organizations. The Marshals handle investigations and policing, while you come in to get the job done during riots or incursions. Any job where heavy lifting was required, you were there."))
		to_chat(M, SPAN_BOLD("You were activated as a part of a Quick Reaction Force to reinforce Colonial Marshals in distress."))
		to_chat(M, SPAN_BOLD("You weren't sure if it was a false alarm or not. Turns out it isn't..."))
		to_chat(M, SPAN_BOLD("Now it looks like the time to be the cavalry is once more upon you. Signal's clean."))
	else
		to_chat(M, SPAN_BOLD("You are a Rifleman of the Anchorpoint Team QRF, originally from [pick(70;"The United Americas", 20;"Sol", 10;"a colony on the frontier")]."))
		to_chat(M, SPAN_BOLD("You've served on The Station for [pick(45; "a Sol year, and a tour of duty", 20;"a couple months", 5;"six long years, three consecutive tours")]."))
		to_chat(M, SPAN_BOLD("Living, training and working alongside Colonial Marshals at Anchorpoint Station has kept you well disciplined, and you've always felt proud to be the cavalry."))
		to_chat(M, SPAN_BOLD("During your time at Anchorpoint, you [pick(20; "had your life saved by a Colonial Marshal", 20;"quelled a corporate riot", 10; "defended the station against a UPP incursion", 10;"experienced a pathogenic outbreak", 10;"assisted the Colonial Marshals during an enacted martial law", 10;"were deployed to the [MAIN_SHIP_NAME], and understand its layout", 10;"assisted the Colonial Marshals with barricaded fugitive situation", 5;"helped the ICC take down a suspected smuggling ring", 5;"helped take down a human trafficking scheme alongside the Colonial Marshals" )]."))
		to_chat(M, SPAN_BOLD("Working on conjunction with the Colonial Marshals on many incidents has created a comradery between your organizations. The Marshals handle investigations and policing, while you come in to get the job done during riots or incursions. Any job where heavy lifting was required, you were there."))
		to_chat(M, SPAN_BOLD("You were activated as a part of a Quick Reaction Force to reinforce Colonial Marshals in distress."))
		to_chat(M, SPAN_BOLD("You weren't sure if it was a false alarm or not. Turns out it isn't..."))
		to_chat(M, SPAN_BOLD("Now it looks like the time to be the cavalry is once more upon you."))
