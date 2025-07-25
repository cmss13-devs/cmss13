/// Handles setting lastKnownIP and computer_id for use by the ban systems
/mob/proc/update_Login_details()
	if(client)
		lastKnownIP = client.address
		computer_id = client.computer_id

/mob/Login()
	if(!client)
		return

	logging_ckey = client.ckey
	persistent_ckey = client.ckey
	persistent_username = username()

	if(client.player_data)
		client.player_data.playtime_start = world.time

	GLOB.player_list |= src
	set_logged_in_mob()

	update_Login_details()

	SEND_SIGNAL(src, COMSIG_MOB_LOGIN)

	client.images = null
	client.screen = null //remove hud items just in case
	if(!hud_used)
		create_hud()
	if(hud_used)
		hud_used.show_hud(hud_used.hud_version)

	reload_fullscreens()

	if(length(client_color_matrices))
		update_client_color_matrices(time = 0) //This mob has client color matrices set, apply them instantly on login.
	else
		update_client_color_matrices(time = 1.5 SECONDS) //Otherwise, fade any matrices from a previous mob.

	next_move = 1
	sight |= SEE_SELF

	. = ..()

	reset_view(loc)
	update_sight()

	//updating atom HUD
	refresh_huds()

	if(isnewplayer(src))
		check_event_info()
	else if(isxeno(src))
		var/mob/living/carbon/xenomorph/X = src
		check_event_info(X.hive.name)
	else if(!isobserver(src) && faction)
		check_event_info(faction)

	if(client.player_details)
		for(var/foo in client.player_details.post_login_callbacks)
			var/datum/callback/CB = foo
			CB.Invoke()

	client.init_verbs()
	client.set_right_click_menu_mode(shift_only = FALSE)
	client.tgui_say?.load()

	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MOB_LOGGED_IN, src)
	SEND_SIGNAL(client, COMSIG_CLIENT_MOB_LOGGED_IN, src)
	SEND_SIGNAL(src, COMSIG_MOB_LOGGED_IN)
	if(client?.prefs.main_cursor)
		update_cursor()

/mob/proc/set_logged_in_mob()
	GLOB.ckey_to_occupied_mob[client.ckey] = src
