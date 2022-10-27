
/datum/equipment_preset/pmc
	name = "PMC"
	faction = FACTION_PMC
	rank = FACTION_PMC
	idtype = /obj/item/card/id/pmc
	faction = FACTION_PMC
	faction_group = FACTION_LIST_WY
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	var/human_versus_human = FALSE
	var/headset_type = /obj/item/device/radio/headset/distress/PMC

/datum/equipment_preset/pmc/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()


/datum/equipment_preset/pmc/load_name(mob/living/carbon/human/H, var/randomise)
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

	var/choice = rand(1,6)
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC, WEAR_BODY)
	if(prob(50))
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC, WEAR_JACKET)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC/light, WEAR_JACKET)
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
		if(1,2)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_L_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/nsg23, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/nsg_ap, WEAR_L_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/nsg_ext, WEAR_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/nsg23/ap, WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/nsg23/ap, WEAR_IN_BACK)
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

/datum/equipment_preset/pmc/pmc_standard/hvh
	name = "Weyland-Yutani PMC (Standard) | HvH"
	human_versus_human = TRUE
	headset_type = /obj/item/device/radio/headset/distress/PMC/hvh

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
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC, WEAR_BODY)
	if(prob(50))
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC, WEAR_JACKET)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC/light, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
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

/datum/equipment_preset/pmc/pmc_detainer/hvh
	name = "Weyland-Yutani PMC (Detainer) | HvH"
	human_versus_human = TRUE
	headset_type = /obj/item/device/radio/headset/distress/PMC/hvh

//*****************************************************************************************************/
/datum/equipment_preset/pmc/pmc_medic
	name = "Weyland-Yutani PMC (Corporate Medic)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_PMC_MEDIC
	rank = JOB_PMC_MEDIC
	paygrade = "PMC-MS"
	skills = /datum/skills/pmc/medic

/datum/equipment_preset/pmc/pmc_medic/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/PMC, WEAR_IN_JACKET)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/PMC, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol/skillless, WEAR_IN_BELT)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_R_STORE)

/datum/equipment_preset/pmc/pmc_medic/hvh
	name = "Weyland-Yutani PMC (Corporate Medic) | HvH"
	human_versus_human = TRUE
	headset_type = /obj/item/device/radio/headset/distress/PMC/hvh

//*****************************************************************************************************/
/datum/equipment_preset/pmc/pmc_med_investigator
	name = "Weyland-Yutani PMC (Medical Investigator)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_PMC_INVESTIGATOR
	rank = JOB_PMC_INVESTIGATOR
	paygrade = "PMC-MS" //Fixed from PMC2 to PMC-MS to display properly.
	skills = /datum/skills/pmc/medic/chem

/datum/equipment_preset/pmc/pmc_med_investigator/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol/skillless, WEAR_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BELT)

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

//*****************************************************************************************************/

/datum/equipment_preset/pmc/pmc_leader
	name = "Weyland-Yutani PMC (Leader)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_PMC_LEADER
	rank = JOB_PMC_LEADER
	paygrade = "PMC-TL"
	role_comm_title = "SL"
	skills = /datum/skills/pmc/SL

/datum/equipment_preset/pmc/pmc_leader/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
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

	var/obj/item/device/radio/headset/R = H.wear_l_ear
	if(istype(R))
		R.volume = RADIO_VOLUME_IMPORTANT

/datum/equipment_preset/pmc/pmc_leader/hvh
	name = "Weyland-Yutani PMC (Leader) | HvH"
	human_versus_human = TRUE
	headset_type = /obj/item/device/radio/headset/distress/PMC/hvh/cct

//*****************************************************************************************************/

/datum/equipment_preset/pmc/pmc_lead_investigator
	name = "Weyland-Yutani PMC (Lead Investigator)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_PMC_LEAD_INVEST
	rank = JOB_PMC_LEAD_INVEST
	paygrade = "PMC-TL"
	role_comm_title = "SL"
	skills = /datum/skills/pmc/SL/chem

/datum/equipment_preset/pmc/pmc_lead_investigator/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
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
	paygrade = "PMC-SS"
	role_comm_title = "SG"
	skills = /datum/skills/pmc/smartgunner

/datum/equipment_preset/pmc/pmc_gunner/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
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

/datum/equipment_preset/pmc/pmc_gunner/hvh
	name = "Weyland-Yutani PMC (Gunner) | HvH"
	human_versus_human = TRUE
	headset_type = /obj/item/device/radio/headset/distress/PMC/hvh

//*****************************************************************************************************/

/datum/equipment_preset/pmc/pmc_sniper
	name = "Weyland-Yutani PMC (Sniper)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_PMC_SNIPER
	rank = JOB_PMC_SNIPER
	paygrade = "PMC-WS"
	role_comm_title = "Spc"
	skills = /datum/skills/pmc/specialist

/datum/equipment_preset/pmc/pmc_sniper/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC/sniper, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/sniper, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/leader, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/m42c, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/large_holster/m39/full/elite, WEAR_WAIST)
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

/datum/equipment_preset/pmc/pmc_sniper/hvh
	name = "Weyland-Yutani PMC (Sniper) | HvH"
	human_versus_human = TRUE
	headset_type = /obj/item/device/radio/headset/distress/PMC/hvh/cct

/datum/equipment_preset/pmc/pmc_sniper/hvh/load_gear(mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)

//*****************************************************************************************************/
/datum/equipment_preset/pmc/pmc_crewman
	name = "Weyland-Yutani PMC (Crewman)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "Weyland-Yutani PMC (Crewman)"
	rank = JOB_PMC_CREWMAN
	paygrade = "PMC-VS"
	skills = /datum/skills/pmc/tank_crew

