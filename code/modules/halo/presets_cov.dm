/datum/equipment_preset/covenant
	name = "COVENANT"
	faction = FACTION_COVENANT
	languages = list(LANGUAGE_SANGHEILI)
	idtype = /obj/item/card/id/covenant
	var/random_name
	var/eye_color

/datum/equipment_preset/covenant/sangheili
	name = "Sangheili"
	assignment = JOB_COV_CIV
	assignment = JOB_COV_CIV
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	paygrades = list(PAY_SHORT_COV_CIV = JOB_PLAYTIME_TIER_0)
	faction = FACTION_COVENANT
	skills = /datum/skills/covenant/sangheili

/datum/equipment_preset/covenant/sangheili/load_race(mob/living/carbon/human/new_human, client/mob_client)
	new_human.set_species(SPECIES_SANGHEILI)
	random_name = capitalize(pick(GLOB.first_names_sangheili)) + " " + capitalize(pick(GLOB.last_names_sangheili))
	var/final_name = random_name
	new_human.change_real_name(new_human, final_name)
	new_human.gender = MALE
	new_human.body_type = "sang"
	new_human.skin_color = pick("sang1", "sang2")
	var/static/list/eye_color_list = list("Magenta" = list(141, 39, 85), "Orange" = list(158, 67, 28), "Green" = list(24, 105, 17))
	eye_color = pick(eye_color_list)
	new_human.r_eyes = eye_color_list[eye_color][1]
	new_human.g_eyes = eye_color_list[eye_color][2]
	new_human.b_eyes = eye_color_list[eye_color][3]

/datum/equipment_preset/covenant/sangheili/load_id(mob/living/carbon/human/new_human)
	. = ..()

/datum/equipment_preset/covenant/sangheili/load_name(mob/living/carbon/human/new_human, randomise, client/mob_client)
	random_name = capitalize(pick(GLOB.first_names_sangheili)) + " " + capitalize(pick(GLOB.last_names_sangheili))
	var/final_name = random_name
	new_human.change_real_name(new_human, final_name)
	new_human.gender = MALE
	new_human.body_type = "sang"
	new_human.skin_color = pick("sang1", "sang2")
	var/static/list/eye_color_list = list("Magenta" = list(141, 39, 85), "Orange" = list(158, 67, 28), "Green" = list(24, 105, 17))
	eye_color = pick(eye_color_list)
	new_human.r_eyes = eye_color_list[eye_color][1]
	new_human.g_eyes = eye_color_list[eye_color][2]
	new_human.b_eyes = eye_color_list[eye_color][3]

// =================================
// Minor
// =================================

