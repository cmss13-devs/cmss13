/obj/structure/machinery/cm_vending/gear/engi
	vendor_role = JOB_SQUAD_ENGI
	req_access = list(ACCESS_MARINE_ENGPREP)

	listed_products = list(
		list("ENGINEER SET (Mandatory)", 0, null, null, null),
		list("Essential Engineer Set", 0, /obj/effect/essentials_set/engi, MARINE_CAN_BUY_ESSENTIALS, "white"),

		list("HANDHELD DEFENSE (choose 1)", 0, null, null, null),
		list("UA 571-C sentry gun", 0, /obj/item/defenses/handheld/sentry, MARINE_CAN_BUY_MASK, "black"),
		list("UA 42-F sentry flamer", 0, /obj/item/defenses/handheld/sentry/flamer, MARINE_CAN_BUY_MASK, "black"),
		list("21S tesla coil", 0, /obj/item/defenses/handheld/tesla_coil, MARINE_CAN_BUY_MASK, "black"),
		list("R-1NG bell tower", 0, /obj/item/defenses/handheld/bell_tower, MARINE_CAN_BUY_MASK, "black"),
		list("JIMA planted flag", 0, /obj/item/defenses/handheld/planted_flag, MARINE_CAN_BUY_MASK, "black"),

		list("ENGINEER SUPPLIES", 0, null, null, null),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, "orange"),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, "orange"),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, "orange"),
		list("Airlock electronics", 2, /obj/item/circuitboard/airlock, null, "black"),
		list("Entrenching tool", 2, /obj/item/tool/shovel/etool, null, "black"),
		list("Fire extinguisher (portable)", 5, /obj/item/tool/extinguisher/mini, null, "black"),
		list("High capacity powercell", 3, /obj/item/cell/high, null, "black"),
		list("Incendiary grenade", 6, /obj/item/explosive/grenade/incendiary, null, "black"),
		list("M20 mine box", 18, /obj/item/storage/box/explosive_mines, null, "black"),
		list("Multitool", 4, /obj/item/device/multitool, null, "black"),
		list("Plastique explosive", 5, /obj/item/explosive/plastique, null, "black"),
		list("Power control module", 2, /obj/item/circuitboard/apc, null, "black"),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, "black"),

		list("AMMUNITION", 0, null, null, null),
		list("M39 AP magazine (10x20mm)", 6, /obj/item/ammo_magazine/smg/m39/ap , null, "black"),
		list("M39 extended magazine (10x20mm)", 6, /obj/item/ammo_magazine/smg/m39/extended , null, "black"),
		list("M40 HEDP grenade", 9, /obj/item/explosive/grenade/HE, null, "black"),
		list("M41A AP magazine (10x24mm)", 6, /obj/item/ammo_magazine/rifle/ap , null, "black"),
		list("M41A extended magazine (10x24mm)", 6, /obj/item/ammo_magazine/rifle/extended , null, "black"),
		list("L42A AP magazine (10x24mm)", 6, /obj/item/ammo_magazine/rifle/l42a/ap, null, "black"),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled grip", 6, /obj/item/attachable/angledgrip, null, "black"),
		list("Extended barrel", 6, /obj/item/attachable/extended_barrel, null, "black"),
		list("Gyroscopic stabilizer", 6, /obj/item/attachable/gyro, null, "black"),
		list("L42A synthetic stock", 6, /obj/item/attachable/stock/carbine, null, "black"),
		list("Laser sight", 6, /obj/item/attachable/lasersight, null, "black"),
		list("Masterkey shotgun", 6, /obj/item/attachable/attached_gun/shotgun, null, "black"),
		list("M37 wooden stock", 6, /obj/item/attachable/stock/shotgun, null, "black"),
		list("M41A solid stock", 6, /obj/item/attachable/stock/rifle, null, "black"),
		list("Quickfire adapter", 6, /obj/item/attachable/quickfire, null, "black"),
		list("Recoil compensator", 6, /obj/item/attachable/compensator, null, "black"),
		list("Red-dot sight", 6, /obj/item/attachable/reddot, null, "black"),
		list("Reflex sight", 6, /obj/item/attachable/reflex, null, "black"),
		list("Submachinegun stock", 6, /obj/item/attachable/stock/smg, null, "black"),
		list("Suppressor", 6, /obj/item/attachable/suppressor, null, "black"),
		list("Vertical grip", 6, /obj/item/attachable/verticalgrip, null, "black"),
	)


