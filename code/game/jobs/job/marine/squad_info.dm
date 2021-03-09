/datum/squad/proc/ui_interact(mob/living/carbon/human/user)
	if(!istype(user))
		return

	if(!squad_info_data.len)					//initial first update of data
		update_all_squad_info()
	if(squad_info_data["total_mar"] != count)	//updates for new marines
		update_free_mar()
		if(squad_leader && squad_info_data["sl"]["name"] != squad_leader.real_name)
			update_squad_leader()
		update_squad_ui()

	var/list/ui_data = squad_info_data.Copy()
	// This needs to be passed since we're not handling the full UI interaction on the mob itself
	var/userref = "\ref[user]"

	ui_data["userref"] = userref

	var/datum/nanoui/ui = nanomanager.try_update_ui(user, user, "squad_info_ui", null, ui_data)
	if(isnull(ui))
		ui = new(user, user, "squad_info_ui", "squad_info.tmpl", "[name] Squad Info", 460, 400)
		ui.set_initial_data(ui_data)
		ui.open()

		squad_info_uis += user

//used once on first opening
/datum/squad/proc/update_all_squad_info()
	squad_info_data["sl"] = list()
	update_squad_leader()
	squad_info_data["fireteams"] = list()
	var/i = 1
	for(var/team in fireteams)
		squad_info_data["fireteams"][team] = list()
		squad_info_data["fireteams"][team]["name"] = "Fireteam [i]"
		update_fireteam(team)
		i++
	squad_info_data["mar_free"] = list()
	update_free_mar()

/datum/squad/proc/update_squad_ui()		//proc that handles opened UIs updates
	for(var/mob/living/carbon/human/H in squad_info_uis)
		var/rmv_user = TRUE
		for(var/datum/nanoui/ui in H.open_uis)
			if(ui.ui_key == "squad_info_ui")
				rmv_user = FALSE
				var/list/ui_data = squad_info_data.Copy()
				ui_data["userref"] = "\ref[H]"
				ui = nanomanager.try_update_ui(H, H, "squad_info_ui", null, ui_data)
		if(rmv_user)
			squad_info_uis -= H

//SL update. Should always be paired up with FT or free marines update
/datum/squad/proc/update_squad_leader()
	var/obj/item/card/id/ID = null
	if(squad_leader)
		ID = squad_leader.get_idcard()
	squad_info_data["sl"]["name"] = squad_leader ? squad_leader.real_name : "None"
	squad_info_data["sl"]["refer"] = squad_leader ? "\ref[squad_leader]" : null
	squad_info_data["sl"]["paygrade"] = ID ? get_paygrades(ID.paygrade, 1) : ""

