//UPDATE TRIGGERS, when the chunk (and the surrounding chunks) should update.

// TURFS

/turf
	var/image/obscured

/turf/proc/visibilityChanged()
	if(z && SSatoms.initialized != INITIALIZATION_INSSATOMS)
		GLOB.cameranet.updateVisibility(src)

/obj/structure/machinery/door/poddoor/shutters/open()
	if(z && SSatoms.initialized != INITIALIZATION_INSSATOMS)
		GLOB.cameranet.updateVisibility(src)
	. = ..()


/obj/structure/machinery/door/poddoor/shutters/close()
	if(z && SSatoms.initialized != INITIALIZATION_INSSATOMS)
		GLOB.cameranet.updateVisibility(src)
	. = ..()


/obj/structure/machinery/door/poddoor/shutters/Destroy()
	if(z && SSatoms.initialized != INITIALIZATION_INSSATOMS)
		GLOB.cameranet.updateVisibility(src)
	. = ..()
// STRUCTURES

/obj/structure/Destroy(force)
	if(z && SSatoms.initialized != INITIALIZATION_INSSATOMS)
		GLOB.cameranet.updateVisibility(src)
	. = ..()

/obj/structure/Initialize(mapload, ...)
	. = ..()
	if(z && SSatoms.initialized != INITIALIZATION_INSSATOMS)
		GLOB.cameranet.updateVisibility(src)

// EFFECTS

/obj/effect/Destroy()
	if(z && SSatoms.initialized != INITIALIZATION_INSSATOMS)
		GLOB.cameranet.updateVisibility(src)
	. = ..()

/obj/effect/Initialize(mapload, ...)
	. = ..()
	if(z && SSatoms.initialized != INITIALIZATION_INSSATOMS)
		GLOB.cameranet.updateVisibility(src)



// ROBOT MOVEMENT

// Update the portable camera everytime the Robot moves.
// This might be laggy, comment it out if there are problems.
/mob/living/silicon/robot/var/updating = 0

/mob/living/silicon/robot/Move()
	var/oldLoc = src.loc
	. = ..()
	if(.)
		if(src.camera && src.camera.network.len)
			if(!updating)
				updating = 1
				if(oldLoc != src.loc)
					GLOB.cameranet.updatePortableCamera(src.camera)
				updating = 0

/mob/living/carbon/human/var/updating = 0

/mob/living/carbon/human/Move(NewLoc, direction)
	var/oldLoc = src.loc
	. = ..()
	if (.)
		for (var/obj/item/clothing/head/helmet/marine/H in src)
			if (!H.camera || !H.camera.network.len)
				continue
			if (updating)
				continue
			updating = TRUE
			if (oldLoc != loc)
				GLOB.cameranet.updatePortableCamera(H.camera)
			updating = FALSE

// CAMERA

// An addition to deactivate which removes/adds the camera from the chunk list based on if it works or not.

/obj/structure/machinery/camera/toggle_cam_status(mob/user, silent)
	..()
	if(can_use())
		GLOB.cameranet.addCamera(src)
	else
		set_light(0)
		GLOB.cameranet.removeCamera(src)

/obj/structure/machinery/camera/Initialize()
	. = ..()
	GLOB.cameranet.cameras += src //Camera must be added to global list of all cameras no matter what...
	var/list/open_networks = difflist(network,GLOB.RESTRICTED_CAMERA_NETWORKS) //...but if all of camera's networks are restricted, it only works for specific camera consoles.
	if(open_networks.len) //If there is at least one open network, chunk is available for AI usage.
		GLOB.cameranet.addCamera(src)

/obj/structure/machinery/camera/Destroy()
	GLOB.cameranet.cameras -= src
	var/list/open_networks = difflist(network,GLOB.RESTRICTED_CAMERA_NETWORKS)
	if(open_networks.len)
		GLOB.cameranet.removeCamera(src)
	. = ..()

