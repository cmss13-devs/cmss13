/obj/effect/projector
	density = FALSE
	unacidable = TRUE
	anchored = TRUE
	invisibility = 101
	layer = TURF_LAYER
	icon = 'icons/landmarks.dmi'
	icon_state = "projector"//for map editor
	/// The offset in x for this projector
	var/vector_x = 0
	/// The offset in y for this projector
	var/vector_y = 0
	/// The offset in z for this projector
	var/vector_z = 0

/obj/effect/projector/Initialize(mapload, ...)
	. = ..()
	GLOB.projectors += src

/obj/effect/projector/Destroy(force)
	. = ..()
	GLOB.projectors -= src

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
		stack_trace("[type] with identifier '[link]' has an invalid location!")
	else
		GLOB.projector_links[link] = location
	return INITIALIZE_HINT_QDEL
