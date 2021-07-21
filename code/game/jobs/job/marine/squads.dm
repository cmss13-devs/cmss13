//This datum keeps track of individual squads. New squads can be added without any problem but to give them
//access you must add them individually to access.dm with the other squads. Just look for "access_alpha" and add the new one

//Note: some important procs are held by the job controller, in job_controller.dm.
//In particular, get_lowest_squad() and randomize_squad()

/datum/squad
	var/name = "Empty Squad"  //Name of the squad
	var/tracking_id = null	//Used for the tracking subsystem
	var/max_positions = -1 //Maximum number allowed in a squad. Defaults to infinite
	var/color = 0 //Color for helmets, etc.
	var/list/access = list() //Which special access do we grant them
	var/usable = 0	 //Is it a valid squad?
	var/no_random_spawn = 0 //Stop players from spawning into the squad
	var/max_engineers = 3 //maximum # of engineers allowed in squad
	var/max_medics = 4 //Ditto, squad medics
	var/max_specialists = 1
	var/num_specialists = 0
	var/max_rto = 2
	var/num_rto = 0
	var/max_smartgun = 1
	var/num_smartgun = 0
	var/max_leaders = 1
	var/num_leaders = 0
	var/radio_freq = 1461 //Squad radio headset frequency.
	//vvv Do not set these in squad defines
	var/mob/living/carbon/human/squad_leader = null //Who currently leads it.
	var/list/fireteam_leaders = list(
									"FT1" = null,
									"FT2" = null,
									"FT3" = null
									)	//FT leaders stored here
	var/list/list/fireteams = list(
							"FT1" = list(),
							"FT2" = list(),
							"FT3" = list()
							)			//3 FTs where references to marines stored.
	var/list/squad_info_data = list()
	var/list/squad_info_uis = list()		//list of opened UIs

	var/num_engineers = 0
	var/num_medics = 0
	var/count = 0	//Current # in the squad
	var/list/marines_list = list()	// list of mobs (or name, not always a mob ref) in that squad.

	var/mob/living/carbon/human/overwatch_officer = null	//Who's overwatching this squad?
	var/supply_cooldown = 0	//Cooldown for supply drops
	var/primary_objective = null	//Text strings
	var/secondary_objective = null
	var/obj/item/device/squad_beacon/sbeacon = null
	var/obj/item/device/squad_beacon/bomb/bbeacon = null
	var/obj/structure/supply_drop/drop_pad = null

/datum/squad/alpha
	name = SQUAD_NAME_1
	color = 1
	access = list(ACCESS_MARINE_ALPHA)
	usable = 1
	radio_freq = ALPHA_FREQ

/datum/squad/bravo
	name = SQUAD_NAME_2
	color = 2
	access = list(ACCESS_MARINE_BRAVO)
	usable = 1
	radio_freq = BRAVO_FREQ

/datum/squad/charlie
	name = SQUAD_NAME_3
	color = 3
	access = list(ACCESS_MARINE_CHARLIE)
	usable = 1
	radio_freq = CHARLIE_FREQ

/datum/squad/delta
	name = SQUAD_NAME_4
	color = 4
	access = list(ACCESS_MARINE_DELTA)
	usable = 1
	radio_freq = DELTA_FREQ

/datum/squad/echo
	name = SQUAD_NAME_5
	color = 5
	access = list(ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)
	usable = 0	//Normally not usable
	radio_freq = ECHO_FREQ

/datum/squad/New()
	. = ..()

	tracking_id = SStracking.setup_trackers()
	SStracking.setup_trackers(null, "FT1")
	SStracking.setup_trackers(null, "FT2")
	SStracking.setup_trackers(null, "FT3")
	update_all_squad_info()

	RegisterSignal(SSdcs, COMSIG_GLOB_MODE_POSTSETUP, .proc/setup_supply_drop_list)

/datum/squad/proc/setup_supply_drop_list()
	SIGNAL_HANDLER

	for(var/i in GLOB.supply_drop_list)
		var/obj/structure/supply_drop/S = i
		if(name == S.squad)
			drop_pad = S
			break

/// Sets an overwatch officer for the squad, returning TRUE on success
/datum/squad/proc/assume_overwatch(mob/M)
	var/mob/previous
	if(overwatch_officer)
		if(overwatch_officer == M)
			return FALSE
		previous = overwatch_officer
		overwatch_officer = null
		clear_ref_tracking(previous)
	overwatch_officer = M
	RegisterSignal(overwatch_officer, COMSIG_PARENT_QDELETING, .proc/personnel_deleted, override = TRUE)
	return TRUE

