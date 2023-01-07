/mob/living/carbon/human/verb/checkSkills()
	set name = "Check Skills"
	set category = "IC"
	skills.tgui_interact(src)

/datum/skills/ui_state(mob/user)
	return GLOB.always_state

/datum/skills/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SkillsMenu", "[owner]'s skills")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/skills/ui_static_data(mob/user)
	var/list/data = list()

	data["admin"] = check_rights(R_VAREDIT, FALSE)

	return data

/datum/skills/ui_data(mob/user)
	var/list/data = list()

	data["skillset_name"] = name
	data["owner"] = owner


	if(!skills)
		data["skills"] = null
		return data // they have no skills =  show the null skills menu

	var/list/skills_data_list = list()

	for(var/skillname as anything in skills)
		var/datum/skill/skilldatum = get_skill(skillname)

		skills_data_list += list(list(
			"name" = skilldatum.readable_skill_name ? skilldatum.readable_skill_name : skilldatum.skill_name,
			"realname" = skilldatum.skill_name,
			"level" = get_skill_level(skillname),
			"maxlevel" = skilldatum.max_skill_level
		))

	data["skills"] = skills_data_list

	return data

/datum/skills/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("set_skill")
			if(!check_rights(R_VAREDIT))
				return
			else
				var/newlevel = params["level"]
				var/oldlevel = params["oldlevel"]
				if(newlevel == oldlevel)
					return // to stop staff spam

				var/skillname = params["skill"]
				set_skill(skillname, newlevel)
				message_staff("[key_name_admin(usr)] has edited [owner]'s [skillname] skill from [oldlevel] to level [newlevel].")
				. = TRUE

		if("refresh")
			SStgui.update_uis(src)
