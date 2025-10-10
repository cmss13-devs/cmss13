#define PRIORITY_FIRST "1"
#define PRIORITY_SECOND "2"
#define PRIORITY_THIRD "3"

SUBSYSTEM_DEF(cmtv)
	name = "CMTV"
	wait = 5 SECONDS

	var/client/camera_operator
	var/mob/dead/observer/camera_mob

	var/mob/current_perspective
	var/datum/weakref/future_perspective

	var/list/priority_list

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

/datum/controller/subsystem/cmtv/proc/handle_new_client(SSdcs, client/new_client)
	SIGNAL_HANDLER

	if(new_client.ckey != ckey(CONFIG_GET(string/cmtv_ckey)))
		return

	INVOKE_ASYNC(src, PROC_REF(handle_new_camera), new_client)

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

	camera_operator.view = "20x15"
	camera_operator.prefs.auto_fit_viewport = TRUE
	camera_operator.prefs.toggle_prefs |= TOGGLE_FULLSCREEN
	camera_operator.update_fullscreen()

	camera_operator.prefs.hide_statusbar = TRUE

	camera_operator.prefs.toggles_chat &= ~(CHAT_GHOSTEARS|CHAT_GHOSTSIGHT|CHAT_LISTENINGBUG)

	camera_operator.nuke_chat()
	addtimer(CALLBACK(src, PROC_REF(do_init_chat)), 2 SECONDS)

	winset(camera_operator, null, "infowindow.info.splitter=0;tgui_say.is-disabled=true;tooltip.is-disabled=true;mapwindow.status_bar.is-visible=false")

	camera_mob = new_mob

	if(!QDELETED(current_perspective))
		camera_mob.do_observe(current_perspective)

/datum/controller/subsystem/cmtv/proc/do_init_chat()
	camera_operator.tgui_panel.window.send_message("chat/disableScroll")

/datum/controller/subsystem/cmtv/proc/change_observed_mob(mob/new_perspective)
	if(current_perspective)
		to_chat(current_perspective, boxed_message("[SPAN_BIGNOTICE("You are no longer being observed.")]\n\n [SPAN_NOTICE("You have opted out or are no longer eligible to be displayed on CMTV.")]"))

		UnregisterSignal(current_perspective, list(COMSIG_PARENT_QDELETING, COMSIG_MOB_STAT_SET_DEAD, COMSIG_MOB_NESTED, COMSIG_MOB_LOGOUT, COMSIG_MOB_DEATH, COMSIG_MOVABLE_Z_CHANGED))
		remove_verb(current_perspective, /client/proc/handoff_cmtv)
		current_perspective = null

	if(!istype(new_perspective) || !new_perspective.client)
		return reset_perspective()

	if(future_perspective)
		to_chat(future_perspective, boxed_message("[SPAN_BIGNOTICE("You are no longer going to be observed.")]\n\n [SPAN_NOTICE("You have been opted out of displaying on CMTV.")]"))

	var/cmtv_link = CONFIG_GET(string/cmtv_link)
	to_chat(new_perspective, boxed_message("[SPAN_BIGNOTICE("You will be observed in 10 seconds.")]\n\n [SPAN_NOTICE("Your perspective will be shared on <a href='[cmtv_link]'>[cmtv_link]</a>. If you wish to cancel this, press <a href='byond://?src=\ref[src];cancel_cmtv=1'>here</a>.")]"))
	future_perspective = WEAKREF(new_perspective)

	addtimer(CALLBACK(src, PROC_REF(do_change_observed_mob)), 10 SECONDS)

