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

/obj/structure/machinery/computer/cameras/Initialize(mapload)
	. = ..()

	RegisterSignal(src, COMSIG_CAMERA_MAPNAME_ASSIGNED, PROC_REF(camera_mapname_update))

	// camera setup
	AddComponent(/datum/component/camera_manager)
	SEND_SIGNAL(src, COMSIG_CAMERA_CLEAR)

	if(colony_camera_mapload && mapload && is_ground_level(z))
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
		to_chat(user, SPAN_DANGER("<b>Unable to establish a connection</b>: \black You're too far away from the ship!"))
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

	if(!ui)
		var/user_ref = WEAKREF(user)
		var/is_living = isliving(user)
		// Ghosts shouldn't count towards concurrent users, which produces
		// an audible terminal_on click.
		if(is_living)
			concurrent_users += user_ref
		// Turn on the console
		if(length(concurrent_users) == 1 && is_living)
			update_use_power(USE_POWER_ACTIVE)

		SEND_SIGNAL(src, COMSIG_CAMERA_REGISTER_UI, user)

		// Open UI
		ui = new(user, src, "CameraConsole", name)
		ui.open()

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
	network = list(CAMERA_NET_CONTAINMENT, CAMERA_NET_CONTAINMENT_HIDDEN, CAMERA_NET_RESEARCH)

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

	var/shuttle_tag
	var/datum/tacmap/tacmap
	var/minimap_type = MINIMAP_FLAG_USCM
	var/camera_target_id
	var/camera_width = 11
	var/camera_height = 11
	var/registered = FALSE
	var/obj/structure/dropship_equipment/camera_area_equipment = null
	var/upgraded = MATRIX_DEFAULT // we transport upgrade var from matrixdm
	var/matrix_color = NV_COLOR_GREEN //color of matrix, only used when we upgrade to nv

	// Direct Fire offset - needed for weapon firing compatibility
	var/direct_x_offset_value = 0
	var/direct_y_offset_value = 0

	// Equipment selection - needed for equipment uninstall compatibility
	var/obj/structure/dropship_equipment/selected_equipment

/obj/structure/machinery/computer/cameras/dropship/Initialize(mapload)
	. = ..()

	// Initialize tacmap
	tacmap = new(src, minimap_type)

	// Add camera management component
	AddComponent(/datum/component/camera_manager)
	SEND_SIGNAL(src, COMSIG_CAMERA_CLEAR)

/obj/structure/machinery/computer/cameras/dropship/Destroy()
	QDEL_NULL(tacmap)
	return ..()

/obj/structure/machinery/computer/cameras/dropship/attack_hand(mob/user)
	if(inoperable())
		return

	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Auxiliary equipment access denied."))
		return TRUE

	if(!isRemoteControlling(user))
		user.set_interaction(src)
	tgui_interact(user)

/obj/structure/machinery/computer/cameras/dropship/tgui_interact(mob/user, datum/tgui/ui)
	if(!registered)
		var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
		if(dropship)
			RegisterSignal(dropship, COMSIG_DROPSHIP_ADD_EQUIPMENT, PROC_REF(equipment_update))
			RegisterSignal(dropship, COMSIG_DROPSHIP_REMOVE_EQUIPMENT, PROC_REF(equipment_update))
		registered = TRUE

	if(!tacmap.map_holder)
		var/level = SSmapping.levels_by_trait(tacmap.targeted_ztrait)
		if(level && length(level))
			tacmap.map_holder = SSminimaps.fetch_tacmap_datum(level[1], tacmap.allowed_flags)

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		if(tacmap.map_holder)
			user.client.register_map_obj(tacmap.map_holder.map)
		SEND_SIGNAL(src, COMSIG_CAMERA_REGISTER_UI, user)
		ui = new(user, src, "DropshipCameraConsole", "Camera Console")
		ui.open()

/obj/structure/machinery/computer/cameras/dropship/ui_close(mob/user)
	. = ..()
	SEND_SIGNAL(src, COMSIG_CAMERA_UNREGISTER_UI, user)

/obj/structure/machinery/computer/cameras/dropship/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/computer/cameras/dropship/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/computer/cameras/dropship/ui_static_data(mob/user)
	. = list()
	if(tacmap.map_holder)
		.["tactical_map_ref"] = tacmap.map_holder.map_ref
	.["camera_map_ref"] = camera_map_name

