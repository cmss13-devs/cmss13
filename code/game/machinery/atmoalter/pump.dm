/obj/structure/machinery/portable_atmospherics/powered/pump
	name = "portable air pump"

	icon = 'icons/obj/structures/machinery/atmos.dmi'
	icon_state = "psiphon:0"
	density = 1

	var/on = 0

/obj/structure/machinery/portable_atmospherics/powered/pump/New()
	..()
	cell = new/obj/item/cell(src)

/obj/structure/machinery/portable_atmospherics/powered/pump/update_icon()
	src.overlays = 0

	if(on && cell && cell.charge)
		icon_state = "psiphon:1"
	else
		icon_state = "psiphon:0"

	if(connected_port)
		overlays += "siphon-connector"

	return

/obj/structure/machinery/portable_atmospherics/powered/pump/CanPass(atom/movable/mover, turf/target)
	if(density == 0) //Because broken racks -Agouri |TODO: SPRITE!|
		return 1
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0
