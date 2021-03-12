//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/storage/lockbox
	name = "lockbox"
	desc = "A locked box."
	icon_state = "lockbox+l"
	item_state = "syringe_kit"
	w_class = SIZE_LARGE
	max_w_class = SIZE_MEDIUM
	max_storage_space = 14 //The sum of the w_classes of all the items in this storage item.
	storage_slots = 4
	req_access = list(ACCESS_MARINE_COMMANDER)
	var/locked = 1
	var/broken = 0
	var/icon_locked = "lockbox+l"
	var/icon_closed = "lockbox"
	var/icon_broken = "lockbox+b"


	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/card/id))
			if(src.broken)
				to_chat(user, SPAN_DANGER("It appears to be broken."))
				return
			if(src.allowed(user))
				src.locked = !( src.locked )
				if(src.locked)
					src.icon_state = src.icon_locked
					to_chat(user, SPAN_DANGER("You lock the [src.name]!"))
					return
				else
					src.icon_state = src.icon_closed
					to_chat(user, SPAN_DANGER("You unlock the [src.name]!"))
					return
			else
				to_chat(user, SPAN_DANGER("Access Denied"))
		if(!locked)
			..()
		else
			to_chat(user, SPAN_DANGER("Its locked!"))
		return


	show_to(mob/user as mob)
		if(locked)
			to_chat(user, SPAN_DANGER("Its locked!"))
		else
			..()
		return


/obj/item/storage/lockbox/loyalty
	name = "\improper W-Y equipment lockbox"
	req_access = list(ACCESS_WY_CORPORATE)

/obj/item/storage/lockbox/loyalty/fill_preset_inventory()
	new /obj/item/ammo_magazine/pistol/mod88(src)
	new /obj/item/ammo_magazine/pistol/mod88(src)
	new /obj/item/ammo_magazine/pistol/mod88/rubber(src)
	new /obj/item/ammo_magazine/pistol/mod88/rubber(src)


/obj/item/storage/lockbox/clusterbang
	name = "lockbox of clusterbangs"
	desc = "You have a bad feeling about opening this."
	req_access = list(ACCESS_MARINE_BRIG)

/obj/item/storage/lockbox/clusterbang/fill_preset_inventory()
	new /obj/item/explosive/grenade/flashbang/clusterbang(src)
