
/datum/equipment_preset/pmc
	name = "PMC"
	faction = FACTION_PMC
	rank = FACTION_PMC
	idtype = /obj/item/card/id/pmc
	faction = FACTION_PMC
	faction_group = FACTION_LIST_WY
	languages = list("English")

/datum/equipment_preset/pmc/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()


/datum/equipment_preset/pmc/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(MALE,FEMALE)
	var/list/first_names_m = list("Owen","Luka","Nelson","Branson", "Tyson", "Leo", "Bryant", "Kobe", "Rohan", "Riley", "Aidan", "Watase","Egawa", "Hisakawa", "Koide", "Remy", "Martial", "Magnus", "Heiko", "Lennard")
	var/list/first_names_f = list("Madison","Jessica","Anna","Juliet", "Olivia", "Lea", "Diane", "Kaori", "Beatrice", "Riley", "Amy", "Natsue","Yumi", "Aiko", "Fujiko", "Jennifer", "Ashley", "Mary", "Hitomi", "Lisa")
	var/list/last_names_mb = list("Bates","Shaw","Hansen","Black", "Chambers", "Hall", "Gibson", "Weiss", "Waller", "Burton", "Bakin", "Rohan", "Naomichi", "Yakumo", "Yosai", "Gallagher", "Hiles", "Bourdon", "Strassman", "Palau")
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	if(H.gender == MALE)
		random_name = "PMC [pick(first_names_m)] [pick(last_names_mb)]"
		H.f_style = "5 O'clock Shadow"
	else
		random_name = "PMC [pick(first_names_f)] [pick(last_names_mb)]"
	H.change_real_name(H, random_name)
	H.age = rand(25,35)
	H.h_style = "Shaved Head"
	H.r_hair = 25
	H.g_hair = 25
	H.b_hair = 35

//*****************************************************************************************************/
/datum/equipment_preset/pmc/pmc_survivor
	name = "Survivor - PMC"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "Weyland-Yutani PMC (Standard)"
	rank = JOB_PMC
	paygrade = "PMC1"
	skills = /datum/skills/pmc

/datum/equipment_preset/pmc/pmc_survivor/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)

//*****************************************************************************************************/
/datum/equipment_preset/pmc/pmc_standard
	name = "Weyland-Yutani PMC (Standard)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "Weyland-Yutani PMC (Standard)"
	rank = JOB_PMC
	paygrade = "PMC1"
	skills = /datum/skills/pmc

/datum/equipment_preset/pmc/pmc_standard/load_gear(mob/living/carbon/human/H)

	var/choice = rand(1,6)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/PMC, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)

	switch(choice)
		if(1,2,3)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_L_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/underextinguisher, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/pmc_mod88, WEAR_L_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/pmc_mod88, WEAR_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank, WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank, WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank, WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank, WEAR_IN_BACK)
		if(5,6)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle, WEAR_L_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle, WEAR_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_BACK)

//*****************************************************************************************************/
/datum/equipment_preset/pmc/pmc_detainer
	name = "Weyland-Yutani PMC (Detainer)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "Weyland-Yutani PMC (Detainer)"
	rank = JOB_PMC
	paygrade = "PMC1"
	skills = /datum/skills/pmc

/datum/equipment_preset/pmc/pmc_detainer/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/holster, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/taser, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer/underextinguisher, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/pmc_mod88, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank, WEAR_IN_BACK)

//*****************************************************************************************************/
/datum/equipment_preset/pmc/pmc_medic
	name = "Weyland-Yutani PMC (Medic)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "Weyland-Yutani PMC (Medic)"
	rank = "PMC Medic"
	paygrade = "PMC2M" //Fixed from PMC2 to PMC2M to display properly.
	skills = /datum/skills/pmc/medic

/datum/equipment_preset/pmc/pmc_medic/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol/skillless, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/PMC, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)

//*****************************************************************************************************/
/datum/equipment_preset/pmc/pmc_med_investigator
	name = "Weyland-Yutani PMC (Medical Investigator)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_PMC_INVESTIGATOR
	rank = JOB_PMC_INVESTIGATOR
	paygrade = "PMC2M" //Fixed from PMC2 to PMC2M to display properly.
	skills = /datum/skills/pmc/medic/chem

