#define DEFAULT_MAP_SIZE 15

/obj/structure/machinery/computer/cameras
	name = "security cameras console"
	desc = "Used to access the various cameras on the station."
	icon_state = "cameras"
	var/obj/structure/machinery/camera/current
	var/list/network = list(CAMERA_NET_MILITARY)
	circuit = /obj/item/circuitboard/computer/cameras

	/// The turf where the camera was last updated.
	var/turf/last_camera_turf
	var/list/concurrent_users = list()

	// Stuff needed to render the map
	var/camera_map_name

	var/colony_camera_mapload = TRUE
	var/admin_console = FALSE
	var/stay_connected = FALSE
	/// TGUI interface opened by this console.
	var/ui_template_name = "CameraConsole"
	var/datum/weakref/user_weakref

/obj/structure/machinery/computer/cameras/Initialize(mapload)
	. = ..()

	RegisterSignal(src, COMSIG_CAMERA_MAPNAME_ASSIGNED, PROC_REF(camera_mapname_update))

	// camera setup
	AddComponent(/datum/component/camera_manager)

	SEND_SIGNAL(src, COMSIG_CAMERA_CLEAR)

	if(colony_camera_mapload && mapload && is_ground_level(z))
		if(SSmapping.configs[GROUND_MAP].map_name == MAP_WHISKEY_OUTPOST)
			return FALSE
		network = list(CAMERA_NET_COLONY)


/obj/structure/machinery/computer/cameras/Destroy()
	SStgui.close_uis(src)
	current = null
	UnregisterSignal(src, COMSIG_CAMERA_MAPNAME_ASSIGNED)
	last_camera_turf = null
	concurrent_users = null
	return ..()

/obj/structure/machinery/computer/cameras/proc/camera_mapname_update(source, value)
	camera_map_name = value

/obj/structure/machinery/computer/cameras/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/cameras/attack_hand(mob/user)
	if(!admin_console && should_block_game_interaction(src))
		to_chat(user, SPAN_DANGER("[SPAN_BOLD("Unable to establish a connection")]: You're too far away from the ship!"))
		return
	if(inoperable())
		return
	if(!isRemoteControlling(user))
		user.set_interaction(src)
	tgui_interact(user)

/obj/structure/machinery/computer/cameras/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_DISABLED

//Closes UI if you move away from console.
/obj/structure/machinery/computer/cameras/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/computer/cameras/tgui_interact(mob/user, datum/tgui/ui)
	// Update UI
	ui = SStgui.try_update_ui(user, src, ui)

	SEND_SIGNAL(src, COMSIG_CAMERA_REFRESH)

	if(!ui && user.Adjacent(src))
		prepare_tgui(user)
		var/user_ref = WEAKREF(user)
		var/is_living = isliving(user)
		// Ghosts shouldn't count towards concurrent users, which produces
		// an audible terminal_on click.
		if(is_living)
			concurrent_users += user_ref
			user_weakref = user_ref
		// Turn on the console
		if(length(concurrent_users) == 1 && is_living)
			update_use_power(USE_POWER_ACTIVE)
		SEND_SIGNAL(src, COMSIG_CAMERA_REGISTER_UI, user)

		// Open UI
		ui = new(user, src, ui_template_name, name)
		ui.open()

/obj/structure/machinery/computer/cameras/proc/prepare_tgui(mob/user)
	return

/obj/structure/machinery/computer/cameras/ui_data()
	var/list/data = list()
	data["network"] = network
	data["activeCamera"] = null
	if(current)
		data["activeCamera"] = list(
			name = current.c_tag,
			status = current.status,
		)
	return data

/obj/structure/machinery/computer/cameras/ui_static_data()
	var/list/data = list()
	data["mapRef"] = camera_map_name
	var/list/cameras = get_available_cameras()
	data["cameras"] = list()
	for(var/i in cameras)
		var/obj/structure/machinery/camera/C = cameras[i]
		data["cameras"] += list(list(
			name = C.c_tag,
		))

	return data

/obj/structure/machinery/computer/cameras/ui_act(action, params)
	. = ..()
	if(.)
		return

	if(action == "switch_camera")
		var/c_tag = params["name"]
		var/list/cameras = get_available_cameras()
		var/obj/structure/machinery/camera/selected_camera
		selected_camera = cameras[c_tag]
		// Unicode breaks c_tags
		// Currently the only issues with character names comes from the improper or proper tags and so we strip and recheck if not found.
		if(!selected_camera)
			for(var/I in cameras)
				if(strip_improper(I) == c_tag)
					selected_camera = cameras[I]
					break
		current = selected_camera
		playsound(src, get_sfx("terminal_type"), 25, FALSE)

		if(!selected_camera)
			return TRUE

		SEND_SIGNAL(src, COMSIG_CAMERA_SET_TARGET, selected_camera, selected_camera.view_range, selected_camera.view_range)

		return TRUE


/obj/structure/machinery/computer/cameras/ui_close(mob/user)
	var/user_ref = WEAKREF(user)
	var/is_living = isliving(user)
	// Living creature or not, we remove you anyway.
	concurrent_users -= user_ref
	// Unregister map objects
	SEND_SIGNAL(src, COMSIG_CAMERA_UNREGISTER_UI, user)
	// Turn off the console
	if(length(concurrent_users) == 0 && is_living && !stay_connected)
		current = null
		SEND_SIGNAL(src, COMSIG_CAMERA_CLEAR)
		last_camera_turf = null
		if(use_power)
			update_use_power(USE_POWER_IDLE)
	user.unset_interaction()

