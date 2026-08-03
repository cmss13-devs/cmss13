/obj/item/device/radio/beacon
	name = "Tracking Beacon"
	desc = "A beacon used by a teleporter."
	icon_state = "beacon"
	item_state = "signaller"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/devices_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/devices_righthand.dmi',
	)
	var/code = "electronic"

/obj/item/device/radio/beacon/Initialize()
	. = ..()
	GLOB.radio_beacon_list += src
	flags_atom &= ~USES_HEARING // This subtype apparenlty does not want to hear stuff

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

	if (usr.is_mob_incapacitated())
		src.code = t
	if (!( src.code ))
		src.code = "beacon"
	src.add_fingerprint(usr)
	return

//Probably a better way of doing this, I'm lazy.
/obj/item/device/radio/beacon/bacon/proc/digest_delay()
	QDEL_IN(src, 1 MINUTES)