/datum/equipment_preset/pmc/pmc_med_investigator/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol/skillless, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/device/reagent_scanner, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder, WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/syringe/full, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/syringe/counteragent, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/sedative, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_JACKET)

//*****************************************************************************************************/

/datum/equipment_preset/pmc/pmc_leader
	name = "Weyland-Yutani PMC (Leader)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_PMC_LEADER
	rank = JOB_PMC_LEADER
	paygrade = "PMC4"
	role_comm_title = "SL"
	skills = /datum/skills/pmc/SL

/datum/equipment_preset/pmc/pmc_leader/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC/leader, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC/leader, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/leader, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/leader, WEAR_FACE)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/PMC, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite, WEAR_J_STORE)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/pmc/pmc_lead_investigator
	name = "Weyland-Yutani PMC (Lead Investigator)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_PMC_LEAD_INVEST
	rank = JOB_PMC_LEAD_INVEST
	paygrade = "PMC4"
	role_comm_title = "SL"
	skills = /datum/skills/pmc/SL/chem

/datum/equipment_preset/pmc/pmc_lead_investigator/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC/leader, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC/leader, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/leader, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/leader, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/fp9000/pmc, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/reagent_scanner, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_p90, WEAR_L_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/pmc/pmc_gunner
	name = "Weyland-Yutani PMC (Gunner)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_PMC_GUNNER
	rank = JOB_PMC_GUNNER
	paygrade = "PMC2S"
	role_comm_title = "SG"
	skills = /datum/skills/pmc/smartgunner

/datum/equipment_preset/pmc/pmc_gunner/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/smartgunner/veteran/PMC, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/gunner, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/leader, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/smartgun_powerpack/snow, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun/dirty, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/pmc_vp78, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner/pmc/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles, WEAR_EYES)

//*****************************************************************************************************/

/datum/equipment_preset/pmc/pmc_sniper
	name = "Weyland-Yutani PMC (Sniper)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_PMC_SNIPER
	rank = JOB_PMC_SNIPER
	paygrade = "PMC3"
	role_comm_title = "Spc"
	skills = /datum/skills/pmc/specialist

/datum/equipment_preset/pmc/pmc_sniper/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC/sniper, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/sniper, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/m42_goggles, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/sniper/elite, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_sniper, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)


//*****************************************************************************************************/
/datum/equipment_preset/pmc/pmc_crewman
	name = "Weyland-Yutani PMC (Crewman)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "Weyland-Yutani PMC (Crewman)"
	rank = JOB_PMC_CREWMAN
	paygrade = "PMC5"
	skills = /datum/skills/pmc/tank_crew

/datum/equipment_preset/pmc/pmc_crewman/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC, WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/tool/weldpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/leader, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tank, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_L_STORE)

	spawn_weapon(/obj/item/weapon/gun/smg/m39/elite, /obj/item/ammo_magazine/smg/m39/ap, H, 0, 0)

/*****************************************************************************************************/

/datum/equipment_preset/pmc/xeno_handler
    name = "Weyland-Yutani PMC (Xeno Handler)"
    flags = EQUIPMENT_PRESET_EXTRA

    faction_group = FACTION_LIST_MARINE_WY

    assignment = JOB_PMC_XENO_HANDLER
    rank = JOB_PMC_XENO_HANDLER
    paygrade = "PMC3"
    role_comm_title = "Spc"
    skills = /datum/skills/pmc/xeno_handler
    languages = list("English", "Xenomorph")

/datum/equipment_preset/pmc/xeno_handler/load_gear(mob/living/carbon/human/H)
    H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC, WEAR_EAR)
    H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC, WEAR_BODY)
    H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC, WEAR_JACKET)
    H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
    H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC, WEAR_HEAD)
    H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
    H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)

    H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
    H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/PMC, WEAR_IN_BACK)
    H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
    H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
    H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
    H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88, WEAR_WAIST)
    H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)

    H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite, WEAR_J_STORE)
    H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_L_STORE)
    H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_R_STORE)
    H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
    H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
    H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)

