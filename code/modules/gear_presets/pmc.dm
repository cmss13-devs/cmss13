
/datum/equipment_preset/pmc
	name = "PMC"
	faction = FACTION_PMC
	rank = FACTION_PMC
	idtype = /obj/item/card/id/pmc
	faction = FACTION_PMC
	faction_group = FACTION_LIST_WY
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	var/human_versus_human = FALSE
	var/headset_type = /obj/item/device/radio/headset/distress/pmc

/datum/equipment_preset/pmc/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access() + get_antagonist_access()


/datum/equipment_preset/pmc/load_name(mob/living/carbon/human/H, randomise)
	H.gender = pick(MALE,FEMALE)
	var/random_name
	var/first_name
	var/last_name
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	if(H.gender == MALE)
		if(prob(10))
			first_name = "[capitalize(randomly_generate_japanese_word(rand(2, 3)))]"
		else
			first_name = "[pick(first_names_male_pmc)]"
		H.f_style = "5 O'clock Shadow"
	else
		if(prob(10))
			first_name = "[capitalize(randomly_generate_japanese_word(rand(2, 3)))]"
		else
			first_name = "[pick(first_names_female_pmc)]"
	if(prob(25))
		last_name = "[capitalize(randomly_generate_japanese_word(rand(2, 4)))]"
	else
		last_name = "[pick(last_names_pmc)]"
	random_name = "[first_name] [last_name]"
	H.change_real_name(H, random_name)
	H.age = rand(25,35)
	H.h_style = "Shaved Head"
	H.r_hair = 25
	H.g_hair = 25
	H.b_hair = 35

/datum/equipment_preset/pmc/load_id(mob/living/carbon/human/H, client/mob_client)
	if(human_versus_human)
		var/obj/item/clothing/under/uniform = H.w_uniform
		if(istype(uniform))
			uniform.has_sensor = UNIFORM_HAS_SENSORS
			uniform.sensor_faction = FACTION_PMC
	return ..()


//*****************************************************************************************************/
/datum/equipment_preset/pmc/pmc_standard
	name = "Weyland-Yutani PMC (Standard)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "Weyland-Yutani PMC (Standard)"
	rank = JOB_PMC
	paygrade = "PMC-OP"
	skills = /datum/skills/pmc

/datum/equipment_preset/pmc/pmc_standard/load_gear(mob/living/carbon/human/H)

	var/choice = rand(1,5)
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc, WEAR_BODY)
	if(prob(50))
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc, WEAR_JACKET)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc, WEAR_FACE)

	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/splint, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_ACCESSORY)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/pmc, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)

	switch(choice)
		if(1,2)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_L_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/nsg23, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/nsg_ap, WEAR_L_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/nsg23/extended, WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/nsg23/extended, WEAR_IN_BACK)
		if(4,5)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle, WEAR_L_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_BACK)

/datum/equipment_preset/pmc/pmc_standard/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/veteran/pmc/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/pmc, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/pmc, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/pmc/hvh, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("MRE", 0,  /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Armored Balaclava", 0, /obj/item/clothing/mask/gas/pmc, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Tactical Cap", 0, /obj/item/clothing/head/helmet/marine/veteran/pmc, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Standard Armor", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("Light Armor", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc/light, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Knife Rig (Full)", 0, /obj/item/storage/belt/knifepouch, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/large_holster/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M40 Grenade Rig (Empty)", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Bayonet Sheath (Full)", 0, /obj/item/storage/pouch/bayonet, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Small Document Pouch", 0, /obj/item/storage/pouch/document/small, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/pmc/pmc_standard/get_antag_gear_equipment()
	return list(
		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_RECOMMENDED),
		list("Sandbags x25", 5, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),

		list("SPECIAL AMMUNITION", 0, null, null, null), //pmcs can get TWO HEAP magazines, maximum.
		list("M41A HEAP magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/heap, null, VENDOR_ITEM_REGULAR),
		list("M39 HEAP magazine (10x20mm)", 20, /obj/item/ammo_magazine/smg/m39/heap, null, VENDOR_ITEM_REGULAR),
		list("NSG23 HEAP magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/nsg23/heap, null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("M12 Blast Grenade", 15, /obj/item/explosive/grenade/high_explosive/pmc, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 10, /obj/item/clothing/accessory/storage/holster, null, VENDOR_ITEM_REGULAR),
		list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 10, /obj/item/clothing/accessory/storage/droppouch, null, VENDOR_ITEM_REGULAR),
	)

//*****************************************************************************************************/
/datum/equipment_preset/pmc/pmc_detainer
	name = "Weyland-Yutani PMC (Detainer)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "Weyland-Yutani PMC (Detainer)"
	rank = JOB_PMC
	paygrade = "PMC-EN"
	skills = /datum/skills/pmc

/datum/equipment_preset/pmc/pmc_detainer/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc, WEAR_BODY)
	if(prob(50))
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc, WEAR_JACKET)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/tactical, WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/splint, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_ACCESSORY)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/taser, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/corporate/detainer, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/box/zipcuffs/small, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flash, WEAR_IN_BACK)

