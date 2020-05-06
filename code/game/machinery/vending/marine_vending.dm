//MARINE VENDING - APOPHIS775 - LAST UPDATE - 25JAN2015


///******MARINE VENDOR******/

/obj/structure/machinery/vending/marine
	name = "ColMarTech Automated Weapons rack"
	desc = "A automated weapon rack hooked up to a colossal storage of standard-issue weapons."
	icon_state = "armory"
	icon_vend = "armory-vend"
	icon_deny = "armory"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_PREP, ACCESS_MARINE_CARGO)
	wrenchable = FALSE

	product_ads = "If it moves, it's hostile!;How many enemies have you killed today?;Shoot first, perform autopsy later!;Your ammo is right here.;Guns!;Die, scumbag!;Don't shoot me bro!;Shoot them, bro.;Why not have a donut?"
	products = list()
	contraband = list()
	premium = list()
	prices = list()

/obj/structure/machinery/vending/marine/proc/populate_product_list(var/scale)
	//Forcefully reset the product list
	product_records = list()

	products = list(
		/obj/item/weapon/gun/pistol/m4a3 = round(scale * 25),
		/obj/item/weapon/gun/pistol/mod88 = round(scale * 25),
		/obj/item/weapon/gun/revolver/m44 = round(scale * 25),
		/obj/item/weapon/gun/smg/m39 = round(scale * 30),
		/obj/item/weapon/gun/rifle/m41a = round(scale * 30),
		/obj/item/weapon/gun/rifle/l42a = round(scale * 10),
		/obj/item/weapon/gun/shotgun/pump = round(scale * 15),
		/obj/item/ammo_magazine/pistol = round(scale * 20),
		/obj/item/ammo_magazine/pistol/mod88 = round(scale * 20),
		/obj/item/ammo_magazine/revolver = round(scale * 20),
		/obj/item/ammo_magazine/smg/m39 = round(scale * 30),
		/obj/item/ammo_magazine/rifle = round(scale * 25),
		/obj/item/ammo_magazine/rifle/ap = 0,
		/obj/item/ammo_magazine/rifle/l42a = round(scale * 15),
		/obj/item/ammo_magazine/rifle/l42a/ap = 0,
		/obj/item/ammo_magazine/shotgun/slugs = round(scale * 10),
		/obj/item/ammo_magazine/shotgun/buckshot = round(scale * 10),
		/obj/item/ammo_magazine/shotgun/flechette = round(scale * 4),
		/obj/item/attachable/flashlight = round(scale * 25),
		/obj/item/attachable/bayonet = round(scale * 30),
		/obj/item/weapon/throwing_knife = round(scale * 10),
		/obj/item/storage/box/m94 = round(scale * 10),
	)

	contraband =   list()

	premium = list()

	prices = list()

	//Rebuild the vendor's inventory to make our changes apply
	build_inventory(products)
	build_inventory(contraband, 1)
	build_inventory(premium, 0, 1)

/obj/structure/machinery/vending/marine/select_gamemode_equipment(gamemode)
	var/products2[]
	if (map_tag in MAPS_COLD_TEMP)
		products2 = list(
					/obj/item/clothing/mask/rebreather/scarf = 10,
						)
	build_inventory(products2)

/obj/structure/machinery/vending/marine/New()
	..()
	populate_product_list(1)
	marine_vendors.Add(src)

/obj/structure/machinery/vending/marine/Dispose()
	. = ..()
	marine_vendors.Remove(src)

/obj/structure/machinery/vending/marine/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/gun))
		stock(W, user)
		return TRUE
	if(istype(W, /obj/item/ammo_magazine))
		stock(W, user)
		return TRUE
	. = ..()

/obj/structure/machinery/vending/marine/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				qdel(src)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)

/obj/structure/machinery/vending/marine/cargo_guns
	name = "\improper ColMarTech automated armaments vendor"
	desc = "A automated rack hooked up to a small supply of various firearms and explosives."
	hacking_safety = 1
	wrenchable = FALSE
	req_access = list(ACCESS_MARINE_CARGO)
	products = list()
	contraband = list()
	premium = list()