/// Explicitely relinquish overwatch control
/datum/squad/proc/release_overwatch()
	if(!overwatch_officer)
		return FALSE
	var/mob/operator = overwatch_officer
	overwatch_officer = null
	clear_ref_tracking(operator)
	return TRUE

/// Clear deletion signal as needed for mob - to call *after* removal
/datum/squad/proc/clear_ref_tracking(mob/M)
	if(!M) return FALSE
	if(M in marines_list)
		return FALSE
	if(overwatch_officer == M)
		return FALSE
	UnregisterSignal(M, COMSIG_PARENT_QDELETING)
	return TRUE

/// Clear references in squad listing upon deletion. Zap also erases the kept records.
/datum/squad/proc/personnel_deleted(mob/M, zap = FALSE)
	SIGNAL_HANDLER
	if(M == overwatch_officer)
		overwatch_officer = null
	if(M == squad_leader)
		squad_leader = null
	SStracking.stop_tracking(tracking_id, M)
	if(zap)
		marines_list.Remove(M)
		return
	var/idx = marines_list.Find(M)
	if(idx)
		marines_list[idx] = M.name // legacy behavior, replace mob ref index by name. very weird

/*
 * Send a text message to the squad members following legacy overwatch usage
 *
 * input_text: raw user input as text
 * user: mob reference to whoever the message is sent on behalf of - adds sounds notification
 * displayed_icon: /atom or /icon to display by the message in chat
 * leader_only: if truthy sends only to the squad leader
 */
/datum/squad/proc/send_squad_message(input_text, mob/user, displayed_icon, leader_only = FALSE)
	var/message = strip_html(input_text)
	var/datum/sound_template/sfx

	if(user)
		message = "[user.name] transmits: [FONT_SIZE_LARGE("<b>[message]<b>")]"
		sfx = new()
		sfx.file = 'sound/effects/radiostatic.ogg'
		sfx.channel = get_free_channel()
		sfx.y = 3
	message = "[SPAN_BLUE("<B>[leader_only ? "SL " : ""]Overwatch:</b> [message]")]"

	var/list/client/targets = list()
	if(leader_only)
		targets = list(squad_leader)
	else
		for(var/mob/M in marines_list)
			if(!M.stat && M.client)
				targets += M.client

	if(displayed_icon)
		message = "[icon2html(displayed_icon, targets, dir = null)] [message]"
	if(sfx)
		SSsound.queue(sfx, targets)
	to_chat(targets, html = message, type = MESSAGE_TYPE_RADIO)


//Straight-up insert a marine into a squad.
//This sets their ID, increments the total count, and so on. Everything else is done in job_controller.dm.
//So it does not check if the squad is too full already, or randomize it, etc.
/datum/squad/proc/put_marine_in_squad(var/mob/living/carbon/human/M, var/obj/item/card/id/ID)

	if(!istype(M))
		return 0	//Logic
	if(!src.usable)
		return 0
	if(!M.mind)
		return 0
	if(!M.job)
		return 0	//Not yet
	if(M.assigned_squad)
		return 0	//already in a squad

	var/obj/item/card/id/C = ID
	if(!C)
		C = M.wear_id
	if(!C)
		C = M.get_active_hand()
	if(!istype(C))
		return 0	//No ID found

	var/assignment = JOB_SQUAD_MARINE
	var/paygrade

	var/list/extra_access = list()

	switch(M.job)
		if(JOB_SQUAD_ENGI)
			assignment = JOB_SQUAD_ENGI
			num_engineers++
			C.claimedgear = 0
		if(JOB_SQUAD_MEDIC)
			assignment = JOB_SQUAD_MEDIC
			num_medics++
			C.claimedgear = 0
		if(JOB_SQUAD_SPECIALIST)
			assignment = JOB_SQUAD_SPECIALIST
			num_specialists++
		if(JOB_SQUAD_RTO)
			if(num_rto > 0)
				assignment = "Assistant [JOB_SQUAD_RTO]"
				paygrade = "E4"
				M.comm_title = "aRTO"
			else
				paygrade = "E5"
				assignment = JOB_SQUAD_RTO
				extra_access += ACCESS_MARINE_RTO_DROP
				M.important_radio_channels += radio_freq

			num_rto++
		if(JOB_SQUAD_SMARTGUN)
			assignment = JOB_SQUAD_SMARTGUN
			num_smartgun++
		if(JOB_SQUAD_LEADER)
			if(squad_leader && squad_leader.job != JOB_SQUAD_LEADER) //field promoted SL
				var/old_lead = squad_leader
				demote_squad_leader()	//replaced by the real one
				SStracking.start_tracking(tracking_id, old_lead)
			assignment = JOB_SQUAD_LEADER
			squad_leader = M
			SStracking.set_leader(tracking_id, M)
			SStracking.start_tracking("marine_sl", M)

			if(M.job == JOB_SQUAD_LEADER) //field promoted SL don't count as real ones
				num_leaders++

	RegisterSignal(M, COMSIG_PARENT_QDELETING, .proc/personnel_deleted, override = TRUE)
	if(assignment != JOB_SQUAD_LEADER)
		SStracking.start_tracking(tracking_id, M)

	count++		//Add up the tally. This is important in even squad distribution.

	if(M.job != "Squad Marine")
		log_admin("[key_name(M)] has been assigned as [name] [M.job]") // we don't want to spam squad marines but the others are useful

	marines_list += M
	M.assigned_squad = src	//Add them to the squad
	C.access += (src.access + extra_access)	//Add their squad access to their ID
	C.assignment = "[name] [assignment]"

	if(paygrade)
		C.paygrade = paygrade
	C.name = "[C.registered_name]'s ID Card ([C.assignment])"
	return 1

