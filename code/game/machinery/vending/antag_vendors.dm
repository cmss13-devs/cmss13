/obj/structure/machinery/vending/antag
	req_access = list(ACCESS_ILLEGAL_PIRATE)
	req_one_access = list()
	wrenchable = FALSE
	products = list()

	var/clf_products = list()
	var/upp_products = list()
	var/current_faction = ""

/obj/structure/machinery/vending/antag/attack_hand(var/mob/living/carbon/human/H)
	if(!istype(H) ||!H.wear_id || !H.wear_id.faction) //TODO: convert mind.faction into ID faction when ID has factions...
		to_chat(H, SPAN_WARNING("Access denied."))
		return
	if(!(H.wear_id.faction=="CLF") && !(H.wear_id.faction=="UPP"))
		to_chat(H, SPAN_WARNING("Access denied, you imperialist pig!"))
		return

	if(current_faction != H.wear_id.faction)
		product_records = list()
		switch(H.wear_id.faction)
			if("CLF")
				products = clf_products
			if("UPP")
				products = upp_products
		build_inventory(products)

	. = ..()

/obj/structure/machinery/vending/antag/gear
	name = "\improper Automated Gear Vendor"
	desc = "An automated gear vendor, dispensing various pieces of equipment."
	icon_state = "uniform_marine"
	icon_vend = "uniform_marine_vend"
	icon_deny = "uniform_marine"

/obj/structure/machinery/vending/antag/gear/New()
	//Forcefully reset the product list
	product_records = list()

	clf_products = list(
		/obj/item/clothing/head/militia = 40,
		/obj/item/clothing/mask/gas/PMC = 40,
		/obj/item/device/radio/headset/distress/dutch = 40,
		/obj/item/clothing/under/colonist = 40,
		/obj/item/clothing/suit/storage/militia = 40,
		/obj/item/clothing/gloves/black = 40,
		/obj/item/clothing/shoes/black = 40,
		/obj/item/storage/backpack/lightpack = 40,
		/obj/item/storage/large_holster/katana/full = 40,
		/obj/item/storage/large_holster/machete/full = 40,
		/obj/item/storage/belt/marine = 40,
		/obj/item/storage/pouch/firstaid = 40,
		/obj/item/storage/pouch/medical = 40,
		/obj/item/storage/pouch/general/medium = 40,
		/obj/item/storage/pouch/survival/full = 40,
		/obj/item/storage/pouch/tools/full = 40,
		/obj/item/clothing/accessory/storage/webbing = 40
	)

	upp_products = list(
		/obj/item/clothing/head/helmet/UPP = 40,
		/obj/item/clothing/mask/gas/PMC/upp = 40,
		/obj/item/device/radio/headset/distress/bears = 40,
		/obj/item/clothing/under/marine/veteran/UPP = 40,
		/obj/item/clothing/suit/storage/marine/faction/UPP = 40,
		/obj/item/clothing/gloves/marine/veteran/PMC = 40,
		/obj/item/clothing/shoes/marine = 40,
		/obj/item/storage/backpack/lightpack = 40,
		/obj/item/storage/belt/marine = 40,
		/obj/item/storage/belt/marine/upp = 40,
		/obj/item/storage/belt/gun/korovin/standard = 40,
		/obj/item/storage/belt/gun/korovin/tranq = 40,
		/obj/item/storage/pouch/bayonet/upp = 40,
		/obj/item/storage/pouch/firstaid = 40,
		/obj/item/storage/pouch/general = 40,
		/obj/item/storage/pouch/magazine/large/upp = 40,
		/obj/item/storage/pouch/magazine/upp_smg = 40,
		/obj/item/storage/pouch/survival/full = 40,
		/obj/item/storage/pouch/tools/full = 40,
		/obj/item/clothing/accessory/storage/webbing = 40
	)

/obj/structure/machinery/vending/antag/weapons
	name = "\improper Automated Weapons Rack"
	desc = "An automated weapons rack, dispensing various arms."
	icon_state = "armory"
	icon_vend = "armory-vend"
	icon_deny = "armory"

