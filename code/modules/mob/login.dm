/// Handles setting lastKnownIP and computer_id for use by the ban systems
/mob/proc/update_Login_details()
	if(client)
		lastKnownIP	= client.address
		computer_id	= client.computer_id

/mob/Login()
	if(!client)
		return

	logging_ckey = client.ckey

	if(client.player_data)
		client.player_data.playtime_start = world.time

	GLOB.player_list |= src

	update_Login_details()

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

	client.init_statbrowser()

	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MOB_LOGIN, src)
	SEND_SIGNAL(src, COMSIG_MOB_LOGIN)
