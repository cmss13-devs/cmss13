// In theory we only support multiple per ID, but in practice it's 1:1.
// Still this is an alist of id -> list of /obj/effect/landmark/dispersal_initiator instances.
GLOBAL_ALIST_EMPTY(dispersal_initiators_by_id)
/obj/effect/landmark/dispersal_initiator
	name = "\improper Dispersal Initiator"
	icon = 'icons/old_stuff/mark.dmi'
	icon_state = "spawn_shuttle_move"
	layer = ABOVE_FLY_LAYER - 0.1 //to make it visible in the map editor
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	explo_proof = TRUE
	var/id = null

/obj/effect/landmark/dispersal_initiator/floodgate
	id = "floodgate"

/obj/effect/landmark/dispersal_initiator/filter_one
	id = "filter 1"

/obj/effect/landmark/dispersal_initiator/filter_two
	id = "filter 2"

/obj/effect/landmark/dispersal_initiator/Initialize(mapload, ...)
	if(!id)
		stack_trace("\The [src] [type] at [x] [y] [z] had no ID set, deleting!")
		return INITIALIZE_HINT_QDEL
	. = ..()
	LAZYADD(GLOB.dispersal_initiators_by_id[id], src)

/obj/effect/landmark/dispersal_initiator/Destroy()
	LAZYREMOVE(GLOB.dispersal_initiators_by_id[id], src)
	return ..()

/obj/effect/landmark/dispersal_initiator/proc/initiate_dispersal()
	// Ported over ambience->ambience_exterior, was broken. Enable if you actually want it
	//var/area/A = get_area(src)
	//A.ambience_exterior = 'sound/ambience/ambiatm1.ogg'
	for(var/obj/effect/blocker/water/our_water in get_turf(src))
		our_water.disperse_spread()

/obj/effect/landmark/dispersal_initiator/proc/initiate_drain()
	for(var/obj/effect/blocker/water/our_water in get_turf(src))
		our_water.drain_spread()
