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

#define WL_PANEL_RIGHT_CO (1<<0)
#define WL_PANEL_RIGHT_SYNTH (1<<1)
#define WL_PANEL_RIGHT_YAUTJA (1<<2)
#define WL_PANEL_RIGHT_MENTOR (1<<3)
#define WL_PANEL_RIGHT_OVERSEER (1<<4)
#define WL_PANEL_ALL_RIGHTS (WL_PANEL_RIGHT_CO|WL_PANEL_RIGHT_SYNTH|WL_PANEL_RIGHT_YAUTJA|WL_PANEL_RIGHT_MENTOR|WL_PANEL_RIGHT_OVERSEER)

/datum/whitelist_panel
	var/viewed_player = list()
	var/current_menu = "Panel"
	var/used_by
	var/user_rights = 0
	var/target_rights = 0
	var/new_rights = 0

/datum/whitelist_panel/proc/get_user_rights(mob/user)
	if(!user.client)
		return
	var/client/person = user.client
	if(CLIENT_HAS_RIGHTS(person, R_PERMISSIONS) || person.check_whitelist_status(WHITELISTS_LEADER))
		return WL_PANEL_ALL_RIGHTS
	var/rights
	if(person.check_whitelist_status(WHITELIST_COMMANDER_LEADER))
		rights |= WL_PANEL_RIGHT_CO
	if(person.check_whitelist_status(WHITELIST_SYNTHETIC_LEADER))
		rights |= WL_PANEL_RIGHT_SYNTH
	if(person.check_whitelist_status(WHITELIST_YAUTJA_LEADER))
		rights |= WL_PANEL_RIGHT_YAUTJA
	return rights

/datum/whitelist_panel/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "WhitelistPanel", "Whitelist Panel")
		ui.open()

/datum/whitelist_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/whitelist_panel/ui_close(mob/user)
	. = ..()
	if(used_by)
		used_by = null
	viewed_player = list()
	user_rights = 0
	current_menu = "Panel"
	target_rights = 0
	new_rights = 0

/datum/whitelist_panel/ui_data(mob/user)
	var/list/data = list()

	data["current_menu"] = current_menu
	data["user_rights"] = user_rights
	data["viewed_player"] = viewed_player
	data["target_rights"] = target_rights
	data["new_rights"] = new_rights

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
	list(name = "Commander", bitflag = WHITELIST_COMMANDER, permission = WL_PANEL_RIGHT_CO),
	list(name = "CO Council", bitflag = WHITELIST_COMMANDER_COUNCIL, permission = WL_PANEL_RIGHT_CO),
	list(name = "Legacy CO Council", bitflag = WHITELIST_COMMANDER_COUNCIL_LEGACY, permission = WL_PANEL_RIGHT_CO),
	list(name = "CO Senator", bitflag = WHITELIST_COMMANDER_LEADER, permission = WL_PANEL_RIGHT_OVERSEER)
))
GLOBAL_LIST_INIT(syn_flags, list(
	list(name = "Synethetic", bitflag = WHITELIST_SYNTHETIC, permission = WL_PANEL_RIGHT_SYNTH),
	list(name = "Synthetic Council", bitflag = WHITELIST_SYNTHETIC_COUNCIL, permission = WL_PANEL_RIGHT_SYNTH),
	list(name = "Legacy Synthetic Council", bitflag = WHITELIST_SYNTHETIC_COUNCIL_LEGACY, permission = WL_PANEL_RIGHT_SYNTH),
	list(name = "Synthetic Senator", bitflag = WHITELIST_SYNTHETIC_LEADER, permission = WL_PANEL_RIGHT_OVERSEER)
))
GLOBAL_LIST_INIT(yaut_flags, list(
	list(name = "Yautja", bitflag = WHITELIST_YAUTJA, permission = WL_PANEL_RIGHT_YAUTJA),
	list(name = "Legacy Yautja", bitflag = WHITELIST_YAUTJA_LEGACY, permission = WL_PANEL_RIGHT_OVERSEER),
	list(name = "Yautja Council", bitflag = WHITELIST_YAUTJA_COUNCIL, permission = WL_PANEL_RIGHT_YAUTJA),
	list(name = "Legacy Yautja Council", bitflag = WHITELIST_YAUTJA_COUNCIL_LEGACY, permission = WL_PANEL_RIGHT_YAUTJA),
	list(name = "Yautja Senator", bitflag = WHITELIST_YAUTJA_LEADER, permission = WL_PANEL_RIGHT_OVERSEER)
))
GLOBAL_LIST_INIT(misc_flags, list(
	list(name = "Senior Enlisted Advisor", bitflag = WHITELIST_MENTOR, permission = WL_PANEL_RIGHT_MENTOR),
	list(name = "Working Joe", bitflag = WHITELIST_JOE, permission = WL_PANEL_RIGHT_SYNTH),
))

/datum/whitelist_panel/ui_static_data(mob/user)
	. = list()
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
		if("go_back")
			if(used_by)
				used_by = null
			viewed_player = list()
			user_rights = 0
			current_menu = "Panel"
			target_rights = 0
			new_rights = 0
		if("select_player")
			if(used_by && (used_by != user.ckey))
				to_chat(user, SPAN_ALERTWARNING("Panel already in use by [used_by]"))
				var/override_option = tgui_alert(user, "The Whitelist Panel is in use by [used_by]. Do you want to override?", "Use Panel", list("Override", "Cancel"))
				if(override_option != "Override")
					return

			var/datum/entity/player/player = get_player_from_key(params["player"])
			var/list/current_player = list()
			current_player["ckey"] = params["player"]
			current_player["status"] = player.whitelist_status

			target_rights = player.whitelist_flags
			new_rights = player.whitelist_flags
			viewed_player = current_player
			current_menu = "Update"
			user_rights = get_user_rights(user)
			used_by = user.ckey
			return
		if("update_number")
			new_rights = text2num(params["wl_flag"])
			return
		if("update_perms")
			var/datum/entity/player/player = get_player_from_key(params["player"])
			player.set_whitelist_status(new_rights)
			message_admins("Whitelists updated.")
			return


#undef WHITELISTFILE
#undef WL_PANEL_RIGHT_CO
#undef WL_PANEL_RIGHT_SYNTH
#undef WL_PANEL_RIGHT_YAUTJA
#undef WL_PANEL_RIGHT_MENTOR
#undef WL_PANEL_RIGHT_OVERSEER
#undef WL_PANEL_ALL_RIGHTS
