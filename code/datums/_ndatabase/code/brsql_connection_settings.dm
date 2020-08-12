// MIT License

// Copyright (c) 2020 Neth Iafin

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
