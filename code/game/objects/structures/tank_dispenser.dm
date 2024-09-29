/obj/structure/dispenser
	name = "tank storage unit"
	desc = "A simple yet bulky storage device for gas tanks. Has room for up to ten oxygen tanks, and ten phoron tanks."
	icon = 'icons/obj/objects.dmi'
	icon_state = "dispenser"
	density = TRUE
	anchored = TRUE
	var/oxygentanks = 10
	var/phorontanks = 10
	var/list/oxytanks = list() //sorry for the similar var names
	var/list/platanks = list()


/obj/structure/dispenser/oxygen
	phorontanks = 0

/obj/structure/dispenser/phoron
	oxygentanks = 0


/obj/structure/dispenser/New()
	..()
	update_icon()


/obj/structure/dispenser/update_icon()
	overlays.Cut()
	switch(oxygentanks)
		if(1 to 3) overlays += "oxygen-[oxygentanks]"
		if(4 to INFINITY) overlays += "oxygen-4"
	switch(phorontanks)
		if(1 to 4) overlays += "phoron-[phorontanks]"
		if(5 to INFINITY) overlays += "phoron-5"

/obj/structure/dispenser/attack_remote(mob/user as mob)
	if(user.Adjacent(src))
		return attack_hand(user)
	..()

/obj/structure/dispenser/attack_hand(mob/user as mob)
	user.set_interaction(src)
	var/dat = "[src]<br><br>"
	dat += "Oxygen tanks: [oxygentanks] - [oxygentanks ? "<A href='?src=\ref[src];oxygen=1'>Dispense</A>" : "empty"]<br>"
	dat += "Phoron tanks: [phorontanks] - [phorontanks ? "<A href='?src=\ref[src];phoron=1'>Dispense</A>" : "empty"]"
	show_browser(user, dat, "Tank Storage Unit", "dispenser")
	onclose(user, "dispenser")
	return


/obj/structure/dispenser/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/tank/oxygen) || istype(I, /obj/item/tank/air) || istype(I, /obj/item/tank/anesthetic))
		if(oxygentanks < 10)
			user.drop_held_item()
			I.forceMove(src)
			oxytanks.Add(I)
			oxygentanks++
			to_chat(user, SPAN_NOTICE("You put [I] in [src]."))
			if(oxygentanks < 5)
				update_icon()
		else
			to_chat(user, SPAN_NOTICE("[src] is full."))
		updateUsrDialog()
		return
	if(istype(I, /obj/item/tank/phoron))
		if(phorontanks < 10)
			user.drop_held_item()
			I.forceMove(src)
			platanks.Add(I)
			phorontanks++
			to_chat(user, SPAN_NOTICE("You put [I] in [src]."))
			if(oxygentanks < 6)
				update_icon()
		else
			to_chat(user, SPAN_NOTICE("[src] is full."))
		updateUsrDialog()
		return
/*
	if(HAS_TRAIT(I, TRAIT_TOOL_WRENCH))
		if(anchored)
			to_chat(user, SPAN_NOTICE("You lean down and unwrench [src]."))
			anchored = FALSE
		else
			to_chat(user, SPAN_NOTICE("You wrench [src] into place."))
			anchored = TRUE
		return
*/
/obj/structure/dispenser/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(usr.stat || usr.is_mob_restrained())
		return
	if(Adjacent(usr))
		usr.set_interaction(src)
		if(href_list["oxygen"])
			if(oxygentanks > 0)
				var/obj/item/tank/oxygen/O
				if(length(oxytanks) == oxygentanks)
					O = oxytanks[1]
					oxytanks.Remove(O)
				else
					O = new /obj/item/tank/oxygen(loc)
				O.forceMove(loc)
				to_chat(usr, SPAN_NOTICE("You take [O] out of [src]."))
				oxygentanks--
				update_icon()
		if(href_list["phoron"])
			if(phorontanks > 0)
				var/obj/item/tank/phoron/P
				if(length(platanks) == phorontanks)
					P = platanks[1]
					platanks.Remove(P)
				else
					P = new /obj/item/tank/phoron(loc)
				P.forceMove(loc)
				to_chat(usr, SPAN_NOTICE("You take [P] out of [src]."))
				phorontanks--
				update_icon()
		add_fingerprint(usr)
		updateUsrDialog()
	else
		close_browser(usr, "dispenser")
		return
	return
