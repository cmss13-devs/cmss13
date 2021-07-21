/obj/structure/transmitter/internal
	name = "\improper internal telephone receiver"

	phone_type = /obj/item/phone

	var/atom/relay_obj

/obj/structure/transmitter/internal/ui_host(mob/user, datum/tgui/ui)
	if(!relay_obj)
		return ..()
	return relay_obj

/obj/structure/transmitter/internal/Destroy()
	relay_obj = null
	return ..()
