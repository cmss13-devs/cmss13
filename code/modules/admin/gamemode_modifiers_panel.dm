/client
	var/datum/modifiers_panel/modifiers_panel

/client/proc/modifiers_panel()
	set name = "Modifiers Panel"
	set category = "Admin.Panels"

	if(!SSticker.mode)
		to_chat(mob, SPAN_WARNING("The round has not started yet."))
		return

	if(modifiers_panel)
		qdel(modifiers_panel)
	modifiers_panel = new
	modifiers_panel.tgui_interact(mob)

/datum/modifiers_panel
	var/target_modifier
	var/new_state

/datum/modifiers_panel/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ModifiersPanel", "Modifiers Panel")
		ui.open()

/datum/modifiers_panel/ui_state(mob/user)
	return GLOB.admin_state

/datum/modifiers_panel/ui_close(mob/user)
	. = ..()
	if(user?.client.modifiers_panel)
		qdel(user.client.modifiers_panel)

/datum/modifiers_panel/ui_data(mob/user)
	var/list/data = list()
	data["target_modifier"] = target_modifier
	data["new_state"] = new_state
	return data

/datum/modifiers_panel/ui_static_data(mob/user)
	var/list/data = list()
	var/list/modifiers = list()
	var/list/round_modifiers = SSticker.mode.round_modifiers
	for(var/modifier_type in round_modifiers)
		var/datum/gamemode_modifier/modifier = round_modifiers[modifier_type]
		var/list/modifier_info = list()
		modifier_info["path"] = modifier_type
		modifier_info["name"] = modifier.modifier_name
		modifier_info["desc"] = modifier.modifier_desc
		modifier_info["state"] = modifier.active
		modifiers += list(modifier_info)

	data["all_modifiers"] = modifiers
	return data

/datum/modifiers_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return FALSE
	var/mob/user = ui.user
	if(!CLIENT_HAS_RIGHTS(user.client, R_MOD))
		return FALSE

	if(action != "set_modifier_state")
		return FALSE

	message_admins("[key_name_admin(user)] has [params["state"] ? "enabled" : "disabled" ] [params["name"]] modifier.")
	MODE_SET_MODIFIER(text2path(params["path"]), params["state"])
	update_static_data(user, ui)
