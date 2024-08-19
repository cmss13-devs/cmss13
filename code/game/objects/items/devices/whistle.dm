/obj/item/device/whistle
	name = "\improper whistle"
	desc = "A metal pea-whistle. Can be blown while held, or worn in the mouth"
	icon_state = "whistle"
	w_class = SIZE_TINY
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_FACE
	actions_types = list(/datum/action/item_action/toggle/use)

	var/volume = 60
	var/spam_cooldown_time = 10 SECONDS
	COOLDOWN_DECLARE(spam_cooldown)

/obj/item/device/whistle/attack_self(mob/user)
	..()
	whistle_playsound(user)
	add_fingerprint(user)

/obj/item/device/whistle/attackby(obj/item/W, mob/user)
	if(user.wear_mask == src)
		whistle_playsound(user)
	else
		..()

/obj/item/device/whistle/attack_hand(mob/user)
	if(user.wear_mask == src)
		whistle_playsound(user)
	else
		..()

/obj/item/device/whistle/proc/whistle_playsound(mob/user)
	if(!COOLDOWN_FINISHED(src, spam_cooldown))
		to_chat(user, SPAN_DANGER("You are out of breath after using [src]! Wait [COOLDOWN_SECONDSLEFT(src, spam_cooldown)] second\s."))
		return

	user.visible_message(SPAN_WARNING("[user] blows into [src]!"))
	playsound(get_turf(src), 'sound/items/whistle.ogg', volume, 1, vary = 0)

	COOLDOWN_START(src, spam_cooldown, spam_cooldown_time)

/obj/item/device/whistle/MouseDrop(obj/over_object)
	if(ishuman(usr))

		if(!usr.is_mob_restrained() && !usr.stat && usr.wear_mask == src)
			switch(over_object.name)
				if("r_hand")
					if(usr.drop_inv_item_on_ground(src))
						usr.put_in_r_hand(src)
				if("l_hand")
					if(usr.drop_inv_item_on_ground(src))
						usr.put_in_l_hand(src)
			add_fingerprint(usr)

/obj/item/device/hailer
	name = "hailer"
	desc = "Used by obese officers to save their breath for running."
	icon_state = "voice0"
	item_state = "flash_device" //looks exactly like a flash (and nothing like a flashbang)
	w_class = SIZE_TINY
	flags_atom = FPRINT|CONDUCT

	var/spamcheck = 0
	var/insults = 0//just in case

/obj/item/device/hailer/attack_self(mob/living/carbon/user)
	..()

	if (spamcheck)
		return

	playsound(get_turf(src), 'sound/voice/halt.ogg', 25, 1, vary = 0)
	user.show_message(SPAN_WARNING("[user]'s [name] rasps, \"Halt! Security!\""), SHOW_MESSAGE_AUDIBLE)

	spamcheck = 1
	addtimer(VARSET_CALLBACK(src, spamcheck, FALSE), 2 SECONDS)
