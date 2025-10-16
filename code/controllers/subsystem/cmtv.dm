#define PRIORITY_FIRST "1"
#define PRIORITY_SECOND "2"
#define PRIORITY_THIRD "3"

SUBSYSTEM_DEF(cmtv)
	name = "CMTV"
	wait = 5 SECONDS
	init_order = SS_INIT_CMTV

	/// Our perspective, based on a specific ckey, either found in init
	/// or post-join via DCS
	var/client/camera_operator

	/// For convenience, a reference to their camera mob
	var/mob/dead/observer/camera_mob

	/// A hardref to the person we are currently watching,
	/// with a bunch of signals subscribed.
	var/mob/current_perspective

	/// A weakref of who we will be switching to after the delay
	/// to ensure they can cancel, if they want to.
	var/datum/weakref/future_perspective

	/// The cached list of priority groups for observing. This is
	/// used so we can ensure we're only switching perspective
	/// if there is someone more interesting to watch instead.
	var/list/priority_list

	var/atom/movable/screen/cmtv/perspective_display

	/// How long until we should start polling to change perspective
	/// excluding mobs dying or other factors that make a mob ineligible
	/// based on DCS
	COOLDOWN_DECLARE(minimum_screentime)

	/// While we're currently checking out a different turf
	var/temporarily_observing_turf = FALSE

/datum/controller/subsystem/cmtv/Initialize()
	var/username = ckey(CONFIG_GET(string/cmtv_ckey))
	if(!username || !CONFIG_GET(string/cmtv_link))
		can_fire = FALSE
		return SS_INIT_NO_NEED

	RegisterSignal(SSdcs, COMSIG_GLOB_CLIENT_LOGGED_IN, PROC_REF(handle_new_client))

	var/camera = GLOB.directory[username]
	if(!camera)
		can_fire = FALSE
		return SS_INIT_NO_NEED

	perspective_display = new
	handle_new_camera(camera)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/cmtv/fire(resumed)
	priority_list = get_active_priority_player_list()

	if(temporarily_observing_turf)
		return

	if(is_ineligible(current_perspective) && !future_perspective)
		reset_perspective("Ineligible current perspective and no future perspective.")
		return

	if(minimum_screentime && !COOLDOWN_FINISHED(src, minimum_screentime))
		return

	if(future_perspective)
		return

	if(!length(priority_list[PRIORITY_FIRST]) || is_combatant(current_perspective, 40 SECONDS))
		return

	if(is_active(current_perspective, 20 SECONDS))
		return

	reset_perspective("Inactive (last 20 seconds), non-combatant (last 40 seconds).")

/datum/controller/subsystem/cmtv/stat_entry(msg)
	. = ..()
	return "[.] P: [current_perspective]"

/datum/controller/subsystem/cmtv/Topic(href, href_list)
	. = ..()

	if(href_list["abandon_cmtv"] && usr == current_perspective)
		reset_perspective("Current user requested reset (topic)")

	if(href_list["cancel_cmtv"] && usr == future_perspective.resolve())
		reset_perspective("Future user requested reset (topic)")

/datum/controller/subsystem/cmtv/proc/online()
	if(camera_operator)
		return TRUE

	return FALSE

/// Signal handler for if the client disconnects/rejoins midround
/datum/controller/subsystem/cmtv/proc/handle_new_client(SSdcs, client/new_client)
	SIGNAL_HANDLER

	if(new_client.ckey != ckey(CONFIG_GET(string/cmtv_ckey)))
		return

	can_fire = TRUE
	INVOKE_ASYNC(src, PROC_REF(handle_new_camera), new_client)

