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
	if(player.check_whitelist_status(WHITELIST_FAX_RESPONDER))
		LAZYADD(., "responder")

/client
	var/datum/whitelist_panel/wl_panel

/client/proc/whitelist_panel()
	set name = "Whitelist Panel"
	set category = "OOC.Whitelist"

	if(wl_panel)
		qdel(wl_panel)
	wl_panel = new
	wl_panel.tgui_interact(mob)

#define WL_PANEL_RIGHT_CO (1<<0)
#define WL_PANEL_RIGHT_SYNTH (1<<1)
#define WL_PANEL_RIGHT_YAUTJA (1<<2)
#define WL_PANEL_RIGHT_MENTOR (1<<3)
#define WL_PANEL_RIGHT_OVERSEER (1<<4)
#define WL_PANEL_RIGHT_MANAGER (1<<5)
#define WL_PANEL_ALL_COUNCILS (WL_PANEL_RIGHT_CO|WL_PANEL_RIGHT_SYNTH|WL_PANEL_RIGHT_YAUTJA)
#define WL_PANEL_RIGHTS_OVERSEER (WL_PANEL_RIGHT_CO|WL_PANEL_RIGHT_SYNTH|WL_PANEL_RIGHT_YAUTJA|WL_PANEL_RIGHT_OVERSEER)
#define WL_PANEL_ALL_RIGHTS (WL_PANEL_RIGHT_CO|WL_PANEL_RIGHT_SYNTH|WL_PANEL_RIGHT_YAUTJA|WL_PANEL_RIGHT_MENTOR|WL_PANEL_RIGHT_OVERSEER|WL_PANEL_RIGHT_MANAGER)

/datum/whitelist_panel
	var/viewed_player = list()
	var/current_menu = "Panel"
	var/user_rights = 0
	var/target_rights = 0
	var/new_rights = 0

/datum/whitelist_panel/proc/get_user_rights(mob/user)
	if(!user.client)
		return
	var/client/person = user.client
	if(CLIENT_HAS_RIGHTS(person, R_PERMISSIONS))
		return WL_PANEL_ALL_RIGHTS
	var/rights
	if(person.check_whitelist_status(WHITELIST_COMMANDER_LEADER))
		rights |= WL_PANEL_RIGHT_CO
	if(person.check_whitelist_status(WHITELIST_SYNTHETIC_LEADER))
		rights |= WL_PANEL_RIGHT_SYNTH
	if(person.check_whitelist_status(WHITELIST_YAUTJA_LEADER))
		rights |= WL_PANEL_RIGHT_YAUTJA
	if(rights == WL_PANEL_ALL_COUNCILS)
		rights |= WL_PANEL_RIGHTS_OVERSEER
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
	if(user?.client.wl_panel)
		qdel(user.client.wl_panel)

/datum/whitelist_panel/vv_edit_var(var_name, var_value)
	return FALSE

/datum/whitelist_panel/ui_data(mob/user)
	var/list/data = list()

	data["current_menu"] = current_menu
	data["user_rights"] = user_rights
	data["viewed_player"] = viewed_player
	data["target_rights"] = target_rights
	data["new_rights"] = new_rights

	return data

GLOBAL_LIST_INIT(co_flags, list(
	list(name = "Commander", bitflag = WHITELIST_COMMANDER, permission = WL_PANEL_RIGHT_CO),
	list(name = "Council", bitflag = WHITELIST_COMMANDER_COUNCIL, permission = WL_PANEL_RIGHT_CO),
	list(name = "Legacy Council", bitflag = WHITELIST_COMMANDER_COUNCIL_LEGACY, permission = WL_PANEL_RIGHT_CO),
	list(name = "Senator", bitflag = WHITELIST_COMMANDER_LEADER, permission = WL_PANEL_RIGHT_OVERSEER),
	list(name = "Colonel", bitflag = WHITELIST_COMMANDER_COLONEL, permission = WL_PANEL_RIGHT_OVERSEER)
))
GLOBAL_LIST_INIT(syn_flags, list(
	list(name = "Synthetic", bitflag = WHITELIST_SYNTHETIC, permission = WL_PANEL_RIGHT_SYNTH),
	list(name = "Council", bitflag = WHITELIST_SYNTHETIC_COUNCIL, permission = WL_PANEL_RIGHT_SYNTH),
	list(name = "Legacy Council", bitflag = WHITELIST_SYNTHETIC_COUNCIL_LEGACY, permission = WL_PANEL_RIGHT_SYNTH),
	list(name = "Senator", bitflag = WHITELIST_SYNTHETIC_LEADER, permission = WL_PANEL_RIGHT_OVERSEER)
))
GLOBAL_LIST_INIT(yaut_flags, list(
	list(name = "Yautja", bitflag = WHITELIST_YAUTJA, permission = WL_PANEL_RIGHT_YAUTJA),
	list(name = "Legacy Holder", bitflag = WHITELIST_YAUTJA_LEGACY, permission = WL_PANEL_RIGHT_MANAGER),
	list(name = "Council", bitflag = WHITELIST_YAUTJA_COUNCIL, permission = WL_PANEL_RIGHT_YAUTJA),
	list(name = "Legacy Council", bitflag = WHITELIST_YAUTJA_COUNCIL_LEGACY, permission = WL_PANEL_RIGHT_YAUTJA),
	list(name = "Senator", bitflag = WHITELIST_YAUTJA_LEADER, permission = WL_PANEL_RIGHT_OVERSEER)
))
GLOBAL_LIST_INIT(misc_flags, list(
	list(name = "Senior Enlisted Advisor", bitflag = WHITELIST_MENTOR, permission = WL_PANEL_RIGHT_MENTOR),
	list(name = "Working Joe", bitflag = WHITELIST_JOE, permission = WL_PANEL_RIGHT_SYNTH),
	list(name = "Dzho Automaton", bitflag = WHITELIST_JOE, permission = WL_PANEL_RIGHT_SYNTH),
	list(name = "Fax Responder", bitflag = WHITELIST_FAX_RESPONDER, permission = WL_PANEL_RIGHT_MANAGER),
))

