/* Photography!
 * Contains:
 * Camera Film
 * Photo Albums
 * Broadcasting Camera
 */

/*
* film *
*******/
/obj/item/device/camera_film
	name = "film cartridge"
	icon = 'icons/obj/items/paper.dmi'
	desc = "A camera film cartridge. Insert it into a camera to reload it."
	icon_state = "film"
	item_state = "electropack"
	w_class = SIZE_TINY

/*
* photo album *
**************/
/obj/item/storage/photo_album
	name = "Photo album"
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "album"
	item_state = "briefcase"
	can_hold = list(/obj/item/photo,)
	storage_slots = 28

/obj/item/storage/photo_album/MouseDrop(obj/over_object as obj)

	if((istype(usr, /mob/living/carbon/human)))
		var/mob/M = usr
		if(!( istype(over_object, /atom/movable/screen) ))
			return ..()
		playsound(loc, "rustle", 15, 1, 6)
		if((!( M.is_mob_restrained() ) && !( M.stat ) && M.back == src))
			switch(over_object.name)
				if("r_hand")
					M.drop_inv_item_on_ground(src)
					M.put_in_r_hand(src)
				if("l_hand")
					M.drop_inv_item_on_ground(src)
					M.put_in_l_hand(src)
			add_fingerprint(usr)
			return
		if(over_object == usr && in_range(src, usr) || usr.contents.Find(src))
			if(usr.s_active)
				usr.s_active.storage_close(usr)
			show_to(usr)
			return
	return

/obj/item/device/camera/oldcamera
	name = "Old Camera"
	desc = "An old, slightly beat-up digital camera, with a cheap photo printer taped on. It's a nice shade of blue."
	icon_state = "oldcamera"
	pictures_left = 30

/obj/item/device/broadcasting
	name = "Broadcasting Camera"
	desc = "Actively document everything you see, from the mundanity of shipside to the brutal battlefields below."
	icon = 'icons/obj/items/tools.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/tools_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/tools_righthand.dmi',
	)
	icon_state = "broadcastingcamera"
	item_state = "broadcastingcamera"
	unacidable = TRUE
	explo_proof = TRUE
	w_class = SIZE_HUGE
	flags_item = NO_FLAGS
	flags_equip_slot = NO_FLAGS //cannot be equiped
	var/active = FALSE
	var/obj/structure/machinery/camera/correspondent/linked_cam

/obj/item/device/broadcasting/Initialize(mapload, ...)
	. = ..()
	linked_cam = new(loc, src)
	linked_cam.status = FALSE
	RegisterSignal(src, COMSIG_COMPONENT_ADDED, PROC_REF(handle_rename))

/obj/item/device/broadcasting/Destroy()
	clear_broadcast()
	return ..()

/obj/item/device/broadcasting/update_icon()
	if(active)
		item_state = "broadcastingcamera_w"
	else
		item_state = "broadcastingcamera"
	. = ..()


/obj/item/device/broadcasting/proc/turn_on(mob/user)
	active = TRUE
	flags_atom |= (USES_HEARING|USES_SEEING)
	handle_move()
	SEND_SIGNAL(src, COMSIG_BROADCAST_GO_LIVE)
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))
	to_chat(user, SPAN_NOTICE("[src] begins to buzz softly as you go live."))
	update_icon()

/obj/item/device/broadcasting/proc/turn_off(mob/user)
	active = FALSE
	flags_atom &= ~(USES_HEARING|USES_SEEING)
	linked_cam.status = FALSE
	UnregisterSignal(src, COMSIG_MOVABLE_MOVED)
	to_chat(user, SPAN_NOTICE("[src] goes silent as the broadcast stops."))
	update_icon()

/obj/item/device/broadcasting/proc/handle_move()
	if(!linked_cam || QDELETED(linked_cam))
		linked_cam = new(loc, src)
	else
		linked_cam.status = TRUE
		linked_cam.forceMove(loc)

/obj/item/device/broadcasting/dropped(mob/user)
	. = ..()
	linked_cam.view_range = 4

/obj/item/device/broadcasting/pickup(mob/user, silent)
	. = ..()
	linked_cam.view_range = 7

/obj/item/device/broadcasting/attack_self(mob/user)
	. = ..()
	if(active)
		turn_off(user)
	else
		turn_on(user)

/obj/item/device/broadcasting/attack_alien(mob/living/carbon/xenomorph/xeno)
	. = ..()
	if(!active)
		return
	xeno.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	xeno.visible_message(SPAN_DANGER("[xeno] [xeno.slashes_verb] [src]!"),
	SPAN_DANGER("We [xeno.slash_verb] [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	turn_off(xeno)
	return XENO_ATTACK_ACTION

/obj/item/device/broadcasting/proc/handle_rename(obj/item/camera, datum/component/label)
	SIGNAL_HANDLER
	if(!istype(label, /datum/component/label))
		return
	linked_cam.c_tag = get_broadcast_name()

/obj/item/device/broadcasting/proc/clear_broadcast()
	if(!QDELETED(linked_cam))
		QDEL_NULL(linked_cam)

/obj/item/device/broadcasting/proc/get_broadcast_name()
	var/datum/component/label/src_label_component = GetComponent(/datum/component/label)
	if(src_label_component)
		return src_label_component.label_name
	return "Broadcast [serial_number]"

/obj/item/device/broadcasting/hear_talk(mob/living/sourcemob, message, verb = "says", datum/language/language, italics = FALSE)
	SEND_SIGNAL(src, COMSIG_BROADCAST_HEAR_TALK, sourcemob, message, verb, language, italics, get_dist(sourcemob, src) < 3)

/obj/item/device/broadcasting/see_emote(mob/living/sourcemob, emote, audible = FALSE)
	SEND_SIGNAL(src, COMSIG_BROADCAST_SEE_EMOTE, sourcemob, emote, audible, get_dist(sourcemob, src) < 3 && audible)