//proc used by the overwatch console to transfer marine to another squad
/datum/squad/proc/remove_marine_from_squad(mob/living/carbon/human/M)
	if(!M.mind)
		return 0
	if(M.assigned_squad != src)
		return		//not assigned to the correct squad
	var/obj/item/card/id/C
	C = M.wear_id
	if(!istype(C))
		return 0	//Abort, no ID found

	C.access -= src.access
	C.assignment = M.job
	C.name = "[C.registered_name]'s ID Card ([C.assignment])"

	forget_marine_in_squad(M)

//gracefully remove a marine from squad system, alive, dead or otherwise
/datum/squad/proc/forget_marine_in_squad(mob/living/carbon/human/M)
	if(M.assigned_squad.squad_leader == M)
		if(M.job != JOB_SQUAD_LEADER) //a field promoted SL, not a real one
			demote_squad_leader()
		else
			M.assigned_squad.squad_leader = null
		update_squad_leader()
	else
		if(M.assigned_fireteam)
			if(fireteam_leaders[M.assigned_fireteam] == M)
				unassign_ft_leader(M.assigned_fireteam, TRUE, FALSE)
			unassign_fireteam(M, FALSE)

	count--
	marines_list -= M
	personnel_deleted(M, zap = TRUE) // Free all refs and Zap it entierly as this is on purpose
	clear_ref_tracking(M)
	update_free_mar()
	update_squad_ui()
	M.assigned_squad = null

	switch(M.job)
		if(JOB_SQUAD_ENGI)
			num_engineers--
		if(JOB_SQUAD_MEDIC)
			num_medics--
		if(JOB_SQUAD_SPECIALIST)
			num_specialists--
		if(JOB_SQUAD_SMARTGUN)
			num_smartgun--
		if(JOB_SQUAD_RTO)
			num_rto--
		if(JOB_SQUAD_LEADER)
			num_leaders--

