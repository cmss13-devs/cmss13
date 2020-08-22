/datum/equipment_preset/yautja
    name = "Yautja"
    idtype = null //No IDs for Yautja!
    languages = list("Sainja")
    rank = "Predator"
    faction = FACTION_YAUTJA
    uses_special_name = TRUE
    skills = /datum/skills/yautja/warrior

/datum/equipment_preset/yautja/load_race(mob/living/carbon/human/H)
    H.set_species("Yautja")

/datum/equipment_preset/yautja/load_id(mob/living/carbon/human/H)
    H.job = rank
    H.faction = faction

/datum/equipment_preset/yautja/load_vanity(mob/living/carbon/human/H)
    return //No vanity items for Yautja!

/datum/equipment_preset/yautja/load_gear(mob/living/carbon/human/H)
    var/armor_number = 1
    var/boot_number = 1
    var/mask_number = 1
    if(H.client && H.client.prefs)
        armor_number = H.client.prefs.predator_armor_type
        boot_number = H.client.prefs.predator_boot_type
        mask_number = H.client.prefs.predator_mask_type

    H.equip_to_slot_or_del(new /obj/item/clothing/under/chainshirt(H), WEAR_BODY)
    H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yautja(H), WEAR_HANDS)
    H.equip_to_slot_or_del(new /obj/item/device/radio/headset/yautja(H), WEAR_EAR)
    H.equip_to_slot_or_del(new /obj/item/weapon/melee/yautja_knife(H), WEAR_R_STORE)
    H.equip_to_slot_or_del(new /obj/item/device/yautja_teleporter(H),WEAR_L_STORE)
    H.equip_to_slot_or_del(new /obj/item/storage/backpack/yautja(H), WEAR_WAIST)

    H.equip_to_slot_or_del(new /obj/item/clothing/shoes/yautja(H, boot_number), WEAR_FEET)
    H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/yautja(H, armor_number), WEAR_JACKET)
    H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/yautja(H, mask_number), WEAR_FACE)

/datum/equipment_preset/yautja/load_name(mob/living/carbon/human/H, var/randomise)
    var/final_name = "Le'pro"
    H.gender = MALE
    H.age = 100

    if(H.client && H.client.prefs)
        H.gender = H.client.prefs.predator_gender
        H.age = H.client.prefs.predator_age
        final_name = H.client.prefs.predator_name
        if(!final_name || final_name == "Undefined") //In case they don't have a name set or no prefs, there's a name.
            final_name = "Le'pro"
    H.change_real_name(H, final_name)

// YOUNG BLOOD
/datum/equipment_preset/yautja/youngblood
    name = "Yautja Young"
    flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/yautja/youngblood/load_name(mob/living/carbon/human/H, var/randomise)
    . = ..()
    var/new_name = "Young [H.real_name]"
    H.change_real_name(H, new_name)

//BLOODED
/datum/equipment_preset/yautja/blooded
    name = "Yautja Blooded"
    flags = EQUIPMENT_PRESET_START_OF_ROUND

// ELITE
/datum/equipment_preset/yautja/elite
    name = "Yautja Elite"
    flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/yautja/elite/load_name(mob/living/carbon/human/H, var/randomise)
    . = ..()
    var/new_name = "Elite [H.real_name]"
    H.change_real_name(H, new_name)

/datum/equipment_preset/yautja/elite/load_gear(mob/living/carbon/human/H)
    H.equip_to_slot_or_del(new /obj/item/clothing/cape/eldercape(H), WEAR_BACK)
    . = ..()

// ELDER
/datum/equipment_preset/yautja/elder
    name = "Yautja Elder"
    flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/yautja/elder/load_name(mob/living/carbon/human/H, var/randomise)
    . = ..()
    var/new_name = "Elder [H.real_name]"
    H.change_real_name(H, new_name)

/datum/equipment_preset/yautja/elder/load_gear(mob/living/carbon/human/H)
    H.equip_to_slot_or_del(new /obj/item/clothing/cape/eldercape(H), WEAR_BACK)
    . = ..()

// CLAN LEADER
/datum/equipment_preset/yautja/leader
    name = "Yautja Leader"
    flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/yautja/leader/load_name(mob/living/carbon/human/H, var/randomise)
    . = ..()
    var/new_name = "Clan Leader [H.real_name]"
    H.change_real_name(H, new_name)

/datum/equipment_preset/yautja/leader/load_gear(mob/living/carbon/human/H)
    H.equip_to_slot_or_del(new /obj/item/clothing/cape/eldercape(H), WEAR_BACK)
    . = ..()

// ANCIENT
/datum/equipment_preset/yautja/ancient
    name = "Yautja Ancient"
    flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/yautja/ancient/load_name(mob/living/carbon/human/H, var/randomise)
    . = ..()
    var/new_name = "Ancient [H.real_name]"
    H.change_real_name(H, new_name)

/datum/equipment_preset/yautja/ancient/load_gear(mob/living/carbon/human/H)
    H.equip_to_slot_or_del(new /obj/item/clothing/cape/eldercape(H), WEAR_BACK)
    . = ..()