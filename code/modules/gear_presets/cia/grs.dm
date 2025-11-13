/// Global Response Staff, CIA Paramilitaries. ///
#define STRENGTH_NORM "Normal"
#define STRENGTH_NO_IFF "No-IFF"
#define STRENGTH_WEAK "Weakened"
#define STRENGTH_SURVIVOR "Survivor"
#define STRENGTH_DEATH "Deathsquad"

/datum/equipment_preset/cia_global_response
	name = "Global Response"

	assignment = "Global Response"
	job_title = "Global Response"
	idtype = /obj/item/card/id/adaptive/cia
	faction = FACTION_CIA
	faction_group = FACTION_LIST_CIA_MARINE
	minimap_background = "background_ua"
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE, LANGUAGE_CHINESE, LANGUAGE_RUSSIAN, LANGUAGE_GERMAN, LANGUAGE_SCANDINAVIAN, LANGUAGE_SPANISH, LANGUAGE_FRENCH, LANGUAGE_TSL)
	var/strength_type = STRENGTH_NORM
	var/helmet_type = /obj/item/clothing/head/helmet/marine/sof/grs
	var/headset_type = /obj/item/device/radio/headset/almayer/cia_grs
	var/uniform_type = /obj/item/clothing/under/marine/veteran/marsoc/grs
	var/suit_type = /obj/item/clothing/suit/storage/marine/sof/grs
	var/back_type = /obj/item/storage/backpack/lightpack/black
	var/mask_type = /obj/item/clothing/mask/gas/pmc/marsoc/grs

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
	access = get_access(ACCESS_LIST_UA) + list(ACCESS_CIA, ACCESS_CIA_GRS)
	switch(strength_type)
		if(STRENGTH_WEAK)
			name = "[name] (Weakened)"
		if(STRENGTH_NO_IFF)
			name = "[name] (No-IFF)"
			faction_group = FACTION_LIST_CIA
			headset_type = /obj/item/device/radio/headset/almayer/cia_grs/hvh
		if(STRENGTH_SURVIVOR)
			name = "Survivor - [name]"
			faction_group = FACITON_LIST_SURVIVOR_CIA
			headset_type = /obj/item/device/radio/headset/almayer/cia_grs/survivor
			access = get_access(ACCESS_LIST_COLONIAL_ALL) + list(ACCESS_CIA, ACCESS_CIA_GRS)
			selection_categories += FACTION_SURVIVOR
		if(STRENGTH_DEATH)
			name = "[name] (!DEATHSQUAD!)"
			faction_group = FACTION_LIST_CIA
			headset_type = /obj/item/device/radio/headset/almayer/cia_grs/hvh

//*****************************************************************************************************/

/// Loads the Headset, Helmet, Mask, Uniform, Armor, Gloves, Shoes and Backpack
/datum/equipment_preset/cia_global_response/proc/load_standard_gear(mob/living/carbon/human/new_human)
	if(headset_type)
		new_human.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	if(helmet_type)
		new_human.equip_to_slot_or_del(new helmet_type, WEAR_HEAD)
	if(mask_type)
		new_human.equip_to_slot_or_del(new mask_type, WEAR_FACE)
	if(uniform_type)
		new_human.equip_to_slot_or_del(new uniform_type, WEAR_BODY)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_ACCESSORY)
	if(suit_type)
		new_human.equip_to_slot_or_del(new suit_type, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/cia_knife, WEAR_FEET)
	if(back_type)
		new_human.equip_to_slot_or_del(new back_type, WEAR_BACK)


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

/datum/equipment_preset/cia_global_response/standard/deathsquad
	strength_type = STRENGTH_DEATH
	mask_type = /obj/item/clothing/mask/gas/pmc/marsoc/grs/deathsquad

/datum/equipment_preset/cia_global_response/standard/no_iff
	strength_type = STRENGTH_NO_IFF

/datum/equipment_preset/cia_global_response/standard/weak
	strength_type = STRENGTH_WEAK
	suit_type = /obj/item/clothing/suit/storage/marine/sof/grs/damaged
	helmet_type = /obj/item/clothing/head/helmet/marine/sof/grs/damaged

