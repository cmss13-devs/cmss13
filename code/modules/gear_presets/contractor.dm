/datum/equipment_preset/contractor
	name = "Military Contractor"

	assignment = "VAI Mercenary"
	rank = JOB_CONTRACTOR
	idtype = /obj/item/card/id/data
	faction = FACTION_MARINE

/datum/equipment_preset/contractor/New()
	. = ..()
	access = get_all_accesses()

/datum/equipment_preset/other/elite_merc/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(80;MALE,20;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(first_names_male)] [pick(last_names)]"
		H.f_style = "5 O'clock Shadow"
	else
		random_name = "[pick(first_names_female)] [pick(last_names)]"
	H.change_real_name(H, random_name)
	H.age = rand(20,45)
	H.r_hair = rand(15,35)
	H.g_hair = rand(15,35)
	H.b_hair = rand(25,45)

//*****************************************************************************************************/

/datum/equipment_preset/contractor
	name = "Military Contractor"
	faction = FACTION_MARINE
	rank = JOB_CONTRACTOR
	idtype = /obj/item/card/id/data
	faction = FACTION_MARINE
	faction_group = FACTION_LIST_MARINE
	languages = list(LANGUAGE_ENGLISH)
	var/human_versus_human = FALSE
	var/headset_type = /obj/item/device/radio/headset/distress/PMC

/datum/equipment_preset/contractor/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()


/datum/equipment_preset/dust_raider/load_name(mob/living/carbon/human/H)
	H.gender = pick(60;MALE,40;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	random_name = capitalize(pick(H.gender == MALE ? first_names_male : first_names_female)) + " " + capitalize(pick(last_names))
	H.change_real_name(H, random_name)
	H.name = H.real_name
	H.age = rand(25,45)

	if(H.gender == MALE)
		H.f_style = pick("3 O'clock Shadow", "3 O'clock Moustache", "5 O'clock Shadow", "5 O'clock Moustache")

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

/datum/equipment_preset/contractor/load_id(mob/living/carbon/human/H, client/mob_client)
	if(human_versus_human)
		var/obj/item/clothing/under/uniform = H.w_uniform
		if(istype(uniform))
			uniform.has_sensor = UNIFORM_HAS_SENSORS
			uniform.sensor_faction = FACTION_MARINE
	return ..()

//*****************************************************************************************************/

/datum/equipment_preset/contractor/duty/standard
	name = "Military Contractor (Standard)"
	paygrade = "VAI-MERC "
	role_comm_title = "Merc"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "VAIPO Mercenary"
	rank = JOB_CONTRACTOR_ST
	skills = /datum/skills/contractor
	faction = FACTION_MARINE

/datum/equipment_preset/contractor/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/contractor/duty/load_gear(mob/living/carbon/human/H)

	var/choice = rand(1,10)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/contractor, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/gray_blu, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911/socom, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/MRE,WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)

	switch(choice)
		if(1 to 4)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/mar40/tactical, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing, WEAR_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40, WEAR_IN_BACK)
		if(5 to 7)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/tactical, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing, WEAR_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/extended, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/extended, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/extended, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/extended, WEAR_IN_BACK)
		if(8 to 9)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/combat/covert, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest, WEAR_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/large/buckshot, WEAR_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
		if(10)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1/tactical, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest, WEAR_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1, WEAR_IN_BACK)


//*****************************************************************************************************/

/datum/equipment_preset/contractor/duty/heavy
	name = "Military Contractor (Machinegunner)"
	paygrade = "VAI-MG "
	role_comm_title = "MG"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "VAIPO Automatic Rifleman"
	rank = JOB_CONTRACTOR_MG
	skills = /datum/skills/contractor/heavy
	faction = FACTION_MARINE

/datum/equipment_preset/contractor/duty/heavy/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/contractor/duty/heavy/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/contractor, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/gray_blu, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/lmg, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/lmg, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/lmg, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/mar40/lmg/tactical, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911/socom, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_R_STORE)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/MRE,WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/lmg, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/lmg, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)


//*****************************************************************************************************/
/datum/equipment_preset/contractor/duty/engi
	name = "Military Contractor (Engineer)"
	paygrade = "VAI-ENG "

	role_comm_title = "Eng"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "VAIPO Engineering Specialist"
	rank = JOB_CONTRACTOR_ENGI
	skills = /datum/skills/contractor/engi
	faction = FACTION_MARINE

