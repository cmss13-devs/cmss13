/obj/structure/machinery/computer/camera_advanced
	name = "advanced camera console"
	desc = "Used to access the various cameras on the ship."
	icon_state = "cameras"
	var/list/z_lock = list() // Lock use to these z levels
	var/lock_override = NONE
	var/open_prompt = TRUE
	var/mob/camera/eye/remote/eyeobj
	var/mob/living/current_user
	var/list/networks = list(CAMERA_NET_ALMAYER)
	var/datum/action/innate/camera_off/off_action
	var/datum/action/innate/camera_jump/jump_action
	var/list/actions
	var/mob/living/tracking_target
	var/tracking = FALSE
	var/cameraticks = 0

/obj/structure/machinery/computer/camera_advanced/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	interact(user)

/obj/structure/machinery/computer/camera_advanced/Initialize()
	. = ..()
	off_action = new
	jump_action = new
	actions = list()
	if(lock_override)
		if(lock_override & CAMERA_LOCK_SHIP)
			z_lock |= SSmapping.levels_by_trait(ZTRAITS_MAIN_SHIP)
		if(lock_override & CAMERA_LOCK_GROUND)
			z_lock |= SSmapping.levels_by_trait(ZTRAIT_GROUND)
		if(lock_override & CAMERA_LOCK_ADMIN)
			z_lock |= SSmapping.levels_by_trait(ZTRAIT_ADMIN)


/obj/structure/machinery/computer/camera_advanced/proc/CreateEye()
	eyeobj = new()
	eyeobj.origin = src


/obj/structure/machinery/computer/camera_advanced/proc/give_actions(mob/living/user)
	if(off_action)
		off_action.target = user
		off_action.give_to(user)
		actions += off_action

	if(jump_action)
		jump_action.target = user
		jump_action.give_to(user)
		actions += jump_action


/obj/structure/machinery/computer/camera_advanced/remove_eye_control(mob/living/user)
	if(!user)
		return
	if(!eyeobj)
		return
	for(var/V in actions)
		var/datum/action/A = V
		A.remove_from(user)
	actions.Cut()
	for(var/V in eyeobj.visibleCameraChunks)
		var/datum/camerachunk/C = V
		C.remove(eyeobj)
	if(user.client)
		user.reset_perspective(null)
		if(eyeobj.visible_icon && user.client)
			user.client.images -= eyeobj.user_image
	eyeobj.eye_user = null
	user.remote_control = null

	current_user = null
	user.unset_interaction()
	playsound(src, 'sound/machines/terminal_off.ogg', 25, 0)


/obj/structure/machinery/computer/camera_advanced/check_eye(mob/living/user)
	if(stat & (NOPOWER|BROKEN) || user.is_mob_incapacitated(TRUE))
		user.unset_interaction()
	if(isAI(user))
		return
	if(!Adjacent(user) || is_blind(user))
		user.unset_interaction()


/obj/structure/machinery/computer/camera_advanced/Destroy()
	current_user?.unset_interaction()
	if(eyeobj)
		qdel(eyeobj)
	QDEL_LIST(actions)
	return ..()


/obj/structure/machinery/computer/camera_advanced/on_unset_interaction(mob/M)
	if(M == current_user)
		remove_eye_control(M)


/obj/structure/machinery/computer/camera_advanced/proc/can_use(mob/living/user)
	return TRUE


/obj/structure/machinery/computer/camera_advanced/interact(mob/living/user)
	. = ..()
	if(.)
		return

	if(open_prompt)
		open_prompt(user)


/obj/structure/machinery/computer/camera_advanced/proc/open_prompt(mob/user, turf/premade_camera_location)
	if(current_user)
		to_chat(user, "The console is already in use!")
		return

	var/mob/living/L = user

	if(!can_use(user))
		return

	if(!eyeobj)
		CreateEye()

	if(!eyeobj.eye_initialized)
		if(premade_camera_location)
			eyeobj.eye_initialized = TRUE
			give_eye_control(L)
			eyeobj.setLoc(premade_camera_location)
			return
		var/camera_location
		var/turf/myturf = get_turf(src)
		if(eyeobj.use_static)
			if((!length(z_lock) || (myturf.z in z_lock)) && GLOB.cameranet.checkTurfVis(myturf))
				camera_location = myturf
			else
				for(var/i in GLOB.cameranet.cameras)
					var/obj/structure/machinery/camera/C = i
					if(!C.can_use() || length(z_lock) && !(C.z in z_lock))
						continue
					var/list/network_overlap = networks & C.network
					if(length(network_overlap))
						camera_location = get_turf(C)
						break
		else
			camera_location = myturf
			if(length(z_lock) && !(myturf.z in z_lock))
				camera_location = locate(round(world.maxx / 2), round(world.maxy / 2), z_lock[1])

		if(camera_location)
			eyeobj.eye_initialized = TRUE
			give_eye_control(L)
			eyeobj.setLoc(camera_location)
		else
			user.unset_interaction()
	else
		give_eye_control(L)
		eyeobj.setLoc(eyeobj.loc)


/obj/structure/machinery/computer/camera_advanced/proc/give_eye_control(mob/user)
	give_actions(user)
	current_user = user
	eyeobj.eye_user = user
	eyeobj.name = "Camera Eye ([user.name])"
	user.remote_control = eyeobj
	user.reset_perspective(eyeobj)
	eyeobj.setLoc(eyeobj.loc)

/obj/structure/machinery/computer/camera_advanced/proc/track(mob/living/target)
	if(!istype(target))
		return

	if(!target.can_track(current_user))
		to_chat(current_user, SPAN_WARNING("Target is not near any active cameras."))
		tracking_target = null
		return

	tracking_target = target
	to_chat(current_user, SPAN_NOTICE("Now tracking [target] on camera."))
	start_processing()


