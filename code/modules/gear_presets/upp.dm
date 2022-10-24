/datum/equipment_preset/upp
	name = FACTION_UPP
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_ENGLISH)
	faction = FACTION_UPP
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/upp/New()
	. = ..()
	access = get_antagonist_access()

/datum/equipment_preset/upp/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(60;MALE,40;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	var/first_name
	var/last_name
	//gender checks
	if(H.gender == MALE)
		if(prob(40))
			first_name = "[capitalize(randomly_generate_chinese_word(1))]"
		else
			first_name = "[pick(first_names_male_upp)]"
		H.f_style = pick("3 O'clock Shadow", "3 O'clock Moustache", "5 O'clock Shadow", "5 O'clock Moustache")
	else
		if(prob(40))
			first_name = "[capitalize(randomly_generate_chinese_word(1))]"
		else
			first_name = "[pick(first_names_female_upp)]"
	//surname
	if(prob(35))
		last_name = "[capitalize(randomly_generate_chinese_word(pick(20;1, 80;2)))]"
	else
		last_name = "[pick(last_names_upp)]"
	//put them together
	random_name = "[first_name] [last_name]"

	H.change_real_name(H, random_name)
	H.age = rand(17,35)
	H.h_style = pick("Crewcut", "Shaved Head", "Buzzcut", "Undercut", "Side Undercut", "Bun, Topknot")
	var/static/list/colors = list("BLACK" = list(15, 15, 25), "BROWN" = list(102, 51, 0), "AUBURN" = list(139, 62, 19))
	var/static/list/hair_colors = colors.Copy() + list("BLONDE" = list(197, 164, 30), "CARROT" = list(174, 69, 42))
	var/hair_color = pick(hair_colors)
	H.r_hair = hair_colors[hair_color][1]
	H.g_hair = hair_colors[hair_color][2]
	H.b_hair = hair_colors[hair_color][3]
	H.r_facial = hair_colors[hair_color][1]
	H.g_facial = hair_colors[hair_color][2]
	H.b_facial = hair_colors[hair_color][3]
	var/eye_color = pick(colors)
	H.r_eyes = colors[eye_color][1]
	H.g_eyes = colors[eye_color][2]
	H.b_eyes = colors[eye_color][3]
	idtype = /obj/item/card/id/dogtag

//*****************************************************************************************************/

/datum/equipment_preset/upp/soldier
	name = "UPP Soldier"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp
	assignment = JOB_UPP
	rank = JOB_UPP
	role_comm_title = "Sol"
	paygrade = "UE1"

/datum/equipment_preset/upp/soldier/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	H.equip_to_slot_or_del(UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

	load_upp_soldier(H, UPP)

/datum/equipment_preset/upp/soldier/proc/load_upp_soldier(mob/living/carbon/human/H, obj/item/clothing/under/marine/veteran/UPP/UPP)
	var/percentage = rand(1, 100)
	switch(percentage)
		//most UPP are rifleman, most others are breachers, some have both primaries.
		if(1 to 66)
			load_upp_rifleman(H, UPP)
		if(67 to 85)
			load_upp_breacher(H, UPP)
		else
			load_upp_double(H, UPP)

/datum/equipment_preset/upp/soldier/proc/load_upp_rifleman(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //.75
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //1.5
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_BACK) //2.25
	H.equip_to_slot_or_del(new /obj/item/storage/box/m94, WEAR_IN_BACK) //3.25
	H.equip_to_slot_or_del(new /obj/item/storage/box/m94, WEAR_IN_BACK) //4.25
	//body
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/rifleman, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp/full, WEAR_WAIST)
	//rpocket
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_R_STORE)
	//lpocket
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)

/datum/equipment_preset/upp/soldier/proc/load_upp_breacher(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //.75
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //1.5
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_BACK) //2.25
	H.equip_to_slot_or_del(new /obj/item/storage/box/m94, WEAR_IN_BACK) //3.25
	H.equip_to_slot_or_del(new /obj/item/storage/box/m94, WEAR_IN_BACK) //4.25
	//waist
	var/gunbelt = prob(50) ? /obj/item/storage/belt/gun/type47/NY : /obj/item/storage/belt/gun/type47/PK9
	H.equip_to_slot_or_del(new gunbelt, WEAR_WAIST)
	pick_ammotype(H)

/datum/equipment_preset/upp/soldier/proc/pick_ammotype(mob/living/carbon/human/H)
	var/percentage = rand(1, 100)
	switch(percentage)
		if(1 to 33)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/type23/breacher, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/heavybuck, WEAR_L_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/heavybuck, WEAR_R_STORE)
		if(34 to 66)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/type23/breacher/slug, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/heavyslug, WEAR_L_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/heavyslug, WEAR_R_STORE)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/type23/breacher/flechette, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/heavyflechette, WEAR_L_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/heavyflechette, WEAR_R_STORE)