/datum/equipment_preset/pmc/pmc_detainer/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/veteran/pmc/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/pmc, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/pmc, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/pmc/hvh, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("MRE", 0,  /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Armored Balaclava", 0, /obj/item/clothing/mask/gas/pmc, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Tactical Cap", 0, /obj/item/clothing/head/helmet/marine/veteran/pmc, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Standard Armor", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("Light Armor", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc/light, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Knife Rig (Full)", 0, /obj/item/storage/belt/knifepouch, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/large_holster/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M40 Grenade Rig (Empty)", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Bayonet Sheath (Full)", 0, /obj/item/storage/pouch/bayonet, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Small Document Pouch", 0, /obj/item/storage/pouch/document/small, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/pmc/pmc_detainer/get_antag_gear_equipment()
	return list(
		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_RECOMMENDED),
		list("Sandbags x25", 5, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),

		list("SPECIAL AMMUNITION", 0, null, null, null), //pmcs can get TWO HEAP magazines, maximum.
		list("M41A HEAP magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/heap, null, VENDOR_ITEM_REGULAR),
		list("M39 HEAP magazine (10x20mm)", 20, /obj/item/ammo_magazine/smg/m39/heap, null, VENDOR_ITEM_REGULAR),
		list("NSG23 HEAP magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/nsg23/heap, null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("M12 Blast Grenade", 15, /obj/item/explosive/grenade/high_explosive/pmc, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 10, /obj/item/clothing/accessory/storage/holster, null, VENDOR_ITEM_REGULAR),
		list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 10, /obj/item/clothing/accessory/storage/droppouch, null, VENDOR_ITEM_REGULAR),
	)

//*****************************************************************************************************/
/datum/equipment_preset/pmc/pmc_medic
	name = "Weyland-Yutani PMC (Corporate Medic)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_PMC_MEDIC
	rank = JOB_PMC_MEDIC
	paygrade = "PMC-MS"
	skills = /datum/skills/pmc/medic
	headset_type = /obj/item/device/radio/headset/distress/pmc/medic

/datum/equipment_preset/pmc/pmc_medic/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc, WEAR_FACE)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/pmc, WEAR_IN_JACKET)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/pmc, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch, WEAR_WAIST)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_R_STORE)

/datum/equipment_preset/pmc/pmc_medic/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/veteran/pmc/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/pmc, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/pmc, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/pmc/hvh, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("MRE", 0,  /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Armored Balaclava", 0, /obj/item/clothing/mask/gas/pmc, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Tactical Cap", 0, /obj/item/clothing/head/helmet/marine/veteran/pmc, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Standard Armor", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("Light Armor", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc/light, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Lifesaver Bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full/dutch, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Medical Storage Rig (Full)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/large_holster/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M40 Grenade Rig", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Bicaridine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Kelotane)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/pmc/pmc_medic/get_antag_gear_equipment()
	return list(
		list("MEDIC SET (MANDATORY)", 0, null, null, null),
		list("Essential Medic Set", 0, /obj/effect/essentials_set/medic, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("FIELD SUPPLIES", 0, null, null, null),
		list("Adv Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_RECOMMENDED),
		list("Adv Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_RECOMMENDED),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_RECOMMENDED),

		list("FIRSTAID KITS", 0, null, null, null),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_RECOMMENDED),
		list("Firstaid Kit", 5, /obj/item/storage/firstaid/regular, null, VENDOR_ITEM_REGULAR),
		list("Fire Firstaid Kit", 6, /obj/item/storage/firstaid/fire, null, VENDOR_ITEM_REGULAR),
		list("Toxin Firstaid Kit", 6, /obj/item/storage/firstaid/toxin, null, VENDOR_ITEM_REGULAR),
		list("Oxygen Firstaid Kit", 6, /obj/item/storage/firstaid/o2, null, VENDOR_ITEM_REGULAR),
		list("Radiation Firstaid Kit", 6, /obj/item/storage/firstaid/rad, null, VENDOR_ITEM_REGULAR),

		list("AUTOINJECTORS", 0, null, null, null),
		list("Autoinjector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Epinephrine)", 2, /obj/item/reagent_container/hypospray/autoinjector/adrenaline, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (QuickClot)", 1, /obj/item/reagent_container/hypospray/autoinjector/quickclot, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("PILL BOTTLES", 0, null, null, null),
		list("Pill Bottle (Bicaridine)", 5, /obj/item/storage/pill_bottle/bicaridine, null, VENDOR_ITEM_RECOMMENDED),
		list("Pill Bottle (Dexalin)", 5, /obj/item/storage/pill_bottle/dexalin, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Dylovene)", 5, /obj/item/storage/pill_bottle/antitox, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Inaprovaline)", 5, /obj/item/storage/pill_bottle/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Kelotane)", 5, /obj/item/storage/pill_bottle/kelotane, null, VENDOR_ITEM_RECOMMENDED),
		list("Pill Bottle (Peridaxon)", 5, /obj/item/storage/pill_bottle/peridaxon, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (QuickClot)", 5, /obj/item/storage/pill_bottle/quickclot, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Tramadol)", 5, /obj/item/storage/pill_bottle/tramadol, null, VENDOR_ITEM_RECOMMENDED),

		list("MEDICAL UTILITIES", 0, null, null, null),
		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_REGULAR),
		list("Roller Bed", 4, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Stasis Bag", 6, /obj/item/bodybag/cryobag, null, VENDOR_ITEM_REGULAR),

		list("SPECIAL AMMUNITION", 0, null, null, null), //pmcs can get TWO HEAP magazines, maximum.
		list("M41A HEAP magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/heap, null, VENDOR_ITEM_REGULAR),
		list("M39 HEAP magazine (10x20mm)", 20, /obj/item/ammo_magazine/smg/m39/heap, null, VENDOR_ITEM_REGULAR),
		list("NSG23 HEAP magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/nsg23/heap, null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("M12 Blast Grenade", 15, /obj/item/explosive/grenade/high_explosive/pmc, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 10, /obj/item/clothing/accessory/storage/holster, null, VENDOR_ITEM_REGULAR),
		list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 10, /obj/item/clothing/accessory/storage/droppouch, null, VENDOR_ITEM_REGULAR),
	)

//*****************************************************************************************************/
/datum/equipment_preset/pmc/pmc_med_investigator
	name = "Weyland-Yutani PMC (Medical Investigator)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_PMC_INVESTIGATOR
	rank = JOB_PMC_INVESTIGATOR
	paygrade = "PMC-MS" //Fixed from PMC2 to PMC-MS to display properly.
	skills = /datum/skills/pmc/medic/chem
	headset_type = /obj/item/device/radio/headset/distress/pmc/medic

/datum/equipment_preset/pmc/pmc_med_investigator/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc, WEAR_FACE)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)

	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/device/reagent_scanner, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder, WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/syringe/full, WEAR_R_STORE)

	H.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/syringe/counteragent, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/sedative, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)

