var/datum/subsystem/landmark_init/SSlandmark_init
var/list/shuttle_landmarks = list()

/datum/subsystem/landmark_init
	name       = "Landmark Init"
	init_order = SS_INIT_LANDMARK
	flags      = SS_NO_FIRE

/datum/subsystem/landmark_init/New()
	NEW_SS_GLOBAL(SSlandmark_init)

/datum/subsystem/landmark_init/Initialize()
	for(var/obj/effect/landmark/shuttle_loc/L in shuttle_landmarks)
		L.initialize_marker()
		L.link_loc()
		shuttle_landmarks -= L
	..()
