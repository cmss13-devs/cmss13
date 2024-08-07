/datum/faction
	var/name = NAME_FACTION_NEUTRAL
	var/desc = "Neutral Faction"

	var/faction_name = FACTION_NEUTRAL
	var/faction_tag = SIDE_FACTION_NEUTRAL

	var/organ_faction_iff_tag_type
	var/faction_iff_tag_type
	var/ally_factions_initialize = TRUE

	var/relations_pregen[] = RELATIONS_NEUTRAL

	var/hud_type = FACTION_HUD
	var/orders = "Survive"
	var/color = "#22888a"
	var/ui_color = "#22888a"
	var/prefix = ""
	var/list/totalMobs = list()
	var/list/totalDeadMobs = list()
	var/list/faction_leaders = list()
	var/list/late_join_landmarks = list()
	var/mob/living/carbon/faction_leader

	var/need_round_end_check = FALSE

////////////////
//BALANCE DEFS//
////////////////
	var/list/role_mappings = list()
	var/list/roles_list = list()

	var/spawning_enabled = TRUE
	var/latejoin_enabled = TRUE

///////////
//MODULES//
///////////
	var/list/modules_to_add = list(MODULE_CODE_NAME_RELATIONS = list()) // list(MODULE_NAME = list(MODULE_VARS = VALUE, ...), ...)
	var/list/datum/faction_module/modules = list()

//////////////
/datum/faction/New()
	for(var/module in modules_to_add)
		if(!GLOB.faction_modules[module])
			return
		modules[module] = new GLOB.faction_modules[module](src, ...modules_to_add[module])

/datum/faction/can_vv_modify()
	return FALSE

/datum/faction/proc/modify_hud_holder(image/holder, mob/living/carbon/human/H)
	return

/datum/faction/proc/add_mob(mob/living/carbon/carbon)
	if(!carbon || !istype(carbon))
		return

	if(carbon.faction && carbon.faction != src)
		carbon.faction.remove_mob(carbon, TRUE)

	if(carbon in totalMobs)
		return

	carbon.faction = src

	if(carbon.hud_list)
		carbon.hud_update()

	if(!carbon.statistic_exempt)
		totalMobs += carbon

/datum/faction/proc/remove_mob(mob/living/carbon/carbon, hard = FALSE)
	if(!carbon || !istype(carbon))
		return

	if(!(carbon in totalMobs))
		return

	if(hard)
		carbon.faction = null
	else
		totalDeadMobs += carbon

	totalMobs -= carbon

/datum/faction/proc/can_delay_round_end(mob/living/carbon/carbon)
	return TRUE

//Ally procs
/atom/movable/proc/ally(datum/faction/ally_faction)
	if(!ally_faction)
		return FALSE

	var/list/factions = list()
	factions += ally_faction
	var/datum/faction_module/relations/module = ally_faction.modules[MODULE_CODE_NAME_RELATIONS]
	for(var/datum/faction/allies in module.allies)
		factions += allies
	if(isnull(factions) || !faction)
		return FALSE

	return faction in factions

/mob/ally(datum/faction/ally_faction)
	if(!ally_faction)
		return FALSE

	var/list/factions = list()
	factions += ally_faction
	var/datum/faction_module/relations/module = ally_faction.modules[MODULE_CODE_NAME_RELATIONS]
	for(var/datum/faction/allies in module.allies)
		factions += allies

	if(isnull(factions) || !faction)
		return FALSE

	return faction in factions

/mob/living/carbon/ally(datum/faction/ally_faction)
	if(!ally_faction)
		return FALSE

	if((organ_faction_tag || (faction.faction_tag in SIDE_ORGANICAL_DOM)) && (ally_faction.faction_tag in SIDE_ORGANICAL_DOM))
		if(organ_faction_tag)
			return ally_faction.organ_faction_tag_is_ally(organ_faction_tag)
		else if(faction == ally_faction)
			return TRUE
	else if(faction_tag)
		return ally_faction.faction_tag_is_ally(faction_tag)

	return FALSE

/datum/faction/proc/organ_faction_tag_is_ally(obj/item/faction_tag/organ/organ_tag)
	if(organ_tag.faction == src)
		return TRUE
	var/datum/faction_module/relations/module = modules[MODULE_CODE_NAME_RELATIONS]
	for(var/datum/faction/faction in organ_tag.factions + organ_tag.faction)
		if(module.allies[faction.faction_name])
			return TRUE

	return FALSE

