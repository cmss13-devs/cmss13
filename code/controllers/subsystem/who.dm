SUBSYSTEM_DEF(who)
	name = "Who"
	flags = SS_BACKGROUND
	runlevels = RUNLEVELS_DEFAULT|RUNLEVEL_LOBBY
	init_order = SS_INIT_WHO
	wait = 5 SECONDS

	var/datum/player_list/who = new
	var/datum/player_list/staff/staff_who = new

/datum/controller/subsystem/who/Initialize()
	who.update_data()
	staff_who.update_data()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/who/fire(resumed = TRUE)
	who.update_data()
	staff_who.update_data()



// WHO DATA
/datum/player_list
	var/tgui_name = "Who"
	var/tgui_interface_name = "Who"
	var/list/base_data = list()
	var/list/admin_sorted_additional = list()

/datum/player_list/proc/update_data()
	var/list/base_data = list()
	var/list/admin_sorted_additional = list()

	var/list/factions_additional = list()
	admin_sorted_additional["factions_additional"] = list("flags" = R_MOD|R_ADMIN, "data" = factions_additional)

	var/list/player_additional = list()
	admin_sorted_additional["player_additional"] = list("flags" = R_MOD|R_ADMIN, "data" = player_additional)

	var/list/player_stealthed_additional = list()
	admin_sorted_additional["player_stealthed_additional"] = list("flags" = R_STEALTH, "data" = player_stealthed_additional)

	var/list/counted_additional = list(
		"lobby" = 0,
		"admin_observers" = 0,
		"observers" = 0,
		"yautja" = 0,
		"infected_preds" = 0,
		"humans" = 0,
		"infected_humans" = 0,
		"uscm" = 0,
		"uscm_marines" = 0,
	)
	var/list/counted_factions = list()

	// Running thru all clients and doing some counts
	for(var/client/client as anything in sortTim(GLOB.clients, GLOBAL_PROC_REF(cmp_ckey_asc)))
		var/list/client_payload = list()
		client_payload["text"] = client.key
		client_payload["ckey_color"] = "white"
		if(CLIENT_IS_STEALTHED(client))
			player_stealthed_additional["total_players"] += list(list(client.key = list(client_payload)))
		else if(client.admin_holder?.fakekey)
			player_additional["total_players"] += list(list(client.key = list(client_payload)))
		else
			base_data["total_players"] += list(list(client.key = list(client_payload.Copy())))
			player_additional["total_players"] += list(list(client.key = list(client_payload)))

		var/mob/client_mob = client.mob
		if(client_mob)
			if(istype(client_mob, /mob/new_player))
				client_payload["text"] += " - in Lobby"
				counted_additional["lobby"]++

			else if(isobserver(client_mob))
				client_payload["text"] += " - Playing as [client_mob.real_name]"
				if(CLIENT_IS_STAFF(client))
					counted_additional["admin_observers"]++
				else
					counted_additional["observers"]++

				var/mob/dead/observer/observer = client_mob
				if(observer.started_as_observer)
					client_payload["color"] = "#ce89cd"
					client_payload["text"] += " - Spectating"
				else
					client_payload["color"] = "#A000D0"
					client_payload["text"] += " - DEAD"

			else
				client_payload["text"] += " - Playing as [client_mob.real_name]"

				switch(client_mob.stat)
					if(UNCONSCIOUS)
						client_payload["color"] = "#B0B0B0"
						client_payload["text"] += " - Unconscious"
					if(DEAD)
						client_payload["color"] = "#A000D0"
						client_payload["text"] += " - DEAD"

				if(client_mob.stat != DEAD)
					if(isxeno(client_mob))
						client_payload["color"] = "#ec3535"
						client_payload["text"] += " - Xenomorph"

					else if(ishuman(client_mob))
						if(client_mob.faction == FACTION_ZOMBIE)
							counted_factions[FACTION_ZOMBIE]++
							client_payload["color"] = "#2DACB1"
							client_payload["text"] += " - Zombie"
						else if(client_mob.faction == FACTION_YAUTJA)
							client_payload["color"] = "#7ABA19"
							client_payload["text"] += " - Yautja"
							counted_additional["yautja"]++
							if(client_mob.status_flags & XENO_HOST)
								counted_additional["infected_preds"]++
						else
							counted_additional["humans"]++
							if(client_mob.status_flags & XENO_HOST)
								counted_additional["infected_humans"]++
							if(client_mob.faction == FACTION_MARINE)
								counted_additional["uscm"]++
								if(client_mob.job in (GLOB.ROLES_MARINES))
									counted_additional["uscm_marines"]++
							else
								counted_factions[client_mob.faction]++

	//Bulky section with pre writen names and desc for counts
	factions_additional += list(list("content" = "In Lobby: [counted_additional["lobby"]]", "color" = "#777", "text" = "Player in lobby"))
	factions_additional += list(list("content" = "Spectating Players: [counted_additional["observers"]]", "color" = "#777", "text" = "Spectating players"))
	factions_additional += list(list("content" = "Spectating Admins: [counted_additional["admin_observers"]]", "color" = "#777", "text" = "Spectating administrators"))
	factions_additional += list(list("content" = "Humans: [counted_additional["humans"]]", "color" = "#2C7EFF", "text" = "Players playing as Human"))
	factions_additional += list(list("content" = "Infected Humans: [counted_additional["infected_humans"]]", "color" = "#ec3535", "text" = "Players playing as Infected Human"))
	factions_additional += list(list("content" = "[MAIN_SHIP_NAME] Personnel: [counted_additional["uscm"]]", "color" = "#5442bd", "text" = "Players playing as [MAIN_SHIP_NAME] Personnel"))
	factions_additional += list(list("content" = "Marines: [counted_additional["uscm_marines"]]", "color" = "#5442bd", "text" = "Players playing as Marines"))
	factions_additional += list(list("content" = "Yautjas: [counted_additional["yautja"]]", "color" = "#7ABA19", "text" = "Players playing as Yautja"))
	factions_additional += list(list("content" = "Infected Predators: [counted_additional["infected_preds"]]", "color" = "#7ABA19", "text" = "Players playing as Infected Yautja"))

	for(var/i in 1 to length(counted_factions))
		if(!counted_factions[counted_factions[i]])
			continue
		factions_additional += list(list("content" = "[counted_factions[i]]: [counted_factions[counted_factions[i]]]", "color" = "#2C7EFF", "text" = "Other"))

	if(counted_factions[FACTION_NEUTRAL])
		factions_additional += list(list("content" = "[FACTION_NEUTRAL] Humans: [counted_factions[FACTION_NEUTRAL]]", "color" = "#688944", "text" = "Neutrals"))

	for(var/faction_to_get in ALL_XENO_HIVES)
		var/datum/hive_status/hive = GLOB.hive_datum[faction_to_get]
		if(!hive || !length(hive.totalXenos))
			continue
		factions_additional += list(list("content" = "[hive.name]: [length(hive.totalXenos)]", "color" = hive.color ? hive.color : "#8200FF", "text" = "Queen: [hive.living_xeno_queen ? "Alive" : "Dead"]"))

	src.base_data = base_data
	src.admin_sorted_additional = admin_sorted_additional

