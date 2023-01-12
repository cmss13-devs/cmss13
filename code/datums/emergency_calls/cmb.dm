// The Colonial Marshal Bureau, a UA Federal investigative/law enforcement functionary from Sol which oversees many colonies among the frontier. They are friendly to USCM.
/datum/emergency_call/CMB
	name = "Colonial Marshals (Squad) (Friendly)"
	mob_max = 5
	probability = 9

	var/max_synths = 1
	var/synths = 0

	var/will_spawn_icc_liaison
	var/icc_liaison

	var/will_spawn_cmb_observer
	var/cmb_observer


/datum/emergency_call/CMB/New()
	..()
	arrival_message = "Incoming Transmission: [MAIN_SHIP_NAME], This is Anchorpoint Station with the Colonial Marshal Bureau. We are receiving your distress signal and are dispatching a nearby team to board with you now. Standby."
	objectives = "Investigate the distress signal aboard the [MAIN_SHIP_NAME], and assist the crew with rescue if possible. If necessary, a contingent of Colonial Marines is ready to act as a QRF to reinforce you."

	will_spawn_icc_liaison = prob(50)
	will_spawn_cmb_observer = prob(20)

/datum/emergency_call/CMB/create_member(datum/mind/M, var/turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are the Colonial Marshal!"))
		arm_equipment(mob, /datum/equipment_preset/CMB/leader, TRUE, TRUE)
	else if(synths < max_synths && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_SYNTH) && RoleAuthority.roles_whitelist[mob.ckey] & WHITELIST_SYNTHETIC)
		synths++
		to_chat(mob, SPAN_ROLE_HEADER("You are a CMB Investigative Synthetic!"))
		arm_equipment(mob, /datum/equipment_preset/CMB/synth, TRUE, TRUE)
	else if(!icc_liaison && will_spawn_icc_liaison && check_timelock(mob.client, JOB_CORPORATE_LIAISON, time_required_for_job))
		icc_liaison = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are a CMB-attached Interstellar Commerce Commission Liaison!"))
		arm_equipment(mob, /datum/equipment_preset/CMB/liaison, TRUE, TRUE)
	else if(!cmb_observer && will_spawn_cmb_observer)
		cmb_observer = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are an Interstellar Human Rights Observer!"))
		arm_equipment(mob, /datum/equipment_preset/CMB/observer, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a CMB Deputy!"))
		arm_equipment(mob, /datum/equipment_preset/CMB/standard, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)


/datum/emergency_call/CMB/print_backstory(mob/living/carbon/human/M)
	if(M == leader)
		to_chat(M, SPAN_BOLD("You are the Colonial Marshal, originally from [pick(70;"The United Americas", 20;"Sol", 10;"a colony on the frontier")]."))
		to_chat(M, SPAN_BOLD("You started in the Marshals through [pick(50; "pursuing a career during college", 40;"working for law enforcement", 10;"being recruited for your skills")]."))
		to_chat(M, SPAN_BOLD("Rising through positions across the galaxy, you have become renown for your steadfast commitment to justice, fighting against crime and corruption alike."))
		to_chat(M, SPAN_BOLD("Enroute to a [pick(20; "homicide", 20;"corporate corruption investigation", 10; "hostage situation", 10;"terrorist attack", 10;"prisoner transfer", 10;"drug raid", 10;"barricaded fugitive situation", 5;"suspected smuggling incident", 5;"human trafficing situation" )] you were diverted by your command at Anchorpoint Station to the [MAIN_SHIP_NAME] because of a distress beacon."))
		to_chat(M, SPAN_BOLD("The laws of Earth stretch beyond the Sol. Where others are tempted and fall to corruption, you stay steadfast in your morals."))
		to_chat(M, SPAN_BOLD("Corporate Officers chase after paychecks and promotions, but you are motivated to do your sworn duty and care for the population, no matter how far or isolated a colony may be."))
		to_chat(M, SPAN_BOLD("You've seen a lot during your time in the Neroid Sector, but you're here because you're the best, doing the right thing to make the frontier a better place."))
		to_chat(M, SPAN_BOLD("Despite being stretched thin, the stalwart oath of the Marshals has continued to keep communities safe, with the CMB well respected by many. You are the representation of that oath, serve with distinction."))
	else if(isSynth(M))
		to_chat(M, SPAN_BOLD("Despite being an older model, you are well regarded among your peers for your keen senses and alertness."))
		to_chat(M, SPAN_BOLD("In addition to law enforcement procedures, you are programmed to be an absolute expert in locating evidence, analyzing chemicals and investigating crimes."))
		to_chat(M, SPAN_BOLD("You do not enforce or comply with Marine Law, however you have an understanding of it."))
		to_chat(M, SPAN_BOLD("After receiving a software and law update in Sol, you were stationed at Anchorpoint Station to assist with CMB units on the frontier."))
		to_chat(M, SPAN_BOLD("While enroute to an investigation you were diverted by your command to the [MAIN_SHIP_NAME] because of a distress beacon."))
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

