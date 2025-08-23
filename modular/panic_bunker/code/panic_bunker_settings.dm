#define PANIC_BUNKER_SETTINGS_FILE "config/panic_bunker.json"
#define READ_JSON_FILE(PATH) (safe_read_json(PATH))
#define WRITE_JSON_FILE(TEXT, PATH) (text2file(json_encode(TEXT),PATH))

GLOBAL_LIST_EMPTY(panic_bunker_bypass)

/proc/safe_json_decode(data)
	try
		return json_decode(data)
	catch
		return null

/proc/safe_read_json(path)
	var/raw_data = file2text(path)
	if(raw_data)
		var/list/parsed_data = safe_json_decode(raw_data)
		if(isnull(parsed_data))
			log_config("JSON parsing failure for [path]")
		else
			return parsed_data

/datum/config_entry/flag/panic_bunker_enabled

/datum/config_entry/number/panic_bunker_min_alive_playtime_hours
	min_val = 1
	max_val = 100

/datum/controller/configuration/proc/LoadPanicBunker()
	var/list/settings = READ_JSON_FILE(PANIC_BUNKER_SETTINGS_FILE)
	if(!settings)
		message_admins("Failed to load Panic Bunker Settings!")
		return
	CONFIG_SET(flag/panic_bunker_enabled, settings["panic_bunker_enabled"])
	CONFIG_SET(number/panic_bunker_min_alive_playtime_hours, settings["panic_bunker_min_alive_playtime_hours"])
	GLOB.panic_bunker_bypass |= settings["panic_bunker_bypass_ckeys"]

/client/proc/toggle_panic_bunker()
	set name = "Toggle Panic Bunker"
	set desc = "Enables/Disables Panic Bunker"
	set category = "Server.Panic"

	if(!check_rights(R_SERVER))
		return

	var/datum/panic_bunker/panic_bunker = new
	panic_bunker.toggle_panic_bunker(src)

/client/proc/change_panic_bunker_time()
	set name = "Change Panic Bunker Time"
	set desc = "Changes Panic Bunker Time"
	set category = "Server.Panic"

	if(!check_rights(R_SERVER))
		return

	var/datum/panic_bunker/panic_bunker = new
	panic_bunker.change_panic_bunker_time(src)

/client/proc/edit_panic_bunker_bypass()
	set name = "Edit Panic Bunker Bypass"
	set desc = "Edit Panic Bunker Bypass"
	set category = "Server.Panic"

	if(!check_rights(R_SERVER))
		return

	var/datum/panic_bunker/panic_bunker = new
	panic_bunker.edit_panic_bunker_bypass(src)

/client/proc/clear_panic_bunker_bypass()
	set name = "Clear Panic Bunker Bypass"
	set desc = "Clear Panic Bunker Bypass"
	set category = "Server.Panic"

	if(!check_rights(R_PERMISSIONS))
		return

	var/datum/panic_bunker/panic_bunker = new
	panic_bunker.clear_bypass_list(src)