/obj/structure/machinery/vending/marine/cargo_guns/populate_product_list(var/scale)
	//Forcefully reset the product list
	product_records = list()

	products = list(
		// BACKPACKS
		/obj/item/storage/backpack/marine = round(scale * 15),
		/obj/item/storage/backpack/marine/engineerpack = round(scale * 2),
		/obj/item/storage/backpack/marine/engineerpack/flamethrower/kit = round(scale * 2),

		// BELTS
		/obj/item/storage/sparepouch = round(scale * 2),
		/obj/item/storage/belt/marine = round(scale * 15),
		/obj/item/storage/belt/gun/m4a3 = round(scale * 10),
		/obj/item/storage/belt/gun/smartpistol = round(scale * 10),
		/obj/item/storage/large_holster/m39 = round(scale * 5),
		/obj/item/storage/belt/gun/m44 = round(scale * 5),
		/obj/item/storage/belt/shotgun = round(scale * 10),

		// WEBBINGS
		/obj/item/clothing/accessory/storage/black_vest/brown_vest = round(scale * 2),
		/obj/item/clothing/accessory/storage/webbing = round(scale * 5),

		// POUCHES
		/obj/item/storage/pouch/construction = round(scale * 2),
		/obj/item/storage/pouch/document/small = round(scale * 2),
		/obj/item/storage/pouch/explosive = round(scale * 2),
		/obj/item/storage/pouch/firstaid/full = round(scale * 5),
		/obj/item/storage/pouch/flare/full = round(scale * 5),
		/obj/item/storage/pouch/flamertank = round(scale * 4),
		/obj/item/storage/pouch/magazine = round(scale * 5),
		/obj/item/storage/pouch/medical = round(scale * 2),
		/obj/item/storage/pouch/general/medium = round(scale * 2),
		/obj/item/storage/pouch/medkit = round(scale * 2),
		/obj/item/storage/pouch/magazine/pistol/large = round(scale * 5),
		/obj/item/storage/pouch/pistol = round(scale * 15),
		/obj/item/storage/pouch/syringe = round(scale * 2),
		/obj/item/storage/pouch/tools = round(scale * 2),

		// FIREARMS
		/obj/item/weapon/gun/pistol/m4a3 = round(scale * 10),
		/obj/item/weapon/gun/pistol/mod88 = round(scale * 10),
		/obj/item/weapon/gun/revolver/m44 = round(scale * 10),
		/obj/item/weapon/gun/pistol/smart = round(scale * 6),
		/obj/item/weapon/gun/rifle/l42a = round(scale * 20),
		/obj/item/weapon/gun/shotgun/pump = round(scale * 10),
		/obj/item/weapon/gun/smg/m39 = round(scale * 15),
		/obj/item/weapon/gun/rifle/m41a = round(scale * 20),

		// KITS
		/obj/item/storage/box/kit/exp_trooper = round(scale * 4),
		/obj/item/storage/box/kit/mini_jtac = round(scale * 4),
		/obj/item/storage/box/kit/heavy_support = round(scale * 4),
		/obj/item/storage/box/kit/mini_intel = round(scale * 4),
		/obj/item/storage/box/kit/pursuit = round(scale * 4),
		/obj/item/storage/box/kit/mou53_sapper = round(scale * 3),

		// EXPLOSIVES
		/obj/item/explosive/grenade/HE/m15 = round(scale * 2),
		/obj/item/explosive/mine = round(scale * 2),
		/obj/item/storage/box/nade_box = round(scale * 1),
		/obj/item/storage/box/nade_box/frag = round(scale * 2),
		/obj/item/explosive/grenade/incendiary = round(scale * 2),
		/obj/item/explosive/grenade/smokebomb = round(scale * 5),

		// MISCELLANEOUS
		/obj/item/device/flashlight/combat = round(scale * 5),
		/obj/item/tool/shovel/etool = round(scale * 4),
		/obj/item/storage/box/m94/signal = round(scale * 2),
		/obj/item/storage/box/m94 = round(scale * 10),
		/obj/item/folding_barricade = round(scale * 4)
	)

	contraband = list()

	premium = list()

	//Rebuild the vendor's inventory to make our changes apply
	build_inventory(products)

