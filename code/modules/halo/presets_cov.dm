/*
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
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate/cov(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_R_STORE)

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
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate/cov(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_R_STORE)
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
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate/cov(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_R_STORE)
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
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate/cov(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_R_STORE)

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
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate/cov(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_R_STORE)

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
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate/cov(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_R_STORE)

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
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate/cov(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_R_STORE)

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
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate/cov(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_R_STORE)
*/

/datum/equipment_preset/covenant
	name = "COVENANT"
	faction = FACTION_COVENANT
	languages = list(LANGUAGE_SANGHEILI)
	idtype = /obj/item/card/id/covenant
	var/random_name
	var/eye_color

/datum/equipment_preset/covenant/sangheili
	name = "Sangheili"
	job_title = JOB_COV_CIV
	assignment = JOB_COV_CIV
	faction = FACTION_COVENANT
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	paygrades = list(PAY_SHORT_COV_CIV = JOB_PLAYTIME_TIER_0)
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
	job_title = JOB_COV_MINOR
	paygrades = list(PAY_SHORT_SANG_MINOR = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Minor"
	skills = /datum/skills/covenant/sangheili
	languages = list(LANGUAGE_SANGHEILI)

/datum/equipment_preset/covenant/sangheili/minor/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics(new_human)
	add_elite_minor(new_human)

/datum/equipment_preset/covenant/sangheili/minor/plasma_rifle
	name = parent_type::name + " (Plasma Rifle)"

/datum/equipment_preset/covenant/sangheili/minor/plasma_rifle/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics(new_human)
	add_elite_minor(new_human)
	add_plasma_rifle_package(new_human)

/datum/equipment_preset/covenant/sangheili/minor/needler
	name = parent_type::name + " (Needler)"

/datum/equipment_preset/covenant/sangheili/minor/needler/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics(new_human)
	add_elite_minor(new_human)
	add_needler_package(new_human)

/datum/equipment_preset/covenant/sangheili/minor/carbine
	name = parent_type::name + " (Carbine)"

/datum/equipment_preset/covenant/sangheili/minor/carbine/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics(new_human)
	add_elite_minor(new_human)
	add_cov_carbine_package(new_human)

// =================================
// Major
// =================================

/datum/equipment_preset/covenant/sangheili/major
	name = parent_type::name + " Major"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_MAJOR
	job_title = JOB_COV_MAJOR
	paygrades = list(PAY_SHORT_SANG_MAJOR = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Major"
	skills = /datum/skills/covenant/sangheili
	languages = list(LANGUAGE_SANGHEILI)

/datum/equipment_preset/covenant/sangheili/major/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics(new_human)
	add_elite_major(new_human)

/datum/equipment_preset/covenant/sangheili/major/plasma_rifle
	name = parent_type::name + " (Plasma Rifle)"

/datum/equipment_preset/covenant/sangheili/major/plasma_rifle/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics(new_human)
	add_elite_major(new_human)
	add_plasma_rifle_package(new_human)

/datum/equipment_preset/covenant/sangheili/major/needler
	name = parent_type::name + " (Needler)"

/datum/equipment_preset/covenant/sangheili/major/needler/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics(new_human)
	add_elite_major(new_human)
	add_needler_package(new_human)

/datum/equipment_preset/covenant/sangheili/major/carbine
	name = parent_type::name + " (Carbine)"

/datum/equipment_preset/covenant/sangheili/major/carbine/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics(new_human)
	add_elite_major(new_human)
	add_cov_carbine_package(new_human)

// =================================
// Ultra
// =================================

/datum/equipment_preset/covenant/sangheili/ultra
	name = parent_type::name + " Ultra"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_ULTRA
	job_title = JOB_COV_ULTRA
	paygrades = list(PAY_SHORT_SANG_ULTRA = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Ultra"
	skills = /datum/skills/covenant/sangheili
	languages = list(LANGUAGE_SANGHEILI)

/datum/equipment_preset/covenant/sangheili/ultra/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics(new_human)
	add_elite_ultra(new_human)

/datum/equipment_preset/covenant/sangheili/ultra/plasma_rifle
	name = parent_type::name + " (Plasma Rifle)"

/datum/equipment_preset/covenant/sangheili/ultra/plasma_rifle/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics(new_human)
	add_elite_ultra(new_human)
	add_plasma_rifle_package(new_human)

/datum/equipment_preset/covenant/sangheili/ultra/carbine
	name = parent_type::name + " (Carbine)"

/datum/equipment_preset/covenant/sangheili/ultra/carbine/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics(new_human)
	add_elite_ultra(new_human)
	add_cov_carbine_package(new_human)

// =================================
// Zealot
// =================================

/datum/equipment_preset/covenant/sangheili/zealot
	name = parent_type::name + " Zealot"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_ZEALOT
	job_title = JOB_COV_ZEALOT
	paygrades = list(PAY_SHORT_SANG_ZEALOT = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Zealot"
	skills = /datum/skills/covenant/sangheili
	languages = list(LANGUAGE_SANGHEILI)

/datum/equipment_preset/covenant/sangheili/zealot/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics(new_human)
	add_elite_zealot(new_human)

/datum/equipment_preset/covenant/sangheili/zealot/plasma_rifle
	name = parent_type::name + " (Plasma Rifle)"

/datum/equipment_preset/covenant/sangheili/zealot/plasma_rifle/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics(new_human)
	add_elite_zealot(new_human)
	add_plasma_rifle_package(new_human)

/datum/equipment_preset/covenant/sangheili/zealot/carbine
	name = parent_type::name + " (Carbine)"

/datum/equipment_preset/covenant/sangheili/zealot/carbine/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics(new_human)
	add_elite_zealot(new_human)
	add_cov_carbine_package(new_human)
/*
/datum/equipment_preset/covenant/sangheili/zealot/cloaking
	name = parent_type::name + " (Cloaked)"

/datum/equipment_preset/covenant/sangheili/zealot/cloaking/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics(new_human)
	add_elite_zealot(new_human)
	add_plasma_rifle_package(new_human)
*/
// =================================
// Special Operations
// =================================
/*
/datum/equipment_preset/covenant/sangheili/specops
	name = parent_type::name + " SpecOps"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	faction = FACTION_COVENANT
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_SPECOPS
	job_title = JOB_COV_SPECOPS
	paygrades = list(PAY_SHORT_SANG_MAJOR = JOB_PLAYTIME_TIER_0)
	role_comm_title = "SpecOps"
	skills = /datum/skills/covenant/sangheili
	languages = list(LANGUAGE_SANGHEILI)


/datum/equipment_preset/covenant/sangheili/specops/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics_fullbody(new_human)
	add_elite_specops(new_human)

/datum/equipment_preset/covenant/sangheili/specops/plasma_rifle
	name =  parent_type::name + " (Plasma Rifle)"

/datum/equipment_preset/covenant/sangheili/specops/plasma_rifle/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics_fullbody(new_human)
	add_elite_specops(new_human)
	add_plasma_rifle_package(new_human)

/datum/equipment_preset/covenant/sangheili/specops/carbine
	name =  parent_type::name + " (Carbine)"

/datum/equipment_preset/covenant/sangheili/specops/carbine/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics_fullbody(new_human)
	add_elite_specops(new_human)
	add_cov_carbine_package(new_human)

/datum/equipment_preset/covenant/sangheili/specops/cloaking
	name = parent_type::name + " (Cloaked)"

/datum/equipment_preset/covenant/sangheili/specops/cloaking/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics(new_human)
	add_elite_specops(new_human)
	add_plasma_rifle_package(new_human)
	elite_camouflage(new_human)

// =================================
// Special Operations Ultra
// =================================

/datum/equipment_preset/covenant/sangheili/specops_ultra
	name = parent_type::name + " SpecOps Ultra"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	faction = FACTION_COVENANT
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_SPECOPS_ULTRA
	job_title = JOB_COV_SPECOPS_ULTRA
	paygrades = list(PAY_SHORT_COV_ULTRA = JOB_PLAYTIME_TIER_0)
	role_comm_title = "SpecOps Ultra"
	skills = /datum/skills/covenant/sangheili
	languages = list(LANGUAGE_SANGHEILI)

/datum/equipment_preset/covenant/sangheili/specops_ultra/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics_fullbody(new_human)
	add_elite_specops_ultra(new_human)

/datum/equipment_preset/covenant/sangheili/specops_ultra/plasma_rifle
	name =  parent_type::name + " (Plasma Rifle)"

/datum/equipment_preset/covenant/sangheili/specops_ultra/plasma_rifle/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics_fullbody(new_human)
	add_elite_specops_ultra(new_human)
	add_plasma_rifle_package(new_human)

/datum/equipment_preset/covenant/sangheili/specops_ultra/carbine
	name =  parent_type::name + " (Carbine)"

/datum/equipment_preset/covenant/sangheili/specops_ultra/carbine/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics_fullbody(new_human)
	add_elite_specops_ultra(new_human)
	add_cov_carbine_package(new_human)

/datum/equipment_preset/covenant/sangheili/specops_ultra/cloaking
	name = parent_type::name + " (Cloaked)"

/datum/equipment_preset/covenant/sangheili/specops_ultra/cloaking/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics(new_human)
	add_elite_specops_ultra(new_human)
	add_plasma_rifle_package(new_human)
	elite_camouflage(new_human)

// =================================
// Stealth
// =================================

/datum/equipment_preset/covenant/sangheili/stealth
	name = parent_type::name + " Stealth"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	faction = FACTION_COVENANT
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_STEALTH
	job_title = JOB_COV_STEALTH
	paygrades = list(PAY_SHORT_COV_MAJOR = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Stealth"
	skills = /datum/skills/covenant/sangheili
	languages = list(LANGUAGE_SANGHEILI)

/datum/equipment_preset/covenant/sangheili/stealth/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics_fullbody(new_human)
	add_elite_stealth(new_human)

/datum/equipment_preset/covenant/sangheili/stealth/plasma_rifle
	name =  parent_type::name + " (Plasma Rifle)"

/datum/equipment_preset/covenant/sangheili/stealth/plasma_rifle/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics(new_human)
	add_elite_stealth(new_human)
	add_plasma_rifle_package(new_human)

/datum/equipment_preset/covenant/sangheili/stealth/needler
	name =  parent_type::name + " (Needler)"

/datum/equipment_preset/covenant/sangheili/stealth/needler/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics(new_human)
	add_elite_stealth(new_human)
	add_needler_package(new_human)

/datum/equipment_preset/covenant/sangheili/stealth/needler/cloaking
	name =  parent_type::name + " (Cloaked)"

/datum/equipment_preset/covenant/sangheili/stealth/needler/cloaking/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics(new_human)
	add_elite_stealth(new_human)
	add_needler_package(new_human)
	elite_camouflage(new_human)

/datum/equipment_preset/covenant/sangheili/stealth/plasma_rifle/cloaking
	name = parent_type::name + " (Cloaked)"

/datum/equipment_preset/covenant/sangheili/stealth/plasma_rifle/cloaking/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics(new_human)
	add_elite_stealth(new_human)
	add_plasma_rifle_package(new_human)
	elite_camouflage(new_human)
*/
// =================================
// Honor Guard
// =================================

/datum/equipment_preset/covenant/sangheili/honor_guard
	name = parent_type::name + " Honor Guard !!DEATHSQUAD!!"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_HONOR_GUARD
	job_title = JOB_COV_HONOR_GUARD
	paygrades = list(PAY_SHORT_SANG_HONOR_GUARD = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Honor Guard"
	skills = /datum/skills/covenant/sangheili
	languages = list(LANGUAGE_SANGHEILI)

/datum/equipment_preset/covenant/sangheili/honor_guard/load_gear(mob/living/carbon/human/new_human)
	add_elite_basics_fullbody(new_human)
	add_elite_honor_guard(new_human)
	add_plasma_rifle_package(new_human)


/datum/equipment_preset/covenant/unggoy
	name = "Unggoy"
	job_title = JOB_COV_CIV
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

// =================================
// MINOR
// =================================

/datum/equipment_preset/covenant/unggoy/minor
	name = parent_type::name + " Minor"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_MINOR
	job_title = JOB_COV_MINOR
	paygrades = list(PAY_SHORT_COV_MINOR = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Minor"
	skills = /datum/skills/covenant/unggoy
	languages = list(LANGUAGE_SANGHEILI, LANGUAGE_UNGGOY)

/datum/equipment_preset/covenant/unggoy/minor/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_minor(new_human)

/datum/equipment_preset/covenant/unggoy/minor/plasma_pistol
	name = parent_type::name + " (Plasma Pistol)"

/datum/equipment_preset/covenant/unggoy/minor/plasma_pistol/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_minor(new_human)
	add_plasma_pistol_package(new_human)

/datum/equipment_preset/covenant/unggoy/minor/needler
	name = parent_type::name + " (Needler)"

/datum/equipment_preset/covenant/unggoy/minor/needler/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_minor(new_human)
	add_needler_package(new_human)

/datum/equipment_preset/covenant/unggoy/minor/plasma_rifle
	name = parent_type::name + " (Plasma Rifle)"

/datum/equipment_preset/covenant/unggoy/minor/plasma_rifle/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_minor(new_human)
	add_plasma_rifle_package(new_human)

// =================================
// MAJOR
// =================================

/datum/equipment_preset/covenant/unggoy/major
	name = parent_type::name + " Major"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_MAJOR
	job_title = JOB_COV_MAJOR
	paygrades = list(PAY_SHORT_COV_MAJOR = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Major"
	skills = /datum/skills/covenant/unggoy
	languages = list(LANGUAGE_SANGHEILI, LANGUAGE_UNGGOY)

/datum/equipment_preset/covenant/unggoy/major/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_major(new_human)

/datum/equipment_preset/covenant/unggoy/major/plasma_pistol
	name = parent_type::name + " (Plasma Pistol)"

/datum/equipment_preset/covenant/unggoy/major/plasma_pistol/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_major(new_human)
	add_plasma_pistol_package(new_human)

/datum/equipment_preset/covenant/unggoy/major/needler
	name = parent_type::name + " (Needler)"

/datum/equipment_preset/covenant/unggoy/major/needler/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_major(new_human)
	add_needler_package(new_human)

/datum/equipment_preset/covenant/unggoy/major/plasma_rifle
	name = parent_type::name + " (Plasma Rifle)"

/datum/equipment_preset/covenant/unggoy/major/plasma_rifle/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_major(new_human)
	add_plasma_rifle_package(new_human)

// =================================
// HEAVY
// =================================

/datum/equipment_preset/covenant/unggoy/heavy
	name = parent_type::name + " Heavy"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_HEAVY
	job_title = JOB_COV_HEAVY
	paygrades = list(PAY_SHORT_COV_HEAVY = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Heavy"
	skills = /datum/skills/covenant/unggoy
	languages = list(LANGUAGE_SANGHEILI, LANGUAGE_UNGGOY)

/datum/equipment_preset/covenant/unggoy/heavy/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_heavy(new_human)

/datum/equipment_preset/covenant/unggoy/heavy/plasma_pistol
	name = parent_type::name + " (Plasma Pistol)"

/datum/equipment_preset/covenant/unggoy/heavy/plasma_pistol/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_heavy(new_human)
	add_plasma_pistol_package(new_human)

/datum/equipment_preset/covenant/unggoy/heavy/needler
	name = parent_type::name + " (Needler)"

/datum/equipment_preset/covenant/unggoy/heavy/needler/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_heavy(new_human)
	add_needler_package(new_human)

/datum/equipment_preset/covenant/unggoy/heavy/plasma_rifle
	name = parent_type::name + " (Plasma Rifle)"

/datum/equipment_preset/covenant/unggoy/heavy/plasma_rifle/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_heavy(new_human)
	add_plasma_rifle_package(new_human)

// =================================
// ULTRA
// =================================

/datum/equipment_preset/covenant/unggoy/ultra
	name = parent_type::name + " Ultra"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_ULTRA
	job_title = JOB_COV_ULTRA
	paygrades = list(PAY_SHORT_COV_ULTRA = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Ultra"
	skills = /datum/skills/covenant/unggoy
	languages = list(LANGUAGE_SANGHEILI, LANGUAGE_UNGGOY)

/datum/equipment_preset/covenant/unggoy/ultra/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_ultra(new_human)

/datum/equipment_preset/covenant/unggoy/ultra/plasma_pistol
	name = parent_type::name + " (Plasma Pistol)"

/datum/equipment_preset/covenant/unggoy/ultra/plasma_pistol/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_ultra(new_human)
	add_plasma_pistol_package(new_human)

/datum/equipment_preset/covenant/unggoy/ultra/needler
	name = parent_type::name + " (Needler)"

/datum/equipment_preset/covenant/unggoy/ultra/needler/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_ultra(new_human)
	add_needler_package(new_human)

/datum/equipment_preset/covenant/unggoy/ultra/plasma_rifle
	name = parent_type::name + " (Plasma Rifle)"

/datum/equipment_preset/covenant/unggoy/ultra/plasma_rifle/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_ultra(new_human)
	add_plasma_rifle_package(new_human)

// =================================
// SPECOPS
// =================================

/datum/equipment_preset/covenant/unggoy/specops
	name = parent_type::name + " SpecOps"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	faction = FACTION_COVENANT
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_SPECOPS
	job_title = JOB_COV_SPECOPS
	paygrades = list(PAY_SHORT_COV_MAJOR = JOB_PLAYTIME_TIER_0)
	role_comm_title = "SpecOps"
	skills = /datum/skills/covenant/unggoy
	languages = list(LANGUAGE_SANGHEILI, LANGUAGE_UNGGOY)

/datum/equipment_preset/covenant/unggoy/specops/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_specops(new_human)

/datum/equipment_preset/covenant/unggoy/specops/plasma_pistol
	name = parent_type::name + " (Plasma Pistol)"

/datum/equipment_preset/covenant/unggoy/specops/plasma_pistol/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_specops(new_human)
	add_plasma_pistol_package(new_human)

/datum/equipment_preset/covenant/unggoy/specops/needler
	name = parent_type::name + " (Needler)"

/datum/equipment_preset/covenant/unggoy/specops/needler/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_specops(new_human)
	add_needler_package(new_human)

/datum/equipment_preset/covenant/unggoy/specops/plasma_rifle
	name = parent_type::name + " (Plasma Rifle)"

/datum/equipment_preset/covenant/unggoy/specops/plasma_rifle/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_specops(new_human)
	add_plasma_rifle_package(new_human)

// =================================
// SPECOPS ULTRA
// =================================

/datum/equipment_preset/covenant/unggoy/specops_ultra
	name = parent_type::name + " SpecOps Ultra"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	faction = FACTION_COVENANT
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_SPECOPS_ULTRA
	job_title = JOB_COV_SPECOPS_ULTRA
	paygrades = list(PAY_SHORT_COV_ULTRA = JOB_PLAYTIME_TIER_0)
	role_comm_title = "SpecOps Ultra"
	skills = /datum/skills/covenant/unggoy
	languages = list(LANGUAGE_SANGHEILI, LANGUAGE_UNGGOY)

/datum/equipment_preset/covenant/unggoy/specops_ultra/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_specops_ultra(new_human)

/datum/equipment_preset/covenant/unggoy/specops_ultra/plasma_pistol
	name = parent_type::name + " (Plasma Pistol)"

/datum/equipment_preset/covenant/unggoy/specops_ultra/plasma_pistol/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_specops_ultra(new_human)
	add_plasma_pistol_package(new_human)

/datum/equipment_preset/covenant/unggoy/specops_ultra/needler
	name = parent_type::name + " (Needler)"

/datum/equipment_preset/covenant/unggoy/specops_ultra/needler/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_specops_ultra(new_human)
	add_needler_package(new_human)

/datum/equipment_preset/covenant/unggoy/specops_ultra/plasma_rifle
	name = parent_type::name + " (Plasma Rifle)"

/datum/equipment_preset/covenant/unggoy/specops_ultra/plasma_rifle/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_specops_ultra(new_human)
	add_plasma_rifle_package(new_human)


// =================================
// DEACON
// =================================

/datum/equipment_preset/covenant/unggoy/deacon
	name = parent_type::name + " Deacon"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	idtype = /obj/item/card/id/covenant
	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_COV_DEACON
	job_title = JOB_COV_DEACON
	paygrades = list(PAY_SHORT_COV_DEACON = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Deacon"
	skills = /datum/skills/covenant/unggoy
	languages = list(LANGUAGE_SANGHEILI, LANGUAGE_UNGGOY)

/datum/equipment_preset/covenant/unggoy/deacon/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_deacon(new_human)

/datum/equipment_preset/covenant/unggoy/deacon/plasma_pistol
	name = parent_type::name + " (Plasma Pistol)"

/datum/equipment_preset/covenant/unggoy/deacon/plasma_pistol/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_deacon(new_human)
	add_plasma_pistol_package(new_human)

/datum/equipment_preset/covenant/unggoy/deacon/needler
	name = parent_type::name + " (Needler)"

/datum/equipment_preset/covenant/unggoy/deacon/needler/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_deacon(new_human)
	add_needler_package(new_human)

/datum/equipment_preset/covenant/unggoy/deacon/plasma_rifle
	name = parent_type::name + " (Plasma Rifle)"

/datum/equipment_preset/covenant/unggoy/deacon/plasma_rifle/load_gear(mob/living/carbon/human/new_human)
	add_grunt_basics(new_human)
	add_grunt_deacon(new_human)
	add_plasma_rifle_package(new_human)

// =================================
// PROCS
// =================================

/datum/equipment_preset/proc/add_grunt_basics(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/covenant/unggoy(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/covenant(new_human), WEAR_L_EAR)

/datum/equipment_preset/proc/add_grunt_minor(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/unggoy/minor(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/unggoy/minor(new_human), WEAR_WAIST)


	//mask
	var/mask_pick = pick_weight(list("assault" = 5, "specops" = 0, "standard" = 95))
	switch(mask_pick)
		if("assault")
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/unggoy/minor(new_human), WEAR_HEAD)
		if("specops")
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy/specops(new_human), WEAR_FACE)
		if("standard")
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy(new_human), WEAR_FACE)

	//tanks
	var/tank_pick = pick_weight(list("pointy" = 50, "curlback" = 45, "doubleprong" = 2, "canister" = 3))
	switch(tank_pick)
		if("pointy")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/minor/pointy(new_human), WEAR_BACK)
		if("curlback")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/minor/curlback(new_human), WEAR_BACK)
		if("doubleprong")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/minor/doubleprong(new_human), WEAR_BACK)
		if("canister")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/minor/canister(new_human), WEAR_BACK)

	//misc
	if(prob(5))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/unggoy/minor(new_human), WEAR_HANDS)
	if(prob(5))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/unggoy/minor(new_human), WEAR_FEET)
	if(prob(50))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/pads/unggoy/minor(new_human), WEAR_ACCESSORY)
	if(prob(90))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/pads/unggoy/bicep/minor(new_human), WEAR_ACCESSORY)

/datum/equipment_preset/proc/add_grunt_major(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/unggoy/major(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/unggoy/major(new_human), WEAR_WAIST)


	//mask
	var/mask_pick = pick_weight(list("assault" = 15, "specops" = 10, "standard" = 75))
	switch(mask_pick)
		if("assault")
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/unggoy/major(new_human), WEAR_HEAD)
		if("specops")
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy/specops(new_human), WEAR_FACE)
		if("standard")
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy(new_human), WEAR_FACE)

	//tanks
	var/tank_pick = pick_weight(list("pointy" = 46, "curlback" = 46, "doubleprong" = 4, "canister" = 4))
	switch(tank_pick)
		if("pointy")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/major/pointy(new_human), WEAR_BACK)
		if("curlback")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/major/curlback(new_human), WEAR_BACK)
		if("doubleprong")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/major/doubleprong(new_human), WEAR_BACK)
		if("canister")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/major/canister(new_human), WEAR_BACK)

	//misc
	if(prob(25))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/unggoy/major(new_human), WEAR_HANDS)
	if(prob(25))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/unggoy/major(new_human), WEAR_FEET)
	if(prob(70))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/pads/unggoy/major(new_human), WEAR_ACCESSORY)
	if(prob(95))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/pads/unggoy/bicep/major(new_human), WEAR_ACCESSORY)

