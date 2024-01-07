#define WHITELISTFILE "data/whitelist.txt"

GLOBAL_LIST_FILE_LOAD(whitelist, WHITELISTFILE)

/proc/check_whitelist(mob/M /*, rank*/)
	if(!CONFIG_GET(flag/usewhitelist) || !GLOB.whitelist)
		return 0
	return ("[M.ckey]" in GLOB.whitelist)

/proc/can_play_special_job(client/client, job)
	if(client.admin_holder && (client.admin_holder.rights & R_ADMIN))
		return TRUE
	if(job == XENO_CASTE_QUEEN)
		var/datum/caste_datum/C = GLOB.RoleAuthority.castes_by_name[XENO_CASTE_QUEEN]
		return C.can_play_caste(client)
	if(job == JOB_SURVIVOR)
		var/datum/job/J = GLOB.RoleAuthority.roles_by_path[/datum/job/civilian/survivor]
		return J.can_play_role(client)
	return TRUE

/// returns a list of strings containing the whitelists held by a specific ckey
/proc/get_whitelisted_roles(ckey)
	var/datum/entity/player/player = get_player_from_key(ckey)
	if(player.check_whitelist_status(WHITELIST_YAUTJA))
		LAZYADD(., "predator")
	if(player.check_whitelist_status(WHITELIST_COMMANDER))
		LAZYADD(., "commander")
	if(player.check_whitelist_status(WHITELIST_SYNTHETIC))
		LAZYADD(., "synthetic")

/client/proc/whitelist_panel()
	set name = "Whitelist Panel"
	set category = "Admin.Panels"

	var/data = "<hr><b>Whitelists:</b> <a href='?src=\ref[src];[HrefToken()];change_whitelist=[TRUE]'>Add Whitelist</a> <hr><table border=1 rules=all frame=void cellspacing=0 cellpadding=3>"

	var/list/datum/view_record/players/players_view = DB_VIEW(/datum/view_record/players, DB_COMP("whitelist_status", DB_NOTEQUAL, ""))

	for(var/datum/view_record/players/whitelistee in players_view)
		data += "<tr><td> <a href='?src=\ref[src];[HrefToken()];change_whitelist=[whitelistee.ckey]'>(CHANGE)</a> Key: <b>[whitelistee.ckey]</b></td> <td>Whitelists: [whitelistee.whitelist_status]</td></tr>"

	data += "</table>"

	show_browser(usr, data, "Whitelist Panel", "whitelist_panel", "size=857x400")

/client/load_player_data_info(datum/entity/player/player)
	. = ..()

	if(WHITELISTS_LEADER & player.whitelist_flags)
		add_verb(src, /client/proc/whitelist_panel)

/*
target.client.prefs.muted = text2num(params["mute_flag"])
	log_admin("[key_name(user)] set the mute flags for [key_name(target)] to [target.client.prefs.muted].")
	return TRUE
*/

/client/proc/whitelist_panel_tgui()
	set name = "Whitelist TGUI Panel"
	set category = "Admin.Panels"
	if(!SSticker.mode)
		to_chat(usr, SPAN_WARNING("The round has not started yet."))
		return FALSE

	GLOB.WhitelistPanel.tgui_interact(mob)
	var/mob/user = usr
	var/log = "[key_name(user)] opened the Whitelist Panel."
	message_admins(log)

GLOBAL_DATUM_INIT(WhitelistPanel, /datum/whitelist_panel, new)

/datum/whitelist_panel
	var/viewed_player = list()
	var/current_menu = "Panel"
	var/used_by
	var/user_rights

#define PANEL_RIGHT_CO (1<<0)
#define PANEL_RIGHT_SYNTH (1<<1)
#define PANEL_RIGHT_YAUTJA (1<<2)
#define PANEL_RIGHT_MENTOR (1<<3)
#define PANEL_RIGHT_OVERSEER (1<<4)
#define PANEL_ALL_RIGHTS (PANEL_RIGHT_CO|PANEL_RIGHT_SYNTH|PANEL_RIGHT_YAUTJA|PANEL_RIGHT_MENTOR|PANEL_RIGHT_OVERSEER)

/datum/whitelist_panel/proc/get_user_rights(mob/user)
	if(!user.client)
		return
	var/client/person = user.client
	if(CLIENT_HAS_RIGHTS(person, R_PERMISSIONS) || person.check_whitelist_status(WHITELISTS_LEADER))
		return PANEL_ALL_RIGHTS
	var/rights
	if(person.check_whitelist_status(WHITELIST_COMMANDER_LEADER))
		rights |= PANEL_RIGHT_CO
	if(person.check_whitelist_status(WHITELIST_SYNTHETIC_LEADER))
		rights |= PANEL_RIGHT_SYNTH
	if(person.check_whitelist_status(WHITELIST_YAUTJA_LEADER))
		rights |= PANEL_RIGHT_YAUTJA
	return rights

/datum/whitelist_panel/tgui_interact(mob/user, datum/tgui/ui, datum/ui_state/state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "WhitelistPanel", "Whitelist Panel")
		ui.open()

/datum/whitelist_panel/ui_close(mob/user)
	. = ..()
	if(used_by)
		used_by = null
	viewed_player = list()