/datum/equipment_preset/cia_global_response/standard/weak/survivor
	strength_type = STRENGTH_SURVIVOR
	skills = /datum/skills/cia/global_response/survivor

/datum/equipment_preset/cia_global_response/standard/load_gear(mob/living/carbon/human/new_human)
	load_standard_gear(new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)

	//backpack and stuff in it
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)

	switch(strength_type)
		if(STRENGTH_WEAK, STRENGTH_SURVIVOR)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/black/m47/weak, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m47/grenadier, WEAR_J_STORE)

			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/not_op, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/high_explosive, WEAR_IN_BACK)
			if(strength_type == STRENGTH_SURVIVOR)
				new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/medium_stack, WEAR_IN_BACK)

		if(STRENGTH_NORM, STRENGTH_NO_IFF)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/black/m47/ap, WEAR_WAIST)

			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m47/grenadier/ap, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/le, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/le, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/le, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/le, WEAR_IN_JACKET)

			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/no_stims, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/full, WEAR_L_STORE)

			new_human.equip_to_slot_or_del(new /obj/item/storage/box/explosive_mines, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/hefa, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/phosphorus/strong, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/high_explosive, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/high_explosive, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717/cia, WEAR_IN_BACK)

		if(STRENGTH_DEATH)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical/incendiary, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/incendiary, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/incendiary, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/black/m47/heap, WEAR_WAIST)

			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m47/grenadier/heap, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/heap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/heap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/heap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/heap, WEAR_IN_JACKET)

			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/full, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/super, WEAR_L_STORE)

			new_human.equip_to_slot_or_del(new /obj/item/storage/box/explosive_mines, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/hefa, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/phosphorus/strong, WEAR_IN_BACK)
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
	suit_type = /obj/item/clothing/suit/storage/marine/smartgunner/veteran/sof/grs
	back_type = /obj/item/storage/large_holster/machete/smartgunner/full

/datum/equipment_preset/cia_global_response/heavy/deathsquad
	strength_type = STRENGTH_DEATH
	mask_type = /obj/item/clothing/mask/gas/pmc/marsoc/grs/deathsquad

/datum/equipment_preset/cia_global_response/heavy/no_iff
	strength_type = STRENGTH_NO_IFF

/datum/equipment_preset/cia_global_response/heavy/weak
	strength_type = STRENGTH_WEAK
	suit_type = /obj/item/clothing/suit/storage/marine/smartgunner/veteran/sof/grs/damaged
	helmet_type = /obj/item/clothing/head/helmet/marine/sof/grs/damaged

/datum/equipment_preset/cia_global_response/heavy/weak/survivor
	strength_type = STRENGTH_SURVIVOR
	skills = /datum/skills/cia/global_response/heavy/survivor

/datum/equipment_preset/cia_global_response/heavy/load_gear(mob/living/carbon/human/new_human)
	load_standard_gear(new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)

	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_JACKET)

	switch(strength_type)
		if(STRENGTH_WEAK, STRENGTH_SURVIVOR)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun/cia_grs(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m39/mp5a6/full, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_sg/marsoc/grs/near_empty, WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/not_op, WEAR_R_STORE)

		if(STRENGTH_NORM, STRENGTH_NO_IFF)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun/cia_grs(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m39/mp5a6/full, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/ap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/ap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_sg/marsoc/grs, WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/no_stims, WEAR_R_STORE)

		if(STRENGTH_DEATH)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical/incendiary, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/incendiary, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/incendiary, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun/cia_grs/elite(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m39/mp5a6/heap, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/mp5a5_heap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/mp5a5_heap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_sg/marsoc/grs/deathsquad, WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/full, WEAR_R_STORE)

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
	helmet_type = /obj/item/clothing/head/helmet/marine/sof/grs/sniper
	uniform_type = /obj/item/clothing/under/marine/veteran/marsoc/grs/hidden_holdout
	suit_type = /obj/item/clothing/suit/storage/marine/ghillie/grs
	back_type = /obj/item/storage/backpack/lightpack/black/grs_sniper

/datum/equipment_preset/cia_global_response/sniper/deathsquad
	strength_type = STRENGTH_DEATH
	mask_type = /obj/item/clothing/mask/gas/pmc/marsoc/grs/deathsquad

