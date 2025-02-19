/obj/item/bananapeel
	name = "banana peel"
	desc = "A peel from a banana."
	icon = 'icons/obj/items/harvest.dmi'
	icon_state = "banana_peel"
	item_state = "banana_peel"
	w_class = SIZE_TINY
	throwforce = 0
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	garbage = TRUE

/obj/item/bananapeel/Crossed(AM as mob|obj)
	if (iscarbon(AM))
		var/mob/living/carbon/C = AM
		C.slip(name, 4, 2)

/obj/item/gift
	name = "gift"
	desc = "A wrapped item."
	icon = 'icons/obj/items/gifts.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_righthand.dmi'
	)
	icon_state = "gift3"
	var/size = 3
	var/obj/item/gift = null
	item_state = "gift"
	w_class = SIZE_LARGE

/obj/item/weapon/pole
	name = "wooden pole"
	desc = "A rough, cracked pole seemingly constructed on the field. You could probably whack someone with this."
	icon = 'icons/obj/items/weapons/melee/canes.dmi'
	icon_state = "wooden_pole"
	item_state = "wooden_pole"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/melee/canes_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/melee/canes_righthand.dmi',
	)
	force = 20
	attack_speed = 1.5 SECONDS
	var/gripped = FALSE

/obj/item/weapon/pole/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("Activate on your hand to grip this tightly. Useful if you have a bad leg.")

/obj/item/weapon/pole/attack_self(mob/living/user)
	..()
	if(!gripped)
		user.visible_message(SPAN_NOTICE("[user] grips [src] tightly."), SPAN_NOTICE("You grip [src] tightly."))
		flags_item |= NODROP|FORCEDROP_CONDITIONAL
		ADD_TRAIT(user, TRAIT_HOLDS_CANE, TRAIT_SOURCE_ITEM)
		user.AddComponent(/datum/component/footstep, 6, 35, 4, 1, "cane_step")
		gripped = TRUE
	else
		user.visible_message(SPAN_NOTICE("[user] loosens \his grip on [src]."), SPAN_NOTICE("You loosen your grip on [src]."))
		flags_item &= ~(NODROP|FORCEDROP_CONDITIONAL)
		REMOVE_TRAIT(user, TRAIT_HOLDS_CANE, TRAIT_SOURCE_ITEM)
		// Ideally, this would be something like a component added onto every mob that prioritizes certain sounds, such as stomping over canes.
		var/component = user.GetComponent(/datum/component/footstep)
		qdel(component)
		// However, I'm not going to do that. :)
		gripped = FALSE

/obj/item/weapon/pole/pickup(mob/user, silent)
	. = ..()
	gripped = FALSE
	REMOVE_TRAIT(user, TRAIT_HOLDS_CANE, TRAIT_SOURCE_ITEM) // no fucking around with two canes
	var/component = user.GetComponent(/datum/component/footstep)
	qdel(component)

/obj/item/weapon/pole/dropped(mob/user)
	. = ..()
	gripped = FALSE
	REMOVE_TRAIT(user, TRAIT_HOLDS_CANE, TRAIT_SOURCE_ITEM) // in case their arm is chopped off or something
	var/component = user.GetComponent(/datum/component/footstep)
	qdel(component)

/obj/item/weapon/pole/wooden_cane
	name = "wooden cane"
	desc = "A bog standard wooden cane with a dark tip."
	icon_state = "wooden_cane"
	item_state = "wooden_cane"
	force = 15

/obj/item/weapon/pole/fancy_cane
	name = "fancy cane"
	desc = "An ebony cane with a fancy, seemingly-golden tip."
	icon_state = "fancy_cane"
	item_state = "fancy_cane"
	force = 30

/obj/item/weapon/pole/fancy_cane/this_is_a_knife
	name = "fancy cane"
	desc = "An ebony cane with a fancy, seemingly-golden tip. Feels hollow to the touch."
	force = 15 // hollow
	var/obj/item/stored_item
	var/list/allowed_items = list(/obj/item/weapon, /obj/item/attachable/bayonet)

/obj/item/weapon/pole/fancy_cane/this_is_a_knife/Destroy()
	if(stored_item)
		QDEL_NULL(stored_item)
	. = ..()

/obj/item/weapon/pole/fancy_cane/this_is_a_knife/attack_hand(mob/living/mobber)
	if(stored_item && src.loc == mobber && !mobber.is_mob_incapacitated()) //Only allow someone to take out the stored_item if it's being worn or held. So you can pick them up off the floor
		if(mobber.put_in_active_hand(stored_item))
			mobber.visible_message(SPAN_DANGER("[mobber] slides [stored_item] out of [src]!"), SPAN_NOTICE("You slide [stored_item] out of [src]."))
			playsound(mobber, 'sound/weapons/gun_shotgun_shell_insert.ogg', 15, TRUE)
			stored_item = null
			update_icon()
		return
	..()

/obj/item/weapon/pole/fancy_cane/this_is_a_knife/update_icon()
	if(stored_item == null)
		icon_state = initial(icon_state) + "_open"
	else
		icon_state = initial(icon_state)

/obj/item/weapon/pole/fancy_cane/this_is_a_knife/attackby(obj/item/object, mob/living/mobber)
	if(length(allowed_items))
		for (var/i in allowed_items)
			if(istype(object, i))
				if(stored_item)
					return
				stored_item = object
				mobber.drop_inv_item_to_loc(object, src)
				to_chat(mobber, SPAN_NOTICE("You slide [object] into [src]."))
				playsound(mobber, 'sound/weapons/gun_shotgun_shell_insert.ogg', 15, TRUE)
				update_icon()
				break
	. = ..()

