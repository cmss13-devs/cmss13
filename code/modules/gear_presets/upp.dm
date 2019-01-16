

/datum/equipment_preset/upp
	name = "UPP"

	languages = list("Russian", "English")

/datum/equipment_preset/upp/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(60;MALE,40;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance_for(H)
	if(H.gender == MALE)
		H.real_name = "[pick(first_names_male_upp)] [pick(last_names_upp)]"
		H.f_style = "5 O'clock Shadow"
	else
		H.real_name = "[pick(first_names_female_upp)] [pick(last_names_upp)]"

	H.name = H.real_name
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
	name = "UPP Soldier (Standard)"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/pfc/crafty
	assignment = "UPP Soldier"
	rank = "MODE"
	paygrade = "E1"
	special_role = "UPP"

/datum/equipment_preset/upp/soldier/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/UPP(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/UPP(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/upp(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/bayonet/upp(H), WEAR_L_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/upp/survivor
	name = "UPP Survivor"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/civilian/survivor/doctor
	assignment = "UPP Soldier"
	rank = "MODE"
	paygrade = "E1"
	special_role = "UPP"

/datum/equipment_preset/upp/survivor/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/UPP(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/UPP(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/upp/soldier_medic
	name = "UPP Soldier (Medic)"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/combat_medic/crafty
	assignment = "UPP Medic"
	rank = "MODE"
	paygrade = "E4"
	special_role = "UPP"
	role_comm_title = "Cpl"

/datum/equipment_preset/upp/soldier_medic/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/medic(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/UPP(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/combatLifesaver/upp(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/skorpion/upp(H), WEAR_J_STORE)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/skorpion(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/skorpion(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol/skillless(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/upp_smg, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/bayonet/upp(H), WEAR_L_STORE)

	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)

/*****************************************************************************************************/

/datum/equipment_preset/upp/soldier_heavy
	name = "UPP Soldier (Heavy)"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/specialist/upp
	assignment = "UPP Specialist"
	rank = "MODE"
	paygrade = "E5"
	special_role = "UPP"
	role_comm_title = "Spc"

/datum/equipment_preset/upp/soldier_heavy/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/UPP/heavy(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/UPP/heavy(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/c99/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/c99(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/c99(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/upp(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/bayonet/upp(H), WEAR_L_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/upp/soldier_leader
	name = "UPP Soldier (Leader)"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/SL/upp
	assignment = "UPP Leader"
	rank = "MODE"
	paygrade = "E5"
	special_role = "UPP"
	role_comm_title = "SL"

/datum/equipment_preset/upp/soldier_leader/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/UPP/heavy(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/standard(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/c99(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/c99(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/upp(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/bayonet/upp(H), WEAR_L_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/upp/commando
	name = "UPP Commando (Standard)"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/commando
	assignment = "UPP Commando"
	rank = "MODE"
	paygrade = "E2"
	special_role = "UPP"
	idtype = /obj/item/card/id/data

/datum/equipment_preset/upp/commando/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/UPP/commando(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/tranq(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp(H), WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/carbine/commando(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/tranq(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/chameleon	(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/upp(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/bayonet/upp(H), WEAR_L_STORE)

	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)

/*****************************************************************************************************/

/datum/equipment_preset/upp/commando/medic
	name = "UPP Commando (Medic)"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/commando/medic
	assignment = "UPP Commando Medic"
	rank = "MODE"
	paygrade = "E4"
	special_role = "UPP"
	role_comm_title = "Cpl"

/datum/equipment_preset/upp/commando/medic/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/medic(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/UPP/commando(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp(H), WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/carbine/commando(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/tranq(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H.back), WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/device/defibrillator(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol/skillless(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/upp(H), WEAR_R_STORE)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/chameleon	(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/upp(H), WEAR_L_STORE)

	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)

/*****************************************************************************************************/

/datum/equipment_preset/upp/commando/leader
	name = "UPP Commando (Leader)"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/commando/leader
	assignment = "UPP Commando Leader"
	rank = "MODE"
	paygrade = "E6"
	role_comm_title = "SL"
	special_role = "UPP"
	idtype = /obj/item/card/id/silver

/datum/equipment_preset/upp/commando/leader/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/bears(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/faction/UPP/commando(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp(H), WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/carbine/commando(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/korovin/tranq(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(H.back), WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/chameleon	(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/upp(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/upp(H), WEAR_L_STORE)

	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/handcuffs(H.back), WEAR_IN_BACK)