/obj/structure/machinery/vending/marine/cargo_guns/wo

/obj/structure/machinery/vending/marine/cargo_guns/wo/populate_product_list(var/scale)
	//Forcefully reset the product list
	product_records = list()

	products = list(
		/obj/item/storage/backpack/marine = round(scale * 10),
		/obj/item/storage/belt/marine = round(scale * 10),
		/obj/item/storage/belt/shotgun = round(scale * 10),
		/obj/item/clothing/accessory/storage/webbing = round(scale * 5),
		/obj/item/clothing/accessory/storage/black_vest/brown_vest = round(scale * 5),
		/obj/item/clothing/accessory/holster = round(scale * 5),
		/obj/item/storage/belt/gun/m4a3 = round(scale * 10),
		/obj/item/storage/belt/gun/m44 = round(scale * 5),
		/obj/item/storage/large_holster/m39 = round(scale * 5),
		/obj/item/storage/pouch/general/medium = round(scale * 3),
		/obj/item/storage/pouch/construction = round(scale * 3),
		/obj/item/storage/pouch/document/small = round(scale * 3),
		/obj/item/storage/pouch/tools = round(scale * 3),
		/obj/item/storage/pouch/explosive = round(scale * 1),
		/obj/item/storage/pouch/syringe = round(scale * 1),
		/obj/item/storage/pouch/medical = round(scale * 1),
		/obj/item/storage/pouch/medkit = round(scale * 1),
		/obj/item/storage/pouch/magazine = round(scale * 1),
		/obj/item/storage/pouch/flare/full = round(scale * 5),
		/obj/item/storage/pouch/firstaid/full = round(scale * 5),
		/obj/item/storage/pouch/pistol = round(scale * 10),
		/obj/item/storage/pouch/bayonet = round(scale * 1),
		/obj/item/storage/pouch/magazine/pistol/large = round(scale * 3),
		/obj/item/weapon/gun/pistol/m4a3 = round(scale * 5),
		/obj/item/weapon/gun/pistol/smart = round(scale * 6),
		/obj/item/weapon/gun/revolver/m44 = round(scale * 5),
		/obj/item/weapon/gun/smg/m39 = round(scale * 10),
		/obj/item/weapon/gun/rifle/m41aMK1 = round(scale * 5),
		/obj/item/weapon/gun/rifle/m41a = round(scale * 10),
		/obj/item/weapon/gun/shotgun/pump = round(scale * 5),
		/obj/item/weapon/gun/shotgun/combat = round(scale * 3),
		/obj/item/explosive/mine = round(scale * 5),
		/obj/item/explosive/grenade/HE = round(scale * 1),
		/obj/item/explosive/grenade/HE = round(scale * 1),
		/obj/item/explosive/grenade/incendiary = round(scale * 1),
		/obj/item/explosive/grenade/smokebomb = round(scale * 1),
		/obj/item/storage/box/m94 = round(scale * 10),
		/obj/item/device/flashlight/combat = round(scale * 15),
	)

	contraband = list()

	premium = list()

/obj/structure/machinery/vending/marine/cargo_guns/select_gamemode_equipment(gamemode)
	return

/obj/structure/machinery/vending/marine/cargo_guns/New()
	..()
	cargo_guns_vendors.Add(src)
	marine_vendors.Remove(src)

/obj/structure/machinery/vending/marine/cargo_guns/Dispose()
	. = ..()
	cargo_guns_vendors.Remove(src)

/obj/structure/machinery/vending/marine/cargo_ammo
	name = "\improper ColMarTech automated munition vendor"
	desc = "A automated rack hooked up to a small supply of ammo magazines."
	hacking_safety = 1
	wrenchable = FALSE
	req_access = list(ACCESS_MARINE_CARGO)
	products = list()
	contraband = list()
	premium = list()