/obj/item/weapon/pole/fancy_cane/this_is_a_knife/machete
	stored_item = new /obj/item/weapon/sword/machete

/obj/item/weapon/pole/fancy_cane/this_is_a_knife/ceremonial_sword
	stored_item = new /obj/item/weapon/sword/ceremonial

/obj/item/weapon/pole/fancy_cane/this_is_a_knife/katana
	stored_item = new /obj/item/weapon/sword/katana

/obj/item/research//Makes testing much less of a pain -Sieve
	name = "research"
	icon = 'icons/obj/items/stock_parts.dmi'
	icon_state = "capacitor"
	desc = "A debug item for research."

/obj/item/moneybag
	icon = 'icons/obj/items/storage/bags.dmi'
	name = "Money bag"
	icon_state = "moneybag"
	force = 10
	throwforce = 2
	w_class = SIZE_LARGE

/obj/item/evidencebag
	name = "evidence bag"
	desc = "An empty evidence bag."
	icon = 'icons/obj/items/storage/bags.dmi'
	icon_state = "evidenceobj"
	item_state = ""
	w_class = SIZE_SMALL
	var/obj/item/stored_item = null

/obj/item/evidencebag/MouseDrop(obj/item/I as obj)
	if (!ishuman(usr))
		return

	var/mob/living/carbon/human/user = usr

	if (!(user.l_hand == src || user.r_hand == src))
		return //bag must be in your hands to use

	if (isturf(I.loc))
		if (!user.Adjacent(I))
			return
	else
		//If it isn't on the floor. Do some checks to see if it's in our hands or a box. Otherwise give up.
		if(istype(I.loc,/obj/item/storage)) //in a container.
			var/depth = I.get_storage_depth_to(user)
			if (!depth || depth > 2)
				return //too deeply nested to access or not being carried by the user.

			var/obj/item/storage/U = I.loc
			user.client.remove_from_screen(I)
			U.contents.Remove(I)
		else if(user.l_hand == I) //in a hand
			user.drop_l_hand()
		else if(user.r_hand == I) //in a hand
			user.drop_r_hand()
		else
			return

	if(!istype(I) || I.anchored)
		return

	if(istype(I, /obj/item/evidencebag))
		to_chat(user, SPAN_NOTICE("You find putting an evidence bag in another evidence bag to be slightly absurd."))
		return

	if(I.w_class > SIZE_MEDIUM)
		to_chat(user, SPAN_NOTICE("[I] won't fit in [src]."))
		return

	if(length(contents))
		to_chat(user, SPAN_NOTICE("[src] already has something inside it."))
		return

	user.visible_message("[user] puts [I] into [src]", "You put [I] inside [src].",
	"You hear a rustle as someone puts something into a plastic bag.")

	icon_state = "evidence"
	/// save the offset of the item
	var/xx = I.pixel_x
	var/yy = I.pixel_y
	/// then remove it so it'll stay within the evidence bag
	I.pixel_x = 0
	I.pixel_y = 0
	/// take a snapshot. (necessary to stop the underlays appearing under our inventory-HUD slots) ~Carn
	var/image/img = image("icon"=I, "layer"=FLOAT_LAYER)
	/// and then return it
	I.pixel_x = xx
	I.pixel_y = yy
	overlays += img
	/// should look nicer for transparent stuff. not really that important, but hey.
	overlays += "evidence"

	desc = "An evidence bag containing [I]."
	I.forceMove(src)
	stored_item = I
	w_class = I.w_class
	return


/obj/item/evidencebag/attack_self(mob/user)
	..()

	if(length(contents))
		var/obj/item/I = contents[1]
		user.visible_message("[user] takes [I] out of [src]", "You take [I] out of [src].",
		"You hear someone rustle around in a plastic bag, and remove something.")
		overlays.Cut() //remove the overlays

		user.put_in_hands(I)
		stored_item = null

		w_class = initial(w_class)
		icon_state = "evidenceobj"
		desc = "An empty evidence bag."
	else
		to_chat(user, "[src] is empty.")
		icon_state = "evidenceobj"
	return

/obj/item/evidencebag/get_examine_text(mob/user)
	. = ..()
	if(stored_item)
		. += stored_item.get_examine_text(user)

/obj/item/storage/box/evidence
	name = "evidence bag box"
	desc = "A box claiming to contain evidence bags."

/obj/item/storage/box/evidence/New()
	..()
	new /obj/item/evidencebag(src)
	new /obj/item/evidencebag(src)
	new /obj/item/evidencebag(src)
	new /obj/item/evidencebag(src)
	new /obj/item/evidencebag(src)
	new /obj/item/evidencebag(src)

/obj/item/parachute
	name = "parachute"
	desc = "A surprisingly small yet bulky pack with just enough safety straps to make RnD pass health and safety. The label says the pack comes with two parachutes - main and reserve, but you doubt the pack can fit even one."
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_faction/UA.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/backpacks_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/backpacks_righthand.dmi',
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/backpacks_by_faction/UA.dmi',
	)
	icon_state = "parachute_pack"
	item_state = "parachute_pack"
	w_class = SIZE_MASSIVE
	flags_equip_slot = SLOT_BACK
	flags_item = SMARTGUNNER_BACKPACK_OVERRIDE

/obj/item/clock
	name = "digital clock"
	desc = "A battery powered clock, able to keep time within about 5 seconds... it was never that accurate."
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "digital_clock"
	force = 3
	throwforce = 2
	throw_speed = 1
	throw_range = 4
	w_class = SIZE_SMALL

/obj/item/clock/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("The [src] reads: [GLOB.current_date_string] - [worldtime2text()]")
