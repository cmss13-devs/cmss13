/datum/db/connection_settings/bsql
	var/ipaddress
	var/port
	var/username
	var/password
	var/db

/datum/db/connection_settings/bsql/New(var/list/config)
	ipaddress = config["db_address"]
	port = config["db_port"]
	username = config["db_username"]
	password = config["db_password"]
	db = config["db_database"]

/datum/db/connection_settings/bsql/create_connection()
	var/datum/db/connection/persistent_connection/connection = new()
	connection.setup(ipaddress, port, username, password, db)
	return connection
