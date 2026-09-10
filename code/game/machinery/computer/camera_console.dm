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
	desc = "A computer to monitor cameras linked to the dropship."
	density = TRUE
	icon = 'icons/obj/structures/machinery/shuttle-parts.dmi'
	icon_state = "consoleleft"
	circuit = null
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE


/obj/structure/machinery/computer/cameras/dropship/one
	name = "\improper 'Alamo' camera controls"
	network = list(CAMERA_NET_ALAMO, CAMERA_NET_LASER_TARGETS)

/obj/structure/machinery/computer/cameras/dropship/omaha
	name = "\improper 'Omaha' camera controls"
	icon = 'icons/obj/structures/machinery/omaha/controls.dmi'
	icon_state = "weapons_console"
	density = FALSE
	layer = OBJ_LAYER + 0.01
	network = list(CAMERA_NET_OMAHA, CAMERA_NET_LASER_TARGETS)

/obj/structure/machinery/computer/cameras/dropship/two
	name = "\improper 'Normandy' camera controls"
	network = list(CAMERA_NET_NORMANDY, CAMERA_NET_LASER_TARGETS)

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
	var/focused = FALSE
	var/matrix_color = NV_COLOR_GREEN
	var/datum/weakref/user_weakref
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
	if(linked_m90)
		return ..()
	else
		for(var/obj/structure/dropship_equipment/weapon/m90_minigun/gun in linked_dropship.equipments)
			linked_m90 = gun
			return ..()

/obj/structure/machinery/computer/cameras/dropship/midway/gunnery/ui_close(mob/user)
	if(focused)
		if(user_weakref)
			focus_mob()
			if(!user.client?.prefs.custom_cursors)
				return ..()
			user.client.mouse_pointer_icon = initial(user.client.mouse_pointer_icon)

	current = null
	return ..()

/obj/structure/machinery/computer/cameras/dropship/midway/gunnery/tgui_interact(mob/user, datum/tgui/ui)
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
			user_weakref = user_ref
		// Turn on the console
		if(length(concurrent_users) == 1 && is_living)
			update_use_power(USE_POWER_ACTIVE)

		SEND_SIGNAL(src, COMSIG_CAMERA_REGISTER_UI, user)

		// Open UI
		ui = new(user, src, "DropshipGunneryConsole", name)
		to_chat(world, "what3")
		ui.open()

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
				to_chat(world, "dogshit")
				selected_camera = null
				current = null
				ui_data()
				return

		current = selected_camera
		playsound(src, get_sfx("terminal_type"), 25, FALSE)

		if(!selected_camera)
			return TRUE
		to_chat(world, "what2")
		to_chat(world, "selected_camera.view_range is [selected_camera.view_range]")
		SEND_SIGNAL(src, COMSIG_CAMERA_SET_TARGET, selected_camera, selected_camera.view_range, selected_camera.view_range)
		if(user_weakref)
			focus_camera(selected_camera)
			prepare()
		return TRUE

/obj/structure/machinery/computer/cameras/dropship/midway/gunnery/proc/focus_mob()
	to_chat(world, "focusing mob")
	var/mob/living/carbon/human/user = user_weakref.resolve()
	user.remove_client_color_matrix("nvg_visor", 0.75 SECONDS)
	user.clear_fullscreen("nvg_visor", 0.3 SECONDS)
	user.clear_fullscreen("nvg_visor_blur", 0.3 SECONDS)
	playsound(user, 'sound/handling/toggle_nv2.ogg', 25)

	UnregisterSignal(user, COMSIG_MOB_POST_CLICK)

	user.reset_view(user)
	user.update_sight()
	focused = FALSE

/obj/structure/machinery/computer/cameras/dropship/midway/gunnery/proc/focus_camera(selected_camera)
	to_chat(world, "focusing camera")
	var/mob/living/carbon/human/user = user_weakref.resolve()
	to_chat(world, "user found")
	if(user.client?.prefs?.night_vision_preference)
		matrix_color = user.client.prefs.nv_color_list[user.client.prefs.night_vision_preference]
	user.add_client_color_matrix("nvg_visor", 99, color_matrix_multiply(color_matrix_saturation(0), color_matrix_from_string(matrix_color)), 0.75 SECONDS)
	user.overlay_fullscreen("nvg_visor", /atom/movable/screen/fullscreen/flash/noise/nvg)
	user.overlay_fullscreen("nvg_visor_blur", /atom/movable/screen/fullscreen/brute/nvg, 3)
	playsound(user, 'sound/handling/toggle_nv1.ogg', 25)

	user.reset_view(selected_camera)
	user.update_sight()
	focused = TRUE

/obj/structure/machinery/computer/cameras/dropship/midway/gunnery/proc/prepare()
	var/mob/living/carbon/human/user = user_weakref.resolve()

	if(!skillcheck(user, SKILL_PILOT, linked_m90.skill_required)) //only pilots can fire dropship weapons.
		to_chat(user, SPAN_WARNING("You don't have the training to fire this weapon!"))
		return FALSE
//	if(!faction)
//		return FALSE//no faction, no weapons
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

	if(!linked_m90.ammo_equipped || linked_m90.ammo_equipped.ammo_count <= 0)
		to_chat(user, SPAN_WARNING("The [linked_m90.name] has no ammo."))
		return FALSE
	if(linked_m90.last_fired > world.time - linked_m90.firing_delay)
		to_chat(user, SPAN_WARNING("[linked_m90.name] just fired, wait for it to cool down."))
		return FALSE
	if(linked_dropship.mode != SHUTTLE_CALL)
		to_chat(user, SPAN_WARNING("Dropship can only fire while in flight."))
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


/obj/structure/machinery/computer/cameras/dropship/three
	name = "\improper 'Saipan' camera controls"
	network = list(CAMERA_NET_RESEARCH, CAMERA_NET_LASER_TARGETS)

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