/datum/equipment_preset/upp/soldier/proc/load_upp_double(mob/living/carbon/human/H, obj/item/clothing/under/marine/veteran/UPP/UPP)
	//back
	var/rifle = prob(50) ? /obj/item/weapon/gun/rifle/type71/dual : /obj/item/weapon/gun/rifle/type71/carbine/dual
	H.equip_to_slot_or_del(new rifle, WEAR_BACK)
	//body
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/type23/dual, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp/full, WEAR_WAIST)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/heavybuck, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)

/datum/equipment_preset/upp/soldier/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("UM5 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("HELMET", 0, null, null, null),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Type 41 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/soldier/get_antag_gear_equipment()
	return list(
		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_RECOMMENDED),
		list("Sandbags x25", 5, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),

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
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/HE/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

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

/datum/equipment_preset/upp/medic
	name = "UPP Medic"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/combat_medic
	assignment = JOB_UPP_MEDIC
	rank = JOB_UPP_MEDIC
	role_comm_title = "Med"
	paygrade = "UE3M"

/datum/equipment_preset/upp/medic/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator/compact, WEAR_IN_BACK) //1
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK) //2
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK) //2.33
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //3
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //3.33
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap, WEAR_HEAD)
	//body
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/medic, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/skorpion/upp/medic, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//póckets
	var/obj/item/storage/pouch/magazine/pistol/large/ppouch = new()
	H.equip_to_slot_or_del(ppouch, WEAR_R_STORE)
	for(var/i = 1 to ppouch.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/skorpion, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/tricordrazine, WEAR_IN_L_STORE)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

/datum/equipment_preset/upp/medic/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Medic Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP/medic, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("UM5 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("HealthMate HUD", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BELT", 0, null, null, null),
		list("Type 41 Lifesaver Bag", 0, /obj/item/storage/belt/medical/lifesaver/upp/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medical Pouch (Utilities)", 0, /obj/item/storage/pouch/medical/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medical Pouch (Pills)", 0, /obj/item/storage/pouch/medical/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/medic/get_antag_gear_equipment()
	return list(
		list("MEDIC SET (MANDATORY)", 0, null, null, null),
		list("Essential Medic Set", 0, /obj/effect/essentials_set/medic/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

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

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),

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
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/HE/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

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

/datum/equipment_preset/upp/sapper
	name = "UPP Sapper"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/combat_engineer
	assignment = JOB_UPP_ENGI
	rank = JOB_UPP_ENGI
	role_comm_title = "Sap"
	paygrade = "UE3S"

/datum/equipment_preset/upp/sapper/load_gear(mob/living/carbon/human/H)
	//Sappers should have lots of gear and whatnot that helps them attack or siege marines
	//But that'll need a lot of effort so for now they are just soldiers with a toolbox.
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //.33
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //.66
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked, WEAR_IN_BACK) //1.66
	H.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/mini, WEAR_IN_BACK) //2.66
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/cct, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas, WEAR_FACE)
	//head
	var/headgear = prob(70) ? /obj/item/clothing/head/helmet/marine/veteran/UPP/engi : /obj/item/clothing/head/uppcap/ushanka
	H.equip_to_slot_or_del(new headgear, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/engi/UPP = new()
	var/obj/item/clothing/accessory/storage/black_vest/tool_webbing/W = new()
	UPP.attach_accessory(H, W)
	H.equip_to_slot_or_del(UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/sapper, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp/sapper(H), WEAR_WAIST)
	//limb
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_R_STORE)

/datum/equipment_preset/upp/sapper/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("UM5 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP/cct, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Welding Goggles", 0, /obj/item/clothing/glasses/welding, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Welderpack", 0, /obj/item/storage/backpack/marine/engineerpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BELT (Choose 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 41 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (Choose 2)", 0, null, null, null),
		list("Construction Pouch", 0, /obj/item/storage/pouch/construction, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Electronics Pouch (Full)", 0, /obj/item/storage/pouch/electronics/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/sapper/get_antag_gear_equipment()
	return list(
		list("SAPPER SET (MANDATORY)", 0, null, null, null),
		list("Essential Sapper Set", 0, /obj/effect/essentials_set/engi, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

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

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/HE/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

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

/datum/equipment_preset/upp/specialist
	name = "UPP Specialist"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/specialist
	assignment = JOB_UPP_SPECIALIST
	rank = JOB_UPP_SPECIALIST
	role_comm_title = "Spc"
	paygrade = "UE5"

/datum/equipment_preset/upp/specialist/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_BACK) //1
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //1.33
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //1.66
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_IN_BACK) //2
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_IN_BACK) //2.33
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_IN_BACK) //2.66
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/heavy, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	H.equip_to_slot_or_del(UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, WEAR_JACKET)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

	var/obj/item/device/internal_implant/subdermal_armor/implant = new()
	implant.on_implanted(H)

	//body
	var/obj/item/clothing/accessory/storage/black_vest/W = new()
	UPP.attach_accessory(H, W)
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/heavy/dragonsbreath, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/type23/dragon, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/heavy/dragonsbreath, WEAR_IN_JACKET)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/NY, WEAR_WAIST)

