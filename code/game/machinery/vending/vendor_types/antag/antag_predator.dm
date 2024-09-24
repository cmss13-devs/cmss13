
GLOBAL_LIST_INIT(cm_vending_equipment_yautja, list(
		list("Essential Hunting Supplies", 0, null, null, null),
		list("Hunting Equipment", 0, list( /obj/item/clothing/shoes/yautja/hunter/knife,/obj/item/clothing/under/chainshirt/hunter, /obj/item/device/radio/headset/yautja,/obj/item/storage/medicomp/full,/obj/item/device/yautja_teleporter,/obj/item/storage/backpack/yautja), MARINE_CAN_BUY_ESSENTIALS, MARINE_CAN_BUY_UNIFORM),

		list("ARMOR", 0, null, null, null),
		list("Clan Armour", 0, /obj/item/clothing/suit/armor/yautja, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Clan Mask", 0, /obj/item/clothing/mask/gas/yautja/hunter, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("Bracer Attachments",0, null, null, null),
		list("Wrist Blades",0 /obj/item/bracer_attachments/wristblades),MARINE_CAN_BUY_ATTACHMENT,VENDOR_ITEM_MANDATORY
		list("Scimitars",0 /obj/item/bracer_attachments/scimitars),MARINE_CAN_BUY_ATTACHMENT,VENDOR_ITEM_MANDATORY

		list("Main Weapons (CHOOSE 1)", 0, null, null, null),
		list("The Piercing Hunting Sword",0,/obj/item/weapon/yautja/sword, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("The Rending Chain-Whip",0,/obj/item/weapon/yautja/chain, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("The Cleaving War-Scythe",0,/obj/item/weapon/yautja/scythe, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("The Ripping War-Scythe",0,/obj/item/weapon/yautja/scythe/alt, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("The Adaptive Combi-Stick",0,/obj/item/weapon/yautja/combistick, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("The Lumbering Glaive",0,/obj/item/weapon/twohanded/yautja/glaive, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("The Imposing Glaive",0,/obj/item/weapon/twohanded/yautja/glaive/alt, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),

		list("Secondary Equipment (CHOOSE 2)", 0, null, null, null),
		list("The Fleeting Spike Launcher",0,/obj/item/weapon/gun/launcher/spike, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Swift Plasma Pistol",0,/obj/item/weapon/gun/energy/yautja/plasmapistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Agile Drone",0,/obj/item/falcon_drone, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Purifying Smart-Disc",0,/obj/item/explosive/grenade/spawnergrenade/smartdisc, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Steadfast Shield",0,/obj/item/weapon/shield/riot/yautja, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("Clothing Accessory (CHOOSE 1)", 0, null, null, null),
		list("Third Cape",0,/obj/item/clothing/yautja_cape/third, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Half Cape",0,/obj/item/clothing/yautja_cape/half, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Qauter Cape",0,/obj/item/clothing/yautja_cape/quarter, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Poncho",0,/obj/item/clothing/yautja_cape/poncho, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

	))

GLOBAL_LIST_INIT(cm_vending_elder_yautja, list(
		list("Essential Hunting Supplies", 0, null, null, null),
		list("Hunting Equipment", 0, list( /obj/item/clothing/shoes/yautja/hunter/knife,/obj/item/clothing/under/chainshirt/hunter, /obj/item/device/radio/headset/yautja,/obj/item/storage/medicomp/full,/obj/item/device/yautja_teleporter,/obj/item/storage/backpack/yautja), MARINE_CAN_BUY_ESSENTIALS, MARINE_CAN_BUY_UNIFORM),

		list("ARMOR", 0, null, null, null),
		list("Clan Armour", 0, /obj/item/clothing/suit/armor/yautja, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Clan Mask", 0, /obj/item/clothing/mask/gas/yautja/hunter, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("Bracer Attachments",0, null, null, null),
		list("Wrist Blades",0 /obj/item/bracer_attachments/wristblades),MARINE_CAN_BUY_ATTACHMENT,VENDOR_ITEM_MANDATORY
		list("Scimitars",0 /obj/item/bracer_attachments/scimitars),MARINE_CAN_BUY_ATTACHMENT,VENDOR_ITEM_MANDATORY

		list("Main Weapons (CHOOSE 1)", 0, null, null, null),
		list("The Piercing Hunting Sword",0,/obj/item/weapon/yautja/sword, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("The Rending Chain-Whip",0,/obj/item/weapon/yautja/chain, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("The Cleaving War-Scythe",0,/obj/item/weapon/yautja/scythe, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("The Ripping War-Scythe",0,/obj/item/weapon/yautja/scythe/alt, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("The Adaptive Combi-Stick",0,/obj/item/weapon/yautja/combistick, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("The Lumbering Glaive",0,/obj/item/weapon/twohanded/yautja/glaive, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("The Imposing Glaive",0,/obj/item/weapon/twohanded/yautja/glaive/alt, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),

		list("Secondary Equipment (CHOOSE 2)", 0, null, null, null),
		list("The Fleeting Spike Launcher",0,/obj/item/weapon/gun/launcher/spike, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Swift Plasma Pistol",0,/obj/item/weapon/gun/energy/yautja/plasmapistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Agile Drone",0,/obj/item/falcon_drone, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Purifying Smart-Disc",0,/obj/item/explosive/grenade/spawnergrenade/smartdisc, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Steadfast Shield",0,/obj/item/weapon/shield/riot/yautja, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("Clothing Accessory (CHOOSE 1)", 0, null, null, null),
		list("Third Cape",0,/obj/item/clothing/yautja_cape/third, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Half Cape",0,/obj/item/clothing/yautja_cape/half, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Qauter Cape",0,/obj/item/clothing/yautja_cape/quarter, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Poncho",0,/obj/item/clothing/yautja_cape/poncho, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Ceremonial Cape",0,/obj/item/clothing/yautja_cape/ceremonial, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Full-Cape",0,/obj/item/clothing/yautja_cape, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

	))

/obj/structure/machinery/cm_vending/gear/yautja
	name = "\improper Yautja Hunting Gear Rack"
	desc = "A gear rack for hunting."
	icon_state = "gear"
	req_access = list(ACCESS_YAUTJA_SECURE)
	vendor_role = list(JOB_PREDATOR)
	show_points = FALSE

/obj/structure/machinery/cm_vending/gear/yautja/get_listed_products(mob/user)
	return GLOB.cm_vending_equipment_yautja


/obj/structure/machinery/cm_vending/gear/elder
	name = "\improper Yautja Elder Hunting Gear Rack"
	desc = "A gear rack for hunting."
	icon_state = "gear"
	req_access = list(ACCESS_YAUTJA_ELDER)
	vendor_role = list(JOB_PREDATOR)
	show_points = FALSE

/obj/structure/machinery/cm_vending/gear/elder/get_listed_products(mob/user)
	return GLOB.cm_vending_elder_yautja