/obj/structure/machinery/vending/marine/cargo_ammo/populate_product_list(var/scale)
	//Forcefully reset the product list
	product_records = list()

	products = list(
		// REGULAR AMMO
		/obj/item/ammo_magazine/shotgun/buckshot = round(scale * 10) % 3,
		/obj/item/ammo_magazine/shotgun/flechette = round(scale * 5) % 12,
		/obj/item/ammo_magazine/shotgun/slugs = round(scale * 15) % 3,
		/obj/item/ammo_magazine/pistol = round(scale * 20),
		/obj/item/ammo_magazine/revolver = round(scale * 20),
		/obj/item/ammo_magazine/smg/m39 = round(scale * 20) % 12,
		/obj/item/ammo_magazine/rifle = round(scale * 30) % 10,
		/obj/item/ammo_magazine/smartgun = round(scale * 2),
		// AP AMMO
		/obj/item/ammo_magazine/rifle/l42a/ap = round(scale * 1),
		/obj/item/ammo_magazine/smg/m39/ap = round(scale * 5) % 12,
		/obj/item/ammo_magazine/rifle/ap = round(scale * 10) % 10,

		// EXTENDED AMMO
		/obj/item/ammo_magazine/smg/m39/extended = round(scale * 10) % 10,
		/obj/item/ammo_magazine/rifle/extended = round(scale * 10) % 8,

		// SPECIAL AMMO
		/obj/item/ammo_magazine/pistol/smart = round(scale * 12),
		/obj/item/ammo_magazine/revolver/heavy = round(scale * 10),

		// AMMO BOXES
		/obj/item/ammo_box/magazine/l42a = round(scale * 10) % 10,
		/obj/item/ammo_box/magazine/l42a/ap = round(scale * 1),
		/obj/item/ammo_box/magazine/m39 = round(scale * 20 / 12),
		/obj/item/ammo_box/magazine/m39/ap = round(scale * 5 / 12),
		/obj/item/ammo_box/magazine/m39/ext = round(scale * 10 / 10),
		/obj/item/ammo_box/magazine = round(scale * 30 / 10),
		/obj/item/ammo_box/magazine/ap = round(scale * 10 / 10),
		/obj/item/ammo_box/magazine/ext = round(scale * 10 / 8),
		/obj/item/ammo_box/magazine/shotgun/buckshot = round(scale * 10 / 3),
		/obj/item/ammo_box/magazine/shotgun = round(scale * 15 / 3),
		/obj/item/ammo_box/magazine/shotgun/flechette = round(scale * 5 / 12),

		// MISCELLANEOUS
		/obj/item/storage/large_holster/machete/full = round(scale * 10),
		/obj/item/ammo_magazine/flamer_tank = round(scale * 2),
		/obj/item/smartgun_powerpack = round(scale * 2),
		/obj/item/ammo_magazine/smartgun = round(scale * 2)
	)

	contraband = list()

	premium = list()

	//Rebuild the vendor's inventory to make our changes apply
	build_inventory(products)

/obj/structure/machinery/vending/marine/cargo_ammo/wo

/obj/structure/machinery/vending/marine/cargo_ammo/wo/populate_product_list(var/scale)
	//Forcefully reset the product list
	product_records = list()

	products = list(
		/obj/item/storage/large_holster/machete/full = round(scale * 6),
		/obj/item/ammo_magazine/pistol = round(scale * 10),
		/obj/item/ammo_magazine/pistol/incendiary = round(scale * 1),
		/obj/item/ammo_magazine/revolver = round(scale * 10),
		/obj/item/ammo_magazine/revolver/marksman = round(scale * 2),
		/obj/item/ammo_magazine/smg/m39 = round(scale * 15),
		/obj/item/ammo_magazine/smg/m39/ap = round(scale * 5),
		/obj/item/ammo_magazine/smg/m39/extended = round(scale * 1),
		/obj/item/ammo_magazine/rifle = round(scale * 15),
		/obj/item/ammo_magazine/rifle/extended = round(scale * 3),
		/obj/item/ammo_magazine/rifle/incendiary = round(scale * 3),
		/obj/item/ammo_magazine/rifle/l42a/incendiary = round(scale * 3),
		/obj/item/ammo_magazine/rifle/ap = round(scale * 10),
		/obj/item/ammo_magazine/rifle/m4ra = round(scale * 1),
		/obj/item/ammo_magazine/rifle/m41aMK1 = round(scale * 20),
		/obj/item/ammo_magazine/rifle/lmg = round(scale * 5),
		/obj/item/ammo_magazine/shotgun/slugs = round(scale * 5),
		/obj/item/ammo_magazine/shotgun/buckshot = round(scale * 5),
		/obj/item/ammo_magazine/shotgun/flechette = round(scale * 5),
		/obj/item/ammo_magazine/sniper = round(scale * 1),
		/obj/item/ammo_magazine/sniper/incendiary = round(scale * 1),
		/obj/item/ammo_magazine/sniper/flak = round(scale * 1),
		/obj/item/smartgun_powerpack = round(scale * 5),
		/obj/item/ammo_magazine/smartgun = round(scale * 5)
	)

