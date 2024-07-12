/obj/item/storage/box/spec/stormtrooper
	name = "\improper Stormtrooper equipment case"
	desc = "A large case containing your experimental M40 full armor, heavy hammer and montage shield."
	icon = 'core_ru/icons/obj/items/storage.dmi'
	icon_state = "kit_case"
	kit_overlay = "stormtrooper"
//stormtrooper
/obj/item/storage/box/spec/stormtrooper/fill_preset_inventory()
	new /obj/item/clothing/suit/storage/marine/m40(src)
	new /obj/item/clothing/head/helmet/marine/m40(src)
	new /obj/item/clothing/gloves/marine/m40(src)
	new /obj/item/weapon/twohanded/st_hammer(src)
	new /obj/item/weapon/shield/montage(src)
	new /obj/item/storage/belt/gun/xm52(src)
	new /obj/item/weapon/gun/rifle/xm52(src)
	new /obj/item/ammo_magazine/rifle/xm52(src)
	new /obj/item/ammo_magazine/rifle/xm52(src)
	new /obj/item/ammo_magazine/shotgun/light/breaching/sparkshots(src)
	new /obj/item/ammo_magazine/shotgun/light/breaching/sparkshots(src)

