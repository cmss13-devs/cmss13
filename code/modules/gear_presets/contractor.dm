/datum/equipment_preset/contractor
	name = "Elite Mercenary"

	assignment = "Elite Mercenary"
	rank = "Mercenary"
	idtype = /obj/item/card/id/centcom
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
	name = "Military Contractor Mercenary"
	paygrade = "Elite Freelancer Standard"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/centcom
	assignment = "Mercenary Miner"
	rank = "Mercenary"
	skills = /datum/skills/contractor
	faction = FACTION_MARINE

/datum/equipment_preset/contractor/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/other/elite_merc/standard/load_gear(mob/living/carbon/human/H)
	//TODO: add unique backpacks and satchels
	//clothes
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/highcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/gray_blu, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/mar40, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40/extended, WEAR_IN_R_STORE)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
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

/datum/equipment_preset/other/elite_merc/heavy
	name = "Military Contractor (Machinegunner)"
	paygrade = "Elite Freelancer Heavy"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/centcom
	assignment = "Mercenary Heavy"
	rank = "Mercenary"
	skills = /datum/skills/mercenary/elite/heavy
	faction = FACTION_MERCENARY

/datum/equipment_preset/other/elite_merc/heavy/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/other/elite_merc/standard/load_gear(mob/living/carbon/human/H)
	//TODO: add unique backpacks and satchels
	//clothes
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/highcom(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/gray_blu, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light/vest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/mar40/lmg, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/c4, WEAR_R_STORE)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/MRE,WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/obj/item/tool/crowbar/tactical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/obj/item/attachable/magnetic_harness, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/obj/ammo_magazine/rifle/mar40/lmg, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/obj/ammo_magazine/rifle/mar40/lmg, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/obj/ammo_magazine/rifle/mar40/lmg, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/obj/ammo_magazine/rifle/mar40/lmg, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/obj/ammo_magazine/rifle/mar40/lmg, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)


//*****************************************************************************************************/
/datum/equipment_preset/other/elite_merc/engineer
	name = "Elite Mercenary (Engineer)"
	paygrade = "Elite Freelancer Engineer"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "Mercenary Engineer"
	rank = "Mercenary"
	skills = /datum/skills/mercenary/elite/engineer
	faction = FACTION_MERCENARY

/datum/equipment_preset/other/elite_merc/engineer/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/other/elite_merc/engineer/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	//snowflake webbing
	var/obj/item/clothing/under/marine/veteran/mercenary/support/SUPPORT = new()
	var/obj/item/clothing/accessory/storage/black_vest/W = new()
	SUPPORT.attach_accessory(H, W)
	W.hold.storage_slots = 7
	H.equip_to_slot_or_del(SUPPORT, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/bicaridine, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/bicaridine, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/kelotane, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/kelotane, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/tramadol, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/tramadol, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/emergency, WEAR_IN_ACCESSORY)
	//clothes
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary/support, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary/support/engineer, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles, WEAR_EYES)
	//storage items
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked/elite_merc, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/large, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical/full, WEAR_R_STORE)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/large_stack, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/mini, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/mini, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)
	//gun
	spawn_merc_elite_weapon(H, 9, 100, 0) //only shotguns

//*****************************************************************************************************/

/datum/equipment_preset/other/elite_merc/medic
	name = "Elite Mercenary (Medic)"
	paygrade = "Elite Freelancer Medic"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/centcom
	assignment = "Mercenary Medic"
	rank = "Mercenary"
	skills = /datum/skills/mercenary/elite/medic
	faction = FACTION_MERCENARY

/datum/equipment_preset/other/elite_merc/medic/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/other/elite_merc/medic/load_gear(mob/living/carbon/human/H)
	//webbing
	var/obj/item/clothing/under/marine/veteran/mercenary/support/SUPPORT = new()
	var/obj/item/clothing/accessory/storage/surg_vest/equipped/W = new()
	SUPPORT.attach_accessory(H, W)
	H.equip_to_slot_or_del(SUPPORT, WEAR_BODY)
	//clothing
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/medhud, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary/support, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary/support, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary/support, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)
	//storage items
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK) //Line in vest.
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)
	//gun
	spawn_merc_elite_weapon(H, 7, 0, 0) //no shotguns

//*****************************************************************************************************/

/datum/equipment_preset/other/elite_merc/leader
	name = "Elite Mercenary (Leader)"
	paygrade = "Elite Freelancer Leader"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/centcom
	assignment = "Mercenary Warlord"
	rank = "Mercenary"
	skills = /datum/skills/mercenary/elite/leader
	faction = FACTION_MERCENARY

/datum/equipment_preset/other/elite_merc/leader/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/other/elite_merc/leader/load_gear(mob/living/carbon/human/H)
	//clothes
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/medhud, WEAR_EYES)
	//storage items
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_R_STORE)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/m15, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/phosphorus/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked/elite_merc, WEAR_IN_BACK)
	//gun
	spawn_merc_elite_weapon(H, 7, 25, 1) //lower shotgun chance, but not zero