/obj/structure/machinery/vending/antag/weapons/New()
	//Forcefully reset the product list
	product_records = list()

	clf_products = list(
		/obj/item/weapon/gun/rifle/mar40/carbine = 40,
		/obj/item/weapon/gun/rifle/mar40 = 40,
		/obj/item/weapon/gun/rifle/hunting = 40,
		/obj/item/weapon/gun/shotgun/merc = 40,
		/obj/item/weapon/gun/shotgun/double = 40,
		/obj/item/weapon/gun/shotgun/pump/cmb = 40,
		/obj/item/weapon/gun/shotgun/double/sawn = 40,
		/obj/item/weapon/gun/smg/skorpion = 40,
		/obj/item/weapon/gun/smg/uzi = 40,
		/obj/item/weapon/gun/smg/mp7 = 40,
		/obj/item/weapon/gun/revolver/cmb = 40,
		/obj/item/weapon/gun/revolver/small = 40,
		/obj/item/weapon/gun/pistol/mod88 = 40,
		/obj/item/weapon/gun/pistol/highpower = 40,
		/obj/item/weapon/gun/pistol/holdout = 40,
		/obj/item/weapon/gun/pistol/kt42 = 40,
		/obj/item/weapon/gun/pistol/c99 = 40,
		/obj/item/weapon/gun/pistol/heavy = 40
	)

	upp_products = list(
		/obj/item/weapon/gun/rifle/type71 = 40,
		/obj/item/weapon/gun/rifle/type71/flamer = 40,
		/obj/item/weapon/gun/rifle/type71/carbine = 40,
		/obj/item/weapon/gun/smg/skorpion/upp = 40,
		/obj/item/weapon/gun/pistol/c99/upp = 40
	)

/obj/structure/machinery/vending/antag/munition
	name = "\improper Automated Munitions Vendor"
	desc = "An automated munitions vendor, dispensing various types of ammunition, explosives, and tools."
	icon_state = "robotics"
	icon_deny = "robotics-deny"

/obj/structure/machinery/vending/antag/munition/New()
	//Forcefully reset the product list
	product_records = list()

	clf_products = list(
		/obj/item/ammo_magazine/rifle/mar40 = 40,
		/obj/item/ammo_magazine/rifle/hunting = 40,
		/obj/item/ammo_magazine/shotgun/buckshot = 40,
		/obj/item/ammo_magazine/shotgun/incendiary = 40,
		/obj/item/ammo_magazine/shotgun/slugs = 40,
		/obj/item/ammo_magazine/smg/uzi/extended = 40,
		/obj/item/ammo_magazine/smg/mp7 = 40,
		/obj/item/ammo_magazine/smg/skorpion = 40,
		/obj/item/ammo_magazine/revolver/cmb = 40,
		/obj/item/ammo_magazine/revolver/small = 40,
		/obj/item/ammo_magazine/pistol/mod88 = 40,
		/obj/item/ammo_magazine/pistol/heavy = 40,
		/obj/item/ammo_magazine/pistol/highpower = 40,
		/obj/item/ammo_magazine/pistol/automatic = 40,
		/obj/item/ammo_magazine/pistol/c99 = 40,
		/obj/item/ammo_magazine/pistol/holdout = 40,
		/obj/item/explosive/grenade/empgrenade = 40,
		/obj/item/explosive/grenade/incendiary/molotov = 40,
		/obj/item/explosive/grenade/smokebomb = 40,
		/obj/item/explosive/grenade/custom/ied = 40,
		/obj/item/explosive/grenade/custom/ied_incendiary = 40,
		/obj/item/weapon/melee/twohanded/fireaxe = 40,
		/obj/item/weapon/melee/twohanded/lungemine = 40,
		/obj/item/device/flashlight = 40,
		/obj/item/reagent_container/spray/pepper = 40,
		/obj/item/attachable/bayonet/upp = 40
	)

	upp_products = list(
		/obj/item/ammo_magazine/rifle/type71 = 80,
		/obj/item/ammo_magazine/smg/skorpion = 80,
		/obj/item/ammo_magazine/pistol/c99 = 40,
		/obj/item/ammo_magazine/minigun = 40,
		/obj/item/explosive/grenade/empgrenade = 40,
		/obj/item/explosive/grenade/smokebomb = 40,
		/obj/item/explosive/grenade/HE/upp = 40,
		/obj/item/explosive/grenade/phosphorus/upp = 40,
		/obj/item/weapon/melee/twohanded/fireaxe = 40,
		/obj/item/device/flashlight = 40,
		/obj/item/handcuffs = 40,
		/obj/item/explosive/plastique = 40,
		/obj/item/reagent_container/food/snacks/upp = 40
	)