/datum/equipment_preset/contractor/duty/engi/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/contractor/duty/engi/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/w_br, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest/tool_webbing, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/contractor, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/mar40/carbine/tactical, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding/superior, WEAR_EYES)
	//storage items
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40, WEAR_IN_R_STORE)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/large_stack, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/mini, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15, WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/contractor/duty/medic
	name = "Military Contractor (Medic)"
	paygrade = "VAI-MED "
	role_comm_title = "Med"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "VAIMS Medical Specialist"
	rank = JOB_CONTRACTOR_MEDIC
	skills = /datum/skills/contractor/medic
	faction = FACTION_MARINE

/datum/equipment_preset/contractor/duty/medic/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/contractor/duty/medic/load_gear(mob/living/carbon/human/H)
	//clothing
	H.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/w_br, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/contractor, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/surg_vest/equipped, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/mar40/carbine/tactical, WEAR_J_STORE)
	//storage items
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch, WEAR_WAIST)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK) //Line in vest.
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/contractor/duty/leader
	name = "Military Contractor (Leader)"
	paygrade = "VAI-TL "
	role_comm_title = "TL"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "VAIPO Team Leader"
	rank = JOB_CONTRACTOR_TL
	skills = /datum/skills/contractor/leader
	faction = FACTION_MARINE

/datum/equipment_preset/contractor/duty/leader/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/contractor/duty/leader/load_gear(mob/living/carbon/human/H)
	//clothes
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/contractor, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/r_bla, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1/tactical, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911/socom, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/sensor, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_R_STORE)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments, WEAR_IN_BACK)

//*****************************************************************************************************/
/datum/equipment_preset/contractor/duty/synth
	name = "Military Contractor (Synthetic)"
	paygrade = "VAI-SYN "
	role_comm_title = "Syn"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "VAIPO Support Synthetic"
	rank = JOB_CONTRACTOR_SYN
	skills = /datum/skills/synthetic
	faction = FACTION_MARINE

/datum/equipment_preset/contractor/duty/synth/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(50;MALE,50;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(first_names_male)]"
	else
		random_name = "[pick(first_names_female)]"

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
	idtype = /obj/item/card/id/data

/datum/equipment_preset/contractor/duty/synth/load_race(mob/living/carbon/human/H)
	H.set_species(SYNTH_GEN_THREE)

/datum/equipment_preset/contractor/duty/synth/load_gear(mob/living/carbon/human/H)
	load_name(H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/smartpack/black, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK) //1
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK) //2
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/contractor, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/experimental_mesons, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine, WEAR_HEAD)
	//body
	H.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/r_bla, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/surg_vest/equipped, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/synvest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/telebaton, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/twohanded/breacher, WEAR_L_HAND)
	//póckets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full_barbed_wire, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/screwdriver/tactical, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/wirecutters/tactical, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/wrench, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/stack/cable_coil, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/stack/cable_coil, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/multitool, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/weldingtool/hugetank, WEAR_IN_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/contractor/covert/standard
	name = "Military Contractor (Covert Standard)"
	paygrade = "VAI-MERC "
	role_comm_title = "Merc"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "VAISO Mercenary"
	rank = JOB_CONTRACTOR_COVST
	skills = /datum/skills/contractor
	faction = FACTION_MARINE

/datum/equipment_preset/contractor/covert/standard/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/contractor/covert/load_gear(mob/living/carbon/human/H)

	var/choice = rand(1,10)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/contractor, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/ua_civvies, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911/socom, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/covert, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/helmet_nvg/marsoc, WEAR_IN_HELMET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/tactical, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/MRE,WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)

	switch(choice)
		if(1 to 4)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/mar40/tactical, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing, WEAR_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40, WEAR_IN_BACK)
		if(5 to 7)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/tactical, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing, WEAR_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/extended, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/extended, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/extended, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/extended, WEAR_IN_BACK)
		if(8 to 9)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/combat/covert, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest, WEAR_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/large/buckshot, WEAR_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
		if(10)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1/tactical, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest, WEAR_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1, WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/contractor/covert/heavy
	name = "Military Contractor (Covert Machinegunner)"
	paygrade = "VAI-MG "
	role_comm_title = "MG"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "VAISO Automatic Rifleman"
	rank = JOB_CONTRACTOR_COVMG
	skills = /datum/skills/contractor/heavy
	faction = FACTION_MARINE