/datum/equipment_preset/cia_global_response/sniper/no_iff
	strength_type = STRENGTH_NO_IFF

/datum/equipment_preset/cia_global_response/sniper/weak
	strength_type = STRENGTH_WEAK
	suit_type = /obj/item/clothing/suit/storage/marine/ghillie/grs/damaged

/datum/equipment_preset/cia_global_response/sniper/weak/survivor
	strength_type = STRENGTH_SURVIVOR
	skills = /datum/skills/cia/global_response/sniper/survivor

/datum/equipment_preset/cia_global_response/sniper/load_gear(mob/living/carbon/human/new_human)
	load_standard_gear(new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)

	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/lever_action/xm88/cia, WEAR_J_STORE)

	//backpack and stuff in it
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)

	switch(strength_type)
		if(STRENGTH_WEAK, STRENGTH_SURVIVOR)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m10/black_tactical, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m10, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m10, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m10, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m10, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/xm88/black/half_full_cia, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/not_op, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717/cia, WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular/response, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/m15, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
			if(strength_type == STRENGTH_SURVIVOR)
				new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/medium_stack, WEAR_IN_BACK)

		if(STRENGTH_NORM, STRENGTH_NO_IFF)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m10/black_tactical/ap, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m10/ap, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m10/ap, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m10/ap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m10/ap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m10/ap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m10/ap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/xm88/black/full_cia, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/no_stims, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717/cia, WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular/response, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/m15, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/high_explosive, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/phosphorus/strong, WEAR_IN_BACK)

		if(STRENGTH_DEATH)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m10/black_tactical/incendiary, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m10/incendiary, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m10/incendiary, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m10/incendiary, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m10/incendiary, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m10/incendiary, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m10/incendiary, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/xm88/black/full_cia, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/full, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717/cia, WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular/response, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/m15, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/high_explosive/super, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/phosphorus/strong, WEAR_IN_BACK)

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
	back_type = /obj/item/storage/backpack/marine/engineerpack/ert/black
	uniform_type = /obj/item/clothing/under/marine/veteran/marsoc/grs/hidden_holdout

/datum/equipment_preset/cia_global_response/engineer/deathsquad
	strength_type = STRENGTH_DEATH
	mask_type = /obj/item/clothing/mask/gas/pmc/marsoc/grs/deathsquad

/datum/equipment_preset/cia_global_response/engineer/no_iff
	strength_type = STRENGTH_NO_IFF

/datum/equipment_preset/cia_global_response/engineer/weak
	strength_type = STRENGTH_WEAK
	suit_type = /obj/item/clothing/suit/storage/marine/sof/grs/damaged
	helmet_type = /obj/item/clothing/head/helmet/marine/sof/grs/damaged

/datum/equipment_preset/cia_global_response/engineer/weak/survivor
	strength_type = STRENGTH_SURVIVOR
	skills = /datum/skills/cia/global_response/engineer/survivor

