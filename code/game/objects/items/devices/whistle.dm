/obj/item/clothing/accessory/device/whistle
	name = "\improper whistle"
	desc = "A metal pea-whistle. Can be blown while held, or worn in the mouth. It can also be worn as an accessory."
	icon_state = "whistle_generic"
	icon = 'icons/obj/items/tools.dmi'
	w_class = SIZE_TINY
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_FACE
	actions_types = list(/datum/action/item_action/toggle/use/whistle)
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/masks/objects.dmi'
	)
	worn_accessory_slot = ACCESSORY_SLOT_UTILITY
	high_visibility = TRUE
	accessory_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/accessory/misc.dmi',
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/accessory/misc.dmi'
	)
	inv_overlay_icon = 'icons/obj/items/clothing/accessory/inventory_overlays/misc.dmi'
	var/whistle_sound = 'sound/items/whistles/whistle.ogg'
	var/volume = 60
	var/spam_cooldown_time = 5 SECONDS
	var/leader_whistle = FALSE
	COOLDOWN_DECLARE(spam_cooldown)

/obj/item/clothing/accessory/device/whistle/ui_action_click(mob/user, action)
	if(has_suit && has_suit.loc == user)
		attack_self(user)
		return
	return ..()

/obj/item/clothing/accessory/device/whistle/attack_self(mob/user)
	..()
	whistle_playsound(user)
	add_fingerprint(user)

/obj/item/clothing/accessory/device/whistle/attackby(obj/item/W, mob/user)
	if(user.wear_mask == src)
		whistle_playsound(user)
	else
		..()

/obj/item/clothing/accessory/device/whistle/attack_hand(mob/user)
	if(user.wear_mask == src)
		whistle_playsound(user)
	else
		..()

/obj/item/clothing/accessory/device/whistle/proc/whistle_playsound(mob/user, bypass_cooldown = FALSE, custom_sound, leader_slowdown = FALSE)
	if(!COOLDOWN_FINISHED(src, spam_cooldown) && !bypass_cooldown)
		to_chat(user, SPAN_DANGER("You are out of breath after using [src]! Wait [COOLDOWN_SECONDSLEFT(src, spam_cooldown)] second\s."))
		return

	if(leader_slowdown)
		user.visible_message(SPAN_WARNING("[user] rouses everyone around as they blow [src]!"), SPAN_WARNING("You rouse everyone around you as you blow into [src], slowing yourself down as you do!"))
		user.set_effect(3, SLOW) // 3 ticks, yes
	else
		user.visible_message(SPAN_WARNING("[user] blows into [src]!"))
	playsound(get_turf(src), custom_sound ? custom_sound : whistle_sound, volume, 1, vary = 0)

	COOLDOWN_START(src, spam_cooldown, spam_cooldown_time)

/obj/item/clothing/accessory/device/whistle/MouseDrop(obj/over_object)
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

/obj/item/clothing/accessory/device/whistle/trench
	name = "trench whistle"
	desc = "A metallic field whistle, popularized back in the early 20th century. Can be blown while held, or worn in the mouth. It can also be worn as an accessory."
	desc_lore = "While these trench whistles had fallen out of fashion in favor for the smaller and ligher pea whistles, they are still favored by certain military leaders for their authoritative and distinct sound. It had regained its popularity in recent years during the various campaigns held against the UPP at the tail-end of the Dog War on the year 2162, where such whistles were used to coordinate squad movements and issue audible orders on the battlefield by both sides while under constant, heavy fire. During which most engagements were fielded out in the open, and long-range radio communications relied through vulnerable radio-men, whose equipment had faults within the aging technology most typically due to hostile jamming of the communications network among other issues, which further reinforced the necessity of these whistles."
	icon_state = "trench_whistle"
	icon = 'icons/obj/items/tools.dmi'
	whistle_sound = 'sound/items/whistles/trench_whistle.ogg'
	leader_whistle = TRUE

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
