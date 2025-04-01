
/obj/item/storage/box/m56_system
	name = "\improper M56 smartgun system case"
	desc = "A large case containing an M56B Smartgun, M56 combat harness, head mounted sight and powerpack.\nDrag this sprite into you to open it up! NOTE: You cannot put items back inside this case."
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "kit_case"
	w_class = SIZE_HUGE
	storage_slots = 7
	slowdown = 1
	can_hold = list() //Nada. Once you take the stuff out it doesn't fit back in.
	foldable = null

/obj/item/storage/box/m56_system/Initialize()
	. = ..()
	new /obj/item/clothing/suit/storage/marine/smartgunner(src)
	new /obj/item/weapon/gun/smartgun(src)
	new /obj/item/clothing/glasses/night/m56_goggles(src)
	new /obj/item/smartgun_battery(src)
	for(var/i in 1 to 3)
		new /obj/item/ammo_magazine/smartgun(src)
	update_icon()

/obj/item/storage/box/m56_system/update_icon()
	LAZYCLEARLIST(overlays)
	if(length(contents))
		icon_state = "kit_case"
		overlays += image(icon, "smartgun")
	else
		icon_state = "kit_case_e"

/obj/item/storage/box/m56c_system
	name = "\improper M56C smartgun system case"
	desc = "A large case containing an M56C Smartgun, M56 combat harness, head mounted sight, M280 Smartgunner Drum Belt and powerpack.\nDrag this sprite into you to open it up! NOTE: You cannot put items back inside this case."
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "kit_case"
	w_class = SIZE_HUGE
	storage_slots = 6
	slowdown = 1
	can_hold = list() //Nada. Once you take the stuff out it doesn't fit back in.
	foldable = null

/obj/item/storage/box/m56c_system/Initialize()
	. = ..()
	new /obj/item/clothing/glasses/night/m56_goggles(src)
	new /obj/item/weapon/gun/smartgun/co(src)
	new /obj/item/smartgun_battery(src)
	new /obj/item/pamphlet/skill/cosmartgun(src)
	new /obj/item/clothing/suit/storage/marine/smartgunner(src)
	new /obj/item/storage/belt/marine/smartgunner(src)
	update_icon()

/obj/item/storage/box/m56c_system/update_icon()
	LAZYCLEARLIST(overlays)
	if(length(contents))
		icon_state = "kit_case"
		overlays += image(icon, "smartgun")
	else
		icon_state = "kit_case_e"

/obj/item/storage/box/m56_dirty_system
	name = "\improper M56D 'Dirty' smartgun system case"
	desc = "A large case containing an M56D 'Dirty' Smartgun, M56D PMC combat harness and helmet, head mounted sight, M280 Smartgunner Drum Belt and powerpack.\nDrag this sprite into you to open it up! NOTE: You cannot put items back inside this case."
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "kit_case"
	w_class = SIZE_HUGE
	storage_slots = 6
	slowdown = 1
	can_hold = list() //Nada. Once you take the stuff out it doesn't fit back in.
	foldable = null

/obj/item/storage/box/m56_dirty_system/Initialize()
	. = ..()
	new /obj/item/clothing/glasses/night/m56_goggles(src)
	new /obj/item/weapon/gun/smartgun/dirty(src)
	new /obj/item/smartgun_battery(src)
	new /obj/item/clothing/suit/storage/marine/smartgunner/veteran/pmc(src)
	new /obj/item/clothing/head/helmet/marine/veteran/pmc/gunner(src)
	new /obj/item/storage/belt/gun/smartgunner/pmc/full(src)
	update_icon()

/obj/item/storage/box/m56_dirty_system/update_icon()
	LAZYCLEARLIST(overlays)
	if(length(contents))
		icon_state = "kit_case"
		overlays += image(icon, "smartgun")
	else
		icon_state = "kit_case_e"
