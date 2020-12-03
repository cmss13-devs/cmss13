/datum/equipment_preset/upp
	name = FACTION_UPP

	languages = list("Russian", "English")
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
	if(H.gender == MALE)
		random_name = "[pick(first_names_male_upp)] [pick(last_names_upp)]"
		H.f_style = "5 O'clock Shadow"
	else
		random_name = "[pick(first_names_female_upp)] [pick(last_names_upp)]"

	H.change_real_name(H, random_name)
	H.age = rand(17,35)
	H.h_style = "Shaved Head"
	H.r_hair = 15
	H.g_hair = 15
	H.b_hair = 25
	H.r_eyes = 139
	H.g_eyes = 62
	H.b_eyes = 19
	idtype = /obj/item/card/id/dogtag

/*****************************************************************************************************/

/datum/equipment_preset/upp/soldier
	name = "UPP Soldier"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp
	assignment = JOB_UPP
	rank = JOB_UPP
	role_comm_title = "Pvt"
	paygrade = "E1"

/datum/equipment_preset/upp/soldier/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/UPP, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp_knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71, /obj/item/ammo_magazine/rifle/type71, H, 0, 12)

/*****************************************************************************************************/

/datum/equipment_preset/upp/soldier/cryo
	name = "UPP Cryo Soldier"

/datum/equipment_preset/upp/soldier/cryo/load_gear(mob/living/carbon/human/H)
	return

/*****************************************************************************************************/

/datum/equipment_preset/upp/survivor
	name = "UPP Survivor"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id
	skills = /datum/skills/civilian/survivor/doctor
	assignment = JOB_UPP
	rank = JOB_UPP
	paygrade = "E1"

/datum/equipment_preset/upp/survivor/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/UPP, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full, WEAR_L_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/upp/synth
	name = "UPP Combat Synthetic"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/synthetic
	assignment = "UPP Combat Synthetic"
	rank = "UPP Combat Synthetic"
	paygrade = "SYN"
	idtype = /obj/item/card/id/gold

/datum/equipment_preset/upp/synth/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(50;MALE,50;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(first_names_male_upp)]"
		H.f_style = "5 O'clock Shadow"
	else
		random_name = "[pick(first_names_female_upp)]"
	H.change_real_name(H, random_name)
	H.r_hair = 15
	H.g_hair = 15
	H.b_hair = 25
	H.r_eyes = 139
	H.g_eyes = 62
	H.b_eyes = 19
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/upp/synth/load_race(mob/living/carbon/human/H)
	H.set_species("Synthetic")

/datum/equipment_preset/upp/synth/load_gear(mob/living/carbon/human/H)
	load_name(H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/UPP, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/upp, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/synth, WEAR_L_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/upp/engineer
	name = "UPP Engineer"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/combat_engineer
	assignment = JOB_UPP_ENGI
	rank = JOB_UPP_ENGI
	role_comm_title = "Sap"
	paygrade = "E3"

/datum/equipment_preset/upp/engineer/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/UPP, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp_knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/shovel/etool/folded(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine, /obj/item/ammo_magazine/rifle/type71, H, 0, 6)

/*****************************************************************************************************/

/datum/equipment_preset/upp/engineer/cryo
	name = "UPP Cryo Engineer"

/datum/equipment_preset/upp/engineer/cryo/load_gear(mob/living/carbon/human/H)
	return

/*****************************************************************************************************/
/datum/equipment_preset/upp/medic
	name = "UPP Medic"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/combat_medic
	assignment = JOB_UPP_MEDIC
	rank = JOB_UPP_MEDIC
	role_comm_title = "Med"
	paygrade = "E4"

/datum/equipment_preset/upp/medic/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/medic, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp_knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol/skillless, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)

	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine, /obj/item/ammo_magazine/rifle/type71, H, 0, 6)

/*****************************************************************************************************/
/datum/equipment_preset/upp/medic/cryo
	name = "UPP Cryo Medic"

/datum/equipment_preset/upp/medic/cryo/load_gear(mob/living/carbon/human/H)
	return