/datum/equipment_preset/covenant/sangheili/minor
	name = parent_type::name + " Minor"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_MINOR
	assignment = JOB_COV_MINOR
	paygrades = list(PAY_SHORT_SANG_MINOR = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Minor"
	skills = /datum/skills/covenant/sangheili
	languages = list(LANGUAGE_SANGHEILI)

/datum/equipment_preset/covenant/sangheili/minor/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/covenant/sangheili(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/sangheili/minor(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/shielded/sangheili/minor(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/sangheili/minor(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/sangheili/minor(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/sangheili/minor(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/covenant(new_human), WEAR_L_EAR)
	if(prob(80))
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/plasma/plasma_rifle(new_human), WEAR_J_STORE)
	else
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/covenant_needler(new_human), WEAR_J_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/needler_crystal, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/needler_crystal, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/needler_crystal, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/needler_crystal, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/needler_crystal, WEAR_IN_BELT)

// =================================
// Major
// =================================

/datum/equipment_preset/covenant/sangheili/major
	name = parent_type::name + " Major"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_MAJOR
	assignment = JOB_COV_MAJOR
	paygrades = list(PAY_SHORT_SANG_MAJOR = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Major"
	skills = /datum/skills/covenant/sangheili
	languages = list(LANGUAGE_SANGHEILI)

/datum/equipment_preset/covenant/sangheili/major/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/covenant/sangheili(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/sangheili/major(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/shielded/sangheili/major(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/sangheili/major(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/sangheili/major(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/sangheili/major(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/covenant(new_human), WEAR_L_EAR)
	if(prob(60))
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/plasma/plasma_rifle(new_human), WEAR_J_STORE)
	else
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/covenant_carbine(new_human), WEAR_J_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/carbine, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/carbine, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/carbine, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/carbine, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/carbine, WEAR_IN_BELT)

// =================================
// Ultra
// =================================

/datum/equipment_preset/covenant/sangheili/ultra
	name = parent_type::name + " Ultra"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_ULTRA
	assignment = JOB_COV_ULTRA
	paygrades = list(PAY_SHORT_SANG_ULTRA = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Ultra"
	skills = /datum/skills/covenant/sangheili
	languages = list(LANGUAGE_SANGHEILI)

/datum/equipment_preset/covenant/sangheili/ultra/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/covenant/sangheili(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/sangheili/ultra(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/shielded/sangheili/ultra(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/sangheili/ultra(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/sangheili/ultra(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/sangheili/ultra(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/covenant(new_human), WEAR_L_EAR)
	if(prob(60))
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/plasma/plasma_rifle(new_human), WEAR_J_STORE)
	else
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/covenant_carbine(new_human), WEAR_J_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/carbine, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/carbine, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/carbine, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/carbine, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/carbine, WEAR_IN_BELT)

// =================================
// Zealot
// =================================

/datum/equipment_preset/covenant/sangheili/zealot
	name = parent_type::name + " Zealot"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_ZEALOT
	assignment = JOB_COV_ZEALOT
	paygrades = list(PAY_SHORT_SANG_ZEALOT = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Zealot"
	skills = /datum/skills/covenant/sangheili
	languages = list(LANGUAGE_SANGHEILI)

/datum/equipment_preset/covenant/sangheili/zealot/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/covenant/sangheili(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/sangheili/zealot(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/shielded/sangheili/zealot(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/sangheili/zealot(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/sangheili/zealot(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/sangheili/zealot(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/covenant(new_human), WEAR_L_EAR)
	if(prob(60))
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/plasma/plasma_rifle(new_human), WEAR_J_STORE)
	else
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/covenant_carbine(new_human), WEAR_J_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/carbine, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/carbine, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/carbine, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/carbine, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/carbine, WEAR_IN_BELT)

/datum/equipment_preset/covenant/unggoy
	name = "Unggoy"
	assignment = JOB_COV_CIV
	assignment = JOB_COV_MINOR
	flags = EQUIPMENT_PRESET_EXTRA
	paygrades = list(PAY_SHORT_COV_CIV = JOB_PLAYTIME_TIER_0)
	faction = FACTION_COVENANT
	skills = /datum/skills/covenant/unggoy
	languages = list(LANGUAGE_SANGHEILI, LANGUAGE_UNGGOY)

/datum/equipment_preset/covenant/unggoy/load_race(mob/living/carbon/human/new_human, client/mob_client)
	new_human.set_species(SPECIES_UNGGOY)
	random_name = capitalize(pick(GLOB.first_names_unggoy)) + pick(GLOB.last_names_unggoy)
	var/final_name = random_name
	new_human.change_real_name(new_human, final_name)
	new_human.gender = MALE
	new_human.body_type = "ung"
	new_human.skin_color = "unggoy1"
	var/static/list/eye_color_list = list("Magenta" = list(141, 39, 85), "Orange" = list(158, 67, 28), "Green" = list(24, 105, 17))
	eye_color = pick(eye_color_list)
	new_human.r_eyes = eye_color_list[eye_color][1]
	new_human.g_eyes = eye_color_list[eye_color][2]
	new_human.b_eyes = eye_color_list[eye_color][3]

/datum/equipment_preset/covenant/unggoy/load_id(mob/living/carbon/human/new_human)
	. = ..()

/datum/equipment_preset/covenant/unggoy/load_name(mob/living/carbon/human/new_human, randomise, client/mob_client)
	random_name = capitalize(pick(GLOB.first_names_unggoy)) + pick(GLOB.last_names_unggoy)
	var/final_name = random_name
	new_human.change_real_name(new_human, final_name)
	new_human.gender = MALE
	new_human.body_type = "ung"
	new_human.skin_color = "unggoy1"
	var/static/list/eye_color_list = list("Magenta" = list(141, 39, 85), "Orange" = list(158, 67, 28), "Green" = list(24, 105, 17))
	eye_color = pick(eye_color_list)
	new_human.r_eyes = eye_color_list[eye_color][1]
	new_human.g_eyes = eye_color_list[eye_color][2]
	new_human.b_eyes = eye_color_list[eye_color][3]

// BASIC ROLES

// MINOR
/datum/equipment_preset/covenant/unggoy/minor
	name = parent_type::name + " Minor"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_MINOR
	assignment = JOB_COV_MINOR
	paygrades = list(PAY_SHORT_COV_MINOR = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Minor"
	skills = /datum/skills/covenant/unggoy
	languages = list(LANGUAGE_SANGHEILI, LANGUAGE_UNGGOY)

/datum/equipment_preset/covenant/unggoy/minor/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/covenant/unggoy(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/unggoy/minor(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/covenant(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/unggoy/minor(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/plasma/plasma_pistol(new_human), WEAR_J_STORE)

// MAJOR
/datum/equipment_preset/covenant/unggoy/major
	name = parent_type::name + " Major"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_MAJOR
	assignment = JOB_COV_MAJOR
	paygrades = list(PAY_SHORT_COV_MAJOR = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Major"
	skills = /datum/skills/covenant/unggoy
	languages = list(LANGUAGE_SANGHEILI, LANGUAGE_UNGGOY)

/datum/equipment_preset/covenant/unggoy/major/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/covenant/unggoy(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/unggoy/major(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/covenant(new_human), WEAR_L_EAR)
	if(prob(20))
		new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/unggoy/major(new_human), WEAR_WAIST)
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/covenant_needler(new_human), WEAR_J_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/needler_crystal, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/needler_crystal, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/needler_crystal, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/needler_crystal, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/needler_crystal, WEAR_IN_BELT)
	else
		new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/unggoy/major(new_human), WEAR_WAIST)
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/plasma/plasma_pistol(new_human), WEAR_J_STORE)

// HEAVY
/datum/equipment_preset/covenant/unggoy/heavy
	name = parent_type::name + " Heavy"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_HEAVY
	assignment = JOB_COV_HEAVY
	paygrades = list(PAY_SHORT_COV_HEAVY = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Heavy"
	skills = /datum/skills/covenant/unggoy
	languages = list(LANGUAGE_SANGHEILI, LANGUAGE_UNGGOY)

/datum/equipment_preset/covenant/unggoy/heavy/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/covenant/unggoy(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/unggoy/heavy(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/covenant(new_human), WEAR_L_EAR)
	if(prob(50))
		new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/unggoy/heavy(new_human), WEAR_WAIST)
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/covenant_needler(new_human), WEAR_J_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/needler_crystal, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/needler_crystal, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/needler_crystal, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/needler_crystal, WEAR_IN_BELT)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/needler_crystal, WEAR_IN_BELT)
	else
		new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/unggoy/heavy(new_human), WEAR_WAIST)
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/plasma/plasma_rifle(new_human), WEAR_J_STORE)

// Ultra
/datum/equipment_preset/covenant/unggoy/ultra
	name = parent_type::name + " Ultra"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_ULTRA
	assignment = JOB_COV_ULTRA
	paygrades = list(PAY_SHORT_COV_ULTRA = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Ultra"
	skills = /datum/skills/covenant/unggoy
	languages = list(LANGUAGE_SANGHEILI, LANGUAGE_UNGGOY)

/datum/equipment_preset/covenant/unggoy/ultra/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/covenant/unggoy(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/unggoy/ultra(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/covenant(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/unggoy/ultra(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/plasma/plasma_rifle(new_human), WEAR_J_STORE)

// SpecOps
/datum/equipment_preset/covenant/unggoy/specops
	name = parent_type::name + " SpecOps"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_SPECOPS
	assignment = JOB_COV_SPECOPS
	paygrades = list(PAY_SHORT_COV_MAJOR = JOB_PLAYTIME_TIER_0)
	role_comm_title = "SpecOps"
	skills = /datum/skills/covenant/unggoy
	languages = list(LANGUAGE_SANGHEILI, LANGUAGE_UNGGOY)

/datum/equipment_preset/covenant/unggoy/specops/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/covenant/unggoy(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/stealth/unggoy_specops(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/covenant(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/unggoy/specops(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/plasma/plasma_rifle(new_human), WEAR_J_STORE)

/datum/equipment_preset/covenant/unggoy/specops/lesser
	name = parent_type::name + " (Lesser assignment)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_SPECOPS
	assignment = JOB_COV_SPECOPS
	paygrades = list(PAY_SHORT_COV_MINOR = JOB_PLAYTIME_TIER_0)
	role_comm_title = "SpecOps"
	skills = /datum/skills/covenant/unggoy
	languages = list(LANGUAGE_SANGHEILI, LANGUAGE_UNGGOY)

/datum/equipment_preset/covenant/unggoy/specops/lesser/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/covenant/unggoy(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/stealth/unggoy_specops(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/covenant(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/unggoy/specops(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/plasma/plasma_rifle(new_human), WEAR_J_STORE)

// SpecOps Ultra
/datum/equipment_preset/covenant/unggoy/specops_ultra
	name = parent_type::name + " SpecOps Ultra"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_SPECOPS_ULTRA
	assignment = JOB_COV_SPECOPS_ULTRA
	paygrades = list(PAY_SHORT_COV_ULTRA = JOB_PLAYTIME_TIER_0)
	role_comm_title = "SpecOps Ultra"
	skills = /datum/skills/covenant/unggoy
	languages = list(LANGUAGE_SANGHEILI, LANGUAGE_UNGGOY)

/datum/equipment_preset/covenant/unggoy/specops_ultra/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/covenant/unggoy(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/stealth/unggoy_specops/ultra(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/covenant(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/unggoy/specops_ultra(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/plasma/plasma_rifle(new_human), WEAR_J_STORE)

// Deacon
/datum/equipment_preset/covenant/unggoy/deacon
	name = parent_type::name + " Deacon"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_DEACON
	assignment = JOB_COV_DEACON
	paygrades = list(PAY_SHORT_COV_DEACON = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Deacon"
	skills = /datum/skills/covenant/unggoy
	languages = list(LANGUAGE_SANGHEILI, LANGUAGE_UNGGOY)

/datum/equipment_preset/covenant/unggoy/deacon/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/covenant/unggoy(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/unggoy/deacon(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/covenant(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/plasma/plasma_pistol(new_human), WEAR_J_STORE)