/datum/equipment_preset/upp/specialist/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("UH7 Heavy Plated Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/PMC, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("HELMET", 0, null, null, null),
		list("UM7 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP/heavy, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Type 41 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/specialist/get_antag_gear_equipment()
	return list(
		list("HEAVY SET (MANDATORY)", 0, null, null, null),
		list("Essential Heavy Set", 0, /obj/effect/essentials_set/upp_heavy, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Rotating Ammo Drum (7.62x51mm)", 15, /obj/item/ammo_magazine/minigun , null, VENDOR_ITEM_RECOMMENDED),

		list("ATTACHMENTS (NONE FIT GSh-7.62)", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/HE/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

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

/datum/equipment_preset/upp/minigunner
	name = "UPP Minigunner"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/specialist
	assignment = JOB_UPP_SPECIALIST
	rank = JOB_UPP_SPECIALIST
	role_comm_title = "Spc"
	paygrade = "UE5"

/datum/equipment_preset/upp/minigunner/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_BACK) //1
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //1.33
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //1.66
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_IN_BACK) //2
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_IN_BACK) //2.33
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_IN_BACK) //2.66
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/heavy, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	H.equip_to_slot_or_del(UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, WEAR_JACKET)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

	var/obj/item/device/internal_implant/subdermal_armor/implant = new()
	implant.on_implanted(H)

	//body
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/minigun/upp, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun, WEAR_IN_JACKET)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/NY/shrapnel, WEAR_WAIST)

/datum/equipment_preset/upp/minigunner/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("UH7 Heavy Plated Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/PMC, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("HELMET", 0, null, null, null),
		list("UM7 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP/heavy, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Type 41 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/minigunner/get_antag_gear_equipment()
	return list(
		list("HEAVY SET (MANDATORY)", 0, null, null, null),
		list("Essential Heavy Set", 0, /obj/effect/essentials_set/upp_heavy, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Rotating Ammo Drum (7.62x51mm)", 15, /obj/item/ammo_magazine/minigun , null, VENDOR_ITEM_RECOMMENDED),

		list("ATTACHMENTS (NONE FIT GSh-7.62)", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/HE/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

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

/datum/equipment_preset/upp/leader
	name = "UPP Squad Leader"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/SL
	assignment = JOB_UPP_LEADER
	rank = JOB_UPP_LEADER
	role_comm_title = "SL"
	paygrade = "UE6"

/datum/equipment_preset/upp/leader/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/jima, WEAR_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/cct, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	UPP.attach_accessory(H, W)
	H.equip_to_slot_or_del(UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/NY/shrapnel, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/flamertank, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

/datum/equipment_preset/upp/leader/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("UH7 Heavy Plated Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP/cct, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Beret", 0, /obj/item/clothing/head/uppcap/beret, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 41 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/leader/get_antag_gear_equipment()
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

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Adv Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("Adv Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),

		list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Injector (QuickClot)", 1, /obj/item/reagent_container/hypospray/autoinjector/quickclot, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_MANDATORY),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/HE/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

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

/datum/equipment_preset/upp/military_police
	name = "UPP Military Police"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/military_police
	assignment = JOB_UPP_POLICE
	rank = JOB_UPP_POLICE
	role_comm_title = "MP"
	paygrade = "UE6"

/datum/equipment_preset/upp/military_police/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp, WEAR_FACE)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/UPP/mp/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)
	H.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_ACCESSORY)
	//jacket
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/mp, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/UPP/full, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_R_STORE)

/datum/equipment_preset/upp/military_police/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP/mp, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("UL6 camouflaged jacket", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/mp, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Beret", 0, /obj/item/clothing/head/uppcap/beret, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM7 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP/heavy, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 41 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 43 Military Police Rig", 0, /obj/item/storage/belt/security/MP/UPP/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas/PMC/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/military_police/get_antag_gear_equipment()
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

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Adv Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("Adv Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),

		list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Injector (QuickClot)", 1, /obj/item/reagent_container/hypospray/autoinjector/quickclot, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_MANDATORY),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/HE/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

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

/datum/equipment_preset/upp/officer
	name = "UPP Lieutenant"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/officer
	assignment = JOB_UPP_LT_OFFICER
	rank = JOB_UPP_LT_OFFICER
	role_comm_title = "Lt."
	paygrade = "UO1"

/datum/equipment_preset/upp/officer/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/megaphone, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/cct, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/UPP/officer/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)
	H.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_ACCESSORY)
	//jacket
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/officer, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer/leader, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/NY, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_R_STORE)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

/datum/equipment_preset/upp/officer/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP/officer, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP/cct, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Beret", 0, /obj/item/clothing/head/uppcap/beret, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM7 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP/heavy, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("UL6 officers jacket", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/officer, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("UM5B Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/support, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 47 Pistol Holster Rig NY", 0, /obj/item/storage/belt/gun/type47/NY, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas/PMC/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/officer/get_antag_gear_equipment()
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

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Adv Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("Adv Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),

		list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Injector (QuickClot)", 1, /obj/item/reagent_container/hypospray/autoinjector/quickclot, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_MANDATORY),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/HE/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

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

/datum/equipment_preset/upp/officer/senior
	name = "UPP Senior Lieutenant"
	assignment = JOB_UPP_SRLT_OFFICER
	rank = JOB_UPP_SRLT_OFFICER
	role_comm_title = "Sr-Lt."
	paygrade = "UO1E"

/datum/equipment_preset/upp/officer/senior/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/megaphone, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/cct, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/UPP/officer/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)
	H.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_ACCESSORY)
	//jacket
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/officer, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer/leader, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/NY/shrapnel, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_R_STORE)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

/datum/equipment_preset/upp/officer/senior/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP/officer, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("UL6 officers jacket", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/officer, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP/cct, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Beret", 0, /obj/item/clothing/head/uppcap/beret, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM7 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP/heavy, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 47 Pistol Holster Rig NY", 0, /obj/item/storage/belt/gun/type47/NY/shrapnel, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas/PMC/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/officer/senior/get_antag_gear_equipment()
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

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Adv Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("Adv Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),

		list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Injector (QuickClot)", 1, /obj/item/reagent_container/hypospray/autoinjector/quickclot, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_MANDATORY),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/HE/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

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

/datum/equipment_preset/upp/officer/major
	name = "UPP Major"
	assignment = JOB_UPP_MAY_OFFICER
	rank = JOB_UPP_MAY_OFFICER
	role_comm_title = "May."
	paygrade = "UO3"

/datum/equipment_preset/upp/officer/major/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/megaphone, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/cct, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/peaked, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/UPP/officer/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)
	H.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_ACCESSORY)
	//jacket
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/kapitan, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer/leader, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/general/impact, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_R_STORE)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