/*****************************************************************************************************/

/datum/equipment_preset/upp/specialist
	name = "UPP Specialist"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/specialist
	assignment = JOB_UPP_SPECIALIST
	rank = JOB_UPP_SPECIALIST
	role_comm_title = "Szh"
	paygrade = "E5"

/datum/equipment_preset/upp/specialist/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/UPP/heavy, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/standard, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp_knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/upp, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)

	spawn_weapon(/obj/item/weapon/gun/minigun/upp, /obj/item/ammo_magazine/minigun, H, 0, 5)

/*****************************************************************************************************/

/datum/equipment_preset/upp/specialist/cryo
	name = "UPP Cryo Specialist"

/datum/equipment_preset/upp/specialist/cryo/load_gear(mob/living/carbon/human/H)
	return

/*****************************************************************************************************/

/datum/equipment_preset/upp/leader
	name = "UPP Leader"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/SL
	assignment = JOB_UPP_LEADER
	rank = JOB_UPP_LEADER
	role_comm_title = "MSzh"
	paygrade = "E5"

/datum/equipment_preset/upp/leader/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp_knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/standard, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/flamer, /obj/item/ammo_magazine/rifle/type71, H, 0, 8)

/*****************************************************************************************************/

/datum/equipment_preset/upp/leader/cryo
	name = "UPP Cryo Leader"

/datum/equipment_preset/upp/leader/cryo/load_gear(mob/living/carbon/human/H)
	return

/*****************************************************************************************************/

/datum/equipment_preset/upp/commando
	name = "UPP Commando"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/commando
	assignment = JOB_UPP_COMMANDO
	rank = JOB_UPP_COMMANDO
	role_comm_title = "JKdo"
	paygrade = "E2"
	idtype = /obj/item/card/id/data
	languages = list("Russian", "English", "Tactical Sign Language", "American Spanish")

/datum/equipment_preset/upp/commando/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/commando, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/tranq, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp_knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
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

/*****************************************************************************************************/

/datum/equipment_preset/upp/commando/medic
	name = "UPP Commando Medic"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/commando/medic
	assignment = JOB_UPP_COMMANDO_MEDIC
	rank = JOB_UPP_COMMANDO_MEDIC
	role_comm_title = "2ndKdo"
	paygrade = "E4"

/datum/equipment_preset/upp/commando/medic/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/medic, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/commando, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp_knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp, WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol/skillless, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/upp, WEAR_L_STORE)

	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_BACK)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine/commando, /obj/item/ammo_magazine/rifle/type71/ap, H, 0, 5)

/*****************************************************************************************************/

/datum/equipment_preset/upp/commando/leader
	name = "UPP Commando Leader"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/commando/leader
	assignment = JOB_UPP_COMMANDO_LEADER
	rank = JOB_UPP_COMMANDO_LEADER
	role_comm_title = "1stKdo"
	paygrade = "E6"
	idtype = /obj/item/card/id/silver

/datum/equipment_preset/upp/commando/leader/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/commando, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp_knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp, WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/tranq, WEAR_WAIST)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/upp, WEAR_L_STORE)

	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/handcuffs, WEAR_IN_BACK)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine/commando, /obj/item/ammo_magazine/rifle/type71/ap, H, 0, 7)

/*****************************************************************************************************/

/datum/equipment_preset/upp/tank
	name = "UPP Vehicle Crewman (TANK)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_UPP_CREWMAN
	rank = JOB_UPP_CREWMAN
	paygrade = "E7"
	role_comm_title = "TANK"
	minimum_age = 30
	skills = /datum/skills/tank_crew

/datum/equipment_preset/upp/tank/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp_knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/standard(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/tool/weldpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tank(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(pick(new /obj/item/clothing/head/helmet/UPP, new /obj/item/clothing/head/uppcap/beret), WEAR_HEAD)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine, /obj/item/ammo_magazine/rifle/type71, H, 0, 3)

	H.hud_set_squad()

/datum/equipment_preset/upp/tank/load_status()
	return

/*****************************************************************************************************/
