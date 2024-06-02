/obj/structure/machinery/bluespace_beacon

	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beaconf"
	name = "Bluespace Gigabeacon"
	desc = "A device that draws power from bluespace and creates a permanent tracking beacon."
	level = 1 // underfloor
	layer = UNDERFLOOR_OBJ_LAYER
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 0
	var/obj/item/device/radio/beacon/Beacon

/obj/structure/machinery/bluespace_beacon/Initialize(mapload, ...)
	. = ..()
	var/turf/T = loc
	Beacon = new /obj/item/device/radio/beacon
	Beacon.invisibility = INVISIBILITY_MAXIMUM
	Beacon.forceMove(T)

	hide(T.intact_tile)

/obj/structure/machinery/bluespace_beacon/Destroy()
	QDEL_NULL(Beacon)
	return ..()

/obj/structure/machinery/bluespace_beacon/hide(intact)
	// update the invisibility and icon
	invisibility = intact ? 101 : 0
	updateicon()

	// update the icon_state
/obj/structure/machinery/bluespace_beacon/proc/updateicon()
	var/state="floor_beacon"

	if(invisibility)
		icon_state = "[state]f"

	else
		icon_state = "[state]"

/obj/structure/machinery/bluespace_beacon/process()
	if(!Beacon)
		var/turf/T = loc
		Beacon = new /obj/item/device/radio/beacon
		Beacon.invisibility = INVISIBILITY_MAXIMUM
		Beacon.forceMove(T)
	if(Beacon)
		if(Beacon.loc != loc)
			Beacon.forceMove(loc)

	updateicon()