/datum/whitelist_panel/ui_data(mob/user)
	var/list/data = list()

	data["current_menu"] = current_menu
	data["viewed_player"] = viewed_player

	var/list/datum/view_record/players/players_view = DB_VIEW(/datum/view_record/players, DB_COMP("whitelist_status", DB_NOTEQUAL, ""))

	var/list/whitelisted_players = list()
	for(var/datum/view_record/players/whitelistee in players_view)
		var/list/current_player = list()
		current_player["ckey"] = whitelistee.ckey
		current_player["status"] = whitelistee.whitelist_status
		whitelisted_players += list(current_player)
	data["whitelisted_players"] = whitelisted_players

	return data

GLOBAL_LIST_INIT(co_flags, list(
	list(name = "Whitelisted", bitflag = WHITELIST_COMMANDER, permission = PANEL_RIGHT_CO),
	list(name = "Council", bitflag = WHITELIST_COMMANDER_COUNCIL, permission = PANEL_RIGHT_CO),
	list(name = "Legacy Council", bitflag = WHITELIST_COMMANDER_COUNCIL_LEGACY, permission = PANEL_RIGHT_CO),
	list(name = "Senator", bitflag = WHITELIST_COMMANDER_LEADER, permission = PANEL_RIGHT_OVERSEER)
))
GLOBAL_LIST_INIT(syn_flags, list(
	list(name = "Whitelisted", bitflag = WHITELIST_SYNTHETIC, permission = PANEL_RIGHT_SYNTH),
	list(name = "Council", bitflag = WHITELIST_SYNTHETIC_COUNCIL, permission = PANEL_RIGHT_SYNTH),
	list(name = "Legacy Council", bitflag = WHITELIST_SYNTHETIC_COUNCIL_LEGACY, permission = PANEL_RIGHT_SYNTH),
	list(name = "Senator", bitflag = WHITELIST_SYNTHETIC_LEADER, permission = PANEL_RIGHT_OVERSEER)
))
GLOBAL_LIST_INIT(yaut_flags, list(
	list(name = "Whitelisted", bitflag = WHITELIST_YAUTJA, permission = PANEL_RIGHT_YAUTJA),
	list(name = "Legacy", bitflag = WHITELIST_YAUTJA_LEGACY, permission = PANEL_RIGHT_OVERSEER),
	list(name = "Council", bitflag = WHITELIST_YAUTJA_COUNCIL, permission = PANEL_RIGHT_YAUTJA),
	list(name = "Legacy Council", bitflag = WHITELIST_YAUTJA_COUNCIL_LEGACY, permission = PANEL_RIGHT_YAUTJA),
	list(name = "Senator", bitflag = WHITELIST_YAUTJA_LEADER, permission = PANEL_RIGHT_OVERSEER)
))
GLOBAL_LIST_INIT(misc_flags, list(
	list(name = "Senior Enlisted Advisor", bitflag = WHITELIST_MENTOR, permission = PANEL_RIGHT_MENTOR),
	list(name = "Working Joe", bitflag = WHITELIST_JOE, permission = PANEL_RIGHT_SYNTH),
))

/datum/whitelist_panel/ui_static_data(mob/user)
	. = list()
	.["glob_mute_bits"] = GLOB.mute_bits
	.["co_flags"] = GLOB.co_flags
	.["syn_flags"] = GLOB.syn_flags
	.["yaut_flags"] = GLOB.yaut_flags
	.["misc_flags"] = GLOB.misc_flags

/datum/whitelist_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	switch(action)
		if("select_player")
			if(used_by != user.ckey)
				to_chat(user, SPAN_ALERTWARNING("Panel already in use by [used_by]"))
				var/override_option = tgui_alert(user, "The Whitelist Panel is in use by [used_by]. Do you want to override?", "Use Panel", list("Override", "Cancel"))
				if(override_option != "Override")
					return

			var/datum/entity/player/player = get_player_from_key(params["player"])
			var/list/current_player = list()
			current_player["ckey"] = params["player"]
			current_player["status"] = player.whitelist_status
			current_player["flags"] = player.whitelist_flags

			viewed_player = current_player
			current_menu = "Update"
			user_rights = get_user_rights(user)
			used_by = user.ckey

/*
/proc/update_whitelist()
	if(!CLIENT_HAS_RIGHTS(src, R_PERMISSIONS) && !check_whitelist_status(WHITELISTS_LEADER))
		return

	var/target_ckey = href_list["change_whitelist"]
	if(target_ckey == "[TRUE]")
		target_ckey = ckey(tgui_input_text(usr, "Which CKEY do you want to edit?", "Select CKEY"))

		if(!target_ckey || target_ckey == TRUE)
			return

	var/datum/entity/player/player = get_player_from_key(ckey)
	var/can_edit = list()
	for(var/bitfield in GLOB.whitelist_permissions)
		if(player.whitelist_flags & bitfield)
			can_edit += GLOB.whitelist_permissions[bitfield]
	if(!length(can_edit))
		can_edit = null

	var/flags = input_bitfield(usr, "Select Flags", "whitelist_status", player.whitelist_flags, allowed_edit_list = can_edit)
	player.set_whitelist_status(flags)
*/




#undef WHITELISTFILE