/datum/equipment_preset/upp/officer/major/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP/officer, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("UL6 officers jacket", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/officer, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP/cct, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Peaked Cap", 0, /obj/item/clothing/head/uppcap/peaked, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM7 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP/heavy, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 47 Pistol Holster Rig NY", 0, /obj/item/storage/belt/gun/type47/NY/shrapnel, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas/PMC/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/officer/major/get_antag_gear_equipment()
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

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Adv Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("Adv Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),

		list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Injector (QuickClot)", 1, /obj/item/reagent_container/hypospray/autoinjector/quickclot, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_MANDATORY),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/HE/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

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

/datum/equipment_preset/upp/officer/kolonel
	name = "UPP Kolonel"
	assignment = JOB_UPP_KOL_OFFICER
	rank = JOB_UPP_KOL_OFFICER
	role_comm_title = "Kol."
	paygrade = "UO5"
	skills = /datum/skills/upp/commander

/datum/equipment_preset/upp/officer/kolonel/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/megaphone, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/cct, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/peaked, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/UPP/officer/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)
	H.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_ACCESSORY)
	//jacket
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/officer, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer/leader, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/general/impact, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_R_STORE)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

/datum/equipment_preset/upp/officer/kolonel/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP/officer, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("UL6 officers jacket", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/officer, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP/cct, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Peaked Cap", 0, /obj/item/clothing/head/uppcap/peaked, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM7 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP/heavy, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 47 Pistol Holster Rig NY", 0, /obj/item/storage/belt/gun/type47/NY/shrapnel, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas/PMC/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/officer/kolonel/get_antag_gear_equipment()
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

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Adv Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("Adv Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),

		list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Injector (QuickClot)", 1, /obj/item/reagent_container/hypospray/autoinjector/quickclot, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_MANDATORY),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/HE/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

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
/datum/equipment_preset/upp/sapper/survivor
	name = "UPP Sapper (Survivor)"

/datum/equipment_preset/upp/sapper/survivor/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/nagant, WEAR_IN_BACK) //1
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/upp, WEAR_IN_BACK) //1.3
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/upp, WEAR_IN_BACK) //1.6
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/upp, WEAR_IN_BACK) //2
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked, WEAR_IN_BACK) //3
	H.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/mini, WEAR_IN_BACK) //4
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/cct, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas, WEAR_FACE)
	//head
	var/headgear = prob(70) ? /obj/item/clothing/head/helmet/marine/veteran/UPP/engi : /obj/item/clothing/head/uppcap/ushanka
	H.equip_to_slot_or_del(new headgear, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/engi/UPP = new()
	var/obj/item/clothing/accessory/storage/black_vest/tool_webbing/W = new()
	UPP.attach_accessory(H, W)
	H.equip_to_slot_or_del(UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/type23/dual, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/upp/heavybuck(H), WEAR_WAIST)
	//limb
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_R_STORE)