/datum/equipment_preset/contractor/covert/heavy/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/contractor/covert/heavy/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/contractor, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/ua_civvies, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/lmg, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/lmg, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/lmg, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/mar40/lmg/tactical, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911/socom, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/covert, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/helmet_nvg/marsoc, WEAR_IN_HELMET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/tactical, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_R_STORE)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/MRE,WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/lmg, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/lmg, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)


//*****************************************************************************************************/
/datum/equipment_preset/contractor/covert/engi
	name = "Military Contractor (Covert Engineer)"
	paygrade = "VAI-ENG "

	role_comm_title = "Eng"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "VAISO Engineering Specialist"
	rank = JOB_CONTRACTOR_COVENG
	skills = /datum/skills/contractor/engi
	faction = FACTION_MARINE

/datum/equipment_preset/contractor/covert/engi/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/contractor/covert/engi/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/wy_davisone, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest/tool_webbing, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/contractor, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/mar40/carbine/tactical, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/covert, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/helmet_nvg/marsoc, WEAR_IN_HELMET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding/superior, WEAR_EYES)
	//storage items
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40, WEAR_IN_R_STORE)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/large_stack, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/mini, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15, WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/contractor/covert/medic
	name = "Military Contractor (Covert Medic)"
	paygrade = "VAI-MED "
	role_comm_title = "Med"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "VAIMS Medical Specialist"
	rank = JOB_CONTRACTOR_COVMED
	skills = /datum/skills/contractor/medic
	faction = FACTION_MARINE

/datum/equipment_preset/contractor/covert/medic/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/contractor/covert/medic/load_gear(mob/living/carbon/human/H)
	//clothing
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/wy_davisone, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/contractor, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/surg_vest/equipped, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/covert, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/helmet_nvg/marsoc, WEAR_IN_HELMET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/mar40/carbine/tactical, WEAR_J_STORE)
	//storage items
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch, WEAR_WAIST)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK) //Line in vest.
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/contractor/covert/leader
	name = "Military Contractor (Covert Leader)"
	paygrade = "VAI-TL "
	role_comm_title = "TL"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "VAISO Team Leader"
	rank = JOB_CONTRACTOR_COVTL
	skills = /datum/skills/contractor/leader
	faction = FACTION_MARINE

/datum/equipment_preset/contractor/covert/leader/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/contractor/covert/leader/load_gear(mob/living/carbon/human/H)
	//clothes
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/contractor, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/ua_civvies, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1/tactical, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911/socom, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/covert, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/helmet_nvg/marsoc, WEAR_IN_HELMET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/sensor, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_R_STORE)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments, WEAR_IN_BACK)

//*****************************************************************************************************/
/datum/equipment_preset/contractor/covert/synth
	name = "Military Contractor (Covert Synthetic)"
	paygrade = "VAI-SYN "
	role_comm_title = "Syn"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "VAISO Support Synthetic"
	rank = JOB_CONTRACTOR_COVSYN
	skills = /datum/skills/synthetic
	faction = FACTION_MARINE

/datum/equipment_preset/contractor/covert/synth/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(50;MALE,50;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(first_names_male)]"
	else
		random_name = "[pick(first_names_female)]"

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
	idtype = /obj/item/card/id/data

/datum/equipment_preset/contractor/covert/synth/load_race(mob/living/carbon/human/H)
	H.set_species(SYNTH_GEN_THREE)

/datum/equipment_preset/contractor/covert/synth/load_gear(mob/living/carbon/human/H)
	load_name(H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/smartpack/black, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK) //1
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK) //2
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/contractor, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/experimental_mesons, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/covert, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/helmet_nvg/cosmetic, WEAR_IN_HELMET)
	//body
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/wy_davisone, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/surg_vest/equipped, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/synvest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/telebaton, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full/dutch, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/twohanded/breacher, WEAR_L_HAND)
	//póckets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full_barbed_wire, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/screwdriver/tactical, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/wirecutters/tactical, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/wrench, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/stack/cable_coil, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/stack/cable_coil, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/multitool, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/weldingtool/hugetank, WEAR_IN_R_STORE)