/*****************************************************************************************************/

/datum/equipment_preset/pmc/w_y_whiteout
	name = "Whiteout Team Operative"
	flags = EQUIPMENT_PRESET_EXTRA
	uses_special_name = TRUE //We always use a codename!
	faction = FACTION_WY_DEATHSQUAD
	assignment = "Whiteout Team Operative"
	role_comm_title = "WO"
	rank = FACTION_WY_DEATHSQUAD
	skills = /datum/skills/everything //They are Synths, programmed for Everything.
	idtype = /obj/item/card/id/pmc/ds

/datum/equipment_preset/pmc/w_y_whiteout/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/pmc/w_y_whiteout/load_race(mob/living/carbon/human/H)
	H.set_species(SYNTH_COMBAT)
	H.allow_gun_usage = TRUE //To allow usage of Guns/Grenades

/datum/equipment_preset/pmc/w_y_whiteout/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(MALE)
	//var/datum/preferences/A = new()
	//A.randomize_appearance(mob)
	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(greek_letters)]"
	else
		random_name = "[pick(greek_letters)]"
	H.change_real_name(H, random_name)
	H.age = rand(17,45)

/datum/equipment_preset/pmc/w_y_whiteout/load_languages(mob/living/carbon/human/H)
	H.set_languages(list("English", "Japanese", "Spacendeutchen", "Spanish", "Russian", "Tactical Sign Language")) //Synths after all.

/datum/equipment_preset/pmc/w_y_whiteout/load_gear(mob/living/carbon/human/H)
	// back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/commando, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/m42_goggles, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/leader, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/commando, WEAR_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/commando, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/PMC/commando/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)
	H.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/PMC, WEAR_IN_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/veteran/PMC/commando/armor = new()
	H.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/full, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC/commando, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/commando/knife, WEAR_FEET)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle, WEAR_L_STORE)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(H)

//*****************************************************************************************************/

/datum/equipment_preset/pmc/w_y_whiteout/medic
	name = "Whiteout Team Medic"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Whiteout Team Medic"
	role_comm_title = "WO-TM"

/datum/equipment_preset/pmc/w_y_whiteout/medic/load_gear(mob/living/carbon/human/H)
	// back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/commando, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/weldingtool/hugetank, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/cable_coil/white, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/cable_coil/white, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/m42_goggles, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/leader, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/commando, WEAR_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/commando, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/PMC/commando/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)
	H.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/veteran/PMC/commando/armor = new()
	H.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/full, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC/commando, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/commando/knife, WEAR_FEET)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_R_STORE)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(H)

//*****************************************************************************************************/
/datum/equipment_preset/pmc/w_y_whiteout/terminator
	name = "Whiteout Team Terminator"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Whiteout Team Terminator"
	role_comm_title = "WO-TT"

/datum/equipment_preset/pmc/w_y_whiteout/terminator/load_gear(mob/living/carbon/human/H)
	// back
	H.equip_to_slot_or_del(new /obj/item/smartgun_powerpack/snow, WEAR_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/m42_goggles, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/leader, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/commando, WEAR_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/commando, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/PMC/commando/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)
	H.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/PMC, WEAR_IN_ACCESSORY)
	//jacket
	var/obj/item/clothing/suit/storage/marine/smartgunner/veteran/PMC/terminator/armor = new()
	H.equip_to_slot_or_del(armor, WEAR_JACKET)
	for(var/i in 1 to armor.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/stack/nanopaste, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun/dirty/elite, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner/pmc/full, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC/commando, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/commando/knife, WEAR_FEET)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_sg, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_sg, WEAR_L_STORE)

	var/obj/item/device/internal_implant/agility/implant = new()
	implant.on_implanted(H)

//*****************************************************************************************************/
/datum/equipment_preset/pmc/w_y_whiteout/leader
	name = "Whiteout Team Leader"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Whiteout Team Leader"
	role_comm_title = "WO-TL"
