/datum/squad/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "SquadInfo", "Squad Info")
		ui.open()

/datum/squad/ui_state(mob/user)
	. = ..()
	return GLOB.not_incapacitated_state

/datum/squad/ui_data(mob/user)
	if(!length(squad_info_data)) //initial first update of data
		update_all_squad_info()
	if(squad_info_data["total_mar"] != count) //updates for new marines
		update_free_mar()
		if(squad_leader && squad_info_data["sl"]["name"] != squad_leader.real_name)
			update_squad_leader()
	var/list/data = squad_info_data.Copy()
	data["squad"] = name
	data["squad_color"] = equipment_color
	data["is_lead"] = get_leadership(user)
	data["objective"] = list(
		"primary" = primary_objective,
		"secondary" = secondary_objective,
	)
	return data

/datum/squad/proc/get_leadership(mob/user)
	var/mob/living/carbon/human/H = user
	if (squad_leader && H.name == squad_leader.name)
		return "sl"
	else
		for(var/fireteam in fireteams)
			var/mob/living/carbon/human/ftl = fireteam_leaders[fireteam]
			if (ftl && ftl.name == H.name)
				return fireteam
	return FALSE

/datum/squad/proc/get_marine_from_name(name)
	for(var/mob/living/carbon/human/marine in marines_list)
		if(marine.name == name)
			return marine
	return null

/datum/squad/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/spritesheet/ranks))

/datum/squad/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/islead = get_leadership(usr)

	switch (action)
		if ("assign_ft")
			var/target_marine = params["target_marine"]
			var/target_team = params["target_ft"]

			if (islead != "sl")
				return

			var/mob/living/carbon/human/target = get_marine_from_name(target_marine)
			if(!target)
				return

			assign_fireteam(target_team, target, TRUE)
			update_all_squad_info()
			return

		if ("unassign_ft")
			var/target_marine = params["target_marine"]

			if (islead != "sl")
				return

			var/mob/living/carbon/human/target = get_marine_from_name(target_marine)
			if(!target)
				return
			unassign_fireteam(target, TRUE)
			update_all_squad_info()
			return

		if ("demote_ftl")
			var/target_team = params["target_ft"]

			if (islead != "sl")
				return

			unassign_ft_leader(target_team, FALSE, TRUE)
			update_all_squad_info()
			return

		if ("promote_ftl")
			var/target_marine = params["target_marine"]
			var/target_team = params["target_ft"]

			if (islead != "sl")
				return

			var/mob/living/carbon/human/target = get_marine_from_name(target_marine)
			if(!target)
				return
			assign_ft_leader(target_team, target, TRUE)
			update_all_squad_info()
			return

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
	squad_info_data["fireteams"][team]["total"] = length(fireteams[team])
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
				if(skillcheck(H, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE))
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
				if(JOB_SQUAD_TEAM_LEADER)
					rank = "TL"
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
		mar_free -= length(fireteams[team])
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
					if(skillcheck(H, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE))
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
						switch(H.rank_override)
							if("spec_demo")
								rank = "SpcDem"
							if("spec_sniper")
								rank = "SpcSn"
							if("spec_grenadier")
								rank = "SpcGr"
							if("spec_pyro")
								rank = "SpcPy"
							else
								rank = "Spc"
					if(JOB_SQUAD_TEAM_LEADER)
						rank = "TL"
					if(JOB_SQUAD_LEADER)
						rank = "SL"
					else
						rank = ""
				if(H.rank_fallback)
					rank = H.rank_fallback
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
					if(skillcheck(H, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE))
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
					if(JOB_SQUAD_TEAM_LEADER)
						rank = "TL"
					if(JOB_SQUAD_LEADER)
						rank = "SL"
					else
						rank = ""
				mar[H.real_name] += list("rank" = rank)
			else
				mar[H.real_name] += list("paygrade" = "N/A")
				mar[H.real_name] += list("rank" = "")
	return mar
