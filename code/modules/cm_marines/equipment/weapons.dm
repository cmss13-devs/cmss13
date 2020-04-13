
/obj/item/storage/box/m56_system
	name = "\improper M56 smartgun system case"
	desc = "A large case containing an M56B Smartgun, M56 combat harness, head mounted sight and powerpack.\nDrag this sprite into you to open it up! NOTE: You cannot put items back inside this case."
	icon = 'icons/obj/items/storage.dmi'
	icon_state = "kit_case"
	w_class = SIZE_HUGE
	storage_slots = 4
	slowdown = 1
	can_hold = list() //Nada. Once you take the stuff out it doesn't fit back in.
	foldable = null

/obj/item/storage/box/m56_system/Initialize()
	. = ..()
	new /obj/item/clothing/glasses/night/m56_goggles(src)
	new /obj/item/weapon/gun/smartgun(src)
	new /obj/item/smartgun_powerpack(src)
	new /obj/item/clothing/suit/storage/marine/smartgunner(src)
	update_icon()

/obj/item/storage/box/m56_system/update_icon()
	if(overlays.len)
		overlays.Cut()
	if(contents.len)
		icon_state = "kit_case"
		overlays += image(icon, "smartgun")
	else
		icon_state = "kit_case_e"

/obj/item/smartgun_powerpack
	name = "\improper M56 powerpack"
	desc = "A heavy reinforced backpack with support equipment and power cells for the M56 Smartgun System."
	icon = 'icons/obj/items/clothing/backpacks.dmi'
	icon_state = "powerpack"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_BACK
	w_class = SIZE_HUGE
	var/obj/item/cell/pcell = null
	var/reloading = 0

/obj/item/smartgun_powerpack/New()
	select_gamemode_skin(/obj/item/smartgun_powerpack)
	..()
	pcell = new /obj/item/cell/high(src)

/obj/item/smartgun_powerpack/dropped(mob/living/user) // called on unequip
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.glasses && istype(H.glasses, /obj/item/clothing/glasses/night/m56_goggles))
			if(H.back == src)
				to_chat(H, SPAN_NOTICE("You remove \the [H.glasses]."))
				H.drop_inv_item_on_ground(H.glasses)
	..()


/obj/item/smartgun_powerpack/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A,/obj/item/cell))
		var/obj/item/cell/C = A
		visible_message("[user.name] swaps out the power cell in the [src.name].","You swap out the power cell in the [src] and drop the old one.")
		to_chat(user, "The new cell contains: [C.charge] power.")
		pcell.loc = get_turf(user)
		pcell = C
		user.drop_inv_item_to_loc(C, src)
		playsound(src,'sound/machines/click.ogg', 25, 1)		
	else
		..()

/obj/item/smartgun_powerpack/examine(mob/user)
	..()
	if (get_dist(user, src) <= 1)
		if(pcell)
			to_chat(user, "A small gauge in the corner reads: Power: [pcell.charge] / [pcell.maxcharge].")

/obj/item/smartgun_powerpack/proc/drain_powerpack(var/drain = 0, var/obj/item/cell/c)
	var/actual_drain = (rand(drain/2,drain)/25)
	if(c && c.charge > 0)
		if(c.charge > actual_drain)
			c.charge -= actual_drain 
		else 
			c.charge = 0
			to_chat(usr, SPAN_WARNING("[src] emits a low power warning and immediately shuts down!"))
		return TRUE
	if(!c || c.charge == 0)
		to_chat(usr, SPAN_WARNING("[src] emits a low power warning and immediately shuts down!"))
		return FALSE
	return FALSE

/obj/item/smartgun_powerpack/snow
	icon_state = "s_powerpack"

/obj/item/smartgun_powerpack/fancy
	icon_state = "powerpackw"

/obj/item/smartgun_powerpack/merc
	icon_state = "powerpackp"
