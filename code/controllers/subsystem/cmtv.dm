SUBSYSTEM_DEF(cmtv)
	name = "CMTV"
	wait = 1 SECONDS

	var/client/camera_operator

/datum/controller/subsystem/cmtv/Initialize()
	var/username = CONFIG_GET(string/cmtv_ckey)
	if(!username)
		RegisterSignal(SSdcs, COMSIG_GLOB_CLIENT_LOGGED_IN, PROC_REF(handle_new_client))
		return SS_INIT_NO_NEED

	var/camera = GLOB.directory[username]
	if(!camera)
		RegisterSignal(SSdcs, COMSIG_GLOB_CLIENT_LOGGED_IN, PROC_REF(handle_new_client))
		return SS_INIT_NO_NEED

	handle_new_camera(camera)

/datum/controller/subsystem/cmtv/proc/handle_new_client(SSdcs, client/new_client)
	SIGNAL_HANDLER

	if(new_client.ckey != CONFIG_GET(string/cmtv_ckey))
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
	camera_operator.fit_viewport()

	winset(camera_operator, null, "infowindow.info.splitter=0;tgui_say.is-disabled=true;tooltip.is-disabled=true")

	new_mob.do_observe(pick(GLOB.player_list))

/datum/controller/subsystem/cmtv/proc/handle_round_start(client/camera)
	addtimer(CALLBACK(src, PROC_REF(handle_new_camera), camera, TRUE), 5 SECONDS)

/datum/config_entry/string/cmtv_ckey
	protection = CONFIG_ENTRY_LOCKED