/datum/equipment_preset/proc/add_grunt_ultra(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/unggoy/ultra(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/unggoy/ultra(new_human), WEAR_WAIST)


	//mask
	var/mask_pick = pick_weight(list("assault" = 75, "specops" = 10, "standard" = 15))
	switch(mask_pick)
		if("assault")
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/unggoy/ultra(new_human), WEAR_HEAD)
		if("specops")
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy/specops(new_human), WEAR_FACE)
		if("standard")
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy(new_human), WEAR_FACE)

	//tanks
	var/tank_pick = pick_weight(list("pointy" = 35, "curlback" = 35, "doubleprong" = 5, "canister" = 25))
	switch(tank_pick)
		if("pointy")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/ultra/pointy(new_human), WEAR_BACK)
		if("curlback")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/ultra/curlback(new_human), WEAR_BACK)
		if("doubleprong")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/ultra/doubleprong(new_human), WEAR_BACK)
		if("canister")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/ultra/canister(new_human), WEAR_BACK)

	//misc
	if(prob(75))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/unggoy/ultra(new_human), WEAR_HANDS)
	if(prob(75))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/unggoy/ultra(new_human), WEAR_FEET)
	if(prob(99))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/pads/unggoy/ultra(new_human), WEAR_ACCESSORY)
	if(prob(99))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/pads/unggoy/bicep/ultra(new_human), WEAR_ACCESSORY)

