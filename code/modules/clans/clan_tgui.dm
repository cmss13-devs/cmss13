/datum/yautja_panel
	var/viewed_player = list()
	var/current_menu = "view_clans"
	var/user_rights = 0
	var/target_rights = 0
	var/new_rights = 0

/client
	var/datum/yautja_panel/yautja_panel

/client/verb/yautja_panel()
	set name = "Yautja Clan Panel"
	set category = "OOC.Records"

	if(yautja_panel)
		qdel(yautja_panel)
	yautja_panel = new
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

	data["current_menu"] = current_menu

	return data

/datum/yautja_panel/ui_static_data()
	var/list/data = list()
	data["clans"] = list()

	var/list/datum/view_record/clan_view/clan_list = DB_VIEW(/datum/view_record/clan_view/)
	for(var/datum/view_record/clan_view/viewed_clan in clan_list)
		data["clans"] += list(populate_clan("[viewed_clan.name]", viewed_clan.clan_id))

	return data

/datum/yautja_panel/proc/populate_clan(clan_name, clan_to_format)
	var/list/data = list()

	var/datum/entity/clan/formatting_clan
	var/list/datum/view_record/clan_playerbase_view/clan_view

	if(clan_to_format)
		formatting_clan = GET_CLAN(clan_to_format)
		formatting_clan.sync()
		clan_view = DB_VIEW(/datum/view_record/clan_playerbase_view, DB_COMP("clan_id", DB_EQUALS, clan_to_format))
	else
		clan_view = DB_VIEW(/datum/view_record/clan_playerbase_view, DB_COMP("clan_id", DB_IS, clan_to_format))

	var/list/formatted_clan = list()
	for(var/datum/view_record/clan_playerbase_view/CP in clan_view)
		var/yautja = list()
		yautja["ckey"] = CP.ckey
		yautja["player_id"] = CP.player_id
		yautja["rank"] = GLOB.clan_ranks[CP.clan_rank]
		yautja["honor_amount"] = (CP.honor? CP.honor : 0)
		//yautja["rank_pos"] = rank_to_give
		formatted_clan += list(yautja)

	data["label"] = clan_name
	data["clan"] = formatted_clan

	return data

/datum/yautja_panel/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch (action)
		if ("set_menu")
			current_menu = params["new_menu"]

		if ("main_menu")
			current_menu = "main"

		if ("view_clans")
			current_menu = "view_clans"
	return TRUE
