GLOBAL_LIST_EMPTY(permitted_guests)

/mob/unauthenticated
	invisibility = INVISIBILITY_ABSTRACT
	density = FALSE
	anchored = TRUE
	sight = BLIND
	stat = DEAD

	/// Where this user previously had their splitter, so they don't get too mad at us for moving it
	var/cached_splitter_location

	var/static/valid_characters = splittext("abcdefghijklmnopqrstuvwxyzAbCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", "")
	var/access_code

	var/datum/tgui_window/unauthenticated_menu

	var/new_ckey

	COOLDOWN_DECLARE(recall_code_cooldown)

/mob/unauthenticated/New(loc, ...)
	. = ..()

	GLOB.dead_mob_list -= src
	ADD_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_SOURCE_INHERENT)

/mob/unauthenticated/Login()
	. = ..()

	var/static/datum/preferences/dummy_preferences
	if(!dummy_preferences)
		dummy_preferences = new()

	client.prefs = dummy_preferences

	display_unauthenticated_menu()
	create_access_code_entity()

	check_logged_in()

/mob/unauthenticated/set_logged_in_mob()
	return FALSE

/// Creates our authentication request, stores the code in the database and on us
/mob/unauthenticated/proc/create_access_code_entity()
	WAIT_DB_READY

	access_code = generate_access_code()

	var/datum/entity/authentication_request/access_entity = DB_ENTITY(/datum/entity/authentication_request)
	access_entity.access_code = access_code
	access_entity.time = time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")
	access_entity.save()
	access_entity.detach()

#define ACCESS_CODE_LENGTH 20

/// Creates a base 62 access code
/mob/unauthenticated/proc/generate_access_code()
	var/code = ""

	for(var/i in 1 to ACCESS_CODE_LENGTH)
		code += pick(valid_characters)

	return code

#undef ACCESS_CODE_LENGTH

/// Polls the database to see if our access code has been validated
/mob/unauthenticated/proc/check_logged_in(code)
	var/datum/view_record/authentication_request/request = locate() in DB_VIEW(
		/datum/view_record/authentication_request,
		DB_AND(
			DB_COMP("access_code", DB_EQUALS, code ? code : access_code),
			DB_COMP("time", DB_GREATER, time2text(world.timeofday - 3 HOURS, "YYYY-MM-DD hh:mm:ss")),
			DB_COMP("approved", DB_EQUALS, TRUE)
		)
	)

	if(!request)
		if(!code)
			addtimer(CALLBACK(src, PROC_REF(check_logged_in)), 5 SECONDS)
		return

	if(request.external_username)
		client.external_username = ckey(request.external_username)

		new_ckey = "Guest-Forums-[client.external_username]"

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

	if(world.IsBanned(new_ckey, client.address, client.computer_id, real_bans_only = TRUE))
		unauthenticated_menu.send_message("banned")
		QDEL_IN(client, 10 SECONDS)
		return FALSE

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

	cached_splitter_location = winget(client, "mainwindow.split", "splitter")
	if(cached_splitter_location == "100")
		cached_splitter_location = "50"

	winset(client, null, list(
		"mainwindow.split.splitter" = "100",
		"mapwindow.lobby_browser.is-disabled" = "false",
		"mapwindow.lobby_browser.is-visible" = "true",
		"mapwindow.status_bar.is-visible" = "false",
	))

	unauthenticated_menu = new(client, "lobby_browser")
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
		"mainwindow.split.splitter" = cached_splitter_location,
		"mapwindow.lobby_browser.is-disabled" = "true",
		"mapwindow.lobby_browser.is-visible" = "false",
		"mapwindow.status_bar.is-visible" = "true",
	))


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

/mob/unauthenticated/ui_state(mob/user)
	return GLOB.always_state

/mob/unauthenticated/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	switch(action)
		if("open_browser")
			client << link("[CONFIG_GET(keyed_list/auth_urls)[params["auth_option"]]]?code=[access_code]")
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
