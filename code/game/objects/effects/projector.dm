/obj/effect/projector
	density = FALSE
	unacidable = TRUE
	anchored = TRUE
	invisibility = 101
	layer = TURF_LAYER
	icon = 'icons/landmarks.dmi'
	icon_state = "projector"//for map editor
	var/vector_x = 0
	var/vector_y = 0
	var/vector_z = 0
	var/firing_id = "generic"
	var/mask_layer = null // all actual layers are divided by 10 and then subtracted from the mask layer.
	var/movables_projection_plane = -6 //necessary to change when making a movable go under a turf (whose plane is -7)
	var/modify_turf = TRUE
	var/projected_mouse_opacity = 1
	var/projected_opacity

/obj/effect/projector/Initialize(mapload, ...)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/projector/LateInitialize()
	. = ..()
	if(locate(firing_id) in SSfz_transitions.selective_update)
		GLOB.projectors.Add(src)
	else
		GLOB.deselected_projectors.Add(src)

/obj/effect/projector/Destroy()
	. = ..()
	if(SSfz_transitions.selective_update[firing_id])
		GLOB.projectors -= src
	else
		GLOB.deselected_projectors -= src

/obj/effect/projector/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	return TRUE
	// we don't want projectors moving

/obj/effect/projector/airlock
	modify_turf = FALSE
	mask_layer = 1.9
	movables_projection_plane = -7
	projected_mouse_opacity = 0
	projected_opacity = 0
	firing_id = "airlock"

/obj/effect/projector/linked
	/// The identifier to a /obj/effect/projector_anchor identifier to offset the vectors to
	var/link

/obj/effect/projector/linked/Initialize(mapload, ...)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/projector/linked/LateInitialize()
	var/turf/linked_turf = GLOB.projector_links[link]
	vector_x += linked_turf.x - 1
	vector_y += linked_turf.y - 1
	vector_z += linked_turf.z - z

/obj/effect/projector_anchor
	density = FALSE
	unacidable = TRUE
	anchored = TRUE
	invisibility = 101
	layer = TURF_LAYER
	icon = 'icons/landmarks.dmi'
	icon_state = "projector"//for map editor
	/// The identifier for a /obj/effect/projector/linked to offset the vectors to
	var/link

/obj/effect/projector_anchor/Initialize(mapload, ...)
	..()
	var/turf/location = get_turf(src)
	if(!location)
		stack_trace("[src] ([type]) with identifier '[link]' has an invalid location!")
	else if(!link)
		stack_trace("[src] ([type]) at [x],[y],[z] has no identifier!")
	else
		GLOB.projector_links[link] = location
	return INITIALIZE_HINT_QDEL
