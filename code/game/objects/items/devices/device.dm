
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
	if(!isXeno(user) && (get_dist(user, src) < 1 || isobserver(user)))
		to_chat(user, "<span class='information'>The serial number is [serial_number].</span>")
