/datum/db/connection_settings/native
	var/filename

/datum/db/connection_settings/native/New(var/list/config)
	filename = config["db_filename"]

/datum/db/connection_settings/native/create_connection()
	var/datum/db/connection/native/connection = new()
	connection.setup(filename)
	return connection
