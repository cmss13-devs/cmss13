GLOBAL_LIST_INIT(cm_vending_equipment_yautja, list(
        list("Essential Hunting Supplies", 0, null, null, null),
        list("Hunting Equipment", 0, /obj/effect/essentials_set/yautja,	MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

        list("Armor", 0, null, null, null),
        list("Clan Armor", 0, /obj/item/clothing/suit/armor/yautja, MARINE_CAN_BUY_COMBAT_ARMOR , VENDOR_ITEM_MANDATORY),
        list("Clan Mask", 0, /obj/item/clothing/mask/gas/yautja/hunter, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Greaves", 0, /obj/item/clothing/shoes/yautja/hunter/knife, MARINE_CAN_BUY_COMBAT_SHOES, VENDOR_ITEM_MANDATORY),

        list("Bracer Attachments", 0, null, null, null),
        list("Wrist Blades", 0, /obj/item/bracer_attachments/wristblades, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),

        list("Main Weapons (CHOOSE 1)", 0, null, null, null),
        list("The Piercing Hunting Sword", 0, /obj/item/weapon/yautja/sword, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
        list("The Rending Chain-Whip", 0, /obj/item/weapon/yautja/chain, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
        list("The Cleaving War-Scythe", 0, /obj/item/weapon/yautja/scythe, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
        list("The Ripping War-Scythe", 0, /obj/item/weapon/yautja/scythe/alt, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
        list("The Adaptive Combi-Stick", 0, /obj/item/weapon/yautja/combistick, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
        list("The Lumbering Glaive", 0, /obj/item/weapon/twohanded/yautja/glaive, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
        list("The Imposing Glaive", 0, /obj/item/weapon/twohanded/yautja/glaive/alt, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("Scimitars", 0, /obj/item/bracer_attachments/scimitars, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),

        list("Secondary Equipment (CHOOSE 2)", 0, null, null, null),
        list("The Fleeting Spike Launcher", 0, /obj/item/weapon/gun/launcher/spike, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
        list("The Swift Plasma Pistol", 0, /obj/item/weapon/gun/energy/yautja/plasmapistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
        list("The Agile Drone", 0, /obj/item/falcon_drone, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
        list("The Purifying Smart-Disc", 0, /obj/item/explosive/grenade/spawnergrenade/smartdisc, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
        list("The Steadfast Shield", 0, /obj/item/weapon/shield/riot/yautja, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

        list("Clothing Accessory (CHOOSE 1)", 0, null, null, null),
        list("Third-Cape", 0, /obj/item/clothing/yautja_cape/third, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
        list("Half-Cape", 0, /obj/item/clothing/yautja_cape/half, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
        list("Quarter-Cape", 0, /obj/item/clothing/yautja_cape/quarter, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
        list("Poncho", 0, /obj/item/clothing/yautja_cape/poncho, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
    ))

GLOBAL_LIST_INIT(cm_vending_elder_yautja, list(
        list("Essential Hunting Supplies", 0, null, null, null),
        list("Hunting Equipment", 0, /obj/effect/essentials_set/yautja,	MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

        list("Armor", 0, null, null, null),
        list("Clan Armor", 0, /obj/item/clothing/suit/armor/yautja, MARINE_CAN_BUY_COMBAT_ARMOR , VENDOR_ITEM_MANDATORY),
        list("Clan Mask", 0, /obj/item/clothing/mask/gas/yautja/hunter, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Greaves", 0, /obj/item/clothing/shoes/yautja/hunter/knife, MARINE_CAN_BUY_COMBAT_SHOES, VENDOR_ITEM_MANDATORY),

        list("Bracer Attachments", 0, null, null, null),
        list("Wrist Blades", 0, /obj/item/bracer_attachments/wristblades, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),

        list("Main Weapons (CHOOSE 1)", 0, null, null, null),
        list("The Piercing Hunting Sword", 0, /obj/item/weapon/yautja/sword, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
        list("The Rending Chain-Whip", 0, /obj/item/weapon/yautja/chain, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
        list("The Cleaving War-Scythe", 0, /obj/item/weapon/yautja/scythe, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
        list("The Ripping War-Scythe", 0, /obj/item/weapon/yautja/scythe/alt, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
        list("The Adaptive Combi-Stick", 0, /obj/item/weapon/yautja/combistick, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
        list("The Lumbering Glaive", 0, /obj/item/weapon/twohanded/yautja/glaive, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
        list("The Imposing Glaive", 0, /obj/item/weapon/twohanded/yautja/glaive/alt, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("Scimitars", 0, /obj/item/bracer_attachments/scimitars, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),

        list("Secondary Equipment (CHOOSE 2)", 0, null, null, null),
        list("The Fleeting Spike Launcher", 0, /obj/item/weapon/gun/launcher/spike, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
        list("The Swift Plasma Pistol", 0, /obj/item/weapon/gun/energy/yautja/plasmapistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
        list("The Agile Drone", 0, /obj/item/falcon_drone, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
        list("The Purifying Smart-Disc", 0, /obj/item/explosive/grenade/spawnergrenade/smartdisc, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
        list("The Steadfast Shield", 0, /obj/item/weapon/shield/riot/yautja, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

        list("Clothing Accessory (CHOOSE 1)", 0, null, null, null),
        list("Third-Cape", 0, /obj/item/clothing/yautja_cape/third, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
        list("Half-Cape", 0, /obj/item/clothing/yautja_cape/half, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
        list("Quarter-Cape", 0, /obj/item/clothing/yautja_cape/quarter, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
        list("Poncho", 0, /obj/item/clothing/yautja_cape/poncho, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
        list("Ceremonial Cape", 0, /obj/item/clothing/yautja_cape/ceremonial, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
        list("Full-Cape", 0, /obj/item/clothing/yautja_cape, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/yautja
    name = "\improper Yautja Hunting Gear Rack"
    desc = "A gear rack for hunting, expose your bracers ID chip to access."
    icon_state = "gear"
    req_access = list(ACCESS_YAUTJA_SECURE)
    vendor_role = list(JOB_PREDATOR)
    show_points = FALSE

/obj/structure/machinery/cm_vending/clothing/yautja/get_listed_products(mob/user)
    return GLOB.cm_vending_equipment_yautja

/obj/structure/machinery/cm_vending/gear/yautja/elder
    name = "\improper Yautja Elder Hunting Gear Rack"
    icon_state = "gear"
    req_access = list(ACCESS_YAUTJA_ELDER)

/obj/structure/machinery/cm_vending/clothing/yautja/elder/get_listed_products(mob/user)
    return GLOB.cm_vending_elder_yautja

/obj/effect/essentials_set/yautja
	spawned_gear_list = list(
		/obj/item/clothing/under/chainshirt/hunter,
		/obj/item/device/radio/headset/yautja,
		/obj/item/storage/backpack/yautja,
		/obj/item/storage/medicomp/full,
		/obj/item/device/yautja_teleporter,
)

//Armour Prefs
/obj/item/clothing/suit/armor/yautja/post_vendor_spawn_hook(mob/living/carbon/human/user)
    if(!user?.client?.prefs)
        return
    var/client/mob_client = user.client

    if(mob_client.prefs.predator_use_legacy != "None")
        switch(mob_client.prefs.predator_use_legacy)
            if("dragon")
                icon_state = "halfarmor_elder_tr"
                LAZYSET(item_state_slots, WEAR_JACKET, "halfarmor_elder_tr")
            if("swamp")
                icon_state = "halfarmor_elder_joshuu"
                LAZYSET(item_state_slots, WEAR_JACKET, "halfarmor_elder_joshuu")
            if("enforcer")
                icon_state = "halfarmor_elder_feweh"
                LAZYSET(item_state_slots, WEAR_JACKET, "halfarmor_elder_feweh")
            if("collector")
                icon_state = "halfarmor_elder_n"
                LAZYSET(item_state_slots, WEAR_JACKET, "halfarmor_elder_n")
        user.update_inv_wear_suit()
        return

    icon_state = "halfarmor[mob_client.prefs.predator_armor_type]_[mob_client.prefs.predator_armor_material]"
    LAZYSET(item_state_slots, WEAR_JACKET, "halfarmor[mob_client.prefs.predator_armor_type]_[mob_client.prefs.predator_armor_material]")
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
