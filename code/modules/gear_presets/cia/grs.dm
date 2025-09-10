/// Global Response Staff, CIA Paramilitaries. ///

/datum/equipment_preset/cia_global_response
	name = "Global Response"

	assignment = "Global Response"
	job_title = "Global Response"
	idtype = /obj/item/card/id/adaptive/cia
	faction = FACTION_CIA
	faction_group = FACTION_LIST_CIA_MARINE
	minimap_background = "background_ua"
	var/is_deathsquad = FALSE

/datum/equipment_preset/cia_global_response/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(MALE,FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(new_human)
	var/random_name
	if(new_human.gender == MALE)
		random_name = "[pick(GLOB.first_names_male)] [pick(GLOB.last_names)]"
		new_human.f_style = "5 O'clock Shadow"
	else
		random_name = "[pick(GLOB.first_names_female)] [pick(GLOB.last_names)]"
	new_human.change_real_name(new_human, random_name)
	new_human.age = rand(20,45)
	new_human.r_hair = rand(15,35)
	new_human.g_hair = rand(15,35)
	new_human.b_hair = rand(25,45)

/datum/equipment_preset/cia_global_response/New()
	. = ..()
	access = get_access(ACCESS_LIST_MARINE_ALL) + list(ACCESS_CIA, ACCESS_CIA_GRS)

//*****************************************************************************************************/

/datum/equipment_preset/cia_global_response/standard
	name = JOB_CIA_GRS_OPR
	paygrades = list(PAY_SHORT_GRS_OPR = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_CIA_GRS_OPR
	job_title = JOB_CIA_GRS_OPR
	skills = /datum/skills/cia/global_response
	minimap_icon = "peacekeeper"
	role_comm_title = "Opr"

/datum/equipment_preset/cia_global_response/standard/deathsquad/New()
	. = ..()
	name = "[JOB_CIA_GRS_OPR] (!DEATHSQUAD!)"
	is_deathsquad = TRUE
	faction_group = FACTION_LIST_CIA

/datum/equipment_preset/cia_global_response/standard/load_gear(mob/living/carbon/human/new_human)
	//clothes
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cia_grs, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/marsoc, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/cia_knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/marsoc/grs, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/sof/grs, WEAR_JACKET)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/sof/grs, WEAR_HEAD)

	//backpack and stuff in it
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/explosive_mines, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/hefa, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/phosphorus/strong, WEAR_IN_BACK)

	if(!is_deathsquad)
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/m16a5/m16a6/grenadier, WEAR_J_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/black/m16a5/ap, WEAR_WAIST)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/m16a5/ext, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/m16a5/ext, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/m16a5/ext, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/m16a5/ext, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/no_stims, WEAR_R_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/full, WEAR_L_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/high_explosive, WEAR_IN_BACK)
		new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/high_explosive, WEAR_IN_BACK)
		new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717, WEAR_IN_BACK)
	else
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical/incendiary, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/incendiary, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/incendiary, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/m16a5/m16a6/grenadier/heap, WEAR_J_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/black/m16a5/heap, WEAR_WAIST)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/m16a5/heap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/m16a5/heap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/m16a5/heap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/m16a5/heap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/full, WEAR_R_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/super, WEAR_L_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/high_explosive/super, WEAR_IN_BACK)
		new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/high_explosive/super, WEAR_IN_BACK)
		new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717/cia, WEAR_IN_BACK)



//*****************************************************************************************************/

