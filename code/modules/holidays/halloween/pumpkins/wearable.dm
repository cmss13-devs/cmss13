/// Carved Pumpkin from the Halloween event
/obj/item/clothing/head/pumpkin
	name = "pumpkin"
	icon = 'icons/misc/events/pumpkins.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/misc/events/pumpkins.dmi',
	)
	desc = "An ominous looking pumpkin. Would look pretty spooky if worn on your head..."
	w_class = SIZE_MEDIUM
	flags_inv_hide = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEALLHAIR
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_EYES
	flags_inventory = COVEREYES|BLOCKSHARPOBJ|COVERMOUTH
	flags_cold_protection = BODY_FLAG_HEAD
	flags_heat_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROT
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROT
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	health = 5
	force = 15
	var/prefix = "" //! Icon state prefix for corrupted pumpkin variants
	var/carved_icon = "" //! Currently carved pumpkin overlay
	var/carvable_icons = list("smile", "cheeky", "bugeyes", "upside_down_smile", "skelly", "ff")

/obj/item/clothing/head/pumpkin/Initialize(mapload, ...)
	. = ..()
	update_icon()

/obj/item/clothing/head/pumpkin/update_icon()
	. = ..()
	if(carved_icon)
		icon_state = "[prefix]pumpkin_carved"
	else
		icon_state = "[prefix]pumpkin"
	item_state_slots = list(
		WEAR_HEAD = "[prefix]pumpkin_onmob",
	)

/obj/item/clothing/head/pumpkin/mob_can_equip(mob/user, slot, disable_warning)
	if(slot == WEAR_HEAD && !carved_icon)
		to_chat(user, SPAN_WARNING("You can't put on a full pumpkin! Empty and carve it with a sharp object first."))
		return FALSE
	. = ..()

/obj/item/clothing/head/pumpkin/attackby(obj/item/tool, mob/user)
	if(!carved_icon && (tool.sharp == IS_SHARP_ITEM_ACCURATE || tool.sharp == IS_SHARP_ITEM_BIG))
		var/choice = tgui_input_list(user, "Select the pattern to carve on your pumpkin!", "Pumpkin Carving", carvable_icons)
		if(choice)
			playsound(loc, 'sound/effects/vegetation_hit.ogg', 25, 1)
			carved_icon = choice
			name = "carved pumpkin"
			update_icon()
	else
		return ..()

/obj/item/clothing/head/pumpkin/get_mob_overlay(mob/user_mob, slot, default_bodytype = "Default")
	var/image/pumpkin = ..()
	if(carved_icon && slot == WEAR_HEAD)
		var/image/overlay = overlay_image(icon, "[prefix]pumpkin_[carved_icon]")
		pumpkin.overlays += overlay
	return pumpkin

/obj/item/clothing/head/pumpkin/corrupted
	name = "corrupted pumpkin"
	prefix = "cor_"
	carvable_icons = list("cry", "sob", "sad", "why", "spooky", "ff")
