#ifndef OVERRIDE_BAN_SYSTEM
//Blocks an attempt to connect before even creating our client datum thing.
/world/IsBanned(key,address,computer_id, type, real_bans_only=FALSE, is_telemetry = FALSE, guest_bypass_with_ext_auth = TRUE)
	var/ckey = ckey(key)

	// This is added siliently. Thanks to MSO for this fix. You will see it when/if we go OS
	if (type == "world")
		return ..() //shunt world topic banchecks to purely to byond's internal ban system

	var/client/C = GLOB.directory[ckey]
	if (C && ckey == C.ckey && computer_id == C.computer_id && address == C.address)
		return //don't recheck connected clients.

	//Guest Checking
	if(!real_bans_only && CONFIG_GET(flag/guest_ban) && IsGuestKey(key))
		log_access("Failed Login: [key] - Guests not allowed")
		message_admins("Failed Login: [key] - Guests not allowed")
		return list("reason"="guest", "desc"="\nReason: Guests not allowed. Please sign in with a byond account.")

	// wait for database to be ready
	WAIT_DB_READY
	if(GLOB.admin_datums[ckey] && (GLOB.admin_datums[ckey].rights & R_MOD))
		return ..()

	if(CONFIG_GET(number/limit_players) && CONFIG_GET(number/limit_players) < length(GLOB.clients))
		return list("reason"="POP CAPPED", "desc"="\nReason: Server is pop capped at the moment at [CONFIG_GET(number/limit_players)] players. Attempt reconnection in 2-3 minutes.")

	// When a user is logging in as a guest, and we're authenticating them externally, they should bypass this for now
	// so we can check them when they log in with their real login
	if(guest_bypass_with_ext_auth && IsGuestKey(key) && length(CONFIG_GET(keyed_list/auth_urls)))
		return ..()

	var/datum/entity/player/P = get_player_from_key(ckey)


	. = P.check_ban(computer_id, address, is_telemetry)


#endif
