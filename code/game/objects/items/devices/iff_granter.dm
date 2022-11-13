// A device that you can insert an ID into and grant IFF for a faction specified on the device

/obj/item/device/iff_granter
	name = "\improper IFF granter"
	desc = "A device with an ID card slot on it, for granting or removing IFF from an ID."
	icon_state = "wyideditor" // Nothing else uses this except the W-Y IFF granter for now
	req_access = list(ACCESS_MARINE_COMMANDER)
	/// What faction IFF list to add/remove
	var/list/iff_faction = FACTION_LIST_MARINE
	/// What the IFF is called
	var/iff_name = "marine"
	/// Ref to the inserted ID
	var/obj/item/card/id/inserted_id


/obj/item/device/iff_granter/Destroy()
	if(inserted_id)
		QDEL_NULL(inserted_id)
	return ..()


/obj/item/device/iff_granter/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/id))
		inserted_id = W
		user.drop_inv_item_on_ground(W)
		W.forceMove(src)
		to_chat(user, SPAN_NOTICE("You insert [W] into [src]."))
		playsound(src, 'sound/machines/terminal_insert_disc.ogg', 25, FALSE)

	else
		return ..()


/obj/item/device/iff_granter/attack_self(mob/user)
	. = ..()
	if(!inserted_id)
		to_chat(user, SPAN_NOTICE("There needs to be an inserted ID card to use this!"))
		return

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/human_user = user

	if(!check_access(human_user.wear_id))
		to_chat(user, SPAN_WARNING("The screen shows an error about \"INSUFFICIENT ACCESS\"."))
		return

	var/removing = TRUE
	for(var/faction in iff_faction) // We prioritize adding over removing
		if(!(faction in inserted_id.faction_group))
			removing = FALSE
			break

	to_chat(user, SPAN_NOTICE("You begin [removing ? "removing" : "adding"] [iff_name] IFF [removing ? "from" : "to"] [inserted_id]..."))

	if(!do_after(user, 5 SECONDS, INTERRUPT_ALL, removing ? BUSY_ICON_HOSTILE :BUSY_ICON_FRIENDLY))
		to_chat(user, SPAN_WARNING("You need to stand still to finish!"))
		return

	to_chat(user, SPAN_NOTICE("You finish [removing ? "removing" : "adding"] [iff_name] IFF [removing ? "from" : "to"] [inserted_id]."))

	playsound(src, 'sound/machines/chime.ogg', 25, FALSE)


	if(removing)
		inserted_id.faction_group -= iff_faction
	else
		inserted_id.faction_group |= iff_faction

/obj/item/device/iff_granter/attack_hand(mob/user)
	if(!inserted_id || !ishuman(user) || loc != user)
		return ..()

	to_chat(user, SPAN_NOTICE("You remove [inserted_id] from [src]."))
	var/mob/living/carbon/human/human_user = user
	playsound(src, 'sound/machines/terminal_eject.ogg', 25, FALSE)
	human_user.put_in_hands(inserted_id)
	inserted_id = null



/obj/item/device/iff_granter/weyland
	name = "\improper Weyland-Yutani IFF granter"
	desc = "A device with an ID card slot on it, for adding or removing Weyland-Yutani IFF from ID cards."
	icon_state = "wyideditor"
	req_access = list(ACCESS_WY_CORPORATE)
	iff_name = "Weyland-Yutani"
	iff_faction = FACTION_LIST_WY