/datum/equipment_preset/cia_global_response/engineer/load_gear(mob/living/carbon/human/new_human)
	load_standard_gear(new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/tool_webbing/equipped, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding/superior, WEAR_EYES)

	switch(strength_type)
		if(STRENGTH_WEAK, STRENGTH_SURVIVOR)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/es7/tactical/lethal, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/black/es7_lethal/half, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/not_op, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717/cia, WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/medium_stack, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/medium_stack, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/medium_stack, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/explosive_mines, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical, WEAR_IN_BACK)

		if(STRENGTH_NORM, STRENGTH_NO_IFF)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/es7/tactical/lethal, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/black/es7_lethal, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/no_stims, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717/cia, WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/large_stack, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/explosive_mines, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical, WEAR_IN_BACK)

		if(STRENGTH_DEATH)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/es7/tactical/incendiary, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/super(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/super(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/super(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/super(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/black/es7_incendiary, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/full, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717/cia, WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/large_stack, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/explosive_mines, WEAR_IN_BACK)
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
	back_type = /obj/item/storage/backpack/lightpack/black/medic
	uniform_type = /obj/item/clothing/under/marine/veteran/marsoc/grs/hidden_holdout

/datum/equipment_preset/cia_global_response/medic/deathsquad
	strength_type = STRENGTH_DEATH
	mask_type = /obj/item/clothing/mask/gas/pmc/marsoc/grs/deathsquad

/datum/equipment_preset/cia_global_response/medic/no_iff
	strength_type = STRENGTH_NO_IFF

/datum/equipment_preset/cia_global_response/medic/weak
	strength_type = STRENGTH_WEAK
	suit_type = /obj/item/clothing/suit/storage/marine/sof/grs/damaged
	helmet_type = /obj/item/clothing/head/helmet/marine/sof/grs/damaged

/datum/equipment_preset/cia_global_response/medic/weak/survivor
	strength_type = STRENGTH_SURVIVOR
	skills = /datum/skills/cia/global_response/medic/survivor

/datum/equipment_preset/cia_global_response/medic/load_gear(mob/living/carbon/human/new_human)
	load_standard_gear(new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/surg_vest/equipped, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)

	//backpack and stuff in it
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/blood/OMinus, WEAR_IN_BACK)

	switch(strength_type)
		if(STRENGTH_WEAK, STRENGTH_SURVIVOR)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5/mp5a5/mp5a6, WEAR_J_STORE)

			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/mp5/ap/black, WEAR_L_STORE)

			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/wy/full_advanced, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch/black/grs_weak, WEAR_WAIST)

			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/m15, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
			if(strength_type == STRENGTH_SURVIVOR)
				new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/medium_stack, WEAR_IN_BACK)

		if(STRENGTH_NORM, STRENGTH_NO_IFF)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5/mp5a5/mp5a6, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/ap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/ap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/ap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/ap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/mp5/ap/black, WEAR_L_STORE)

			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/wy/full_elite, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch/black/grs, WEAR_WAIST)

			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/m15, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/grs_medical, WEAR_IN_BACK)

		if(STRENGTH_DEATH)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5/mp5a5/mp5a6/heap, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/mp5a5_heap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/mp5a5_heap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/mp5a5_heap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5/mp5a5_heap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/mp5a5_heap/black, WEAR_L_STORE)

			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/wy/full_elite, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch/black/grs, WEAR_WAIST)

			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/m15, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/grs_medical/deathsquad, WEAR_IN_BACK)

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

/datum/equipment_preset/cia_global_response/leader/deathsquad
	strength_type = STRENGTH_DEATH
	mask_type = /obj/item/clothing/mask/gas/pmc/marsoc/grs/deathsquad

/datum/equipment_preset/cia_global_response/leader/no_iff
	strength_type = STRENGTH_NO_IFF

/datum/equipment_preset/cia_global_response/leader/weak
	strength_type = STRENGTH_WEAK
	suit_type = /obj/item/clothing/suit/storage/marine/sof/grs/damaged
	helmet_type = /obj/item/clothing/head/helmet/marine/sof/grs/damaged

/datum/equipment_preset/cia_global_response/leader/weak/survivor
	strength_type = STRENGTH_SURVIVOR
	skills = /datum/skills/cia/global_response/leader/survivor

/datum/equipment_preset/cia_global_response/leader/load_gear(mob/living/carbon/human/new_human)
	load_standard_gear(new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)

	switch(strength_type)
		if(STRENGTH_WEAK, STRENGTH_SURVIVOR)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)

			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/black/m47/weak, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m47, WEAR_J_STORE)

			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/not_op, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717/cia, WEAR_L_STORE)

			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/phosphorus, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/high_explosive, WEAR_IN_BACK)
			if(strength_type == STRENGTH_SURVIVOR)
				new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/medium_stack, WEAR_IN_BACK)

		if(STRENGTH_NORM, STRENGTH_NO_IFF)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/ap, WEAR_IN_ACCESSORY)

			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/black/m47/ap, WEAR_WAIST)

			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m47/ap, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/le, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/le, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/le, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/le, WEAR_IN_JACKET)

			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/no_stims, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4_breaching, WEAR_L_STORE)

			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/m15, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/phosphorus/strong, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/high_explosive, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717/cia, WEAR_IN_BACK)

		if(STRENGTH_DEATH)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/m4a4/tactical/incendiary, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/incendiary, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/incendiary, WEAR_IN_ACCESSORY)

			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/black/m47/heap, WEAR_WAIST)

			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m47/heap, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/heap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/heap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/heap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/heap, WEAR_IN_JACKET)

			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/full, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4_breaching, WEAR_L_STORE)

			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/m15, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/phosphorus/strong, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/high_explosive/super, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717/cia, WEAR_IN_BACK)


