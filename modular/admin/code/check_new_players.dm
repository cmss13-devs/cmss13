/client/proc/check_new_players()
	set name = "Check New Players"
	set category = "Admin"

	if(!check_rights(R_MOD))
		return

	if(admin_holder)
		admin_holder.check_new_players()
	return

/datum/admins/proc/check_new_players()
	var/datum/check_new_players/check_new_players = new
	check_new_players.tgui_interact(owner.mob)

/datum/check_new_players

/datum/check_new_players/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "CheckNewPlayers", "Check New Players")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/check_new_players/ui_state(mob/user)
	return GLOB.admin_state

/datum/check_new_players/ui_data(mob/user)
	. = ..()

	.["new_players"] = list()
	for(var/client/client in GLOB.clients)
		var/time_first_join = text2time(client.player_data.first_join_date)
		var/days_first_join = floor(days_from_time(time_first_join))
		var/client_hours = round(client.get_total_human_playtime() DECISECONDS_TO_HOURS, 0.1) + round(client.get_total_xeno_playtime() DECISECONDS_TO_HOURS, 0.1)
		.["new_players"] += list(
			list(
			"ckey" = client.ckey,
			"client_hours" = client_hours,
			"first_join" = client.player_data.first_join_date,
			"days_first_join" = days_first_join,
			"byond_account_age" = client.player_data.byond_account_age,
			)
		)

/datum/check_new_players/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	if(!CLIENT_IS_STAFF(ui.user.client))
		return

	switch(action)
		if("open_player_panel")
			var/client/target_client = find_client_by_ckey(params["ckey"])
			if(!target_client)
				return
			GLOB.admin_datums[ui.user.client.ckey].show_player_panel(target_client.mob)
		if("follow")
			if(!isobserver(ui.user))
				tgui_alert(ui.user, "Нужно быть гостом","Follow")
				return
			var/client/target_client = find_client_by_ckey(params["ckey"])
			if(!target_client)
				return
			var/mob/dead/observer/observer = ui.user
			observer.do_observe(target_client.mob)
		if("update")
			SStgui.try_update_ui(ui.user, src, ui)
		else
			tgui_alert(ui.user, "Fuck")

/datum/check_new_players/proc/find_client_by_ckey(ckey)
	for(var/client/client in GLOB.clients)
		if(client.ckey != ckey)
			continue
		return client