/obj/structure/machinery/vending/marine/cargo_ammo/select_gamemode_equipment(gamemode)
	return

/obj/structure/machinery/vending/marine/cargo_ammo/New()
	..()
	cargo_ammo_vendors.Add(src)
	marine_vendors.Remove(src)

/obj/structure/machinery/vending/marine/cargo_ammo/Dispose()
	. = ..()
	cargo_ammo_vendors.Remove(src)

/obj/structure/machinery/vending/marine/cargo_ammo/squad
	name = "\improper ColMarTech automated munition squad vendor"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_RO)

/obj/structure/machinery/vending/marine/cargo_ammo/squad/populate_product_list(var/scale)
	product_records = list()

	products = list(
		/obj/item/storage/large_holster/machete/full = round(scale * 5),
		/obj/item/ammo_magazine/pistol/smart = round(scale * 4),
		/obj/item/ammo_magazine/revolver/marksman = round(scale * 3),
		/obj/item/ammo_magazine/revolver/heavy = round(scale * 5),
		/obj/item/ammo_magazine/smg/m39/ap = round(scale * 5) % 12,
		/obj/item/ammo_magazine/smg/m39/extended = round(scale * 10) % 10,
		/obj/item/ammo_magazine/rifle/extended = round(scale * 5) % 8,
		/obj/item/ammo_magazine/rifle/ap = round(scale * 5) % 10,
		/obj/item/ammo_magazine/rifle/l42a/ap = round(scale * 1),
		/obj/item/smartgun_powerpack = round(scale * 1),
		/obj/item/ammo_magazine/flamer_tank = round(scale * 1)
	)

	contraband = list()

	premium = list()

	build_inventory(products)


//MARINE FOOD VENDOR APOPHIS775 23DEC2017
/obj/structure/machinery/vending/marineFood
	name = "\improper Marine Food and Drinks Vendor"
	desc = "Standard Issue Food and Drinks Vendor, containing standard military food and drinks."
	icon_state = "generic"
	icon_deny = "generic-deny"
	wrenchable = FALSE
	products = list(/obj/item/reagent_container/food/snacks/protein_pack = 50,
					/obj/item/reagent_container/food/snacks/mre_pack/meal1 = 15,
					/obj/item/reagent_container/food/snacks/mre_pack/meal2 = 15,
					/obj/item/reagent_container/food/snacks/mre_pack/meal3 = 15,
					/obj/item/reagent_container/food/snacks/mre_pack/meal4 = 15,
					/obj/item/reagent_container/food/snacks/mre_pack/meal5 = 15,
					/obj/item/reagent_container/food/snacks/mre_pack/meal6 = 15,
					/obj/item/reagent_container/food/drinks/flask = 5)
//Christmas inventory
/*
					/obj/item/reagent_container/food/snacks/mre_pack/xmas1 = 25,
					/obj/item/reagent_container/food/snacks/mre_pack/xmas2 = 25,
					/obj/item/reagent_container/food/snacks/mre_pack/xmas3 = 25)*/
	contraband = list(/obj/item/reagent_container/food/drinks/flask/marine = 10)
	vend_delay = 15
	//product_slogans = "Standard Issue Marine food!;It's good for you, and not the worst thing in the world.;Just fucking eat it.;"
	product_ads = "Try the cornbread.;Try the pizza.;Try the pasta.;Try the tofu, wimp.;Try the pork."
	req_access = list()


