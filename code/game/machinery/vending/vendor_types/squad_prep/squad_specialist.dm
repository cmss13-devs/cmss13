//------------GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_gear_spec, list(
		list("WEAPONS SPECIALIST SETS (CHOOSE 1)", 0, null, null, null),
		list("Demolitionist Set", 0, /obj/item/storage/box/spec/demolitionist, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("Heavy Grenadier Set", 0, /obj/item/storage/box/spec/heavy_grenadier, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("Pyro Set", 0, /obj/item/storage/box/spec/pyro, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("Scout Set", 0, /obj/item/storage/box/spec/scout, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("Sniper Set", 0, /obj/item/storage/box/spec/sniper, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_RECOMMENDED),

		list("EXTRA SCOUT AMMUNITION", 0, null, null, null),
		list("A19 High Velocity Impact Magazine (10x24mm)", 15, /obj/item/ammo_magazine/rifle/m4ra/impact, null, VENDOR_ITEM_REGULAR),
		list("A19 High Velocity Incendiary Magazine (10x24mm)", 15, /obj/item/ammo_magazine/rifle/m4ra/incendiary, null, VENDOR_ITEM_REGULAR),
		list("A19 High Velocity Magazine (10x24mm)", 15, /obj/item/ammo_magazine/rifle/m4ra, null, VENDOR_ITEM_REGULAR),

		list("EXTRA SNIPER AMMUNITION", 0, null, null, null),
		list("M42A Flak Magazine (10x28mm)", 15, /obj/item/ammo_magazine/sniper/flak, null, VENDOR_ITEM_REGULAR),
		list("M42A Incendiary Magazine (10x28mm)", 15, /obj/item/ammo_magazine/sniper/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M42A Marksman Magazine (10x28mm Caseless)", 15, /obj/item/ammo_magazine/sniper, null, VENDOR_ITEM_REGULAR),

		list("EXTRA DEMOLITIONIST AMMUNITION", 0, null, null, null),
		list("84mm Anti-Armor Rocket", 15, /obj/item/ammo_magazine/rocket/ap, null, VENDOR_ITEM_REGULAR),
		list("84mm High-Explosive Rocket", 15, /obj/item/ammo_magazine/rocket, null, VENDOR_ITEM_REGULAR),
		list("84mm White-Phosphorus Rocket", 15, /obj/item/ammo_magazine/rocket/wp, null, VENDOR_ITEM_REGULAR),

		list("EXTRA GRENADES", 0, null, null, null),
		list("M40 HEDP Grenades x6", 15, /obj/effect/essentials_set/hedp_6_pack, null, VENDOR_ITEM_REGULAR),
		list("M40 HIDP Incendiary Grenades x6", 15, /obj/effect/essentials_set/hidp_6_pack, null, VENDOR_ITEM_REGULAR),
		list("M40 HPDP White Phosphorus Grenades x6", 15, /obj/effect/essentials_set/hpdp_6_pack, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-F Fragmentation Grenades x6", 15, /obj/effect/essentials_set/agmf_6_pack, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-I Incendiary Grenades x6", 15, /obj/effect/essentials_set/agmi_6_pack, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-S Smoke Grenades x6", 10, /obj/effect/essentials_set/agms_6_pack, null, VENDOR_ITEM_REGULAR),

		list("EXTRA FLAMETHROWER TANKS", 0, null, null, null),
		list("Large Incinerator Tank", 15, /obj/item/ammo_magazine/flamer_tank/large, null, VENDOR_ITEM_REGULAR),
		list("Large Incinerator Tank (B) (Green Flame)", 15, /obj/item/ammo_magazine/flamer_tank/large/B, null, VENDOR_ITEM_REGULAR),
		list("Large Incinerator Tank (X) (Blue Flame)", 15, /obj/item/ammo_magazine/flamer_tank/large/X, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("SensorMate Medical HUD", 15, /obj/item/clothing/glasses/hud/sensor, null, VENDOR_ITEM_REGULAR),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", 5, /obj/item/storage/pouch/flamertank, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 10, /obj/item/storage/pouch/sling, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector Pouch (Full)", 15, /obj/item/storage/pouch/autoinjector/full, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 10, /obj/item/device/motiondetector, null, VENDOR_ITEM_REGULAR),
		list("Machete Pouch (Full)", 15, /obj/item/storage/pouch/machete/full, null, VENDOR_ITEM_REGULAR),
		list("JTAC Pamphlet", 15, /obj/item/pamphlet/skill/jtac, null, VENDOR_ITEM_REGULAR),
		list("Engineering Pamphlet", 15, /obj/item/pamphlet/skill/engineer, null, VENDOR_ITEM_REGULAR),
		list("Powerloader Certification", 45, /obj/item/pamphlet/skill/powerloader, null, VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", 10, /obj/item/storage/pouch/shotgun/large, null, VENDOR_ITEM_REGULAR),

		list("RADIO KEYS", 0, null, null, null),
		list("Engineering Radio Encryption Key", 5, /obj/item/device/encryptionkey/engi, null, VENDOR_ITEM_REGULAR),
		list("Intel Radio Encryption Key", 5, /obj/item/device/encryptionkey/intel, null, VENDOR_ITEM_REGULAR),
		list("JTAC Radio Encryption Key", 5, /obj/item/device/encryptionkey/jtac, null, VENDOR_ITEM_REGULAR),
		list("Supply Radio Encryption Key", 5, /obj/item/device/encryptionkey/req, null, VENDOR_ITEM_REGULAR),

	))

/obj/structure/machinery/cm_vending/gear/spec
	name = "\improper ColMarTech Squad Weapons Specialist Gear Rack"
	desc = "An automated gear rack for Squad Weapons Specialists."
	icon_state = "spec_gear"
	show_points = TRUE
	vendor_role = list(JOB_SQUAD_SPECIALIST)
	req_access = list(ACCESS_MARINE_SPECPREP)

/obj/structure/machinery/cm_vending/gear/spec/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_spec


//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_specialist, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Uniform", 0, /obj/item/clothing/under/marine, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/marine, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Backpack", 0, /obj/item/storage/backpack/marine, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Satchel", 0, /obj/item/storage/backpack/marine/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/large_holster/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Large Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/specialist
	name = "\improper ColMarTech Squad Weapons Specialist Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Squad Weapons Specialist standard-issue equipment."
	req_access = list(ACCESS_MARINE_SPECPREP)
	vendor_role = list(JOB_SQUAD_SPECIALIST)

/obj/structure/machinery/cm_vending/clothing/specialist/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_specialist

/obj/structure/machinery/cm_vending/clothing/specialist/alpha
	squad_tag = SQUAD_MARINE_1
	req_access = list(ACCESS_MARINE_SPECPREP, ACCESS_MARINE_ALPHA)
	headset_type = /obj/item/device/radio/headset/almayer/marine/alpha

/obj/structure/machinery/cm_vending/clothing/specialist/bravo
	squad_tag = SQUAD_MARINE_2
	req_access = list(ACCESS_MARINE_SPECPREP, ACCESS_MARINE_BRAVO)
	headset_type = /obj/item/device/radio/headset/almayer/marine/bravo

/obj/structure/machinery/cm_vending/clothing/specialist/charlie
	squad_tag = SQUAD_MARINE_3
	req_access = list(ACCESS_MARINE_SPECPREP, ACCESS_MARINE_CHARLIE)
	headset_type = /obj/item/device/radio/headset/almayer/marine/charlie

/obj/structure/machinery/cm_vending/clothing/specialist/delta
	squad_tag = SQUAD_MARINE_4
	req_access = list(ACCESS_MARINE_SPECPREP, ACCESS_MARINE_DELTA)
	headset_type = /obj/item/device/radio/headset/almayer/marine/delta

//------------ESSENTIAL SETS---------------

/obj/effect/essentials_set/hedp_6_pack
	spawned_gear_list = list(
		/obj/item/explosive/grenade/high_explosive,
		/obj/item/explosive/grenade/high_explosive,
		/obj/item/explosive/grenade/high_explosive,
		/obj/item/explosive/grenade/high_explosive,
		/obj/item/explosive/grenade/high_explosive,
		/obj/item/explosive/grenade/high_explosive,
	)

/obj/effect/essentials_set/hefa_6_pack
	spawned_gear_list = list(
		/obj/item/explosive/grenade/high_explosive/frag,
		/obj/item/explosive/grenade/high_explosive/frag,
		/obj/item/explosive/grenade/high_explosive/frag,
		/obj/item/explosive/grenade/high_explosive/frag,
		/obj/item/explosive/grenade/high_explosive/frag,
		/obj/item/explosive/grenade/high_explosive/frag,
	)

/obj/effect/essentials_set/hidp_6_pack
	spawned_gear_list = list(
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/incendiary,
	)

/obj/effect/essentials_set/hpdp_6_pack
	spawned_gear_list = list(
		/obj/item/explosive/grenade/phosphorus,
		/obj/item/explosive/grenade/phosphorus,
		/obj/item/explosive/grenade/phosphorus,
		/obj/item/explosive/grenade/phosphorus,
		/obj/item/explosive/grenade/phosphorus,
		/obj/item/explosive/grenade/phosphorus,
	)

/obj/effect/essentials_set/agmf_6_pack
	spawned_gear_list = list(
		/obj/item/explosive/grenade/high_explosive/airburst,
		/obj/item/explosive/grenade/high_explosive/airburst,
		/obj/item/explosive/grenade/high_explosive/airburst,
		/obj/item/explosive/grenade/high_explosive/airburst,
		/obj/item/explosive/grenade/high_explosive/airburst,
		/obj/item/explosive/grenade/high_explosive/airburst,
	)

/obj/effect/essentials_set/agmi_6_pack
	spawned_gear_list = list(
		/obj/item/explosive/grenade/incendiary/airburst,
		/obj/item/explosive/grenade/incendiary/airburst,
		/obj/item/explosive/grenade/incendiary/airburst,
		/obj/item/explosive/grenade/incendiary/airburst,
		/obj/item/explosive/grenade/incendiary/airburst,
		/obj/item/explosive/grenade/incendiary/airburst,
	)

/obj/effect/essentials_set/agms_6_pack
	spawned_gear_list = list(
		/obj/item/explosive/grenade/smokebomb/airburst,
		/obj/item/explosive/grenade/smokebomb/airburst,
		/obj/item/explosive/grenade/smokebomb/airburst,
		/obj/item/explosive/grenade/smokebomb/airburst,
		/obj/item/explosive/grenade/smokebomb/airburst,
		/obj/item/explosive/grenade/smokebomb/airburst,
	)
