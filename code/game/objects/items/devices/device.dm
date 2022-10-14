
//electronic devices

/obj/item/device
	icon = 'icons/obj/items/devices.dmi'
	var/serial_number

/obj/item/device/Initialize()
	. = ..()
	serial_number = "[rand(0,9)][pick(alphabet_uppercase)][rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)][pick(alphabet_uppercase)]"

/obj/item/device/examine(mob/user)
	..()
	if(!isXeno(user) && (get_dist(user, src) < 2 || isobserver(user)) && serial_number)
		to_chat(user, SPAN_INFO("The serial number is [serial_number]."))
