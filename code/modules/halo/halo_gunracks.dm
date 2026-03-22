/obj/structure/gun_rack
	name = "gun rack"
	desc = "ARMAT-produced gun rack for storage of long guns. While initial model was supposed to be extremely modifiable, USCM comissioned racks with fixed slots which only fit M41A rifles. Some say they were cheaper, and some say the main reason was marine's ability to easily break anything more complex than a tungsten ball."
	icon = 'icons/obj/structures/gun_racks.dmi'
	icon_state = "m41a"
	density = TRUE
	var/allowed_type
	var/populate_type
	var/max_stored = 5
	var/initial_stored = 5

/obj/structure/gun_rack/Initialize()
	. = ..()
	if(!allowed_type)
		icon_state = "m41a_0"
		return

	if(initial_stored)
		var/i = 0
		while(i < initial_stored)
			contents += new populate_type(src)
			i++
	update_icon()

/obj/structure/gun_rack/attackby(obj/item/O, mob/user)
	if(istype(O, allowed_type) && contents.len < max_stored)
		user.drop_inv_item_to_loc(O, src)
		contents += O
		update_icon()

/obj/structure/gun_rack/attack_hand(mob/living/user)
	if(!contents.len)
		to_chat(user, SPAN_WARNING("[src] is empty."))
		return

	var/obj/stored_obj = contents[contents.len]
	contents -= stored_obj
	user.put_in_hands(stored_obj)
	to_chat(user, SPAN_NOTICE("You grab [stored_obj] from [src]."))
	playsound(src, "gunequip", 25, TRUE)
	update_icon()

/obj/structure/gun_rack/update_icon()
	if(contents.len)
		icon_state = "[initial(icon_state)]_[contents.len]"
	else
		icon_state = "[initial(icon_state)]_0"


// halo begins
/obj/structure/gun_rack/halo
	name = "halo gun rack holder"
	desc = "A UNSC weapon rack."
	icon = 'icons/halo/obj/structures/gun_racks.dmi'
	icon_state = "template"

/obj/structure/gun_rack/halo/medkit
	name = "medkit station"
	desc = "A wall-mounted medkit station."
	icon_state = "medkit"
	max_stored = 1
	initial_stored = 1
	density = FALSE
	allowed_type = /obj/item/storage/firstaid/unsc
	populate_type = /obj/item/storage/firstaid/unsc

/obj/structure/gun_rack/halo/armory
	name = "weapon rack"
	max_stored = 5
	initial_stored = 5

/obj/structure/gun_rack/halo/armory/Initialize()
	. = ..()
	if(prob(50))
		var/image/picked_image
		picked_image = pick("+decorator_1","+decorator_2","+decorator_3")
		overlays += picked_image
	else
		return

/obj/structure/gun_rack/halo/armory/ma5c
	name = "MA5C weapon rack"
	icon_state = "ma5c"
	allowed_type = /obj/item/weapon/gun/rifle/halo/ma5c
	populate_type = /obj/item/weapon/gun/rifle/halo/ma5c

/obj/structure/gun_rack/halo/armory/ma5c/unloaded
	populate_type = /obj/item/weapon/gun/rifle/halo/ma5c/unloaded

/obj/structure/gun_rack/halo/armory/ma5c/empty
	initial_stored = 0

/obj/structure/gun_rack/halo/armory/ma5b
	name = "MA5B weapon rack"
	icon_state = "ma5b"
	allowed_type = /obj/item/weapon/gun/rifle/halo/ma5b
	populate_type = /obj/item/weapon/gun/rifle/halo/ma5b

/obj/structure/gun_rack/halo/armory/ma5b/unloaded
	populate_type = /obj/item/weapon/gun/rifle/halo/ma5b/unloaded

/obj/structure/gun_rack/halo/armory/ma5b/empty
	initial_stored = 0

/obj/structure/gun_rack/halo/armory/br55
	name = "BR55 weapon rack"
	icon_state = "br55"
	allowed_type = /obj/item/weapon/gun/rifle/halo/br55
	populate_type = /obj/item/weapon/gun/rifle/halo/br55

/obj/structure/gun_rack/halo/armory/br55/unloaded
	populate_type = /obj/item/weapon/gun/rifle/halo/br55/unloaded

/obj/structure/gun_rack/halo/armory/br55/empty
	initial_stored = 0

//-------------------- BIG RACKS (lol) --------------------

/obj/structure/gun_rack/halo/big
	name = "weapon rack"
	icon = 'icons/halo/obj/structures/gun_racks_32x48.dmi'
	max_stored = 5
	initial_stored = 5
	var/not_usable

/obj/structure/gun_rack/halo/big/attack_hand(mob/living/user)
	if(not_usable)
		return
	if(!contents.len)
		to_chat(user, SPAN_WARNING("[src] is empty."))
		return

	var/obj/stored_obj = contents[contents.len]
	contents -= stored_obj
	user.put_in_hands(stored_obj)
	to_chat(user, SPAN_NOTICE("You grab [stored_obj] from [src]."))
	playsound(src, "gunequip", 25, TRUE)
	if(contents.len == 0)
		flick("[initial(icon_state)]_reset", src)
		playsound(src, 'sound/machines/elevator_openclose.ogg', 25)
		if(initial_stored)
			var/i = 0
			while(i < initial_stored)
				contents += new populate_type(src)
				i++
		not_usable = TRUE
		addtimer(CALLBACK(src, PROC_REF(restore_usability)), 7 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(play_sound)), 4.5 SECONDS)
	update_icon()

/obj/structure/gun_rack/halo/big/attackby(obj/item/O, mob/user)
	if(not_usable)
		return
	if(istype(O, allowed_type) && contents.len < max_stored)
		user.drop_inv_item_to_loc(O, src)
		contents += O
		update_icon()

/obj/structure/gun_rack/halo/big/proc/restore_usability()
	not_usable = FALSE

/obj/structure/gun_rack/halo/big/proc/play_sound()
	playsound(src, 'sound/machines/elevator_openclose.ogg', 25)

/obj/structure/gun_rack/halo/big/ma5c
	name = "MA5C weapon rack"
	icon_state = "ma5c"
	allowed_type = /obj/item/weapon/gun/rifle/halo/ma5c
	populate_type = /obj/item/weapon/gun/rifle/halo/ma5c

/obj/structure/gun_rack/halo/big/ma5c/unloaded
	populate_type = /obj/item/weapon/gun/rifle/halo/ma5c/unloaded

/obj/structure/gun_rack/halo/big/ma5b
	name = "MA5B weapon rack"
	icon_state = "ma5b"
	allowed_type = /obj/item/weapon/gun/rifle/halo/ma5b
	populate_type = /obj/item/weapon/gun/rifle/halo/ma5b

/obj/structure/gun_rack/halo/big/ma5b/unloaded
	populate_type = /obj/item/weapon/gun/rifle/halo/ma5b/unloaded
/obj/structure/gun_rack/halo/big/br55
	name = "BR55 weapon rack"
	icon_state = "br55"
	allowed_type = /obj/item/weapon/gun/rifle/halo/br55
	populate_type = /obj/item/weapon/gun/rifle/halo/br55

/obj/structure/gun_rack/halo/big/br55/unloaded
	populate_type = /obj/item/weapon/gun/rifle/halo/br55/unloaded