/datum/equipment_preset/pmc/pmc_med_investigator/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/veteran/pmc/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/pmc, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/pmc, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/pmc/hvh, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("MRE", 0,  /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Armored Balaclava", 0, /obj/item/clothing/mask/gas/pmc, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Tactical Cap", 0, /obj/item/clothing/head/helmet/marine/veteran/pmc, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Standard Armor", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("Light Armor", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc/light, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Lifesaver Bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full/dutch, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Medical Storage Rig (Full)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/large_holster/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M40 Grenade Rig", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Bicaridine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Kelotane)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/pmc/pmc_med_investigator/get_antag_gear_equipment()
	return list(
		list("MEDIC SET (MANDATORY)", 0, null, null, null),
		list("Essential Medic Set", 0, /obj/effect/essentials_set/medic, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("FIELD SUPPLIES", 0, null, null, null),
		list("Adv Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_RECOMMENDED),
		list("Adv Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_RECOMMENDED),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_RECOMMENDED),

		list("FIRSTAID KITS", 0, null, null, null),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_RECOMMENDED),
		list("Firstaid Kit", 5, /obj/item/storage/firstaid/regular, null, VENDOR_ITEM_REGULAR),
		list("Fire Firstaid Kit", 6, /obj/item/storage/firstaid/fire, null, VENDOR_ITEM_REGULAR),
		list("Toxin Firstaid Kit", 6, /obj/item/storage/firstaid/toxin, null, VENDOR_ITEM_REGULAR),
		list("Oxygen Firstaid Kit", 6, /obj/item/storage/firstaid/o2, null, VENDOR_ITEM_REGULAR),
		list("Radiation Firstaid Kit", 6, /obj/item/storage/firstaid/rad, null, VENDOR_ITEM_REGULAR),

		list("AUTOINJECTORS", 0, null, null, null),
		list("Autoinjector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Epinephrine)", 2, /obj/item/reagent_container/hypospray/autoinjector/adrenaline, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (QuickClot)", 1, /obj/item/reagent_container/hypospray/autoinjector/quickclot, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("PILL BOTTLES", 0, null, null, null),
		list("Pill Bottle (Bicaridine)", 5, /obj/item/storage/pill_bottle/bicaridine, null, VENDOR_ITEM_RECOMMENDED),
		list("Pill Bottle (Dexalin)", 5, /obj/item/storage/pill_bottle/dexalin, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Dylovene)", 5, /obj/item/storage/pill_bottle/antitox, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Inaprovaline)", 5, /obj/item/storage/pill_bottle/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Kelotane)", 5, /obj/item/storage/pill_bottle/kelotane, null, VENDOR_ITEM_RECOMMENDED),
		list("Pill Bottle (Peridaxon)", 5, /obj/item/storage/pill_bottle/peridaxon, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (QuickClot)", 5, /obj/item/storage/pill_bottle/quickclot, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Tramadol)", 5, /obj/item/storage/pill_bottle/tramadol, null, VENDOR_ITEM_RECOMMENDED),

		list("MEDICAL UTILITIES", 0, null, null, null),
		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_REGULAR),
		list("Roller Bed", 4, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Stasis Bag", 6, /obj/item/bodybag/cryobag, null, VENDOR_ITEM_REGULAR),

		list("SPECIAL AMMUNITION", 0, null, null, null), //pmcs can get TWO HEAP magazines, maximum.
		list("M41A HEAP magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/heap, null, VENDOR_ITEM_REGULAR),
		list("M39 HEAP magazine (10x20mm)", 20, /obj/item/ammo_magazine/smg/m39/heap, null, VENDOR_ITEM_REGULAR),
		list("NSG23 HEAP magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/nsg23/heap, null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("M12 Blast Grenade", 15, /obj/item/explosive/grenade/high_explosive/pmc, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 10, /obj/item/clothing/accessory/storage/holster, null, VENDOR_ITEM_REGULAR),
		list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 10, /obj/item/clothing/accessory/storage/droppouch, null, VENDOR_ITEM_REGULAR),
	)

//*****************************************************************************************************/

/datum/equipment_preset/pmc/pmc_leader
	name = "Weyland-Yutani PMC (Leader)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_PMC_LEADER
	rank = JOB_PMC_LEADER
	paygrade = "PMC-TL"
	role_comm_title = "SL"
	skills = /datum/skills/pmc/SL
	headset_type = /obj/item/device/radio/headset/distress/pmc/command

/datum/equipment_preset/pmc/pmc_leader/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/leader, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/leader, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/leader, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/leader, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/sensor, WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/splint, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_ACCESSORY)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/pmc, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite, WEAR_J_STORE)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_R_STORE)

	var/obj/item/device/radio/headset/R = H.wear_l_ear
	if(istype(R))
		R.volume = RADIO_VOLUME_IMPORTANT