//*****************************************************************************************************/

/datum/equipment_preset/cia_global_response/commander
	name = JOB_CIA_GRS_CDR
	paygrades = list(PAY_SHORT_GRS_CDR = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_CIA_GRS_CDR
	job_title = JOB_CIA_GRS_CDR
	skills = /datum/skills/cia/global_response/commander
	minimap_icon = "pmc_sd"
	role_comm_title = "CDR"

/datum/equipment_preset/cia_global_response/commander/deathsquad
	strength_type = STRENGTH_DEATH
	mask_type = /obj/item/clothing/mask/gas/pmc/marsoc/grs/deathsquad

/datum/equipment_preset/cia_global_response/commander/no_iff
	strength_type = STRENGTH_NO_IFF

/datum/equipment_preset/cia_global_response/commander/weak
	strength_type = STRENGTH_WEAK
	suit_type = /obj/item/clothing/suit/storage/marine/sof/grs/damaged
	helmet_type = /obj/item/clothing/head/helmet/marine/sof/grs/damaged

/datum/equipment_preset/cia_global_response/commander/weak/survivor
	strength_type = STRENGTH_SURVIVOR
	skills = /datum/skills/cia/global_response/commander/survivor

/datum/equipment_preset/cia_global_response/commander/load_gear(mob/living/carbon/human/new_human)
	load_standard_gear(new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing/black, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)

	switch(strength_type)
		if(STRENGTH_WEAK, STRENGTH_SURVIVOR)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47, WEAR_IN_ACCESSORY)

			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911/commander/tactical/half, WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m47, WEAR_J_STORE)

			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/not_op, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/m47/ap, WEAR_L_STORE)

			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/phosphorus, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/high_explosive, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717/cia, WEAR_IN_BACK)
			if(strength_type == STRENGTH_SURVIVOR)
				new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/medium_stack, WEAR_IN_BACK)

		if(STRENGTH_NORM, STRENGTH_NO_IFF)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/ap, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/ap, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/ap, WEAR_IN_ACCESSORY)

			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911/commander/tactical, WEAR_WAIST)

			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m47/ap, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/le, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/le, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/le, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/le, WEAR_IN_JACKET)

			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/no_stims, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/m47/ap, WEAR_L_STORE)

			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/m15, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/phosphorus/strong, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/high_explosive, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717/cia, WEAR_IN_BACK)

		if(STRENGTH_DEATH)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/incendiary, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/incendiary, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/incendiary, WEAR_IN_ACCESSORY)

			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911/commander/tactical/boom, WEAR_WAIST)

			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m47/heap, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/heap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/heap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/heap, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m47/heap, WEAR_IN_JACKET)

			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/full, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/m47/heap, WEAR_L_STORE)

			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/m15, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/phosphorus/strong, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/high_explosive/super, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717/cia, WEAR_IN_BACK)

/datum/equipment_preset/cia_global_response/commander/deputy
	name = JOB_CIA_GRS_DCDR
	paygrades = list(PAY_SHORT_GRS_DCDR = JOB_PLAYTIME_TIER_0)
	assignment = JOB_CIA_GRS_DCDR
	job_title = JOB_CIA_GRS_DCDR
	skills = /datum/skills/cia/global_response/commander/deputy
	role_comm_title = "DCDR"

/datum/equipment_preset/cia_global_response/commander/deputy/deathsquad
	strength_type = STRENGTH_DEATH
	mask_type = /obj/item/clothing/mask/gas/pmc/marsoc/grs/deathsquad

/datum/equipment_preset/cia_global_response/commander/deputy/no_iff
	strength_type = STRENGTH_NO_IFF

/datum/equipment_preset/cia_global_response/commander/deputy/weak
	strength_type = STRENGTH_WEAK
	suit_type = /obj/item/clothing/suit/storage/marine/sof/grs/damaged
	helmet_type = /obj/item/clothing/head/helmet/marine/sof/grs/damaged

