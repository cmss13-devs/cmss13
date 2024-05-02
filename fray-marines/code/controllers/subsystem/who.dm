SUBSYSTEM_DEF(who)
	name = "Who"
	flags = SS_NO_INIT|SS_BACKGROUND
	runlevels = RUNLEVELS_DEFAULT|RUNLEVEL_LOBBY
	wait = 5 SECONDS

	var/datum/player_list/who = new
	var/datum/player_list/staff/staff_who = new

/datum/controller/subsystem/who/fire(resumed = TRUE)
	who.update_data()
	staff_who.update_data()

//datum
/datum/player_list
	var/tgui_name = "Who"
	var/tgui_interface_name = "Who"
	var/list/mobs_ckey = list()
	var/list/list_data = list()

/datum/player_list/proc/update_data()
	var/list/new_list_data = list()
	var/list/new_mobs_ckey = list()
	var/list/additiona_data = list(
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
	new_list_data["additional_info"] = list()
	var/list/counted_factions = list()
	for(var/client/client in sortTim(GLOB.clients, GLOBAL_PROC_REF(cmp_ckey_asc)))
		CHECK_TICK
		new_list_data["all_clients"]++
		var/list/client_payload = list()
		client_payload["ckey"] = "[client.key]"
		client_payload["text"] = "[client.key]"
		client_payload["ckey_color"] = "white"
		var/mob/client_mob = client.mob
		new_mobs_ckey[client.key] = client_mob
		if(client_mob)
			if(istype(client_mob, /mob/new_player))
				client_payload["text"] += " - in Lobby"
				additiona_data["lobby"]++
				new_list_data["total_players"] += list(client_payload)
				continue

			if(isobserver(client_mob))
				client_payload["text"] += " - Playing as [client_mob.real_name]"
				if(CLIENT_IS_STAFF(client))
					additiona_data["admin_observers"]++
				else
					additiona_data["observers"]++

				var/mob/dead/observer/observer = client_mob
				if(observer.started_as_observer)
					client_payload["color"] += "#ce89cd"
					client_payload["text"] += " - Spectating"
				else
					client_payload["color"] += "#A000D0"
					client_payload["text"] += " - DEAD"

			else
				client_payload["text"] += " - Playing as [client_mob.real_name]"

				switch(client_mob.stat)
					if(UNCONSCIOUS)
						client_payload["color"] += "#B0B0B0"
						client_payload["text"] += " - Unconscious"
					if(DEAD)
						client_payload["color"] += "#A000D0"
						client_payload["text"] += " - DEAD"

				if(client_mob.stat != DEAD)
					if(isxeno(client_mob))
						client_payload["color"] += "#f00"
						client_payload["text"] += " - Xenomorph"

					else if(ishuman(client_mob))
						if(client_mob.faction == FACTION_ZOMBIE)
							counted_factions[FACTION_ZOMBIE]++
							client_payload["color"] += "#2DACB1"
							client_payload["text"] += " - Zombie"
						else if(client_mob.faction == FACTION_YAUTJA)
							client_payload["color"] += "#7ABA19"
							client_payload["text"] += " - Yautja"
							additiona_data["yautja"]++
							if(client_mob.status_flags & XENO_HOST)
								additiona_data["infected_preds"]++
						else
							additiona_data["humans"]++
							if(client_mob.status_flags & XENO_HOST)
								additiona_data["infected_humans"]++
							if(client_mob.faction == FACTION_MARINE)
								additiona_data["uscm"]++
								if(client_mob.job in (GLOB.ROLES_MARINES))
									additiona_data["uscm_marines"]++
							else
								counted_factions[client_mob.faction]++

		new_list_data["total_players"] += list(client_payload)

	new_list_data["additional_info"] += list(list(
		"content" = "in Lobby: [additiona_data["lobby"]]",
		"color" = "#777",
		"text" = "Player in lobby",
	))

	new_list_data["additional_info"] += list(list(
		"content" = "Spectators: [additiona_data["observers"]] Players",
		"color" = "#777",
		"text" = "Spectating players",
	))

	new_list_data["additional_info"] += list(list(
		"content" = "Spectators: [additiona_data["admin_observers"]] Administrators",
		"color" = "#777",
		"text" = "Spectating administrators",
	))

	new_list_data["additional_info"] += list(list(
		"content" = "Humans: [additiona_data["humans"]]",
		"color" = "#2C7EFF",
		"text" = "Players playing as Human",
	))

	new_list_data["additional_info"] += list(list(
		"content" = "Infected Humans: [additiona_data["infected_humans"]]",
		"color" = "#F00",
		"text" = "Players playing as Infected Human",
	))

	new_list_data["additional_info"] += list(list(
		"content" = "USS `Almayer` Personnel: [additiona_data["uscm"]]",
		"color" = "#2d199b",
		"text" = "Players playing as USS `Almayer` Personnel",
	))

	new_list_data["additional_info"] += list(list(
		"content" = "Marines: [additiona_data["uscm_marines"]]",
		"color" = "#2d199b",
		"text" = "Players playing as Marines",
	))

	new_list_data["additional_info"] += list(list(
		"content" = "Yautjes: [additiona_data["yautja"]]",
		"color" = "#7ABA19",
		"text" = "Players playing as Yautja",
	))

	new_list_data["additional_info"] += list(list(
		"content" = "Infected Yautjes: [additiona_data["infected_preds"]])",
		"color" = "#7ABA19",
		"text" = "Players playing as Infected Yautja",
	))

	for(var/i in 10 to length(counted_factions) - 2)
		if(counted_factions[counted_factions[i]])
			new_list_data["factions"] += list(list(
				"content" = "[counted_factions[i]]: [counted_factions[counted_factions[i]]]",
				"color" = "#2C7EFF",
				"text" = "Other",
			))
	if(counted_factions[FACTION_NEUTRAL])
		new_list_data["factions"] += list(list(
			"content" = "[FACTION_NEUTRAL] Humans: [counted_factions[FACTION_NEUTRAL]]",
			"color" = "#688944",
			"text" = "Neutrals",
		))

	for(var/faction_to_get in ALL_XENO_HIVES)
		var/datum/hive_status/hive = GLOB.hive_datum[faction_to_get]
		if(hive && length(hive.totalXenos))
			new_list_data["xenomorphs"] += list(list(
				"content" = "[hive.name]: [length(hive.totalXenos)]",
				"color" = hive.color ? hive.color : "#8200FF",
				"text" = "Queen: [hive.living_xeno_queen ? "Alive" : "Dead"]",
			))

	list_data = new_list_data
	mobs_ckey = new_mobs_ckey

/datum/player_list/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, tgui_name, tgui_interface_name)
		ui.open()
		ui.set_autoupdate(TRUE)