//fireteam and TL update
/datum/squad/proc/update_fireteam(team)
	squad_info_data["fireteams"][team]["total"] = fireteams[team].len
	if(squad_info_data["fireteams"][team]["total"] < 1)
		squad_info_data["fireteams"][team]["tl"] = list()
		squad_info_data["fireteams"][team]["mar"] = list()
		return

	if(fireteam_leaders[team])
		var/mob/living/carbon/human/H = null
		var/obj/item/card/id/ID = null
		H = fireteam_leaders[team]
		var/Med = FALSE
		var/Eng = FALSE
		if(H.has_used_pamphlet)
			if(skillcheck(H, SKILL_MEDICAL, SKILL_MEDICAL_TRAINED))
				Med = TRUE
			else
				if(skillcheck(H, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
					Eng = TRUE
		ID = H.get_idcard()
		squad_info_data["fireteams"][team]["tl"] = list(
							"name" = H.real_name,
							"med" = Med,
							"eng" = Eng,
							"status" = H.squad_status,
							"refer" = "\ref[H]")
		if(ID)
			squad_info_data["fireteams"][team]["tl"] += list("paygrade" = get_paygrades(ID.paygrade, 1))
			var/rank = ID.rank
			switch(rank)
				if(JOB_SQUAD_MARINE)
					rank = "Mar"
				if(JOB_SQUAD_ENGI)
					rank = "Eng"
				if(JOB_SQUAD_MEDIC)
					rank = "Med"
				if(JOB_SQUAD_SMARTGUN)
					rank = "SG"
				if(JOB_SQUAD_SPECIALIST)
					rank = "Spc"
				if(JOB_SQUAD_RTO)
					rank = "RTO"
				if(JOB_SQUAD_LEADER)
					rank = "SL"
				else
					rank = ""
			squad_info_data["fireteams"][team]["tl"] += list("rank" = rank)
		else
			squad_info_data["fireteams"][team]["tl"] += list("paygrade" = "N/A")
			squad_info_data["fireteams"][team]["tl"] += list("rank" = "")
	else
		squad_info_data["fireteams"][team]["tl"] = list(
							"name" = "Not assigned",
							"paygrade" = "",
							"rank" = "",
							"med" = FALSE,
							"eng" = FALSE,
							"status" = null,
							"refer" = null)

	squad_info_data["fireteams"][team]["mar"] = get_marines(team)

//unassigned (free) marines update. Includes updating of current marine count, cause new marines will be unassigned.
/datum/squad/proc/update_free_mar()
	squad_info_data["total_mar"] = count
	squad_info_data["total_kia"] = 0
	var/mar_free = count
	for(var/team in fireteams)
		mar_free -= fireteams[team].len
	if(squad_leader)
		mar_free--
	for(var/list/freeman in squad_info_data["mar_free"])
		if(freeman["paygrade"] == "SSGT")
			mar_free--
	squad_info_data["total_free"] = mar_free
	squad_info_data["mar_free"] = get_marines(0)
	return

//retrieving info about marines in a selected group. 0 goes for unassigned marines
/datum/squad/proc/get_marines(team)
	var/list/mar = list()
	if(!team)
		for(var/mob/living/carbon/human/H in marines_list)
			if(H.assigned_fireteam || H == squad_leader)
				continue
			if(H.squad_status == "K.I.A.")
				squad_info_data["total_kia"]++
			var/obj/item/card/id/ID = H.get_idcard()
			var/Med = FALSE
			var/Eng = FALSE
			if(H.has_used_pamphlet)
				if(skillcheck(H, SKILL_MEDICAL, SKILL_MEDICAL_TRAINED))
					Med = TRUE
				else
					if(skillcheck(H, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
						Eng = TRUE
			mar[H.real_name] = list(
					"name" = H.real_name,
					"med" = Med,
					"eng" = Eng,
					"status" = H.squad_status,
					"refer" = "\ref[H]"
					)
			if(ID)
				mar[H.real_name] += list("paygrade" = get_paygrades(ID.paygrade, 1))
				var/rank = ID.rank
				switch(rank)
					if(JOB_SQUAD_MARINE)
						rank = "Mar"
					if(JOB_SQUAD_ENGI)
						rank = "Eng"
					if(JOB_SQUAD_MEDIC)
						rank = "Med"
					if(JOB_SQUAD_SMARTGUN)
						rank = "SG"
					if(JOB_SQUAD_SPECIALIST)
						rank = "Spc"
					if(JOB_SQUAD_RTO)
						rank = "RTO"
					if(JOB_SQUAD_LEADER)
						rank = "SL"
					else
						rank = ""
				mar[H.real_name] += list("rank" = rank)
			else
				mar[H.real_name] += list("paygrade" = "N/A")
				mar[H.real_name] += list("rank" = "")

	else
		for(var/mob/living/carbon/human/H in fireteams[team])
			if(H == fireteam_leaders[team])
				continue
			var/obj/item/card/id/ID = H.get_idcard()
			var/Med = FALSE
			var/Eng = FALSE
			if(H.has_used_pamphlet)
				if(skillcheck(H, SKILL_MEDICAL, SKILL_MEDICAL_TRAINED))
					Med = TRUE
				else
					if(skillcheck(H, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
						Eng = TRUE
			mar[H.real_name] = list(
				"name" = H.real_name,
				"med" = Med,
				"eng" = Eng,
				"status" = H.squad_status,
				"refer" = "\ref[H]"
				)
			if(ID)
				mar[H.real_name] += list("paygrade" = get_paygrades(ID.paygrade, 1))
				var/rank = ID.rank
				switch(rank)
					if(JOB_SQUAD_MARINE)
						rank = "Mar"
					if(JOB_SQUAD_ENGI)
						rank = "Eng"
					if(JOB_SQUAD_MEDIC)
						rank = "Med"
					if(JOB_SQUAD_SMARTGUN)
						rank = "SG"
					if(JOB_SQUAD_SPECIALIST)
						rank = "Spc"
					if(JOB_SQUAD_RTO)
						rank = "RTO"
					if(JOB_SQUAD_LEADER)
						rank = "SL"
					else
						rank = ""
				mar[H.real_name] += list("rank" = rank)
			else
				mar[H.real_name] += list("paygrade" = "N/A")
				mar[H.real_name] += list("rank" = "")
	return mar