/datum/equipment_preset/proc/add_grunt_heavy(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/unggoy/heavy(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/unggoy/heavy(new_human), WEAR_WAIST)


	//mask
	var/mask_pick = pick_weight(list("assault" = 48, "specops" = 48, "standard" = 4))
	switch(mask_pick)
		if("assault")
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/unggoy/heavy(new_human), WEAR_HEAD)
		if("specops")
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy/specops(new_human), WEAR_FACE)
		if("standard")
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy(new_human), WEAR_FACE)

	//tanks
	var/tank_pick = pick_weight(list("pointy" = 25, "curlback" = 25, "doubleprong" = 25, "canister" = 25))
	switch(tank_pick)
		if("pointy")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/heavy/pointy(new_human), WEAR_BACK)
		if("curlback")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/heavy/curlback(new_human), WEAR_BACK)
		if("doubleprong")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/heavy/doubleprong(new_human), WEAR_BACK)
		if("canister")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/heavy/canister(new_human), WEAR_BACK)

	//misc
	if(prob(95))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/unggoy/heavy(new_human), WEAR_HANDS)
	if(prob(95))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/unggoy/heavy(new_human), WEAR_FEET)
	if(prob(95))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/pads/unggoy/heavy(new_human), WEAR_ACCESSORY)
	if(prob(95))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/pads/unggoy/bicep/heavy(new_human), WEAR_ACCESSORY)