// Returns the list of cameras accessible from this computer
/obj/structure/machinery/computer/cameras/proc/get_available_cameras()
	var/list/D = list()
	for(var/obj/structure/machinery/camera/C in GLOB.all_cameras)
		if(!C.network)
			stack_trace("Camera in a cameranet has no camera network")
			continue
		if(!(islist(C.network)))
			stack_trace("Camera in a cameranet has a non-list camera network")
			continue
		var/list/tempnetwork = C.network & network
		if(length(tempnetwork))
			D["[C.c_tag]"] = C
	return D

/obj/structure/machinery/computer/cameras/telescreen
	name = "Telescreen"
	desc = "Used for watching an empty arena."
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "telescreen"
	network = list("thunder")
	density = FALSE
	circuit = null

/obj/structure/machinery/computer/cameras/telescreen/update_icon()
	icon_state = initial(icon_state)
	if(stat & BROKEN)
		icon_state += "b"
	return

/obj/structure/machinery/computer/cameras/telescreen/entertainment
	name = "entertainment monitor"
	desc = "Damn, why do they never have anything interesting on these things?"
	icon = 'icons/obj/structures/machinery/status_display.dmi'
	icon_state = "entertainment"
	circuit = null

/obj/structure/machinery/computer/cameras/wooden_tv
	name = "Security Cameras"
	desc = "An old TV hooked into the station's camera network."
	icon_state = "security_det"
	circuit = null

/obj/structure/machinery/computer/cameras/wooden_tv/almayer
	name = "Ship Security Cameras"
	network = list(CAMERA_NET_ALMAYER)

/obj/structure/machinery/computer/cameras/wooden_tv/broadcast
	name = "Television Set"
	desc = "An old TV hooked up to a video cassette recorder, you can even use it to time shift WOW."
	network = list(CAMERA_NET_CORRESPONDENT)
	stay_connected = TRUE
	wrenchable = TRUE
	circuit = /obj/item/circuitboard/computer/cameras/tv
	var/obj/item/device/broadcasting/broadcastingcamera = null

/obj/structure/machinery/computer/cameras/wooden_tv/broadcast/Destroy()
	broadcastingcamera = null
	return ..()

/obj/structure/machinery/computer/cameras/wooden_tv/broadcast/wheeled
	name = "Mobile Television Set"
	desc = "An old TV hooked up to a video cassette recorder, bolted onto what appears to be an old roller bed. Only the finest for our Military Police force.\n\nIt could be used to keep perma prisoners entertained."
	icon_state = "tv_mobile"
	layer = WINDOW_LAYER

	anchored = FALSE
	drag_delay = 0
	deconstructible = FALSE
	density = TRUE

/obj/structure/machinery/computer/cameras/wooden_tv/broadcast/ui_state(mob/user)
	return GLOB.in_view

/obj/structure/machinery/computer/cameras/wooden_tv/broadcast/ui_act(action, params)
	. = ..()
	if(action != "switch_camera")
		return
	if(broadcastingcamera)
		clear_camera()
	if(!istype(current, /obj/structure/machinery/camera/correspondent))
		return
	var/obj/structure/machinery/camera/correspondent/corr_cam = current
	if(!corr_cam.linked_broadcasting)
		return
	broadcastingcamera = corr_cam.linked_broadcasting
	RegisterSignal(broadcastingcamera, COMSIG_BROADCAST_GO_LIVE, PROC_REF(go_back_live))
	RegisterSignal(broadcastingcamera, COMSIG_COMPONENT_ADDED, PROC_REF(handle_rename))
	RegisterSignal(broadcastingcamera, COMSIG_PARENT_QDELETING, PROC_REF(clear_camera))
	RegisterSignal(broadcastingcamera, COMSIG_BROADCAST_HEAR_TALK, PROC_REF(transfer_talk))
	RegisterSignal(broadcastingcamera, COMSIG_BROADCAST_SEE_EMOTE, PROC_REF(transfer_emote))

/obj/structure/machinery/computer/cameras/wooden_tv/broadcast/ui_close(mob/user)
	. = ..()
	if(!broadcastingcamera)
		return
	if(!current)
		clear_camera()

/obj/structure/machinery/computer/cameras/wooden_tv/broadcast/inoperable(additional_flags = 0)
	return ..(MAINT|additional_flags)

/obj/structure/machinery/computer/cameras/wooden_tv/broadcast/attackby(obj/item/wrench, mob/user)
	if(HAS_TRAIT(wrench, TRAIT_TOOL_WRENCH))
		if(user.action_busy)
			return TRUE
		toggle_anchored(wrench, user)
		return TRUE
	. = ..()

/obj/structure/machinery/computer/cameras/wooden_tv/broadcast/toggle_anchored(obj/item/wrench, mob/user)
	. = ..()
	if(!.)
		return
	if(!anchored)
		stat |= MAINT
		clear_camera()
		current = null
		SEND_SIGNAL(src, COMSIG_CAMERA_CLEAR)
	else
		stat &= ~MAINT
	update_icon()

/obj/structure/machinery/computer/cameras/wooden_tv/broadcast/update_icon()
	. = ..()
	if(stat & BROKEN)
		return
	if(stat & MAINT)
		icon_state = initial(icon_state)
		icon_state += "0"

/obj/structure/machinery/computer/cameras/wooden_tv/broadcast/proc/clear_camera()
	SIGNAL_HANDLER
	UnregisterSignal(broadcastingcamera, list(COMSIG_BROADCAST_GO_LIVE, COMSIG_PARENT_QDELETING, COMSIG_COMPONENT_ADDED, COMSIG_BROADCAST_HEAR_TALK, COMSIG_BROADCAST_SEE_EMOTE))
	broadcastingcamera = null

