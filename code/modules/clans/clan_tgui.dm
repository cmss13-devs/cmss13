/datum/yautja_panel
	var/client/linked_client
	var/current_clan_index = 0
	var/list/clan_name_to_index = list()
	var/list/clan_index_to_id = list()
	var/user_rights = 0
	var/user_clan_id
	var/current_clan_id
	var/list/global_data

GLOBAL_DATUM_INIT(yautja_clan_data, /datum/yautja_panel, new(init_global = TRUE))

/datum/yautja_panel/New(client/origin_client, init_global = FALSE)
	. = ..()
	if(origin_client)
		linked_client = origin_client
		user_rights = linked_client.clan_info.permissions
		user_clan_id = linked_client.clan_info.clan_id
	if(init_global)
		addtimer(CALLBACK(src, PROC_REF(populate_global_clan_data), TRUE), 30 SECONDS)

/client
	var/datum/yautja_panel/yautja_panel

/client/verb/yautja_panel()
	set name = "Yautja Clan Panel"
	set category = "OOC.Records"

	if(!check_whitelist_status(WHITELIST_PREDATOR))
		return FALSE

	if(!GLOB.yautja_clan_data.global_data)
		to_chat(usr, SPAN_WARNING("Clan Data has not populated yet, please wait for up to 30 seconds."))
		return FALSE

	if(yautja_panel)
		qdel(yautja_panel)
	yautja_panel = new(src)
	yautja_panel.tgui_interact(mob)

/datum/yautja_panel/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "YautjaClans", "Yautja Clan Panel")
		ui.open()

/datum/yautja_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/yautja_panel/ui_close(mob/user)
	. = ..()
	if(user?.client.yautja_panel)
		qdel(user.client.yautja_panel)

/datum/yautja_panel/vv_edit_var(var_name, var_value)
	return FALSE

/datum/yautja_panel/ui_data(mob/user)
	var/list/data = list()

	data["current_clan_index"] = current_clan_index

	data["user_is_clan_leader"] = verify_clan_leader(current_clan_id)
	data["user_is_council"] = verify_council()
	data["user_is_superadmin"] = verify_superadmin()

	return data

/datum/yautja_panel/ui_static_data()
	return GLOB.yautja_clan_data.global_data

/datum/yautja_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui.user

	switch (action)
		if("change_clan_list")
			var/new_clan = params["new_clan"]
			current_clan_index = GLOB.yautja_clan_data.clan_name_to_index[new_clan]
			current_clan_id = index_to_id(current_clan_index)

		if("change_rank")
			if(!verify_clan_leader(index_to_id(current_clan_index)))
				to_chat(user, SPAN_WARNING("You are not authorized to do this."))
				return FALSE

		if("assign_ancillary")
			if(!verify_clan_leader(index_to_id(current_clan_index)))
				to_chat(user, SPAN_WARNING("You are not authorized to do this."))
				return FALSE

		if("kick_from_clan")
			if(!verify_clan_leader(index_to_id(current_clan_index)))
				to_chat(user, SPAN_WARNING("You are not authorized to do this."))
				return FALSE

		if("banish_from_clan")
			if(!verify_clan_leader(index_to_id(current_clan_index)))
				to_chat(user, SPAN_WARNING("You are not authorized to do this."))
				return FALSE

	return TRUE

/datum/yautja_panel/proc/index_to_id(clan_index)
	var/index_holder = "[clan_index]"
	return GLOB.yautja_clan_data.clan_index_to_id[index_holder]

/datum/yautja_panel/proc/verify_clan_leader(clan_id)
	if(user_rights & CLAN_PERMISSION_ADMIN_ANCIENT)
		return TRUE
	if(user_clan_id == clan_id)
		return TRUE
	return FALSE

/datum/yautja_panel/proc/verify_council()
	if(user_rights & CLAN_PERMISSION_ADMIN_ANCIENT)
		return TRUE
	return FALSE

/datum/yautja_panel/proc/verify_superadmin()
	if(user_rights & CLAN_PERMISSION_ADMIN_MANAGER)
		return TRUE
	return FALSE

/datum/yautja_panel/proc/populate_global_clan_data(start_timer = FALSE)
	log_debug("Populating Yautja Clan Global Data.")
	global_data = populate_clan_data()
	log_debug("Yautja Clan Global Data has been populated.")
	if(start_timer)
		addtimer(CALLBACK(src, PROC_REF(populate_global_clan_data), TRUE), 30 MINUTES)
		log_debug("Yautja Clan Global Data will repopulate in 30 minutes.")

/datum/yautja_panel/proc/populate_clan_data()
	clan_name_to_index = list("Clanless" = 0)
	clan_index_to_id = list("0" = 0)
	var/clan_names = list("Clanless")
	var/index = 1
	var/list/data = list()
	data["clans"] = list()

	data["clans"] += list(populate_clan("Clanless", null))
	var/list/datum/view_record/clan_view/clan_list = DB_VIEW(/datum/view_record/clan_view/)
	for(var/datum/view_record/clan_view/viewed_clan in clan_list)
		data["clans"] += list(populate_clan("[viewed_clan.name]", viewed_clan.clan_id))
		clan_index_to_id["[index]"] = viewed_clan.clan_id
		clan_name_to_index[viewed_clan.name] = index
		index++
		clan_names += viewed_clan.name

	data["clan_names"] = clan_names
	return data

/datum/yautja_panel/proc/populate_clan(clan_name, clan_to_format)
	var/list/data = list()

	var/datum/entity/clan/formatting_clan
	var/list/datum/view_record/clan_playerbase_view/clan_view
	var/clan_desc = "This is a list of players without a clan"
	if(clan_to_format)
		formatting_clan = GET_CLAN(clan_to_format)
		formatting_clan.sync()
		clan_desc = html_encode(formatting_clan.description)
		clan_view = DB_VIEW(/datum/view_record/clan_playerbase_view, DB_COMP("clan_id", DB_EQUALS, clan_to_format))
	else
		clan_view = DB_VIEW(/datum/view_record/clan_playerbase_view, DB_COMP("clan_id", DB_IS, null))

	var/list/members_list = list()
	for(var/datum/view_record/clan_playerbase_view/CP in clan_view)

		var/yautja = list()
		yautja["ckey"] = CP.ckey
		yautja["player_label"] = CP.ckey
		yautja["name"] = (CP.player_name? CP.player_name : "No Data")
		yautja["player_id"] = CP.player_id
		yautja["rank"] = GLOB.clan_ranks[CP.clan_rank]

		var/datum/entity/player/player = get_player_from_key(CP.ckey)
		if(player.check_whitelist_status(WHITELIST_YAUTJA_LEADER))
			yautja["player_label"] = "[CP.ckey] (SENATOR)"
		else if(player.check_whitelist_status(WHITELIST_YAUTJA_COUNCIL))
			yautja["player_label"] = "[CP.ckey] (COUNCILLOR)"

		members_list += list(yautja)

	data["label"] = clan_name
	data["desc"] = clan_desc
	data["color"] = (formatting_clan?.color? formatting_clan.color : "#ffffff")
	data["members"] = members_list
	if(clan_to_format)
		data["clan_id"] = clan_to_format

	return data