/datum/equipment_preset/pmc/pmc_crewman/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
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

/datum/equipment_preset/pmc/pmc_crewman/hvh
	name = "Weyland-Yutani PMC (Crewman) | HvH"
	human_versus_human = TRUE
	headset_type = /obj/item/device/radio/headset/distress/PMC/hvh/cct

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

/datum/equipment_preset/pmc/xeno_handler/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/multitool, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/PMC, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88, WEAR_WAIST)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)

/datum/equipment_preset/pmc/xeno_handler/hvh
	name = "Weyland-Yutani PMC (Xeno Handler) | HvH"
	faction_group = FACTION_LIST_WY
	human_versus_human = TRUE
	headset_type = /obj/item/device/radio/headset/distress/PMC/hvh/cct

/*****************************************************************************************************/

/datum/equipment_preset/pmc/doctor
	name = "Weyland-Yutani PMC (Trauma Surgeon)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_PMC_DOCTOR
	rank = JOB_PMC_DOCTOR
	paygrade = "PMC-DOC"
	role_comm_title = "TRI"
	skills = /datum/skills/pmc/doctor

/datum/equipment_preset/pmc/doctor/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical, WEAR_FACE)
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/surg_vest/equipped, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC/light, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/nsg23, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/nsg23, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/nsg23, WEAR_J_STORE)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/pressurized_reagent_canister/revival, WEAR_R_STORE)

	//Extra oxy for surgery.
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/oxycodone, WEAR_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/oxycodone, WEAR_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/oxycodone, WEAR_IN_BELT)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/oxycodone, WEAR_IN_BELT)

/datum/equipment_preset/pmc/doctor/hvh
	name = "Weyland-Yutani PMC (Trauma Surgeon) | HvH"
	human_versus_human = TRUE
	headset_type = /obj/item/device/radio/headset/distress/PMC/hvh

/*****************************************************************************************************/

/datum/equipment_preset/pmc/technician
	name = "Weyland-Yutani PMC (Corporate Technician)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_PMC_ENGINEER
	rank = JOB_PMC_ENGINEER
	paygrade = "PMC-TECH"
	role_comm_title = "TEC"
	skills = /datum/skills/pmc/engineer

/datum/equipment_preset/pmc/technician/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest/brown_vest, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC/light, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/fp9000, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/fp9000, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/fp9000/pmc, WEAR_J_STORE)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/PMC, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/PMC, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/shovel/etool/folded, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/mini, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/mini, WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full, WEAR_R_STORE)

/datum/equipment_preset/pmc/technician/hvh
	name = "Weyland-Yutani PMC (Corporate Technician) | HvH"
	human_versus_human = TRUE
	headset_type = /obj/item/device/radio/headset/distress/PMC/hvh/cct

/*****************************************************************************************************/

/datum/equipment_preset/pmc/director
	name = "Weyland-Yutani PMC (Site Director)"
	flags = EQUIPMENT_PRESET_EXTRA

	languages = list(LANGUAGE_ENGLISH, LANGUAGE_RUSSIAN, LANGUAGE_JAPANESE, LANGUAGE_WELTRAUMDEUTSCH, LANGUAGE_NEOSPANISH, LANGUAGE_CHINESE)

	assignment = JOB_PMC_DIRECTOR
	rank = JOB_PMC_DIRECTOR
	paygrade = "PMC-DIR"
	role_comm_title = "DIR"
	skills = /datum/skills/pmc/director

/datum/equipment_preset/pmc/director/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/leader, WEAR_HEAD)
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/director, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/pmc, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)

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

/datum/equipment_preset/pmc/director/hvh
	name = "Weyland-Yutani PMC (Site Director) | HvH"
	human_versus_human = TRUE
	headset_type = /obj/item/device/radio/headset/distress/PMC/hvh/cct

//*****************************************************************************************************/

/datum/equipment_preset/pmc/synth
		name = "Weyland-Yutani PMC (Support Synthetic)"
		flags = EQUIPMENT_PRESET_EXTRA

		languages = list(LANGUAGE_ENGLISH, LANGUAGE_RUSSIAN, LANGUAGE_JAPANESE, LANGUAGE_YAUTJA, LANGUAGE_XENOMORPH, LANGUAGE_WELTRAUMDEUTSCH, LANGUAGE_NEOSPANISH, LANGUAGE_CHINESE)

		skills = /datum/skills/synthetic
		idtype = /obj/item/card/id/data
		assignment = JOB_PMC_SYNTH
		rank = JOB_PMC_SYNTH
		role_comm_title = "SYN"


/datum/equipment_preset/pmc/synth/load_name(mob/living/carbon/human/H, var/randomise)
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
		var/obj/item/clothing/under/marine/veteran/PMC/PMC = new()
		var/obj/item/clothing/accessory/storage/webbing/W = new()
		PMC.attach_accessory(H, W)
		H.equip_to_slot_or_del(PMC, WEAR_BODY)

		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC, WEAR_HEAD)
		H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)

		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC/light/synth, WEAR_JACKET)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)

		H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
		H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/weapon/melee/telebaton, WEAR_IN_BACK)
		H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)

		H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_suture_and_graft, WEAR_WAIST)
		H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H), WEAR_IN_BELT)
		H.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)

		H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/synth, WEAR_L_STORE)
		H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full_barbed_wire, WEAR_R_STORE)

/datum/equipment_preset/pmc/synth/hvh
		name = "Weyland-Yutani PMC (Support Synthetic) | HvH"
		human_versus_human = TRUE
		headset_type = /obj/item/device/radio/headset/distress/PMC/hvh/cct