/obj/structure/machinery/computer/cameras/wooden_tv/broadcast/proc/go_back_live(obj/item/device/broadcasting/broadcastingcamera)
	SIGNAL_HANDLER
	if(current.c_tag == broadcastingcamera.get_broadcast_name())
		current = broadcastingcamera.linked_cam
		SEND_SIGNAL(src, COMSIG_CAMERA_SET_TARGET, broadcastingcamera.linked_cam, broadcastingcamera.linked_cam.view_range, broadcastingcamera.linked_cam.view_range)

/obj/structure/machinery/computer/cameras/wooden_tv/broadcast/proc/transfer_talk(obj/item/camera, mob/living/sourcemob, message, verb = "says", datum/language/language, italics = FALSE, show_message_above_tv = FALSE)
	SIGNAL_HANDLER
	if(inoperable())
		return
	if(show_message_above_tv)
		langchat_speech(message, get_mobs_in_view(7, src), language, sourcemob.langchat_color, FALSE, LANGCHAT_FAST_POP, list(sourcemob.langchat_styles))
	for(var/datum/weakref/user_ref in concurrent_users)
		var/mob/user = user_ref.resolve()
		if(user?.client?.prefs && !user.client.prefs.lang_chat_disabled && !user.ear_deaf && user.say_understands(sourcemob, language))
			sourcemob.langchat_display_image(user)

/obj/structure/machinery/computer/cameras/wooden_tv/broadcast/proc/transfer_emote(obj/item/camera, mob/living/sourcemob, emote, audible = FALSE, show_message_above_tv = FALSE)
	SIGNAL_HANDLER
	if(inoperable())
		return
	if(show_message_above_tv)
		langchat_speech(emote, get_mobs_in_view(7, src), skip_language_check = TRUE, animation_style = LANGCHAT_FAST_POP, additional_styles = list("emote"))
	for(var/datum/weakref/user_ref in concurrent_users)
		var/mob/user = user_ref.resolve()
		if(user?.client?.prefs && (user.client.prefs.toggles_langchat & LANGCHAT_SEE_EMOTES) && (!audible || !user.ear_deaf))
			sourcemob.langchat_display_image(user)

/obj/structure/machinery/computer/cameras/wooden_tv/broadcast/examine(mob/user)
	. = ..()
	attack_hand(user) //watch tv on examine

/obj/structure/machinery/computer/cameras/wooden_tv/broadcast/proc/handle_rename(obj/item/camera, datum/component/label)
	SIGNAL_HANDLER
	if(!istype(label, /datum/component/label))
		return
	current.c_tag = broadcastingcamera.get_broadcast_name()

/obj/structure/machinery/computer/cameras/wooden_tv/ot
	name = "Mortar Monitoring Set"
	desc = "A Console linked to Mortar launched cameras."
	network = list(CAMERA_NET_MORTAR)

/obj/structure/machinery/computer/cameras/mining
	name = "Outpost Cameras"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	desc = "Used to access the various cameras on the outpost."
	icon_state = "cameras"
	network = list("MINE")
	circuit = /obj/item/circuitboard/computer/cameras/mining

/obj/structure/machinery/computer/cameras/engineering
	name = "Engineering Cameras"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	desc = "Used to monitor fires and breaches."
	icon_state = "cameras"
	network = list("Engineering","Power Alarms","Atmosphere Alarms","Fire Alarms")
	circuit = /obj/item/circuitboard/computer/cameras/engineering

/obj/structure/machinery/computer/cameras/nuclear
	name = "Mission Monitor"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	desc = "Used to access the built-in cameras in helmets."
	icon_state = "syndicam"
	network = list("NUKE")
	circuit = null


/obj/structure/machinery/computer/cameras/almayer
	density = FALSE
	icon_state = "security_cam"
	network = list(CAMERA_NET_ALMAYER)

/obj/structure/machinery/computer/cameras/almayer/containment
	name = "Containment Cameras"
	network = list(CAMERA_NET_CONTAINMENT)

/obj/structure/machinery/computer/cameras/almayer/ares
	name = "ARES Core Cameras"
	network = list(CAMERA_NET_ARES)

/obj/structure/machinery/computer/cameras/almayer/vehicle
	name = "Ship Security Cameras"
	network = list(CAMERA_NET_ALMAYER, CAMERA_NET_VEHICLE)

/obj/structure/machinery/computer/cameras/hangar
	name = "Dropship Security Cameras Console"
	icon_state = "security_cam"
	density = FALSE
	network = list(CAMERA_NET_ALAMO, CAMERA_NET_NORMANDY)

/obj/structure/machinery/computer/cameras/containment
	name = "Containment Cameras"
	network = list(CAMERA_NET_CONTAINMENT, CAMERA_NET_RESEARCH)

/obj/structure/machinery/computer/cameras/containment/hidden
	network = list(CAMERA_NET_CONTAINMENT, CAMERA_NET_RESEARCH, CAMERA_NET_CONTAINMENT_HIDDEN)

/obj/structure/machinery/computer/cameras/almayer_network
	network = list(CAMERA_NET_ALMAYER)

/obj/structure/machinery/computer/cameras/almayer_network/vehicle
	network = list(CAMERA_NET_ALMAYER, CAMERA_NET_VEHICLE)

/obj/structure/machinery/computer/cameras/almayer_brig
	name = "Brig Cameras Console"
	network = list(CAMERA_NET_BRIG)