//*****************************************************************************************************/
/datum/equipment_preset/upp/synth
	name = "UPP Combat Synthetic"
	flags = EQUIPMENT_PRESET_EXTRA

	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_ENGLISH, LANGUAGE_JAPANESE, LANGUAGE_YAUTJA, LANGUAGE_XENOMORPH, LANGUAGE_WELTRAUMDEUTSCH, LANGUAGE_NEOSPANISH, LANGUAGE_CHINESE)

	skills = /datum/skills/synthetic
	assignment = JOB_UPP_COMBAT_SYNTH
	rank = JOB_UPP_COMBAT_SYNTH
	paygrade = "SYN"
	idtype = /obj/item/card/id/gold

/datum/equipment_preset/upp/synth/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(50;MALE,50;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	if(prob(10))
		random_name = "[capitalize(randomly_generate_chinese_word(2))]"
	else if(H.gender == MALE)
		random_name = "[pick(first_names_male_upp)]"
	else
		random_name = "[pick(first_names_female_upp)]"

	if(H.gender == MALE)
		H.f_style = pick("3 O'clock Shadow", "3 O'clock Moustache", "5 O'clock Shadow", "5 O'clock Moustache")


	H.change_real_name(H, random_name)
	H.h_style = pick("Crewcut", "Shaved Head", "Buzzcut", "Undercut", "Side Undercut")
	var/static/list/colors = list("BLACK" = list(15, 15, 25), "BROWN" = list(102, 51, 0), "AUBURN" = list(139, 62, 19))
	var/static/list/hair_colors = colors.Copy() + list("BLONDE" = list(197, 164, 30), "CARROT" = list(174, 69, 42))
	var/hair_color = pick(hair_colors)
	H.r_hair = hair_colors[hair_color][1]
	H.g_hair = hair_colors[hair_color][2]
	H.b_hair = hair_colors[hair_color][3]
	H.r_facial = hair_colors[hair_color][1]
	H.g_facial = hair_colors[hair_color][2]
	H.b_facial = hair_colors[hair_color][3]
	var/eye_color = pick(colors)
	H.r_eyes = colors[eye_color][1]
	H.g_eyes = colors[eye_color][2]
	H.b_eyes = colors[eye_color][3]
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/upp/synth/load_race(mob/living/carbon/human/H)
	H.set_species(SYNTH_GEN_THREE)

/datum/equipment_preset/upp/synth/load_gear(mob/living/carbon/human/H)
	load_name(H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator/compact, WEAR_IN_BACK) //1
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK) //2
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK) //2.33
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //2.66
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //3
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //3.33
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/cct, WEAR_L_EAR)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	//head
	var/hat = pick(/obj/item/clothing/head/uppcap, /obj/item/clothing/head/uppcap/beret, /obj/item/clothing/head/uppcap/ushanka)
	H.equip_to_slot_or_del(new hat, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/medic/UPP = new()
	var/obj/item/clothing/accessory/storage/black_vest/tool_webbing/W = new()
	UPP.attach_accessory(H, W)
	H.equip_to_slot_or_del(UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/jacket, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/glass/bottle/tricordrazine, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/skorpion/upp/medic, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//póckets
	var/obj/item/storage/pouch/magazine/pistol/large/ppouch = new()
	H.equip_to_slot_or_del(ppouch, WEAR_R_STORE)
	for(var/i = 1 to ppouch.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/skorpion, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/tricordrazine, WEAR_IN_L_STORE)

/datum/equipment_preset/upp/synth/get_antag_clothing_equipment()
	return list(
		list("RADIO (TAKE ALL)", 0, null, null, null),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP/cct, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),

		list("WEBBING (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Surgical Webbing Vest", 0, /obj/item/clothing/accessory/storage/surg_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Surgical Webbing Vest (Blue)", 0, /obj/item/clothing/accessory/storage/surg_vest/blue, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("SHOES (CHOOSE 1)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),

		list("GLOVES (CHOOSE 1)", 0, null, null, null),
		list("Insulated Gloves", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_RECOMMENDED),
		list("Black Gloves", 0, /obj/item/clothing/gloves/black, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),
		list("Latex Gloves", 0, /obj/item/clothing/gloves/latex, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),

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
		list("Electronics Pouch (Full)", 0, /obj/item/storage/pouch/electronics/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("MASK", 0, null, null, null),
		list("Sterile mask", 0, /obj/item/clothing/mask/surgical, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/synth/get_antag_gear_equipment()
	return list(
		list("ENGINEER SUPPLIES", 0, null, null, null),
		list("Airlock Circuit Board", 2, /obj/item/circuitboard/airlock, null, VENDOR_ITEM_REGULAR),
		list("APC Circuit Board", 2, /obj/item/circuitboard/apc, null, VENDOR_ITEM_REGULAR),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("High-Capacity Power Cell", 3, /obj/item/cell/high, null, VENDOR_ITEM_REGULAR),
		list("Light Replacer", 2, /obj/item/device/lightreplacer, null, VENDOR_ITEM_REGULAR),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_REGULAR),
		list("Multitool", 4, /obj/item/device/multitool, null, VENDOR_ITEM_REGULAR),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_REGULAR),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_REGULAR),
		list("Industrial Blowtorch", 4, /obj/item/tool/weldingtool/largetank, null, VENDOR_ITEM_RECOMMENDED),

		list("FIRSTAID KITS", 0, null, null, null),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_RECOMMENDED),
		list("Firstaid Kit", 5, /obj/item/storage/firstaid/regular, null, VENDOR_ITEM_REGULAR),
		list("Fire Firstaid Kit", 6, /obj/item/storage/firstaid/fire, null, VENDOR_ITEM_REGULAR),
		list("Toxin Firstaid Kit", 6, /obj/item/storage/firstaid/toxin, null, VENDOR_ITEM_REGULAR),
		list("Oxygen Firstaid Kit", 6, /obj/item/storage/firstaid/o2, null, VENDOR_ITEM_REGULAR),
		list("Radiation Firstaid Kit", 6, /obj/item/storage/firstaid/rad, null, VENDOR_ITEM_REGULAR),

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Adv Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("Adv Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Medevac Bed", 6, /obj/item/roller/medevac, null, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),
		list("Roller Bed", 4, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Stasis Bag", 6, /obj/item/bodybag/cryobag, null, VENDOR_ITEM_REGULAR),

		list("Pillbottle (Bicaridine)", 5, /obj/item/storage/pill_bottle/bicaridine, null, VENDOR_ITEM_RECOMMENDED),
		list("Pillbottle (Dexalin)", 5, /obj/item/storage/pill_bottle/dexalin, null, VENDOR_ITEM_REGULAR),
		list("Pillbottle (Dylovene)", 5, /obj/item/storage/pill_bottle/antitox, null, VENDOR_ITEM_REGULAR),
		list("Pillbottle (Inaprovaline)", 5, /obj/item/storage/pill_bottle/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Pillbottle (Kelotane)", 5, /obj/item/storage/pill_bottle/kelotane, null, VENDOR_ITEM_RECOMMENDED),
		list("Pillbottle (Peridaxon)", 5, /obj/item/storage/pill_bottle/peridaxon, null, VENDOR_ITEM_REGULAR),
		list("Pillbottle (QuickClot)", 5, /obj/item/storage/pill_bottle/quickclot, null, VENDOR_ITEM_REGULAR),
		list("Pillbottle (Tramadol)", 5, /obj/item/storage/pill_bottle/tramadol, null, VENDOR_ITEM_RECOMMENDED),

		list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Injector (Epinephrine)", 2, /obj/item/reagent_container/hypospray/autoinjector/adrenaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Injector (QuickClot)", 1, /obj/item/reagent_container/hypospray/autoinjector/quickclot, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("Emergency Defibrillator", 4, /obj/item/device/defibrillator, null, VENDOR_ITEM_MANDATORY),
		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Surgical Line", 4, /obj/item/tool/surgery/surgical_line, null, VENDOR_ITEM_REGULAR),
		list("Synth-Graft", 4, /obj/item/tool/surgery/synthgraft, null, VENDOR_ITEM_REGULAR),

		list("OTHER SUPPLIES", 0, null, null, null),
		list("Binoculars", 5,/obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Rangefinder", 8, /obj/item/device/binoculars/range, null,  VENDOR_ITEM_REGULAR),
		list("Laser Designator", 12, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_RECOMMENDED),
		list("Flashlight", 1, /obj/item/device/flashlight, null, VENDOR_ITEM_RECOMMENDED),
		list("Fulton Recovery Device", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 5, /obj/item/device/motiondetector, null, VENDOR_ITEM_REGULAR),
		list("Space Cleaner", 2, /obj/item/reagent_container/spray/cleaner, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
	)

//*****************************************************************************************************/

/datum/equipment_preset/upp/conscript
	//meme role
	name = "UPP Conscript"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp
	assignment = JOB_UPP_CONSCRIPT
	rank = JOB_UPP_CONSCRIPT
	role_comm_title = "Cons"
	paygrade = "UE0"

/datum/equipment_preset/upp/conscript/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	//back
	var/maybebackpack = prob(20) ? pick(/obj/item/storage/backpack/lightpack/upp, /obj/item/storage/backpack/lightpack) : null
	if(maybebackpack)
		H.equip_to_slot_or_del(new maybebackpack, WEAR_BACK) //what in back?
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)

	//head
	var/maybehat = prob(66) ? pick(/obj/item/clothing/head/uppcap, /obj/item/clothing/head/uppcap/beret, /obj/item/clothing/head/ushanka, /obj/item/clothing/head/uppcap/ushanka) : null
	if(maybehat)
		H.equip_to_slot_or_del(new maybehat, WEAR_HEAD)

	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	H.equip_to_slot_or_del(UPP, WEAR_BODY)

	var/maybejacket = prob(50) ? pick(/obj/item/clothing/suit/storage/marine/faction/UPP/jacket, /obj/item/clothing/suit/storage/snow_suit/soviet) : null
	if(maybejacket)
		H.equip_to_slot_or_del(new maybejacket, WEAR_JACKET)
		H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_JACKET)
		H.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/vodka, WEAR_IN_JACKET)
		//limit of snowcoat
		H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_JACKET)

	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	var/maybegloves = prob(80) ? pick(/obj/item/clothing/gloves/black, /obj/item/clothing/gloves/marine/veteran, /obj/item/clothing/gloves/combat) : null
	if(maybegloves)
		H.equip_to_slot_or_del(new maybegloves, WEAR_HANDS)

	//gun
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/carbine, WEAR_R_HAND)

	//webbing or belt?
	if(prob(30))
		var/obj/item/clothing/accessory/storage/webbing/W = new()
		UPP.attach_accessory(H, W)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_ACCESSORY)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_ACCESSORY)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_ACCESSORY)
	else if(prob(30))
		H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp/scarce, WEAR_WAIST)
	//if you fail the rolls you must scavenge the ammo from your fallen brethren

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

	if(prob(10))
		//sometimes Ivan smiles upon the corps
		H.set_species("Human Hero")

