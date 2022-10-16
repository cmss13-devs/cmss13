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
	var/sensor_faction = FACTION_MARINE
	var/has_sensor = UNIFORM_HAS_SENSORS // For the crew computer
	var/sensor_mode = SENSOR_MODE_LOCATION
		/*
		1 = Report living/dead
		2 = Report detailed damages
		3 = Report location
		*/
	var/displays_id = TRUE
	///Stores whether sleeves can be rolled, cut etc. and whether they currently are.
	var/flags_jumpsuit = FALSE
	var/list/suit_restricted //for uniforms that only accept to be combined with certain suits
	var/removed_parts = 0
	var/worn_state = null
	drag_unequip = TRUE
	valid_accessory_slots = list(ACCESSORY_SLOT_UTILITY, ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_RANK, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_ARMOR_C)
	restricted_accessory_slots = list(ACCESSORY_SLOT_UTILITY, ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_RANK, ACCESSORY_SLOT_ARMOR_C)
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/uniform_monkey_0.dmi')
	equip_sounds = list('sound/handling/clothing_on.ogg')
	unequip_sounds = list('sound/handling/clothing_off.ogg')

/obj/item/clothing/under/Initialize()
	. = ..()
	if(worn_state)
		LAZYSET(item_state_slots, WEAR_BODY, worn_state)
	else
		worn_state = icon_state

	//autodetect rollability
	if((worn_state + "_d") in icon_states(default_onmob_icons[WEAR_BODY]))
		flags_jumpsuit |= UNIFORM_SLEEVE_ROLLABLE
	else if(flags_jumpsuit & UNIFORM_SLEEVE_ROLLABLE)
		flags_jumpsuit &= ~UNIFORM_SLEEVE_ROLLABLE
		log_debug("CLOTHING: Jumpsuit of name: \"[src.name]\" and type: \"[src.type]\" was flagged as having rollable sleeves but could not detect a rolled icon state.")

	if((worn_state + "_df") in icon_states(default_onmob_icons[WEAR_BODY]))
		flags_jumpsuit |= UNIFORM_SLEEVE_CUTTABLE
	else if(flags_jumpsuit & UNIFORM_SLEEVE_CUTTABLE)
		flags_jumpsuit &= ~UNIFORM_SLEEVE_CUTTABLE
		log_debug("CLOTHING: Jumpsuit of name: \"[src.name]\" and type: \"[src.type]\" was flagged as having cuttable sleeves but could not detect a cut icon state.")

	if((worn_state + "_dj") in icon_states(default_onmob_icons[WEAR_BODY]))
		flags_jumpsuit |= UNIFORM_JACKET_REMOVABLE
	else if(flags_jumpsuit & UNIFORM_JACKET_REMOVABLE)
		flags_jumpsuit &= ~UNIFORM_JACKET_REMOVABLE
		log_debug("CLOTHING: Jumpsuit of name: \"[src.name]\" and type: \"[src.type]\" was flagged as having a removable jacket but could not detect a shirtless icon state.")

	//autodetect preset states are valid
	if((flags_jumpsuit & UNIFORM_SLEEVE_ROLLED) && !(flags_jumpsuit & UNIFORM_SLEEVE_ROLLABLE))
		flags_jumpsuit &= ~UNIFORM_SLEEVE_ROLLED
		log_debug("CLOTHING: Jumpsuit of name: \"[src.name]\" and type: \"[src.type]\" was flagged as having rolled sleeves but could not detect a rolled icon state.")

	if((flags_jumpsuit & UNIFORM_SLEEVE_CUT) && !(flags_jumpsuit & UNIFORM_SLEEVE_CUTTABLE))
		flags_jumpsuit &= ~UNIFORM_SLEEVE_CUT
		log_debug("CLOTHING: Jumpsuit of name: \"[src.name]\" and type: \"[src.type]\" was flagged as having cut sleeves but could not detect a cut icon state.")

	if((flags_jumpsuit & UNIFORM_JACKET_REMOVED) && !(flags_jumpsuit & UNIFORM_JACKET_REMOVABLE))
		flags_jumpsuit &= ~UNIFORM_JACKET_REMOVED
		log_debug("CLOTHING: Jumpsuit of name: \"[src.name]\" and type: \"[src.type]\" was flagged as having a removed jacket but could not detect a shirtless icon state.")

	update_clothing_icon()