/datum/equipment_preset/proc/add_grunt_specops(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/stealth/unggoy_specops(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/unggoy/specops(new_human), WEAR_WAIST)


	//mask
	var/mask_pick = pick_weight(list("assault" = 50, "specops" = 50, "standard" = 0))
	switch(mask_pick)
		if("assault")
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/unggoy/specops(new_human), WEAR_HEAD)
		if("specops")
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy/specops(new_human), WEAR_FACE)
		if("standard")
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy(new_human), WEAR_FACE)

	//tanks
	var/tank_pick = pick_weight(list("pointy" = 15, "curlback" = 15, "doubleprong" = 65, "canister" = 5))
	switch(tank_pick)
		if("pointy")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/specops/pointy(new_human), WEAR_BACK)
		if("curlback")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/specops/curlback(new_human), WEAR_BACK)
		if("doubleprong")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/specops/doubleprong(new_human), WEAR_BACK)
		if("canister")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/specops/canister(new_human), WEAR_BACK)

	//misc
	if(prob(75))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/unggoy/specops(new_human), WEAR_HANDS)
	if(prob(75))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/unggoy/specops(new_human), WEAR_FEET)
	if(prob(99))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/pads/unggoy/specops(new_human), WEAR_ACCESSORY)
	if(prob(99))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/pads/unggoy/bicep/specops(new_human), WEAR_ACCESSORY)