//proc for demoting current Squad Leader
/datum/squad/proc/demote_squad_leader(leader_killed)
	var/mob/living/carbon/human/old_lead = squad_leader

	SStracking.delete_leader(tracking_id)
	SStracking.stop_tracking("marine_sl", old_lead)

	squad_leader = null
	switch(old_lead.job)
		if(JOB_SQUAD_SPECIALIST)
			old_lead.comm_title = "Spc"
			if(old_lead.skills)
				old_lead.skills.set_skill(SKILL_LEADERSHIP, SKILL_LEAD_BEGINNER)
		if(JOB_SQUAD_ENGI)
			old_lead.comm_title = "Eng"
			if(old_lead.skills)
				old_lead.skills.set_skill(SKILL_LEADERSHIP, SKILL_LEAD_BEGINNER)
		if(JOB_SQUAD_MEDIC)
			old_lead.comm_title = "Med"
			if(old_lead.skills)
				old_lead.skills.set_skill(SKILL_LEADERSHIP, SKILL_LEAD_BEGINNER)
		if(JOB_SQUAD_RTO)
			old_lead.comm_title = "RTO"
			if(old_lead.skills)
				old_lead.skills.set_skill(SKILL_LEADERSHIP, SKILL_LEAD_TRAINED)
		if(JOB_SQUAD_SMARTGUN)
			old_lead.comm_title = "SG"
			if(old_lead.skills)
				old_lead.skills.set_skill(SKILL_LEADERSHIP, SKILL_LEAD_BEGINNER)
		if(JOB_SQUAD_LEADER)
			if(!leader_killed)
				if(old_lead.skills)
					old_lead.skills.set_skill(SKILL_LEADERSHIP, SKILL_LEAD_NOVICE)
				old_lead.comm_title = "Mar"
		else
			old_lead.comm_title = "Mar"
			if(old_lead.skills)
				old_lead.skills.set_skill(SKILL_LEADERSHIP, SKILL_LEAD_NOVICE)

	if(old_lead.job != JOB_SQUAD_LEADER || !leader_killed)
		if(istype(old_lead.wear_ear, /obj/item/device/radio/headset/almayer/marine))
			var/obj/item/device/radio/headset/almayer/marine/R = old_lead.wear_ear
			for(var/obj/item/device/encryptionkey/squadlead/acting/key in R.keys)
				R.keys -= key
				qdel(key)
			R.recalculateChannels()
		if(istype(old_lead.wear_id, /obj/item/card/id))
			var/obj/item/card/id/ID = old_lead.wear_id
			ID.access -= ACCESS_MARINE_LEADER
	old_lead.hud_set_squad()
	old_lead.update_inv_head()	//updating marine helmet leader overlays
	old_lead.update_inv_wear_suit()
	to_chat(old_lead, FONT_SIZE_BIG(SPAN_BLUE("You're no longer the Squad Leader for [src]!")))

//Not a safe proc. Returns null if squads or jobs aren't set up.
//Mostly used in the marine squad console in marine_consoles.dm.
/proc/get_squad_by_name(var/text)
	if(!RoleAuthority || RoleAuthority.squads.len == 0)
		return null
	var/datum/squad/S
	for(S in RoleAuthority.squads)
		if(S.name == text)
			return S
	return null

//below are procs used by acting SL to organize their squad
/datum/squad/proc/assign_fireteam(fireteam, mob/living/carbon/human/H, upd_ui = TRUE)
	if(H.assigned_fireteam)
		if(fireteam_leaders[H.assigned_fireteam])
			if(fireteam_leaders[H.assigned_fireteam] == H)
				unassign_ft_leader(H.assigned_fireteam, TRUE)	//remove marine from TL position
			else
				SStracking.stop_tracking(H.assigned_fireteam, H)	//remove from previous FT group
				if(H.stat == CONSCIOUS)
					to_chat(fireteam_leaders[fireteam], FONT_SIZE_BIG(SPAN_BLUE("[H.mind ? H.comm_title : ""] [H] was unassigned from your fireteam.")))
		fireteams[H.assigned_fireteam].Remove(H)
		var/ft = H.assigned_fireteam
		H.assigned_fireteam = fireteam
		fireteams[fireteam].Add(H)			//adding to fireteam
		update_fireteam(ft)
		update_fireteam(fireteam)
		if(upd_ui)
			update_squad_ui()
		if(fireteam_leaders[fireteam])		//if TL exists -> FT group, otherwise -> SL group
			SStracking.start_tracking(fireteam, H)
			if(H.stat == CONSCIOUS)
				to_chat(H, FONT_SIZE_HUGE(SPAN_BLUE("You were assigned to [fireteam]. Report to your Team Leader ASAP.")))
			to_chat(fireteam_leaders[fireteam], FONT_SIZE_BIG(SPAN_BLUE("[H.mind ? H.comm_title : ""] [H] was assigned to your fireteam.")))
		else
			SStracking.start_tracking(tracking_id, H)
			if(H.stat == CONSCIOUS)
				to_chat(H, FONT_SIZE_HUGE(SPAN_BLUE("You were assigned to [fireteam].")))
	else
		fireteams[fireteam].Add(H)
		H.assigned_fireteam = fireteam		//adding to fireteam
		update_fireteam(fireteam)
		update_free_mar()
		if(upd_ui)
			update_squad_ui()
		if(fireteam_leaders[fireteam])
			SStracking.stop_tracking(tracking_id, H)	//remove from previous FT group
			SStracking.start_tracking(fireteam, H)
			if(H.stat == CONSCIOUS)
				to_chat(H, FONT_SIZE_HUGE(SPAN_BLUE("You were assigned to [fireteam]. Report to your Team Leader ASAP.")))
			to_chat(fireteam_leaders[fireteam], FONT_SIZE_BIG(SPAN_BLUE("[H.mind ? H.comm_title : ""] [H] was assigned to your fireteam.")))
		if(H.stat == CONSCIOUS)
			to_chat(H, FONT_SIZE_HUGE(SPAN_BLUE("You were assigned to [fireteam].")))