/obj/structure/machinery/cm_vending/sorted/medical/blood/antag
	req_access = list(ACCESS_ILLEGAL_PIRATE)

/obj/structure/machinery/vending/marine_medic
	name = "\improper ColMarTech Medic Vendor"
	desc = "A marine medic equipment vendor"
	product_ads = "They were gonna die anyway.;Let's get space drugged!"
	req_access = list(ACCESS_MARINE_MEDPREP)
	icon_state = "medicprepvendor"
	icon_deny = "medicprepvendor-deny"
	wrenchable = FALSE

	products = list(
						/obj/item/clothing/under/marine/medic = 4,
						/obj/item/clothing/head/helmet/marine/medic = 4,
						/obj/item/storage/backpack/marine/medic = 4,
						/obj/item/storage/backpack/marine/satchel/medic = 4,
						/obj/item/device/encryptionkey/med = 4,
						/obj/item/storage/belt/medical/full = 4,
						/obj/item/bodybag/cryobag = 4,
						/obj/item/device/healthanalyzer = 4,
						/obj/item/clothing/glasses/hud/health = 4,
						/obj/item/storage/firstaid/regular = 4,
						/obj/item/storage/firstaid/adv = 4,
						/obj/item/storage/pouch/medical = 4,
						/obj/item/storage/pouch/medkit = 4,
						/obj/item/storage/pouch/magazine = 4,
						/obj/item/storage/pouch/pistol = 4,
					)
	contraband = list(/obj/item/reagent_container/blood/OMinus = 1)

/obj/structure/machinery/vending/marine_smartgun
	name = "\improper ColMarTech Smartgun Vendor"
	desc = "A marine smartgun equipment vendor"
	hacking_safety = 1
	product_ads = "If it moves, it's hostile!;How many enemies have you killed today?;Shoot first, perform autopsy later!;Your ammo is right here.;Guns!;Die, scumbag!;Don't shoot me bro!;Shoot them, bro.;Why not have a donut?"
	req_access = list(ACCESS_MARINE_SMARTPREP)
	icon_state = "boozeomat"
	icon_deny = "boozeomat-deny"
	wrenchable = FALSE

	products = list(
						/obj/item/clothing/accessory/storage/webbing = 1,
						/obj/item/storage/box/m56_system = 1,
						/obj/item/smartgun_powerpack = 1,
						/obj/item/storage/pouch/magazine = 1,
						/obj/item/storage/belt/gun/smartgunner/full = 1
			)
	contraband = list()
	premium = list()
	prices = list()

/obj/structure/machinery/vending/marine_leader
	name = "\improper ColMarTech Leader Vendor"
	desc = "A marine leader equipment vendor"
	hacking_safety = 1
	product_ads = "If it moves, it's hostile!;How many enemies have you killed today?;Shoot first, perform autopsy later!;Your ammo is right here.;Guns!;Die, scumbag!;Don't shoot me bro!;Shoot them, bro.;Why not have a donut?"
	req_access = list(ACCESS_MARINE_LEADER)
	icon_state = "tool"
	icon_deny = "tool-deny"
	wrenchable = FALSE

	products = list(
						/obj/item/clothing/suit/storage/marine/leader = 1,
						/obj/item/clothing/head/helmet/marine/leader = 1,
						/obj/item/clothing/accessory/storage/webbing = 1,
						/obj/item/explosive/plastique = 1,
						/obj/item/explosive/grenade/smokebomb = 3,
						/obj/item/device/binoculars/range/designator = 1,
						/obj/item/device/motiondetector = 1,
						/obj/item/storage/backpack/marine/satchel = 2,
						/obj/item/weapon/gun/flamer = 2,
						/obj/item/ammo_magazine/flamer_tank = 8,
						/obj/item/storage/pouch/flamertank = 2,
						/obj/item/storage/pouch/magazine/large = 1,
						/obj/item/storage/pouch/general/large = 1,
						/obj/item/storage/pouch/pistol = 1,
						/obj/item/device/whistle = 1,
						/obj/item/storage/box/zipcuffs = 2
					)

