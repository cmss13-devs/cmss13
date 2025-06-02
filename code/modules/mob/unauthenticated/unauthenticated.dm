/mob/unauthenticated
	invisibility = INVISIBILITY_ABSTRACT
	density = FALSE
	anchored = TRUE
	sight = BLIND
	stat = DEAD

	/// Where this user previously had their splitter, so they don't get too mad at us for moving it
	var/cached_splitter_location

	var/static/valid_characters = list("abcdefghijklmnopqrstuvwxyzAbCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
	var/access_code

	var/datum/tgui_window/unauthenticated_menu

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

	client.external_username = ckey(request.external_username)

	if(!code)
		notify_unauthenticated_menu()

	log_in()

/// Switches the clients ckey, and continues the logging in
/mob/unauthenticated/proc/log_in()
	client.ckey = "guest-[client.external_username]"

	client.PreLogin()

	var/mob/new_player/new_mob = new()
	new_mob.client = client

	client.PostLogin()

/// Displays the usual lobby menu and moves the splitter all the way over, for the full screen effect
/mob/unauthenticated/proc/display_unauthenticated_menu()
	set waitfor = FALSE

	cached_splitter_location = winget(client, "mainwindow.split", "splitter")

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

/mob/unauthenticated/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "UnauthenticatedMenu", window = unauthenticated_menu)
		ui.closeable = FALSE
		ui.open(preinitialized = TRUE)

/mob/unauthenticated/ui_state(mob/user)
	return GLOB.always_state

/mob/unauthenticated/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	switch(action)
		if("open_browser")
			client << link("[CONFIG_GET(string/auth_url)]&code=[access_code]")
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