/obj/structure/machinery/computer/cameras/mortar
	name = "Mortar Camera Interface"
	alpha = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	density = FALSE
	use_power = USE_POWER_NONE
	idle_power_usage = 0
	active_power_usage = 0
	needs_power = FALSE
	network = list(CAMERA_NET_MORTAR)
	explo_proof = TRUE
	colony_camera_mapload = FALSE

/obj/structure/machinery/computer/cameras/mortar/set_broken()
	return

/obj/structure/machinery/computer/cameras/dropship
	name = "abstract dropship camera computer"
	desc = "A computer to monitor cameras and manage auxiliary equipment linked to the dropship."
	density = TRUE
	icon = 'icons/obj/structures/machinery/shuttle-parts.dmi'
	icon_state = "consoleleft"
	circuit = null
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	ui_template_name = "DropshipCameraConsole"

	var/shuttle_tag
	var/camera_target_id
	var/camera_width = 11
	var/camera_height = 11
	var/obj/structure/dropship_equipment/camera_area_equipment = null
	var/upgraded = MATRIX_DEFAULT // we transport upgrade var from matrixdm
	var/matrix_color = NV_COLOR_GREEN //color of matrix, only used when we upgrade to nv
	/// Tacmap embedded in the console's UI.
	var/datum/tacmap_holder/tacmap_holder
	/// Client ceiling layers used by users viewing this console.
	var/list/atom/movable/screen/minimap_ceiling_layer/ceiling_layers

/obj/structure/machinery/computer/cameras/dropship/Initialize(mapload)
	. = ..()
	ceiling_layers = list()
	AddComponent(/datum/component/tacmap, has_drawing_tools = FALSE, minimap_flag = MINIMAP_FLAG_USCM, has_update = TRUE)

/obj/structure/machinery/computer/cameras/dropship/Destroy()
	QDEL_LIST_ASSOC_VAL(ceiling_layers)
	QDEL_NULL(tacmap_holder)
	return ..()

/obj/structure/machinery/computer/cameras/dropship/attack_hand(mob/user)
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Auxiliary equipment access denied."))
		return TRUE
	return ..()

/obj/structure/machinery/computer/cameras/dropship/prepare_tgui(mob/user)
	var/datum/component/tacmap/tacmap_component = GetComponent(/datum/component/tacmap)
	if(!tacmap_component)
		return

	if(!tacmap_holder)
		var/list/ground_zlevels = SSmapping.levels_by_trait(ZTRAIT_GROUND)
		if(length(ground_zlevels))
			tacmap_holder = new(null, ground_zlevels[1], MINIMAP_FLAG_USCM, drawing = TRUE, popup = FALSE, uncached = TRUE)
			tacmap_component.is_embedded = TRUE

	if(!tacmap_holder?.map)
		QDEL_NULL(tacmap_holder)
		return

	var/matrix/transform = matrix()
	transform.Translate(-32, 14)
	tacmap_holder.map.transform = transform
	tacmap_holder.map.del_on_map_removal = FALSE
	user.client.register_map_obj(tacmap_holder.map)
	var/atom/movable/screen/minimap_ceiling_layer/ceiling_layer = new(null, tacmap_holder.map_ref, tacmap_holder.map.target, transform)
	ceiling_layers[user] = ceiling_layer
	user.client.register_map_obj(ceiling_layer)

/obj/structure/machinery/computer/cameras/dropship/proc/unregister_tacmap(mob/user)
	if(!tacmap_holder)
		return

	var/atom/movable/screen/minimap_ceiling_layer/ceiling_layer = ceiling_layers[user]
	user.client?.clear_map(tacmap_holder.map_ref)
	QDEL_NULL(ceiling_layer)
	ceiling_layers -= user

/obj/structure/machinery/computer/cameras/dropship/on_unset_interaction(mob/user)
	. = ..()
	var/datum/component/tacmap/tacmap_component = GetComponent(/datum/component/tacmap)
	tacmap_component?.on_unset_interaction(user)

/obj/structure/machinery/computer/cameras/dropship/ui_close(mob/user)
	unregister_tacmap(user)
	return ..()

/obj/structure/machinery/computer/cameras/dropship/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/computer/cameras/dropship/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/computer/cameras/dropship/ui_static_data(mob/user)
	. = list()
	if(tacmap_holder)
		.["tactical_map_ref"] = tacmap_holder.map_ref
	.["camera_map_ref"] = camera_map_name

/obj/structure/machinery/computer/cameras/dropship/ui_data(mob/user)
	. = list()
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
	if(!istype(dropship))
		return

	.["ceiling_overlay_enabled"] = ceiling_layers[user]?.enabled
	.["equipment_data"] = get_sanitised_equipment(user, dropship)

	.["shuttle_state"] = dropship.mode
	.["flight_time"] = dropship.timeLeft(10)
	.["max_flight_duration"] = dropship.callTime * 0.1
	.["max_refuel_duration"] = dropship.rechargeTime * 0.1

	.["medevac_targets"] = list()
	for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
		if(istype(equipment, /obj/structure/dropship_equipment/medevac_system))
			var/obj/structure/dropship_equipment/medevac_system/medevac = equipment
			.["medevac_targets"] += medevac.ui_data(user)

	.["fulton_targets"] = list()
	for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
		if(istype(equipment, /obj/structure/dropship_equipment/fulton_system))
			var/obj/structure/dropship_equipment/fulton_system/fult = equipment
			.["fulton_targets"] += fult.ui_data(user)

	.["camera_target_id"] = camera_target_id
	.["matrix_upgrade"] = upgraded
	.["nvg_available"] = (upgraded == MATRIX_NVG)
	var/datum/component/camera_manager/camera_component = GetComponent(/datum/component/camera_manager)
	.["nvg_enabled"] = camera_component ? camera_component.nvg_enabled : FALSE

	.["available_cameras"] = list()
	var/list/cameras = get_available_cameras()
	for(var/c_tag in cameras)
		var/obj/structure/machinery/camera/camera = cameras[c_tag]
		if(camera)
			.["available_cameras"] += list(list("name" = c_tag))

	.["targets_data"] = get_targets()

	.["worldtime"] = world.time