/datum/controller/subsystem/cmtv/proc/do_change_observed_mob()
	if(!istype(future_perspective))
		return reset_perspective()

	var/mob/future_perspective_mob = future_perspective.resolve()
	if(!future_perspective_mob || !future_perspective_mob.client)
		return reset_perspective()

	RegisterSignal(future_perspective_mob, list(COMSIG_PARENT_QDELETING, COMSIG_MOB_STAT_SET_DEAD, COMSIG_MOB_NESTED, COMSIG_MOB_LOGOUT, COMSIG_MOB_DEATH), PROC_REF(reset_perspective))
	RegisterSignal(future_perspective_mob, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(handle_z_change))
	current_perspective = future_perspective_mob

	var/cmtv_link = CONFIG_GET(string/cmtv_link)
	to_chat(current_perspective, boxed_message("[SPAN_BIGNOTICE("You are being observed.")]\n\n [SPAN_NOTICE("Your perspective is currently being shared on <a href='[cmtv_link]'>[cmtv_link]</a>. If you wish to hand this off to a different player, press <a href='byond://?src=\ref[src];abandon_cmtv=1'>here</a>. You can also use the verb 'Handoff CMTV' at any point.")]"))
	add_verb(current_perspective, /client/proc/handoff_cmtv)

	camera_mob.do_observe(current_perspective)

/datum/controller/subsystem/cmtv/proc/handle_z_change(atom/movable/moving, old_z, new_z)
	SIGNAL_HANDLER

	if(SSticker.mode?.is_in_endgame)
		return

	if(is_ground_level(new_z))
		return // getting into the action

	if(is_ground_level(old_z) && is_mainship_level(new_z))
		reset_perspective() // dull, either fleeing or going to med

/datum/controller/subsystem/cmtv/proc/reset_perspective(mob/old_perspective)
	SIGNAL_HANDLER

	change_observed_mob(get_active_player())

#define PERSPECTIVE_SELECTION_DELAY_TIME (20 SECONDS)

/datum/controller/subsystem/cmtv/proc/get_active_priority_player_list()
	var/new_priority_list = list(PRIORITY_FIRST = list(), PRIORITY_SECOND = list(), PRIORITY_THIRD = list())

	for(var/mob/mob in GLOB.living_player_list)
		if(!is_active(mob, PERSPECTIVE_SELECTION_DELAY_TIME))
			continue

		if(!is_ground_level(mob.z) && !SSticker.mode?.is_in_endgame)
			new_priority_list[PRIORITY_THIRD] += WEAKREF(mob)
			continue

		if(!is_combatant(mob, PERSPECTIVE_SELECTION_DELAY_TIME))
			new_priority_list[PRIORITY_SECOND] += WEAKREF(mob)
			continue

		new_priority_list[PRIORITY_FIRST] += WEAKREF(mob)

	return new_priority_list

/datum/controller/subsystem/cmtv/proc/get_active_player()
	for(var/priority, priority_mobs in priority_list)
		var/list/priority_mobs_list = priority_mobs
		if(length(priority_mobs))
			var/list/inner_priority_list = priority_mobs_list.Copy()
	
			for(var/i in 1 to length(inner_priority_list))
				var/datum/weakref/picked = pick_n_take(inner_priority_list)
				var/found_mob = picked.resolve()

				if(found_mob)
					return found_mob

/datum/controller/subsystem/cmtv/proc/is_active(mob/possible_player, delay_time)
	if(possible_player.client?.inactivity > delay_time)
		return FALSE

	if(world.time > possible_player.l_move_time + delay_time)
		return FALSE

	return TRUE

/datum/controller/subsystem/cmtv/proc/is_combatant(mob/possible_combatant, delay_time)
	var/mob_ref = REF(possible_combatant)
	if(!(mob_ref in GLOB.ref_mob_to_last_cause_data_time))
		return FALSE

	if(GLOB.ref_mob_to_last_cause_data_time[mob_ref] + delay_time <= world.time)
		return FALSE

	return TRUE

/client/proc/handoff_cmtv()
	set name = "Handoff CMTV"
	set category = "OOC.CMTV"

	if(SScmtv.current_perspective == mob)
		SScmtv.reset_perspective()

/client/proc/change_observed_player(mob/new_player in GLOB.player_list)
	set name = "Change Observed Player"
	set category = "Admin.CMTV"

	SScmtv.change_observed_mob(new_player)

/datum/controller/subsystem/cmtv/proc/handle_round_start(client/camera)
	addtimer(CALLBACK(src, PROC_REF(handle_new_camera), camera, TRUE), 5 SECONDS)

/datum/config_entry/string/cmtv_ckey
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/string/cmtv_link
	protection = CONFIG_ENTRY_LOCKED

#undef PRIORITY_FIRST
#undef PRIORITY_SECOND
#undef PRIORITY_THIRD