/datum/equipment_preset/pmc/pmc_leader/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/veteran/pmc/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/pmc, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/pmc, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/pmc/hvh, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("MRE", 0,  /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Armored Balaclava", 0, /obj/item/clothing/mask/gas/pmc, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Armored Beret", 0, /obj/item/clothing/head/helmet/marine/veteran/pmc/leader, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Armor", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc/leader, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Lifesaver Bag", 0, /obj/item/storage/belt/medical/lifesaver, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Medical Storage Rig", 0, /obj/item/storage/belt/medical, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/large_holster/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M40 Grenade Rig", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch (Full)", 0, /obj/item/storage/pouch/autoinjector/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Bayonet Sheath (Full)", 0, /obj/item/storage/pouch/bayonet, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/pmc/pmc_leader/get_antag_gear_equipment()
	return list(

		list("SQUAD LEADER SET (MANDATORY)", 0, null, null, null),
		list("Essential SL Set", 0, /obj/effect/essentials_set/leader/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("GENERAL SUPPLIES", 0, null, null, null),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Insulated Gloves", 3, /obj/item/clothing/gloves/yellow, null, VENDOR_ITEM_REGULAR),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),
		list("Tools Pouch (Full)", 5, /obj/item/storage/pouch/tools/full, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 5, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),

		list("SPECIAL AMMUNITION", 0, null, null, null), //pmcs can get TWO HEAP magazines, maximum.
		list("M41A HEAP magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/heap, null, VENDOR_ITEM_REGULAR),
		list("M39 HEAP magazine (10x20mm)", 20, /obj/item/ammo_magazine/smg/m39/heap, null, VENDOR_ITEM_REGULAR),
		list("NSG23 HEAP magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/nsg23/heap, null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("M12 Blast Grenade", 15, /obj/item/explosive/grenade/high_explosive/pmc, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 10, /obj/item/clothing/accessory/storage/holster, null, VENDOR_ITEM_REGULAR),
		list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 10, /obj/item/clothing/accessory/storage/droppouch, null, VENDOR_ITEM_REGULAR),
	)

//*****************************************************************************************************/

/datum/equipment_preset/pmc/pmc_lead_investigator
	name = "Weyland-Yutani PMC (Lead Investigator)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_PMC_LEAD_INVEST
	rank = JOB_PMC_LEAD_INVEST
	paygrade = "PMC-TL"
	role_comm_title = "SL"
	skills = /datum/skills/pmc/SL/chem
	headset_type = /obj/item/device/radio/headset/distress/pmc/command

/datum/equipment_preset/pmc/pmc_lead_investigator/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/leader, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/leader, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/leader, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/leader, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/sensor, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/splint, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/reagent_scanner, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_R_STORE)

/datum/equipment_preset/pmc/pmc_lead_investigator/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/veteran/pmc/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/pmc, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/pmc, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/pmc/hvh, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("MRE", 0,  /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Armored Balaclava", 0, /obj/item/clothing/mask/gas/pmc, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Armored Beret", 0, /obj/item/clothing/head/helmet/marine/veteran/pmc/leader, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Armor", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc/leader, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Lifesaver Bag", 0, /obj/item/storage/belt/medical/lifesaver, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Medical Storage Rig", 0, /obj/item/storage/belt/medical, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/large_holster/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M40 Grenade Rig", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch (Full)", 0, /obj/item/storage/pouch/autoinjector/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Bayonet Sheath (Full)", 0, /obj/item/storage/pouch/bayonet, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/pmc/pmc_lead_investigator/get_antag_gear_equipment()
	return list(

		list("SQUAD LEADER SET (MANDATORY)", 0, null, null, null),
		list("Essential SL Set", 0, /obj/effect/essentials_set/leader/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("GENERAL SUPPLIES", 0, null, null, null),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Insulated Gloves", 3, /obj/item/clothing/gloves/yellow, null, VENDOR_ITEM_REGULAR),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),
		list("Tools Pouch (Full)", 5, /obj/item/storage/pouch/tools/full, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 5, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),

		list("SPECIAL AMMUNITION", 0, null, null, null), //pmcs can get TWO HEAP magazines, maximum.
		list("M41A HEAP magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/heap, null, VENDOR_ITEM_REGULAR),
		list("M39 HEAP magazine (10x20mm)", 20, /obj/item/ammo_magazine/smg/m39/heap, null, VENDOR_ITEM_REGULAR),
		list("NSG23 HEAP magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/nsg23/heap, null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("M12 Blast Grenade", 15, /obj/item/explosive/grenade/high_explosive/pmc, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 10, /obj/item/clothing/accessory/storage/holster, null, VENDOR_ITEM_REGULAR),
		list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 10, /obj/item/clothing/accessory/storage/droppouch, null, VENDOR_ITEM_REGULAR),
	)

//*****************************************************************************************************/

/datum/equipment_preset/pmc/pmc_gunner
	name = "Weyland-Yutani PMC (Gunner)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_PMC_GUNNER
	rank = JOB_PMC_GUNNER
	paygrade = "PMC-SS"
	role_comm_title = "SG"
	skills = /datum/skills/pmc/smartgunner

/datum/equipment_preset/pmc/pmc_gunner/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/smartgunner/veteran/pmc, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/gunner, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/leader, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/splint, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/cell/hyper, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/smartgun_powerpack/pmc, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun/dirty, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/large/vp78, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner/pmc/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles, WEAR_EYES)

/datum/equipment_preset/pmc/pmc_gunner/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/veteran/pmc/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/pmc, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/pmc, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/pmc/hvh, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("MRE", 0,  /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Armored Balaclava", 0, /obj/item/clothing/mask/gas/pmc/leader, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/pmc/gunner, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Armor", 0, /obj/item/clothing/suit/storage/marine/smartgunner/veteran/pmc, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("BELT", 0, null, null, null),
		list("M802 Smartgunner Sidearm Belt", 0, /obj/item/storage/belt/gun/smartgunner/pmc/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),
		list("M280 Smartgunner Drum Belt", 0, /obj/item/storage/belt/marine/smartgunner, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Bayonet Sheath (Full)", 0, /obj/item/storage/pouch/bayonet, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Small Document Pouch", 0, /obj/item/storage/pouch/document/small, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/pmc/pmc_gunner/get_antag_gear_equipment()
	return list(

		list("PMC GUNNER SET (SPARE)", 0, null, null, null),
		list("Spare M56D 'Dirty' Set", 0, /obj/item/storage/box/m56_dirty_system, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Irradiated smartgun drum (10x28mm)", 15, /obj/item/ammo_magazine/smartgun/dirty, null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("M12 Blast Grenade", 15, /obj/item/explosive/grenade/high_explosive/pmc, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 10, /obj/item/clothing/accessory/storage/holster, null, VENDOR_ITEM_REGULAR),
		list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 10, /obj/item/clothing/accessory/storage/droppouch, null, VENDOR_ITEM_REGULAR),
	)

//*****************************************************************************************************/

/datum/equipment_preset/pmc/pmc_sniper
	name = "Weyland-Yutani PMC (Sniper)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_PMC_SNIPER
	rank = JOB_PMC_SNIPER
	paygrade = "PMC-WS"
	role_comm_title = "Spc"
	skills = /datum/skills/pmc/specialist
	headset_type = /obj/item/device/radio/headset/distress/pmc/cct

/datum/equipment_preset/pmc/pmc_sniper/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/sniper, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/sniper, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/leader, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/m42c, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/large_holster/m39/full/elite, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/splint, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/sniper/elite, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/sniper/elite, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/sniper/elite, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_sniper, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)

/datum/equipment_preset/pmc/pmc_sniper/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/veteran/pmc/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/pmc, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/pmc, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/pmc/hvh, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("MRE", 0,  /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Armored Balaclava", 0, /obj/item/clothing/mask/gas/pmc/leader, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/pmc/sniper, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Armor", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc/sniper, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Lifesaver Bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full/dutch, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Medical Storage Rig (Full)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/large_holster/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M40 Grenade Rig", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Bayonet Sheath (Full)", 0, /obj/item/storage/pouch/bayonet, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Small Document Pouch", 0, /obj/item/storage/pouch/document/small, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/pmc/pmc_sniper/get_antag_gear_equipment()
	return list(

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("M42C marksman magazine (10x99mm)", 15, /obj/item/ammo_magazine/sniper/elite, null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("M12 Blast Grenade", 15, /obj/item/explosive/grenade/high_explosive/pmc, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 10, /obj/item/clothing/accessory/storage/holster, null, VENDOR_ITEM_REGULAR),
		list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 10, /obj/item/clothing/accessory/storage/droppouch, null, VENDOR_ITEM_REGULAR),
	)

//*****************************************************************************************************/
/datum/equipment_preset/pmc/pmc_crewman
	name = "Weyland-Yutani PMC (Crewman)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "Weyland-Yutani PMC (Crewman)"
	rank = JOB_PMC_CREWMAN
	paygrade = "PMC-VS"
	skills = /datum/skills/pmc/tank_crew
	headset_type = /obj/item/device/radio/headset/distress/pmc/cct

/datum/equipment_preset/pmc/pmc_crewman/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding/superior, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/tool/weldpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/leader, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tank, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_L_STORE)

	spawn_weapon(/obj/item/weapon/gun/smg/m39/elite, /obj/item/ammo_magazine/smg/m39/ap, H, 0, 0)

/datum/equipment_preset/pmc/pmc_crewman/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/veteran/pmc/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/pmc, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/pmc, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/pmc/hvh, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("MRE", 0,  /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Armored Balaclava", 0, /obj/item/clothing/mask/gas/pmc, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Armored Beret", 0, /obj/item/clothing/head/helmet/marine/veteran/pmc/leader, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Armor", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc/leader, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Lifesaver Bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full/dutch, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Medical Storage Rig (Full)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/large_holster/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M40 Grenade Rig", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch (Full)", 0, /obj/item/storage/pouch/autoinjector/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Bayonet Sheath (Full)", 0, /obj/item/storage/pouch/bayonet, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/pmc/pmc_crewman/get_antag_gear_equipment()
	return list(

		list("SQUAD LEADER SET (MANDATORY)", 0, null, null, null),
		list("Essential SL Set", 0, /obj/effect/essentials_set/leader/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("GENERAL SUPPLIES", 0, null, null, null),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Insulated Gloves", 3, /obj/item/clothing/gloves/yellow, null, VENDOR_ITEM_REGULAR),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),
		list("Tools Pouch (Full)", 5, /obj/item/storage/pouch/tools/full, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 5, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),

		list("SPECIAL AMMUNITION", 0, null, null, null), //pmcs can get TWO HEAP magazines, maximum.
		list("M41A HEAP magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/heap, null, VENDOR_ITEM_REGULAR),
		list("M39 HEAP magazine (10x20mm)", 20, /obj/item/ammo_magazine/smg/m39/heap, null, VENDOR_ITEM_REGULAR),
		list("NSG23 HEAP magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/nsg23/heap, null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("M12 Blast Grenade", 15, /obj/item/explosive/grenade/high_explosive/pmc, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 10, /obj/item/clothing/accessory/storage/holster, null, VENDOR_ITEM_REGULAR),
		list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 10, /obj/item/clothing/accessory/storage/droppouch, null, VENDOR_ITEM_REGULAR),
	)

/*****************************************************************************************************/

/datum/equipment_preset/pmc/xeno_handler
	name = "Weyland-Yutani PMC (Xeno Handler)"
	flags = EQUIPMENT_PRESET_EXTRA

	faction_group = FACTION_LIST_MARINE_WY

	assignment = JOB_PMC_XENO_HANDLER
	rank = JOB_PMC_XENO_HANDLER
	paygrade = "PMC-XS"
	role_comm_title = "XH"
	skills = /datum/skills/pmc/xeno_handler
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE, LANGUAGE_XENOMORPH)
	headset_type = /obj/item/device/radio/headset/distress/pmc/command

/datum/equipment_preset/pmc/xeno_handler/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc, WEAR_FACE)
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/multitool, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)

	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/splint, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_ACCESSORY)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/pmc, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88, WEAR_WAIST)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)

/datum/equipment_preset/pmc/xeno_handler/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/veteran/pmc/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/pmc, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/pmc, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/pmc/hvh, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("MRE", 0,  /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Armored Balaclava", 0, /obj/item/clothing/mask/gas/pmc, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Tactical Cap", 0, /obj/item/clothing/head/helmet/marine/veteran/pmc, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Standard Armor", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("Light Armor", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc/light, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Lifesaver Bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full/dutch, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Medical Storage Rig (Full)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/large_holster/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M40 Grenade Rig", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch (Full)", 0, /obj/item/storage/pouch/autoinjector/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Bayonet Sheath (Full)", 0, /obj/item/storage/pouch/bayonet, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/pmc/xeno_handler/get_antag_gear_equipment()
	return list(

		list("SQUAD LEADER SET (MANDATORY)", 0, null, null, null),
		list("Essential SL Set", 0, /obj/effect/essentials_set/leader/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("GENERAL SUPPLIES", 0, null, null, null),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Insulated Gloves", 3, /obj/item/clothing/gloves/yellow, null, VENDOR_ITEM_REGULAR),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),
		list("Tools Pouch (Full)", 5, /obj/item/storage/pouch/tools/full, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 5, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),

		list("SPECIAL AMMUNITION", 0, null, null, null), //pmcs can get TWO HEAP magazines, maximum.
		list("M41A HEAP magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/heap, null, VENDOR_ITEM_REGULAR),
		list("M39 HEAP magazine (10x20mm)", 20, /obj/item/ammo_magazine/smg/m39/heap, null, VENDOR_ITEM_REGULAR),
		list("NSG23 HEAP magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/nsg23/heap, null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("M12 Blast Grenade", 15, /obj/item/explosive/grenade/high_explosive/pmc, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 10, /obj/item/clothing/accessory/storage/holster, null, VENDOR_ITEM_REGULAR),
		list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 10, /obj/item/clothing/accessory/storage/droppouch, null, VENDOR_ITEM_REGULAR),
	)

/*****************************************************************************************************/

/datum/equipment_preset/pmc/doctor
	name = "Weyland-Yutani PMC (Trauma Surgeon)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_PMC_DOCTOR
	rank = JOB_PMC_DOCTOR
	paygrade = "PMC-DOC"
	role_comm_title = "TRI"
	skills = /datum/skills/pmc/doctor
	headset_type = /obj/item/device/radio/headset/distress/pmc/medic

/datum/equipment_preset/pmc/doctor/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/leader, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc, WEAR_FACE)
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/surg_vest/equipped, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)

	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite, WEAR_J_STORE)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/pressurized_reagent_canister/oxycodone, WEAR_R_STORE) //surgery


/datum/equipment_preset/pmc/doctor/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/veteran/pmc/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/pmc, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/pmc, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/pmc/hvh, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("MRE", 0,  /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Armored Balaclava", 0, /obj/item/clothing/mask/gas/pmc, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Armored Beret", 0, /obj/item/clothing/head/helmet/marine/veteran/pmc/leader, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Standard Armor", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("Light Armor", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc/light, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Lifesaver Bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full/dutch, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Medical Storage Rig (Full)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/large_holster/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M40 Grenade Rig", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Bicaridine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Kelotane)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/pmc/doctor/get_antag_gear_equipment()
	return list(
		list("MEDIC SET (MANDATORY)", 0, null, null, null),
		list("Essential Medic Set", 0, /obj/effect/essentials_set/medic, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("FIELD SUPPLIES", 0, null, null, null),
		list("Adv Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_RECOMMENDED),
		list("Adv Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_RECOMMENDED),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_RECOMMENDED),

		list("FIRSTAID KITS", 0, null, null, null),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_RECOMMENDED),
		list("Firstaid Kit", 5, /obj/item/storage/firstaid/regular, null, VENDOR_ITEM_REGULAR),
		list("Fire Firstaid Kit", 6, /obj/item/storage/firstaid/fire, null, VENDOR_ITEM_REGULAR),
		list("Toxin Firstaid Kit", 6, /obj/item/storage/firstaid/toxin, null, VENDOR_ITEM_REGULAR),
		list("Oxygen Firstaid Kit", 6, /obj/item/storage/firstaid/o2, null, VENDOR_ITEM_REGULAR),
		list("Radiation Firstaid Kit", 6, /obj/item/storage/firstaid/rad, null, VENDOR_ITEM_REGULAR),

		list("AUTOINJECTORS", 0, null, null, null),
		list("Autoinjector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Epinephrine)", 2, /obj/item/reagent_container/hypospray/autoinjector/adrenaline, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (QuickClot)", 1, /obj/item/reagent_container/hypospray/autoinjector/quickclot, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("PILL BOTTLES", 0, null, null, null),
		list("Pill Bottle (Bicaridine)", 5, /obj/item/storage/pill_bottle/bicaridine, null, VENDOR_ITEM_RECOMMENDED),
		list("Pill Bottle (Dexalin)", 5, /obj/item/storage/pill_bottle/dexalin, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Dylovene)", 5, /obj/item/storage/pill_bottle/antitox, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Inaprovaline)", 5, /obj/item/storage/pill_bottle/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Kelotane)", 5, /obj/item/storage/pill_bottle/kelotane, null, VENDOR_ITEM_RECOMMENDED),
		list("Pill Bottle (Peridaxon)", 5, /obj/item/storage/pill_bottle/peridaxon, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (QuickClot)", 5, /obj/item/storage/pill_bottle/quickclot, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Tramadol)", 5, /obj/item/storage/pill_bottle/tramadol, null, VENDOR_ITEM_RECOMMENDED),

		list("MEDICAL UTILITIES", 0, null, null, null),
		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_REGULAR),
		list("Roller Bed", 4, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Stasis Bag", 6, /obj/item/bodybag/cryobag, null, VENDOR_ITEM_REGULAR),

		list("SPECIAL AMMUNITION", 0, null, null, null), //pmcs can get TWO HEAP magazines, maximum.
		list("M41A HEAP magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/heap, null, VENDOR_ITEM_REGULAR),
		list("M39 HEAP magazine (10x20mm)", 20, /obj/item/ammo_magazine/smg/m39/heap, null, VENDOR_ITEM_REGULAR),
		list("NSG23 HEAP magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/nsg23/heap, null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("M12 Blast Grenade", 15, /obj/item/explosive/grenade/high_explosive/pmc, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 10, /obj/item/clothing/accessory/storage/holster, null, VENDOR_ITEM_REGULAR),
		list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 10, /obj/item/clothing/accessory/storage/droppouch, null, VENDOR_ITEM_REGULAR),
	)

/*****************************************************************************************************/

/datum/equipment_preset/pmc/technician
	name = "Weyland-Yutani PMC (Corporate Technician)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_PMC_ENGINEER
	rank = JOB_PMC_ENGINEER
	paygrade = "PMC-TECH"
	role_comm_title = "TEC"
	skills = /datum/skills/pmc/engineer
	headset_type = /obj/item/device/radio/headset/distress/pmc/cct

/datum/equipment_preset/pmc/technician/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc, WEAR_FACE)
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest/brown_vest, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding/superior, WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_JACKET)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/pmc, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/pmc, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/shovel/etool/folded, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/mini, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/mini, WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full, WEAR_R_STORE)

/datum/equipment_preset/pmc/technician/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/veteran/pmc/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/pmc, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/pmc, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/pmc/hvh, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Welding Goggles", 0, /obj/item/clothing/glasses/welding/superior, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("MRE", 0,  /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Armored Balaclava", 0, /obj/item/clothing/mask/gas/pmc, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Tactical Cap", 0, /obj/item/clothing/head/helmet/marine/veteran/pmc, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Standard Armor", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("Light Armor", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc/light, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/large_holster/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Mortar Operator Belt", 0, /obj/item/storage/belt/gun/mortarbelt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),
		list("M276 M40 Grenade Rig", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Construction Pouch", 0, /obj/item/storage/pouch/construction, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Electronics Pouch (Full)", 0, /obj/item/storage/pouch/electronics/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Bayonet Sheath (Full)", 0, /obj/item/storage/pouch/bayonet, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Small Document Pouch", 0, /obj/item/storage/pouch/document/small, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/pmc/technician/get_antag_gear_equipment()
	return list(
		list("TECHNICIAN SET (MANDATORY)", 0, null, null, null),
		list("Essential Engineer Set", 0, /obj/effect/essentials_set/engi, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("HANDHELD DEFENSE (CHOOSE 1)", 0, null, null, null),
		list("JIMA Planted Flag", 0, /obj/item/defenses/handheld/planted_flag, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),
		list("UA 42-F Sentry Flamer", 0, /obj/item/defenses/handheld/sentry/flamer, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),
		list("UA 571-C Sentry Gun", 0, /obj/item/defenses/handheld/sentry, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Airlock Circuit Board", 2, /obj/item/circuitboard/airlock, null, VENDOR_ITEM_REGULAR),
		list("APC Circuit Board", 2, /obj/item/circuitboard/apc, null, VENDOR_ITEM_REGULAR),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("High-Capacity Power Cell", 3, /obj/item/cell/high, null, VENDOR_ITEM_REGULAR),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),

		list("SPECIAL AMMUNITION", 0, null, null, null), //pmcs can get TWO HEAP magazines, maximum.
		list("M41A HEAP magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/heap, null, VENDOR_ITEM_REGULAR),
		list("M39 HEAP magazine (10x20mm)", 20, /obj/item/ammo_magazine/smg/m39/heap, null, VENDOR_ITEM_REGULAR),
		list("NSG23 HEAP magazine (10x24mm)", 20, /obj/item/ammo_magazine/rifle/nsg23/heap, null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("M12 Blast Grenade", 15, /obj/item/explosive/grenade/high_explosive/pmc, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 10, /obj/item/clothing/accessory/storage/holster, null, VENDOR_ITEM_REGULAR),
		list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 10, /obj/item/clothing/accessory/storage/droppouch, null, VENDOR_ITEM_REGULAR),
	)

/*****************************************************************************************************/

/datum/equipment_preset/pmc/director
	name = "Weyland-Yutani PMC (Site Director)"
	flags = EQUIPMENT_PRESET_EXTRA

	languages = ALL_HUMAN_LANGUAGES

	assignment = JOB_PMC_DIRECTOR
	rank = JOB_PMC_DIRECTOR
	paygrade = "PMC-DIR"
	role_comm_title = "DIR"
	skills = /datum/skills/pmc/director
	headset_type = /obj/item/device/radio/headset/distress/pmc/command/director

/datum/equipment_preset/pmc/director/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/director, WEAR_HEAD)
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/director, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/director, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/pmc, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable, WEAR_BACK)

	var/obj/item/storage/pouch/pistol/command/command_pouch = new(H)
	command_pouch.desc = replacetext(command_pouch.desc, "Captains", "corporate PMC directors")
	H.equip_to_slot_or_del(command_pouch, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/cotablet/pmc(H), WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range(H), WEAR_IN_L_STORE)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_R_STORE)

	var/obj/item/device/radio/headset/R = H.wear_l_ear
	if(istype(R))
		R.volume = RADIO_VOLUME_CRITICAL

//*****************************************************************************************************/

/datum/equipment_preset/pmc/synth
		name = "Weyland-Yutani PMC (Support Synthetic)"
		flags = EQUIPMENT_PRESET_EXTRA

		languages = ALL_SYNTH_LANGUAGES

		skills = /datum/skills/synthetic
		idtype = /obj/item/card/id/data
		assignment = JOB_PMC_SYNTH
		rank = JOB_PMC_SYNTH
		role_comm_title = "SYN"
		headset_type = /obj/item/device/radio/headset/distress/pmc/command


/datum/equipment_preset/pmc/synth/load_name(mob/living/carbon/human/H, randomise)
	H.gender = pick(50;MALE,50;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	if(prob(10))
		random_name = "[capitalize(randomly_generate_japanese_word(rand(2, 3)))]"
	else if(H.gender == MALE)
		random_name = "[pick(first_names_male_pmc)]"
	else
		random_name = "[pick(first_names_female_pmc)]"

	if(H.gender == MALE)
		H.f_style = "5 O'clock Shadow"

	H.change_real_name(H, random_name)
	H.r_hair = 15
	H.g_hair = 15
	H.b_hair = 25
	H.r_eyes = 139
	H.g_eyes = 62
	H.b_eyes = 19

/datum/equipment_preset/pmc/synth/load_race(mob/living/carbon/human/H)
		H.set_species(SYNTH_GEN_THREE)

/datum/equipment_preset/pmc/synth/load_skills(mob/living/carbon/human/H)
		H.set_skills(/datum/skills/synthetic)
		H.allow_gun_usage = FALSE

/datum/equipment_preset/pmc/synth/load_gear(mob/living/carbon/human/H)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc, WEAR_BODY)
		H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/surg_vest/equipped, WEAR_ACCESSORY)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/synth, WEAR_JACKET)
		H.equip_to_slot_or_del(new /obj/item/weapon/melee/telebaton, WEAR_IN_JACKET)
		H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_JACKET)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/nailgun, WEAR_IN_JACKET)

		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc, WEAR_HEAD)
		H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/experimental_mesons, WEAR_EYES)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc, WEAR_FACE)

		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)

		H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/smartpack/white, WEAR_BACK)
		H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/nailgun, WEAR_IN_BACK)
		new /obj/item/clothing/suit/auto_cpr(H.back)

		H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch, WEAR_WAIST)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun/compact, WEAR_J_STORE)

		H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical, WEAR_L_STORE)
		H.equip_to_slot_or_del(new /obj/item/tool/screwdriver/tactical, WEAR_IN_L_STORE)
		H.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_L_STORE)
		H.equip_to_slot_or_del(new /obj/item/tool/wirecutters/tactical, WEAR_IN_L_STORE)
		H.equip_to_slot_or_del(new /obj/item/tool/wrench, WEAR_IN_L_STORE)
		H.equip_to_slot_or_del(new /obj/item/stack/cable_coil, WEAR_IN_L_STORE)
		H.equip_to_slot_or_del(new /obj/item/stack/cable_coil, WEAR_IN_L_STORE)
		H.equip_to_slot_or_del(new /obj/item/device/multitool, WEAR_IN_L_STORE)
		H.equip_to_slot_or_del(new /obj/item/tool/weldingtool/hugetank, WEAR_IN_L_STORE)
		H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full_barbed_wire, WEAR_R_STORE)

