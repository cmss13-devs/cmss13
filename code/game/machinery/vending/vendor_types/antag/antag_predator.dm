GLOBAL_LIST_INIT(cm_vending_equipment_yautja, list(
		list("Essential Hunting Supplies", 0, null, null, null),
		list("Hunting Equipment", 0, list(/obj/item/clothing/under/chainshirt/hunter, /obj/item/storage/backpack/yautja, /obj/item/storage/medicomp/full, /obj/item/device/yautja_teleporter, /obj/item/tool/yautja_cleaner), MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),
		list("Armor", 0, list(/obj/item/clothing/suit/armor/yautja/hunter, /obj/item/clothing/mask/gas/yautja/hunter, /obj/item/clothing/accessory/mask, /obj/item/clothing/shoes/yautja/hunter/knife), MARINE_CAN_BUY_COMBAT_ARMOR, VENDOR_ITEM_MANDATORY),

		list("Main Weapons (CHOOSE 1)", 0, null, null, null),
		list("The Primary Hunting Sword", 0, /obj/item/weapon/yautja/sword, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Rending Hunting Sword", 0, /obj/item/weapon/yautja/sword/alt_1, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Piercing Hunting Sword", 0, /obj/item/weapon/yautja/sword/alt_2, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Severing Hunting Sword", 0, /obj/item/weapon/yautja/sword/alt_3, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Taruulan Staff", 0, /obj/item/weapon/yautja/sword/staff, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Sundering Chain-Whip", 0, /obj/item/weapon/yautja/chain, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Cleaving War-Scythe", 0, /obj/item/weapon/yautja/scythe, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Ripping War-Scythe", 0, /obj/item/weapon/yautja/scythe/alt, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Adaptive Combi-Stick", 0, /obj/item/weapon/yautja/chained/combistick, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Butchering War Axe", 0, /obj/item/weapon/yautja/chained/war_axe, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Lumbering Glaive", 0, /obj/item/weapon/twohanded/yautja/glaive, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Imposing Glaive", 0, /obj/item/weapon/twohanded/yautja/glaive/alt, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Crushing Longaxe", 0, /obj/item/weapon/twohanded/yautja/glaive/longaxe, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),

		list("Bracer Attachments", 0, null, null, null),
		list("Wrist Blades", 0,list(/obj/item/bracer_attachments/wristblades, /obj/item/bracer_attachments/wristblades), MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),
		list("The Fearsome Scimitars", 0, list(/obj/item/bracer_attachments/scimitars, /obj/item/bracer_attachments/scimitars), MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Skewering Scimitars", 0, list(/obj/item/bracer_attachments/scimitars_alt, /obj/item/bracer_attachments/scimitars_alt), MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Chain Gauntlets", 0, list(/obj/item/bracer_attachments/chain_gauntlets, /obj/item/bracer_attachments/chain_gauntlets, /obj/item/yautja/chain), MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),

		list("Secondary Equipment (CHOOSE 2)", 0, null, null, null),
		list("The Fleeting Spike Launcher", 0, /obj/item/weapon/gun/launcher/spike, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Swift Plasma Pistol", 0, /obj/item/weapon/gun/energy/yautja/plasmapistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Agile Drone", 0, /obj/item/falcon_drone, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Purifying Smart-Disc", 0, /obj/item/explosive/grenade/spawnergrenade/smartdisc, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Steadfast Shield", 0, /obj/item/weapon/shield/riot/yautja, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Formidable Plate Armor", 0, /obj/item/clothing/suit/armor/yautja/hunter/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Firm Bow", 0, /obj/item/storage/belt/gun/quiver/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("Clothing Accessory (CHOOSE 1)", 0, null, null, null),
		list("Third-Cape", 0, /obj/item/clothing/yautja_cape/third, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Half-Cape", 0, /obj/item/clothing/yautja_cape/half, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Quarter-Cape", 0, /obj/item/clothing/yautja_cape/quarter, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Poncho", 0, /obj/item/clothing/yautja_cape/poncho, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
			))

GLOBAL_LIST_INIT(cm_vending_elder_yautja, list(
		list("Essential Hunting Supplies", 0, null, null, null),
		list("Hunting Equipment", 0, list(/obj/item/clothing/under/chainshirt/hunter, /obj/item/storage/backpack/yautja, /obj/item/storage/medicomp/full, /obj/item/device/yautja_teleporter, /obj/item/tool/yautja_cleaner), MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),
		list("Armor", 0, list(/obj/item/clothing/suit/armor/yautja/hunter, /obj/item/clothing/mask/gas/yautja/hunter, /obj/item/clothing/accessory/mask, /obj/item/clothing/shoes/yautja/hunter/knife), MARINE_CAN_BUY_COMBAT_ARMOR, VENDOR_ITEM_MANDATORY),

		list("Main Weapons (CHOOSE 1)", 0, null, null, null),
		list("The Primary Hunting Sword", 0, /obj/item/weapon/yautja/sword, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Rending Hunting Sword", 0, /obj/item/weapon/yautja/sword/alt_1, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Piercing Hunting Sword", 0, /obj/item/weapon/yautja/sword/alt_2, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Severing Hunting Sword", 0, /obj/item/weapon/yautja/sword/alt_3, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Taruulan Staff", 0, /obj/item/weapon/yautja/sword/staff, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Sundering Chain-Whip", 0, /obj/item/weapon/yautja/chain, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Cleaving War-Scythe", 0, /obj/item/weapon/yautja/scythe, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Ripping War-Scythe", 0, /obj/item/weapon/yautja/scythe/alt, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Adaptive Combi-Stick", 0, /obj/item/weapon/yautja/chained/combistick, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Butchering War Axe", 0, /obj/item/weapon/yautja/chained/war_axe, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Lumbering Glaive", 0, /obj/item/weapon/twohanded/yautja/glaive, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Imposing Glaive", 0, /obj/item/weapon/twohanded/yautja/glaive/alt, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Crushing Longaxe", 0, /obj/item/weapon/twohanded/yautja/glaive/longaxe, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),

		list("Bracer Attachments", 0, null, null, null),
		list("Wrist Blades", 0,list(/obj/item/bracer_attachments/wristblades, /obj/item/bracer_attachments/wristblades), MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),
		list("The Fearsome Scimitars", 0, list(/obj/item/bracer_attachments/scimitars, /obj/item/bracer_attachments/scimitars), MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Skewering Scimitars", 0, list(/obj/item/bracer_attachments/scimitars_alt, /obj/item/bracer_attachments/scimitars_alt), MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Chain Gauntlets", 0, list(/obj/item/bracer_attachments/chain_gauntlets, /obj/item/bracer_attachments/chain_gauntlets, /obj/item/yautja/chain), MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("Secondary Equipment (CHOOSE 2)", 0, null, null, null),
		list("The Fleeting Spike Launcher", 0, /obj/item/weapon/gun/launcher/spike, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Swift Plasma Pistol", 0, /obj/item/weapon/gun/energy/yautja/plasmapistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Agile Drone", 0, /obj/item/falcon_drone, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Purifying Smart-Disc", 0, /obj/item/explosive/grenade/spawnergrenade/smartdisc, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Steadfast Shield", 0, /obj/item/weapon/shield/riot/yautja, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Gilded Warlord’s Aegis", 0, /obj/item/weapon/shield/riot/yautja/ancient, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Dread Hunter’s Bulwark", 0, /obj/item/weapon/shield/riot/yautja/ancient/alt, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Formidable Plate Armor", 0, /obj/item/clothing/suit/armor/yautja/hunter/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("The Firm Bow", 0, /obj/item/storage/belt/gun/quiver/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("Clothing Accessory (CHOOSE 1)", 0, null, null, null),
		list("Third-Cape", 0, /obj/item/clothing/yautja_cape/third, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Half-Cape", 0, /obj/item/clothing/yautja_cape/half, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Quarter-Cape", 0, /obj/item/clothing/yautja_cape/quarter, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Poncho", 0, /obj/item/clothing/yautja_cape/poncho, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Damaged-Cape", 0, /obj/item/clothing/yautja_cape/damaged, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Ceremonial Cape", 0, /obj/item/clothing/yautja_cape/ceremonial, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Full-Cape", 0, /obj/item/clothing/yautja_cape, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
			))

GLOBAL_LIST_INIT(cm_vending_young_yautja, list(
		list("Essential Hunting Supplies", 0, null, null, null),
		list("Hunting Equipment", 0, list(/obj/item/clothing/under/chainshirt/hunter, /obj/item/storage/backpack/yautja, /obj/item/storage/medicomp/full, /obj/item/device/flashlight/lantern), MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),
		list("Armor", 0, list(/obj/item/clothing/suit/armor/yautja/hunter, /obj/item/clothing/mask/gas/yautja/hunter, /obj/item/clothing/accessory/mask, /obj/item/clothing/shoes/yautja/hunter/knife), MARINE_CAN_BUY_COMBAT_ARMOR, VENDOR_ITEM_MANDATORY),

		list("Main Weapons (CHOOSE 1)", 0, null, null, null),
		list("The Primary Hunting Sword", 0, /obj/item/weapon/yautja/sword, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Rending Hunting Sword", 0, /obj/item/weapon/yautja/sword/alt_1, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Piercing Hunting Sword", 0, /obj/item/weapon/yautja/sword/alt_2, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Severing Hunting Sword", 0, /obj/item/weapon/yautja/sword/alt_3, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Sundering Chain-Whip", 0, /obj/item/weapon/yautja/chain, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Cleaving War-Scythe", 0, /obj/item/weapon/yautja/scythe, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Ripping War-Scythe", 0, /obj/item/weapon/yautja/scythe/alt, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Adaptive Combi-Stick", 0, /obj/item/weapon/yautja/chained/combistick, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Butchering War Axe", 0, /obj/item/weapon/yautja/chained/war_axe, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Lumbering Glaive", 0, /obj/item/weapon/twohanded/yautja/glaive, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Imposing Glaive", 0, /obj/item/weapon/twohanded/yautja/glaive/alt, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Crushing Longaxe", 0, /obj/item/weapon/twohanded/yautja/glaive/longaxe, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),

		list("Bracer Attachments", 0, null, null, null),
		list("Wrist Blades", 0,list(/obj/item/bracer_attachments/wristblades, /obj/item/bracer_attachments/wristblades), MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),
		list("The Fearsome Scimitars", 0, list(/obj/item/bracer_attachments/scimitars, /obj/item/bracer_attachments/scimitars), MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("The Skewering Scimitars", 0, list(/obj/item/bracer_attachments/scimitars_alt, /obj/item/bracer_attachments/scimitars_alt), MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
			))

GLOBAL_LIST_INIT(cm_vending_thrall, list(
		list("Essential Hunting Supplies", 0, null, null, null),
		list("Hunting Equipment", 0, list(/obj/item/clothing/under/chainshirt/thrall, /obj/item/storage/backpack/yautja), MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("Armor Material (CHOOSE 1)", 0, null, null, null),
		list("Ebony", 0, list(/obj/item/clothing/suit/armor/yautja/thrall, /obj/item/clothing/shoes/yautja/thrall, /obj/item/clothing/mask/gas/yautja/thrall, /obj/item/clothing/shoes/yautja/hunter/knife), MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("Silver", 0, list(/obj/item/clothing/suit/armor/yautja/thrall/silver, /obj/item/clothing/shoes/yautja/thrall/silver, /obj/item/clothing/mask/gas/yautja/thrall/silver, /obj/item/clothing/shoes/yautja/hunter/knife), MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("Gold", 0, list(/obj/item/clothing/suit/armor/yautja/thrall/gold, /obj/item/clothing/shoes/yautja/thrall/gold, /obj/item/clothing/mask/gas/yautja/thrall/gold, /obj/item/clothing/shoes/yautja/hunter/knife), MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("Crimson", 0, list(/obj/item/clothing/suit/armor/yautja/thrall/crimson, /obj/item/clothing/shoes/yautja/thrall/crimson, /obj/item/clothing/mask/gas/yautja/thrall/crimson, /obj/item/clothing/shoes/yautja/hunter/knife), MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("Bone", 0, list(/obj/item/clothing/suit/armor/yautja/thrall/bone, /obj/item/clothing/shoes/yautja/thrall/bone, /obj/item/clothing/mask/gas/yautja/thrall/bone, /obj/item/clothing/shoes/yautja/hunter/knife), MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),

		list("Main Weapons (CHOOSE 1)", 0, null, null, null),
		list("The Primary Hunting Sword", 0, /obj/item/weapon/yautja/sword, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("The Rending Hunting Sword", 0, /obj/item/weapon/yautja/sword/alt_1, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("The Piercing Hunting Sword", 0, /obj/item/weapon/yautja/sword/alt_2, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("The Severing Hunting Sword", 0, /obj/item/weapon/yautja/sword/alt_3, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("The Sundering Chain-Whip", 0, /obj/item/weapon/yautja/chain, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("The Cleaving War-Scythe", 0, /obj/item/weapon/yautja/scythe, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("The Ripping War-Scythe", 0, /obj/item/weapon/yautja/scythe/alt, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("The Adaptive Combi-Stick", 0, /obj/item/weapon/yautja/chained/combistick, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("The Butchering War Axe", 0, /obj/item/weapon/yautja/chained/war_axe, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("The Lumbering Glaive", 0, /obj/item/weapon/twohanded/yautja/glaive, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("The Imposing Glaive", 0, /obj/item/weapon/twohanded/yautja/glaive/alt, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("The Crushing Longaxe", 0, /obj/item/weapon/twohanded/yautja/glaive/longaxe, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
			))

GLOBAL_LIST_INIT(cm_vending_blooded_thrall, list(
		list("Blooded Equipment", 0, null, null, null),
		list("Blooded Equipment", 0, list(/obj/item/device/thrall_teleporter, /obj/item/storage/medicomp/full), MARINE_CAN_BUY_KIT, VENDOR_ITEM_REGULAR),

		list("Clothing Accessory (CHOOSE 1)", 0, null, null, null),
		list("Third-Cape", 0, /obj/item/clothing/yautja_cape/third, MARINE_CAN_BUY_COMBAT_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Half-Cape", 0, /obj/item/clothing/yautja_cape/half, MARINE_CAN_BUY_COMBAT_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Quarter-Cape", 0, /obj/item/clothing/yautja_cape/quarter, MARINE_CAN_BUY_COMBAT_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Poncho", 0, /obj/item/clothing/yautja_cape/poncho, MARINE_CAN_BUY_COMBAT_ARMOR, VENDOR_ITEM_MANDATORY),
			))

/obj/structure/machinery/cm_vending/clothing/yautja/hunter
	name = "\improper Yautja Hunting Gear Rack"
	desc = "A gear rack for hunting."
	icon = 'icons/obj/items/hunter/pred_vendor.dmi'
	icon_state = "pred_vendor_left"
	req_access = list(ACCESS_YAUTJA_SECURE)
	vendor_role = list(JOB_PREDATOR)
	show_points = FALSE
	vendor_theme = VENDOR_THEME_YAUTJA

/obj/structure/machinery/cm_vending/clothing/yautja/hunter/can_access_to_vend(mob/user, display = TRUE, ignore_hack = FALSE)
	if(!allowed(user))
		if(display)
			to_chat(user, SPAN_WARNING("Access denied."))
			vend_fail()
		return FALSE

	if(LAZYLEN(vendor_role) && !vendor_role.Find(user.job))
		if(display)
			to_chat(user, SPAN_WARNING("This machine isn't for you."))
			vend_fail()
		return FALSE
	return TRUE

/obj/structure/machinery/cm_vending/clothing/yautja/hunter/left_centre
	icon_state = "pred_vendor_lcenter"

/obj/structure/machinery/cm_vending/clothing/yautja/hunter/centre
	icon_state = "pred_vendor_centre"

/obj/structure/machinery/cm_vending/clothing/yautja/hunter/right_centre
	icon_state = "pred_vendor_rcentre"

/obj/structure/machinery/cm_vending/clothing/yautja/hunter/right
	icon_state = "pred_vendor_right"

/obj/structure/machinery/cm_vending/clothing/yautja/hunter/get_listed_products(mob/user)
	return GLOB.cm_vending_equipment_yautja

/obj/structure/machinery/cm_vending/clothing/yautja/hunter/elder
	name = "\improper Yautja Elder Hunting Gear Rack"
	desc = "A gear rack for hunting."
	icon = 'icons/obj/items/hunter/pred_vendor.dmi'
	icon_state = "pred_vendor_elder_left"
	req_one_access = list(ACCESS_YAUTJA_ELITE, ACCESS_YAUTJA_ELDER, ACCESS_YAUTJA_ANCIENT)
	vendor_role = list(JOB_PREDATOR)
	show_points = FALSE
	vendor_theme = VENDOR_THEME_YAUTJA

/obj/structure/machinery/cm_vending/clothing/yautja/hunter/elder/right
	icon_state = "pred_vendor_elder_right"

/obj/structure/machinery/cm_vending/clothing/yautja/hunter/elder/get_listed_products(mob/user)
	return GLOB.cm_vending_elder_yautja

/obj/structure/machinery/cm_vending/clothing/yautja/young_blood
	name = "\improper Yautja Young Hunting Gear Rack"
	icon = 'icons/obj/items/hunter/pred_vendor.dmi'
	icon_state = "pred_vendor_left"
	req_access = list(ACCESS_YAUTJA_SECURE)
	vendor_role = list(ERT_JOB_YOUNGBLOOD, JOB_PREDATOR)
	show_points = FALSE
	vendor_theme = VENDOR_THEME_YAUTJA

/obj/structure/machinery/cm_vending/clothing/yautja/young_blood/can_access_to_vend(mob/user, display = TRUE, ignore_hack = FALSE)
	if(!allowed(user))
		if(display)
			to_chat(user, SPAN_WARNING("Access denied."))
			vend_fail()
		return FALSE

	if(LAZYLEN(vendor_role) && !vendor_role.Find(user.job))
		if(display)
			to_chat(user, SPAN_WARNING("This machine isn't for you."))
			vend_fail()
		return FALSE
	return TRUE

/obj/structure/machinery/cm_vending/clothing/yautja/young_blood/left_centre
	icon_state = "pred_vendor_lcenter"

/obj/structure/machinery/cm_vending/clothing/yautja/young_blood/centre
	icon_state = "pred_vendor_centre"

/obj/structure/machinery/cm_vending/clothing/yautja/young_blood/right_centre
	icon_state = "pred_vendor_rcentre"

/obj/structure/machinery/cm_vending/clothing/yautja/young_blood/right
	icon_state = "pred_vendor_right"

/obj/structure/machinery/cm_vending/clothing/yautja/young_blood/get_listed_products(mob/user)
	return GLOB.cm_vending_young_yautja

/obj/structure/machinery/cm_vending/clothing/yautja/thrall
	name = "\improper Yautja Thrall Gear Rack"
	desc = "A gear rack for hunting."
	icon = 'icons/obj/items/hunter/pred_vendor.dmi'
	icon_state = "pred_vendor_left"
	show_points = FALSE
	vendor_theme = VENDOR_THEME_YAUTJA

/obj/structure/machinery/cm_vending/clothing/yautja/thrall/can_access_to_vend(mob/user, display = TRUE, ignore_hack = FALSE)
	if(isthrall(user))
		return TRUE
	if(!hacked || ignore_hack)
		if(!allowed(user))
			if(display)
				to_chat(user, SPAN_WARNING("Access denied."))
				vend_fail()
			return FALSE
	if(!isthrall(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		vend_fail()
	return FALSE

/obj/structure/machinery/cm_vending/clothing/yautja/thrall/left_centre
	icon_state = "pred_vendor_lcenter"

/obj/structure/machinery/cm_vending/clothing/yautja/thrall/centre
	icon_state = "pred_vendor_centre"

/obj/structure/machinery/cm_vending/clothing/yautja/thrall/right_centre
	icon_state = "pred_vendor_rcentre"

/obj/structure/machinery/cm_vending/clothing/yautja/thrall/right
	icon_state = "pred_vendor_thrall_right"

/obj/structure/machinery/cm_vending/clothing/yautja/thrall/get_listed_products(mob/user)
	return GLOB.cm_vending_thrall

/obj/structure/machinery/cm_vending/clothing/yautja/thrall/blooded_thrall
	name = "\improper Yautja Blooded Thrall Gear Rack"
	desc = "A gear rack for hunting."
	icon = 'icons/obj/items/hunter/pred_vendor.dmi'
	icon_state = "pred_vendor_left"
	show_points = FALSE
	vendor_theme = VENDOR_THEME_YAUTJA

/obj/structure/machinery/cm_vending/clothing/yautja/thrall/blooded_thrall/can_access_to_vend(mob/user, display = TRUE, ignore_hack = FALSE)
	if(HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		return TRUE
	if(!hacked || ignore_hack)
		if(!allowed(user))
			if(display)
				to_chat(user, SPAN_WARNING("Access denied."))
				vend_fail()
			return FALSE
	if(isyautja(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		vend_fail()
	return FALSE

/obj/structure/machinery/cm_vending/clothing/yautja/thrall/blooded_thrall/left
	icon_state = "pred_vendor_blooded_left"

/obj/structure/machinery/cm_vending/clothing/yautja/thrall/blooded_thrall/right
	icon_state = "pred_vendor_blooded_right"

/obj/structure/machinery/cm_vending/clothing/yautja/thrall/blooded_thrall/get_listed_products(mob/user)
	return GLOB.cm_vending_blooded_thrall

//Armour Prefs
/obj/item/clothing/suit/armor/yautja/hunter/post_vendor_spawn_hook(mob/living/carbon/human/user)
	if(!user?.client?.prefs)
		return
	var/client/mob_client = user.client

	if(mob_client.prefs.predator_use_legacy != "None")
		switch(mob_client.prefs.predator_use_legacy)
			if("Dragon")
				icon_state = "halfarmor_elder_tr"
				LAZYSET(item_state_slots, WEAR_JACKET, "halfarmor_elder_tr")
			if("Swamp")
				icon_state = "halfarmor_elder_joshuu"
				LAZYSET(item_state_slots, WEAR_JACKET, "halfarmor_elder_joshuu")
			if("Enforcer")
				icon_state = "halfarmor_elder_feweh"
				LAZYSET(item_state_slots, WEAR_JACKET, "halfarmor_elder_feweh")
			if("Collector")
				icon_state = "halfarmor_elder_n"
				LAZYSET(item_state_slots, WEAR_JACKET, "halfarmor_elder_n")
		user.update_inv_wear_suit()
		return

	icon_state = "halfarmor[mob_client.prefs.predator_armor_type]_[mob_client.prefs.predator_armor_material]"
	LAZYSET(item_state_slots, WEAR_JACKET, "halfarmor[mob_client.prefs.predator_armor_type]_[mob_client.prefs.predator_armor_material]")
	user.update_inv_wear_suit()

/obj/item/clothing/suit/armor/yautja/hunter/full/post_vendor_spawn_hook(mob/living/carbon/human/user)
	if(!user?.client?.prefs)
		return
	var/client/mob_client = user.client

	icon_state = "fullarmor_[mob_client.prefs.predator_armor_material]"
	LAZYSET(item_state_slots, WEAR_JACKET, "fullarmor_[mob_client.prefs.predator_armor_material]")
	user.update_inv_wear_suit()

//Mask Prefs
/obj/item/clothing/mask/gas/yautja/hunter/post_vendor_spawn_hook(mob/living/carbon/human/user)
	if(!user?.client?.prefs)
		return
	var/client/mob_client = user.client

	if(mob_client.prefs.predator_use_legacy != "None")
		switch(mob_client.prefs.predator_use_legacy)
			if("Dragon")
				icon_state = "pred_mask_elder_tr"
				LAZYSET(item_state_slots, WEAR_FACE, "pred_mask_elder_tr")
			if("Swamp")
				icon_state = "pred_mask_elder_joshuu"
				LAZYSET(item_state_slots, WEAR_FACE, "pred_mask_elder_joshuu")
			if("Enforcer")
				icon_state = "pred_mask_elder_feweh"
				LAZYSET(item_state_slots, WEAR_FACE, "pred_mask_elder_feweh")
			if("Collector")
				icon_state = "pred_mask_elder_n"
				LAZYSET(item_state_slots, WEAR_FACE, "pred_mask_elder_n")
		user.update_inv_wear_mask()
		return

	icon_state = "pred_mask[mob_client.prefs.predator_mask_type]_[mob_client.prefs.predator_mask_material]"
	LAZYSET(item_state_slots, WEAR_FACE, "pred_mask[mob_client.prefs.predator_mask_type]_[mob_client.prefs.predator_mask_material]")
	user.update_inv_wear_mask()

/obj/item/clothing/accessory/mask/post_vendor_spawn_hook(mob/living/carbon/human/user)
	if(!user?.client?.prefs)
		return
	var/client/mob_client = user.client
	if(mob_client.prefs.predator_accessory_type)
		icon_state = "pred_accessory[mob_client.prefs.predator_accessory_type]_[mob_client.prefs.predator_mask_material]"
	else
		qdel(src)


//Greaves Prefs

/obj/item/clothing/shoes/yautja/hunter/post_vendor_spawn_hook(mob/living/carbon/human/user)
	if(!user?.client?.prefs)
		return
	var/client/mob_client = user.client

	icon_state = "y-boots[mob_client.prefs.predator_boot_type]_[mob_client.prefs.predator_greave_material]"
	user.update_inv_shoes()

//Cape Prefs

/obj/item/clothing/yautja_cape/post_vendor_spawn_hook(mob/living/carbon/human/user)
	if(!user?.client?.prefs)
		return
	var/client/mob_client = user.client

	color = mob_client.prefs.predator_cape_color
	user.update_inv_back()
