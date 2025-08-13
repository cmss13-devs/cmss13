GLOBAL_LIST_EMPTY(permitted_guests)

GENERAL_PROTECT_DATUM(/mob/unauthenticated)

/mob/unauthenticated
	invisibility = INVISIBILITY_ABSTRACT
	density = FALSE
	anchored = TRUE
	sight = BLIND
	stat = DEAD

	var/static/valid_characters = splittext("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", "")
	var/access_code

	var/datum/tgui_window/unauthenticated_menu

	var/new_ckey

	COOLDOWN_DECLARE(recall_code_cooldown)

/mob/unauthenticated/New(loc, ...)
	. = ..()

	GLOB.dead_mob_list -= src
	ADD_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_SOURCE_INHERENT)

/mob/unauthenticated/Login()
	var/static/datum/preferences/dummy_preferences
	if(!dummy_preferences)
		dummy_preferences = new()

	client.prefs = dummy_preferences

	. = ..()

	client.acquire_dpi()

	display_unauthenticated_menu()

/mob/unauthenticated/Logout()
	. = ..()

	QDEL_NULL(unauthenticated_menu)
	qdel(src)

/mob/unauthenticated/set_logged_in_mob()
	return FALSE

/// Creates our authentication request, stores the code in the database and on us
/mob/unauthenticated/proc/create_access_code_entity()
	WAIT_DB_READY

	access_code = generate_access_code()

	var/datum/entity/authentication_request/access_entity = DB_ENTITY(/datum/entity/authentication_request)
	access_entity.access_code = access_code
	access_entity.ip = client.address
	access_entity.cid = "[client.computer_id]"
	access_entity.time = time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")
	access_entity.save()
	access_entity.detach()

#define ACCESS_CODE_LENGTH 40

/// Creates a base 62 access code
/mob/unauthenticated/proc/generate_access_code()
	var/code = ""

	for(var/i in 1 to ACCESS_CODE_LENGTH)
		code += pick(valid_characters)

	return code

#undef ACCESS_CODE_LENGTH

/mob/unauthenticated/process()
	if(!client)
		return PROCESS_KILL

	if(new_ckey)
		return PROCESS_KILL

	INVOKE_ASYNC(src, PROC_REF(check_logged_in))

/// Polls the database to see if our access code has been validated
/mob/unauthenticated/proc/check_logged_in(code)
	if(new_ckey)
		return

	var/datum/view_record/authentication_request/request = locate() in DB_VIEW(
		/datum/view_record/authentication_request,
		DB_AND(
			DB_COMP("access_code", DB_EQUALS, code ? code : access_code),
			DB_COMP("time", DB_GREATER, time2text(world.timeofday - 3 HOURS, "YYYY-MM-DD hh:mm:ss")),
			DB_COMP("approved", DB_EQUALS, TRUE),
			DB_COMP("ip", DB_EQUALS, client.address),
			DB_COMP("cid", DB_EQUALS, "[client.computer_id]")
		)
	)

	if(!request)
		return

	if(request.external_username)
		client.external_username = ckey(request.external_username)

		var/middle = ""
		if(request.authentication_method)
			middle = "[capitalize(request.authentication_method)]-"

		new_ckey = "Guest-[middle][client.external_username]"

	else if(request.internal_user_id)
		var/datum/view_record/players/player = locate() in DB_VIEW(
			/datum/view_record/players,
			DB_COMP("id", DB_EQUALS, request.internal_user_id)
		)

		if(!player)
			message_admins("Something has gone really wrong when authenticating [client].")
			return

		new_ckey = player.ckey

	if(!code)
		notify_unauthenticated_menu()
		sleep(1)

	var/banned = world.IsBanned(new_ckey, client.address, client.computer_id, real_bans_only = TRUE, guest_bypass_with_ext_auth = FALSE)
	if(banned)
		unauthenticated_menu.send_message("banned", banned)
		QDEL_IN(client, 10 SECONDS)
		return FALSE

	message_admins("Non-BYOND user [new_ckey] (previously [key]) has been authenticated via [request.authentication_method].")

	STOP_PROCESSING(SSauthentication, src)

	log_in()