/obj/structure/machinery/computer/cameras/dropship/ui_data(mob/user)
	. = list()
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
	if(!istype(dropship))
		return

	.["equipment_data"] = get_sanitised_equipment(user, dropship)

	.["medevac_targets"] = list()
	for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
		if (istype(equipment, /obj/structure/dropship_equipment/medevac_system))
			var/obj/structure/dropship_equipment/medevac_system/medevac = equipment
			.["medevac_targets"] += medevac.ui_data(user)

	.["fulton_targets"] = list()
	for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
		if (istype(equipment, /obj/structure/dropship_equipment/fulton_system))
			var/obj/structure/dropship_equipment/fulton_system/fult = equipment
			.["fulton_targets"] += fult.ui_data(user)

	.["camera_target_id"] = camera_target_id

	if(selected_equipment)
		.["selected_eqp"] = selected_equipment.ship_base.attach_id

	.["available_cameras"] = list()
	var/list/cameras = get_available_cameras()
	for(var/c_tag in cameras)
		var/obj/structure/machinery/camera/camera = cameras[c_tag]
		if(camera)
			var/list/camera_data = list(
				"name" = c_tag,
				"ref" = "\ref[camera]"
			)
			.["available_cameras"] += list(camera_data)

	.["targets_data"] = list()
	var/datum/cas_iff_group/cas_group = GLOB.cas_groups[FACTION_MARINE]
	if(cas_group)
		for(var/datum/cas_signal/LT in cas_group.cas_signals)
			var/obj/object = LT.signal_loc
			if(!istype(LT) || !LT.valid_signal() || !is_ground_level(object.z))
				continue
			var/area/laser_area = get_area(LT.signal_loc)

			// Get ceiling protection tier for this target
			var/ceiling_tier = null
			if(laser_area)
				ceiling_tier = laser_area.ceiling

			.["targets_data"] += list(
				list(
					"target_name" = "[LT.name] ([laser_area.name])",
					"target_tag" = LT.target_id,
					"ceiling_protection_tier" = ceiling_tier
				)
			)