/datum/player_list/ui_data(mob/user)
	. = list_data

/datum/player_list/ui_static_data(mob/user)
	. = list()

	.["admin"] = CLIENT_IS_STAFF(user.client)

/datum/player_list/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("get_player_panel")
			GLOB.admin_datums[usr.client.ckey].show_player_panel(mobs_ckey[params["ckey"]])

/datum/player_list/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE


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
	var/list/new_list_data = list()
	mobs_ckey = list()

	var/list/listings
	var/list/mappings
	if(CONFIG_GET(flag/show_manager))
		LAZYSET(mappings, "Management", R_PERMISSIONS)
	if(CONFIG_GET(flag/show_devs))
		LAZYSET(mappings, "Maintainers", R_PROFILER)
	LAZYSET(mappings, "Administrators", R_ADMIN)
	if(CONFIG_GET(flag/show_mods))
		LAZYSET(mappings, "Moderators", R_MOD && R_BAN)
	if(CONFIG_GET(flag/show_mentors))
		LAZYSET(mappings, "Mentors", R_MENTOR)

	for(var/category in mappings)
		LAZYSET(listings, category, list())

	for(var/client/client in GLOB.admins)
		if(client.admin_holder?.fakekey && !CLIENT_IS_STAFF(client))
			continue

		for(var/category in mappings)
			if(CLIENT_HAS_RIGHTS(client, mappings[category]))
				LAZYADD(listings[category], client)
				break

	for(var/category in listings)
		var/list/admins = list()
		for(var/client/entry in listings[category])
			var/list/admin = list()
			var/rank = entry.admin_holder.rank
			if(entry.admin_holder.extra_titles?.len)
				for(var/srank in entry.admin_holder.extra_titles)
					rank += " & [srank]"

			admin["content"] = "[entry.key] ([rank])"
			admin["text"] = ""

			if(entry.admin_holder?.fakekey)
				admin["text"] += " (HIDDEN)"

			if(istype(entry.mob, /mob/dead/observer))
				admin["color"] = "#808080"
				admin["text"] += " Spectating"

			else if(istype(entry.mob, /mob/new_player))
				admin["color"] = "#688944"
				admin["text"] += " in Lobby"
			else
				admin["color"] = "#688944"
				admin["text"] += " Playing"

			if(entry.is_afk())
				admin["color"] = "#A040D0"
				admin["text"] += " (AFK)"

			admins += list(admin)

		new_list_data["administrators"] += list(list(
			"category" = category,
			"category_color" = category_colors[category],
			"category_administrators" = length(listings[category]),
			"admins" = admins,
		))

	list_data = new_list_data

/mob/verb/who()
	set category = "OOC"
	set name = "Who"

	SSwho.who.tgui_interact(src)

/mob/verb/staffwho()
	set category = "Admin"
	set name = "Staff Who"

	SSwho.staff_who.tgui_interact(src)
