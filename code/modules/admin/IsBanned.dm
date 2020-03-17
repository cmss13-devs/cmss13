#ifndef OVERRIDE_BAN_SYSTEM
//Blocks an attempt to connect before even creating our client datum thing.
world/IsBanned(key,address,computer_id, type)
	var/ckey = ckey(key)

	// This is added siliently. Thanks to MSO for this fix. You will see it when/if we go OS
	if (type == "world")
		return ..() //shunt world topic banchecks to purely to byond's internal ban system

	var/client/C = directory[ckey]
	if (C && ckey == C.ckey && computer_id == C.computer_id && address == C.address)
		return //don't recheck connected clients.

	if(ckey in admin_datums && !isnull(admin_datums[ckey]) && (admin_datums[ckey].rights & R_MOD))
		return ..()

	//Guest Checking
	if(!guests_allowed && IsGuestKey(key))
		log_access("Failed Login: [key] - Guests not allowed")
		message_admins(SPAN_NOTICE("Failed Login: [key] - Guests not allowed"))
		return list("reason"="guest", "desc"="\nReason: Guests not allowed. Please sign in with a byond account.")

	//check if the IP address is a known TOR node
	if(config && config.ToRban && ToRban_isbanned(address))
		log_access("Failed Login: [src] - Banned: ToR")
		message_admins(SPAN_NOTICE("Failed Login: [src] - Banned: ToR"))
		//ban their computer_id and ckey for posterity
		AddBan(ckey(key), computer_id, "Use of ToR", "Automated Ban", 0, 0)
		return list("reason"="Using ToR", "desc"="\nReason: The network you are using to connect has been banned.\nIf you believe this is a mistake, please request help at [config.banappeals]")

	//Ban Checking
	. = CheckBan( ckey(key), computer_id, address )
	if(.)
		log_access("Failed Login: [key] [computer_id] [address] - Banned [.["reason"]]")
		message_admins(SPAN_NOTICE("Failed Login: [key] id:[computer_id] ip:[address] - Banned [.["reason"]]"))
		return .

	return ..()	//default pager ban stuff

	
#endif