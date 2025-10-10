#define PRIORITY_FIRST "1"
#define PRIORITY_SECOND "2"
#define PRIORITY_THIRD "3"

SUBSYSTEM_DEF(cmtv)
	name = "CMTV"
	wait = 5 SECONDS

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

	/// The world.time when we should move over to our new watchee
	var/swap_at


/datum/controller/subsystem/cmtv/Initialize()
	var/username = ckey(CONFIG_GET(string/cmtv_ckey))
	if(!username || !CONFIG_GET(string/cmtv_link))
		return SS_INIT_NO_NEED

	RegisterSignal(SSdcs, COMSIG_GLOB_CLIENT_LOGGED_IN, PROC_REF(handle_new_client))

	var/camera = GLOB.directory[username]
	if(!camera)
		return SS_INIT_NO_NEED

	handle_new_camera(camera)

/datum/controller/subsystem/cmtv/fire(resumed)
	priority_list = get_active_priority_player_list()

	if(future_perspective && swap_at <= world.time)
		do_change_observed_mob()
		return

	if(!current_perspective && !future_perspective)
		reset_perspective()
		return

	if(!length(priority_list[PRIORITY_FIRST]) || is_combatant(current_perspective, 40 SECONDS))
		return

	if(is_active(current_perspective, 20 SECONDS))
		return

	reset_perspective()

/datum/controller/subsystem/cmtv/Topic(href, href_list)
	. = ..()
	
	if(href_list["abandon_cmtv"] && usr == current_perspective)
		reset_perspective()

	if(href_list["cancel_cmtv"] && usr == future_perspective.resolve())
		reset_perspective()

/// Signal handler for if the client disconnects/rejoins midround
/datum/controller/subsystem/cmtv/proc/handle_new_client(SSdcs, client/new_client)
	SIGNAL_HANDLER

	if(new_client.ckey != ckey(CONFIG_GET(string/cmtv_ckey)))
		return

	INVOKE_ASYNC(src, PROC_REF(handle_new_camera), new_client)

