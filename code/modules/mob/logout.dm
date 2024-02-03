/mob/Logout()
	SEND_SIGNAL(src, COMSIG_MOB_LOGOUT)
	SSnano.nanomanager.user_logout(src) // this is used to clean up (remove) this user's Nano UIs
	if(interactee)
		unset_interaction()
	GLOB.player_list -= src

	if(s_active)
		s_active.storage_close(src)
	..()

	var/datum/entity/player/P = get_player_from_key(logging_ckey)

	if(P)
		if(stat == DEAD)
			record_playtime(P, JOB_OBSERVER, type)
		else
			record_playtime(P, job, type)

	logging_ckey = null

	if(client) //As of 16/8/21 this check doesn't seem possible - client appears to be unset before Logout() is called.
		for(var/foo in client.player_details.post_logout_callbacks)
			var/datum/callback/CB = foo
			CB.Invoke()

	return TRUE