/obj/structure/machinery/computer/cameras/dropship/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("set-camera")
			var/target_camera = params["equipment_id"]
			var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
			if(!dropship)
				return TRUE

			for(var/obj/structure/dropship_equipment/rappel_system/rappel in dropship.equipments)
				rappel.cleanup_ropes(TRUE)
				rappel.icon_state = "rappel_hatch_closed"
				rappel.last_deployed_target = null
				rappel.manual_deploy_cooldown = world.time + 5 SECONDS

			set_camera_target(target_camera)
			return TRUE

		if("set-camera-sentry")
			var/equipment_tag = params["equipment_id"]
			var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
			if(!dropship)
				return TRUE

			for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
				var/mount_point = equipment.ship_base.attach_id
				if(mount_point != equipment_tag)
					continue
				if(istype(equipment, /obj/structure/dropship_equipment/sentry_holder))
					var/obj/structure/dropship_equipment/sentry_holder/sentry = equipment
					var/obj/structure/machinery/defenses/sentry/defense = sentry.deployed_turret
					if(defense.has_camera)
						defense.set_range()
						camera_area_equipment = sentry
						SEND_SIGNAL(src, COMSIG_CAMERA_SET_AREA, defense.range_bounds, defense.loc.z)
			return TRUE

		if("auto-deploy")
			var/equipment_tag = params["equipment_id"]
			var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
			if(!dropship)
				return TRUE

			for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
				var/mount_point = equipment.ship_base.attach_id
				if(mount_point != equipment_tag)
					continue

				if(istype(equipment, /obj/structure/dropship_equipment/sentry_holder))
					var/obj/structure/dropship_equipment/sentry_holder/sentry = equipment
					sentry.auto_deploy = !sentry.auto_deploy
					return TRUE

				if(istype(equipment, /obj/structure/dropship_equipment/mg_holder))
					var/obj/structure/dropship_equipment/mg_holder/mg = equipment
					mg.auto_deploy = !mg.auto_deploy
			return TRUE

		if("clear-camera")
			set_camera_target(null)
			return TRUE

		if("nvg-enable")
			if(upgraded != MATRIX_NVG)
				to_chat(usr, SPAN_WARNING("The matrix is not upgraded with night vision."))
				return FALSE
			if(usr.client?.prefs?.night_vision_preference)
				matrix_color = usr.client.prefs.nv_color_list[usr.client.prefs.night_vision_preference]
			SEND_SIGNAL(src, COMSIG_CAMERA_SET_NVG, 5, matrix_color)
			return TRUE

		if("nvg-disable")
			SEND_SIGNAL(src, COMSIG_CAMERA_CLEAR_NVG)
			return TRUE

		if("paradrop-lock")
			var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
			if(!dropship)
				return FALSE
			if(dropship.mode != SHUTTLE_CALL)
				return FALSE
			if(dropship.paradrop_signal)
				clear_locked_turf_and_lock_aft()
				return TRUE
			var/datum/cas_signal/sig = get_cas_signal(camera_target_id)
			if(!sig)
				to_chat(usr, SPAN_WARNING("No signal chosen."))
				return FALSE
			var/turf/location = get_turf(sig.signal_loc)
			var/area/location_area = get_area(location)
			if(CEILING_IS_PROTECTED(location_area.ceiling, CEILING_PROTECTION_TIER_1))
				to_chat(usr, SPAN_WARNING("Target is obscured."))
				return FALSE
			var/equipment_tag = params["equipment_id"]
			for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
				var/mount_point = equipment.ship_base.attach_id
				if(mount_point != equipment_tag)
					continue
				if(istype(equipment, /obj/structure/dropship_equipment/paradrop_system))
					var/obj/structure/dropship_equipment/paradrop_system/paradrop_system = equipment
					if(paradrop_system.system_cooldown > world.time)
						to_chat(usr, SPAN_WARNING("You toggled the system too recently."))
						return
					paradrop_system.system_cooldown = world.time + 5 SECONDS
					paradrop_system.visible_message(SPAN_NOTICE("[equipment] hums as it locks to a signal."))
					break
			dropship.paradrop_signal = sig
			addtimer(CALLBACK(src, PROC_REF(open_aft_for_paradrop)), 2 SECONDS)
			RegisterSignal(dropship.paradrop_signal, COMSIG_PARENT_QDELETING, PROC_REF(clear_locked_turf_and_lock_aft))
			RegisterSignal(dropship, COMSIG_SHUTTLE_SETMODE, PROC_REF(clear_locked_turf_and_lock_aft))
			return TRUE

		if("rappel-lock")
			var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
			if(!dropship)
				return FALSE

			var/obj/structure/dropship_equipment/rappel_system/rappel = null
			for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
				if(istype(equipment, /obj/structure/dropship_equipment/rappel_system))
					rappel = equipment
					break
			if(!rappel)
				to_chat(usr, SPAN_WARNING("No rappel system installed on this dropship."))
				return FALSE

			var/datum/cas_signal/sig = get_cas_signal(camera_target_id)
			if(!sig)
				to_chat(usr, SPAN_WARNING("No signal chosen."))
				return FALSE

			if(rappel.locked_target && rappel.locked_target != sig)
				// Only allow automatic winch raising if not on cooldown
				if(rappel.system_cooldown <= world.time)
					rappel.cleanup_ropes(TRUE)
				else
					to_chat(usr, SPAN_WARNING("Cannot change rappel target while system is cooling down from active deployment."))
					return FALSE

			// Store the target in the rappel system for later use
			rappel.locked_target = sig
			to_chat(usr, SPAN_NOTICE("Rappel target locked: [sig.name]"))

			// Register signal handling for rappel cleanup
			UnregisterSignal(dropship, COMSIG_SHUTTLE_SETMODE, PROC_REF(clear_rope_landed))
			RegisterSignal(dropship, COMSIG_SHUTTLE_SETMODE, PROC_REF(clear_rope_landed))
			return TRUE

		if("rappel-cancel")
			var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
			if(!dropship)
				return FALSE
			var/obj/structure/dropship_equipment/rappel_system/rappel = null
			for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
				if(istype(equipment, /obj/structure/dropship_equipment/rappel_system))
					rappel = equipment
					break
			if(!rappel)
				return FALSE

			if(world.time < rappel.manual_cancel_cooldown)
				to_chat(usr, SPAN_WARNING("You must wait before canceling the rappel again!"))
				return FALSE

			rappel.cleanup_ropes(TRUE)
			rappel.icon_state = "rappel_hatch_closed"
			rappel.last_deployed_target = null
			rappel.manual_deploy_cooldown = world.time + 5 SECONDS
			return TRUE

		if("select-ammo")
			var/weapon_tag = params["eqp_tag"]
			var/ammo_ref = params["ammo_ref"]
			if(!weapon_tag || !ammo_ref)
				to_chat(usr, SPAN_WARNING("You must select both a weapon and an ammo type."))
				return TRUE

			var/obj/structure/dropship_equipment/weapon/selected_weapon = get_weapon(weapon_tag)
			if(!selected_weapon)
				to_chat(usr, SPAN_WARNING("No weapon selected for reloading."))
				return TRUE

			var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
			if(!dropship)
				return TRUE

			// Find the autoreloader installed on the shuttle
			var/obj/structure/dropship_equipment/autoreloader/auto = null
			for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
				if(istype(equipment, /obj/structure/dropship_equipment/autoreloader))
					auto = equipment
					break
			if(!auto)
				to_chat(usr, SPAN_WARNING("No autoreloader system installed on this dropship."))
				return TRUE

			var/obj/structure/ship_ammo/selected_ammo = locate(ammo_ref)
			if(!selected_ammo)
				to_chat(usr, SPAN_WARNING("Selected ammo not found in autoreloader."))
				return TRUE

			// Check compatibility
			if(istype(selected_ammo.equipment_type, /list))
				var/eq_types = selected_ammo.equipment_type
				var/found = FALSE
				for(var/eq_type in eq_types)
					if(istype(selected_weapon, eq_type))
						found = TRUE
						break
				if(!found)
					to_chat(usr, SPAN_WARNING("[selected_ammo.name] is not compatible with [selected_weapon.name]."))
					return TRUE
			else if(!istype(selected_weapon, selected_ammo.equipment_type))
				to_chat(usr, SPAN_WARNING("[selected_ammo.name] is not compatible with [selected_weapon.name]."))
				return TRUE

			// Save selected weapon and ammo to the autoreloader for later use
			auto.selected_weapon = selected_weapon
			auto.selected_ammo = selected_ammo
			auto.update_icon()
			to_chat(usr, SPAN_NOTICE("[selected_ammo.name] selected for [selected_weapon.name]. Ready to reload."))
			return TRUE

		if("firemission-dual-offset-camera")
			var/target_id = params["target_id"]
			camera_target_id = target_id

			// Get the CAS signal and switch camera to that location
			var/datum/cas_signal/cas_sig = get_cas_signal(camera_target_id)
			if(cas_sig && cas_sig.signal_loc)
				var/turf/target_turf = get_turf(cas_sig.signal_loc)
				if(target_turf)
					// Set camera to the target location using the area targeting system
					var/cam_width = camera_width
					var/cam_height = camera_height
					if(upgraded == MATRIX_WIDE)
						cam_width = cam_width * 1.5
						cam_height = cam_height * 1.5

					// Create a shape object for the camera area
					var/shape_size = max(cam_width, cam_height)
					var/datum/shape/rectangle/square/target_area = new(target_turf.x, target_turf.y, shape_size)

					// Use area-based camera targeting for signal locations
					SEND_SIGNAL(src, COMSIG_CAMERA_SET_AREA, target_area, target_turf.z)

			// Update all equipment to respond to camera target change
			var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
			if(dropship)
				for(var/obj/structure/dropship_equipment/equipment in dropship.equipments)
					equipment.update_equipment()
			return TRUE

		if("fire-weapon")
			var/equipment_tag = params["eqp_tag"]
			var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
			if(!dropship)
				return TRUE

			for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
				if(ref(equipment) != equipment_tag)
					continue
				if(equipment.is_weapon)
					var/obj/structure/dropship_equipment/weapon/WEAP = equipment

					// Check weapon cooldown (same as weapon console)
					if(WEAP.last_fired > world.time - WEAP.firing_delay)
						to_chat(usr, SPAN_WARNING("[WEAP] just fired, wait for it to cool down."))
						return TRUE

					WEAP.linked_console = src
					if(WEAP.is_interactable)
						var/datum/cas_signal/target = get_cas_signal(camera_target_id)
						if(target)
							WEAP.open_fire(target.signal_loc, usr)
						else
							to_chat(usr, SPAN_WARNING("No target selected."))
				return TRUE

		if("deploy-equipment")
			var/equipment_id = params["equipment_id"]
			var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
			if(!dropship)
				return TRUE

			for(var/obj/structure/dropship_equipment/equipment in dropship.equipments)
				if(equipment.ship_base && equipment.ship_base.attach_id == equipment_id)
					if(equipment.is_interactable)
						equipment.equipment_interact(usr)
					return TRUE
			return TRUE

		if("medevac-target")
			var/equipment_tag = params["equipment_id"]
			var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
			if(!dropship)
				return TRUE

			for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
				var/mount_point = equipment.ship_base.attach_id
				if(mount_point != equipment_tag)
					continue
				if (istype(equipment, /obj/structure/dropship_equipment/medevac_system))
					var/obj/structure/dropship_equipment/medevac_system/medevac = equipment
					var/target_ref = params["ref"]
					medevac.automate_interact(usr, target_ref)
				return TRUE

		if("fulton-target")
			var/equipment_tag = params["equipment_id"]
			var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
			if(!dropship)
				return TRUE

			for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
				var/mount_point = equipment.ship_base.attach_id
				if(mount_point != equipment_tag)
					continue
				if (istype(equipment, /obj/structure/dropship_equipment/fulton_system))
					var/obj/structure/dropship_equipment/fulton_system/fulton = equipment
					var/target_ref = params["ref"]
					fulton.automate_interact(usr, target_ref)
				return TRUE