/obj/structure/machinery/computer/cameras/dropship/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
	if(!dropship || dropship.is_hijacked)
		return
	var/mob/user = ui.user

	switch(action)
		if("toggle-ceiling-overlay")
			var/atom/movable/screen/minimap_ceiling_layer/ceiling_layer = ceiling_layers[user]
			if(!ceiling_layer)
				return FALSE
			ceiling_layer.set_enabled(!ceiling_layer.enabled)
			return TRUE

		if("set-camera")
			var/target_camera = params["equipment_id"]
			var/obj/structure/dropship_equipment/equipment = get_equipment_by_mount(target_camera)
			if(istype(equipment, /obj/structure/dropship_equipment/sentry_holder))
				var/obj/structure/dropship_equipment/sentry_holder/sentry = equipment
				var/obj/structure/machinery/defenses/sentry/premade/dropship/defense = sentry.deployed_turret
				if(!defense || defense.loc == sentry)
					to_chat(user, SPAN_WARNING("Sentry must be deployed to access camera."))
					return TRUE
				if(!defense.has_camera || !defense.linked_cam)
					to_chat(user, SPAN_WARNING("Sentry camera is not available."))
					return TRUE
				camera_area_equipment = sentry
				SEND_SIGNAL(src, COMSIG_CAMERA_SET_TARGET, defense.linked_cam, defense.linked_cam.view_range, defense.linked_cam.view_range)
				to_chat(user, SPAN_NOTICE("Switching to sentry camera view."))
				return TRUE

			set_camera_target(target_camera)
			return TRUE

		if("auto-deploy")
			var/obj/structure/dropship_equipment/equipment = get_equipment_by_mount(params["equipment_id"])
			if(istype(equipment, /obj/structure/dropship_equipment/sentry_holder))
				var/obj/structure/dropship_equipment/sentry_holder/sentry = equipment
				sentry.auto_deploy = !sentry.auto_deploy
			else if(istype(equipment, /obj/structure/dropship_equipment/mg_holder))
				var/obj/structure/dropship_equipment/mg_holder/mg = equipment
				mg.auto_deploy = !mg.auto_deploy
			return TRUE

		if("clear-camera")
			set_camera_target(null)
			return TRUE

		if("nvg-enable")
			if(upgraded != MATRIX_NVG)
				to_chat(user, SPAN_WARNING("The matrix is not upgraded with night vision."))
				return FALSE
			if(user.client?.prefs?.night_vision_preference)
				matrix_color = user.client.prefs.nv_color_list[user.client.prefs.night_vision_preference]
			SEND_SIGNAL(src, COMSIG_CAMERA_SET_NVG, 5, matrix_color)
			return TRUE

		if("nvg-disable")
			SEND_SIGNAL(src, COMSIG_CAMERA_CLEAR_NVG)
			return TRUE

		if("paradrop-lock")
			if(dropship.mode != SHUTTLE_CALL)
				return FALSE
			if(dropship.paradrop_signal)
				clear_locked_turf_and_lock_aft()
				return TRUE
			var/datum/cas_signal/sig = get_cas_signal(camera_target_id)
			if(!sig)
				to_chat(user, SPAN_WARNING("No signal chosen."))
				return FALSE
			var/turf/location = get_turf(sig.signal_loc)
			var/area/location_area = get_area(location)
			if(CEILING_IS_PROTECTED(location_area.ceiling, CEILING_PROTECTION_TIER_1))
				to_chat(user, SPAN_WARNING("Target is obscured."))
				return FALSE
			var/obj/structure/dropship_equipment/equipment = get_equipment_by_mount(params["equipment_id"])
			if(!istype(equipment, /obj/structure/dropship_equipment/paradrop_system))
				return FALSE
			var/obj/structure/dropship_equipment/paradrop_system/paradrop_system = equipment
			if(paradrop_system.system_cooldown > world.time)
				to_chat(user, SPAN_WARNING("You toggled the system too recently."))
				return FALSE
			paradrop_system.system_cooldown = world.time + 5 SECONDS
			paradrop_system.visible_message(SPAN_NOTICE("[paradrop_system] hums as it locks to a signal."))
			dropship.paradrop_signal = sig
			paradrop_system.on_signal_lock()
			addtimer(CALLBACK(src, PROC_REF(open_aft_for_paradrop)), 2 SECONDS)
			RegisterSignal(dropship.paradrop_signal, COMSIG_PARENT_QDELETING, PROC_REF(clear_locked_turf_and_lock_aft))
			RegisterSignal(dropship, COMSIG_SHUTTLE_SETMODE, PROC_REF(clear_locked_turf_and_lock_aft))
			return TRUE

		if("firemission-dual-offset-camera")
			var/target_id = params["target_id"]
			var/datum/cas_signal/cas_sig = get_cas_signal(target_id, valid_only = TRUE)
			if(!cas_sig)
				return FALSE
			camera_target_id = target_id
			var/turf/target_turf = get_turf(cas_sig.signal_loc)
			if(!target_turf)
				return FALSE
			var/shape_size = upgraded == MATRIX_WIDE ? max(camera_width, camera_height) * 1.5 : max(camera_width, camera_height)
			var/datum/shape/rectangle/square/target_area = new(target_turf.x, target_turf.y, shape_size)
			SEND_SIGNAL(src, COMSIG_CAMERA_SET_AREA, target_area, target_turf.z)
			for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
				equipment.update_equipment()
			return TRUE

		if("deploy-equipment")
			var/obj/structure/dropship_equipment/equipment = get_equipment_by_mount(params["equipment_id"])
			if(equipment?.is_interactable)
				if(camera_area_equipment == equipment)
					set_camera_target(null)
				equipment.equipment_interact(user)
			return TRUE

		if("medevac-target")
			var/obj/structure/dropship_equipment/equipment = get_equipment_by_mount(params["equipment_id"])
			if(istype(equipment, /obj/structure/dropship_equipment/medevac_system))
				var/obj/structure/dropship_equipment/medevac_system/medevac = equipment
				medevac.automate_interact(user, params["ref"])
				if(medevac.linked_stretcher)
					SEND_SIGNAL(src, COMSIG_CAMERA_SET_TARGET, medevac.linked_stretcher, 5, 5)
			return TRUE

		if("fulton-target")
			var/obj/structure/dropship_equipment/equipment = get_equipment_by_mount(params["equipment_id"])
			if(istype(equipment, /obj/structure/dropship_equipment/fulton_system))
				var/obj/structure/dropship_equipment/fulton_system/fulton = equipment
				fulton.automate_interact(user, params["ref"])
			return TRUE

