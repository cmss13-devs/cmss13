/obj/effect/landmark/objective_landmark
	name = "Objective Landmark"
	icon_state = "o_white"
	var/document_holder_present = FALSE

/obj/effect/landmark/objective_landmark/Initialize(mapload, ...)
	. = ..()
	if(!mapload)
		return INITIALIZE_HINT_QDEL
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/objective_landmark/LateInitialize()
	for(var/obj/structure/filingcabinet/fc in loc)
		document_holder_present = TRUE
		break

/obj/effect/landmark/objective_landmark/close
	name = "Objective Landmark Close"
	icon_state = "o_green"
/obj/effect/landmark/objective_landmark/close/Initialize(mapload, ...)
	. = ..()
	GLOB.objective_landmarks_close[src] = document_holder_present
/obj/effect/landmark/objective_landmark/close/Destroy(force = FALSE)
	GLOB.objective_landmarks_close.Remove(src)
	return ..()

/obj/effect/landmark/objective_landmark/medium
	name = "Objective Landmark Medium"
	icon_state = "o_yellow"
/obj/effect/landmark/objective_landmark/medium/Initialize(mapload, ...)
	. = ..()
	GLOB.objective_landmarks_medium[src] = document_holder_present
/obj/effect/landmark/objective_landmark/medium/Destroy(force = FALSE)
	GLOB.objective_landmarks_medium.Remove(src)
	return ..()

/obj/effect/landmark/objective_landmark/far
	name = "Objective Landmark Far"
	icon_state = "o_red"
/obj/effect/landmark/objective_landmark/far/Initialize(mapload, ...)
	. = ..()
	GLOB.objective_landmarks_far[src] = document_holder_present
/obj/effect/landmark/objective_landmark/far/Destroy(force = FALSE)
	GLOB.objective_landmarks_far.Remove(src)
	return ..()

/obj/effect/landmark/objective_landmark/science
	name = "Objective Landmark Science"
	icon_state = "o_blue"
/obj/effect/landmark/objective_landmark/science/Initialize(mapload, ...)
	. = ..()
	GLOB.objective_landmarks_science[src] = document_holder_present
/obj/effect/landmark/objective_landmark/science/Destroy(force = FALSE)
	GLOB.objective_landmarks_science.Remove(src)
	return ..()
