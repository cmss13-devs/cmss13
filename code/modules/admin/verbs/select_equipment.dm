

/client/proc/cmd_admin_select_mob_rank(var/mob/living/carbon/human/H in mob_list)
	set category = null
	set name = "Select Rank"
	if(!istype(H))
		alert("Invalid mob")
		return

	var/rank_list = list("Custom") + RoleAuthority.roles_by_name

	var/newrank = input("Select new rank for [H]", "Change the mob's rank and skills") as null|anything in rank_list
	if (!newrank)
		return
	if(!H || !H.mind)
		return
	var/obj/item/card/id/I = H.wear_id
	feedback_add_details("admin_verb","SMRK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	if(newrank != "Custom")
		var/datum/job/J = RoleAuthority.roles_by_name[newrank]
		H.mind.role_comm_title = J.get_comm_title()
		H.mind.set_cm_skills(J.get_skills())
		if(istype(I))
			I.access = J.get_access()
			I.rank = J.title
			I.assignment = J.disp_title
			I.name = "[I.registered_name]'s ID Card ([I.assignment])"
			I.paygrade = J.get_paygrade()
	else
		var/newcommtitle = input("Write the custom title appearing on comms chat (e.g. Spc)", "Comms title") as null|text
		if(!newcommtitle)
			return
		if(!H || !H.mind)
			return

		H.mind.role_comm_title = newcommtitle

		if(!istype(I) || I != H.wear_id)
			usr << "The mob has no id card, unable to modify ID and chat title."
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

		if(!H.mind)
			usr << "The mob has no mind, unable to modify skills."
		else
			var/newskillset = input("Select a skillset", "Skill Set") as null|anything in RoleAuthority.roles_by_name
			if(!newskillset)
				return

			if(!H || !H.mind)
				return

			var/datum/job/J = RoleAuthority.roles_by_name[newskillset]
			H.mind.set_cm_skills(J.get_skills())




/client/proc/cmd_admin_dress(var/mob/living/carbon/human/M in mob_list)
	set category = null
	set name = "Select Equipment"
	if(!ishuman(M))
		alert("Invalid mob")
		return

	var/dresscode = input("Select dress for [M]", "Robust quick dress shop") as null|anything in gear_presets_list
	if (isnull(dresscode))
		return
	feedback_add_details("admin_verb","SEQ") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	for (var/obj/item/I in M)
		if (istype(I, /obj/item/implant))
			continue
		cdel(I)
	arm_equipment(M, dresscode)
	M.regenerate_icons()
	log_admin("[key_name(usr)] changed the equipment of [key_name(M)] to [dresscode].")
	message_admins("\blue [key_name_admin(usr)] changed the equipment of [key_name_admin(M)] to [dresscode].", 1)
	return


//note: when adding new dresscodes, on top of adding a proper skills_list, make sure the ID given has
//a rank that matches a job title unless you want the human to bypass the skill system.
/proc/arm_equipment(var/mob/living/carbon/human/M, var/dresscode, var/randomise = FALSE)
	if(!gear_presets_list || !gear_presets_list[dresscode])
		return
	gear_presets_list[dresscode].load_preset(M, randomise)
	return