/datum/equipment_preset/proc/add_grunt_specops_ultra(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/stealth/unggoy_specops/ultra(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/unggoy/specops_ultra(new_human), WEAR_WAIST)


	//mask
	var/mask_pick = pick_weight(list("assault" = 75, "specops" = 25, "standard" = 0))
	switch(mask_pick)
		if("assault")
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/unggoy/specops_ultra(new_human), WEAR_HEAD)
		if("specops")
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy/specops(new_human), WEAR_FACE)
		if("standard")
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy(new_human), WEAR_FACE)

	//tanks
	var/tank_pick = pick_weight(list("pointy" = 5, "curlback" = 5, "doubleprong" = 60, "canister" = 30))
	switch(tank_pick)
		if("pointy")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/specops_ultra/pointy(new_human), WEAR_BACK)
		if("curlback")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/specops_ultra/curlback(new_human), WEAR_BACK)
		if("doubleprong")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/specops_ultra/doubleprong(new_human), WEAR_BACK)
		if("canister")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/specops_ultra/canister(new_human), WEAR_BACK)

	//misc
	if(prob(90))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/unggoy/specops_ultra(new_human), WEAR_HANDS)
	if(prob(90))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/unggoy/specops_ultra(new_human), WEAR_FEET)
	if(prob(99))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/pads/unggoy/specops_ultra(new_human), WEAR_ACCESSORY)
	if(prob(99))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/pads/unggoy/bicep/specops_ultra(new_human), WEAR_ACCESSORY)

