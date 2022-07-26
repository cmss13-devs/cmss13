/datum/equipment_preset/contractor
	name = "Military Contractor"

	assignment = "VASC Mercenary"
	rank = "Mercenary"
	idtype = /obj/item/card/id/DATA
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

/datum/equipment_preset/contractor/duty
	name = "Military Contractor (Standard)"
	paygrade = "VASC Mercenary"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "VASC Mercenary"
	rank = "Mercenary"
	skills = /datum/skills/contractor
	faction = FACTION_MARINE

/datum/equipment_preset/contractor/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/contractor/duty/load_gear(mob/living/carbon/human/H)
	//TODO: add unique backpacks and satchels
	//clothes
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/highcom, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/gray_blu, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/accessory/health/ceramic_plate, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/accessory/holobadge_cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/mar40/tactical, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911/socom, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15/rubber, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15/rubber, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/MRE,WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/contractor/duty/heavy
	name = "Military Contractor (Machinegunner)"
	paygrade = "VASC Mercenary Machinegunner"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "VASC Machinegunner"
	rank = "Mercenary"
	skills = /datum/skills/contractor/heavy
	faction = FACTION_MARINE

/datum/equipment_preset/contractor/duty/heavy/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/contractor/duty/heavy/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/highcom, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/gray_blu, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/accessory/health/ceramic_plate, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/accessory/holobadge_cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new obj/weapon/gun/rifle/mar40/lmg/tactical, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911/socom, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/c4, WEAR_R_STORE)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/MRE,WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/obj/item/attachable/magnetic_harness, WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/obj/ammo_magazine/rifle/mar40/lmg, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/obj/ammo_magazine/rifle/mar40/lmg, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/obj/ammo_magazine/rifle/mar40/lmg, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/obj/ammo_magazine/rifle/mar40/lmg, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/obj/ammo_magazine/rifle/mar40/lmg, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)


//*****************************************************************************************************/
/datum/equipment_preset/contractor/duty/engi
	name = "Military Contractor (Engineer)"
	paygrade = "VASC Mercenary Engineer"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "VASC Engineering Specialist"
	rank = "Mercenary"
	skills = /datum/skills/mercenary/elite/engineer
	faction = FACTION_MARINE

/datum/equipment_preset/contractor/duty/engi/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/contractor/duty/engi/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/gray_blu, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/black_vest/tool_webbing, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/accessory/holobadge_cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/accessory/health/ceramic_plate, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/highcom, WEAR_L_EAR)
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
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/large_stack, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/mini, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15, WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/contractor/duty/medic
	name = "Military Contractor (Medic)"
	paygrade = "VASC Mercenary Medic"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "VASC Medical Specialist"
	rank = "Mercenary"
	skills = /datum/skills/contractor/medic
	faction = FACTION_MARINE

/datum/equipment_preset/contractor/duty/medic/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/contractor/duty/medic/load_gear(mob/living/carbon/human/H)
	//clothing
	H.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/w_br, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/highcom, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/accessory/storage/surg_vest/equipped, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/accessory/holobadge_cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/accessory/health/ceramic_plate, WEAR_ACCESSORY)
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
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_L_STORE)
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
	paygrade = "VASC Mercenary Leader"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "VASC Team Leader"
	rank = "Mercenary"
	skills = /datum/skills/contractor/duty/leader
	faction = FACTION_MERCENARY

/datum/equipment_preset/contractor/duty/leader/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/contractor/duty/leader/load_gear(mob/living/carbon/human/H)
	//clothes
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/highcom, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/r_bla, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/accessory/health/ceramic_plate, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/accessory/holobadge_cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1/tactical, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/grenade/large/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1, WEAR_IN_R_STORE)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector/m717, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments, WEAR_IN_BACK)

//*****************************************************************************************************/
/datum/equipment_preset/contractor/duty/synth
	name = "Military Contractor (Synthetic)"
	paygrade = "VASC Synthetic"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "VASC Support Synthetic"
	rank = "Mercenary"
	skills = /datum/skills/synthetic
	faction = FACTION_MERCENARY

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
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK) //1
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK) //2
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK) //2.33
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/telebaton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/box/packet/smoke, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/highcom, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/experimental_mesons, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine, WEAR_HEAD)
	//body
	H.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/r_bla, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/accessory/storage/surg_vest/equipped, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/accessory/holobadge_cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/accessory/health/ceramic_plate, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/synvest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator, WEAR_IN_JACKET)
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

/datum/equipment_preset/contractor/duty
	name = "Covert Military Contractor (Standard)"
	uses_special_name = TRUE
	paygrade = "VASC Covert Mercenary"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "VASC Covert Mercenary"
	rank = "Mercenary"
	skills = /datum/skills/contractor
	faction = FACTION_MARINE

/datum/equipment_preset/contractor/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/contractor/duty/load_gear(mob/living/carbon/human/H)
	//TODO: add unique backpacks and satchels
	//clothes
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/highcom, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/ua_civvies, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/accessory/health/ceramic_plate, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/accessory/holobadge_cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/mar40/tactical, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911/socom, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15/rubber, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/m15/rubber, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/MRE,WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)

//*****************************************************************************************************/

	/datum/equipment_preset/contractor/duty/medic
	name = "Covert Military Contractor (Medic)"
	paygrade = "VASC Covert Mercenary Medic"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "VASC Covert Medical Specialist"
	rank = "Mercenary"
	skills = /datum/skills/contractor/medic
	faction = FACTION_MARINE

/datum/equipment_preset/contractor/duty/medic/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/contractor/duty/medic/load_gear(mob/living/carbon/human/H)
	//clothing
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/wy_davisone, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/highcom, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/accessory/storage/surg_vest/equipped, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/accessory/holobadge_cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/accessory/health/ceramic_plate, WEAR_ACCESSORY)
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
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_L_STORE)
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
