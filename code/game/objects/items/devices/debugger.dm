/**
 * Multitool -- A multitool is used for hacking electronic devices.
 * TO-DO -- Using it as a power measurement tool for cables etc. Nannek.
 *
 */

/obj/item/device/debugger
	name = "debugger"
	desc = "Used to debug electronic equipment."
	icon_state = "hacktool-g"
	flags_atom = FPRINT|CONDUCT
	force = 5.0
	w_class = SIZE_SMALL
	throwforce = 5.0
	throw_range = 15
	throw_speed = SPEED_VERY_FAST
	desc = "You can use this on airlocks or APCs to try to hack them without cutting wires."

	matter = list("metal" = 50,"glass" = 20)


	var/obj/structure/machinery/telecomms/buffer // simple machine buffer for device linkage

/obj/item/device/debugger/is_used_on(obj/O, mob/user)
	if(istype(O, /obj/structure/machinery/power/apc))
		to_chat(user, SPAN_NOTICE(" The device's software appears to be fine."))
		return 1
	if(istype(O, /obj/structure/machinery/door))
		var/obj/structure/machinery/door/D = O
		if(D.operating == -1)
			to_chat(user, SPAN_DANGER("There is a software error with the device."))
		else
			to_chat(user, SPAN_NOTICE(" The device's software appears to be fine."))
		return 1
	else if(istype(O, /obj/structure/machinery))
		to_chat(user, SPAN_NOTICE(" The device's software appears to be fine."))
		return 1
