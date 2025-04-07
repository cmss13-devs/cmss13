/client/proc/offline_timed_ban()
	set name = "Offline Timed Ban"
	set category = "Admin"

	if(!check_rights(R_ADMIN))
		return

	var/datum/offline_timed_ban/offline_timed_ban = new
	offline_timed_ban.add_offline_timed_ban()

/datum/offline_timed_ban/proc/add_offline_timed_ban()
	var/ckey = ckey(tgui_input_text(usr, "Ckey to ban? Enter key or ckey", "Ckey to ban"))
	if(!ckey)
		return

	var/mins = tgui_input_number(usr, "How long (in minutes)? 180 = 3 hours, 1440 = 1 day,  4320 = 3 days, 10080 = 7 days, 43800 = 1 Month", "Ban time", 1440, 262800, 1)
	if(!mins)
		return

	var/reason = tgui_input_text(usr, "Reason? Press 'OK' to finalize the ban.", "Ban reason", "Griefer")
	if(!reason)
		return

	var/datum/entity/player/player = get_player_from_key(ckey)
	if(player.is_time_banned && alert(usr, "Ban already exists. Proceed?", "Confirmation", "Yes", "No") != "Yes")
		return
	player.add_timed_ban(reason, mins)
