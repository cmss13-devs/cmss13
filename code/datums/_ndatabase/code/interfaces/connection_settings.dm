/datum/db/connection_settings

/datum/db/connection_settings/New(var/list/config)

/datum/db/connection_settings/proc/create_connection()
	return null

/proc/connection_settings_from_config(var/list/config)	
	var/typestr = text2path("/datum/db/connection_settings/"+config["db_provider"])
	if(!typestr)
		typestr = /datum/db/connection_settings/native
	return new typestr(config)

var/global/datum/db/connection_settings/connection_settings