/datum/equipment_preset/pmc/synth/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/veteran/pmc/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/pmc, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/pmc, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/pmc/hvh, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("MRE", 0,  /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Armored Balaclava", 0, /obj/item/clothing/mask/gas/pmc, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Synthetic Vest", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc/light/synth, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Tactical Cap", 0, /obj/item/clothing/head/helmet/marine/veteran/pmc, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("WEBBING (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Surgical Webbing Vest (Equipped)", 0, /obj/item/clothing/accessory/storage/surg_vest/equipped, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Surgical Webbing Vest (Blue)(Equipped)", 0, /obj/item/clothing/accessory/storage/surg_vest/blue/equipped, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Tool Webbing", 0, /obj/item/clothing/accessory/storage/black_vest/tool_webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Smartpack, Blue", 0, /obj/item/storage/backpack/marine/smartpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Smartpack, Green", 0, /obj/item/storage/backpack/marine/smartpack/green, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Smartpack, Tan", 0, /obj/item/storage/backpack/marine/smartpack/tan, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Smartpack, White", 0, /obj/item/storage/backpack/marine/smartpack/white, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Smartpack, Black", 0, /obj/item/storage/backpack/marine/smartpack/black, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Logistics IMP Backpack", 0, /obj/item/storage/backpack/marine/satchel/big, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Lifesaver Bag", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Medical Storage Belt", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Construction Pouch", 0, /obj/item/storage/pouch/construction, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Document Pouch", 0, /obj/item/storage/pouch/document, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Electronics Pouch (Full)", 0, /obj/item/storage/pouch/electronics/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Bicaridine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Kelotane)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Revival Mix)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Oxycodone)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/oxycodone, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Machete Pouch (Full)", 0, /obj/item/storage/pouch/machete/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

	)