/// Sets up the camera client, including assigning a new mob, making it widescreen, winsetting() for clarity
/datum/controller/subsystem/cmtv/proc/handle_new_camera(client/camera_operator, round_start = FALSE)
	if(!istype(camera_operator))
		CRASH("Not a client ([camera_operator]) passed to [__PROC__]")

	if(!SSticker.HasRoundStarted() && !round_start)
		SSticker.OnRoundstart(CALLBACK(src, PROC_REF(handle_new_camera), camera_operator, TRUE))
		return

	src.camera_operator = camera_operator

	var/mob/dead/observer/new_mob = new(locate(1, 1, 1))
	new_mob.client = camera_operator
	new_mob.see_invisible = HIDE_INVISIBLE_OBSERVER
	new_mob.alpha = 0

	camera_mob = new_mob

	camera_operator.nuke_chat()
	addtimer(CALLBACK(src, PROC_REF(do_init_chat)), 2 SECONDS)

	winset(camera_operator, null, {"
		infowindow.info.splitter=0;
		tgui_say.is-disabled=true;
		tooltip.is-disabled=true;
		mapwindow.status_bar.is-visible=false;
		mainwindow.size=1920x1080;
		mainwindow.pos=0,0;
		"})

	camera_operator.view = "20x15"
	camera_operator.prefs.auto_fit_viewport = TRUE
	camera_operator.prefs.toggle_prefs |= TOGGLE_FULLSCREEN
	camera_operator.update_fullscreen()

	for(var/hud in list(MOB_HUD_MEDICAL_OBSERVER, MOB_HUD_XENO_STATUS, MOB_HUD_FACTION_OBSERVER))
		var/datum/mob_hud/hud_datum = GLOB.huds[hud]
		hud_datum.add_hud_to(camera_mob, camera_mob)

	camera_operator.prefs.hide_statusbar = TRUE
	camera_operator.prefs.toggles_chat &= ~(CHAT_GHOSTEARS|CHAT_GHOSTSIGHT|CHAT_LISTENINGBUG)

	if(!QDELETED(current_perspective))
		camera_mob.do_observe(current_perspective)

/// To ensure the chat is fully initialised after we nuke it, we wait a bit before sending it an action
/datum/controller/subsystem/cmtv/proc/do_init_chat()
	camera_operator.tgui_panel.window.send_message("chat/disableScroll")

/// Takes a new mob to observe. If there is already a queued up mob, or a current perspective, they will be notified and dropped. This will become the new perspective in 10 seconds.
/datum/controller/subsystem/cmtv/proc/change_observed_mob(mob/new_perspective)
	log_debug("CMTV: Swapping to perspective [new_perspective].")

	if(current_perspective)
		to_chat(current_perspective, boxed_message("[SPAN_BIGNOTICE("You are no longer being observed.")]\n\n [SPAN_NOTICE("You have opted out or are no longer eligible to be displayed on CMTV.")]"))

		UnregisterSignal(current_perspective, list(COMSIG_PARENT_QDELETING, COMSIG_MOB_STAT_SET_DEAD, COMSIG_MOB_NESTED, COMSIG_MOB_LOGOUT, COMSIG_MOB_DEATH, COMSIG_MOVABLE_Z_CHANGED))
		remove_verb(current_perspective, /mob/proc/handoff_cmtv)
		current_perspective = null

	if(!istype(new_perspective) || !new_perspective.client)
		log_debug("CMTV: Perspective could not be swapped to, picking new perspective.")
		return reset_perspective()

	if(future_perspective)
		to_chat(future_perspective, boxed_message("[SPAN_BIGNOTICE("You are no longer going to be observed.")]\n\n [SPAN_NOTICE("You have been opted out of displaying on CMTV.")]"))

	var/cmtv_link = CONFIG_GET(string/cmtv_link)
	to_chat(new_perspective, boxed_message("[SPAN_BIGNOTICE("You will be observed in 10 seconds.")]\n\n [SPAN_NOTICE("Your perspective will be shared on <a href='[cmtv_link]'>[cmtv_link]</a>. If you wish to cancel this, press <a href='byond://?src=\ref[src];cancel_cmtv=1'>here</a>.")]"))

	future_perspective = WEAKREF(new_perspective)
	swap_at = world.time + 10 SECONDS

/datum/controller/subsystem/cmtv/proc/do_change_observed_mob()
	if(!istype(future_perspective))
		log_debug("CMTV: Perspective changed while we were waiting, aborting and resetting.")
		return reset_perspective()

	var/mob/future_perspective_mob = future_perspective.resolve()
	if(!future_perspective_mob || !future_perspective_mob.client)
		log_debug("CMTV: Perspective could not resolve, aborting and resetting.")
		return reset_perspective()

	RegisterSignal(future_perspective_mob, list(COMSIG_PARENT_QDELETING, COMSIG_MOB_STAT_SET_DEAD, COMSIG_MOB_NESTED, COMSIG_MOB_LOGOUT, COMSIG_MOB_DEATH), PROC_REF(reset_perspective))
	RegisterSignal(future_perspective_mob, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(handle_z_change))
	current_perspective = future_perspective_mob

	var/cmtv_link = CONFIG_GET(string/cmtv_link)
	to_chat(current_perspective, boxed_message("[SPAN_BIGNOTICE("You are being observed.")]\n\n [SPAN_NOTICE("Your perspective is currently being shared on <a href='[cmtv_link]'>[cmtv_link]</a>. If you wish to hand this off to a different player, press <a href='byond://?src=\ref[src];abandon_cmtv=1'>here</a>. You can also use the verb 'Handoff CMTV' at any point.")]"))
	add_verb(current_perspective, /mob/proc/handoff_cmtv)

	camera_mob.do_observe(current_perspective)

	future_perspective = null

	log_debug("CMTV: Perspective successfully changed to [current_perspective].")

/// Signal handler - it might be dull if a player wanders off to medical on the ship.
/datum/controller/subsystem/cmtv/proc/handle_z_change(atom/movable/moving, old_z, new_z)
	SIGNAL_HANDLER

	if(SSticker.mode?.is_in_endgame)
		return

	if(is_ground_level(new_z))
		return // getting into the action

	if(is_ground_level(old_z) && is_mainship_level(new_z))
		reset_perspective() // dull, either fleeing or going to med

/// Generic signal handler for deaths, nestings, logouts, etc. Immediately queues up a new perspective to be switched to
/datum/controller/subsystem/cmtv/proc/reset_perspective()
	SIGNAL_HANDLER

	log_debug("CMTV: Perspective reset requested.")

	var/mob/active_player = get_active_player()
	if(!active_player)
		log_debug("CMTV: Unable to find an appropriate player.")
		return FALSE // start the blooper reel, we've got nothing

	change_observed_mob(get_active_player())

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

	for(var/priority, priority_mobs in priority_list)
		var/list/priority_mobs_list = priority_mobs
		if(length(priority_mobs))
			var/list/inner_priority_list = priority_mobs_list.Copy()

			for(var/i in 1 to length(inner_priority_list))
				var/datum/weakref/picked = pick_n_take(inner_priority_list)
				var/found_mob = picked.resolve()

				if(found_mob && is_active(found_mob))
					return found_mob

	return FALSE

/// If a player has moved recently, also checks the inactivity var
/datum/controller/subsystem/cmtv/proc/is_active(mob/possible_player, delay_time)
	if(!possible_player.client)
		return FALSE
	
	if(possible_player.client.inactivity > delay_time)
		return FALSE

	if(world.time > possible_player.l_move_time + delay_time)
		return FALSE

	return TRUE

/// Checks if the latest [/datum/cause_data] was generated within the given delay_time
/datum/controller/subsystem/cmtv/proc/is_combatant(mob/possible_combatant, delay_time)
	var/mob_ref = REF(possible_combatant)
	if(!(mob_ref in GLOB.ref_mob_to_last_cause_data_time))
		return FALSE

	if(GLOB.ref_mob_to_last_cause_data_time[mob_ref] + delay_time <= world.time)
		return FALSE

	return TRUE

/mob/proc/handoff_cmtv()
	set name = "Handoff CMTV"
	set category = "OOC.CMTV"

	if(SScmtv.current_perspective == src)
		SScmtv.reset_perspective()

/client/proc/change_observed_player()
	set name = "Change Observed Player"
	set category = "Admin.CMTV"

	var/mob/selected_mob = tgui_input_list(src, "Who should be selected for observation?", "CMTV Target", GLOB.player_list)
	if(!selected_mob)
		return

	message_admins("CMTV: [key_name(src)] swapped the perspective to [key_name_admin(selected_mob)].")
	SScmtv.change_observed_mob(selected_mob)

/datum/config_entry/string/cmtv_ckey
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/string/cmtv_link
	protection = CONFIG_ENTRY_LOCKED

#undef PRIORITY_FIRST
#undef PRIORITY_SECOND
#undef PRIORITY_THIRD