/datum/faction/proc/faction_tag_is_ally(obj/item/faction_tag/object_tag)
	if(object_tag.faction == src)
		return TRUE
	var/datum/faction_module/relations/module = modules[MODULE_CODE_NAME_RELATIONS]
	for(var/datum/faction/faction in object_tag.factions + object_tag.faction)
		if(module.allies[faction.faction_name])
			return TRUE
		else if(faction.faction_tag == faction_tag)
			return TRUE

	return FALSE

/datum/faction/proc/faction_is_ally(datum/faction/faction_to_check)
	if(faction_to_check.faction_tag == faction_tag)
		return TRUE

	var/datum/faction_module/relations/module = modules[MODULE_CODE_NAME_RELATIONS]
	if(module.allies[faction_to_check.faction_name])
		return TRUE

	return FALSE

/datum/faction/proc/get_antag_guns_snowflake_equipment()
	return list()

/datum/faction/proc/get_antag_guns_sorted_equipment()
	return list()

/datum/faction/proc/store_objective(datum/cm_objective/O)
	if(objective_memory)
		objective_memory.store_objective(O)

//FACTION INFO PANEL
/datum/faction/ui_state(mob/user)
	return GLOB.not_incapacitated_state

/datum/faction/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(isobserver(user))
		return UI_INTERACTIVE

/datum/faction/ui_data(mob/user)
	. = list()
	.["faction_orders"] = orders

/datum/faction/ui_static_data(mob/user)
	. = list()
	.["faction_color"] = ui_color
	.["faction_name"] = name
	.["faction_desc"] = desc
	.["actions"] = get_faction_actions()

