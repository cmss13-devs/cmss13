/obj/machinery/portable_atmospherics/powered/scrubber
	name = "Portable Air Scrubber"

	icon = 'icons/obj/machines/atmos.dmi'
	icon_state = "pscrubber:0"
	density = 1
	var/on = 0

/obj/machinery/portable_atmospherics/powered/scrubber/New()
	..()
	cell = new/obj/item/cell(src)


/obj/machinery/portable_atmospherics/powered/scrubber/CanPass(atom/movable/mover, turf/target)

	if(density == 0) //Because broken racks -Agouri |TODO: SPRITE!|
		return 1
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0


/obj/machinery/portable_atmospherics/powered/scrubber/update_icon()
	src.overlays = 0

	if(on && cell && cell.charge)
		icon_state = "pscrubber:1"
	else
		icon_state = "pscrubber:0"

	if(connected_port)
		overlays += "scrubber-connector"

	return


//Huge scrubber
/obj/machinery/portable_atmospherics/powered/scrubber/huge
	name = "Huge Air Scrubber"
	icon_state = "scrubber:0"
	anchored = 1

	chan
	use_power = 0

	var/global/gid = 1
	var/id = 0

/obj/machinery/portable_atmospherics/powered/scrubber/huge/New()
	..()
	cell = null

	id = gid
	gid++

	name = "[name] (ID [id])"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/attack_hand(var/mob/user as mob)
		to_chat(usr, SPAN_NOTICE(" You can't directly interact with this machine. Use the scrubber control console."))

/obj/machinery/portable_atmospherics/powered/scrubber/huge/update_icon()
	src.overlays = 0

	if(on && !(stat & (NOPOWER|BROKEN)))
		icon_state = "scrubber:1"
	else
		icon_state = "scrubber:0"



/obj/machinery/portable_atmospherics/powered/scrubber/huge/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/tool/wrench))
		if(on)
			to_chat(user, SPAN_NOTICE(" Turn it off first!"))
			return

		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
		to_chat(user, SPAN_NOTICE(" You [anchored ? "wrench" : "unwrench"] \the [src]."))

		return

	//doesn't use power cells
	if(istype(I, /obj/item/cell))
		return
	if (istype(I, /obj/item/tool/screwdriver))
		return

	//doesn't hold tanks
	if(istype(I, /obj/item/tank))
		return

	..()


/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary
	name = "Stationary Air Scrubber"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/tool/wrench))
		to_chat(user, SPAN_NOTICE(" The bolts are too tight for you to unscrew!"))
		return

	..()