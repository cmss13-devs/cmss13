/obj/structure/machinery/rampart
	icon = 'icons/obj/structures/machinery/rampart.dmi'
	icon_state = "rampart"
	dir = EAST
	layer = UNDERFLOOR_OBJ_LAYER
	name = "rampart"
	var/offset_on_deploy = 64
	var/obj/docking_port/stationary/marine_dropship/linked_port

/obj/structure/machinery/rampart/west
	dir = WEST
	offset_on_deploy = -64

/obj/structure/machinery/rampart/Initialize(mapload, ...)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MODE_POSTSETUP, PROC_REF(deploy))

/obj/structure/machinery/rampart/proc/deploy()
	if(SSticker.current_state < GAME_STATE_PLAYING)
		return
	animate(src, pixel_x = pixel_x + offset_on_deploy, time = 2 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(expand), 1), 0.5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(expand), 2), 1.5 SECONDS)


/obj/structure/machinery/rampart/proc/undeploy()
	animate(src, pixel_x = pixel_x - offset_on_deploy, time = 2 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(retract), 2), 0.5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(retract), 1), 1.5 SECONDS)



/obj/structure/machinery/rampart/Destroy()
	. = ..()
	if(linked_port)
		linked_port.ramparts -= src

/obj/structure/machinery/rampart/proc/expand(distance)
	var/turf/turf = src.loc
	if(dir == EAST)
		turf = get_step(turf, dir)
	for(var/i = 0; i < distance; i++)
		turf = get_step(turf, dir)
	turf.ChangeTurf(/turf/solid_open_space/walkable)
	var/turf/turf_north = get_step(turf, NORTH)
	turf_north.ChangeTurf(/turf/solid_open_space/walkable)

/obj/structure/machinery/rampart/proc/retract(distance)
	var/turf/turf = src.loc
	if(dir == EAST)
		turf = get_step(turf, dir)
	for(var/i = 0; i < distance; i++)
		turf = get_step(turf, dir)
	turf.ChangeTurf(/turf/open_space)
	var/turf/turf_north = get_step(turf, NORTH)
	turf_north.ChangeTurf(/turf/open_space)

/obj/effect/decal/strata_decals/catwalk/prison/hangar
	keep_as_object = TRUE
	anchored = TRUE
	plane = GAME_PLANE