/obj/structure/machinery/vending/marine_leader/select_gamemode_equipment(gamemode)
	var/products2[]
	switch(map_tag)
		if(MAP_ICE_COLONY)
			products2 = list( /obj/item/map/ice_colony_map = 3)
		if(MAP_BIG_RED)
			products2 = list(/obj/item/map/big_red_map = 3)
		if(MAP_WHISKEY_OUTPOST)
			products2 = list(/obj/item/map/whiskey_outpost_map = 3)
		if(MAP_LV_624)
			products2 = list(/obj/item/map/lazarus_landing_map = 3)
		if(MAP_DESERT_DAM)
			products2 = list(/obj/item/map/desert_dam = 3)
		if (MAP_SOROKYNE_STRATA)
			products2 = list(/obj/item/map/sorokyne_map = 3)
	build_inventory(products2)



/obj/structure/machinery/vending/attachments
	name = "\improper Armat Systems Attachments Vendor"
	desc = "A subsidiary-owned vendor of weapon attachments. This can only be accessed by the Requisitions Officer and Cargo Techs."
	hacking_safety = 1
	product_ads = "If it moves, it's hostile!;How many enemies have you killed today?;Shoot first, perform autopsy later!;Your ammo is right here.;Guns!;Die, scumbag!;Don't shoot me bro!;Shoot them, bro.;Why not have a donut?"
	req_access = list(ACCESS_MARINE_CARGO)
	icon_state = "robotics"
	icon_deny = "robotics-deny"
	wrenchable = FALSE

	products = list()


/obj/structure/machinery/vending/attachments/proc/populate_product_list(scale)
	//Forcefully reset the product list
	product_records = list()

	products = list(
		// MUZZLE
		/obj/item/attachable/bayonet = round(scale * 10),
		/obj/item/attachable/heavy_barrel = round(scale * 2),
		/obj/item/attachable/extended_barrel = round(scale * 6),
		/obj/item/attachable/compensator = round(scale * 6),
		/obj/item/attachable/suppressor = round(scale * 6),

		// RAIL
		/obj/item/attachable/scope/mini_iff = round(scale * 2)+1,
		/obj/item/attachable/magnetic_harness = round(scale * 6),
		/obj/item/attachable/quickfire = round(scale * 4),
		/obj/item/attachable/flashlight = round(scale * 10),
		/obj/item/attachable/scope/mini = round(scale * 4),
		/obj/item/attachable/reddot = round(scale * 9),
		/obj/item/attachable/reflex = round(scale * 9),
		/obj/item/attachable/scope = round(scale * 4),

		// UNDERBARREL
		/obj/item/attachable/angledgrip = round(scale * 6),
		/obj/item/attachable/bipod = round(scale * 6),
		/obj/item/attachable/burstfire_assembly = round(scale * 3),
		/obj/item/attachable/gyro = round(scale * 4),
		/obj/item/attachable/lasersight = round(scale * 9),
		/obj/item/attachable/attached_gun/flamer = round(scale * 4),
		/obj/item/attachable/attached_gun/shotgun = round(scale * 4),
		/obj/item/attachable/attached_gun/grenade = round(scale * 5),
		/obj/item/attachable/flashlight/grip = round(scale * 9),
		/obj/item/attachable/verticalgrip = round(scale * 9),

		// STOCK
		/obj/item/attachable/stock/carbine = round(scale * 4),
		/obj/item/attachable/stock/shotgun = round(scale * 4),
		/obj/item/attachable/stock/rifle = round(scale * 4),
		/obj/item/attachable/stock/revolver = round(scale * 4),
		/obj/item/attachable/stock/smg/brace = round(scale * 2) + 1,
		/obj/item/attachable/stock/smg/collapsible = round(scale * 2) + 1,
		/obj/item/attachable/stock/smg = round(scale * 2) + 1
	)

	//Rebuild the vendor's inventory to make our changes apply
	build_inventory(products)

/obj/structure/machinery/vending/attachments/New()
	..()
	attachment_vendors.Add(src)