/datum/equipment_preset/upp/conscript/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("HELMET", 0, null, null, null),
		list("Armored Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Armored Ushanka", 0, /obj/item/clothing/head/uppcap/ushanka, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Tactical Bandana", 0, /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/conscript/get_antag_gear_equipment()
	return list(
		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_RECOMMENDED),
		list("Sandbags x25", 5, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),

		list("EXPLOSIVES", 0, null, null, null),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 10, /obj/item/clothing/accessory/storage/droppouch, null, VENDOR_ITEM_REGULAR)
	)

//*****************************************************************************************************/

/datum/equipment_preset/upp/commando
	name = "UPP Commando"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/commando
	assignment = JOB_UPP_COMMANDO
	rank = JOB_UPP_COMMANDO
	role_comm_title = "JKdo"
	paygrade = "UC1"
	idtype = /obj/item/card/id/data
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_ENGLISH, LANGUAGE_TSL, LANGUAGE_NEOSPANISH)

/datum/equipment_preset/upp/commando/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/cct, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/commando, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/PK9/tranq, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp, WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)

	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_BACK)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine/commando, /obj/item/ammo_magazine/rifle/type71/ap, H, 0, 8)

/datum/equipment_preset/upp/commando/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/commando, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/PMC, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP/cct, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Night Vision Goggles", 0, /obj/item/clothing/glasses/night/m42_night_goggles/upp, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("UM5CU Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/commando, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("UPP Cloak", 0, /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("UPP Balaclava", 0, /obj/item/clothing/mask/gas/PMC/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 41 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/type47/PK9/tranq, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/commando/get_antag_gear_equipment()
	return list(
		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_RECOMMENDED),
		list("Sandbags x25", 5, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),

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
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/HE/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

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

/datum/equipment_preset/upp/commando/medic
	name = "UPP Commando Medic"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/commando/medic
	assignment = JOB_UPP_COMMANDO_MEDIC
	rank = JOB_UPP_COMMANDO_MEDIC
	role_comm_title = "2ndKdo"
	paygrade = "UC2"

/datum/equipment_preset/upp/commando/medic/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/cct, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/medic, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/commando, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp, WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(H), WEAR_IN_BACK)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_L_STORE)

	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_JACKET)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine/commando, /obj/item/ammo_magazine/rifle/type71/ap, H, 0, 5)