/obj/structure/machinery/computer/cameras/dropship/proc/set_camera_target(target_ref)
	camera_area_equipment = null

	var/datum/cas_signal/target = get_cas_signal(target_ref)
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
	. = null
	if(!shuttle_tag)
		return
	var/datum/cas_iff_group/group = GLOB.cas_groups[FACTION_MARINE]
	if(!group)
		return
	for(var/datum/cas_signal/sig in group.cas_signals)
		if(sig.target_id != sig_id)
			continue
		return sig

/obj/structure/machinery/computer/cameras/dropship/proc/equipment_update()
	return

/obj/structure/machinery/computer/cameras/dropship/proc/get_sanitised_equipment(mob/user, obj/docking_port/mobile/marine_dropship/dropship)
	. = list()
	for(var/obj/structure/dropship_equipment/equipment in dropship.equipments)
		var/list/data = list(
			"name"= equipment.name,
			"shorthand" = equipment.shorthand,
			"eqp_tag" = ref(equipment),
			"is_weapon" = equipment.is_weapon,
			"is_interactable" = equipment.is_interactable,
			"mount_point" = equipment.ship_base.attach_id,
			"is_missile" = istype(equipment,  /obj/structure/dropship_equipment/weapon/rocket_pod),
			"ammo_name" = equipment.ammo_equipped?.name,
			"ammo" = equipment.ammo_equipped?.ammo_count,
			"max_ammo" = equipment.ammo_equipped?.max_ammo_count,
			"firemission_delay" = equipment.ammo_equipped?.fire_mission_delay,
			"burst" = equipment.ammo_equipped?.ammo_used_per_firing,
			"icon_state" = equipment.icon_state,
			"damaged" = equipment.damaged,
			"data" = equipment.ui_data(user)
		)

		// Add weapon firing timing data for cooldown display
		if(istype(equipment, /obj/structure/dropship_equipment/weapon))
			var/obj/structure/dropship_equipment/weapon/weapon = equipment
			data["last_fired"] = weapon.last_fired
			data["firing_delay"] = weapon.firing_delay

		// Add support equipment cooldown data
		if(istype(equipment, /obj/structure/dropship_equipment/medevac_system))
			var/obj/structure/dropship_equipment/medevac_system/medevac = equipment
			data["medevac_cooldown"] = medevac.medevac_cooldown

		if(istype(equipment, /obj/structure/dropship_equipment/rappel_system))
			var/obj/structure/dropship_equipment/rappel_system/rappel = equipment
			data["system_cooldown"] = rappel.system_cooldown

		if(istype(equipment, /obj/structure/dropship_equipment/paradrop_system))
			var/obj/structure/dropship_equipment/paradrop_system/paradrop = equipment
			data["system_cooldown"] = paradrop.system_cooldown

		if(istype(equipment, /obj/structure/dropship_equipment/sentry_holder))
			var/obj/structure/dropship_equipment/sentry_holder/sentry = equipment
			data["deployment_cooldown"] = sentry.deployment_cooldown

		if(istype(equipment, /obj/structure/dropship_equipment/mg_holder))
			var/obj/structure/dropship_equipment/mg_holder/mg = equipment
			data["deployment_cooldown"] = mg.deployment_cooldown

		if(istype(equipment, /obj/structure/dropship_equipment/electronics/spotlights))
			var/obj/structure/dropship_equipment/electronics/spotlights/spotlight = equipment
			data["spotlights_cooldown"] = spotlight.spotlights_cooldown

		if(istype(equipment, /obj/structure/dropship_equipment/fulton_system))
			var/obj/structure/dropship_equipment/fulton_system/fulton = equipment
			data["fulton_cooldown"] = fulton.fulton_cooldown

		// If this is an autoreloader, add stored ammo info as a list
		if(istype(equipment, /obj/structure/dropship_equipment/autoreloader))
			var/obj/structure/dropship_equipment/autoreloader/auto = equipment
			data["reload_cooldown"] = auto.reload_cooldown
			data["stored_ammo"] = list()
			for(var/obj/structure/ship_ammo/A in auto.stored_ammo)
				data["stored_ammo"] += list(list(
					"name" = A.name,
					"ammo_count" = A.ammo_count,
					"max_ammo_count" = A.max_ammo_count,
					"ammo_name" = A.ammo_name,
					"ref" = ref(A)
				))

		. += list(data)

		equipment.linked_console = src