/datum/whitelist_panel/ui_static_data(mob/user)
	. = list()
	.["co_flags"] = GLOB.co_flags
	.["syn_flags"] = GLOB.syn_flags
	.["yaut_flags"] = GLOB.yaut_flags
	.["misc_flags"] = GLOB.misc_flags

	var/list/datum/view_record/players/players_view = DB_VIEW(/datum/view_record/players, DB_COMP("whitelist_status", DB_NOTEQUAL, ""))

	var/list/whitelisted_players = list()
	for(var/datum/view_record/players/whitelistee in players_view)
		var/list/current_player = list()
		current_player["ckey"] = whitelistee.ckey
		var/list/unreadable_list = splittext(whitelistee.whitelist_status, "|")
		var/readable_list = unreadable_list.Join(" | ")
		current_player["status"] = readable_list
		whitelisted_players += list(current_player)
	.["whitelisted_players"] = whitelisted_players

/datum/whitelist_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return FALSE
	var/mob/user = ui.user
	if(!isSenator(user.client) && !CLIENT_HAS_RIGHTS(user.client, R_PERMISSIONS))
		return FALSE
	switch(action)
		if("go_back")
			go_back()
		if("select_player")
			select_player(user, params["player"])
			return
		if("add_player")
			select_player(user, TRUE)
			return
		if("update_number")
			new_rights = text2num(params["wl_flag"])
			return
		if("update_perms")
			var/player_key = params["player"]
			var/reason = tgui_input_text(user, "What is the reason for this change?", "Update Reason")
			if(!reason)
				return
			var/datum/entity/player/player = get_player_from_key(player_key)
			player.set_whitelist_status(new_rights)
			player.add_note("Whitelists updated by [user.key]. Reason: '[reason]'.", FALSE, NOTE_WHITELIST)
			to_chat(user, SPAN_HELPFUL("Whitelists for [player_key] updated."))
			message_admins("Whitelists for [player_key] updated by [key_name(user)]. Reason: '[reason]'.")
			log_admin("WHITELISTS: Flags for [player_key] changed from [target_rights] to [new_rights]. Reason: '[reason]'.")
			go_back()
			update_static_data(user, ui)
			return
		if("refresh_data")
			update_static_data(user, ui)
			to_chat(user, SPAN_NOTICE("Whitelist data refreshed."))

/datum/whitelist_panel/proc/select_player(mob/user, player_key)
	var/target_key = player_key
	if(IsAdminAdvancedProcCall())
		return PROC_BLOCKED
	if(!target_key)
		return FALSE

	if(target_key == TRUE)
		var/new_player = tgui_input_text(user, "Enter the new ckey you wish to add. Do not include spaces or special characters.", "New Whitelistee")
		if(!new_player)
			return FALSE
		target_key = new_player

	var/datum/entity/player/player = get_player_from_key(target_key)
	var/list/current_player = list()
	current_player["ckey"] = target_key
	current_player["status"] = player.whitelist_status

	target_rights = player.whitelist_flags
	new_rights = player.whitelist_flags
	viewed_player = current_player
	current_menu = "Update"
	user_rights = get_user_rights(user)
	return

/datum/whitelist_panel/proc/go_back()
	viewed_player = list()
	user_rights = 0
	current_menu = "Panel"
	target_rights = 0
	new_rights = 0


#undef WL_PANEL_RIGHT_CO
#undef WL_PANEL_RIGHT_SYNTH
#undef WL_PANEL_RIGHT_YAUTJA
#undef WL_PANEL_RIGHT_MENTOR
#undef WL_PANEL_RIGHT_OVERSEER
#undef WL_PANEL_ALL_RIGHTS
