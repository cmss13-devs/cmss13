/obj/item/clothing/under
	icon = 'icons/obj/items/clothing/uniforms.dmi'
	name = "under"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	permeability_coefficient = 0.90
	flags_equip_slot = SLOT_ICLOTHING
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE
	w_class = SIZE_MEDIUM
	blood_overlay_type = "uniform"
	var/has_sensor = 1//For the crew computer 2 = unable to change mode
	var/sensor_mode = 3
		/*
		1 = Report living/dead
		2 = Report detailed damages
		3 = Report location
		*/
	var/displays_id = 1
	var/rollable_sleeves = FALSE //can we roll the sleeves on this uniform?
	var/rolled_sleeves = FALSE //are the sleeves currently rolled?
	var/list/suit_restricted //for uniforms that only accept to be combined with certain suits
	var/removed_parts = 0
	var/worn_state = null
	drag_unequip = TRUE
	valid_accessory_slots = list(ACCESSORY_SLOT_UTILITY, ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_RANK, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)
	restricted_accessory_slots = list(ACCESSORY_SLOT_UTILITY, ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_RANK)
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/uniform_monkey_0.dmi')
	equip_sounds = list('sound/handling/clothing_on.ogg')
	unequip_sounds = list('sound/handling/clothing_off.ogg')

/obj/item/clothing/under/New()
	if(worn_state)
		if(!item_state_slots)
			item_state_slots = list()
		item_state_slots[WEAR_BODY] = worn_state
	else
		worn_state = icon_state

	//autodetect rollability
	if((worn_state + "_d") in icon_states(default_onmob_icons[WEAR_BODY]))
		rollable_sleeves = TRUE
	..()

/obj/item/clothing/Dispose()
	if(accessories && accessories.len)
		for(var/obj/I in accessories)
			qdel(I)
	. = ..()

/obj/item/clothing/under/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	worn_state = icon_state
	item_state_slots[WEAR_BODY] = worn_state

/obj/item/clothing/under/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_w_uniform()

/obj/item/clothing/attackby(obj/item/I, mob/user)
	if(loc == user && istype(I,/obj/item/clothing/under) && src != I)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.w_uniform == src)
				H.drop_inv_item_on_ground(src)
				if(H.equip_to_appropriate_slot(I))
					H.put_in_active_hand(src)
	..()

/obj/item/clothing/under/MouseDrop(obj/over_object as obj)
	if (ishuman(usr))
		//makes sure that the clothing is equipped so that we can't drag it into our hand from miles away.
		if ((flags_item & NODROP) || loc != usr)
			return

		if (!usr.is_mob_incapacitated() && !(usr.buckled && usr.lying))
			if(over_object)
				switch(over_object.name)
					if("r_hand")
						usr.drop_inv_item_on_ground(src)
						usr.put_in_r_hand(src)
					if("l_hand")
						usr.drop_inv_item_on_ground(src)
						usr.put_in_l_hand(src)
				add_fingerprint(usr)


/obj/item/clothing/under/examine(mob/user)
	..()
	if(has_sensor)
		switch(sensor_mode)
			if(0)
				to_chat(user, "Its sensors appear to be disabled.")
			if(1)
				to_chat(user, "Its binary life sensors appear to be enabled.")
			if(2)
				to_chat(user, "Its vital tracker appears to be enabled.")
			if(3)
				to_chat(user, "Its vital tracker and tracking beacon appear to be enabled.")

/obj/item/clothing/under/proc/set_sensors(mob/user)
	if (istype(user, /mob/dead/)) return
	if (user.stat || user.is_mob_restrained()) return
	if(has_sensor >= 2)
		to_chat(user, "The controls are locked.")
		return 0
	if(has_sensor <= 0)
		to_chat(user, "This suit does not have any sensors.")
		return 0

	var/list/modes = list("Off", "Binary sensors", "Vitals tracker", "Tracking beacon")
	var/switchMode = input("Select a sensor mode:", "Suit Sensor Mode", modes[sensor_mode + 1]) in modes
	if(get_dist(user, src) > 1)
		to_chat(user, "You have moved too far away.")
		return
	sensor_mode = modes.Find(switchMode) - 1

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.w_uniform == src)
			H.update_suit_sensors()

	if (loc == user)
		switch(sensor_mode)
			if(0)
				to_chat(user, "You disable your suit's remote sensing equipment.")
			if(1)
				to_chat(user, "Your suit will now report whether you are live or dead.")
			if(2)
				to_chat(user, "Your suit will now report your vital lifesigns.")
			if(3)
				to_chat(user, "Your suit will now report your vital lifesigns as well as your coordinate position.")
	else if (ismob(loc))
		switch(sensor_mode)
			if(0)
				for(var/mob/V in viewers(usr, 1))
					V.show_message(SPAN_DANGER("[user] disables [src.loc]'s remote sensing equipment."), 1)
			if(1)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("[user] turns [src.loc]'s remote sensors to binary.", 1)
			if(2)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("[user] sets [src.loc]'s sensors to track vitals.", 1)
			if(3)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("[user] sets [src.loc]'s sensors to maximum.", 1)

/obj/item/clothing/under/verb/toggle()
	set name = "Toggle Suit Sensors"
	set category = "Object"
	set src in usr
	set_sensors(usr)

/obj/item/clothing/under/proc/update_rollsuit_status()
	var/mob/living/carbon/human/H
	if(ishuman(loc))
		H = loc

	var/icon/under_icon
	if(icon_override)
		under_icon = icon_override
	else if(H && sprite_sheets && sprite_sheets[H.species.get_bodytype(H)])
		under_icon = sprite_sheets[H.species.get_bodytype(H)]
	else if(item_icons && item_icons[WEAR_BODY])
		under_icon = item_icons[WEAR_BODY]
	else
		under_icon = default_onmob_icons[WEAR_BODY]
	if(("[worn_state]_d") in icon_states(under_icon))
		if(rolled_sleeves != TRUE)
			rolled_sleeves = FALSE
	else
		rollable_sleeves = FALSE
	if(H) update_clothing_icon()

/obj/item/clothing/under/verb/rollsuit()
	set name = "Roll Down Jumpsuit"
	set category = "Object"
	set src in usr
	if(!isliving(usr)) return
	if(usr.stat) return

	update_rollsuit_status()
	if(rollable_sleeves)
		rolled_sleeves = !rolled_sleeves
		if(rolled_sleeves)
			item_state_slots[WEAR_BODY] = "[worn_state]_d"
		else
			item_state_slots[WEAR_BODY] = "[worn_state]"

		update_clothing_icon()
	else to_chat(usr, SPAN_WARNING("You cannot roll down the uniform!"))
