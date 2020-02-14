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
	var/list/fireteams = list(
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
	for(var/obj/structure/supply_drop/S in structure_list)
		if(name == S.squad)
			drop_pad = S
			break

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
	if(!M.mind.assigned_role)
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

	switch(M.mind.assigned_role)
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
		if(JOB_SQUAD_SMARTGUN)
			assignment = JOB_SQUAD_SMARTGUN
			num_smartgun++
		if(JOB_SQUAD_LEADER)
			if(squad_leader && (!squad_leader.mind || squad_leader.mind.assigned_role != JOB_SQUAD_LEADER)) //field promoted SL
				var/old_lead = squad_leader
				demote_squad_leader()	//replaced by the real one
				SStracking.start_tracking(tracking_id, old_lead)
			assignment = JOB_SQUAD_LEADER
			squad_leader = M
			SStracking.set_leader(tracking_id, M)
			SStracking.start_tracking("marine_sl", M)

			if(M.mind.assigned_role == JOB_SQUAD_LEADER) //field promoted SL don't count as real ones
				num_leaders++

	if(assignment != JOB_SQUAD_LEADER)
		SStracking.start_tracking(tracking_id, M)

	count++		//Add up the tally. This is important in even squad distribution.

	if(M.mind.assigned_role != "Squad Marine")
		log_admin("[key_name(M)] has been assigned as [name] [M.mind.assigned_role]") // we don't want to spam squad marines but the others are useful

	marines_list += M
	M.assigned_squad = src	//Add them to the squad
	C.access += src.access	//Add their squad access to their ID
	C.assignment = "[name] [assignment]"
	C.name = "[C.registered_name]'s ID Card ([C.assignment])"
	return 1

//proc used by the overwatch console to transfer marine to another squad
/datum/squad/proc/remove_marine_from_squad(mob/living/carbon/human/M)
	if(!M.mind)
		return 0
	if(!M.assigned_squad)
		return		//not assigned to a squad
	var/obj/item/card/id/C
	C = M.wear_id
	if(!istype(C))
		return 0	//Abort, no ID found

	C.access -= src.access
	C.assignment = M.mind.assigned_role
	C.name = "[C.registered_name]'s ID Card ([C.assignment])"

	if(M.assigned_squad.squad_leader == M)
		if(M.mind.assigned_role != JOB_SQUAD_LEADER) //a field promoted SL, not a real one
			demote_squad_leader()
		else
			M.assigned_squad.squad_leader = null
		update_squad_leader()
	else
		if(M.assigned_fireteam)
			if(fireteam_leaders[M.assigned_fireteam] == M)
				unassign_ft_leader(M.assigned_fireteam, TRUE, FALSE)
			unassign_fireteam(M, FALSE)
		SStracking.stop_tracking(tracking_id, M)

	count--
	marines_list -= M
	update_free_mar()
	update_squad_ui()
	M.assigned_squad = null

	switch(M.mind.assigned_role)
		if(JOB_SQUAD_ENGI) num_engineers--
		if(JOB_SQUAD_MEDIC) num_medics--
		if(JOB_SQUAD_SPECIALIST) num_specialists--
		if(JOB_SQUAD_SMARTGUN) num_smartgun--
		if(JOB_SQUAD_LEADER) num_leaders--

//proc for demoting current Squad Leader
/datum/squad/proc/demote_squad_leader(leader_killed)
	var/mob/living/carbon/human/old_lead = squad_leader

	SStracking.delete_leader(tracking_id)
	SStracking.stop_tracking("marine_sl", old_lead)

	squad_leader = null
	if(old_lead.mind)
		switch(old_lead.mind.assigned_role)
			if(JOB_SQUAD_SPECIALIST)
				old_lead.mind.role_comm_title = "Spc"
				if(old_lead.skills)
					old_lead.skills.set_skill(SKILL_LEADERSHIP, SKILL_LEAD_BEGINNER)
			if(JOB_SQUAD_ENGI)
				old_lead.mind.role_comm_title = "Eng"
				if(old_lead.skills)
					old_lead.skills.set_skill(SKILL_LEADERSHIP, SKILL_LEAD_BEGINNER)
			if(JOB_SQUAD_MEDIC)
				old_lead.mind.role_comm_title = "Med"
				if(old_lead.skills)
					old_lead.skills.set_skill(SKILL_LEADERSHIP, SKILL_LEAD_BEGINNER)
			if(JOB_SQUAD_SMARTGUN)
				old_lead.mind.role_comm_title = "SG"
				if(old_lead.skills)
					old_lead.skills.set_skill(SKILL_LEADERSHIP, SKILL_LEAD_BEGINNER)
			if(JOB_SQUAD_LEADER)
				if(!leader_killed)
					if(old_lead.skills)
						old_lead.skills.set_skill(SKILL_LEADERSHIP, SKILL_LEAD_NOVICE)
					old_lead.mind.role_comm_title = "Mar"
			else
				old_lead.mind.role_comm_title = "Mar"
				if(old_lead.skills)
					old_lead.skills.set_skill(SKILL_LEADERSHIP, SKILL_LEAD_NOVICE)

	if(!old_lead.mind || old_lead.mind.assigned_role != JOB_SQUAD_LEADER || !leader_killed)
		if(istype(old_lead.wear_ear, /obj/item/device/radio/headset/almayer/marine))
			var/obj/item/device/radio/headset/almayer/marine/R = old_lead.wear_ear
			if(istype(R.keyslot1, /obj/item/device/encryptionkey/squadlead))
				qdel(R.keyslot1)
				R.keyslot1 = null
			else if(istype(R.keyslot2, /obj/item/device/encryptionkey/squadlead))
				qdel(R.keyslot2)
				R.keyslot2 = null
			else if(istype(R.keyslot3, /obj/item/device/encryptionkey/squadlead))
				qdel(R.keyslot3)
				R.keyslot3 = null
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
					to_chat(fireteam_leaders[fireteam], FONT_SIZE_BIG(SPAN_BLUE("[H.mind ? H.mind.role_comm_title : ""] [H] was unassigned from your fireteam.")))
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
			to_chat(fireteam_leaders[fireteam], FONT_SIZE_BIG(SPAN_BLUE("[H.mind ? H.mind.role_comm_title : ""] [H] was assigned to your fireteam.")))
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
			to_chat(fireteam_leaders[fireteam], FONT_SIZE_BIG(SPAN_BLUE("[H.mind ? H.mind.role_comm_title : ""] [H] was assigned to your fireteam.")))
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
		to_chat(fireteam_leaders[ft], FONT_SIZE_HUGE(SPAN_BLUE("[H.mind ? H.mind.role_comm_title : ""] [H] was unassigned from your fireteam.")))

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
		var/choice = input(squad_leader, "Manage Fireteams and Team leaders.", "Fireteams Management") as null|anything in list("Cancel", "Unassign Fireteam 1 Leader", "Unassign Fireteam 2 Leader", "Unassign Fireteam 3 Leader", "Unassign all Team Leaders")
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
			var/choice = input(squad_leader, "Manage Fireteams and Team leaders.", "Fireteams Management") as null|anything in list("Cancel", "Unassign from Team Leader position")
			if(target.assigned_squad != src)
				return
			if(squad_leader.is_mob_incapacitated() || !hasHUD(squad_leader,"squadleader"))
				return
			if(choice == "Unassign from Team Leader position")
				if("Unassign from Team Leader position") unassign_ft_leader(target.assigned_fireteam, TRUE)
				else return
			target.hud_set_squad()
			return

		var/choice = input(squad_leader, "Manage Fireteams and Team leaders.", "Fireteams Management") as null|anything in list("Remove from Fireteam", "Assign to Fireteam 1", "Assign to Fireteam 2", "Assign to Fireteam 3", "Assign as Team Leader")
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

	var/choice = input(squad_leader, "Manage Fireteams and Team leaders.", "Fireteams Management") as null|anything in list("Cancel", "Assign to Fireteam 1", "Assign to Fireteam 2", "Assign to Fireteam 3")
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
	var/choice = input(squad_leader, "Marine status management. M.I.A. for unaccounted for marines, K.I.A. for confirmed unrevivable dead.", "Squad Management") as null|anything in list("Cancel", "Remove status", "M.I.A.", "K.I.A.")
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