/obj/structure/machinery/vending/attachments/Dispose()
	. = ..()
	attachment_vendors.Remove(src)

// Req's diagonal vending
/obj/structure/machinery/vending/attachments/req/release_item(datum/data/vending_product/R, delay_vending = 0, var/mob/living/carbon/human/user)
	set waitfor = 0
	if(delay_vending)
		use_power(vend_power_usage)
		if(icon_vend)
			flick(icon_vend,src)
		sleep(delay_vending)
	if(get_dir(src, user) & NORTHEAST)
		. = new R.product_path(get_turf(get_step(src, NORTH)))
	else if(get_dir(src, user) & SOUTHEAST)
		. = new R.product_path(get_turf(get_step(src, SOUTH)))
	else
		. = new R.product_path(get_turf(src))

/obj/structure/machinery/vending/uniform_supply
	name = "\improper ColMarTech surplus uniform vendor"
	desc = "A automated weapon rack hooked up to a colossal storage of uniforms"
	icon_state = "uniform_marine"
	icon_vend = "uniform_marine_vend"
	icon_deny = "uniform_marine"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_CARGO)
	var/squad_tag = ""

	product_ads = "If it moves, it's hostile!;How many enemies have you killed today?;Shoot first, perform autopsy later!;Your ammo is right here.;Guns!;Die, scumbag!;Don't shoot me bro!;Shoot them, bro.;Why not have a donut?"
	products = list(
					/obj/item/storage/backpack/marine = 10,
					/obj/item/storage/backpack/marine/satchel = 10,
					/obj/item/storage/belt/marine = 10,
					/obj/item/storage/belt/shotgun = 5,
					/obj/item/clothing/shoes/marine = 20,
					/obj/item/clothing/under/marine = 20,
					/obj/item/clothing/suit/storage/marine/padded = 20,
					/obj/item/clothing/suit/storage/marine/padless = 20,
					/obj/item/clothing/suit/storage/marine/padless_lines = 20,
					/obj/item/clothing/suit/storage/marine/carrier = 20,
					/obj/item/clothing/suit/storage/marine/skull = 20,
					/obj/item/clothing/suit/storage/marine/smooth = 20,
					/obj/item/clothing/suit/storage/marine/class/heavy = 10,
					/obj/item/clothing/suit/storage/marine/class/light = 10,
					/obj/item/clothing/head/helmet/marine = 20,
					/obj/item/clothing/mask/rebreather/scarf = 10,
					/obj/item/clothing/mask/gas = 20
					)

	prices = list()

/obj/structure/machinery/vending/uniform_supply/New()
	..()
	var/products2 = list(
		/obj/item/device/radio/headset/almayer = 10,
		/obj/item/clothing/gloves/marine = 10,
		//Encryption keys to slow into the headset, for customization
		/obj/item/device/encryptionkey/alpha = 5,
		/obj/item/device/encryptionkey/bravo = 5,
		/obj/item/device/encryptionkey/charlie = 5,
		/obj/item/device/encryptionkey/delta = 5,
		/obj/item/device/encryptionkey/req = 5,
		/obj/item/device/encryptionkey/engi = 5,
	)

	switch(squad_tag)
		if("Alpha")
			products2 = list(/obj/item/device/radio/headset/almayer/marine/alpha = 20,
							/obj/item/clothing/gloves/marine/alpha = 10)
		if("Bravo")
			products2 = list(/obj/item/device/radio/headset/almayer/marine/bravo = 20,
							/obj/item/clothing/gloves/marine/bravo = 10)
		if("Charlie")
			products2 = list(/obj/item/device/radio/headset/almayer/marine/charlie = 20,
							/obj/item/clothing/gloves/marine/charlie = 10)
		if("Delta")
			products2 = list(/obj/item/device/radio/headset/almayer/marine/delta = 20,
							/obj/item/clothing/gloves/marine/delta = 10)

	build_inventory(products2)
	marine_vendors.Add(src)


/obj/structure/machinery/vending/uniform_supply/Dispose()
	. = ..()
	marine_vendors.Remove(src)