/datum/equipment_preset/pmc/synth/get_antag_gear_equipment()
	return list(
		list("MEDIC SET (MANDATORY)", 0, null, null, null),
		list("Essential Medic Set", 0, /obj/effect/essentials_set/medic, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("FIELD SUPPLIES", 0, null, null, null),
		list("Adv Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_RECOMMENDED),
		list("Adv Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_RECOMMENDED),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_RECOMMENDED),

		list("FIRSTAID KITS", 0, null, null, null),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_RECOMMENDED),
		list("Firstaid Kit", 5, /obj/item/storage/firstaid/regular, null, VENDOR_ITEM_REGULAR),
		list("Fire Firstaid Kit", 6, /obj/item/storage/firstaid/fire, null, VENDOR_ITEM_REGULAR),
		list("Toxin Firstaid Kit", 6, /obj/item/storage/firstaid/toxin, null, VENDOR_ITEM_REGULAR),
		list("Oxygen Firstaid Kit", 6, /obj/item/storage/firstaid/o2, null, VENDOR_ITEM_REGULAR),
		list("Radiation Firstaid Kit", 6, /obj/item/storage/firstaid/rad, null, VENDOR_ITEM_REGULAR),

		list("AUTOINJECTORS", 0, null, null, null),
		list("Autoinjector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Epinephrine)", 2, /obj/item/reagent_container/hypospray/autoinjector/adrenaline, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (QuickClot)", 1, /obj/item/reagent_container/hypospray/autoinjector/quickclot, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("PILL BOTTLES", 0, null, null, null),
		list("Pill Bottle (Bicaridine)", 5, /obj/item/storage/pill_bottle/bicaridine, null, VENDOR_ITEM_RECOMMENDED),
		list("Pill Bottle (Dexalin)", 5, /obj/item/storage/pill_bottle/dexalin, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Dylovene)", 5, /obj/item/storage/pill_bottle/antitox, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Inaprovaline)", 5, /obj/item/storage/pill_bottle/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Kelotane)", 5, /obj/item/storage/pill_bottle/kelotane, null, VENDOR_ITEM_RECOMMENDED),
		list("Pill Bottle (Peridaxon)", 5, /obj/item/storage/pill_bottle/peridaxon, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (QuickClot)", 5, /obj/item/storage/pill_bottle/quickclot, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Tramadol)", 5, /obj/item/storage/pill_bottle/tramadol, null, VENDOR_ITEM_RECOMMENDED),

		list("MEDICAL UTILITIES", 0, null, null, null),
		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_REGULAR),
		list("Roller Bed", 4, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Stasis Bag", 6, /obj/item/bodybag/cryobag, null, VENDOR_ITEM_REGULAR),

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Airlock Circuit Board", 2, /obj/item/circuitboard/airlock, null, VENDOR_ITEM_REGULAR),
		list("APC Circuit Board", 2, /obj/item/circuitboard/apc, null, VENDOR_ITEM_REGULAR),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("High-Capacity Power Cell", 3, /obj/item/cell/high, null, VENDOR_ITEM_REGULAR),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),,

		list("UTILITIES", 0, null, null, null),
		list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 10, /obj/item/clothing/accessory/storage/holster, null, VENDOR_ITEM_REGULAR),
		list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 10, /obj/item/clothing/accessory/storage/droppouch, null, VENDOR_ITEM_REGULAR),
	)