/datum/equipment_preset/upp/commando/medic/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues Medic", 0, /obj/item/clothing/under/marine/veteran/UPP/medic, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/PMC, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP/cct, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("HealthMate HUD", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Night Vision Goggles", 0, /obj/item/clothing/glasses/night/m42_night_goggles/upp, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("UM5CU Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/commando, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("UPP Cloak", 0, /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("UPP Balaclava", 0, /obj/item/clothing/mask/gas/PMC/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BELT", 0, null, null, null),
		list("Type 41 Lifesaver Bag", 0, /obj/item/storage/belt/medical/lifesaver/upp/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medical Pouch (Splints)", 0, /obj/item/storage/pouch/medical/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medical Pouch (Pills)", 0, /obj/item/storage/pouch/medical/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/commando/medic/get_antag_gear_equipment()
	return list(
		list("MEDIC SET (MANDATORY)", 0, null, null, null),
		list("Essential Medic Set", 0, /obj/effect/essentials_set/medic/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

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

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),

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
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/HE/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

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

/datum/equipment_preset/upp/commando/leader
	name = "UPP Commando Leader"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/commando/leader
	assignment = JOB_UPP_COMMANDO_LEADER
	rank = JOB_UPP_COMMANDO_LEADER
	role_comm_title = "1stKdo"
	paygrade = "UC3"
	idtype = /obj/item/card/id/silver

/datum/equipment_preset/upp/commando/leader/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/cct, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/commando, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp, WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/PK9/tranq, WEAR_WAIST)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_L_STORE)

	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/handcuffs, WEAR_IN_BACK)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine/commando, /obj/item/ammo_magazine/rifle/type71/ap, H, 0, 7)

