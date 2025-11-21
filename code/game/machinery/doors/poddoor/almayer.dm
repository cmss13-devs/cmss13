/obj/structure/machinery/door/poddoor/almayer
	icon = 'icons/obj/structures/doors/blastdoors_shutters.dmi'
	openspeed = 4 //shorter open animation.
	var/vehicle_resistant = FALSE
	tiles_with = list(
		/obj/structure/window/framed/almayer,
		/obj/structure/machinery/door/airlock,
	)

/obj/structure/machinery/door/poddoor/almayer/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/door/poddoor/almayer/LateInitialize()
	. = ..()
	relativewall_neighbours()

/obj/structure/machinery/door/poddoor/almayer/open
	density = FALSE

/obj/structure/machinery/door/poddoor/almayer/blended
	icon_state = "almayer_pdoor1"
	base_icon_state = "almayer_pdoor"

/obj/structure/machinery/door/poddoor/almayer/blended/open
	density = FALSE

/obj/structure/machinery/door/poddoor/almayer/blended/white
	icon_state = "w_almayer_pdoor1"
	base_icon_state = "w_almayer_pdoor"

/obj/structure/machinery/door/poddoor/almayer/blended/white/open
	density = FALSE

/obj/structure/machinery/door/poddoor/almayer/blended/liaison
	name = "hull"
	desc = "A metal wall used to separate rooms and make up the ship."
	icon_state = "liaison_pdoor1"
	base_icon_state = "liaison_pdoor"
	id = "CLRoomDivider"

/obj/structure/machinery/door/poddoor/almayer/blended/liaison/open
	density = FALSE

/obj/structure/machinery/door/poddoor/almayer/blended/aicore
	icon_state = "aidoor1"
	base_icon_state = "aidoor"

/obj/structure/machinery/door/poddoor/almayer/blended/aicore/open
	density = FALSE

/obj/structure/machinery/door/poddoor/almayer/blended/white_aicore
	icon_state = "w_aidoor1"
	base_icon_state = "w_aidoor"

/obj/structure/machinery/door/poddoor/almayer/blended/white_aicore/open
	density = FALSE

/obj/structure/machinery/door/poddoor/almayer/locked
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/door/poddoor/almayer/locked/attackby(obj/item/C as obj, mob/user as mob)
	if(HAS_TRAIT(C, TRAIT_TOOL_CROWBAR))
		return
	. = ..()

/obj/structure/machinery/door/poddoor/almayer/closed
	density = TRUE
	opacity = TRUE

/obj/structure/machinery/door/poddoor/almayer/planet_side_blastdoor
	density = TRUE
	opacity = TRUE
	vehicle_resistant = TRUE