/obj/structure/machinery/computer/camera_advanced/process()
	if(QDELETED(tracking_target))
		return PROCESS_KILL

	if(!tracking_target.can_track(current_user))
		if(!cameraticks)
			to_chat(current_user, SPAN_WARNING("Target is not near any active cameras. Attempting to reacquire..."))
		cameraticks++
		if(cameraticks > 9)
			tracking_target = null
			to_chat(current_user, SPAN_WARNING("Unable to reacquire, cancelling track..."))
			return PROCESS_KILL
	else
		cameraticks = 0

	eyeobj?.setLoc(get_turf(tracking_target))


/mob/camera/eye/remote
	name = "Inactive Camera Eye"
	ai_detector_visible = FALSE
	/// The delay applied after moving to a tile.
	move_delay = 0.1 SECONDS
	/// Internal variable used to keep track of the amount of tiles we have moved in the same direction
	var/tiles_moved = 0
	/// Limits tiles_moved to this value.
	var/max_tile_acceleration = 8
	/// last direction moved
	var/direction_moved
	var/cooldown = 0
	var/acceleration = TRUE
	var/mob/living/eye_user = null
	var/obj/structure/machinery/origin
	var/eye_initialized = 0
	var/visible_icon = 0
	var/image/user_image = null


/mob/camera/eye/remote/update_remote_sight(mob/living/user)
	user.see_invisible = SEE_INVISIBLE_LIVING
	user.sight = SEE_SELF|SEE_MOBS|SEE_OBJS|SEE_TURFS|SEE_BLACKNESS
	user.see_in_dark = 2
	return TRUE


/mob/camera/eye/remote/Destroy()
	if(origin && eye_user)
		origin.remove_eye_control(eye_user,src)
	origin = null
	eye_user = null
	return ..()


/mob/camera/eye/remote/GetViewerClient()
	return eye_user?.client


/mob/camera/eye/remote/setLoc(atom/target)
	if(!eye_user)
		return
	var/turf/T = get_turf(target)
	if(!T)
		return
	if(T.z != z && use_static)
		GLOB.cameranet.visibility(src, GetViewerClient(), null, use_static)
	direction_moved = get_dir(src, target)
	abstract_move(T)
	if(use_static)
		GLOB.cameranet.visibility(src, GetViewerClient(), null, use_static)
	if(visible_icon && eye_user.client)
		eye_user.client.images -= user_image
		var/atom/top
		for(var/i in loc)
			var/atom/A = i
			if(!top)
				top = loc
			if(is_type_in_typecache(A.type, GLOB.ignored_atoms))
				continue
			if(A.layer > top.layer)
				top = A
			else if(A.plane > top.plane)
				top = A
		user_image = image(icon, top, icon_state, FLY_LAYER)
		eye_user.client.images += user_image


/mob/camera/eye/remote/relaymove(mob/user, direct)
	if(istype(origin, /obj/structure/machinery/computer/camera_advanced))
		var/obj/structure/machinery/computer/camera_advanced/CA = origin
		CA.tracking_target = null
	if(cooldown > world.time)
		return
	tiles_moved = ((cooldown + move_delay * 5) > world.time) ? 0 : tiles_moved
	cooldown = world.time + move_delay * (1 - acceleration * tiles_moved / 10)
	var/turf/T = get_turf(get_step(src, direct))
	// check for dir change , if we changed then remove all acceleration
	if(get_dir(src, T) != direction_moved)
		tiles_moved = 0
	tiles_moved = min(tiles_moved++, max_tile_acceleration)
	setLoc(T)

/datum/action/innate/camera_off
	name = "End Camera View"
	action_icon_state = "camera_off"


/datum/action/innate/camera_off/action_activate()
	if(!isliving(target))
		return
	var/mob/living/C = target
	var/mob/camera/eye/remote/remote_eye = C.remote_control
	var/obj/structure/machinery/computer/camera_advanced/console = remote_eye.origin
	console.remove_eye_control(target)


/datum/action/innate/camera_jump
	name = "Jump To Camera"
	action_icon_state = "camera_jump"


/datum/action/innate/camera_jump/action_activate()
	if(!isliving(target))
		return
	var/mob/living/L = target
	var/mob/camera/eye/remote/remote_eye = L.remote_control
	var/obj/structure/machinery/computer/camera_advanced/origin = remote_eye.origin

	var/list/valid_cams = list()

	for(var/i in GLOB.cameranet.cameras)
		var/obj/structure/machinery/camera/C = i
		if(length(origin.z_lock) && !(C.z in origin.z_lock))
			continue
		valid_cams += C

	camera_sort(valid_cams)

	var/list/T = list()

	for(var/i in valid_cams)
		var/obj/structure/machinery/camera/C = i
		var/list/tempnetwork = C.network & origin.networks
		if(length(tempnetwork))
			T["[C.c_tag][C.can_use() ? "" : " (Deactivated)"]"] = C

	playsound(origin, 'sound/machines/terminal_prompt.ogg', 25, 0)
	var/camera = tgui_input_list(owner, "Choose which camera you want to view?", "Cameras", T)
	var/obj/structure/machinery/camera/C = T[camera]
	playsound(src, "terminal_type", 25, 0)

	if(!C)
		playsound(origin, 'sound/machines/terminal_prompt_deny.ogg', 25, 0)
		return

	playsound(origin, 'sound/machines/terminal_prompt_confirm.ogg', 25, 0)
	remote_eye.setLoc(get_turf(C))
	L.overlay_fullscreen("flash", /atom/movable/screen/fullscreen/flash/noise)
	L.clear_fullscreen("flash", 3)