/datum/equipment_preset/proc/add_grunt_deacon(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/unggoy/deacon(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/unggoy/ultra(new_human), WEAR_WAIST)


	//mask
	var/mask_pick = pick_weight(list("assault" = 0, "specops" = 0, "standard" = 100))
	switch(mask_pick)
		if("assault")
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/unggoy/ultra(new_human), WEAR_HEAD)
		if("specops")
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy/specops(new_human), WEAR_FACE)
		if("standard")
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/unggoy(new_human), WEAR_FACE)

	//tanks
	var/tank_pick = pick_weight(list("pointy" = 45, "curlback" = 45, "doubleprong" = 5, "canister" = 5))
	switch(tank_pick)
		if("pointy")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/ultra/pointy(new_human), WEAR_BACK)
		if("curlback")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/ultra/curlback(new_human), WEAR_BACK)
		if("doubleprong")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/ultra/doubleprong(new_human), WEAR_BACK)
		if("canister")
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/covenant/unggoy/ultra/canister(new_human), WEAR_BACK)
/*
/datum/equipment_preset/proc/grunt_camouflage(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	for(var/obj/item/clothing/suit/marine/unggoy/cloaking/camouflage in new_human)
		camouflage.attack_self(new_human)
*/

// =================================
// PROCS
// =================================