/datum/squad/proc/unassign_fireteam(mob/living/carbon/human/H, upd_ui = TRUE)
	fireteams[H.assigned_fireteam].Remove(H)
	var/ft = H.assigned_fireteam
	H.assigned_fireteam = 0
	update_fireteam(ft)
	update_free_mar()
	if(upd_ui)
		update_squad_ui()
	if(fireteam_leaders[ft])
		SStracking.stop_tracking(ft, H)			//remove from FT group
		SStracking.start_tracking(tracking_id, H)	//add to SL group
		to_chat(fireteam_leaders[ft], FONT_SIZE_HUGE(SPAN_BLUE("[H.mind ? H.comm_title : ""] [H] was unassigned from your fireteam.")))
	if(!H.stat)
		to_chat(H, FONT_SIZE_HUGE(SPAN_BLUE("You were unassigned from [ft].")))

/datum/squad/proc/assign_ft_leader(fireteam, mob/living/carbon/human/H, upd_ui = TRUE)
	if(fireteam_leaders[fireteam])
		unassign_ft_leader(fireteam, FALSE, FALSE)
	fireteam_leaders[fireteam] = H
	H.hud_set_squad()
	update_fireteam(fireteam)
	if(upd_ui)
		update_squad_ui()
	SStracking.set_leader(H.assigned_fireteam, H)		//Set FT leader as leader of this group
	SStracking.start_tracking("marine_sl", H)
	if(H.stat == CONSCIOUS)
		to_chat(H, FONT_SIZE_HUGE(SPAN_BLUE("You were assigned as [fireteam] Team Leader.")))

/datum/squad/proc/unassign_ft_leader(fireteam, clear_group_id, upd_ui = TRUE)
	if(!fireteam_leaders[fireteam])
		return
	var/mob/living/carbon/human/H = fireteam_leaders[fireteam]
	fireteam_leaders[fireteam] = null
	H.hud_set_squad()
	if(clear_group_id)
		reassign_ft_tracker_group(fireteam, H.assigned_fireteam, tracking_id)	//transfer whole FT to SL group
		update_fireteam(fireteam)
	if(upd_ui)
		update_squad_ui()
	if(!H.stat)
		to_chat(H, FONT_SIZE_HUGE(SPAN_BLUE("You were unassigned as [fireteam] Team Leader.")))

/datum/squad/proc/unassign_all_ft_leaders()
	for(var/team in fireteam_leaders)
		if(fireteam_leaders[team])
			unassign_ft_leader(team, TRUE, TRUE)

/datum/squad/proc/reassign_ft_tracker_group(fireteam, old_id, new_id)
	for(var/mob/living/carbon/human/H in fireteams[fireteam])
		SStracking.stop_tracking(old_id, H)
		SStracking.start_tracking(new_id, H)