/datum/equipment_preset/cia_global_response/heavy
	name = JOB_CIA_GRS_HVY
	paygrades = list(PAY_SHORT_GRS_HVY = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_CIA_GRS_HVY
	job_title = JOB_CIA_GRS_HVY
	skills = /datum/skills/cia/global_response/heavy
	minimap_icon = "smartgunner"
	role_comm_title = "HvyOpr"

/datum/equipment_preset/cia_global_response/heavy/deathsquad/New()
	. = ..()
	name = "[JOB_CIA_GRS_HVY] (!DEATHSQUAD!)"
	is_deathsquad = TRUE
	faction_group = FACTION_LIST_CIA

/datum/equipment_preset/cia_global_response/heavy/load_gear(mob/living/carbon/human/new_human)
	//clothes
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cia_grs, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/marsoc, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/cia_knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/marsoc/grs, WEAR_BODY)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_ACCESSORY)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/sof/grs/smartgun, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_JACKET)

	if(!is_deathsquad)
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun/cia_grs(new_human), WEAR_J_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m39/mp5a6/full, WEAR_WAIST)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/ap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/ap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/grs_sg, WEAR_L_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/no_stims, WEAR_R_STORE)
	else
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical/incendiary, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/incendiary, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/incendiary, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun/cia_grs/elite(new_human), WEAR_J_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m39/mp5a6/heap, WEAR_WAIST)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/mp5a5_heap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/mp5a5_heap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/grs_sg/deathsquad, WEAR_L_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/full, WEAR_R_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/sof/grs, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/machete/smartgunner/full, WEAR_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/cia_global_response/sniper
	name = JOB_CIA_GRS_SNP
	paygrades = list(PAY_SHORT_GRS_SNP = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_CIA_GRS_SNP
	job_title = JOB_CIA_GRS_SNP
	skills = /datum/skills/cia/global_response/sniper
	minimap_icon = "spec_sniper"
	role_comm_title = "AdvMrk"

/datum/equipment_preset/cia_global_response/sniper/deathsquad/New()
	. = ..()
	name = "[JOB_CIA_GRS_SNP] (!DEATHSQUAD!)"
	is_deathsquad = TRUE
	faction_group = FACTION_LIST_CIA

/datum/equipment_preset/cia_global_response/sniper/load_gear(mob/living/carbon/human/new_human)
	//clothes
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cia_grs, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/marsoc, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/cia_knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/marsoc/grs, WEAR_BODY)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_ACCESSORY)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/sof/grs, WEAR_JACKET)

	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/lever_action/xm88/cia, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/xm88/black/full_cia, WEAR_WAIST)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/sof/grs, WEAR_HEAD)
	//backpack and stuff in it
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/m15, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/phosphorus/strong, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular/response, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)

	if(!is_deathsquad)
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/no_stims, WEAR_R_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717, WEAR_L_STORE)

	else
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical/incendiary, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/incendiary, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/incendiary, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/incendiary, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/incendiary, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/incendiary, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/incendiary, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/full, WEAR_R_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717/cia, WEAR_L_STORE)


