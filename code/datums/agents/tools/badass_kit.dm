/obj/item/storage/box/badass_kit
    name = "suspicious box"
    desc = "A compact and suspicious looking box. This one is small enough to fit into a bag."

    w_class = SIZE_MEDIUM

    storage_slots = 2


/obj/item/storage/box/badass_kit/Initialize()
    . = ..()
    new/obj/item/device/encryptionkey/sec(src)
    new/obj/item/clothing/glasses/sunglasses/antag(src)

/obj/item/clothing/glasses/sunglasses/antag
    flags_equip_slot = SLOT_EYES

    flags_armor_protection = BODY_FLAG_EYES|BODY_FLAG_FACE

    armor_energy = CLOTHING_ARMOR_HARDCORE
    eye_protection = 2