/datum/faction/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FactionStatus", "[name] Статус")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/faction/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("relations")
			relations_datum.tgui_interact(usr)
		if("tasks")
			task_interface.tgui_interact(usr)
		if("clues")
			if(!skillcheck(usr, SKILL_INTEL, SKILL_INTEL_TRAINED))
				to_chat(usr, SPAN_WARNING("You have no access to the [name] intel network."))
				return
			objective_interface.tgui_interact(usr)
		if("researchs")
			if(!skillcheck(usr, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
				to_chat(usr, SPAN_WARNING("You have no access to the [name] research network."))
				return
			research_objective_interface.tgui_interact(usr)
		if("status")
			get_faction_info(usr)

/datum/faction/proc/get_faction_actions(mob/user)
	. = list()
	. += list(list("name" = "Faction Relations", "action" = "relations"))
	. += list(list("name" = "Faction Tasks", "action" = "tasks"))
	. += list(list("name" = "Faction Clues", "action" = "clues"))
	. += list(list("name" = "Faction Researchs", "action" = "researchs"))
	. += list(list("name" = "Faction Status", "action" = "status"))
	return .

/datum/faction/proc/get_faction_info(mob/user)
	var/dat = GLOB.data_core.get_manifest(FALSE, src)
	if(!dat)
		return FALSE
	show_browser(user, dat, "Список Экипажа [name]", "manifest", "size=450x750")
	return TRUE

/datum/faction/proc/get_join_status(mob/new_player/user, dat)

/* Right now don't wanna mess around for one factions solution, if making this, this need to be working for ALL factions as well as for MARINES
		if(roles_show & FLAG_SHOW_CIC && GLOB.ROLES_CIC.Find(J.title))
			dat += "Command:<br>"
			roles_show ^= FLAG_SHOW_CIC

		else if(roles_show & FLAG_SHOW_AUXIL_SUPPORT && GLOB.ROLES_AUXIL_SUPPORT.Find(J.title))
			dat += "<hr>Auxiliary Combat Support:<br>"
			roles_show ^= FLAG_SHOW_AUXIL_SUPPORT

		else if(roles_show & FLAG_SHOW_MISC && GLOB.ROLES_MISC.Find(J.title))
			dat += "<hr>Other:<br>"
			roles_show ^= FLAG_SHOW_MISC

		else if(roles_show & FLAG_SHOW_POLICE && GLOB.ROLES_POLICE.Find(J.title))
			dat += "<hr>Military Police:<br>"
			roles_show ^= FLAG_SHOW_POLICE

		else if(roles_show & FLAG_SHOW_ENGINEERING && GLOB.ROLES_ENGINEERING.Find(J.title))
			dat += "<hr>Engineering:<br>"
			roles_show ^= FLAG_SHOW_ENGINEERING

		else if(roles_show & FLAG_SHOW_REQUISITION && GLOB.ROLES_REQUISITION.Find(J.title))
			dat += "<hr>Requisitions:<br>"
			roles_show ^= FLAG_SHOW_REQUISITION

		else if(roles_show & FLAG_SHOW_MEDICAL && GLOB.ROLES_MEDICAL.Find(J.title))
			dat += "<hr>Medbay:<br>"
			roles_show ^= FLAG_SHOW_MEDICAL

		else if(roles_show & FLAG_SHOW_MARINES && GLOB.ROLES_MARINES.Find(J.title))
			dat += "<hr>Marines:<br>"
			roles_show ^= FLAG_SHOW_MARINES

		dat += "<a href='byond://?src=\ref[src];lobby_choice=SelectedJob;job_selected=[J.title]'>[J.disp_title] ([J.current_positions]) (Active: [active])</a><br>"
*/

	dat = "<html><body onselectstart='return false;'><center>"
	dat += "[user.client.auto_lang(LANGUAGE_LOBBY_ROUND_TIME)]: [DisplayTimeText(world.time, language = user.client.language)]<br>"
	dat += "[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_CHOSE)]:<br>"
	dat += additional_join_status(user)

	if(!latejoin_enabled)
		dat = "[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_CLOSED)]:<br>"

	else if(!SSautobalancer.can_join(src))
		dat = "[user.client.auto_lang(LANGUAGE_JS_BALANCE_ISSUE)]:<br>"

	else
		var/list/roles = roles_list[SSticker.mode.name]
		for(var/role in roles)
			var/datum/job/job = SSticker.role_authority.roles_by_name[role]
			var/check_result = SSticker.role_authority.check_role_entry(user, job, src, TRUE)
			var/active = 0
			for(var/mob/mob in GLOB.player_list)
				if(mob.client && mob.job == job.title)
					active++

			if(check_result)
				dat += "[job.disp_title] ([job.current_positions]): [check_result] ([user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_ACTIVE)]: [active])<br>"
			else
				dat += "<a href='byond://?src=\ref[user];lobby_choice=SelectedJob;job_selected=[job.title]'>[job.disp_title] ([job.current_positions]) ([user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_ACTIVE)]: [active])</a><br>"

	dat += "</center>"
	show_browser(user, dat, "Late Join", "latechoices", "size=420x700")

/datum/faction/proc/additional_join_status(mob/new_player/user, dat = "")
	return
/*
			if(roles_show & FLAG_SHOW_CIC && ROLES_CIC & job.title)
				dat += "<hr>[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_COM)]:<br>"
				roles_show ^= FLAG_SHOW_CIC

			else if(roles_show & FLAG_SHOW_AUXIL_SUPPORT && ROLES_AUXIL_SUPPORT & job.title)
				dat += "<hr>[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_SUP)]:<br>"
				roles_show ^= FLAG_SHOW_AUXIL_SUPPORT

			else if(roles_show & FLAG_SHOW_MISC && ROLES_MISC & job.title)
				dat += "<hr>[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_OTH)]:<br>"
				roles_show ^= FLAG_SHOW_MISC

			else if(roles_show & FLAG_SHOW_POLICE && ROLES_POLICE & job.title)
				dat += "<hr>[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_POL)]:<br>"
				roles_show ^= FLAG_SHOW_POLICE

			else if(roles_show & FLAG_SHOW_ENGINEERING && ROLES_ENGINEERING & job.title)
				dat += "<hr>[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_ENG)]:<br>"
				roles_show ^= FLAG_SHOW_ENGINEERING

			else if(roles_show & FLAG_SHOW_REQUISITION && ROLES_REQUISITION & job.title)
				dat += "<hr>[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_CAG)]:<br>"
				roles_show ^= FLAG_SHOW_REQUISITION

			else if(roles_show & FLAG_SHOW_MEDICAL && ROLES_MEDICAL & job.title)
				dat += "<hr>[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_MED)]:<br>"
				roles_show ^= FLAG_SHOW_MEDICAL

			else if(roles_show & FLAG_SHOW_MARINES && ROLES_MARINES & job.title)
				dat += "<hr>[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_MAR)]:<br>"
				roles_show ^= FLAG_SHOW_MARINES
*/
