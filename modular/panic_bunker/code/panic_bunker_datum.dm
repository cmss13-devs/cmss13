/datum/panic_bunker/proc/toggle_panic_bunker(client/client)
	var/confirm = tgui_alert(client, "Вы уверены, что хотите [CONFIG_GET(flag/panic_bunker_enabled) ? "выключить" : "включить"] Panic Bunker?", "Toggle Panic Bunker", list("Да", "Нет"))
	if(confirm != "Да")
		return

	var/new_value = !CONFIG_GET(flag/panic_bunker_enabled)
	CONFIG_SET(flag/panic_bunker_enabled, new_value)
	message_admins("[key_name(client)] toggled Panic Bunker. New value - [new_value]")

	update_panic_bunker_setting("panic_bunker_enabled", new_value)

/datum/panic_bunker/proc/change_panic_bunker_time(client/client)
	var/confirm = tgui_alert(client, "Вы уверены, что хотите сменить минимальное количество часов для прохождения Panic Bunker? Текущее - [CONFIG_GET(number/panic_bunker_min_alive_playtime_hours)]", "Change Panic Bunker Hours", list("Да", "Нет"))
	if(confirm != "Да")
		return

	var/new_hours = tgui_input_number(client, "Введите новое количество часов", "Change Panic Bunker Hours", CONFIG_GET(number/panic_bunker_min_alive_playtime_hours), 100, 1)
	if(!new_hours)
		return

	CONFIG_SET(number/panic_bunker_min_alive_playtime_hours, new_hours)
	message_admins("[key_name(client)] changed Panic Bunker hours. New value - [new_hours] hours")

	update_panic_bunker_setting("panic_bunker_min_alive_playtime_hours", new_hours)

/datum/panic_bunker/proc/edit_panic_bunker_bypass(client/client)
	var/alert = tgui_alert(client, "Add or remove?", "Edit Panic Bunker Bypass", list("Add", "Remove"))
	if(!alert)
		return

	var/list/settings = READ_JSON_FILE(PANIC_BUNKER_SETTINGS_FILE)

	switch(alert)
		if("Add")
			var/new_ckey = ckey(tgui_input_text(client, "Enter ckey", "Add ckey to Panic Bunker Bypass"))
			if(!new_ckey)
				return
			add_to_bypass(new_ckey, settings)
			message_admins("[key_name(client)] added [new_ckey] to Panic Bunker Bypass list.")
			tgui_alert_async(client, "[new_ckey] added to Panic Bunker Bypass", "Success")
		if("Remove")
			if(!length(settings["panic_bunker_bypass_ckeys"]))
				tgui_alert_async(client, "No bypass ckeys", "Error")
				return

			var/remove_ckey = tgui_input_list(client, "Choose ckey", "Remove ckey from Panic Bunker Bypass", settings["panic_bunker_bypass_ckeys"])
			if(!remove_ckey)
				return
			remove_from_bypass(remove_ckey, settings)
			message_admins("[key_name(client)] removed [remove_ckey] from Panic Bunker Bypass list.")
			tgui_alert_async(client, "[remove_ckey] removed from Panic Bunker Bypass", "Success")

	save_panic_bunker_settings(settings)

/datum/panic_bunker/proc/clear_bypass_list(client/client)
	var/clear_hours = tgui_input_number(client, "Введите количество часов больше которого убрать пропуск", "Clear Bunker Bypass List", 1, 100, 1)
	if(!clear_hours)
		return
	to_chat(client, "Panic Bunker: Clean started")

	var/list/settings = READ_JSON_FILE(PANIC_BUNKER_SETTINGS_FILE)
	var/counter = 0
	for(var/ckey in settings["panic_bunker_bypass_ckeys"])
		to_chat(client, "Panic Bunker: Checking [ckey]...")
		var/datum/entity/player/player = get_player_from_key(ckey)
		var/current_hours = round(get_total_living_playtime(player.id) /60, 0.1)
		if(clear_hours > current_hours)
			continue
		settings["panic_bunker_bypass_ckeys"] -= ckey
		to_chat(client, "Panic Bunker: Removed [ckey] ([current_hours]h)")
		counter++

	if(counter)
		save_panic_bunker_settings(settings)
		message_admins("[key_name(client)] cleared [counter] ckeys from Panic Bunker Bypass List")
	else
		to_chat(client, "Panic Bunker: No ckeys to clear")

/datum/panic_bunker/proc/save_panic_bunker_settings(settings)
	fdel(PANIC_BUNKER_SETTINGS_FILE)
	WRITE_JSON_FILE(settings, PANIC_BUNKER_SETTINGS_FILE)

/datum/panic_bunker/proc/update_panic_bunker_setting(key, value)
	var/list/settings = READ_JSON_FILE(PANIC_BUNKER_SETTINGS_FILE)
	settings[key] = value
	save_panic_bunker_settings(settings)

/datum/panic_bunker/proc/add_to_bypass(ckey, list/settings)
	settings["panic_bunker_bypass_ckeys"] |= ckey
	GLOB.panic_bunker_bypass |= ckey
	save_panic_bunker_settings(settings)

/datum/panic_bunker/proc/remove_from_bypass(ckey, list/settings)
	settings["panic_bunker_bypass_ckeys"] -= ckey
	GLOB.panic_bunker_bypass -= ckey
	save_panic_bunker_settings(settings)

#undef PANIC_BUNKER_SETTINGS_FILE
#undef READ_JSON_FILE
#undef WRITE_JSON_FILE