/datum/equipment_preset/upp/commando/leader/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/commando, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/PMC, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP/cct, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Night Vision Goggles", 0, /obj/item/clothing/glasses/night/m42_night_goggles/upp, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("UM5CU Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/commando, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("UPP Cloak", 0, /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("UPP Balaclava", 0, /obj/item/clothing/mask/gas/PMC/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 41 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/type47/PK9/tranq, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/commando/leader/get_antag_gear_equipment()
	return list(
		list("LEADER SET (MANDATORY)", 0, null, null, null),
		list("Essential Leader Set", 0, /obj/effect/essentials_set/leader/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

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

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Adv Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("Adv Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),

		list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Injector (QuickClot)", 1, /obj/item/reagent_container/hypospray/autoinjector/quickclot, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_MANDATORY),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/HE/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

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

/datum/equipment_preset/upp/tank
	name = "UPP Vehicle Crewman (TANK)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_UPP_CREWMAN
	rank = JOB_UPP_CREWMAN
	paygrade = "UE5"
	role_comm_title = "TANK"
	minimum_age = 30
	skills = /datum/skills/tank_crew

/datum/equipment_preset/upp/tank/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/cct(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/PK9(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/tool/weldpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tank(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/engi(H), WEAR_HEAD)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine, /obj/item/ammo_magazine/rifle/type71, H, 0, 3)

/datum/equipment_preset/upp/tank/load_status()
	return

/datum/equipment_preset/upp/tank/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/insulated, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("UM5 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("UM4-V Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP/engi, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Welding Kit", 0, /obj/item/tool/weldpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("PERSONAL SIDEARM (CHOOSE 1)", 0, null, null, null),
		list("Korovin PK-9 Pistol", 0, /obj/item/weapon/gun/pistol/c99/upp, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M103 Vehicle-Ammo Rig", 0, /obj/item/storage/belt/tank, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/tank, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("WELDING PROTECTION (CHOOSE 1)", 0, null, null, null),
		list("Welding Goggles", 0, /obj/item/clothing/glasses/welding, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
		list("Welding Helmet", 0, /obj/item/clothing/head/welding, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Gyroscopic Stabilizer", 10, /obj/item/attachable/gyro, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Masterkey Shotgun", 10, /obj/item/attachable/attached_gun/shotgun, null, VENDOR_ITEM_REGULAR),
		list("M37 Wooden Stock", 10, /obj/item/attachable/stock/shotgun, null, VENDOR_ITEM_REGULAR),
		list("M39 Stock", 10, /obj/item/attachable/stock/smg, null, VENDOR_ITEM_REGULAR),
		list("M41A Solid Stock", 10, /obj/item/attachable/stock/rifle, null, VENDOR_ITEM_REGULAR),
		list("Recoil Compensator", 10, /obj/item/attachable/compensator, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", 5, /obj/item/storage/pouch/flamertank, null, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 15, /obj/item/storage/pouch/magazine/large, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 15, /obj/item/device/motiondetector, null, VENDOR_ITEM_REGULAR),
		list("Plastic Explosive", 10, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/upp/tank/get_antag_gear_equipment()
	return list(
		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/HE/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 10, /obj/item/clothing/accessory/storage/droppouch, null, VENDOR_ITEM_REGULAR)
	)

//*****************************************************************************************************/

/datum/equipment_preset/upp/doctor
	name = "UPP Doctor"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/combat_medic
	assignment = JOB_UPP_LT_DOKTOR
	rank = JOB_UPP_LT_DOKTOR
	role_comm_title = "Lt. Med."
	paygrade = "UO1M"

/datum/equipment_preset/upp/doctor/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/ushanka, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/medic/UPP = new()
	var/obj/item/clothing/accessory/storage/surg_vest/equipped/W = new()
	UPP.attach_accessory(H, W)
	H.equip_to_slot_or_del(UPP, WEAR_BODY)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//póckets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/oxycodone, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/oxycodone, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/tricordrazine, WEAR_IN_L_STORE)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

/datum/equipment_preset/upp/doctor/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Medic Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP/medic, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("HealthMate HUD", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Ushanka", 0, /obj/item/clothing/head/uppcap/ushanka, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BELT", 0, null, null, null),
		list("Type 41 Lifesaver Bag", 0, /obj/item/storage/belt/medical/lifesaver/upp/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Medical Pouch (Splints)", 0, /obj/item/storage/pouch/medical/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medical Pouch (Pills)", 0, /obj/item/storage/pouch/medical/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/doctor/get_antag_gear_equipment()
	return list(
		list("MEDIC SET (MANDATORY)", 0, null, null, null),
		list("Essential Medic Set", 0, /obj/effect/essentials_set/medic/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

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

		list("UTILITIES", 0, null, null, null),
		list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 10, /obj/item/clothing/accessory/storage/holster, null, VENDOR_ITEM_REGULAR),
		list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 10, /obj/item/clothing/accessory/storage/droppouch, null, VENDOR_ITEM_REGULAR),
	)