/obj/structure/machinery/computer/cameras/dropship/proc/set_camera_target(target_ref)
	camera_area_equipment = null

	var/datum/cas_signal/target = get_cas_signal(target_ref, valid_only = TRUE)
	camera_target_id = target_ref

	if(!target)
		SEND_SIGNAL(src, COMSIG_CAMERA_CLEAR)
		return

	var/cam_width = camera_width
	var/cam_height = camera_height
	if(upgraded == MATRIX_WIDE)
		cam_width = cam_width * 1.5
		cam_height = cam_height * 1.5

	SEND_SIGNAL(src, COMSIG_CAMERA_SET_TARGET, target.linked_cam, cam_width, cam_height)

/obj/structure/machinery/computer/cameras/dropship/proc/get_cas_signal(sig_id, valid_only = FALSE)
	var/datum/cas_iff_group/group = GLOB.cas_groups[FACTION_MARINE]
	if(!group)
		return
	for(var/datum/cas_signal/sig as anything in group.cas_signals)
		if(sig.target_id != sig_id)
			continue
		if(valid_only && !sig.valid_signal())
			return
		return sig

/obj/structure/machinery/computer/cameras/dropship/proc/get_equipment_by_mount(equipment_tag)
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
	if(!dropship)
		return
	var/mount_point = isnum(equipment_tag) ? equipment_tag : text2num(equipment_tag)
	for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
		if(equipment.ship_base?.attach_id == mount_point)
			return equipment

/obj/structure/machinery/computer/cameras/dropship/proc/get_targets()
	. = list()
	var/datum/cas_iff_group/cas_group = GLOB.cas_groups[FACTION_MARINE]
	if(!cas_group)
		return
	for(var/datum/cas_signal/cas_signal as anything in cas_group.cas_signals)
		if(!cas_signal.valid_signal())
			continue
		var/turf/signal_turf = get_turf(cas_signal.signal_loc)
		if(!signal_turf || !is_ground_level(signal_turf.z))
			continue
		var/area/laser_area = get_area(signal_turf)
		. += list(list(
			"target_name" = "[cas_signal.name] ([laser_area.name])",
			"target_tag" = cas_signal.target_id,
			"ceiling_protection_tier" = laser_area.ceiling,
		))

/obj/structure/machinery/computer/cameras/dropship/proc/get_sanitised_equipment(mob/user, obj/docking_port/mobile/marine_dropship/dropship)
	. = list()
	for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
		. += list(equipment.get_console_data(user))

/obj/structure/machinery/computer/cameras/dropship/one
	name = "\improper 'Alamo' auxiliary support controls"
	network = list(CAMERA_NET_ALAMO, CAMERA_NET_LASER_TARGETS)
	shuttle_tag = DROPSHIP_ALAMO
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP, ACCESS_WY_FLIGHT)

/obj/structure/machinery/computer/cameras/dropship/omaha
	name = "\improper 'Omaha' camera controls"
	icon = 'icons/obj/structures/machinery/omaha/controls.dmi'
	icon_state = "weapons_console"
	density = FALSE
	layer = OBJ_LAYER + 0.01
	network = list(CAMERA_NET_OMAHA, CAMERA_NET_LASER_TARGETS)

/obj/structure/machinery/computer/cameras/dropship/two
	name = "\improper 'Normandy' auxiliary support controls"
	network = list(CAMERA_NET_NORMANDY, CAMERA_NET_LASER_TARGETS)
	shuttle_tag = DROPSHIP_NORMANDY
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP, ACCESS_WY_FLIGHT)

/obj/structure/machinery/computer/cameras/dropship/midway
	name = "\improper 'Midway' camera controls"
	icon = 'icons/obj/structures/machinery/midway/controls.dmi'
	icon_state = "weapons_console"
	density = FALSE
	layer = OBJ_LAYER + 0.01
	network = list(CAMERA_NET_MIDWAY, CAMERA_NET_LASER_TARGETS)

