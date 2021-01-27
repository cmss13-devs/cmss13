//Terribly sorry for the code doubling, but things go derpy otherwise.
/obj/structure/machinery/door/airlock/multi_tile
	width = 2
	damage_cap = 650 // Bigger = more endurable

/obj/structure/machinery/door/airlock/multi_tile/close() //Nasty as hell O(n^2) code but unfortunately necessary
	for(var/turf/T in locs)
		for(var/obj/vehicle/multitile/M in T)
			if(M) return 0

	return ..()

/obj/structure/machinery/door/airlock/multi_tile/glass
	name = "Glass Airlock"
	icon = 'icons/obj/structures/doors/Door2x1glass.dmi'
	opacity = 0
	glass = 1
	assembly_type = /obj/structure/airlock_assembly/multi_tile


/obj/structure/machinery/door/airlock/multi_tile/security
	name = "Security Airlock"
	icon = 'icons/obj/structures/doors/Door2x1security.dmi'
	opacity = 0
	glass = 1


/obj/structure/machinery/door/airlock/multi_tile/command
	name = "Command Airlock"
	icon = 'icons/obj/structures/doors/Door2x1command.dmi'
	opacity = 0
	glass = 1

/obj/structure/machinery/door/airlock/multi_tile/medical
	name = "Medical Airlock"
	icon = 'icons/obj/structures/doors/Door2x1medbay.dmi'
	opacity = 0
	glass = 1

/obj/structure/machinery/door/airlock/multi_tile/engineering
	name = "Engineering Airlock"
	icon = 'icons/obj/structures/doors/Door2x1engine.dmi'
	opacity = 0
	glass = 1


/obj/structure/machinery/door/airlock/multi_tile/research
	name = "Research Airlock"
	icon = 'icons/obj/structures/doors/Door2x1research.dmi'
	opacity = 0
	glass = 1

/obj/structure/machinery/door/airlock/multi_tile/secure
	name = "Secure Airlock"
	icon = 'icons/obj/structures/doors/Door2x1_secure.dmi'
	openspeed = 34

/obj/structure/machinery/door/airlock/multi_tile/secure2
	name = "Secure Airlock"
	icon = 'icons/obj/structures/doors/Door2x1_secure2.dmi'
	openspeed = 31
	req_access = null

/obj/structure/machinery/door/airlock/multi_tile/secure2_glass
	name = "Secure Airlock"
	icon = 'icons/obj/structures/doors/Door2x1_secure2_glass.dmi'
	opacity = 0
	glass = 1
	openspeed = 31
	req_access = null

/obj/structure/machinery/door/airlock/multi_tile/shuttle
	name = "Shuttle Podlock"
	icon = 'icons/obj/structures/doors/1x2blast_vert.dmi'
	icon_state = "pdoor1"
	opacity = 1
	openspeed = 12
	req_access = null
	not_weldable = 1


// ALMAYER

/obj/structure/machinery/door/airlock/multi_tile/almayer
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/comdoor.dmi' //Tiles with is here FOR SAFETY PURPOSES
	openspeed = 4 //shorter open animation.
	tiles_with = list(
		/obj/structure/window/framed/almayer,
		/obj/structure/machinery/door/airlock)

/obj/structure/machinery/door/airlock/multi_tile/almayer/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/door/airlock/multi_tile/almayer/LateInitialize()
	. = ..()
	relativewall_neighbours()

/obj/structure/machinery/door/airlock/multi_tile/almayer/take_damage(var/dam, var/mob/M)
	var/damage_check = max(0, damage + dam)
	if(damage_check >= damage_cap && M && is_mainship_level(z))
		SSclues.create_print(get_turf(M), M, "The fingerprint contains bits of wire and metal specks.")
	..()

/obj/structure/machinery/door/airlock/multi_tile/almayer/generic
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/2x1generic.dmi'
	opacity = 0
	glass = 1