/datum/equipment_preset/cia_global_response/commander/deputy/weak/survivor
	strength_type = STRENGTH_SURVIVOR
	skills = /datum/skills/cia/global_response/commander/deputy/survivor


//*****************************************************************************************************/

/datum/equipment_preset/cia_global_response/synth
	name = JOB_CIA_GRS_SYN
	flags = EQUIPMENT_PRESET_EXTRA
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE, LANGUAGE_CHINESE, LANGUAGE_RUSSIAN, LANGUAGE_GERMAN, LANGUAGE_SCANDINAVIAN, LANGUAGE_SPANISH, LANGUAGE_FRENCH, LANGUAGE_TSL, LANGUAGE_YAUTJA, LANGUAGE_XENOMORPH)
	skills = /datum/skills/synthetic/antag
	assignment = JOB_CIA_GRS_SYN
	job_title = JOB_CIA_GRS_SYN
	minimap_icon = "pmc_syn"
	paygrades = list(PAY_SHORT_SYN = JOB_PLAYTIME_TIER_0)
	role_comm_title = "GRS Syn"
	helmet_type = null
	mask_type = null
	suit_type = /obj/item/clothing/suit/storage/marine/sof/grs/synth

/datum/equipment_preset/cia_global_response/synth/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(MALE, FEMALE)

	var/datum/preferences/A = new()
	A.randomize_appearance(new_human)

	var/random_name
	switch(new_human.gender)
		if(FEMALE)
			random_name = capitalize(pick(GLOB.first_names_female))
		if(PLURAL, NEUTER) // Not currently possible
			random_name = capitalize(pick(MALE, FEMALE) == MALE ? pick(GLOB.first_names_male) : pick(GLOB.first_names_female))
		else // MALE
			random_name = capitalize(pick(GLOB.first_names_male))
			new_human.f_style = "5 O'clock Shadow"

	new_human.change_real_name(new_human, random_name)
	new_human.r_hair = 15
	new_human.g_hair = 15
	new_human.b_hair = 25
	new_human.r_eyes = 139
	new_human.g_eyes = 62
	new_human.b_eyes = 19

/datum/equipment_preset/cia_global_response/synth/load_race(mob/living/carbon/human/new_human)
	new_human.set_species(SYNTH_GEN_THREE)
	new_human.allow_gun_usage = FALSE

/datum/equipment_preset/cia_global_response/synth/load_gear(mob/living/carbon/human/new_human)
	load_standard_gear(new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/surg_vest/equipped, WEAR_ACCESSORY)

	//backpack and stuff in it
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/blood/OMinus, WEAR_IN_BACK)

	switch(strength_type)
		if(STRENGTH_WEAK, STRENGTH_SURVIVOR)

			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/low_grade_full/wy, WEAR_L_STORE)

			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/wy/full_advanced, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch/black/grs_weak, WEAR_WAIST)

			new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
			if(strength_type == STRENGTH_SURVIVOR)
				new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/medium_stack, WEAR_IN_BACK)

		if(STRENGTH_NORM, STRENGTH_NO_IFF)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full_barbed_wire/wy, WEAR_L_STORE)

			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/wy/full_elite, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch/black/grs, WEAR_WAIST)

			new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/grs_medical, WEAR_IN_BACK)

		if(STRENGTH_DEATH)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full_barbed_wire/wy, WEAR_L_STORE)

			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/wy/full_elite, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch/black/grs, WEAR_WAIST)

			new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/grs_medical/deathsquad, WEAR_IN_BACK)

/datum/equipment_preset/cia_global_response/synth/deathsquad
	strength_type = STRENGTH_DEATH

/datum/equipment_preset/cia_global_response/synth/no_iff
	strength_type = STRENGTH_NO_IFF

/datum/equipment_preset/cia_global_response/synth/weak
	strength_type = STRENGTH_WEAK

/datum/equipment_preset/cia_global_response/synth/weak/survivor
	strength_type = STRENGTH_SURVIVOR


#undef STRENGTH_NORM
#undef STRENGTH_NO_IFF
#undef STRENGTH_WEAK
#undef STRENGTH_SURVIVOR
#undef STRENGTH_DEATH