//moved the main proc for ft management from human.dm here to make it support both examine and squad info way to edit fts
/datum/squad/proc/manage_fireteams(mob/living/carbon/human/target)
	var/obj/item/card/id/ID = target.get_idcard()
	if(!ID || !(ID.rank in ROLES_MARINES))
		return
	if(ID.rank == JOB_SQUAD_LEADER || squad_leader == target)		//if SL/aSL are chosen
		var/choice = tgui_input_list(squad_leader, "Manage Fireteams and Team leaders.", "Fireteams Management", list("Cancel", "Unassign Fireteam 1 Leader", "Unassign Fireteam 2 Leader", "Unassign Fireteam 3 Leader", "Unassign all Team Leaders"))
		if(target.assigned_squad != src)
			return		//in case they somehow change squad while SL is choosing
		if(squad_leader.is_mob_incapacitated() || !hasHUD(squad_leader,"squadleader"))
			return		//if SL got knocked out or demoted while choosing
		switch(choice)
			if("Unassign Fireteam 1 Leader") unassign_ft_leader("FT1", TRUE)
			if("Unassign Fireteam 2 Leader") unassign_ft_leader("FT2", TRUE)
			if("Unassign Fireteam 3 Leader") unassign_ft_leader("FT3", TRUE)
			if("Unassign all Team Leaders") unassign_all_ft_leaders()
			else return
		target.hud_set_squad()
		return
	if(target.assigned_fireteam)
		if(fireteam_leaders[target.assigned_fireteam] == target)	//Check if person already is FT leader
			var/choice = tgui_input_list(squad_leader, "Manage Fireteams and Team leaders.", "Fireteams Management", list("Cancel", "Unassign from Team Leader position"))
			if(target.assigned_squad != src)
				return
			if(squad_leader.is_mob_incapacitated() || !hasHUD(squad_leader,"squadleader"))
				return
			if(choice == "Unassign from Team Leader position")
				unassign_ft_leader(target.assigned_fireteam, TRUE)
			target.hud_set_squad()
			return

		var/choice = tgui_input_list(squad_leader, "Manage Fireteams and Team leaders.", "Fireteams Management", list("Remove from Fireteam", "Assign to Fireteam 1", "Assign to Fireteam 2", "Assign to Fireteam 3", "Assign as Team Leader"))
		if(target.assigned_squad != src)
			return
		if(squad_leader.is_mob_incapacitated() || !hasHUD(squad_leader,"squadleader"))
			return
		switch(choice)
			if("Remove from Fireteam") unassign_fireteam(target)
			if("Assign to Fireteam 1") assign_fireteam("FT1", target)
			if("Assign to Fireteam 2") assign_fireteam("FT2", target)
			if("Assign to Fireteam 3") assign_fireteam("FT3", target)
			if("Assign as Team Leader") assign_ft_leader(target.assigned_fireteam, target)
			else return
		target.hud_set_squad()
		return

	var/choice = tgui_input_list(squad_leader, "Manage Fireteams and Team leaders.", "Fireteams Management", list("Cancel", "Assign to Fireteam 1", "Assign to Fireteam 2", "Assign to Fireteam 3"))
	if(target.assigned_squad != src)
		return
	if(squad_leader.is_mob_incapacitated() || !hasHUD(squad_leader,"squadleader"))
		return
	switch(choice)
		if("Assign to Fireteam 1") assign_fireteam("FT1", target)
		if("Assign to Fireteam 2") assign_fireteam("FT2", target)
		if("Assign to Fireteam 3") assign_fireteam("FT3", target)
		else return
	target.hud_set_squad()
	return

//Managing MIA and KIA statuses for marines
/datum/squad/proc/change_squad_status(mob/living/carbon/human/target)
	if(target == squad_leader)
		return		//you can't mark yourself KIA
	var/choice = tgui_input_list(squad_leader, "Marine status management. M.I.A. for unaccounted for marines, K.I.A. for confirmed unrevivable dead.", "Squad Management", list("Cancel", "Remove status", "M.I.A.", "K.I.A."))
	if(target.assigned_squad != src)
		return		//in case they somehow change squad while SL is choosing
	if(squad_leader.is_mob_incapacitated() || !hasHUD(squad_leader,"squadleader"))
		return		//if SL got knocked out or demoted while choosing
	switch(choice)
		if("Remove status") target.squad_status = null
		if("M.I.A.")
			target.squad_status = choice
			to_chat(squad_leader, FONT_SIZE_BIG(SPAN_BLUE("You set [target]'s status as Missing In Action.")))
			if(target.stat == CONSCIOUS)
				to_chat(target, FONT_SIZE_HUGE(SPAN_BLUE("You were marked as Missing In Action by Squad Leader.")))
		if("K.I.A.")
			target.squad_status = choice
			if(target.assigned_fireteam)
				if(fireteam_leaders[target.assigned_fireteam] == target)
					unassign_ft_leader(target.assigned_fireteam, TRUE, FALSE)
				unassign_fireteam(target, FALSE)
			to_chat(squad_leader, FONT_SIZE_BIG(SPAN_BLUE("You set [target]'s status as Killed In Action. If they were Team Leader or in fireteam, they were demoted and unassigned.")))
			if(target.stat == CONSCIOUS)
				to_chat(target, FONT_SIZE_HUGE(SPAN_BLUE("You were marked as Killed In Action by Squad Leader.")))
		else return
	if(target.assigned_fireteam)
		update_fireteam(target.assigned_fireteam)
	else
		update_free_mar()
	update_squad_ui()
	target.hud_set_squad()
	return
