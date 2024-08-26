//------------GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_gear_spec, list(
		list("WEAPONS SPECIALIST SETS (CHOOSE 1)", 0, null, null, null),
		list("Demolitionist Set", 0, /obj/item/storage/box/spec/demolitionist, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("Heavy Grenadier Set", 0, /obj/item/storage/box/spec/heavy_grenadier, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("Pyro Set", 0, /obj/item/storage/box/spec/pyro, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("Scout Set", 0, /obj/item/storage/box/spec/scout, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("Sniper Set", 0, /obj/item/storage/box/spec/sniper, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_RECOMMENDED),
		list("Anti-Materiel Sniper Set", 0, /obj/item/storage/box/spec/sniper/anti_materiel, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_RECOMMENDED),

		list("EXTRA SCOUT AMMUNITION", 0, null, null, null),
		list("A19 High Velocity Impact Magazine (10x24mm)", 40, /obj/item/ammo_magazine/rifle/m4ra/custom/impact, null, VENDOR_ITEM_REGULAR),
		list("A19 High Velocity Incendiary Magazine (10x24mm)", 40, /obj/item/ammo_magazine/rifle/m4ra/custom/incendiary, null, VENDOR_ITEM_REGULAR),
		list("A19 High Velocity Magazine (10x24mm)", 40, /obj/item/ammo_magazine/rifle/m4ra/custom, null, VENDOR_ITEM_REGULAR),

		list("EXTRA SNIPER AMMUNITION", 0, null, null, null),
		list("M42A Flak Magazine (10x28mm)", 40, /obj/item/ammo_magazine/sniper/flak, null, VENDOR_ITEM_REGULAR),
		list("M42A Incendiary Magazine (10x28mm)", 40, /obj/item/ammo_magazine/sniper/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M42A Marksman Magazine (10x28mm Caseless)", 40, /obj/item/ammo_magazine/sniper, null, VENDOR_ITEM_REGULAR),
		list("XM43E1 Marksman Magazine (10x99mm Caseless)", 40, /obj/item/ammo_magazine/sniper/anti_materiel, null, VENDOR_ITEM_REGULAR),

		list("EXTRA DEMOLITIONIST AMMUNITION", 0, null, null, null),
		list("84mm Anti-Armor Rocket", 40, /obj/item/ammo_magazine/rocket/ap, null, VENDOR_ITEM_REGULAR),
		list("84mm High-Explosive Rocket", 40, /obj/item/ammo_magazine/rocket, null, VENDOR_ITEM_REGULAR),
		list("84mm White-Phosphorus Rocket", 40, /obj/item/ammo_magazine/rocket/wp, null, VENDOR_ITEM_REGULAR),

		list("EXTRA GRENADES", 0, null, null, null),
		list("M40 HEDP Grenades x6", 40, /obj/effect/essentials_set/hedp_6_pack, null, VENDOR_ITEM_REGULAR),
		list("M40 HIDP Incendiary Grenades x6", 40, /obj/effect/essentials_set/hidp_6_pack, null, VENDOR_ITEM_REGULAR),
		list("M40 CCDP Chemical Compound Grenades x6", 40, /obj/effect/essentials_set/ccdp_6_pack, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-F Fragmentation Grenades x6", 40, /obj/effect/essentials_set/agmf_6_pack, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-I Incendiary Grenades x6", 40, /obj/effect/essentials_set/agmi_6_pack, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-S Smoke Grenades x6", 20, /obj/effect/essentials_set/agms_6_pack, null, VENDOR_ITEM_REGULAR),
		list("G2 Electroshock Grenade Pack x6", 40, /obj/effect/essentials_set/sebb_6_pack, null, VENDOR_ITEM_REGULAR),

		list("EXTRA FLAMETHROWER TANKS", 0, null, null, null),
		list("Large Incinerator Tank", 40, /obj/item/ammo_magazine/flamer_tank/large, null, VENDOR_ITEM_REGULAR),
		list("Large Incinerator Tank (B) (Green Flame)", 40, /obj/item/ammo_magazine/flamer_tank/large/B, null, VENDOR_ITEM_REGULAR),
		list("Large Incinerator Tank (X) (Blue Flame)", 40, /obj/item/ammo_magazine/flamer_tank/large/X, null, VENDOR_ITEM_REGULAR),

	))

/obj/structure/machinery/cm_vending/gear/spec
	name = "\improper ColMarTech Squad Weapons Specialist Gear Rack"
	desc = "An automated gear rack for Squad Weapons Specialists."
	icon_state = "spec_gear"
	show_points = TRUE
	use_points = FALSE
	use_snowflake_points = TRUE
	vendor_role = list(JOB_SQUAD_SPECIALIST)
	req_access = list(ACCESS_MARINE_SPECPREP)

/obj/structure/machinery/cm_vending/gear/spec/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_spec


//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_specialist, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Standard Marine Apparel", 0, list(/obj/item/clothing/under/marine, /obj/item/clothing/shoes/marine/knife, /obj/item/clothing/gloves/marine, /obj/item/device/radio/headset/almayer/marine), MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Map", 0, /obj/item/map/current_map, MARINE_CAN_BUY_KIT, VENDOR_ITEM_MANDATORY),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Backpack", 0, /obj/item/storage/backpack/marine, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Satchel", 0, /obj/item/storage/backpack/marine/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/belt/gun/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 General Revolver Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("RESTRICTED FIREARMS", 0, null, null, null),
		list("VP78 Pistol", 15, /obj/item/storage/box/guncase/vp78, null, VENDOR_ITEM_REGULAR),
		list("SU-6 Smart Pistol", 15, /obj/item/storage/box/guncase/smartpistol, null, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", 0, null, null, null),
		list("M44 Heavy Speed Loader (.44)", 10, /obj/item/ammo_magazine/revolver/heavy, null, VENDOR_ITEM_REGULAR),
		list("M44 Marksman Speed Loader (.44)", 10, /obj/item/ammo_magazine/revolver/marksman, null, VENDOR_ITEM_REGULAR),
		list("M4A3 HP Magazine", 5, /obj/item/ammo_magazine/pistol/hp, null, VENDOR_ITEM_REGULAR),
		list("M4A3 AP Magazine", 5, /obj/item/ammo_magazine/pistol/ap, null, VENDOR_ITEM_REGULAR),
		list("VP78 Magazine", 5, /obj/item/ammo_magazine/pistol/vp78, null, VENDOR_ITEM_REGULAR),
		list("SU-6 Smartpistol Magazine (.45)", 10, /obj/item/ammo_magazine/pistol/smart, null, VENDOR_ITEM_REGULAR),

		list("CLOTHING ITEMS", 0, null, null, null),
		list("Machete Scabbard (Full)", 6, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR),
		list("Machete Pouch (Full)", 15, /obj/item/storage/pouch/machete/full, null, VENDOR_ITEM_REGULAR),
		list("USCM Radio Telephone Pack", 15, /obj/item/storage/backpack/marine/satchel/rto, null, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", 5, /obj/item/storage/pouch/flamertank, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 3, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("M276 Pattern Combat Toolbelt Rig", 15, /obj/item/storage/belt/gun/utility, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector Pouch (Full)", 15, /obj/item/storage/pouch/autoinjector/full, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 10, /obj/item/device/motiondetector, null, VENDOR_ITEM_REGULAR),
		list("Data Detector", 10, /obj/item/device/motiondetector/intel, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),

		list("BINOCULARS", 0, null, null, null),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),

		list("HELMET OPTICS", 0, null, null, null),
		list("Medical Helmet Optic", 15, /obj/item/device/helmet_visor/medical, null, VENDOR_ITEM_REGULAR),
		list("Welding Visor", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_REGULAR),

		list("PAMPHLETS", 0, null, null, null),
		list("JTAC Pamphlet", 15, /obj/item/pamphlet/skill/jtac, null, VENDOR_ITEM_REGULAR),
		list("Engineering Pamphlet", 15, /obj/item/pamphlet/skill/engineer, null, VENDOR_ITEM_REGULAR),

		list("RADIO KEYS", 0, null, null, null),
		list("Engineering Radio Encryption Key", 5, /obj/item/device/encryptionkey/engi, null, VENDOR_ITEM_REGULAR),
		list("Intel Radio Encryption Key", 5, /obj/item/device/encryptionkey/intel, null, VENDOR_ITEM_REGULAR),
		list("JTAC Radio Encryption Key", 5, /obj/item/device/encryptionkey/jtac, null, VENDOR_ITEM_REGULAR),
		list("Supply Radio Encryption Key", 5, /obj/item/device/encryptionkey/req, null, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/specialist
	name = "\improper ColMarTech Squad Weapons Specialist Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Squad Weapons Specialist standard-issue equipment."
	show_points = TRUE
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

/obj/effect/essentials_set/ccdp_6_pack
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

/obj/effect/essentials_set/sebb_6_pack
	spawned_gear_list = list(
		/obj/item/explosive/grenade/sebb,
		/obj/item/explosive/grenade/sebb,
		/obj/item/explosive/grenade/sebb,
		/obj/item/explosive/grenade/sebb,
		/obj/item/explosive/grenade/sebb,
		/obj/item/explosive/grenade/sebb,
	)