/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor
	name = "\improper Medical Airlock"
	icon = 'icons/obj/structures/doors/2x1medidoor.dmi'
	opacity = 0
	glass = 1
	req_access = list()
	req_one_access = list(ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_MEDBAY, ACCESS_MARINE_BRIDGE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor
	name = "\improper Command Airlock"
	icon = 'icons/obj/structures/doors/2x1comdoor.dmi'
	opacity = 0
	glass = 1
	req_access = list(ACCESS_MARINE_BRIDGE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/handle_multidoor()
	if(!(width > 1)) return //Bubblewrap

	for(var/i = 1, i < width, i++)
		if(dir in list(NORTH, SOUTH))
			var/turf/T = locate(x, y + i, z)
			T.SetOpacity(opacity)
		else if(dir in list(EAST, WEST))
			var/turf/T = locate(x + i, y, z)
			T.SetOpacity(opacity)

	if(dir in list(NORTH, SOUTH))
		bound_height = world.icon_size * width
	else if(dir in list(EAST, WEST))
		bound_width = world.icon_size * width

//We have to find these again since these doors are used on shuttles a lot so the turfs changes
/obj/structure/machinery/door/airlock/multi_tile/almayer/proc/update_filler_turfs()

	for(var/i = 1, i < width, i++)
		if(dir in list(NORTH, SOUTH))
			var/turf/T = locate(x, y + i, z)
			if(T) T.SetOpacity(opacity)
		else if(dir in list(EAST, WEST))
			var/turf/T = locate(x + i, y, z)
			if(T) T.SetOpacity(opacity)

/obj/structure/machinery/door/airlock/multi_tile/almayer/proc/get_filler_turfs()
	var/list/filler_turfs = list()
	for(var/i = 1, i < width, i++)
		if(dir in list(NORTH, SOUTH))
			var/turf/T = locate(x, y + i, z)
			if(T) filler_turfs += T
		else if(dir in list(EAST, WEST))
			var/turf/T = locate(x + i, y, z)
			if(T) filler_turfs += T
	return filler_turfs

/obj/structure/machinery/door/airlock/multi_tile/almayer/open()
	. = ..()
	update_filler_turfs()

/obj/structure/machinery/door/airlock/multi_tile/almayer/close()
	. = ..()
	update_filler_turfs()

//------Dropship Cargo Doors -----//

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear
	opacity = 1
	width = 3
	unslashable = TRUE
	unacidable = TRUE
	no_panel = 1
	not_weldable = 1

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/ex_act(severity)
	return


/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/unlock()
	if(is_loworbit_level(z))
		return // in orbit
	..()

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/ds1
	name = "\improper Alamo cargo door"
	icon = 'icons/obj/structures/doors/dropship1_cargo.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/ds2
	name = "\improper Normandy cargo door"
	icon = 'icons/obj/structures/doors/dropship2_cargo.dmi'




// Elevator door
/obj/structure/machinery/door/airlock/multi_tile/elevator
	icon = 'icons/obj/structures/doors/4x1_elevator.dmi'
	icon_state = "door_closed"
	width = 4
	openspeed = 22

/obj/structure/machinery/door/airlock/multi_tile/elevator/research
	name = "\improper Research Elevator Hatch"

/obj/structure/machinery/door/airlock/multi_tile/elevator/arrivals
	name = "\improper Arrivals Elevator Hatch"

/obj/structure/machinery/door/airlock/multi_tile/elevator/dormatory
	name = "\improper Dormitory Elevator Hatch"

/obj/structure/machinery/door/airlock/multi_tile/elevator/freight
	name = "\improper Freight Elevator Hatch"


/obj/structure/machinery/door/airlock/multi_tile/elevator/access
	icon = 'icons/obj/structures/doors/4x1_elevator_access.dmi'
	opacity = 0
	glass = 1

/obj/structure/machinery/door/airlock/multi_tile/elevator/access/research
	name = "\improper Research Elevator Hatch"

/obj/structure/machinery/door/airlock/multi_tile/elevator/access/arrivals
	name = "\improper Arrivals Elevator Hatch"

/obj/structure/machinery/door/airlock/multi_tile/elevator/access/dormatory
	name = "\improper Dormitory Elevator Hatch"

/obj/structure/machinery/door/airlock/multi_tile/elevator/access/freight
	name = "\improper Freight Elevator Hatch"
