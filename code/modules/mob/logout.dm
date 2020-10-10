/mob/Logout()
	nanomanager.user_logout(src) // this is used to clean up (remove) this user's Nano UIs
	if(interactee) 
		unset_interaction()
	GLOB.player_list -= src
	log_access("Logout: [key_name(src)]")
	unansweredAhelps.Remove(src.computer_id)

	if(AHOLD_IS_MOD(admin_datums[src.ckey]) && ticker && ticker.current_state == GAME_STATE_PLAYING)
		message_staff("Admin logout: [key_name(src)]")

	if(s_active)
		s_active.hide_from(src)
	..()
	return 1
