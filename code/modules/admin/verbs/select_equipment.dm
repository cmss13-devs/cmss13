/client/proc/cmd_admin_select_mob_rank(var/mob/living/carbon/human/H in GLOB.human_mob_list)
	set category = null
	set name = "Select Rank"
	if(!istype(H))
		alert("Invalid mob")
		return

	var/rank_list = list("Custom", "Weston-Yamada") + RoleAuthority.roles_by_name

	var/newrank = input("Select new rank for [H]", "Change the mob's rank and skills") as null|anything in rank_list
	if (!newrank)
		return
	if(!H)
		return
	var/obj/item/card/id/I = H.wear_id

	if(RoleAuthority.roles_by_name[newrank])
		var/datum/job/J = RoleAuthority.roles_by_name[newrank]
		H.comm_title = J.get_comm_title()
		H.set_skills(J.get_skills())
		if(istype(I))
			I.access = J.get_access()
			I.rank = J.title
			I.assignment = J.disp_title
			I.name = "[I.registered_name]'s ID Card ([I.assignment])"
			I.paygrade = J.get_paygrade()
			if(H.w_uniform)
				var/obj/item/clothing/C = H.w_uniform
				for(var/obj/item/clothing/accessory/ranks/R in C)
					C.remove_accessory(H, R)
					qdel(R)
				var/rankpath = get_rank_pins(I.paygrade)
				if(rankpath)
					var/obj/item/clothing/accessory/ranks/R = new rankpath()
					C.attach_accessory(H, R)
		var/new_faction = input("Select faction.", "Faction Choice", "Neutral") as null|anything in FACTION_LIST_HUMANOID
		if(!new_faction)
			new_faction = FACTION_NEUTRAL
		H.faction = new_faction
	else
		switch(newrank)
			if("Weston-Yamada")
				var/code = "WY-"

				var/divisions = get_named_wy_ranks("division_code")
				var/div = input("Select the Division at which they belong to.", "Division") in divisions

				if(!div)
					return
				code += divisions[div]

				var/ranks = get_named_wy_ranks("job_code")
				var/rank = input("Select the Rank at which they are at.", "Rank") in ranks

				if(!rank)
					return
				code += ranks[rank]

				H.apply_wy_rank_code(code)

				H.faction = FACTION_WY
				H.faction_group = FACTION_LIST_WY

				var/newskillset = input("Select a skillset", "Skill Set") as null|anything in (list("Keep Skillset") +RoleAuthority.roles_by_name)
				if(!newskillset || newskillset == "Keep Skillset")
					return

				if(!H)
					return

				var/datum/job/J = RoleAuthority.roles_by_name[newskillset]
				H.set_skills(J.get_skills())

			if("Custom")
				var/newcommtitle = input("Write the custom title appearing on comms chat (e.g. Spc)", "Comms title") as null|text
				if(!newcommtitle)
					return
				if(!H)
					return

				H.comm_title = newcommtitle

				if(!istype(I) || I != H.wear_id)
					to_chat(usr, "The mob has no id card, unable to modify ID and chat title.")
				else
					var/newchattitle = input("Write the custom title appearing in chat (e.g. SGT)", "Chat title") as null|text
					if(!newchattitle)
						return
					if(!H || I != H.wear_id)
						return

					I.paygrade = newchattitle
					var/IDtitle = input("Write the custom title on your ID (e.g. Squad Specialist)", "ID title") as null|text
					if(!IDtitle)
						return
					if(!H || I != H.wear_id)
						return

					I.rank = IDtitle
					I.assignment = IDtitle
					I.name = "[I.registered_name]'s ID Card ([I.assignment])"

				var/new_faction = input("Select faction.", "Faction Choice", "Neutral") as null|anything in FACTION_LIST_HUMANOID
				if(!new_faction)
					new_faction = FACTION_NEUTRAL
				H.faction = new_faction

				var/newskillset = input("Select a skillset", "Skill Set") as null|anything in RoleAuthority.roles_by_name
				if(!newskillset)
					return

				if(!H)
					return

				var/datum/job/J = RoleAuthority.roles_by_name[newskillset]
				H.set_skills(J.get_skills())

/client/proc/cmd_admin_dress(var/mob/M)
	set category = null
	set name = "Select Equipment"

	cmd_admin_dress_human(M)

/client/proc/cmd_admin_dress_human(var/mob/living/carbon/human/M in GLOB.human_mob_list, var/datum/equipment_preset/dresscode, var/no_logs = 0, var/count_participant = FALSE)
	if (!no_logs)
		dresscode = tgui_input_list(usr, "Select dress for [M]", "Robust quick dress shop", gear_presets_list)

	if(isnull(dresscode))
		return


	for (var/obj/item/I in M)
		if (istype(I, /obj/item/implant))
			continue
		qdel(I)

	if(!ishuman(M))
		//If the mob is not human, we're transforming them into a human
		//To speed up the setup process
		M = M.change_mob_type( /mob/living/carbon/human , null, null, TRUE, "Human")
		if(!ishuman(M))
			to_chat(usr, "Something went wrong with mob transformation...")
			return

	if(!M.hud_used)
		M.create_hud()

	arm_equipment(M, dresscode, FALSE, count_participant)
	if(!no_logs)
		message_staff("[key_name_admin(usr)] changed the equipment of [key_name_admin(M)] to [dresscode].")
	return

/client/proc/cmd_admin_dress_all()
	set category = "Debug"
	set name = "Select Equipment - All Humans"
	set desc = "Applies an equipment preset to all humans in the world."

	var/datum/equipment_preset/dresscode = input("Select dress for ALL HUMANS", "Robust quick dress shop") as null|anything in gear_presets_list
	if (isnull(dresscode))
		return

	if(alert("Are you sure you want to change the equipment of ALL humans in the world to [dresscode]?",, "Yes", "No") == "No") return

	for(var/mob/living/carbon/human/M in GLOB.human_mob_list)
		src.cmd_admin_dress_human(M, dresscode, 1)

	message_staff("[key_name_admin(usr)] changed the equipment of ALL HUMANS to [dresscode].")

//note: when adding new dresscodes, on top of adding a proper skills_list, make sure the ID given has
//a rank that matches a job title unless you want the human to bypass the skill system.
/proc/arm_equipment(var/mob/living/carbon/human/M, var/dresscode, var/randomise = FALSE, var/count_participant = FALSE)
	if(!gear_presets_list)
		CRASH("arm_equipment !gear_presets_list")
	if(!gear_presets_list[dresscode])
		CRASH("arm_equipment !gear_presets_list[dresscode]")
	gear_presets_list[dresscode].load_preset(M, randomise, count_participant)

	if(M.faction)
		M.check_event_info(M.faction)
	return