/obj/structure/machinery/computer/cameras/dropship/one
	name = "\improper 'Alamo' camera controls"
	network = list(CAMERA_NET_ALAMO, CAMERA_NET_LASER_TARGETS)
	shuttle_tag = DROPSHIP_ALAMO
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP, ACCESS_WY_FLIGHT)

/obj/structure/machinery/computer/cameras/dropship/two
	name = "\improper 'Normandy' camera controls"
	network = list(CAMERA_NET_NORMANDY, CAMERA_NET_LASER_TARGETS)
	shuttle_tag = DROPSHIP_NORMANDY
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP, ACCESS_WY_FLIGHT)

/obj/structure/machinery/computer/cameras/dropship/three
	name = "\improper 'Saipan' camera controls"
	network = list(CAMERA_NET_RESEARCH, CAMERA_NET_LASER_TARGETS)
	shuttle_tag = DROPSHIP_SAIPAN
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP, ACCESS_WY_FLIGHT)

/obj/structure/machinery/computer/cameras/yautja
	name = "Hellhound Observation Interface"
	alpha = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	density = FALSE
	use_power = USE_POWER_NONE
	idle_power_usage = 0
	active_power_usage = 0
	needs_power = FALSE
	network = list(CAMERA_NET_YAUTJA)
	explo_proof = TRUE

