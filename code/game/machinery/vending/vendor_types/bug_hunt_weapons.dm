/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/bug_hunt
	name = "\improper ColMarTech Recon Weapons Rack"
	desc = "An automated rack of firearms and ammunition for Force Reconnaissance operations."

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/bug_hunt/populate_product_list(scale)
	listed_products = list(
		list("PRIMARY FIREARMS", -1, null, null),
		list("M41A MK1 Pulse Rifle", floor(scale * 15), /obj/item/weapon/gun/rifle/m41aMK1/forecon, VENDOR_ITEM_RECOMMENDED),
		list("M39 Submachine Gun", floor(scale * 10), /obj/item/weapon/gun/smg/m39, VENDOR_ITEM_REGULAR),
		list("M4RA Battle Rifle", floor(scale * 5), /obj/item/weapon/gun/rifle/m4ra, VENDOR_ITEM_REGULAR),
		list("M37A2 Pump Shotgun", floor(scale * 10), /obj/item/weapon/gun/shotgun/pump/m37a, VENDOR_ITEM_REGULAR),

		list("PRIMARY AMMUNITION", -1, null, null),
		list("M41A MK1 Magazine (10x24mm)", floor(scale * 15), /obj/item/ammo_magazine/rifle/m41aMK1, VENDOR_ITEM_RECOMMENDED),
		list("M41A MK1 AP Magazine (10x24mm)", floor(scale * 3), /obj/item/ammo_magazine/rifle/m41aMK1/ap, VENDOR_ITEM_REGULAR),
		list("M39 HV Magazine (10x20mm)", floor(scale * 15), /obj/item/ammo_magazine/smg/m39, VENDOR_ITEM_REGULAR),
		list("M39 AP Magazine (10x20mm)", floor(scale * 12), /obj/item/ammo_magazine/smg/m39/ap, VENDOR_ITEM_REGULAR),
		list("M39 Extended Magazine (10x20mm)", floor(scale * 10), /obj/item/ammo_magazine/smg/m39/extended, VENDOR_ITEM_REGULAR),
		list("M4RA Magazine (10x24mm)", floor(scale * 15), /obj/item/ammo_magazine/rifle/m4ra, VENDOR_ITEM_REGULAR),
		list("M4RA AP Magazine (10x24mm)", floor(scale * 16), /obj/item/ammo_magazine/rifle/m4ra/ap, VENDOR_ITEM_REGULAR),
		list("M4RA Extended Magazine (10x24mm)", floor(scale * 10), /obj/item/ammo_magazine/rifle/m4ra/extended, VENDOR_ITEM_REGULAR),
		list("Box of Buckshot Shells (12g)", floor(scale * 5), /obj/item/ammo_magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("Box of Shotgun Slugs (12g)", floor(scale * 5), /obj/item/ammo_magazine/shotgun/slugs, VENDOR_ITEM_REGULAR),
		list("Box of Flechette Shells (12g)", floor(scale * 3), /obj/item/ammo_magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),

		list("SIDEARMS", -1, null, null),
		list("M48A4 Service Pistol", floor(scale * 10), /obj/item/weapon/gun/pistol/m1911/socom, VENDOR_ITEM_RECOMMENDED),
		list("M4A3 Service Pistol", floor(scale * 10), /obj/item/weapon/gun/pistol/m4a3, VENDOR_ITEM_REGULAR),
		list("M44 Combat Revolver", floor(scale * 10), /obj/item/weapon/gun/revolver/m44, VENDOR_ITEM_REGULAR),
		list("M82F Flare Gun", floor(scale * 5), /obj/item/weapon/gun/flare, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", -1, null, null),
		list("M48A4 Magazine (.45 ACP)", floor(scale * 10), /obj/item/ammo_magazine/pistol/m1911, VENDOR_ITEM_RECOMMENDED),
		list("M4A3 Magazine (9mm)", floor(scale * 10), /obj/item/ammo_magazine/pistol, VENDOR_ITEM_REGULAR),
		list("M4A3 AP Magazine (9mm)", floor(scale * 2), /obj/item/ammo_magazine/pistol/ap, VENDOR_ITEM_REGULAR),
		list("M4A3 HP Magazine (9mm)", floor(scale * 2), /obj/item/ammo_magazine/pistol/hp, VENDOR_ITEM_REGULAR),
		list("M44 Speedloader (.44)", floor(scale * 10), /obj/item/ammo_magazine/revolver, VENDOR_ITEM_REGULAR),
		list("M44 Heavy Speedloader (.44)", 10, /obj/item/ammo_magazine/revolver/heavy, VENDOR_ITEM_REGULAR),
		list("M44 Marksman Speedloader (.44)", 6, /obj/item/ammo_magazine/revolver/marksman, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", -1, null, null),
		list("M39 Folding Stock", floor(scale * 5), /obj/item/attachable/stock/smg/collapsible, VENDOR_ITEM_REGULAR),
		list("M41A Folding Stock", floor(scale * 5), /obj/item/attachable/stock/rifle/collapsible, VENDOR_ITEM_REGULAR),
		list("Rail Flashlight", floor(scale * 10), /obj/item/attachable/flashlight, VENDOR_ITEM_RECOMMENDED),
		list("Underbarrel Flashlight Grip", floor(scale * 5), /obj/item/attachable/flashlight/grip, VENDOR_ITEM_RECOMMENDED),
		list("M41A MK1 Grenade Launcher (FORECON)", floor(scale * 10), /obj/item/attachable/attached_gun/grenade/mk1/recon, VENDOR_ITEM_REGULAR),
		list("Underbarrel Flare Launcher", floor(scale * 10), /obj/item/attachable/attached_gun/flare_launcher, VENDOR_ITEM_REGULAR),

		list("UTILITIES", -1, null, null),
		list("M5 Bayonet", floor(scale * 10), /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
		list("M94 Marking Flare Pack", floor(scale * 5), /obj/item/storage/box/m94, VENDOR_ITEM_RECOMMENDED),
		list("M89-S Signal Flare Pack", floor(scale * 1), /obj/item/storage/box/m94/signal, VENDOR_ITEM_REGULAR),
	)