/obj/structure/machinery/computer/cameras/dropship/midway/gunnery
	name = "\improper 'Midway' gunnery controls"
	icon = 'icons/obj/structures/machinery/midway/modules.dmi'
	icon_state = "gunnery"
	density = TRUE
	layer = OBJ_LAYER - 0.01
	network = list(CAMERA_NET_LASER_TARGETS)
	ui_template_name = "DropshipGunneryConsole"
	var/focused = FALSE
	var/obj/docking_port/mobile/marine_dropship/linked_dropship
	var/obj/structure/bed/chair/vehicle/midway_gunner/linked_chair
	var/obj/structure/dropship_equipment/weapon/m90_minigun/linked_m90

/obj/structure/machinery/computer/cameras/dropship/midway/gunnery/Initialize()
	.=..()
	for(var/obj/structure/bed/chair/vehicle/midway_gunner/our_chair in range(2, src.loc))
		linked_chair = our_chair
		linked_chair.linked_gunnery_console = src
	return

/obj/structure/machinery/computer/cameras/dropship/midway/gunnery/attack_hand(mob/user)
	if(user_weakref)
		var/mob/living/carbon/human/current_user = user_weakref.resolve()
		if(current_user)
			to_chat(user, SPAN_WARNING("[current_user.name] is already using the [src.name]!"))
			return
	if(linked_m90)
		return ..()
	else
		for(var/obj/structure/dropship_equipment/weapon/m90_minigun/gun in linked_dropship.equipments)
			linked_m90 = gun
			return ..()

/obj/structure/machinery/computer/cameras/dropship/midway/gunnery/ui_data()
	var/list/data = list()
	data["activeCamera"] = null
	if(linked_m90)
		if(linked_m90.ammo_equipped)
			data["currentAmmo"] = linked_m90.ammo_equipped.ammo_count
			data["totalAmmo"] = linked_m90.ammo_equipped.max_ammo_count
		else
			data["currentAmmo"] = 0
			data["totalAmmo"] = 0
	if(current)
		data["activeCamera"] = list(
			name = current.c_tag,
			status = current.status,
		)
	data["mapRef"] = camera_map_name
	var/list/cameras = get_available_cameras()
	data["cameras"] = list()
	for(var/i in cameras)
		var/obj/structure/machinery/camera/C = cameras[i]
		data["cameras"] += list(list(
			name = C.c_tag,
		))
	return data

/obj/structure/machinery/computer/cameras/dropship/midway/gunnery/ui_static_data() // aha
	return

/obj/structure/machinery/computer/cameras/dropship/midway/gunnery/get_available_cameras()
	var/list/cam_list = list()
	for(var/obj/structure/machinery/camera/camerino as anything in GLOB.cas_cameras)
		if(!camerino.network)
			stack_trace("Camera in a cameranet has no camera network")
			continue
		if(!(islist(camerino.network)))
			stack_trace("Camera in a cameranet has a non-list camera network")
			continue
		var/list/tempnetwork = camerino.network & network
		if(length(tempnetwork))
			cam_list["[camerino.c_tag]"] = camerino
	return cam_list

/obj/structure/machinery/computer/cameras/dropship/midway/gunnery/ui_close(mob/user)
	if(focused)
		if(user_weakref)
			var/client/clientino = user.client
			if(clientino)
				focus_mob()
				if(!user.client?.prefs.custom_cursors)
					current = null
					user_weakref = null
					return ..()
				user.client.mouse_pointer_icon = initial(user.client.mouse_pointer_icon)

	current = null
	user_weakref = null
	return ..()


/obj/structure/machinery/computer/cameras/dropship/midway/gunnery/ui_act(action, params)
	. = ..()
	if(.)
		return
	playsound(src, get_sfx("terminal_button"), 30, FALSE)
	if(action == "change_camera") // rename action
		var/c_tag = params["name"]
		var/list/cameras = get_available_cameras()
		var/obj/structure/machinery/camera/selected_camera

		selected_camera = cameras[c_tag]
		// Unicode breaks c_tags
		// Currently the only issues with character names comes from the improper or proper tags and so we strip and recheck if not found.
		if(!selected_camera)
			for(var/I in cameras)
				if(strip_improper(I) == c_tag)
					selected_camera = cameras[I]
					break

		if(selected_camera)
			if(selected_camera == current)
				focus_mob()
				selected_camera = null
				current = null
				ui_data()
				return

		current = selected_camera
		playsound(src, get_sfx("terminal_button"), 25, FALSE)

		if(!selected_camera)
			return TRUE
		SEND_SIGNAL(src, COMSIG_CAMERA_SET_TARGET, selected_camera, selected_camera.view_range, selected_camera.view_range)
		if(user_weakref)
			focus_camera(selected_camera)
			prepare()
		return TRUE

/obj/structure/machinery/computer/cameras/dropship/midway/gunnery/proc/focus_mob()
	var/mob/living/carbon/human/user = user_weakref.resolve()
	if(user)
		user.remove_client_color_matrix("gunnery_visor", 0.75 SECONDS)
		user.clear_fullscreen("gunnery_visor", 0.4 SECONDS)
		user.clear_fullscreen("gunnery_visor_blur", 0.4 SECONDS)
		user.clear_fullscreen("gunnery_clouds", 0.1 SECONDS)
		playsound(user, 'sound/handling/toggle_nv2.ogg', 25)

		UnregisterSignal(user, COMSIG_MOB_POST_CLICK)

		user.reset_view(user)
		user.update_sight()
		focused = FALSE