/// Sets up the camera client, including assigning a new mob, making it widescreen, winsetting() for clarity
/datum/controller/subsystem/cmtv/proc/handle_new_camera(client/camera_operator, round_start = FALSE)
	if(!istype(camera_operator))
		CRASH("Not a client ([camera_operator]) passed to [__PROC__]")

	src.camera_operator = camera_operator

	restart_chat()

	winset(camera_operator, null, {"
		tgui_say.is-disabled=true;
		tooltip.is-disabled=true;
		mapwindow.status_bar.is-visible=false;
		mainwindow.size=1920x1080;
		mainwindow.pos=0,0;
		"})

	camera_operator.prefs.hide_statusbar = TRUE
	camera_operator.prefs.toggles_chat &= ~(CHAT_GHOSTEARS|CHAT_GHOSTSIGHT|CHAT_LISTENINGBUG)
	camera_operator.prefs.auto_fit_viewport = TRUE
	camera_operator.prefs.toggle_prefs |= TOGGLE_FULLSCREEN

	camera_operator.update_fullscreen()
	winset(camera_operator, "split", "right=output_browser;splitter=75")

	camera_operator.screen += give_escape_menu_details()

	for(var/hud in list(MOB_HUD_MEDICAL_OBSERVER, MOB_HUD_XENO_STATUS, MOB_HUD_FACTION_OBSERVER))
		var/datum/mob_hud/hud_datum = GLOB.huds[hud]
		hud_datum.add_hud_to(camera_mob, camera_mob)

	if(!SSticker.HasRoundStarted() && !round_start)
		SSticker.OnRoundstart(CALLBACK(src, PROC_REF(setup_camera_mob)))
		return

	setup_camera_mob()

	if(!QDELETED(current_perspective))
		camera_mob.do_observe(current_perspective)

/datum/controller/subsystem/cmtv/proc/setup_camera_mob()
	var/mob/dead/observer/new_mob = new(locate(1, 1, 1))
	new_mob.client = camera_operator
	new_mob.see_invisible = HIDE_INVISIBLE_OBSERVER
	new_mob.alpha = 0

	camera_mob = new_mob

	camera_operator.view = "20x15"
	camera_operator.update_fullscreen()

/// For events we want to occur at the beginning of the round - eg, when the map becomes actually visible
/datum/controller/subsystem/cmtv/proc/handle_roundstart()
	addtimer(CALLBACK(src, PROC_REF(restart_chat), 10 SECONDS))

/datum/controller/subsystem/cmtv/proc/restart_chat()
	if(!online())
		return

	camera_operator.nuke_chat()
	addtimer(CALLBACK(src, PROC_REF(do_init_chat)), 0.5 SECONDS)

/// To ensure the chat is fully initialised after we nuke it, we wait a bit before sending it an action
/datum/controller/subsystem/cmtv/proc/do_init_chat()
	camera_operator.fit_viewport()
	camera_operator.tgui_panel.window.send_message("game/tvmode")

/// Takes a new mob to observe. If there is already a queued up mob, or a current perspective, they will be notified and dropped. This will become the new perspective in 10 seconds.
/// If set to instant, we immediately switch to observe nothing. If set_showtime is set, the camera will stay on the new perspective for at least this long,
/// unless they die or something.
/datum/controller/subsystem/cmtv/proc/change_observed_mob(mob/new_perspective, instant_switch_away = FALSE, instant_switch_to = FALSE, set_showtime = FALSE)
	if(new_perspective == current_perspective)
		log_debug("CMTV: New perspective same as the old perspective, skipping change.")
		return

	log_debug("CMTV: Swapping to perspective [new_perspective].")

	if(current_perspective)
		terminate_current_perspective()

	if(instant_switch_away)
		camera_mob.clean_observe_target()
		camera_mob.forceMove(pick(GLOB.observer_starts))

	if(!set_showtime)
		minimum_screentime = null

	if(is_ineligible(new_perspective))
		log_debug("CMTV: Perspective could not be swapped to, picking new perspective.")
		return reset_perspective("New perspective does not exist or is not cliented.")

	if(future_perspective)
		to_chat(future_perspective, boxed_message("[SPAN_BIGNOTICE("You are no longer going to be observed.")]\n\n [SPAN_NOTICE("You have been opted out of displaying on CMTV.")]"))

	add_verb(new_perspective, /mob/proc/handoff_cmtv)
	give_action(new_perspective, /datum/action/stop_cmtv)

	if(instant_switch_to)
		do_change_observed_mob(set_showtime)
		return

	var/cmtv_link = CONFIG_GET(string/cmtv_link)
	to_chat(new_perspective, boxed_message("[SPAN_BIGNOTICE("You will be observed in 10 seconds.")]\n\n [SPAN_NOTICE("Your perspective will be shared on <a href='[cmtv_link]'>[cmtv_link]</a>. If you wish to cancel this, press <a href='byond://?src=\ref[src];cancel_cmtv=1'>here</a>.")]"))

	future_perspective = WEAKREF(new_perspective)
	addtimer(CALLBACK(src, PROC_REF(do_change_observed_mob), set_showtime), 10 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)

/datum/controller/subsystem/cmtv/proc/do_change_observed_mob(set_showtime = FALSE)
	if(!istype(future_perspective))
		log_debug("CMTV: Perspective changed while we were waiting, aborting.")
		future_perspective = null
		return

	var/mob/future_perspective_mob = future_perspective.resolve()
	if(!future_perspective_mob || !future_perspective_mob.client)
		log_debug("CMTV: Perspective could not resolve, aborting.")
		future_perspective = null
		return

	RegisterSignal(future_perspective_mob, list(COMSIG_PARENT_QDELETING, COMSIG_MOB_STAT_SET_DEAD, COMSIG_MOB_NESTED, COMSIG_MOB_LOGOUT, COMSIG_MOB_DEATH), PROC_REF(handle_reset_signal))
	RegisterSignal(future_perspective_mob, COMSIG_MOVABLE_ENTERED_OBJ, PROC_REF(handle_reset_signal_immediate))
	RegisterSignal(future_perspective_mob, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(handle_z_change))
	current_perspective = future_perspective_mob
	change_displayed_mob(current_perspective.real_name)

	camera_operator.screen += give_escape_menu_details()

	var/cmtv_link = CONFIG_GET(string/cmtv_link)
	to_chat(current_perspective, boxed_message("[SPAN_BIGNOTICE("You are being observed.")]\n\n [SPAN_NOTICE("Your perspective is currently being shared on <a href='[cmtv_link]'>[cmtv_link]</a>. If you wish to hand this off to a different player, press <a href='byond://?src=\ref[src];abandon_cmtv=1'>here</a>. You can also use the verb 'Handoff CMTV' at any point.")]"))

	camera_mob.sight = current_perspective.sight
	camera_mob.do_observe(current_perspective)
	if(set_showtime)
		COOLDOWN_START(src, minimum_screentime, set_showtime)

	future_perspective = null

	log_debug("CMTV: Perspective successfully changed to [current_perspective].")

/datum/controller/subsystem/cmtv/proc/terminate_current_perspective(ticker_text = "Finding player...")
	to_chat(current_perspective, boxed_message("[SPAN_BIGNOTICE("You are no longer being observed.")]\n\n [SPAN_NOTICE("You have opted out or are no longer eligible to be displayed on CMTV.")]"))

	UnregisterSignal(current_perspective, list(COMSIG_PARENT_QDELETING, COMSIG_MOB_STAT_SET_DEAD, COMSIG_MOB_NESTED, COMSIG_MOB_LOGOUT, COMSIG_MOB_DEATH, COMSIG_MOVABLE_Z_CHANGED, COMSIG_MOVABLE_ENTERED_OBJ))

	remove_verb(current_perspective, /mob/proc/handoff_cmtv)
	remove_action(current_perspective, /datum/action/stop_cmtv)

	current_perspective = null

	if(ticker_text)
		change_displayed_mob(ticker_text)

/// Signal handler - it might be dull if a player wanders off to medical on the ship.
/datum/controller/subsystem/cmtv/proc/handle_z_change(atom/movable/moving, old_z, new_z)
	SIGNAL_HANDLER

	if(SSticker.mode?.is_in_endgame)
		return

	if(is_ground_level(new_z))
		return // getting into the action

	if(is_reserved_level(old_z) && is_mainship_level(new_z))
		reset_perspective("Current perspective is going to the ship.") // dull, either fleeing or going to med

/// Generic reset handler, will keep the perspective on the old mob till the new one accepts
/datum/controller/subsystem/cmtv/proc/handle_reset_signal()
	SIGNAL_HANDLER

	reset_perspective("Current perspective is no longer eligible (signal)")

/// Reset handler that immediately switches perspective to something generic while we wait
/datum/controller/subsystem/cmtv/proc/handle_reset_signal_immediate()
	SIGNAL_HANDLER

	reset_perspective("Current perspective is no longer eligible (instant signal)", instant = TRUE)

/// Generic signal handler for deaths, nestings, logouts, etc. Immediately queues up a new perspective to be switched to
/datum/controller/subsystem/cmtv/proc/reset_perspective(reason, instant = FALSE)
	log_debug("CMTV: Perspective reset requested: [reason].")

	var/mob/active_player = get_active_player()
	if(!active_player)
		log_debug("CMTV: Unable to find an appropriate player.")
		return FALSE // start the blooper reel, we've got nothing

	change_observed_mob(get_active_player(), instant)

/datum/controller/subsystem/cmtv/proc/spectate_event(event, turf/where_to_look, how_long_for = 20 SECONDS, zoom_out = FALSE, when_start = 0)
	if(!how_long_for || !where_to_look)
		return

	if(!istype(where_to_look))
		where_to_look = get_turf(where_to_look)

	if(when_start > 0)
		addtimer(CALLBACK(src, PROC_REF(spectate_event), event, where_to_look, how_long_for, zoom_out), when_start)
		return

	temporarily_observing_turf = TRUE

	var/to_switch_to = null
	if(minimum_screentime && world.time + how_long_for < minimum_screentime)
		to_switch_to = current_perspective

	if(current_perspective)
		terminate_current_perspective(ticker_text = null)
		camera_mob.clean_observe_target()

	camera_mob.abstract_move(where_to_look)

	change_displayed_mob(event)

	camera_mob.hud_used.plane_masters["[HUD_PLANE]"].alpha = 0
	camera_mob.sight = SEE_TURFS|SEE_MOBS|SEE_OBJS

	if(zoom_out)
		camera_operator.view = "32x24"

	addtimer(CALLBACK(src, PROC_REF(end_spectate_event), to_switch_to), how_long_for - 10 SECONDS)

/datum/controller/subsystem/cmtv/proc/end_spectate_event(mob/to_switch_to)
	camera_mob.hud_used.plane_masters["[HUD_PLANE]"].alpha = 255

	temporarily_observing_turf = FALSE

	camera_operator.view = "20x15"

	if(to_switch_to)
		change_observed_mob(to_switch_to, instant_switch_to = TRUE)
		return

	reset_perspective("Turf spectation ended.")

#define PERSPECTIVE_SELECTION_DELAY_TIME (20 SECONDS)

/// Returns a list of weakrefs of mobs in certain priority groups. Priority 1 are active combatants, Priority 2 are mobs that are active and on the
/// groundmap (except in hijack, where they must just be active) and Priority 3 are mobs that are, at least, active.
/datum/controller/subsystem/cmtv/proc/get_active_priority_player_list()
	var/new_priority_list = list(PRIORITY_FIRST = list(), PRIORITY_SECOND = list(), PRIORITY_THIRD = list())

	for(var/mob/mob in GLOB.living_player_list)
		if(!is_active(mob, PERSPECTIVE_SELECTION_DELAY_TIME))
			continue

		if(is_combatant(mob, PERSPECTIVE_SELECTION_DELAY_TIME))
			new_priority_list[PRIORITY_FIRST] += WEAKREF(mob)
			continue

		if(!is_ground_level(mob.z) && !SSticker.mode?.is_in_endgame)
			new_priority_list[PRIORITY_THIRD] += WEAKREF(mob)
			continue

		new_priority_list[PRIORITY_SECOND] += WEAKREF(mob)

	return new_priority_list

/// From the cached priority list, pulls an active player in priority order
/datum/controller/subsystem/cmtv/proc/get_active_player()
	if(!length(priority_list))
		return FALSE

	for(var/priority in priority_list)
		var/list/priority_mobs_list = priority_list[priority]

		if(!length(priority_mobs_list))
			continue

		var/list/cloned_mob_list = priority_mobs_list.Copy()
		for(var/i in 1 to length(cloned_mob_list))
			var/datum/weakref/picked = pick_n_take(cloned_mob_list)
			var/mob/resolved = picked.resolve()

			if(resolved && is_active(resolved, PERSPECTIVE_SELECTION_DELAY_TIME))
				return resolved

	return FALSE

/// Returns the mob list with the greatest priority. If there are priority 1 mobs, it will return that list, even if there is only one.
/datum/controller/subsystem/cmtv/proc/get_most_active_list()
	if(!length(priority_list))
		return

	for(var/priority in priority_list)
		var/list/priority_mobs_list = priority_list[priority]

		if(!length(priority_mobs_list))
			continue

		return priority_mobs_list

/// If a player is still categorised as being active
/datum/controller/subsystem/cmtv/proc/is_active(mob/possible_player, delay_time)
	if(is_ineligible(possible_player))
		return

	if(world.time > possible_player.client.talked_at + delay_time)
		return FALSE

	if(world.time > possible_player.l_move_time + delay_time)
		return FALSE

	return TRUE

/datum/controller/subsystem/cmtv/proc/is_ineligible(mob/possible_player)
	if(!possible_player)
		return TRUE

	if(!possible_player.client)
		return TRUE

	if(!isturf(possible_player.loc))
		return TRUE

	return FALSE

/// Checks if the latest [/datum/cause_data] was generated within the given delay_time
/datum/controller/subsystem/cmtv/proc/is_combatant(mob/possible_combatant, delay_time)
	var/mob_ref = REF(possible_combatant)
	if(!(mob_ref in GLOB.ref_mob_to_last_cause_data_time))
		return FALSE

	if(GLOB.ref_mob_to_last_cause_data_time[mob_ref] + delay_time <= world.time)
		return FALSE

	return TRUE

/datum/controller/subsystem/cmtv/proc/change_displayed_mob(display_name)
	perspective_display.maptext = MAPTEXT("<span style='text-align: center;'><span style='text-decoration: underline; font-size: 12px;'>Currently observing:</span><br><span style='font-size: 16px;'>[display_name]</span></span>")
	camera_operator.screen += perspective_display

/mob/proc/handoff_cmtv()
	set name = "Handoff CMTV"
	set category = "OOC.CMTV"

	if(SScmtv.current_perspective == src)
		SScmtv.reset_perspective("Current user requested reset (verb)")

	if(SScmtv.future_perspective?.resolve() == src)
		SScmtv.reset_perspective("Future user requested reset (verb)")

/client/proc/change_observed_player()
	set name = "Change Observed Player"
	set category = "Admin.CMTV"

	if(!SScmtv.online())
		return to_chat(src, SPAN_WARNING("CMTV is currently offline!"))

	var/mob/selected_mob = tgui_input_list(src, "Who should be selected for observation?", "CMTV Target", GLOB.player_list)
	if(!selected_mob)
		return

	var/how_long = tgui_input_number(src, "How long should we stay on this perspective (in seconds)? Set 0 to not force a length.", "CMTV Length", default = 60)

	message_admins("CMTV: [key_name(src)] swapped the perspective to [key_name_admin(selected_mob)].")
	SScmtv.change_observed_mob(selected_mob, set_showtime = how_long)

/datum/config_entry/string/cmtv_ckey
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/string/cmtv_link
	protection = CONFIG_ENTRY_LOCKED

/atom/movable/screen/cmtv
	plane = ESCAPE_MENU_PLANE
	clear_with_screen = FALSE
	icon_state = "blank"

	screen_loc = "CENTER-5,NORTH-1.5"

	appearance_flags = RESET_COLOR|RESET_TRANSFORM|NO_CLIENT_COLOR|PIXEL_SCALE

	maptext_height = 400
	maptext_width = 400

/datum/action/stop_cmtv
	name = "Stop CMTV"
	icon_file = 'icons/obj/structures/machinery/monitors.dmi'
	action_icon_state = "camera"

/datum/action/stop_cmtv/action_activate()
	. = ..()

	if(owner == SScmtv.current_perspective)
		SScmtv.reset_perspective("Current user requested reset (action)")

	if(owner == SScmtv.future_perspective?.resolve())
		SScmtv.reset_perspective("Future user requested reset (action)")

#undef PRIORITY_FIRST
#undef PRIORITY_SECOND
#undef PRIORITY_THIRD