/// Switches the clients ckey, and continues the logging in
/mob/unauthenticated/proc/log_in()

	// Grab our client from the directory based on the *old* Guest ckey
	var/client/user = GLOB.directory[ckey]
	GLOB.directory -= ckey

	user.key = new_ckey
	GLOB.permitted_guests |= user.key

	// Readd the client to the directory with the *new* Guest ckey
	GLOB.directory[ckey] = user

	close_unauthenticated_menu(user)

	user.PreLogin()

	var/mob/new_mob = GLOB.ckey_to_occupied_mob[user.ckey]
	if(QDELETED(new_mob))
		new_mob = new /mob/new_player()

	new_mob.client = user

	new_mob.client.PostLogin()

/// Displays the usual lobby menu and moves the splitter all the way over, for the full screen effect
/mob/unauthenticated/proc/display_unauthenticated_menu()
	set waitfor = FALSE

	winset(client, null, list(
		"mainwindow.fullscreen_browser.is-disabled" = "false",
		"mainwindow.fullscreen_browser.is-visible" = "true",
	))

	unauthenticated_menu = new(client, "fullscreen_browser")
	unauthenticated_menu.initialize(
		assets = list(
				get_asset_datum(/datum/asset/simple/tgui),
				get_asset_datum(/datum/asset/simple/namespaced/chakrapetch)
			)
	)

	tgui_interact(src)

/mob/unauthenticated/proc/close_unauthenticated_menu(client/to_close)
	set waitfor = FALSE

	winset(to_close, null, list(
		"mainwindow.fullscreen_browser.is-disabled" = "true",
		"mainwindow.fullscreen_browser.is-visible" = "false",
	))

	to_close << browse(null, "window=authwindow")

/mob/unauthenticated/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "UnauthenticatedMenu", window = unauthenticated_menu)
		ui.closeable = FALSE
		ui.open(preinitialized = TRUE)

/mob/unauthenticated/ui_static_data(mob/user)
	. = ..()

	.["auth_options"] = list()

	var/config_options = CONFIG_GET(keyed_list/auth_urls)
	for(var/key in config_options)
		.["auth_options"] += list(
			list("name" = key, "url" = config_options[key])
		)

/mob/unauthenticated/ui_data(mob/user)
	. = ..()

	.["token"] = access_code

/mob/unauthenticated/ui_state(mob/user)
	return GLOB.always_state

/mob/unauthenticated/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	switch(action)
		if("open_browser")
			if(!access_code)
				create_access_code_entity()

			client << browse("<!DOCTYPE html><html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><meta http-equiv='X-UA-Compatible' content='IE=edge'><script>location.href = '[CONFIG_GET(keyed_list/auth_urls)[params["auth_option"]]]?code=[access_code]'</script></head><body></body></html>", "window=authwindow;titlebar=0;can_resize=0;size=[700 * client.window_scaling]x[700 * client.window_scaling]")

			START_PROCESSING(SSauthentication, src)
			return TRUE

		if("close_browser")
			client << browse(null, "window=authwindow")
			return TRUE

		if("open_ext_browser")
			if(!access_code)
				create_access_code_entity()

			client << link("[CONFIG_GET(keyed_list/auth_urls)[params["auth_option"]]]?code=[access_code]")
			START_PROCESSING(SSauthentication, src)
			return TRUE

		if("recall_code")
			if(!COOLDOWN_FINISHED(src, recall_code_cooldown))
				return

			if(!params["code"])
				return

			COOLDOWN_START(src, recall_code_cooldown, 5 SECONDS)

			check_logged_in(params["code"])

/// Informs the menu that we successfully logged in with a code, stores this for usage for the next few hours
/mob/unauthenticated/proc/notify_unauthenticated_menu()
	unauthenticated_menu.send_message("logged_in", list("access_code" = access_code))