//*****************************************************************************************************/
/datum/equipment_preset/cia_global_response/engineer
	name = JOB_CIA_GRS_ENG
	paygrades = list(PAY_SHORT_GRS_ENG = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_CIA_GRS_ENG
	job_title = JOB_CIA_GRS_ENG
	skills = /datum/skills/cia/global_response/engineer
	minimap_icon = "engi"
	role_comm_title = "TechOpr"

/datum/equipment_preset/cia_global_response/engineer/deathsquad/New()
	. = ..()
	name = "[JOB_CIA_GRS_ENG] (!DEATHSQUAD!)"
	is_deathsquad = TRUE
	faction_group = FACTION_LIST_CIA

/datum/equipment_preset/cia_global_response/engineer/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/veteran/marsoc/grs/uniform = new()
	var/obj/item/clothing/accessory/storage/tool_webbing/equipped/webbing = new()
	uniform.attach_accessory(new_human, webbing)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_ACCESSORY)
	//clothes
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cia_grs, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/marsoc, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/cia_knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/sof/grs, WEAR_JACKET)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/sof/grs, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding/superior, WEAR_EYES)

	//backpack and stuff in it
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert/black, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/large_stack, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/explosive_mines, WEAR_IN_BACK)

	if(!is_deathsquad)
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/es7/tactical/lethal, WEAR_J_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive(new_human), WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive(new_human), WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive(new_human), WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive(new_human), WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/black/es7_lethal, WEAR_WAIST)
		new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/no_stims, WEAR_R_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717, WEAR_L_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical, WEAR_IN_BACK)
	else
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/es7/tactical/incendiary, WEAR_J_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/super(new_human), WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/super(new_human), WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/super(new_human), WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/super(new_human), WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/black/es7_incendiary, WEAR_WAIST)
		new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/full, WEAR_R_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717/cia, WEAR_L_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical/incendiary, WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/cia_global_response/medic
	name = JOB_CIA_GRS_MED
	paygrades = list(PAY_SHORT_GRS_MED = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_CIA_GRS_MED
	job_title = JOB_CIA_GRS_MED
	skills = /datum/skills/cia/global_response/medic
	minimap_icon = "medic"
	role_comm_title = "MedOpr"

/datum/equipment_preset/cia_global_response/medic/deathsquad/New()
	. = ..()
	name = "[JOB_CIA_GRS_MED] (!DEATHSQUAD!)"
	is_deathsquad = TRUE
	faction_group = FACTION_LIST_CIA

/datum/equipment_preset/cia_global_response/medic/load_gear(mob/living/carbon/human/new_human)
	//webbing
	var/obj/item/clothing/under/marine/veteran/marsoc/grs/uniform = new()
	var/obj/item/clothing/accessory/storage/surg_vest/equipped/W = new()
	uniform.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_ACCESSORY)
	//clothing
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cia_grs, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/marsoc, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/cia_knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/sof/grs, WEAR_JACKET)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/sof/grs, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)

	//backpack and stuff in it
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black/medic, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/m15, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/blood/OMinus, WEAR_IN_BACK)

	if(!is_deathsquad)
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5/mp5a5/mp5a6, WEAR_J_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/ap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/ap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/ap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/ap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/mp5/ap/black, WEAR_L_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/storage/box/grs_medical, WEAR_IN_BACK)
	else
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5/mp5a5/mp5a6/heap, WEAR_J_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/mp5a5_heap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/mp5a5_heap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/mp5a5_heap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/mp5a5_heap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/mp5a5_heap/black, WEAR_L_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/storage/box/grs_medical/deathsquad, WEAR_IN_BACK)

	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/wy/full_elite, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch/black/grs, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/bodybag/cryobag, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/bodybag/cryobag, WEAR_IN_BELT)

//*****************************************************************************************************/

/datum/equipment_preset/cia_global_response/leader
	name = JOB_CIA_GRS_TL
	paygrades = list(PAY_SHORT_GRS_TL = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_CIA_GRS_TL
	job_title = JOB_CIA_GRS_TL
	skills = /datum/skills/cia/global_response/leader
	minimap_icon = "leader"
	role_comm_title = "TL"

/datum/equipment_preset/cia_global_response/leader/deathsquad/New()
	. = ..()
	name = "[JOB_CIA_GRS_TL] (!DEATHSQUAD!)"
	is_deathsquad = TRUE
	faction_group = FACTION_LIST_CIA

/datum/equipment_preset/cia_global_response/leader/load_gear(mob/living/carbon/human/new_human)
	//clothes
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/cia_grs, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/marsoc/grs, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/marsoc, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/cia_knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/sof/grs, WEAR_JACKET)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/sof/grs, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)

	//backpack and stuff in it
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/black, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/m15, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/phosphorus/strong, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)

	if(!is_deathsquad)
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/m16a5/m16a6, WEAR_J_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/black/m16a5/ap, WEAR_WAIST)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/m16a5/ext, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/m16a5/ext, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/m16a5/ext, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/m16a5/ext, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/no_stims, WEAR_R_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/high_explosive, WEAR_IN_BACK)
		new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717, WEAR_IN_BACK)
	else
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical/incendiary, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/incendiary, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/incendiary, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16/m16a5/m16a6/heap, WEAR_J_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/black/m16a5/heap, WEAR_WAIST)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/m16a5/heap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/m16a5/heap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/m16a5/heap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16/m16a5/heap, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/full, WEAR_R_STORE)
		new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/high_explosive/super, WEAR_IN_BACK)
		new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717/cia, WEAR_IN_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4_breaching, WEAR_L_STORE)