/datum/player_list/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, tgui_name, tgui_interface_name)
		ui.open()
		ui.set_autoupdate(TRUE)

/datum/player_list/ui_data(mob/user)
	. = list()
	// Sending base client data, this data sended to EVERYONE
	.["base_data"] = base_data

	// Admin rights based data
	if(!CLIENT_IS_STAFF(user.client))
		return
	for(var/data_packet_name in admin_sorted_additional) // One by one for Drulikar complains
		if(!check_client_rights(user.client, admin_sorted_additional[data_packet_name]["flags"], FALSE))
			continue
		. += list("[data_packet_name]" = admin_sorted_additional[data_packet_name]["data"])

/datum/player_list/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("get_player_panel")
			if(!CLIENT_IS_STAFF(ui.user.client))
				return
			var/chosen_ckey = params["ckey"]
			for(var/client/target in GLOB.clients)
				if(target.key != chosen_ckey)
					continue
				if(target.mob)
					GLOB.admin_datums[ui.user.client.ckey].show_player_panel(target.mob)
				break

/datum/player_list/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE


// STAFF DATA
/datum/player_list/staff
	tgui_name = "StaffWho"
	tgui_interface_name = "Staff Who"

	var/list/category_colors = list(
		"Management" = "purple",
		"Maintainers" = "blue",
		"Administrators" = "red",
		"Moderators" = "orange",
		"Mentors" = "green"
	)

