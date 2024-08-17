/*
 * Absorbs /obj/item/secstorage.
 * Reimplements it only slightly to use existing storage functionality.
 *
 * Contains:
 * Secure Briefcase
 * Wall Safe
 */

// -----------------------------
//  Generic Item
// -----------------------------
/obj/item/storage/secure
	name = "secstorage"
	var/icon_locking = "secureb"
	var/icon_sparking = "securespark"
	var/icon_opened = "secure0"
	var/locked = 1
	var/code = ""
	var/l_code = null
	var/l_set = 0
	var/l_setshort = 0
	var/l_hacking = 0
	var/open = 0
	w_class = SIZE_MEDIUM
	max_w_class = SIZE_SMALL
	max_storage_space = 14
	storage_flags = STORAGE_FLAGS_DEFAULT^STORAGE_ALLOW_EMPTY

/obj/item/storage/secure/get_examine_text(mob/user)
	. = ..()
	. += "The service panel is [src.open ? "open" : "closed"]."

/obj/item/storage/secure/attackby(obj/item/W as obj, mob/user as mob)
	if(locked)
		if (HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
			if (do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				open =! open
				var/msg_open_status = "[open ? "open" : "close"]"
				user.show_message(SPAN_NOTICE("You [msg_open_status ] the service panel."), SHOW_MESSAGE_VISIBLE)
			return
		if (HAS_TRAIT(W, TRAIT_TOOL_MULTITOOL) && open == 1 && !l_hacking)
			user.show_message(text(SPAN_DANGER("Now attempting to reset internal memory, please hold.")), SHOW_MESSAGE_VISIBLE)
			l_hacking = 1
			if (do_after(usr, 100, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				if (prob(40))
					l_setshort = 1
					l_set = 0
					user.show_message(text(SPAN_DANGER("Internal memory reset.  Please give it a few seconds to reinitialize.")), SHOW_MESSAGE_VISIBLE)
					sleep(80)
					l_setshort = 0
					l_hacking = 0
				else
					user.show_message(text(SPAN_DANGER("Unable to reset internal memory.")), SHOW_MESSAGE_VISIBLE)
					l_hacking = 0
			else l_hacking = 0
			return
		//At this point you have exhausted all the special things to do when locked
		// ... but it's still locked.
		return

	// -> storage/attackby() what with handle insertion, etc
	..()


/obj/item/storage/secure/MouseDrop(over_object, src_location, over_location)
	if (locked)
		add_fingerprint(usr)
		return
	..()


/obj/item/storage/secure/attack_self(mob/user)
	..()
	user.set_interaction(src)
	var/dat = text("<TT><B>[]</B><BR>\n\nLock Status: []",src, (locked ? "LOCKED" : "UNLOCKED"))
	var/message = "Code"
	if ((l_set == 0) && (!l_setshort))
		dat += text("<p>\n<b>5-DIGIT PASSCODE NOT SET.<br>ENTER NEW PASSCODE.</b>")
	if (l_setshort)
		dat += text("<p>\n<font color=red><b>ALERT: MEMORY SYSTEM ERROR - 6040 201</b></font>")
	message = text("[]", code)
	if (!locked)
		message = "*****"
	dat += text("<HR>\n>[]<BR>\n<A href='?src=\ref[];type=1'>1</A>-<A href='?src=\ref[];type=2'>2</A>-<A href='?src=\ref[];type=3'>3</A><BR>\n<A href='?src=\ref[];type=4'>4</A>-<A href='?src=\ref[];type=5'>5</A>-<A href='?src=\ref[];type=6'>6</A><BR>\n<A href='?src=\ref[];type=7'>7</A>-<A href='?src=\ref[];type=8'>8</A>-<A href='?src=\ref[];type=9'>9</A><BR>\n<A href='?src=\ref[];type=R'>R</A>-<A href='?src=\ref[];type=0'>0</A>-<A href='?src=\ref[];type=E'>E</A><BR>\n</TT>", message, src, src, src, src, src, src, src, src, src, src, src, src)
	user << browse(dat, "window=caselock;size=300x280")

/obj/item/storage/secure/Topic(href, href_list)
	..()
	if ((usr.stat || usr.is_mob_restrained()) || (get_dist(src, usr) > 1))
		return
	if (href_list["type"])
		if (href_list["type"] == "E")
			if ((l_set == 0) && (length(code) == 5) && (!l_setshort) && (code != "ERROR"))
				l_code = code
				l_set = 1
			else if ((code == l_code) && (l_set == 1))
				locked = 0
				overlays = null
				overlays += image('icons/obj/items/storage/briefcases.dmi', icon_opened)
				code = null
			else
				code = "ERROR"
		else
			if ((href_list["type"] == "R") && (!l_setshort))
				locked = 1
				overlays = null
				code = null
				storage_close(usr)
			else
				code += text("[]", href_list["type"])
				if (length(code) > 5)
					code = "ERROR"
		add_fingerprint(usr)
		for(var/mob/M as anything in viewers(1, loc))
			if ((M.client && M.interactee == src))
				attack_self(M)
			return
	return

// -----------------------------
// Secure Briefcase
// -----------------------------
/obj/item/storage/secure/briefcase
	name = "secure briefcase"
	icon = 'icons/obj/items/storage/briefcases.dmi'
	icon_state = "secure"
	item_state = "sec-case"
	desc = "A large briefcase with a digital locking system."
	force = 8
	throw_speed = SPEED_FAST
	throw_range = 4
	w_class = SIZE_LARGE


/obj/item/storage/secure/briefcase/fill_preset_inventory()
	new /obj/item/paper(src)
	new /obj/item/tool/pen(src)

/obj/item/storage/secure/briefcase/attack_hand(mob/user as mob)
	if (loc == user)
		if (locked)
			to_chat(usr, SPAN_DANGER("[src] is locked and cannot be opened!"))
		else
			open(usr)
	else
		..()
		for(var/mob/M in content_watchers)
			storage_close(M)
	add_fingerprint(user)

// -----------------------------
// Secure Safe
// -----------------------------

/obj/item/storage/secure/safe
	name = "secure safe"
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "wallsafe"
	icon_opened = "safe0"
	icon_locking = "safeb"
	icon_sparking = "safespark"
	flags_atom = FPRINT|CONDUCT
	force = 8
	w_class = SIZE_LARGE
	max_w_class = SIZE_LARGE
	anchored = TRUE
	density = FALSE
	cant_hold = list(/obj/item/storage/secure/briefcase)

/obj/item/storage/secure/safe/fill_preset_inventory()
	new /obj/item/paper(src)
	new /obj/item/tool/pen(src)

/obj/item/storage/secure/safe/attack_hand(mob/user as mob)
	return attack_self(user)

/obj/item/storage/secure/safe/HoS/Initialize()
	. = ..()
