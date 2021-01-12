//these are probably broken

/obj/structure/machinery/floodlight
	name = "Emergency Floodlight"
	icon = 'icons/obj/structures/machinery/floodlight.dmi'
	icon_state = "flood00"
	density = 1
	anchored = 1
	var/on = 0
	var/obj/item/cell/cell = null
	var/use = 0
	var/unlocked = 0
	var/open = 0
	var/brightness_on = 7		//can't remember what the maxed out value is
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/floodlight/Initialize(mapload, ...)
	. = ..()
	cell = new /obj/item/cell(src)

/obj/structure/machinery/floodlight/Destroy()
	SetLuminosity(0)
	return ..()

/obj/structure/machinery/floodlight/proc/updateicon()
	icon_state = "flood[open ? "o" : ""][open && cell ? "b" : ""]0[on]"
/*
/obj/structure/machinery/floodlight/process()
	if(on && cell)
		if(cell.charge >= use)
			cell.use(use)
		else
			on = 0
			updateicon()
			SetLuminosity(0)
			src.visible_message(SPAN_WARNING("[src] shuts down due to lack of power!"))
			return
*/
/obj/structure/machinery/floodlight/attack_hand(mob/user as mob)
	if(open && cell)
		if(ishuman(user))
			if(!user.get_active_hand())
				user.put_in_hands(cell)
				cell.forceMove(user.loc)
		else
			cell.forceMove(loc)

		cell.add_fingerprint(user)
		cell.updateicon()

		src.cell = null
		to_chat(user, "You remove the power cell.")
		updateicon()
		return

	if(on)
		on = 0
		to_chat(user, SPAN_NOTICE(" You turn off the light."))
		SetLuminosity(0)
		unslashable = TRUE
		unacidable = TRUE
	else
		if(!cell)
			return
		if(cell.charge <= 0)
			return
		on = 1
		to_chat(user, SPAN_NOTICE(" You turn on the light."))
		SetLuminosity(brightness_on)
		unacidable = FALSE

	updateicon()


/obj/structure/machinery/floodlight/attackby(obj/item/W as obj, mob/user as mob)
	if(!ishuman(user))
		return

	if (istype(W, /obj/item/tool/wrench))
		if (!anchored)
			anchored = 1
			to_chat(user, "You anchor the [src] in place.")
		else
			anchored = 0
			to_chat(user, "You remove the bolts from the [src].")

	if (istype(W, /obj/item/tool/screwdriver))
		if (!open)
			if(unlocked)
				unlocked = 0
				to_chat(user, "You screw the battery panel in place.")
			else
				unlocked = 1
				to_chat(user, "You unscrew the battery panel.")

	if (istype(W, /obj/item/tool/crowbar))
		if(unlocked)
			if(open)
				open = 0
				overlays = null
				to_chat(user, "You crowbar the battery panel in place.")
			else
				if(unlocked)
					open = 1
					to_chat(user, "You remove the battery panel.")

	if (istype(W, /obj/item/cell))
		if(open)
			if(cell)
				to_chat(user, "There is a power cell already installed.")
			else
				if(user.drop_inv_item_to_loc(W, src))
					cell = W
					to_chat(user, "You insert the power cell.")
	updateicon()

//Magical floodlight that cannot be destroyed or interacted with.
/obj/structure/machinery/floodlight/landing
	name = "Landing Light"
	desc = "A powerful light stationed near landing zones to provide better visibility."
	icon_state = "flood01"
	on = 1
	in_use = 1
	luminosity = 6
	use_power = 0

	attack_hand()
		return

	attackby()
		return