/obj/structure/machinery/computer/cameras/yautja/Initialize()
	. = ..()
	SEND_SIGNAL(src, COMSIG_CAMERA_SET_NVG, 5, NV_COLOR_RED)

#undef DEFAULT_MAP_SIZE

// Helper procedures for UI actions
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
	UnregisterSignal(dropship.paradrop_signal, COMSIG_PARENT_QDELETING)
	UnregisterSignal(dropship, COMSIG_SHUTTLE_SETMODE)
	dropship.paradrop_signal = null

/obj/structure/machinery/computer/cameras/dropship/proc/clear_rope_landed()
	SIGNAL_HANDLER
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
	if(!dropship)
		return
	for(var/obj/structure/dropship_equipment/rappel_system/rappel in dropship.equipments)
		rappel.cleanup_ropes(TRUE)
		rappel.last_deployed_target = null // Clear target so redeploy to same lase is possible after landing
	UnregisterSignal(dropship, COMSIG_SHUTTLE_SETMODE, PROC_REF(clear_rope_landed))

/obj/structure/machinery/computer/cameras/dropship/proc/get_weapon(eqp_tag)
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttle_tag)
	for(var/obj/structure/dropship_equipment/weapon/WEAP as anything in dropship.equipments)
		if(ref(WEAP) == eqp_tag)
			return WEAP
	return