/datum/equipment_preset/proc/add_elite_basics(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	var/obj/item/clothing/under/marine/covenant/sangheili/uniform = new()
	var/random_uniform = rand(1,2)
	switch(random_uniform)
		if(1)
			uniform.roll_suit_sleeves(new_human)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/covenant(new_human), WEAR_L_EAR)

/datum/equipment_preset/proc/add_elite_basics_fullbody(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/covenant/sangheili/fullbody(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/covenant(new_human), WEAR_L_EAR)

/datum/equipment_preset/proc/add_elite_minor(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/shielded/sangheili/minor(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/sangheili/minor(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/sangheili/minor(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/sangheili/minor(new_human), WEAR_WAIST)
	var/pick_hat = pick_weight(list(/obj/item/clothing/head/helmet/marine/sangheili/minor = 70, /obj/item/clothing/head/helmet/marine/sangheili/minor/manta_hat = 30))
	var/pick_pads = pick_weight(list(/obj/item/clothing/accessory/pads/sangheili/minor = 50, /obj/item/clothing/accessory/pads/sangheili/minor/variant_2 = 30, /obj/item/clothing/accessory/pads/sangheili/minor/variant_3 = 20))
	new_human.equip_to_slot_or_del(new pick_hat(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new pick_pads(new_human), WEAR_ACCESSORY)

/datum/equipment_preset/proc/add_elite_major(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/shielded/sangheili/major(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/sangheili/major(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/sangheili/major(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/sangheili/major(new_human), WEAR_WAIST)
	var/pick_hat = pick_weight(list(/obj/item/clothing/head/helmet/marine/sangheili/major = 70, /obj/item/clothing/head/helmet/marine/sangheili/major/manta_hat = 30))
	var/pick_pads = pick_weight(list(/obj/item/clothing/accessory/pads/sangheili/major = 50, /obj/item/clothing/accessory/pads/sangheili/major/variant_2 = 30, /obj/item/clothing/accessory/pads/sangheili/major/variant_3 = 20))
	new_human.equip_to_slot_or_del(new pick_hat, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new pick_pads, WEAR_ACCESSORY)

/datum/equipment_preset/proc/add_elite_ultra(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/shielded/sangheili/ultra(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/sangheili/ultra(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/sangheili/ultra(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/sangheili/ultra(new_human), WEAR_WAIST)
	var/pick_hat = pick_weight(list(/obj/item/clothing/head/helmet/marine/sangheili/ultra = 50, /obj/item/clothing/head/helmet/marine/sangheili/ultra/manta_hat = 50))
	var/pick_pads = pick_weight(list(/obj/item/clothing/accessory/pads/sangheili/ultra = 50, /obj/item/clothing/accessory/pads/sangheili/ultra/variant_2 = 25, /obj/item/clothing/accessory/pads/sangheili/ultra/variant_3 = 25))
	new_human.equip_to_slot_or_del(new pick_hat, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new pick_pads, WEAR_ACCESSORY)

/datum/equipment_preset/proc/add_elite_zealot(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/shielded/sangheili/zealot(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/sangheili/zealot(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/sangheili/zealot(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/sangheili/zealot(new_human), WEAR_WAIST)
	var/pick_hat = pick_weight(list(/obj/item/clothing/head/helmet/marine/sangheili/zealot = 50, /obj/item/clothing/head/helmet/marine/sangheili/zealot/manta_hat = 50))
	var/pick_pads = pick_weight(list(/obj/item/clothing/accessory/pads/sangheili/zealot = 20, /obj/item/clothing/accessory/pads/sangheili/zealot/variant_2 = 20, /obj/item/clothing/accessory/pads/sangheili/zealot/variant_3 = 60))
	new_human.equip_to_slot_or_del(new pick_hat, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new pick_pads, WEAR_ACCESSORY)

/*
/datum/equipment_preset/proc/add_elite_specops(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/shielded/sangheili/cloaking/specops(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/sangheili/specops(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/sangheili/specops(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/sangheili/specops(new_human), WEAR_WAIST)
	var/pick_hat = pick_weight(list(/obj/item/clothing/head/helmet/marine/sangheili/specops = 30, /obj/item/clothing/head/helmet/marine/sangheili/specops/manta_hat = 0, /obj/item/clothing/head/helmet/marine/sangheili/specops/assault = 70))
	var/pick_pads = pick_weight(list(/obj/item/clothing/accessory/pads/sangheili/specops = 25, /obj/item/clothing/accessory/pads/sangheili/specops/variant_2 = 25, /obj/item/clothing/accessory/pads/sangheili/specops/variant_3 = 50))
	new_human.equip_to_slot_or_del(new pick_hat, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new pick_pads, WEAR_ACCESSORY)

/datum/equipment_preset/proc/add_elite_specops_ultra(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/shielded/sangheili/cloaking/specops/ultra(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/sangheili/specops/ultra(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/sangheili/specops/ultra(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/sangheili/specops/ultra(new_human), WEAR_WAIST)
	var/pick_hat = pick_weight(list(/obj/item/clothing/head/helmet/marine/sangheili/specops/ultra = 20, /obj/item/clothing/head/helmet/marine/sangheili/specops/ultra/manta_hat = 0, /obj/item/clothing/head/helmet/marine/sangheili/specops/ultra/assault = 80))
	var/pick_pads = pick_weight(list(/obj/item/clothing/accessory/pads/sangheili/specops/ultra = 25, /obj/item/clothing/accessory/pads/sangheili/specops/ultra/variant_2 = 25, /obj/item/clothing/accessory/pads/sangheili/specops/ultra/variant_3 = 50))
	new_human.equip_to_slot_or_del(new pick_hat, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new pick_pads, WEAR_ACCESSORY)

/datum/equipment_preset/proc/add_elite_stealth(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/shielded/sangheili/cloaking/stealth(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/sangheili/stealth(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/sangheili/stealth(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/sangheili/stealth(new_human), WEAR_WAIST)
	var/pick_hat = pick_weight(list(/obj/item/clothing/head/helmet/marine/sangheili/stealth = 10, /obj/item/clothing/head/helmet/marine/sangheili/stealth/manta_hat = 10, /obj/item/clothing/head/helmet/marine/sangheili/stealth/assault = 80))
	var/pick_pads = pick_weight(list(/obj/item/clothing/accessory/pads/sangheili/stealth = 15, /obj/item/clothing/accessory/pads/sangheili/stealth/variant_2 = 80, /obj/item/clothing/accessory/pads/sangheili/stealth/variant_3 = 5))
	new_human.equip_to_slot_or_del(new pick_hat, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new pick_pads, WEAR_ACCESSORY)
*/
/datum/equipment_preset/proc/add_elite_honor_guard(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/shielded/sangheili/honor_guard(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/sangheili/honor_guard(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/sangheili/honor_guard(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/sangheili/honor_guard(new_human), WEAR_WAIST)
	var/pick_hat = pick_weight(list(/obj/item/clothing/head/helmet/marine/sangheili/honor_guard = 100))
	var/pick_pads = pick_weight(list(/obj/item/clothing/accessory/pads/sangheili/honor_guard = 100))
	new_human.equip_to_slot_or_del(new pick_hat, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new pick_pads, WEAR_ACCESSORY)
/*
/datum/equipment_preset/proc/elite_camouflage(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	for(var/obj/item/clothing/suit/marine/shielded/sangheili/cloaking/camouflage in new_human)
		camouflage.attack_self(new_human)
*/area
/datum/equipment_preset/proc/add_plasma_pistol_package(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/plasma/plasma_pistol(new_human), WEAR_J_STORE)

/datum/equipment_preset/proc/add_needler_package(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/covenant/unggoy/major(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/covenant_needler(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/needler_crystal, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/needler_crystal, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/needler_crystal, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/needler_crystal, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/needler_crystal, WEAR_IN_BELT)

/datum/equipment_preset/proc/add_plasma_rifle_package(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/plasma/plasma_rifle(new_human), WEAR_J_STORE)

/datum/equipment_preset/proc/add_cov_carbine_package(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/covenant_carbine(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/carbine, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/carbine, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/carbine, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/carbine, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/carbine, WEAR_IN_BELT)