/obj/item/clothing/Destroy()
	QDEL_NULL_LIST(accessories)
	return..()

/obj/item/clothing/under/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	worn_state = icon_state
	LAZYSET(item_state_slots, WEAR_BODY, worn_state)

/obj/item/clothing/under/update_clothing_icon()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_w_uniform()

/obj/item/clothing/under/MouseDrop(obj/over_object as obj)
	if (ishuman(usr))
		//makes sure that the clothing is equipped so that we can't drag it into our hand from miles away.
		if ((flags_item & NODROP) || loc != usr)
			return

		if (!usr.is_mob_incapacitated() && !(usr.buckled && usr.lying))
			if(over_object)
				switch(over_object.name)
					if("r_hand")
						if(usr.drop_inv_item_on_ground(src))
							usr.put_in_r_hand(src)
					if("l_hand")
						if(usr.drop_inv_item_on_ground(src))
							usr.put_in_l_hand(src)
				add_fingerprint(usr)


/obj/item/clothing/under/get_examine_text(mob/user)
	. = ..()
	if(has_sensor)
		switch(sensor_mode)
			if(SENSOR_MODE_OFF)
				. += "Its sensors appear to be disabled."
			if(SENSOR_MODE_BINARY)
				. += "Its binary life sensors appear to be enabled."
			if(SENSOR_MODE_DAMAGE)
				. += "Its vital tracker appears to be enabled."
			if(SENSOR_MODE_LOCATION)
				. += "Its vital tracker and tracking beacon appear to be enabled."

/obj/item/clothing/under/proc/set_sensors(mob/user)
	if (istype(user, /mob/dead/)) return
	if (user.stat || user.is_mob_restrained()) return
	if(has_sensor >= UNIFORM_FORCED_SENSORS)
		to_chat(user, "The controls are locked.")
		return 0
	if(has_sensor <= UNIFORM_NO_SENSORS)
		to_chat(user, "This suit does not have any sensors.")
		return 0

	var/list/modes = list("Off", "Binary sensors", "Vitals tracker", "Tracking beacon")
	var/switchMode = tgui_input_list(usr, "Select a sensor mode:", "Suit Sensor Mode", modes)
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
			if(SENSOR_MODE_OFF)
				to_chat(user, "You disable your suit's remote sensing equipment.")
			if(SENSOR_MODE_BINARY)
				to_chat(user, "Your suit will now report whether you are live or dead.")
			if(SENSOR_MODE_DAMAGE)
				to_chat(user, "Your suit will now report your vital lifesigns.")
			if(SENSOR_MODE_LOCATION)
				to_chat(user, "Your suit will now report your vital lifesigns as well as your coordinate position.")
	else if (ismob(loc))
		switch(sensor_mode)
			if(SENSOR_MODE_OFF)
				for(var/mob/V in viewers(usr, 1))
					V.show_message(SPAN_DANGER("[user] disables [src.loc]'s remote sensing equipment."), 1)
			if(SENSOR_MODE_BINARY)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("[user] turns [src.loc]'s remote sensors to binary.", 1)
			if(SENSOR_MODE_DAMAGE)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("[user] sets [src.loc]'s sensors to track vitals.", 1)
			if(SENSOR_MODE_LOCATION)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("[user] sets [src.loc]'s sensors to maximum.", 1)

/obj/item/clothing/under/verb/toggle()
	set name = "Toggle Suit Sensors"
	set category = "Object"
	set src in usr
	set_sensors(usr)

/obj/item/clothing/under/proc/update_rollsuit_status()
	var/human_bodytype
	if(sprite_sheets && ishuman(loc))
		var/mob/living/carbon/human/H = loc
		human_bodytype = H.species.get_bodytype(H)

	var/icon/under_icon
	if(icon_override)
		under_icon = icon_override
	else if(human_bodytype && LAZYISIN(sprite_sheets, human_bodytype))
		under_icon = sprite_sheets[human_bodytype]
	else if(LAZYISIN(item_icons, WEAR_BODY))
		under_icon = item_icons[WEAR_BODY]
	else
		under_icon = default_onmob_icons[WEAR_BODY]
	if(!(("[worn_state]_d") in icon_states(under_icon)))
		flags_jumpsuit &= ~UNIFORM_SLEEVE_ROLLABLE

