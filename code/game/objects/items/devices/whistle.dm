/obj/item/device/whistle
	name = "\improper whistle"
	desc = "A metal pea-whistle. Can be blown while held, or worn in the mouth"
	icon_state = "whistle"
	w_class = SIZE_TINY
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_FACE
	actions_types = list(/datum/action/item_action)

	var/volume = 60
	var/spamcheck = 0

/obj/item/device/whistle/attack_self(mob/user as mob)
	whistle_playsound(user)
	add_fingerprint(user)
	return

/obj/item/device/whistle/attackby(obj/item/W as obj, mob/user as mob)
	if(user.wear_mask == src)
		whistle_playsound(user)
	else
		..()

/obj/item/device/whistle/attack_hand(mob/user)
	if(user.wear_mask == src)
		whistle_playsound(user)
	else
		..()

/obj/item/device/whistle/proc/whistle_playsound(mob/user as mob)
	if (spamcheck)
		return

	user.visible_message(SPAN_WARNING("[user] blows into [src]!"))
	playsound(get_turf(src), 'sound/items/whistle.ogg', volume, 1, vary = 0)

	spamcheck = 1
	addtimer(VARSET_CALLBACK(src, spamcheck, FALSE), 3 SECONDS)

/obj/item/device/whistle/MouseDrop(obj/over_object as obj)
	if(ishuman(usr) || isrobot(usr))

		if(!usr.is_mob_restrained() && !usr.stat && usr.wear_mask == src)
			switch(over_object.name)
				if("r_hand")
					usr.drop_inv_item_on_ground(src)
					usr.put_in_r_hand(src)
				if("l_hand")
					usr.drop_inv_item_on_ground(src)
					usr.put_in_l_hand(src)
			add_fingerprint(usr)


/obj/item/device/hailer
	name = "hailer"
	desc = "Used by obese officers to save their breath for running."
	icon_state = "voice0"
	item_state = "flash_device"	//looks exactly like a flash (and nothing like a flashbang)
	w_class = SIZE_TINY
	flags_atom = FPRINT|CONDUCT

	var/spamcheck = 0
	var/insults = 0//just in case

/obj/item/device/hailer/attack_self(mob/living/carbon/user as mob)
	if (spamcheck)
		return

	playsound(get_turf(src), 'sound/voice/halt.ogg', 25, 1, vary = 0)
	user.show_message(SPAN_WARNING("[user]'s [name] rasps, \"Halt! Security!\""),1)

	spamcheck = 1
	addtimer(VARSET_CALLBACK(src, spamcheck, FALSE), 2 SECONDS)
