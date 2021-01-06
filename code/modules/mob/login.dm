//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
/mob/proc/update_Login_details()
	//Multikey checks and logging
	if(!client)
		return
	lastKnownIP	= client.address
	computer_id	= client.computer_id
	log_access("Login: [key_name(src)] from [lastKnownIP ? lastKnownIP : "localhost"]-[computer_id] || BYOND v[client.byond_version].[client.byond_build]")
	if(CONFIG_GET(flag/log_access))
		for(var/mob/M in GLOB.player_list)
			if(M == src)	continue
			if( M.key && (M.key != key) )
				var/matches
				if( (M.lastKnownIP == client.address) )
					matches += "IP ([client.address])"
				if( (client.connection != "web") && (M.computer_id == client.computer_id) )
					if(matches)	matches += " and "
					matches += "ID ([client.computer_id])"
					spawn() alert("You have logged in already with another key this round, please log out of this one NOW or risk being banned!")
				if(matches)
					if(M.client)
						message_staff("<font color='red'><B>Notice: </B>[SPAN_BLUE("<A href='?src=\ref[usr];priv_msg=\ref[src.client]'>[key_name_admin(src)]</A> has the same [matches] as <A href='?src=\ref[usr];priv_msg=\ref[M.client]'>[key_name_admin(M)]</A>.")]", 1)
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(M)].")
					else
						message_staff("<font color='red'><B>Notice: </B>[SPAN_BLUE("<A href='?src=\ref[usr];priv_msg=\ref[src.client]'>[key_name_admin(src)]</A> has the same [matches] as [key_name_admin(M)] (no longer logged in).")]", 1)
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(M)] (no longer logged in).")

/mob/Login()
	if(!client)
		return

	logging_ckey = client.ckey

	if(client.player_data)
		client.player_data.playtime_start = world.time

	GLOB.player_list |= src

	update_Login_details()
	world.update_status()

	client.images = null
	client.screen = null				//remove hud items just in case
	if(!hud_used)
		create_hud()
	if(hud_used)
		hud_used.show_hud(hud_used.hud_version)

	reload_fullscreens()

	next_move = 1
	sight |= SEE_SELF

	. = ..()

	reset_view(loc)

	//updating atom HUD
	refresh_huds()

	if(isnewplayer(src))
		check_event_info()
	else if(isXeno(src))
		var/mob/living/carbon/Xenomorph/X = src
		check_event_info(X.hive.name)
	else if(!isobserver(src) && faction)
		check_event_info(faction)

	if(client.player_details)
		for(var/foo in client.player_details.post_login_callbacks)
			var/datum/callback/CB = foo
			CB.Invoke()

	client.init_verbs()

	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MOB_LOGIN, src)
	SEND_SIGNAL(src, COMSIG_MOB_LOGIN)

