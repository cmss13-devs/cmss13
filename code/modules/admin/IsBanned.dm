#ifndef OVERRIDE_BAN_SYSTEM
//Blocks an attempt to connect before even creating our client datum thing.
world/IsBanned(key,address,computer_id, type)
	var/ckey = ckey(key)

	// This is added siliently. Thanks to MSO for this fix. You will see it when/if we go OS
	if (type == "world")
		return ..() //shunt world topic banchecks to purely to byond's internal ban system

	var/client/C = GLOB.directory[ckey]
	if (C && ckey == C.ckey && computer_id == C.computer_id && address == C.address)
		return //don't recheck connected clients.

	//Guest Checking
	if(IsGuestKey(key))
		log_access("Failed Login: [key] - Guests not allowed")
		message_staff(SPAN_NOTICE("Failed Login: [key] - Guests not allowed"))
		return list("reason"="guest", "desc"="\nReason: Guests not allowed. Please sign in with a byond account.")

	WAIT_DB_READY
	if(admin_datums[ckey] && (admin_datums[ckey].rights & R_MOD))
		return ..()

	if(CONFIG_GET(number/limit_players) && CONFIG_GET(number/limit_players) < GLOB.clients.len)
		return list("reason"="POP CAPPED", "desc"="\nReason: Server is pop capped at the moment at [CONFIG_GET(number/limit_players)] players. Attempt reconnection in 2-3 minutes.")

	var/datum/entity/player/P = get_player_from_key(ckey)

	//check if the IP address is a known TOR node
	if(CONFIG_GET(flag/ToRban) && ToRban_isbanned(address))
		log_access("Failed Login: [src] - Banned: ToR")
		message_staff(SPAN_NOTICE("Failed Login: [src] - Banned: ToR"))
		return list("reason"="Using ToR", "desc"="\nReason: The network you are using to connect has been banned.\nIf you believe this is a mistake, please request help at [CONFIG_GET(string/banappeals)]")

	// wait for database to be ready

	. = P.check_ban(computer_id, address)
	if(.)
		return .

	return ..()	//default pager ban stuff


#endif
