/obj/structure/machinery/portable_atmospherics/powered/scrubber
	name = "Portable Air Scrubber"

	icon = 'icons/obj/structures/machinery/atmos.dmi'
	icon_state = "pscrubber:0"
	density = 1
	

	var/on = 0

/obj/structure/machinery/portable_atmospherics/powered/scrubber/New()
	..()
	cell = new/obj/item/cell(src)

/obj/structure/machinery/portable_atmospherics/powered/scrubber/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = SETUP_LIST_FLAGS(PASS_OVER, PASS_AROUND, PASS_UNDER)

/obj/structure/machinery/portable_atmospherics/powered/scrubber/emp_act(severity)
	if(inoperable())
		..(severity)
		return

	if(prob(50/severity))
		on = !on
		update_icon()

	..(severity)

/obj/structure/machinery/portable_atmospherics/powered/scrubber/update_icon()
	src.overlays = 0

	if(on && cell && cell.charge)
		icon_state = "pscrubber:1"
	else
		icon_state = "pscrubber:0"

	return


//Huge scrubber
/obj/structure/machinery/portable_atmospherics/powered/scrubber/huge
	name = "Huge Air Scrubber"
	icon_state = "scrubber:0"
	anchored = 1

	chan
	use_power = 0

	var/global/gid = 1
	var/id = 0

/obj/structure/machinery/portable_atmospherics/powered/scrubber/huge/New()
	..()
	cell = null

	id = gid
	gid++

	name = "[name] (ID [id])"

/obj/structure/machinery/portable_atmospherics/powered/scrubber/huge/attack_hand(var/mob/user as mob)
		to_chat(usr, SPAN_NOTICE(" You can't directly interact with this machine. Use the scrubber control console."))

/obj/structure/machinery/portable_atmospherics/powered/scrubber/huge/update_icon()
	src.overlays = 0

	if(on && !(inoperable()))
		icon_state = "scrubber:1"
	else
		icon_state = "scrubber:0"


/obj/structure/machinery/portable_atmospherics/powered/scrubber/huge/attackby(var/obj/item/I as obj, var/mob/user as mob)
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


/obj/structure/machinery/portable_atmospherics/powered/scrubber/huge/stationary
	name = "Stationary Air Scrubber"

/obj/structure/machinery/portable_atmospherics/powered/scrubber/huge/stationary/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/tool/wrench))
		to_chat(user, SPAN_NOTICE(" The bolts are too tight for you to unscrew!"))
		return

	..()