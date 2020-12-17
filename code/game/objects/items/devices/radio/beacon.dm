/obj/item/device/radio/beacon
	name = "Tracking Beacon"
	desc = "A beacon used by a teleporter."
	icon_state = "beacon"
	item_state = "signaller"
	var/code = "electronic"

/obj/item/device/radio/beacon/Initialize()
	. = ..()
	GLOB.radio_beacon_list += src

/obj/item/device/radio/beacon/Destroy()
	GLOB.radio_beacon_list -= src
	return ..()

/obj/item/device/radio/beacon/hear_talk()
	return


/obj/item/device/radio/beacon/send_hear()
	return null


/obj/item/device/radio/beacon/verb/alter_signal(t as text)
	set name = "Alter Beacon's Signal"
	set category = "Object"
	set src in usr

	if ((usr.canmove && !( usr.is_mob_restrained() )))
		src.code = t
	if (!( src.code ))
		src.code = "beacon"
	src.add_fingerprint(usr)
	return


/obj/item/device/radio/beacon/bacon //Probably a better way of doing this, I'm lazy.
	proc/digest_delay()
		spawn(MINUTES_1)
			qdel(src)