/obj/structure/machinery/cm_vending/clothing/engi
	req_access = list(ACCESS_MARINE_ENGPREP)
	vendor_role = JOB_SQUAD_ENGI

	listed_products = list(
		list("STANDARD EQUIPMENT (take all)", 0, null, null, null),
		list("Uniform", 0, /obj/item/clothing/under/marine/engineer, MARINE_CAN_BUY_UNIFORM, "white"),
		list("Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, "white"),
		list("Helmet", 0, /obj/item/clothing/head/helmet/marine/tech, MARINE_CAN_BUY_HELMET, "white"),
		list("Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, "white"),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/marine, MARINE_CAN_BUY_EAR, "white"),
		list("Welding glasses", 0, /obj/item/clothing/glasses/welding, MARINE_CAN_BUY_GLASSES, "white"),
		list("MRE", 0, /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, "white"),

		list("ARMOR (choose 1)", 0, null, null, null),
		list("Light armor", 0, /obj/item/clothing/suit/storage/marine/class/light, MARINE_CAN_BUY_ARMOR, "white"),
		list("Medium armor", 0, /obj/item/clothing/suit/storage/marine, MARINE_CAN_BUY_ARMOR, "white"),
		list("Heavy armor", 0, /obj/item/clothing/suit/storage/marine/class/heavy, MARINE_CAN_BUY_ARMOR, "white"),

		list("BACKPACK (choose 1)", 0, null, null, null),
		list("Satchel", 0, /obj/item/storage/backpack/marine/satchel/tech, MARINE_CAN_BUY_BACKPACK, "orange"),
		list("Backpack", 0, /obj/item/storage/backpack/marine/tech, MARINE_CAN_BUY_BACKPACK, "black"),
		list("Machete scabbard", 0, /obj/item/storage/large_holster/machete/full, MARINE_CAN_BUY_BACKPACK, "black"),
		list("Shotgun scabbard", 0, /obj/item/storage/large_holster/m37, MARINE_CAN_BUY_BACKPACK, "black"),
		list("Welderpack", 0, /obj/item/storage/backpack/marine/engineerpack, MARINE_CAN_BUY_BACKPACK, "black"),

		list("BELT (choose 1)", 0, null, null, null),
		list("Tool belt", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, "orange"),

		list("POUCHES (choose 2)", 0, null, null, null),
		list("Construction pouch", 0, /obj/item/storage/pouch/construction, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "orange"),
		list("Firstaid pouch", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "orange"),
		list("Electronics pouch", 0, /obj/item/storage/pouch/electronics/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Explosive pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Flare pouch", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Large pistol magazine pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Magazine pouch", 0, /obj/item/storage/pouch/magazine, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Medium general pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Pistol pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Tools pouch", 0, /obj/item/storage/pouch/tools/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),

		list("ACCESSORIES", 0, null, null, null),
		list("Shoulder holster", 0, /obj/item/clothing/accessory/holster, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Brown webbing vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Black webbing vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, "black"),
	)

/obj/structure/machinery/cm_vending/clothing/engi/alpha
	squad_tag = SQUAD_NAME_1
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_ALPHA)
	gloves_type = /obj/item/clothing/gloves/marine/alpha/insulated
	headset_type = /obj/item/device/radio/headset/almayer/marine/alpha/engi

/obj/structure/machinery/cm_vending/clothing/engi/bravo
	squad_tag = SQUAD_NAME_2
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_BRAVO)
	gloves_type = /obj/item/clothing/gloves/marine/bravo/insulated
	headset_type = /obj/item/device/radio/headset/almayer/marine/bravo/engi

/obj/structure/machinery/cm_vending/clothing/engi/charlie
	squad_tag = SQUAD_NAME_3
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_CHARLIE)
	gloves_type = /obj/item/clothing/gloves/marine/charlie/insulated
	headset_type = /obj/item/device/radio/headset/almayer/marine/charlie/engi

/obj/structure/machinery/cm_vending/clothing/engi/delta
	squad_tag = SQUAD_NAME_4
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_DELTA)
	gloves_type = /obj/item/clothing/gloves/marine/delta/insulated
	headset_type = /obj/item/device/radio/headset/almayer/marine/delta/engi