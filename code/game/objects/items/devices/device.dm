
//electronic devices

/obj/item/device
	icon = 'icons/obj/items/devices.dmi'
	var/serial_number

/obj/item/device/New()
	..()
	var/list/letters = list("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","X","Y","Z") // please find a better way to do this
	serial_number = "[rand(0,9)][pick(letters)][rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)][pick(letters)]"

/obj/item/device/examine(mob/user)
	..()
	if(!isXeno(user) && (get_dist(user, src) < 2 || isobserver(user)) && serial_number)
		to_chat(user, SPAN_INFO("The serial number is [serial_number]."))