/obj/item/clothing/under/verb/rollsuit()
	set name = "Roll Sleeves"
	set category = "Object"
	set src in usr
	if(!isliving(usr))
		return
	if(usr.stat)
		return

	update_rollsuit_status()
	if(flags_jumpsuit & UNIFORM_SLEEVE_ROLLABLE)
		flags_jumpsuit ^= UNIFORM_SLEEVE_ROLLED
		if(flags_jumpsuit & UNIFORM_JACKET_REMOVED)
			to_chat(usr, SPAN_NOTICE("You roll the jacket's sleeves in your hands.")) //visual representation that the sleeves have been rolled while jacket has been removed.
		else if(flags_jumpsuit & UNIFORM_SLEEVE_ROLLED)
			LAZYSET(item_state_slots, WEAR_BODY, "[worn_state]_d")
			update_clothing_icon()
		else
			LAZYSET(item_state_slots, WEAR_BODY, worn_state)
			update_clothing_icon()

	else
		to_chat(usr, SPAN_WARNING("You cannot roll your sleeves!"))

/obj/item/clothing/under/proc/update_removejacket_status()
	var/human_bodytype
	if(sprite_sheets && ishuman(loc))
		var/mob/living/carbon/human/H = loc
		human_bodytype = H.species.get_bodytype(H)

	var/icon/under_icon
	if(icon_override)
		under_icon = icon_override
	else if(human_bodytype && LAZYISIN(sprite_sheets, human_bodytype))
		under_icon = sprite_sheets[human_bodytype]
	else if(LAZYISIN(item_icons, WEAR_BODY))
		under_icon = item_icons[WEAR_BODY]
	else
		under_icon = default_onmob_icons[WEAR_BODY]
	if(!(("[worn_state]_dj") in icon_states(under_icon)))
		flags_jumpsuit &= ~UNIFORM_JACKET_REMOVABLE

/obj/item/clothing/under/verb/removejacket()
	set name = "Toggle Jacket"
	set category = "Object"
	set src in usr
	if(!isliving(usr))
		return
	if(usr.stat)
		return

	update_removejacket_status()
	if(flags_jumpsuit & UNIFORM_JACKET_REMOVABLE)
		flags_jumpsuit ^= UNIFORM_JACKET_REMOVED
		if(flags_jumpsuit & UNIFORM_JACKET_REMOVED)
			LAZYSET(item_state_slots, WEAR_BODY, "[worn_state]_dj")
			if(ismob(loc))
				var/mob/M = loc
				M.update_inv_wear_id()
		else if(flags_jumpsuit & UNIFORM_SLEEVE_CUT)
			LAZYSET(item_state_slots, WEAR_BODY, "[worn_state]_df")
		else if(flags_jumpsuit & UNIFORM_SLEEVE_ROLLED)
			LAZYSET(item_state_slots, WEAR_BODY, "[worn_state]_d")
		else
			LAZYSET(item_state_slots, WEAR_BODY, worn_state)
		update_clothing_icon()
	else
		to_chat(usr, SPAN_WARNING("\The [src] doesn't have a removable jacket!"))

/obj/item/clothing/under/attackby(obj/item/B, mob/user)
	if(istype(B, /obj/item/attachable/bayonet) && (user.a_intent == INTENT_HARM))
		if(!(flags_jumpsuit & UNIFORM_SLEEVE_CUTTABLE))
			to_chat(user, SPAN_NOTICE("You can't cut up [src]."))
		else if(flags_jumpsuit & UNIFORM_JACKET_REMOVED)
			to_chat(user, SPAN_NOTICE("You can't dice up [src] while the jacket is removed."))
		else if(flags_jumpsuit & UNIFORM_SLEEVE_ROLLED)
			to_chat(user, SPAN_NOTICE("You can't dice up [src] while it's rolled."))
		else
			flags_jumpsuit &= ~(UNIFORM_SLEEVE_ROLLABLE|UNIFORM_SLEEVE_CUTTABLE)
			flags_jumpsuit |= UNIFORM_SLEEVE_CUT

			LAZYSET(item_state_slots, WEAR_BODY, "[worn_state]_df")
			user.visible_message("[user] slices [src] with [B].")
			update_clothing_icon()
			update_rollsuit_status()
			update_removejacket_status()

	else if(loc == user && istype(B, /obj/item/clothing/under) && src != B && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.w_uniform == src)
			H.drop_inv_item_on_ground(src)
			if(H.equip_to_appropriate_slot(B))
				H.put_in_active_hand(src)

	else
		..()
