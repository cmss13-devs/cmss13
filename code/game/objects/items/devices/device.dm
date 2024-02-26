
//electronic devices

/obj/item/device
	icon = 'icons/obj/items/devices.dmi'
	var/serial_number

/obj/item/device/Initialize(mapload, ...)
	. = ..()
	serial_number = "[rand(0,9)][pick(GLOB.alphabet_uppercase)][rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)][pick(GLOB.alphabet_uppercase)]"

/obj/item/device/get_examine_text(mob/user)
	. = ..()
	if(!isxeno(user) && (get_dist(user, src) < 2 || isobserver(user)) && serial_number)
		. += SPAN_INFO("The serial number is [serial_number].")
