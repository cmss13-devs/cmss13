/obj/item/clothing/proc/can_attach_accessory(obj/item/clothing/accessory/A)
	if(valid_accessory_slots && istype(A) && (A.slot in valid_accessory_slots))
		.=1
	else
		return 0
	if(LAZYLEN(accessories) && restricted_accessory_slots && (A.slot in restricted_accessory_slots))
		for(var/obj/item/clothing/accessory/AC in accessories)
			if (AC.slot == A.slot)
				return 0

/obj/item/clothing/accessory/proc/get_inv_overlay()
	if(!inv_overlay)
		var/tmp_icon_state = overlay_state? overlay_state : icon_state
		if(icon_override && ("[tmp_icon_state]_tie" in icon_states(icon_override)))
			inv_overlay = image(icon = icon_override, icon_state = "[tmp_icon_state]_tie", dir = SOUTH)
		else if("[tmp_icon_state]_tie" in icon_states(default_onmob_icons[WEAR_ACCESSORY]))
			inv_overlay = image(icon = default_onmob_icons[WEAR_ACCESSORY], icon_state = "[tmp_icon_state]_tie", dir = SOUTH)
		else
			inv_overlay = image(icon = default_onmob_icons[WEAR_ACCESSORY], icon_state = tmp_icon_state, dir = SOUTH)
	inv_overlay.color = color
	return inv_overlay

/obj/item/clothing/accessory/get_mob_overlay(mob/user_mob, slot)
	if(!istype(loc,/obj/item/clothing))	//don't need special handling if it's worn as normal item.
		return ..()
	var/bodytype = "Default"
	if(ishuman(user_mob))
		var/mob/living/carbon/human/user_human = user_mob
		var/user_bodytype = user_human.species.get_bodytype(user_human)
		if(LAZYISIN(sprite_sheets, user_bodytype))
			bodytype = user_bodytype

		var/tmp_icon_state = overlay_state? overlay_state : icon_state

		if(istype(loc,/obj/item/clothing/under))
			var/obj/item/clothing/under/C = loc
			if(C.flags_jumpsuit & jumpsuit_hide_states && !(C.flags_jumpsuit & UNIFORM_DO_NOT_HIDE_ACCESSORIES))
				return

		var/use_sprite_sheet = accessory_icons[slot]
		var/sprite_sheet_bodytype = LAZYACCESS(sprite_sheets, bodytype)
		if(sprite_sheet_bodytype)
			use_sprite_sheet = sprite_sheet_bodytype

		if(icon_override && ("[tmp_icon_state]_mob" in icon_states(icon_override)))
			return overlay_image(icon_override, "[tmp_icon_state]_mob", color, RESET_COLOR)
		else
			return overlay_image(use_sprite_sheet, tmp_icon_state, color, RESET_COLOR)

/obj/item/clothing/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/clothing/accessory))

		if(!valid_accessory_slots || !valid_accessory_slots.len)
			to_chat(usr, SPAN_WARNING("You cannot attach accessories of any kind to \the [src]."))
			return

		var/obj/item/clothing/accessory/A = I
		if(can_attach_accessory(A))
			if(!user.drop_held_item())
				return
			attach_accessory(user, A)
			return TRUE //For some suit/storage items which both allow attaching accessories and also have their own internal storage.
		else
			to_chat(user, SPAN_WARNING("You cannot attach more accessories of this type to [src]."))
		return

	if(LAZYLEN(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			A.attackby(I, user)
		return

	..()

/obj/item/clothing/attack_hand(var/mob/user, mods)
	//only forward to the attached accessory if the clothing is equipped (not in a storage)
	if(LAZYLEN(accessories) && src.loc == user)
		var/delegated //So that accessories don't block attack_hands unless they actually did something. Specifically meant for armour vests with medals, but can't hurt in general.
		for(var/obj/item/clothing/accessory/A in accessories)
			if(A.attack_hand(user, mods))
				delegated = TRUE
		if(delegated)
			return
	return ..()


/obj/item/clothing/clicked(var/mob/user, var/list/mods)
	if(mods["alt"] && loc == user && !user.get_active_hand()) //To pass quick-draw attempts to storage. See storage.dm for explanation.
		for(var/V in verbs)
			if(V == /obj/item/clothing/suit/storage/verb/toggle_draw_mode) //So that alt-clicks are only intercepted for clothing items with internal storage and toggleable draw modes.
				return
	. = ..()


/obj/item/clothing/get_examine_text(var/mob/user)
	. = ..()
	for(var/obj/item/clothing/accessory/A in accessories)
		. += "[icon2html(A, user)] \A [A] is attached to it[A.additional_examine_text()]" //The spacing of the examine text proc is deliberate. By default it returns ".".

/**
 *  Attach accessory A to src
 *
 *  user is the user doing the attaching. Can be null, such as when attaching
 *  items on spawn
 */
/obj/item/clothing/proc/attach_accessory(mob/user, obj/item/clothing/accessory/A, var/silent)
	if(!A.can_attach_to(user, src))
		return

	LAZYADD(accessories, A)
	A.on_attached(src, user, silent)
	if(A.removable)
		verbs += /obj/item/clothing/proc/removetie_verb
	update_clothing_icon()

/obj/item/clothing/proc/remove_accessory(mob/user, obj/item/clothing/accessory/A)
	if(!LAZYISIN(accessories, A))
		return

	A.on_removed(user, src)
	LAZYREMOVE(accessories, A)
	update_clothing_icon()

/obj/item/clothing/proc/removetie_verb()
	set name = "Remove Accessory"
	set category = "Object"
	set src in usr
	if(!isliving(usr))
		return
	if(usr.stat)
		return
	if(!LAZYLEN(accessories))
		return
	var/obj/item/clothing/accessory/A
	var/list/removables = list()
	for(var/obj/item/clothing/accessory/ass in accessories)
		if(ass.removable)
			removables |= ass
	if(LAZYLEN(accessories) > 1)
		A = tgui_input_list(usr, "Select an accessory to remove from [src]", "Remove accessory", removables)
	else
		A = LAZYACCESS(accessories, 1)
	if(!usr.Adjacent(src))
		to_chat(usr, SPAN_WARNING("You're too far away!"))
		return
	src.remove_accessory(usr,A)
	removables -= A
	if(!removables.len)
		verbs -= /obj/item/clothing/proc/removetie_verb

/obj/item/clothing/emp_act(severity)
	if(LAZYLEN(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			A.emp_act(severity)
	..()
