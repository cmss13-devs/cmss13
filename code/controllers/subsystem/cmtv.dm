SUBSYSTEM_DEF(cmtv)
	name = "CMTV"
	wait = 1 SECONDS
	flags = SS_NO_FIRE

	var/client/camera_operator
	var/mob/dead/observer/camera_mob

	var/mob/current_perspective

/datum/controller/subsystem/cmtv/Initialize()
	var/username = ckey(CONFIG_GET(string/cmtv_ckey))
	if(!username)
		return SS_INIT_NO_NEED

	RegisterSignal(SSdcs, COMSIG_GLOB_CLIENT_LOGGED_IN, PROC_REF(handle_new_client))

	var/camera = GLOB.directory[username]
	if(!camera)
		return SS_INIT_NO_NEED

	handle_new_camera(camera)

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

	camera_operator.tgui_panel.window.send_message("chat/disableScroll")

	winset(camera_operator, null, "infowindow.info.splitter=0;tgui_say.is-disabled=true;tooltip.is-disabled=true;mapwindow.status_bar.is-visible=false")

	camera_mob = new_mob

	if(!QDELETED(current_perspective))
		camera_mob.do_observe(current_perspective)

/datum/controller/subsystem/cmtv/proc/change_observed_mob(mob/new_perspective)
	if(current_perspective)
		UnregisterSignal(current_perspective, list(COMSIG_PARENT_QDELETING, COMSIG_MOB_STAT_SET_DEAD, COMSIG_MOB_NESTED, COMSIG_MOB_LOGOUT, COMSIG_MOB_DEATH, COMSIG_MOVABLE_Z_CHANGED))

	if(!istype(new_perspective))
		return

	RegisterSignal(new_perspective, list(COMSIG_PARENT_QDELETING, COMSIG_MOB_STAT_SET_DEAD, COMSIG_MOB_NESTED, COMSIG_MOB_LOGOUT, COMSIG_MOB_DEATH), PROC_REF(reset_perspective))
	RegisterSignal(new_perspective, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(handle_z_change))
	current_perspective = new_perspective

	camera_mob.do_observe(new_perspective)

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

#define PRIORITY_FIRST "1"
#define PRIORITY_SECOND "2"
#define PRIORITY_THIRD "3"

/datum/controller/subsystem/cmtv/proc/get_active_player()
	var/priority_list = list(PRIORITY_FIRST = list(), PRIORITY_SECOND = list(), PRIORITY_THIRD = list())

	for(var/mob/mob in GLOB.living_player_list)
		if(mob.client?.inactivity > 30 SECONDS)
			continue

		if(world.time > mob.l_move_time + 20 SECONDS)
			continue

		if(!is_ground_level(mob.z) && !SSticker.mode?.is_in_endgame)
			priority_list[PRIORITY_THIRD] += mob
			continue

		priority_list[PRIORITY_SECOND] += mob

	for(var/priority, priority_mobs in priority_list)
		if(length(priority_mobs))
			return pick(priority_mobs)

/client/proc/change_observed_player(mob/new_player in GLOB.player_list)
	set name = "Change Observed Player"
	set category = "Admin.CMTV"

	SScmtv.change_observed_mob(new_player)

/datum/controller/subsystem/cmtv/proc/handle_round_start(client/camera)
	addtimer(CALLBACK(src, PROC_REF(handle_new_camera), camera, TRUE), 5 SECONDS)

/datum/config_entry/string/cmtv_ckey
	protection = CONFIG_ENTRY_LOCKED