/obj/structure/machinery/computer/cameras/dropship/midway/gunnery/proc/focus_camera(selected_camera)
	var/mob/living/carbon/human/user = user_weakref.resolve()
	if(user.client?.prefs?.night_vision_preference)
		matrix_color = user.client.prefs.nv_color_list[user.client.prefs.night_vision_preference]
	user.add_client_color_matrix("gunnery_visor", 99, color_matrix_multiply(color_matrix_saturation(0), color_matrix_from_string(matrix_color)), 0.75 SECONDS)
	user.overlay_fullscreen("gunnery_visor", /atom/movable/screen/fullscreen/flash/noise/nvg)
	user.overlay_fullscreen("gunnery_visor_blur", /atom/movable/screen/fullscreen/brute/nvg, 3)
	user.overlay_fullscreen("gunnery_clouds", /atom/movable/screen/fullscreen/clouds)
	playsound(user, 'sound/handling/toggle_nv1.ogg', 25)

	user.reset_view(selected_camera)
	user.update_sight()
	focused = TRUE

/obj/structure/machinery/computer/cameras/dropship/midway/gunnery/proc/prepare()
	var/mob/living/carbon/human/user = user_weakref.resolve()

	if(!skillcheck(user, SKILL_PILOT, linked_m90.skill_required)) //only pilots can fire dropship weapons.
		to_chat(user, SPAN_WARNING("You don't have the training to fire this weapon!"))
		return FALSE
	if(!user.allow_gun_usage)
		to_chat(user, SPAN_WARNING("Your programming prevents you from operating dropship weaponry!"))
		return FALSE
	if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/ceasefire))
		to_chat(user, SPAN_WARNING("You will not break the ceasefire by doing that!"))
		return FALSE

	if(user.buckled == linked_chair)
		if(user.client?.prefs?.custom_cursors)
			user.client.mouse_pointer_icon = 'icons/effects/mouse_pointer/supplypod_target.dmi'
		RegisterSignal(user, COMSIG_MOB_POST_CLICK, PROC_REF(fire_m90))
	else
		to_chat(user, SPAN_NOTICE("I need to be sitting in the gunnery chair in order to use the [src.name] properly."))

/obj/structure/machinery/computer/cameras/dropship/midway/gunnery/proc/fire_m90(mob/living/carbon/human/user, atom/target, mods)
	SIGNAL_HANDLER
	if(linked_m90.last_fired > world.time - linked_m90.firing_delay)
		to_chat(user, SPAN_WARNING("WARNING: [linked_m90.name] just fired, wait for it to cool down."))
		return FALSE
	if(!linked_m90.ammo_equipped || linked_m90.ammo_equipped.ammo_count <= 0)
		to_chat(user, SPAN_WARNING("ERROR: The [linked_m90.name] has no ammo."))
		return FALSE
	if(linked_dropship.mode != SHUTTLE_CALL)
		to_chat(user, SPAN_WARNING("ERROR: Dropship can only fire while in flight."))
		return FALSE

	var/turf/target_turf = get_turf(target)
	var/area/targ_area = get_area(target)
	var/is_outside = FALSE
	if(target_turf)
		if(is_ground_level(target_turf.z))
			switch(targ_area.ceiling)
				if(CEILING_NONE)
					is_outside = TRUE
				if(CEILING_GLASS)
					is_outside = TRUE
		if(!is_outside) //cavebreaker doesn't care |> && !linked_m90.cavebreaker
			to_chat(user, SPAN_WARNING("INVALID TARGET: target must be visible from high altitude."))
			return FALSE
		if(protected_by_pylon(TURF_PROTECTION_CAS, target_turf))
			to_chat(user, SPAN_WARNING("INVALID TARGET: biological-pattern interference with signal."))
			return FALSE

		linked_m90.open_fire(target_turf, user)
		ui_data()


/obj/structure/machinery/computer/cameras/dropship/three
	name = "\improper 'Saipan' auxiliary support controls"
	network = list(CAMERA_NET_RESEARCH, CAMERA_NET_LASER_TARGETS)
	shuttle_tag = DROPSHIP_SAIPAN
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP, ACCESS_WY_FLIGHT)

/obj/structure/machinery/computer/cameras/internal
	name = "Internal Camera Link"
	desc = "If you can see this, someone messed up."
	alpha = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	density = FALSE
	use_power = USE_POWER_NONE
	idle_power_usage = 0
	active_power_usage = 0
	needs_power = FALSE
	network = list(CAMERA_NET_ALMAYER)
	explo_proof = TRUE

/obj/structure/machinery/computer/cameras/internal/yautja
	name = "Hellhound Observation Interface"
	network = list(CAMERA_NET_YAUTJA)

/obj/structure/machinery/computer/cameras/internal/yautja/Initialize()
	. = ..()
	SEND_SIGNAL(src, COMSIG_CAMERA_SET_NVG, 5, NV_COLOR_RED)

#undef DEFAULT_MAP_SIZE

/obj/structure/machinery/computer/cameras/dropship/proc/open_aft_for_paradrop()
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
	if(!dropship || !dropship.paradrop_signal || dropship.mode != SHUTTLE_CALL)
		return
	dropship.door_control.control_doors("force-unlock", "aft", TRUE)

/obj/structure/machinery/computer/cameras/dropship/proc/clear_locked_turf_and_lock_aft()
	SIGNAL_HANDLER
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
	if(!dropship)
		return
	dropship.door_control.control_doors("force-lock", "aft", TRUE)
	visible_message(SPAN_WARNING("[src] displays an alert as it loses the paradrop target."))
	for(var/obj/structure/dropship_equipment/paradrop_system/parad in dropship.equipments)
		parad.visible_message(SPAN_WARNING("[parad] displays an alert as it loses the paradrop target."))
		parad.on_signal_lost()
	if(dropship.paradrop_signal)
		UnregisterSignal(dropship.paradrop_signal, COMSIG_PARENT_QDELETING)
	UnregisterSignal(dropship, COMSIG_SHUTTLE_SETMODE)
	dropship.paradrop_signal = null