/datum/player_list/staff/update_data()
	var/list/base_data = list()
	var/list/admin_sorted_additional = list()

	var/list/admin_additional = list()
	admin_sorted_additional["admin_additional"] = list("flags" = R_MOD|R_ADMIN, "data" = admin_additional)

	var/list/admin_stealthed_additional = list()
	admin_sorted_additional["admin_stealthed_additional"] = list("flags" = R_STEALTH, "data" = admin_stealthed_additional)

	var/list/listings = list()
	if(CONFIG_GET(flag/show_manager))
		listings["Management"] = list(R_PERMISSIONS, list())
	if(CONFIG_GET(flag/show_devs))
		listings["Maintainers"] = list(R_PROFILER, list())
	listings["Administrators"] = list(R_ADMIN, list())
	if(CONFIG_GET(flag/show_mods))
		listings["Moderators"] = list(R_MOD|R_BAN, list())
	if(CONFIG_GET(flag/show_mentors))
		listings["Mentors"] = list(R_MENTOR, list())

	for(var/client/client as anything in GLOB.admins)
		for(var/category in listings)
			if(CLIENT_HAS_RIGHTS(client, listings[category][1]))
				listings[category][2] += client
				break

	for(var/category in listings)
		base_data["categories"] += list(list(
			"category" = category,
			"category_color" = category_colors[category],
		))

		for(var/client/client as anything in listings[category][2])
			var/list/admin_payload = list()
			admin_payload["category"] = category
			var/rank = client.admin_holder.rank
			if(client.admin_holder.extra_titles?.len)
				for(var/srank in client.admin_holder.extra_titles)
					rank += " & [srank]"

			if(CLIENT_IS_STEALTHED(client))
				admin_payload["special_color"] = "#b60d0d"
				admin_payload["special_text"] = " (STEALTHED)"
				admin_stealthed_additional["total_admins"] += list(list("[client.key] ([rank])" = list(admin_payload)))
			else if(client.admin_holder?.fakekey)
				admin_payload["special_color"] = "#7b582f"
				admin_payload["special_text"] += " (HIDDEN)"
				admin_additional["total_admins"] += list(list("[client.key] ([rank])" = list(admin_payload)))
			else
				admin_additional["total_admins"] += list(list("[client.key] ([rank])" = list(admin_payload)))
				base_data["total_admins"] += list(list("[client.key] ([rank])" = list(admin_payload.Copy())))

			admin_payload["text"] = ""
			if(istype(client.mob, /mob/dead/observer))
				admin_payload["color"] = "#808080"
				admin_payload["text"] += "Spectating"

			else if(istype(client.mob, /mob/new_player))
				admin_payload["color"] = "#FFFFFF"
				admin_payload["text"] += "in Lobby"
			else
				admin_payload["color"] = "#688944"
				admin_payload["text"] += "Playing"

			if(client.is_afk())
				admin_payload["color"] = "#A040D0"
				admin_payload["special_text"] += " (AFK)"

	src.base_data = base_data
	src.admin_sorted_additional = admin_sorted_additional


// VERBS
/mob/verb/who()
	set category = "OOC"
	set name = "Who"

	SSwho.who.tgui_interact(src)

/mob/verb/staffwho()
	set category = "Admin"
	set name = "StaffWho"

	SSwho.staff_who.tgui_interact(src)
