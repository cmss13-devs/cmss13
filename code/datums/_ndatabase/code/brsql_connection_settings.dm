/datum/db/connection_settings/brsql
	var/ipaddress
	var/port
	var/username
	var/password
	var/db
	var/min_threads
	var/max_threads

/datum/db/connection_settings/brsql/New(var/list/config)
	..()
	ipaddress = config["db_address"]
	port = text2num(config["db_port"])
	username = config["db_username"]
	password = config["db_password"]
	db = config["db_database"]
	min_threads = text2num(config["db_min_threads"] || "1")
	max_threads = text2num(config["db_max_threads"] || "100")

/datum/db/connection_settings/brsql/create_connection()
	var/datum/db/connection/brsql_connection/connection = new()
	connection.setup(ipaddress, port, username, password, db, min_threads, max_threads)
	return connection
