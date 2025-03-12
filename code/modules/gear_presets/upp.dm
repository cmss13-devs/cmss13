/obj/effect/landmark/start/upp
	name = "UPP start join"
	icon_state = "base_upp"
	job_list = UPP_JOB_LIST

/obj/effect/landmark/late_join/upp
	name = "UPP late join"
	icon_state = "late_join_upp"
	job_list = UPP_JOB_LIST

/datum/job/antag/upp // Abstract type (null title)
	allow_additional = TRUE
	selection_class = "job_synth" //setup colour
	total_positions = 1
	spawn_positions = 1
	allow_additional = TRUE
	late_joinable = TRUE
	scaled = FALSE
	faction_menu = FACTION_UPP
	minimum_playtime_as_job = 0

	gear_preset = /datum/equipment_preset/upp/soldier

/datum/equipment_preset/upp
	name = FACTION_UPP
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_ENGLISH, LANGUAGE_CHINESE)
	faction = FACTION_UPP
	idtype = /obj/item/card/id/dogtag/upp
	minimap_background = "background_upp"
	origin_override = ORIGIN_UPP
	paygrades = list(PAY_SHORT_UE1 = JOB_PLAYTIME_TIER_0, PAY_SHORT_UE2 = JOB_PLAYTIME_TIER_1)

/datum/equipment_preset/upp/New()
	. = ..()
	access = get_access(ACCESS_LIST_UPP_ALL) //ACCESS_COME_BACK_TO_ME
/datum/equipment_preset/upp
	flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/upp/load_gear(mob/living/carbon/human/new_human)
	.=..()
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)

/datum/equipment_preset/upp/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(60;MALE,40;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(new_human)
	var/random_name
	var/first_name
	var/last_name
	//gender checks
	if(new_human.gender == MALE)
		if(prob(40))
			first_name = "[capitalize(randomly_generate_chinese_word(1))]"
		else
			first_name = "[pick(GLOB.first_names_male_upp)]"
		new_human.f_style = pick("3 O'clock Shadow", "3 O'clock Moustache", "5 O'clock Shadow", "5 O'clock Moustache")
	else
		if(prob(40))
			first_name = "[capitalize(randomly_generate_chinese_word(1))]"
		else
			first_name = "[pick(GLOB.first_names_female_upp)]"
	//surname
	if(prob(35))
		last_name = "[capitalize(randomly_generate_chinese_word(pick(20;1, 80;2)))]"
	else
		last_name = "[pick(GLOB.last_names_upp)]"
	//put them together
	random_name = "[first_name] [last_name]"

	new_human.change_real_name(new_human, random_name)
	new_human.age = rand(17,35)
	new_human.h_style = pick("Crewcut", "Shaved Head", "Buzzcut", "Undercut", "Side Undercut", "Bun, Topknot")
	var/static/list/colors = list("BLACK" = list(15, 15, 25), "BROWN" = list(102, 51, 0), "AUBURN" = list(139, 62, 19))
	var/static/list/hair_colors = colors.Copy() + list("BLONDE" = list(197, 164, 30), "CARROT" = list(174, 69, 42))
	var/hair_color = pick(hair_colors)
	new_human.r_hair = hair_colors[hair_color][1]
	new_human.g_hair = hair_colors[hair_color][2]
	new_human.b_hair = hair_colors[hair_color][3]
	new_human.r_facial = hair_colors[hair_color][1]
	new_human.g_facial = hair_colors[hair_color][2]
	new_human.b_facial = hair_colors[hair_color][3]
	var/eye_color = pick(colors)
	new_human.r_eyes = colors[eye_color][1]
	new_human.g_eyes = colors[eye_color][2]
	new_human.b_eyes = colors[eye_color][3]
	idtype = /obj/item/card/id/dogtag/upp

//*****************************************************************************************************/
//=====================//
//  Frontline Roles  //
//=================//

/datum/job/antag/upp/rifleman
	title = JOB_UPP
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/upp/soldier

/datum/equipment_preset/upp/soldier
	name = "UPP Soldier (Cryo)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	skills = /datum/skills/pfc
	assignment = JOB_UPP
	rank = JOB_UPP
	role_comm_title = "Sol"
	minimap_icon = "upp_pvt"
	paygrades = list(PAY_SHORT_UE1 = JOB_PLAYTIME_TIER_0, PAY_SHORT_UE2 = JOB_PLAYTIME_TIER_1)
	access = list(
		ACCESS_UPP_GENERAL,
	)

/datum/equipment_preset/upp/soldier/dressed
	name = "UPP Soldier"
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/upp
	access = ACCESS_LIST_UPP_ALL

/datum/equipment_preset/upp/soldier/dressed/load_gear(mob/living/carbon/human/new_human)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

	load_upp_soldier(new_human, UPP)

/datum/equipment_preset/upp/soldier/proc/load_upp_soldier(mob/living/carbon/human/new_human, obj/item/clothing/under/marine/veteran/UPP/UPP)
	var/percentage = rand(1, 100)
	switch(percentage)
		//most UPP are rifleman, most others are breachers, some have both primaries.
		if(1 to 66)
			load_upp_rifleman(new_human, UPP)
		if(67 to 85)
			load_upp_breacher(new_human, UPP)
		else
			load_upp_double(new_human, UPP)

/datum/equipment_preset/upp/soldier/proc/load_upp_rifleman(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK) //.75
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_BACK) //1.5
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/m94, WEAR_IN_BACK) //2.25
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/m94, WEAR_IN_BACK) //3.25
	//body
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/rifleman, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp/full, WEAR_WAIST)
	//rpocket
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/upp, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/upp, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/upp, WEAR_IN_R_STORE)
	//lpocket
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)

/datum/equipment_preset/upp/soldier/proc/load_upp_breacher(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK) //.75
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_BACK) //1.5
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/m94, WEAR_IN_BACK) //2.25
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/m94, WEAR_IN_BACK) //3.25
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/np92, WEAR_WAIST)
	load_upp_shotgun(new_human)


/datum/equipment_preset/upp/soldier/proc/load_upp_double(mob/living/carbon/human/new_human, obj/item/clothing/under/marine/veteran/UPP/UPP)
	//back
	var/rifle = prob(50) ? /obj/item/weapon/gun/rifle/type71/dual : /obj/item/weapon/gun/rifle/type71/carbine/dual
	new_human.equip_to_slot_or_del(new rifle, WEAR_BACK)
	//body
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/type23/dual, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp/full, WEAR_WAIST)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/heavybuck, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)

/datum/equipment_preset/upp/soldier/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Standard Apparel", 0, list (/obj/item/clothing/under/marine/veteran/UPP, /obj/item/clothing/shoes/marine/upp/knife, /obj/item/clothing/gloves/marine/veteran/upp, /obj/item/device/radio/headset/distress/UPP), MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Map", 0, /obj/item/map/current_map, MARINE_CAN_BUY_KIT, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("ARMOR", 0, null, null, null),
		list("UM5 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("UL6 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/support, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Ushanka", 0, /obj/item/clothing/head/uppcap/ushanka, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("HELMET OPTICS", 0, null, null, null),
		list("Medical Helmet Optic", 15, /obj/item/device/helmet_visor/medical, null, VENDOR_ITEM_REGULAR),
		list("Welding Visor", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Type 42 pattern shotgun shell loading rig", 0, /obj/item/storage/belt/shotgun/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Type 47 pistol holster rig", 0, /obj/item/storage/belt/gun/type47, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Type 46 pattern Type 6/8 Grenade rig", 0, /obj/item/storage/belt/grenade/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 10, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Webbing", 10, /obj/item/clothing/accessory/storage/webbing/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 10, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("E-Tool", 5, /obj/item/tool/shovel/etool/folded, null, VENDOR_ITEM_REGULAR),
		list("Sandbags", 20, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_REGULAR),
		list("ES-11 Mobile Fuel Canister", 5, /obj/item/tool/weldpack/minitank, null, VENDOR_ITEM_REGULAR),
		list("ME3 Hand Welder", 5, /obj/item/tool/weldingtool/simple, null, VENDOR_ITEM_REGULAR),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Smoke Grenade Packet", 10, /obj/item/storage/box/packet/smoke, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade Packet", 20, /obj/item/storage/box/packet/high_explosive/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade Packet", 20, /obj/item/storage/box/packet/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 15, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),

		list("BINOCULARS", 0, null, null, null),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),

		list("PAMPHLETS", 0, null, null, null),
		list("JTAC Pamphlet", 15, /obj/item/pamphlet/skill/jtac, null, VENDOR_ITEM_REGULAR),
		list("Engineering Pamphlet", 15, /obj/item/pamphlet/skill/engineer, null, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/upp/soldier/get_antag_gear_equipment()
	return list(

	)

//*****************************************************************************************************/


/datum/job/antag/upp/medic
	title = JOB_UPP_MEDIC
	gear_preset = /datum/equipment_preset/upp/medic
	flags_startup_parameters = ROLE_ADD_TO_SQUAD


/datum/equipment_preset/upp/medic
	name = "UPP Medic (Cryo)"

	skills = /datum/skills/combat_medic
	assignment = JOB_UPP_MEDIC
	rank = JOB_UPP_MEDIC
	role_comm_title = "Med"
	minimap_icon = "upp_med"
	paygrades = list(PAY_SHORT_UE3 = JOB_PLAYTIME_TIER_0)
	access = list(
		ACCESS_UPP_GENERAL,
		ACCESS_UPP_MEDICAL,
	)

/datum/equipment_preset/upp/medic/dressed
	name = "UPP Medic"

	skills = /datum/skills/upp/combat_medic
	flags = EQUIPMENT_PRESET_EXTRA
	access = ACCESS_LIST_UPP_ALL

/datum/equipment_preset/upp/medic/dressed/load_gear(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/compact, WEAR_IN_BACK) //1
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK) //2
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK) //2.33
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK) //3
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/medic, WEAR_L_EAR)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap, WEAR_HEAD)
	//body
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/medic, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/support, WEAR_JACKET) //medic should move fast
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/bizon/upp, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	//póckets
	var/obj/item/storage/pouch/magazine/large/ppouch = new()
	new_human.equip_to_slot_or_del(ppouch, WEAR_R_STORE)
	for(var/i = 1 to ppouch.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/bizon, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/tricordrazine, WEAR_IN_L_STORE)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

/datum/equipment_preset/upp/medic/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Standard Apparel", 0, list (/obj/item/clothing/under/marine/veteran/UPP/medic, /obj/item/clothing/shoes/marine/upp/knife, /obj/item/clothing/gloves/marine/veteran/upp, /obj/item/device/radio/headset/distress/UPP/medic), MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Map", 0, /obj/item/map/current_map, MARINE_CAN_BUY_KIT, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("MEDICAL OPTICS", 0, null, null, null),
		list("HealthMate HUD", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Advanced Medical Visor", 0, /obj/item/device/helmet_visor/medical/advanced, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("ARMOR", 0, null, null, null),
		list("UM5 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("UL6 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/support, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Ushanka", 0, /obj/item/clothing/head/uppcap/ushanka, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BELT", 0, null, null, null),
		list("Type 41 Lifesaver Bag", 0, /obj/item/storage/belt/medical/lifesaver/upp/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Type 42 pattern shotgun shell loading rig", 0, /obj/item/storage/belt/shotgun/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Type 47 pistol holster rig", 0, /obj/item/storage/belt/gun/type47, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Type 46 pattern Type 6/8 Grenade rig", 0, /obj/item/storage/belt/grenade/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch (Full)", 0, /obj/item/storage/pouch/autoinjector/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Peridaxon)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_peri, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Bicaridine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Kelotane)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Vial Pouch (Full)", 0, /obj/item/storage/pouch/vials/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("HELMET OPTICS", 0, null, null, null),
		list("Medical Helmet Optic", 12, /obj/item/device/helmet_visor/medical, null, VENDOR_ITEM_REGULAR),
		list("Welding Visor", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_REGULAR),

		list("PAMPHLETS", 0, null, null, null),
		list("JTAC Pamphlet", 15, /obj/item/pamphlet/skill/jtac, null, VENDOR_ITEM_REGULAR),
		list("Engineering Pamphlet", 15, /obj/item/pamphlet/skill/engineer, null, VENDOR_ITEM_REGULAR),

	)

/datum/equipment_preset/upp/medic/get_antag_gear_equipment()
	return list(
		list("MEDIC SET (MANDATORY)", 0, null, null, null),
		list("Essential Medic Set", 0, /obj/effect/essentials_set/medic/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("FIELD SUPPLIES", 0, null, null, null),
		list("Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_RECOMMENDED),
		list("Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_RECOMMENDED),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_RECOMMENDED),
		list("Blood Bag (O-)", 4, /obj/item/reagent_container/blood/OMinus, null, VENDOR_ITEM_REGULAR),

		list("FIRSTAID KITS", 0, null, null, null),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_RECOMMENDED),
		list("Firstaid Kit", 5, /obj/item/storage/firstaid/regular/response, null, VENDOR_ITEM_REGULAR),
		list("Fire Firstaid Kit", 6, /obj/item/storage/firstaid/fire, null, VENDOR_ITEM_REGULAR),
		list("Toxin Firstaid Kit", 6, /obj/item/storage/firstaid/toxin, null, VENDOR_ITEM_REGULAR),
		list("Oxygen Firstaid Kit", 6, /obj/item/storage/firstaid/o2, null, VENDOR_ITEM_REGULAR),
		list("Radiation Firstaid Kit", 6, /obj/item/storage/firstaid/rad, null, VENDOR_ITEM_REGULAR),

		list("AUTOINJECTORS", 0, null, null, null),
		list("Autoinjector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Epinephrine)", 2, /obj/item/reagent_container/hypospray/autoinjector/adrenaline, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("PILL BOTTLES", 0, null, null, null),
		list("Pill Bottle (Bicaridine)", 5, /obj/item/storage/pill_bottle/bicaridine, null, VENDOR_ITEM_RECOMMENDED),
		list("Pill Bottle (Dexalin)", 5, /obj/item/storage/pill_bottle/dexalin, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Dylovene)", 5, /obj/item/storage/pill_bottle/antitox, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Inaprovaline)", 5, /obj/item/storage/pill_bottle/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Kelotane)", 5, /obj/item/storage/pill_bottle/kelotane, null, VENDOR_ITEM_RECOMMENDED),
		list("Pill Bottle (Peridaxon)", 5, /obj/item/storage/pill_bottle/peridaxon, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Tramadol)", 5, /obj/item/storage/pill_bottle/tramadol, null, VENDOR_ITEM_RECOMMENDED),

		list("MEDICAL UTILITIES", 0, null, null, null),
		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_REGULAR),
		list("MS-11 Smart Refill Tank", 6, /obj/item/reagent_container/glass/minitank, null, VENDOR_ITEM_REGULAR),
		list("FixOVein", 7, /obj/item/tool/surgery/FixOVein, null, VENDOR_ITEM_REGULAR),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Stasis Bag", 6, /obj/item/bodybag/cryobag, null, VENDOR_ITEM_REGULAR),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Smoke Grenade Packet", 10, /obj/item/storage/box/packet/smoke, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade Packet", 20, /obj/item/storage/box/packet/high_explosive/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade Packet", 20, /obj/item/storage/box/packet/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

		list("BINOCULARS", 0, null, null, null),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Fire Extinguisher (Portable)", 3, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("UPP Motion Detector", 15, /obj/item/device/motiondetector/hacked, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 3, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 15, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
	)

//*****************************************************************************************************/
/datum/job/antag/upp/sapper
	title = JOB_UPP_ENGI
	gear_preset = /datum/equipment_preset/upp/sapper
	flags_startup_parameters = ROLE_ADD_TO_SQUAD

/datum/equipment_preset/upp/sapper
	name = "UPP Sapper (Cryo)"

	skills = /datum/skills/combat_engineer
	assignment = JOB_UPP_ENGI
	rank = JOB_UPP_ENGI
	role_comm_title = "Sap"
	minimap_icon = "upp_sapper"
	paygrades = list(PAY_SHORT_UE3 = JOB_PLAYTIME_TIER_0)
	access = list(
		ACCESS_UPP_GENERAL,
		ACCESS_UPP_ENGINEERING,
	)

/datum/equipment_preset/upp/sapper/dressed
	name = "UPP Sapper"

	skills = /datum/skills/upp/combat_engineer
	flags = EQUIPMENT_PRESET_EXTRA
	access = ACCESS_LIST_UPP_ALL

/datum/equipment_preset/upp/sapper/dressed/load_gear(mob/living/carbon/human/new_human)
	//Sappers should have lots of gear and whatnot that helps them attack or siege marines
	//But that'll need a lot of effort so for now they are just soldiers with a toolbox.
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK) //.33
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked, WEAR_IN_BACK) //.66
	new_human.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/upp/light, WEAR_IN_BACK) //1.66
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/cct, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas, WEAR_FACE)
	//head
	var/headgear = prob(70) ? /obj/item/clothing/head/helmet/marine/veteran/UPP/engi : /obj/item/clothing/head/uppcap/ushanka
	new_human.equip_to_slot_or_del(new headgear, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/engi/UPP = new()
	var/obj/item/clothing/accessory/storage/tool_webbing/equipped/W = new()
	UPP.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/sapper, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp/sapper(new_human), WEAR_WAIST)
	//limb
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(new_human), WEAR_R_STORE)

/datum/equipment_preset/upp/sapper/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Standard Apparel", 0, list(/obj/item/clothing/under/marine/veteran/UPP/engi, /obj/item/clothing/shoes/marine/upp/knife, /obj/item/clothing/gloves/yellow, /obj/item/device/radio/headset/distress/UPP/cct), MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Map", 0, /obj/item/map/current_map, MARINE_CAN_BUY_KIT, VENDOR_ITEM_MANDATORY),
		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Welderpack", 0, /obj/item/storage/backpack/marine/engineerpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("WELDING PROTECTION (CHOOSE 1)", 0, null, null, null),
		list("Welding Goggles", 0, /obj/item/clothing/glasses/welding, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
		list("Welding Helmet", 0, /obj/item/clothing/head/welding, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("ARMOR", 0, null, null, null),
		list("UM5 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("UL6 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/support, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Ushanka", 0, /obj/item/clothing/head/uppcap/ushanka, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BELT (Choose 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 41 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M277 Pattern Construction Rig", 0, /obj/item/storage/belt/utility/construction, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Type 46 pattern Type 6/8 Grenade rig", 0, /obj/item/storage/belt/grenade/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (Choose 2)", 0, null, null, null),
		list("Construction Pouch", 0, /obj/item/storage/pouch/construction, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Electronics Pouch (Full)", 0, /obj/item/storage/pouch/electronics/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Engineer kit Pouch", 0, /obj/item/storage/pouch/engikit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/upp/sapper/get_antag_gear_equipment()
	return list(
		list("SAPPER SET (MANDATORY)", 0, null, null, null),
		list("Essential Sapper Set", 0, /obj/effect/essentials_set/engi, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("HANDHELD DEFENSE (CHOOSE 1)", 0, null, null, null),
		list("UPP Planted Flag", 0, /obj/item/defenses/handheld/planted_flag/upp, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),
		list("UPP SDS-R5 Sentry Flamer", 0, /obj/item/defenses/handheld/sentry/flamer/upp, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),
		list("UPP SDS-R3 Sentry Gun", 0, /obj/item/defenses/handheld/sentry/upp, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Airlock Circuit Board", 2, /obj/item/circuitboard/airlock, null, VENDOR_ITEM_REGULAR),
		list("APC Circuit Board", 2, /obj/item/circuitboard/apc, null, VENDOR_ITEM_REGULAR),
		list("Entrenching Tool (ET)", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("High-Capacity Power Cell", 3, /obj/item/cell/high, null, VENDOR_ITEM_REGULAR),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Plastic Explosive", 3, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Breaching Charge", 5, /obj/item/explosive/plastic/breaching_charge, null, VENDOR_ITEM_RECOMMENDED),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),
		list("Super-Capacity Power Cell", 10, /obj/item/cell/super, null, VENDOR_ITEM_REGULAR),
		list("ES-11 Mobile Fuel Canister", 4, /obj/item/tool/weldpack/minitank, null, VENDOR_ITEM_REGULAR),
		list("Synthetic Reset Key", 10, /obj/item/device/defibrillator/synthetic/hyperdyne, null, VENDOR_ITEM_REGULAR),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_RECOMMENDED),
		list("Breaching Charge", 10, /obj/item/explosive/plastic/breaching_charge, null, VENDOR_ITEM_RECOMMENDED),
		list("Smoke Grenade Packet", 10, /obj/item/storage/box/packet/smoke, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade Packet", 20, /obj/item/storage/box/packet/high_explosive/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade Packet", 20, /obj/item/storage/box/packet/phosphorus/upp, null, VENDOR_ITEM_REGULAR),
		list("M40 MFHS Metal Foam Grenade", 5, /obj/item/explosive/grenade/metal_foam, null, VENDOR_ITEM_REGULAR),

		list("BINOCULARS", 0, null, null, null),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 3, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 15, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),

		list("PAMPHLETS", 0, null, null, null),
		list("JTAC Pamphlet", 15, /obj/item/pamphlet/skill/jtac, null, VENDOR_ITEM_REGULAR),
		list("Powerloader Pamphlet", 30, /obj/item/pamphlet/skill/powerloader, null, VENDOR_ITEM_REGULAR),

		list("HELMET OPTICS", 0, null, null, null),
		list("Medical Helmet Optic", 12, /obj/item/device/helmet_visor/medical, null, VENDOR_ITEM_REGULAR),
		list("Welding Visor", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_REGULAR),
	)

//*****************************************************************************************************/

/datum/equipment_preset/upp/specialist
	name = "UPP Specialist minigun (Cryo)"

	skills = /datum/skills/upp/specialist
	assignment = JOB_UPP_SPECIALIST
	rank = JOB_UPP_SPECIALIST
	role_comm_title = "Spc"
	minimap_icon = "upp_spec"
	paygrades = list(PAY_SHORT_UE5 = JOB_PLAYTIME_TIER_0)
	access = list(
		ACCESS_UPP_GENERAL,
	)

/datum/equipment_preset/upp/specialist/dressed
	name = "UPP Specialist"
	flags = EQUIPMENT_PRESET_EXTRA
	access = ACCESS_LIST_UPP_ALL


/datum/equipment_preset/upp/specialist/dressed/load_gear(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_BACK) //1
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK) //1.33
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/heavy, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, WEAR_JACKET)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

	var/obj/item/device/internal_implant/subdermal_armor/implant = new()
	implant.on_implanted(new_human)

	//body
	var/obj/item/clothing/accessory/storage/black_vest/W = new()
	UPP.attach_accessory(new_human, W)
	for(var/i in 1 to W.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/heavy/dragonsbreath, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/type23/dragon, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/heavy/dragonsbreath, WEAR_IN_JACKET)
	//waist
	var/uppvetsidearm = prob(50) ? /obj/item/storage/belt/gun/type47/t73 : /obj/item/storage/belt/gun/type47/np92
	new_human.equip_to_slot_or_del(new uppvetsidearm, WEAR_WAIST)

/datum/equipment_preset/upp/specialist/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Standard Apparel", 0, list (/obj/item/clothing/under/marine/veteran/UPP, /obj/item/clothing/shoes/marine/upp/knife, /obj/item/clothing/gloves/marine/veteran/upp, /obj/item/device/radio/headset/distress/UPP), MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("ARMOR", 0, null, null, null),
		list("UH7 Heavy Plated Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("UM7 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP/heavy, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Armored Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Ushanka", 0, /obj/item/clothing/head/uppcap/ushanka, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Type 42 pattern shotgun shell loading rig", 0, /obj/item/storage/belt/shotgun/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Type 47 pistol holster rig", 0, /obj/item/storage/belt/gun/type47, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 46 pattern Type 6/8 Grenade rig", 0, /obj/item/storage/belt/grenade/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Rebreather", 0, /obj/item/clothing/mask/rebreather, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/upp/specialist/get_antag_gear_equipment()
	return list(
		list("HEAVY SET (MANDATORY)", 0, null, null, null),
		list("Essential Heavy Set", 0, /obj/effect/essentials_set/upp_heavy, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Rotating ammo drum (7.62x51mm)", 15, /obj/item/ammo_magazine/minigun, null, VENDOR_ITEM_RECOMMENDED),

		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Breaching Charge", 10, /obj/item/explosive/plastic/breaching_charge, null, VENDOR_ITEM_RECOMMENDED),
		list("Smoke Grenade Packet", 10, /obj/item/storage/box/packet/smoke, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade Packet", 20, /obj/item/storage/box/packet/high_explosive/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade Packet", 20, /obj/item/storage/box/packet/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

		list("BINOCULARS", 0, null, null, null),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 3, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 3, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("UPP Motion Detector", 15, /obj/item/device/motiondetector/hacked, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),

		list("PAMPHLETS", 0, null, null, null),
		list("JTAC Pamphlet", 15, /obj/item/pamphlet/skill/jtac, null, VENDOR_ITEM_REGULAR),
		list("Engineering Pamphlet", 15, /obj/item/pamphlet/skill/engineer, null, VENDOR_ITEM_REGULAR),
	)

//*****************************************************************************************************/
/datum/job/antag/upp/machinegunner
	title = JOB_UPP_SPECIALIST
	gear_preset = /datum/equipment_preset/upp/machinegunner
	flags_startup_parameters = ROLE_ADD_TO_SQUAD

/datum/equipment_preset/upp/machinegunner
	name = "UPP Machinegunner (Cryo)"

	skills = /datum/skills/upp/specialist
	assignment = JOB_UPP_SPECIALIST
	rank = JOB_UPP_SPECIALIST
	role_comm_title = "Spc"
	minimap_icon = "upp_spec"
	paygrades = list(PAY_SHORT_UE5 = JOB_PLAYTIME_TIER_0)
	access = list(
		ACCESS_UPP_GENERAL,
	)

/datum/equipment_preset/upp/machinegunner/dressed
	name = "UPP Machinegunner"
	flags = EQUIPMENT_PRESET_EXTRA
	access = ACCESS_LIST_UPP_ALL


/datum/equipment_preset/upp/machinegunner/dressed/load_gear(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_BACK) //1
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK) //1.33
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/heavy, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, WEAR_JACKET)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

	var/obj/item/device/internal_implant/subdermal_armor/implant = new()
	implant.on_implanted(new_human)

	//body
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pkp, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pkp, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pkp, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pkp, WEAR_IN_JACKET)
	//waist
	var/uppvetsidearm = prob(50) ? /obj/item/storage/belt/gun/type47/t73 : /obj/item/storage/belt/gun/type47/np92
	new_human.equip_to_slot_or_del(new uppvetsidearm, WEAR_WAIST) // 50/50 np92 or t73

/datum/equipment_preset/upp/machinegunner/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Standard Apparel", 0, list (/obj/item/clothing/under/marine/veteran/UPP, /obj/item/clothing/shoes/marine/upp/knife, /obj/item/clothing/gloves/marine/veteran/upp, /obj/item/device/radio/headset/distress/UPP), MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("ARMOR", 0, null, null, null),
		list("UH7 Heavy Plated Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("UM7 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP/heavy, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Armored Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Ushanka", 0, /obj/item/clothing/head/uppcap/ushanka, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Type 42 pattern shotgun shell loading rig", 0, /obj/item/storage/belt/shotgun/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Type 47 pistol holster rig", 0, /obj/item/storage/belt/gun/type47, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 46 pattern Type 6/8 Grenade rig", 0, /obj/item/storage/belt/grenade/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Rebreather", 0, /obj/item/clothing/mask/rebreather, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/upp/machinegunner/get_antag_gear_equipment()
	return list(
		list("HEAVY SET (MANDATORY)", 0, null, null, null),
		list("Essential Heavy Set QYJ-72", 0, /obj/effect/essentials_set/upp_heavy_pkp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),
		list("M240 Incinerator Tank (Napthal)", 3, /obj/item/ammo_magazine/flamer_tank, null, VENDOR_ITEM_REGULAR),
		list("M240 Incinerator Tank (B-Gel)", 3, /obj/item/ammo_magazine/flamer_tank/gellied, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Breaching Charge", 10, /obj/item/explosive/plastic/breaching_charge, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade Packet", 10, /obj/item/storage/box/packet/smoke, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade Packet", 20, /obj/item/storage/box/packet/high_explosive/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade Packet", 20, /obj/item/storage/box/packet/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

		list("HELMET OPTICS", 0, null, null, null),
		list("Welding Visor", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_REGULAR),
		list("Medical Helmet Optic", 4, /obj/item/device/helmet_visor/medical, null, VENDOR_ITEM_RECOMMENDED),

		list("UTILITIES", 0, null, null, null),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 3, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("UPP Motion Detector", 8, /obj/item/device/motiondetector/hacked, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 3, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 5, /obj/item/storage/pouch/tools/full, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector Pouch (Full)", 15, /obj/item/storage/pouch/autoinjector/full, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 3, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", 5, /obj/item/storage/pouch/flamertank, null, VENDOR_ITEM_REGULAR),

		list("BINOCULARS", 0, null, null, null),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),

		list("PAMPHLETS", 0, null, null, null),
		list("JTAC Pamphlet", 15, /obj/item/pamphlet/skill/jtac, null, VENDOR_ITEM_REGULAR),
		list("Engineering Pamphlet", 15, /obj/item/pamphlet/skill/engineer, null, VENDOR_ITEM_REGULAR),

	)

//*****************************************************************************************************/
/datum/job/antag/upp/leader
	title = JOB_UPP_LEADER
	gear_preset = /datum/equipment_preset/upp/leader
	flags_startup_parameters = ROLE_ADD_TO_SQUAD

/datum/equipment_preset/upp/leader
	name = "UPP Squad Leader (Cryo)"

	skills = /datum/skills/SL
	assignment = JOB_UPP_LEADER
	rank = JOB_UPP_LEADER
	role_comm_title = "SL"
	minimap_icon = "upp_sl"
	paygrades = list(PAY_SHORT_UE6 = JOB_PLAYTIME_TIER_0)
	access = list(
		ACCESS_UPP_GENERAL,
		ACCESS_UPP_MEDICAL,
		ACCESS_UPP_ENGINEERING,
		ACCESS_UPP_FLIGHT,
		ACCESS_UPP_LEADERSHIP,
	)

/datum/equipment_preset/upp/leader/dressed
	name = "UPP Squad Leader"

	skills = /datum/skills/upp/SL
	flags = EQUIPMENT_PRESET_EXTRA
	access = ACCESS_LIST_UPP_ALL

/datum/equipment_preset/upp/leader/dressed/load_gear(mob/living/carbon/human/new_human)
	var/UPPleadsidearm = rand(1,4)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_BACK) //0.66
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK) //1.33
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK) //2
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK) //2.66
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK) //3.33
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_BACK) //4
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/command, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	UPP.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/t73, WEAR_WAIST)
	switch(UPPleadsidearm)
		if(1 to 2) // 50%
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/t73, WEAR_WAIST)
		if(3) //25%
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/np92, WEAR_WAIST)
		if(4) //25%
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/revolver, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flamertank, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

/datum/equipment_preset/upp/leader/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Standard Apparel", 0, list (/obj/item/clothing/under/marine/veteran/UPP, /obj/item/clothing/shoes/marine/upp/knife, /obj/item/clothing/gloves/marine/veteran/upp, /obj/item/device/radio/headset/distress/UPP/command), MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("ARMOR", 0, null, null, null),
		list("UH7 Heavy Plated Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Beret", 0, /obj/item/clothing/head/uppcap/beret, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Ushanka", 0, /obj/item/clothing/head/uppcap/ushanka, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Type 42 pattern shotgun shell loading rig", 0, /obj/item/storage/belt/shotgun/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Type 47 pistol holster rig", 0, /obj/item/storage/belt/gun/type47, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 46 pattern Type 6/8 Grenade rig", 0, /obj/item/storage/belt/grenade/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 41 Lifesaver Bag", 0, /obj/item/storage/belt/medical/lifesaver/upp/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M277 Pattern Construction Rig", 0, /obj/item/storage/belt/utility/construction, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch (Full)", 0, /obj/item/storage/pouch/autoinjector/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", 0, /obj/item/storage/pouch/flamertank, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Rebreather", 0, /obj/item/clothing/mask/rebreather, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/upp/leader/get_antag_gear_equipment()
	return list(
		list("SQUAD LEADER SET (MANDATORY)", 0, null, null, null),
		list("Essential SL Set", 0, /obj/effect/essentials_set/leader/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("SQUAD KIT (CHOOSE 1, for yourself or your squad)", 0, null, null, null),
		list("Type 71-F Weapon Kit", 0, /obj/item/storage/box/kit/UPP_leader_AR, MARINE_CAN_BUY_KIT, VENDOR_ITEM_RECOMMENDED),
		list("M240 Pyrotechnician Support Kit", 0, /obj/item/storage/box/kit/mini_pyro, MARINE_CAN_BUY_KIT, VENDOR_ITEM_REGULAR),
		list("Basic Engineering Supplies", 0, /obj/item/storage/box/kit/engineering_supply_kit, MARINE_CAN_BUY_KIT, VENDOR_ITEM_REGULAR),

		list("BINOCULARS", 0, null, null, null),
		list("Range Finder", 3, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 5, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),

		list("HELMET OPTICS", 0, null, null, null),
		list("Welding Visor", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_REGULAR),
		list("Medical Helmet Optic", 4, /obj/item/device/helmet_visor/medical, null, VENDOR_ITEM_RECOMMENDED),
		list("Night Vision Optic", 25, /obj/item/device/helmet_visor/night_vision, null, VENDOR_ITEM_RECOMMENDED),

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Insulated Gloves", 3, /obj/item/clothing/gloves/yellow, null, VENDOR_ITEM_REGULAR),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Plastic explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_RECOMMENDED),
		list("Breaching Charge", 7, /obj/item/explosive/plastic/breaching_charge, null, VENDOR_ITEM_RECOMMENDED),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),
		list("Signal Flare Pack", 7, /obj/item/storage/box/m94/signal, null, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 5, /obj/item/storage/pouch/tools/full, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 5, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),


		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),

		list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Roller Bed", 2, /obj/item/roller, null, VENDOR_ITEM_REGULAR),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),
		list("M240 Incinerator Tank (Napthal)", 3, /obj/item/ammo_magazine/flamer_tank, null, VENDOR_ITEM_REGULAR),
		list("M240 Incinerator Tank (B-Gel)", 3, /obj/item/ammo_magazine/flamer_tank/gellied, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Breaching Charge", 7, /obj/item/explosive/plastic/breaching_charge, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade Packet", 7, /obj/item/storage/box/packet/smoke, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade Packet", 18, /obj/item/storage/box/packet/high_explosive/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade Packet", 18, /obj/item/storage/box/packet/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("Zip cuffs", 1, /obj/item/storage/box/zipcuffs, null, VENDOR_ITEM_REGULAR),
		list("UPP Motion Detector", 15, /obj/item/device/motiondetector/hacked, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),

		list("BINOCULARS", 0, null, null, null),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),
	)
//*****************************************************************************************************/
//=====================//
//  Support Roles    //
//=================//

/datum/equipment_preset/upp/military_police
	name = "UPP Military Police (Cryo)"

	skills = /datum/skills/upp/military_police
	assignment = JOB_UPP_POLICE
	rank = JOB_UPP_POLICE
	role_comm_title = "MP"
	minimap_icon = "upp_mp"
	paygrades = list(PAY_SHORT_UE6 = JOB_PLAYTIME_TIER_0)
	access = list(
		ACCESS_UPP_GENERAL,
		ACCESS_UPP_MEDICAL,
		ACCESS_UPP_ENGINEERING,
		ACCESS_UPP_SECURITY,
		ACCESS_UPP_LEADERSHIP,
	)

/datum/job/antag/upp/military_police
	title = JOB_UPP_POLICE
	gear_preset = /datum/equipment_preset/upp/military_police
	selection_class = "job_mp"

/datum/equipment_preset/upp/military_police/load_gear(mob/living/carbon/human/new_human)
	. = ..()
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/mp, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	//ear
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)

/datum/equipment_preset/upp/military_police/dressed
	name = "UPP Military Police"
	flags = EQUIPMENT_PRESET_EXTRA
	access = ACCESS_LIST_UPP_ALL

/datum/equipment_preset/upp/military_police/dressed/load_gear(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/upp, WEAR_FACE)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/mp, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	//jacket
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/mp, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/revolver, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/UPP/full, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/taperecorder, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_R_STORE)

/datum/equipment_preset/upp/military_police/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP/mp, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("UL4 camouflaged jacket", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/mp, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/upp, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Binoculars", 0, /obj/item/device/binoculars, null, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Beret", 0, /obj/item/clothing/head/uppcap/beret, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Ushanka", 0, /obj/item/clothing/head/uppcap/ushanka, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("UL4 camouflaged jacket", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/mp, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("UL6 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/support, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 41 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 43 Military Police Rig", 0, /obj/item/storage/belt/security/MP/UPP/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas/pmc/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/upp/military_police/get_antag_gear_equipment()
	return list(
		list("SQUAD LEADER SET (MANDATORY)", 0, null, null, null),
		list("Essential MP Set", 0, /obj/effect/essentials_set/leader/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("GENERAL SUPPLIES", 0, null, null, null),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Insulated Gloves", 3, /obj/item/clothing/gloves/yellow, null, VENDOR_ITEM_REGULAR),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),
		list("Tools Pouch (Full)", 5, /obj/item/storage/pouch/tools/full, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 5, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),

		list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_MANDATORY),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Breaching Charge", 10, /obj/item/explosive/plastic/breaching_charge, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/high_explosive/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("Zip cuffs", 1, /obj/item/storage/box/zipcuffs, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 15, /obj/item/device/motiondetector/hacked, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),

		list("BINOCULARS", 0, null, null, null),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),
	)

/datum/job/antag/upp/doctor
	title = JOB_UPP_LT_DOKTOR
	selection_class = "job_cmo"
	gear_preset = /datum/equipment_preset/upp/doctor

/datum/equipment_preset/upp/doctor
	name = "UPP Doktor (Cryo)"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/combat_medic
	assignment = JOB_UPP_LT_DOKTOR
	rank = JOB_UPP_LT_DOKTOR
	role_comm_title = "Lt. Med."
	paygrades = list(PAY_SHORT_UO1 = JOB_PLAYTIME_TIER_0)
	access = list(
		ACCESS_UPP_GENERAL,
		ACCESS_UPP_MEDICAL,
		ACCESS_UPP_RESEARCH,
	)

/datum/equipment_preset/upp/doctor/load_gear(mob/living/carbon/human/new_human)
	. = ..()
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/medic/UPP = new()
	var/obj/item/clothing/accessory/storage/surg_vest/equipped/W = new()
	UPP.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)

/datum/equipment_preset/upp/doctor/dressed
	name = "UPP Doctor"
	flags = EQUIPMENT_PRESET_EXTRA
	access = ACCESS_LIST_UPP_ALL

/datum/equipment_preset/upp/doctor/dressed/load_gear(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/np92, WEAR_IN_BACK) //targeting unarmed medical personal is not a war crime in aliens(primarily because, off memory, warcrimes aren't really a thing, although this definately is bad manners), and the playerbase is HRP in this concern!(if you don't get the joke, the players regularly execute unarmed doctors in hvh events. :D)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/np92, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/np92, WEAR_IN_BACK)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/ushanka, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/medic/UPP = new()
	var/obj/item/clothing/accessory/storage/surg_vest/equipped/W = new()
	UPP.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/oxycodone, WEAR_IN_BELT)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	//póckets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/oxycodone, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/tricordrazine, WEAR_IN_L_STORE)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

/datum/equipment_preset/upp/doctor/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Medic Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP/medic, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("UL6 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/support, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/upp, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("HealthMate HUD", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Binoculars", 0, /obj/item/device/binoculars, null, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Ushanka", 0, /obj/item/clothing/head/uppcap/ushanka, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BELT", 0, null, null, null),
		list("Type 41 Lifesaver Bag", 0, /obj/item/storage/belt/medical/lifesaver/upp/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medical Pouch (Splints)", 0, /obj/item/storage/pouch/medical/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Pouch (Pills)", 0, /obj/item/storage/pouch/medical/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/doctor/get_antag_gear_equipment()
	return list(
		list("MEDIC SET (MANDATORY)", 0, null, null, null),
		list("Essential Medic Set", 0, /obj/effect/essentials_set/medic/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("FIELD SUPPLIES", 0, null, null, null),
		list("Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_RECOMMENDED),
		list("Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_RECOMMENDED),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_RECOMMENDED),

		list("FIRSTAID KITS", 0, null, null, null),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_RECOMMENDED),
		list("Firstaid Kit", 5, /obj/item/storage/firstaid/regular/response, null, VENDOR_ITEM_REGULAR),
		list("Fire Firstaid Kit", 6, /obj/item/storage/firstaid/fire, null, VENDOR_ITEM_REGULAR),
		list("Toxin Firstaid Kit", 6, /obj/item/storage/firstaid/toxin, null, VENDOR_ITEM_REGULAR),
		list("Oxygen Firstaid Kit", 6, /obj/item/storage/firstaid/o2, null, VENDOR_ITEM_REGULAR),
		list("Radiation Firstaid Kit", 6, /obj/item/storage/firstaid/rad, null, VENDOR_ITEM_REGULAR),

		list("AUTOINJECTORS", 0, null, null, null),
		list("Autoinjector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Epinephrine)", 2, /obj/item/reagent_container/hypospray/autoinjector/adrenaline, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("PILL BOTTLES", 0, null, null, null),
		list("Pill Bottle (Bicaridine)", 5, /obj/item/storage/pill_bottle/bicaridine, null, VENDOR_ITEM_RECOMMENDED),
		list("Pill Bottle (Dexalin)", 5, /obj/item/storage/pill_bottle/dexalin, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Dylovene)", 5, /obj/item/storage/pill_bottle/antitox, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Inaprovaline)", 5, /obj/item/storage/pill_bottle/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Kelotane)", 5, /obj/item/storage/pill_bottle/kelotane, null, VENDOR_ITEM_RECOMMENDED),
		list("Pill Bottle (Peridaxon)", 5, /obj/item/storage/pill_bottle/peridaxon, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Tramadol)", 5, /obj/item/storage/pill_bottle/tramadol, null, VENDOR_ITEM_RECOMMENDED),

		list("MEDICAL UTILITIES", 0, null, null, null),
		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_REGULAR),
		list("Roller Bed", 4, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Stasis Bag", 6, /obj/item/bodybag/cryobag, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 10, /obj/item/clothing/accessory/storage/holster, null, VENDOR_ITEM_REGULAR),
		list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 10, /obj/item/clothing/accessory/storage/droppouch, null, VENDOR_ITEM_REGULAR),
	)

//*****************************************************************************************************/

/datum/job/antag/upp/supply
	title = JOB_UPP_SUPPLY
	selection_class = "job_ct"
	gear_preset = /datum/equipment_preset/upp/supply


/datum/equipment_preset/upp/supply
	name = "UPP Logistics Technician (Cryo)"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/logistics_technician
	assignment = JOB_UPP_SUPPLY
	rank = JOB_UPP_SUPPLY
	role_comm_title = "Log."
	minimap_icon = "upp_cargo"
	paygrades = list(PAY_SHORT_UE3 = JOB_PLAYTIME_TIER_0)
	access = list(
		ACCESS_UPP_GENERAL,
		ACCESS_UPP_MEDICAL,
		ACCESS_UPP_ENGINEERING,
		ACCESS_UPP_ARMORY,
	)

/datum/equipment_preset/upp/supply/load_gear(mob/living/carbon/human/new_human)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/cct, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap(new_human), WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	//limb
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)

/datum/equipment_preset/upp/supply/dressed
	name = "UPP Logistics Technician"
	flags = EQUIPMENT_PRESET_EXTRA
	access = ACCESS_LIST_UPP_ALL

/datum/equipment_preset/upp/supply/dressed/load_gear(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked, WEAR_IN_BACK)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/cct, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap(new_human), WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	//limb
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction(new_human), WEAR_R_STORE)

/datum/equipment_preset/upp/supply/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("UM5 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/upp, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP/cct, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Welding Goggles", 0, /obj/item/clothing/glasses/welding, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Welderpack", 0, /obj/item/storage/backpack/marine/engineerpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Binoculars", 0, /obj/item/device/binoculars, null, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BELT (Choose 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 41 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (Choose 2)", 0, null, null, null),
		list("Construction Pouch", 0, /obj/item/storage/pouch/construction, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Electronics Pouch (Full)", 0, /obj/item/storage/pouch/electronics/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)



//*****************************************************************************************************/


//====================//
//  Field Officers  //
//================//
/datum/equipment_preset/upp/officer
	name = "UPP Mladshiy Leytenant (Cryo)"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/officer
	assignment = JOB_UPP_LT_OFFICER
	rank = JOB_UPP_LT_OFFICER
	role_comm_title = "Lt."
	minimap_icon = "upp_lt"
	paygrades = list(PAY_SHORT_UO1 = JOB_PLAYTIME_TIER_0)
	access = list(
		ACCESS_UPP_GENERAL,
		ACCESS_UPP_MEDICAL,
		ACCESS_UPP_ENGINEERING,
		ACCESS_UPP_SECURITY,
		ACCESS_UPP_ARMORY,
		ACCESS_UPP_FLIGHT,
		ACCESS_UPP_RESEARCH,
		ACCESS_UPP_COMMANDO,
		ACCESS_UPP_LEADERSHIP,
	)


/datum/job/antag/upp/officer //this is placeholder for stuff that is supposed to be the same for all officers
	selection_class = "job_command"

/datum/equipment_preset/upp/officer/load_gear(mob/living/carbon/human/new_human)
	. = ..()
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/command, WEAR_L_EAR)
	//uniform
	var/obj/item/clothing/under/marine/veteran/UPP/officer/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(M, WEAR_BODY)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)

/datum/equipment_preset/upp/officer/dressed
	name = "UPP Lieutenant"
	flags = EQUIPMENT_PRESET_EXTRA
	access = ACCESS_LIST_UPP_ALL


/datum/equipment_preset/upp/officer/dressed/load_gear(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/megaphone, WEAR_IN_BACK)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/command, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/UPP/officer/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)

	//jacket
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/officer, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer/leader, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/np92, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/upp, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/upp, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_R_STORE)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

/datum/equipment_preset/upp/officer/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP/officer, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/upp, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP/command, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Beret", 0, /obj/item/clothing/head/uppcap/beret, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Ushanka", 0, /obj/item/clothing/head/uppcap/ushanka, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("UL4 officer jacket", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/officer, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("UL6 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/support, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 73 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/type47/t73, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Rebreather", 0, /obj/item/clothing/mask/rebreather, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/upp/officer/get_antag_gear_equipment()
	return list(
		list("SQUAD LEADER SET (MANDATORY)", 0, null, null, null),
		list("Essential SL Set", 0, /obj/effect/essentials_set/leader/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("GENERAL SUPPLIES", 0, null, null, null),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Insulated Gloves", 3, /obj/item/clothing/gloves/yellow, null, VENDOR_ITEM_REGULAR),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),
		list("Tools Pouch (Full)", 5, /obj/item/storage/pouch/tools/full, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 5, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),

		list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_MANDATORY),

		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Breaching Charge", 10, /obj/item/explosive/plastic/breaching_charge, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/high_explosive/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("Zip cuffs", 1, /obj/item/storage/box/zipcuffs, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 15, /obj/item/device/motiondetector/hacked, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),

		list("BINOCULARS", 0, null, null, null),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),
	)

//*****************************************************************************************************/
/datum/job/antag/upp/officer/senior
	title = JOB_UPP_SRLT_OFFICER
	gear_preset = /datum/equipment_preset/upp/officer/senior

/datum/equipment_preset/upp/officer/senior
	name = "UPP Starshiy Leytenant (Cryo)"
	assignment = JOB_UPP_SRLT_OFFICER
	rank = JOB_UPP_SRLT_OFFICER
	role_comm_title = "Sr-Lt."
	minimap_icon = "upp_slt"
	paygrades = list(PAY_SHORT_UO2 = JOB_PLAYTIME_TIER_0)
	access = list(
		ACCESS_UPP_GENERAL,
		ACCESS_UPP_MEDICAL,
		ACCESS_UPP_ENGINEERING,
		ACCESS_UPP_SECURITY,
		ACCESS_UPP_ARMORY,
		ACCESS_UPP_FLIGHT,
		ACCESS_UPP_RESEARCH,
		ACCESS_UPP_COMMANDO,
		ACCESS_UPP_LEADERSHIP,
		ACCESS_UPP_SENIOR_LEAD,
	)

/datum/equipment_preset/upp/officer/senior/dressed
	name = "UPP Senior Lieutenant"
	access = ACCESS_LIST_UPP_ALL

/datum/equipment_preset/upp/officer/senior/dressed/load_gear(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/megaphone, WEAR_IN_BACK)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/command, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/UPP/officer/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)

	//jacket
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/officer, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer/leader, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/t73, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/upp, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/upp, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_R_STORE)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

/datum/equipment_preset/upp/officer/senior/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP/officer, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/upp, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP/command, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Beret", 0, /obj/item/clothing/head/uppcap/beret, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Ushanka", 0, /obj/item/clothing/head/uppcap/ushanka, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("UL4 officer jacket", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/officer, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("UL6 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/support, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 73 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/type47/t73, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas/pmc/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/upp/officer/senior/get_antag_gear_equipment()
	return list(
		list("SQUAD LEADER SET (MANDATORY)", 0, null, null, null),
		list("Essential SL Set", 0, /obj/effect/essentials_set/leader/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Insulated Gloves", 3, /obj/item/clothing/gloves/yellow, null, VENDOR_ITEM_REGULAR),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),
		list("Tools Pouch (Full)", 5, /obj/item/storage/pouch/tools/full, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 5, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),

		list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_MANDATORY),

		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Breaching Charge", 10, /obj/item/explosive/plastic/breaching_charge, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/high_explosive/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("Zip cuffs", 1, /obj/item/storage/box/zipcuffs, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 8, /obj/item/device/motiondetector/hacked, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),

		list("BINOCULARS", 0, null, null, null),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),
	)

//*****************************************************************************************************/
/datum/job/antag/upp/officer/kapitan
	title = JOB_UPP_KPT_OFFICER
	gear_preset = /datum/equipment_preset/upp/officer/kapitan

/datum/equipment_preset/upp/officer/kapitan
	name = "UPP Kapitan (Cryo)"
	assignment = JOB_UPP_KPT_OFFICER
	rank = JOB_UPP_KPT_OFFICER
	role_comm_title = "May."
	minimap_icon = "upp_xo"
	paygrades = list(PAY_SHORT_UO3 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/upp/kapitan


/datum/equipment_preset/upp/officer/kapitan/dressed
	name = "UPP Kapitan"
	access = ACCESS_LIST_UPP_ALL

/datum/equipment_preset/upp/officer/kapitan/load_gear(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/megaphone, WEAR_IN_BACK)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/command, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/UPP/officer/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)

	//jacket
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/kapitan, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer/leader, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/t73, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/upp, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/upp, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_R_STORE)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

/datum/equipment_preset/upp/officer/kapitan/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP/officer, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP/command, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Binoculars", 0, /obj/item/device/binoculars/range, null, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Beret", 0, /obj/item/clothing/head/uppcap/beret, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Ushanka", 0, /obj/item/clothing/head/uppcap/ushanka, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("UL4 senior officer jacket", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/kapitan, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("UL6 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/support, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 74 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/type47/t73/leader, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas/pmc/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/upp/officer/kapitan/get_antag_gear_equipment()
	return list(
		list("SQUAD LEADER SET (MANDATORY)", 0, null, null, null),
		list("Essential SL Set", 0, /obj/effect/essentials_set/leader/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("GENERAL SUPPLIES", 0, null, null, null),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Insulated Gloves", 3, /obj/item/clothing/gloves/yellow, null, VENDOR_ITEM_REGULAR),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),
		list("Tools Pouch (Full)", 5, /obj/item/storage/pouch/tools/full, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 5, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),

		list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_MANDATORY),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Breaching Charge", 10, /obj/item/explosive/plastic/breaching_charge, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/high_explosive/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("Zip cuffs", 1, /obj/item/storage/box/zipcuffs, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 8, /obj/item/device/motiondetector/hacked, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),

		list("BINOCULARS", 0, null, null, null),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),
	)

//*****************************************************************************************************/
/datum/job/antag/upp/officer/co_whitelist
	title = JOB_UPP_CO_OFFICER
	gear_preset = /datum/equipment_preset/upp/officer/major/co
	flags_startup_parameters = ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED
	flags_whitelist = WHITELIST_COMMANDER

/datum/job/antag/upp/officer/co_whitelist/New()
	. = ..()
	gear_preset_whitelist = list(
		"[JOB_CO][WHITELIST_NORMAL]" = /datum/equipment_preset/upp/officer/major/co,
		"[JOB_CO][WHITELIST_COUNCIL]" = /datum/equipment_preset/upp/officer/flag/podpolkovnik/co,
		"[JOB_CO][WHITELIST_LEADER]" = /datum/equipment_preset/upp/officer/flag/polkovnik/co
	)

/datum/job/antag/upp/officer/major
	title = JOB_UPP_MAY_OFFICER
	gear_preset = /datum/equipment_preset/upp/officer/major
	flags_startup_parameters = ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED
	flags_whitelist = WHITELIST_COMMANDER

/datum/equipment_preset/upp/officer/major
	name = "UPP Mayjor (Cryo)"
	assignment = JOB_UPP_MAY_OFFICER
	rank = JOB_UPP_MAY_OFFICER
	role_comm_title = "May."
	minimap_icon = "upp_co"
	paygrades = list(PAY_SHORT_UO4 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/upp/commander

/datum/equipment_preset/upp/officer/major/co
	name = "UPP Mayjor (CO)(Cryo)"
	assignment = JOB_UPP_CO_OFFICER
	rank = JOB_UPP_CO_OFFICER

/datum/equipment_preset/upp/officer/major/dressed
	name = "UPP Major"
	access = ACCESS_LIST_UPP_ALL

/datum/equipment_preset/upp/officer/major/dressed/load_gear(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/megaphone, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/cotablet/upp, WEAR_IN_BACK)

	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/command, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/peaked, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/UPP/officer/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)

	//jacket
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/kapitan, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer/leader, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/t73/leader, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/upp, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/upp, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_R_STORE)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

/datum/equipment_preset/upp/officer/major/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP/officer, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/upp, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP/command, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Binoculars", 0, /obj/item/device/binoculars/range, null, VENDOR_ITEM_MANDATORY),

		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Peaked Cap", 0, /obj/item/clothing/head/uppcap/peaked, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Ushanka", 0, /obj/item/clothing/head/uppcap/ushanka, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("UL4 senior officer jacket", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/kapitan, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("UL6 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/support, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 74 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/type47/t73/leader, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas/pmc/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/upp/officer/major/get_antag_gear_equipment()
	return list(
		list("SQUAD LEADER SET (MANDATORY)", 0, null, null, null),
		list("Essential SL Set", 0, /obj/effect/essentials_set/leader/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("GENERAL SUPPLIES", 0, null, null, null),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Insulated Gloves", 3, /obj/item/clothing/gloves/yellow, null, VENDOR_ITEM_REGULAR),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),
		list("Tools Pouch (Full)", 5, /obj/item/storage/pouch/tools/full, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 5, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),

		list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_MANDATORY),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Breaching Charge", 10, /obj/item/explosive/plastic/breaching_charge, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/high_explosive/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("Zip cuffs", 1, /obj/item/storage/box/zipcuffs, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 8, /obj/item/device/motiondetector/hacked, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),

		list("BINOCULARS", 0, null, null, null),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),
	)

//*****************************************************************************************************/
/datum/job/antag/upp/officer/podpolkovnik
	title = JOB_UPP_LTKOL_OFFICER
	gear_preset = /datum/equipment_preset/upp/officer/flag/podpolkovnik
	flags_startup_parameters = ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED
	flags_whitelist =  WHITELIST_COMMANDER_COUNCIL

/datum/equipment_preset/upp/officer/flag/podpolkovnik
	name = "UPP Podpolkovnik (Cryo)"
	assignment = JOB_UPP_LTKOL_OFFICER
	rank = JOB_UPP_LTKOL_OFFICER
	role_comm_title = "Lt. Kol."
	minimap_icon = "upp_co"
	paygrades = list(PAY_SHORT_UO5 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/upp/commander

/datum/equipment_preset/upp/officer/flag/podpolkovnik/co
	name = "UPP Podpolkovnik (CO)(Cryo)"
	assignment = JOB_UPP_CO_OFFICER
	rank = JOB_UPP_CO_OFFICER

/datum/equipment_preset/upp/officer/flag/dressed/podpolkovnik
	name = "UPP Podpolkovnik"
	assignment = JOB_UPP_LTKOL_OFFICER
	rank = JOB_UPP_LTKOL_OFFICER
	role_comm_title = "Lt. Kol."
	minimap_icon = "upp_co"
	paygrades = list(PAY_SHORT_UO5 = JOB_PLAYTIME_TIER_0)
	access = ACCESS_LIST_UPP_ALL

//*****************************************************************************************************/
/datum/equipment_preset/upp/officer/flag
	name = "UPP Flag Officer Base"
	minimap_icon = "upp_co"
	skills = /datum/skills/upp/commander

/datum/equipment_preset/upp/officer/flag/dressed
	name = "UPP Flag Officer Base (Dressed)"

/datum/equipment_preset/upp/officer/flag/dressed/load_gear(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/megaphone, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/cotablet/upp, WEAR_IN_BACK)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/command, WEAR_L_EAR)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/peaked, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/UPP/officer/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)

	//jacket
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/kapitan, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer/leader, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/t73/leader, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/upp, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/upp, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_R_STORE)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

/datum/equipment_preset/upp/officer/flag/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP/officer, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/upp, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP/command, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Binoculars", 0, /obj/item/device/binoculars, null, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Peaked Cap", 0, /obj/item/clothing/head/uppcap/peaked, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Ushanka", 0, /obj/item/clothing/head/uppcap/ushanka, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("UL4 senior officer jacket", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/kapitan, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("UL6 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/support, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 74 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/type47/t73/leader, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas/pmc/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/upp/officer/flag/get_antag_gear_equipment()
	return list(
		list("SQUAD LEADER SET (MANDATORY)", 0, null, null, null),
		list("Essential SL Set", 0, /obj/effect/essentials_set/leader/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("GENERAL SUPPLIES", 0, null, null, null),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Insulated Gloves", 3, /obj/item/clothing/gloves/yellow, null, VENDOR_ITEM_REGULAR),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),
		list("Tools Pouch (Full)", 5, /obj/item/storage/pouch/tools/full, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 5, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),

		list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_MANDATORY),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Breaching Charge", 10, /obj/item/explosive/plastic/breaching_charge, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/high_explosive/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 8, /obj/item/device/motiondetector/hacked, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),

		list("BINOCULARS", 0, null, null, null),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),
	)


/datum/job/antag/upp/officer/kolonel
	title = JOB_UPP_KOL_OFFICER
	gear_preset = /datum/equipment_preset/upp/officer/flag/podpolkovnik
	flags_startup_parameters = ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED
	flags_whitelist = WHITELIST_COMMANDER_COLONEL|WHITELIST_COMMANDER_LEADER

/datum/equipment_preset/upp/officer/flag/polkovnik
	name = "UPP Polkovnik (Cryo)"
	assignment = JOB_UPP_KOL_OFFICER
	rank = JOB_UPP_KOL_OFFICER
	role_comm_title = "Kol."
	paygrades = list(PAY_SHORT_UO6 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/upp/officer/flag/polkovnik/co
	name = "UPP Polkovnik (CO)(Cryo)"
	assignment = JOB_UPP_CO_OFFICER
	rank = JOB_UPP_CO_OFFICER

/datum/equipment_preset/upp/officer/flag/dressed/polkovnik
	name = "UPP Polkovnik"
	assignment = JOB_UPP_KOL_OFFICER
	rank = JOB_UPP_KOL_OFFICER
	role_comm_title = "Kol."
	paygrades = list(PAY_SHORT_UO6 = JOB_PLAYTIME_TIER_0)
//*****************************************************************************************************/

//===================//
//  Flag Officers  //
//===============//
/datum/equipment_preset/upp/officer/flag/brig_gen
	name = "UPP General Mayjor (Cryo)"
	assignment = JOB_UPP_BRIG_GENERAL
	rank = JOB_UPP_BRIG_GENERAL
	role_comm_title = "May. Gen."
	paygrades = list(PAY_SHORT_UO7 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/upp/officer/flag/dressed/brig_gen
	name = "UPP General Mayjor"
	assignment = JOB_UPP_BRIG_GENERAL
	rank = JOB_UPP_BRIG_GENERAL
	role_comm_title = "May. Gen."
	paygrades = list(PAY_SHORT_UO7 = JOB_PLAYTIME_TIER_0)

//*****************************************************************************************************/

/datum/equipment_preset/upp/officer/flag/may_gen
	name = "UPP General Leytenant (Cryo)"
	assignment = JOB_UPP_MAY_GENERAL
	rank = JOB_UPP_MAY_GENERAL
	role_comm_title = "Ley. Gen."
	minimap_icon = "upp_co"
	paygrades = list(PAY_SHORT_UO8 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/upp/commander

/datum/equipment_preset/upp/officer/flag/may_gen/dressed
	name = "UPP General Leytenant"
	assignment = JOB_UPP_MAY_GENERAL
	rank = JOB_UPP_MAY_GENERAL
	role_comm_title = "Ley. Gen."
	minimap_icon = "upp_co"
	paygrades = list(PAY_SHORT_UO8 = JOB_PLAYTIME_TIER_0)
	access = ACCESS_LIST_UPP_ALL

//*****************************************************************************************************/
/datum/job/antag/upp/officer/ley_gen
	title = JOB_UPP_LT_GENERAL
	gear_preset = /datum/equipment_preset/upp/officer/flag/ley_gen
	flags_whitelist =  WHITELIST_COMMANDER

/datum/equipment_preset/upp/officer/flag/ley_gen
	name = "UPP General Polkovnik (Cryo)"
	assignment = JOB_UPP_LT_GENERAL
	rank = JOB_UPP_LT_GENERAL
	role_comm_title = "Lt. Gen."
	minimap_icon = "upp_co"
	paygrades = list(PAY_SHORT_UO9 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/upp/commander

/datum/equipment_preset/upp/officer/flag/ley_gen/dressed
	name = "UPP General Polkovnik"
	assignment = JOB_UPP_LT_GENERAL
	rank = JOB_UPP_LT_GENERAL
	role_comm_title = "Lt. Gen."
	minimap_icon = "upp_co"
	access = ACCESS_LIST_UPP_ALL

//*****************************************************************************************************/
/datum/job/antag/upp/officer/gen
	title = JOB_UPP_GENERAL
	gear_preset = /datum/equipment_preset/upp/officer/flag/gen

/datum/equipment_preset/upp/officer/flag/gen
	name = "UPP General Armii (Cryo)"
	assignment = JOB_UPP_GENERAL
	rank = JOB_UPP_GENERAL
	role_comm_title = "Gen."
	minimap_icon = "upp_co"
	paygrades = list(PAY_SHORT_UO10 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/upp/commander
	access = ACCESS_LIST_UPP_ALL


//*****************************************************************************************************/
/datum/equipment_preset/upp/sapper/survivor
	name = "UPP Sapper (Survivor)"

/datum/equipment_preset/upp/sapper/survivor/load_gear(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/np92, WEAR_IN_BACK) //1
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/np92, WEAR_IN_BACK) //1.3
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/np92, WEAR_IN_BACK) //1.6
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/np92, WEAR_IN_BACK) //2
	new_human.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/upp/light, WEAR_IN_BACK) //3
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked, WEAR_IN_BACK) //4
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/cct, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas, WEAR_FACE)
	//head
	var/headgear = prob(70) ? /obj/item/clothing/head/helmet/marine/veteran/UPP/engi : /obj/item/clothing/head/uppcap/ushanka
	new_human.equip_to_slot_or_del(new headgear, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/engi/UPP = new()
	var/obj/item/clothing/accessory/storage/tool_webbing/equipped/W = new()
	UPP.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/type23/dual, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/upp/heavybuck(new_human), WEAR_WAIST)
	//limb
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_R_STORE)

//*****************************************************************************************************/
//===================//
//  UPP Synthetics  //
//================//

/datum/job/antag/upp/synth
	title = JOB_UPP_SUPPORT_SYNTH
	gear_preset = /datum/equipment_preset/upp/synth

	flags_whitelist =  WHITELIST_SYNTHETIC
	flags_startup_parameters = ROLE_WHITELISTED

/datum/job/antag/upp/synth/check_whitelist_status(mob/user)
	if(user.client.check_whitelist_status(WHITELIST_SYNTHETIC))
		return TRUE

	return ..()

/datum/equipment_preset/upp/synth
	name = "UPP Synthetic (Cryo)"

	languages = ALL_SYNTH_LANGUAGES_UPP

	skills = /datum/skills/synthetic
	assignment = JOB_UPP_SUPPORT_SYNTH
	rank = JOB_UPP_SUPPORT_SYNTH
	minimap_icon = "upp_synth"
	paygrades = list(PAY_SHORT_SYN = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/dogtag/upp


/datum/equipment_preset/upp/synth/dressed
	name = "UPP Synthetic"
	access = ACCESS_LIST_UPP_ALL

/datum/equipment_preset/upp/synth/load_gear(mob/living/carbon/human/new_human)
	. = ..()
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/command, WEAR_L_EAR)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/medic/UPP = new()
	var/obj/item/clothing/accessory/storage/surg_vest/drop_green/upp/webbing = new()
	UPP.attach_accessory(new_human, webbing)
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)

/datum/equipment_preset/upp/synth/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(50;MALE,50;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(new_human)
	var/random_name
	if(prob(10))
		random_name = "[capitalize(randomly_generate_chinese_word(2))]"
	else if(new_human.gender == MALE)
		random_name = "[pick(GLOB.first_names_male_upp)]"
	else
		random_name = "[pick(GLOB.first_names_female_upp)]"

	if(new_human.gender == MALE)
		new_human.f_style = pick("3 O'clock Shadow", "3 O'clock Moustache", "5 O'clock Shadow", "5 O'clock Moustache")


	new_human.change_real_name(new_human, random_name)
	new_human.h_style = pick("Crewcut", "Shaved Head", "Buzzcut", "Undercut", "Side Undercut")
	var/static/list/colors = list("BLACK" = list(15, 15, 25), "BROWN" = list(102, 51, 0), "AUBURN" = list(139, 62, 19))
	var/static/list/hair_colors = colors.Copy() + list("BLONDE" = list(197, 164, 30), "CARROT" = list(174, 69, 42))
	var/hair_color = pick(hair_colors)
	new_human.r_hair = hair_colors[hair_color][1]
	new_human.g_hair = hair_colors[hair_color][2]
	new_human.b_hair = hair_colors[hair_color][3]
	new_human.r_facial = hair_colors[hair_color][1]
	new_human.g_facial = hair_colors[hair_color][2]
	new_human.b_facial = hair_colors[hair_color][3]
	var/eye_color = pick(colors)
	new_human.r_eyes = colors[eye_color][1]
	new_human.g_eyes = colors[eye_color][2]
	new_human.b_eyes = colors[eye_color][3]
	idtype = /obj/item/card/id/dogtag/upp

/datum/equipment_preset/upp/synth/load_race(mob/living/carbon/human/new_human)
	new_human.set_species(SYNTH_GEN_THREE)

/datum/equipment_preset/upp/synth/load_skills(mob/living/carbon/human/new_human)
	. = ..()
	new_human.allow_gun_usage = FALSE

/datum/equipment_preset/upp/synth/dressed/load_gear(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/compact, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/blood/OMinus, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/blood/OMinus, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/synthetic/hyperdyne, WEAR_IN_BACK)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/command, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/tool/screwdriver, WEAR_R_EAR)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	//head
	var/hat = pick(/obj/item/clothing/head/uppcap, /obj/item/clothing/head/uppcap/beret, /obj/item/clothing/head/uppcap/ushanka)
	new_human.equip_to_slot_or_del(new hat, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/medic/UPP = new()
	var/obj/item/clothing/accessory/storage/surg_vest/drop_green/upp/webbing = new()
	UPP.attach_accessory(new_human, webbing)
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/support/synth, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/synth, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical/upp, WEAR_R_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/epinephrine, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/glass/bottle/epinephrine, WEAR_IN_L_STORE)

/datum/equipment_preset/upp/synth/get_antag_clothing_equipment()
	return list(
		list("RADIO (TAKE ALL)", 0, null, null, null),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP/command, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Ushanka", 0, /obj/item/clothing/head/uppcap/ushanka, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("WEBBING (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Surgical Webbing Vest", 0, /obj/item/clothing/accessory/storage/surg_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Surgical Webbing Vest (Blue)", 0, /obj/item/clothing/accessory/storage/surg_vest/blue, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("SHOES (CHOOSE 1)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),

		list("GLOVES (CHOOSE 1)", 0, null, null, null),
		list("Insulated Gloves", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_RECOMMENDED),
		list("Black Gloves", 0, /obj/item/clothing/gloves/black, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),
		list("Latex Gloves", 0, /obj/item/clothing/gloves/latex, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Smartpack, Blue", 0, /obj/item/storage/backpack/marine/smartpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Smartpack, Green", 0, /obj/item/storage/backpack/marine/smartpack/green, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Smartpack, Tan", 0, /obj/item/storage/backpack/marine/smartpack/tan, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Smartpack, White", 0, /obj/item/storage/backpack/marine/smartpack/white, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Smartpack, Black", 0, /obj/item/storage/backpack/marine/smartpack/black, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Logistics IMP Backpack", 0, /obj/item/storage/backpack/marine/satchel/big, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Lifesaver Bag", 0, /obj/item/storage/belt/medical/lifesaver/upp/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Medical Storage Belt", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Construction Pouch", 0, /obj/item/storage/pouch/construction, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Electronics Pouch (Full)", 0, /obj/item/storage/pouch/electronics/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK", 0, null, null, null),
		list("Sterile mask", 0, /obj/item/clothing/mask/surgical, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/synth/get_antag_gear_equipment()
	return list(
		list("ENGINEER SUPPLIES", 0, null, null, null),
		list("Airlock Circuit Board", 2, /obj/item/circuitboard/airlock, null, VENDOR_ITEM_REGULAR),
		list("APC Circuit Board", 2, /obj/item/circuitboard/apc, null, VENDOR_ITEM_REGULAR),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("High-Capacity Power Cell", 3, /obj/item/cell/high, null, VENDOR_ITEM_REGULAR),
		list("Light Replacer", 2, /obj/item/device/lightreplacer, null, VENDOR_ITEM_REGULAR),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_REGULAR),
		list("Multitool", 4, /obj/item/device/multitool, null, VENDOR_ITEM_REGULAR),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_REGULAR),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_REGULAR),
		list("Industrial Blowtorch", 4, /obj/item/tool/weldingtool/largetank, null, VENDOR_ITEM_RECOMMENDED),

		list("FIRSTAID KITS", 0, null, null, null),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_RECOMMENDED),
		list("Firstaid Kit", 5, /obj/item/storage/firstaid/regular/response, null, VENDOR_ITEM_REGULAR),
		list("Fire Firstaid Kit", 6, /obj/item/storage/firstaid/fire, null, VENDOR_ITEM_REGULAR),
		list("Toxin Firstaid Kit", 6, /obj/item/storage/firstaid/toxin, null, VENDOR_ITEM_REGULAR),
		list("Oxygen Firstaid Kit", 6, /obj/item/storage/firstaid/o2, null, VENDOR_ITEM_REGULAR),
		list("Radiation Firstaid Kit", 6, /obj/item/storage/firstaid/rad, null, VENDOR_ITEM_REGULAR),

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Medevac Bed", 6, /obj/item/roller/medevac, null, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),
		list("Roller Bed", 4, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Stasis Bag", 6, /obj/item/bodybag/cryobag, null, VENDOR_ITEM_REGULAR),

		list("Pillbottle (Bicaridine)", 5, /obj/item/storage/pill_bottle/bicaridine, null, VENDOR_ITEM_RECOMMENDED),
		list("Pillbottle (Dexalin)", 5, /obj/item/storage/pill_bottle/dexalin, null, VENDOR_ITEM_REGULAR),
		list("Pillbottle (Dylovene)", 5, /obj/item/storage/pill_bottle/antitox, null, VENDOR_ITEM_REGULAR),
		list("Pillbottle (Inaprovaline)", 5, /obj/item/storage/pill_bottle/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Pillbottle (Kelotane)", 5, /obj/item/storage/pill_bottle/kelotane, null, VENDOR_ITEM_RECOMMENDED),
		list("Pillbottle (Peridaxon)", 5, /obj/item/storage/pill_bottle/peridaxon, null, VENDOR_ITEM_REGULAR),
		list("Pillbottle (Tramadol)", 5, /obj/item/storage/pill_bottle/tramadol, null, VENDOR_ITEM_RECOMMENDED),

		list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Injector (Epinephrine)", 2, /obj/item/reagent_container/hypospray/autoinjector/adrenaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("Emergency Defibrillator", 4, /obj/item/device/defibrillator, null, VENDOR_ITEM_MANDATORY),
		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Surgical Line", 4, /obj/item/tool/surgery/surgical_line, null, VENDOR_ITEM_REGULAR),
		list("Synth-Graft", 4, /obj/item/tool/surgery/synthgraft, null, VENDOR_ITEM_REGULAR),

		list("OTHER SUPPLIES", 0, null, null, null),
		list("Binoculars", 5,/obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Rangefinder", 8, /obj/item/device/binoculars/range, null,  VENDOR_ITEM_REGULAR),
		list("Laser Designator", 12, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_RECOMMENDED),
		list("Flashlight", 1, /obj/item/device/flashlight, null, VENDOR_ITEM_RECOMMENDED),
		list("Fulton Recovery Device", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 5, /obj/item/device/motiondetector/hacked, null, VENDOR_ITEM_REGULAR),
		list("Space Cleaner", 2, /obj/item/reagent_container/spray/cleaner, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
	)
/datum/job/antag/upp/synth/combat
	title = JOB_UPP_COMBAT_SYNTH
	selection_class = "job_antag"
	gear_preset = /datum/equipment_preset/upp/synth/combat

/datum/equipment_preset/upp/synth/combat
	name = "UPP Combat Synthetic (Cryo)"

	assignment = JOB_UPP_COMBAT_SYNTH
	rank = JOB_UPP_COMBAT_SYNTH

/datum/equipment_preset/upp/synth/combat/dressed
	name = "UPP Combat Synthetic"
	flags = EQUIPMENT_PRESET_EXTRA
	access = ACCESS_LIST_UPP_ALL


/datum/equipment_preset/upp/synth/combat/load_skills(mob/living/carbon/human/new_human)
	. = ..()
	new_human.allow_gun_usage = TRUE

/datum/equipment_preset/upp/synth/combat/dressed/load_gear(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/compact, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/epinephrine, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/glass/bottle/epinephrine, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/blood/OMinus, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/command, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/tool/screwdriver, WEAR_R_EAR)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	//head
	var/hat = pick(/obj/item/clothing/head/uppcap, /obj/item/clothing/head/uppcap/beret, /obj/item/clothing/head/uppcap/ushanka)
	new_human.equip_to_slot_or_del(new hat, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	var/obj/item/clothing/accessory/storage/surg_vest/drop_green/upp/webbing = new()
	UPP.attach_accessory(new_human, webbing)
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/support, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/bizon, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/bizon, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/bizon/upp, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/synth, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	//pockets
	var/obj/item/storage/pouch/magazine/large/ppouch = new()
	new_human.equip_to_slot_or_del(ppouch, WEAR_L_STORE)
	for(var/i = 1 to ppouch.storage_slots)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/bizon, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical/upp/resetkey, WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/upp/commando
	name = "UPP Commando (!DEATHSQUAD! , Cryo)"

	skills = /datum/skills/commando
	assignment = JOB_UPP_COMMANDO
	rank = JOB_UPP_COMMANDO
	role_comm_title = "JKdo"
	paygrades = list(PAY_SHORT_UC1 = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/data

	minimap_icon = "upp_com"

	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_ENGLISH, LANGUAGE_TSL, LANGUAGE_SPANISH, LANGUAGE_CHINESE)

/datum/equipment_preset/upp/commando/New() //commando has full access
	. = ..()
	access = get_access(ACCESS_LIST_GLOBAL)

/datum/equipment_preset/upp/commando/dressed
	name = "UPP Commando (!DEATHSQUAD!)"
	flags = EQUIPMENT_PRESET_EXTRA


/datum/equipment_preset/upp/commando/dressed/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/kdo, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/commando, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/np92/suppressed, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/upp, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp, WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_BACK)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine/commando, /obj/item/ammo_magazine/rifle/type71, new_human, 0, 8)

/datum/equipment_preset/upp/commando/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/commando, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/upp, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP/kdo, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Night Vision Goggles", 0, /obj/item/clothing/glasses/night/m42_night_goggles/upp, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("UM5CU Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/commando, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("UPP Cloak", 0, /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("UPP Balaclava", 0, /obj/item/clothing/mask/gas/pmc/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Binoculars", 0, /obj/item/device/binoculars/range, null, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Ushanka", 0, /obj/item/clothing/head/uppcap/ushanka, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("NPZ92 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/type47/np92/suppressed, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas/pmc/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/upp/commando/get_antag_gear_equipment()
	return list(
		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_RECOMMENDED),
		list("Sandbags x25", 5, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/high_explosive/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 15, /obj/item/device/motiondetector/hacked, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 15, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
	)

//*****************************************************************************************************/
/datum/job/antag/upp/commando/medic
	title = JOB_UPP_COMMANDO_MEDIC
	selection_class = "job_antag"
	gear_preset = /datum/equipment_preset/upp/commando/medic

/datum/equipment_preset/upp/commando/medic
	name = "UPP Commando Medic (!DEATHSQUAD!, Cryo)"

	skills = /datum/skills/commando/medic
	assignment = JOB_UPP_COMMANDO_MEDIC
	rank = JOB_UPP_COMMANDO_MEDIC
	role_comm_title = "2ndKdo"
	minimap_icon = "upp_commed"
	paygrades = list(PAY_SHORT_UC2 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/upp/commando/medic/dressed
	name = "UPP Commando Medic (!DEATHSQUAD!)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/upp/commando/medic/dressed/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/kdo/medic, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/medic, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/commando, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/upp, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp, WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_IN_BACK)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_L_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_JACKET)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine/commando, /obj/item/ammo_magazine/rifle/type71, new_human, 0, 5)

/datum/equipment_preset/upp/commando/medic/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Standard Apparel", 0, list(/obj/item/clothing/under/marine/veteran/UPP/medic, /obj/item/clothing/shoes/marine/upp/knife, /obj/item/clothing/gloves/marine/veteran/upp, /obj/item/device/radio/headset/distress/UPP/kdo/medic), MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("HealthMate HUD", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Night Vision Goggles", 0, /obj/item/clothing/glasses/night/m42_night_goggles/upp, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("UM5CU Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/commando, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("UPP Cloak", 0, /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("UPP Balaclava", 0, /obj/item/clothing/mask/gas/pmc/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Binoculars", 0, /obj/item/device/binoculars/range, null, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Ushanka", 0, /obj/item/clothing/head/uppcap/ushanka, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BELT", 0, null, null, null),
		list("Type 41 Lifesaver Bag", 0, /obj/item/storage/belt/medical/lifesaver/upp/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Pouch (Splints)", 0, /obj/item/storage/pouch/medical/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Pouch (Pills)", 0, /obj/item/storage/pouch/medical/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas/pmc/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/upp/commando/medic/get_antag_gear_equipment()
	return list(
		list("MEDIC SET (MANDATORY)", 0, null, null, null),
		list("Essential Medic Set", 0, /obj/effect/essentials_set/medic/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("FIELD SUPPLIES", 0, null, null, null),
		list("Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_RECOMMENDED),
		list("Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_RECOMMENDED),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_RECOMMENDED),

		list("FIRSTAID KITS", 0, null, null, null),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_RECOMMENDED),
		list("Firstaid Kit", 5, /obj/item/storage/firstaid/regular/response, null, VENDOR_ITEM_REGULAR),
		list("Fire Firstaid Kit", 6, /obj/item/storage/firstaid/fire, null, VENDOR_ITEM_REGULAR),
		list("Toxin Firstaid Kit", 6, /obj/item/storage/firstaid/toxin, null, VENDOR_ITEM_REGULAR),
		list("Oxygen Firstaid Kit", 6, /obj/item/storage/firstaid/o2, null, VENDOR_ITEM_REGULAR),
		list("Radiation Firstaid Kit", 6, /obj/item/storage/firstaid/rad, null, VENDOR_ITEM_REGULAR),

		list("AUTOINJECTORS", 0, null, null, null),
		list("Autoinjector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Epinephrine)", 2, /obj/item/reagent_container/hypospray/autoinjector/adrenaline, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("PILL BOTTLES", 0, null, null, null),
		list("Pill Bottle (Bicaridine)", 5, /obj/item/storage/pill_bottle/bicaridine, null, VENDOR_ITEM_RECOMMENDED),
		list("Pill Bottle (Dexalin)", 5, /obj/item/storage/pill_bottle/dexalin, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Dylovene)", 5, /obj/item/storage/pill_bottle/antitox, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Inaprovaline)", 5, /obj/item/storage/pill_bottle/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Kelotane)", 5, /obj/item/storage/pill_bottle/kelotane, null, VENDOR_ITEM_RECOMMENDED),
		list("Pill Bottle (Peridaxon)", 5, /obj/item/storage/pill_bottle/peridaxon, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Tramadol)", 5, /obj/item/storage/pill_bottle/tramadol, null, VENDOR_ITEM_RECOMMENDED),

		list("MEDICAL UTILITIES", 0, null, null, null),
		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_REGULAR),
		list("Roller Bed", 4, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Stasis Bag", 6, /obj/item/bodybag/cryobag, null, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/high_explosive/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 15, /obj/item/device/motiondetector/hacked, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 15, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
	)

//*****************************************************************************************************/
/datum/job/antag/upp/commando/leader
	title = JOB_UPP_COMMANDO_LEADER
	selection_class = "job_antag"
	gear_preset = /datum/equipment_preset/upp/commando/leader

/datum/equipment_preset/upp/commando/leader
	name = "UPP Commando Leader (!DEATHSQUAD!, cryo)"

	skills = /datum/skills/commando/leader
	assignment = JOB_UPP_COMMANDO_LEADER
	rank = JOB_UPP_COMMANDO_LEADER
	role_comm_title = "1stKdo"
	minimap_icon = "upp_comsl"
	paygrades = list(PAY_SHORT_UC3 = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/silver

/datum/equipment_preset/upp/commando/leader/dressed
	name = "UPP Commando Leader (!DEATHSQUAD!)"
	flags = EQUIPMENT_PRESET_EXTRA


/datum/equipment_preset/upp/commando/leader/dressed/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/kdo/command, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/commando, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/upp, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp, WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/np92/suppressed, WEAR_WAIST)

	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_L_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/handcuffs, WEAR_IN_BACK)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine/commando, /obj/item/ammo_magazine/rifle/type71, new_human, 0, 7)

/datum/equipment_preset/upp/commando/leader/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Standard Apparel", 0, list(/obj/item/clothing/suit/storage/marine/faction/UPP/commando, /obj/item/clothing/shoes/marine/upp/knife, /obj/item/clothing/gloves/marine/veteran/upp, /obj/item/device/radio/headset/distress/UPP/kdo/command), MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Night Vision Goggles", 0, /obj/item/clothing/glasses/night/m42_night_goggles/upp, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("UM5CU Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/commando, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("UPP Cloak", 0, /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("UPP Balaclava", 0, /obj/item/clothing/mask/gas/pmc/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Binoculars", 0, /obj/item/device/binoculars/range, null, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Ushanka", 0, /obj/item/clothing/head/uppcap/ushanka, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("NPZ92 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/type47/np92/suppressed, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas/pmc/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/upp/commando/leader/get_antag_gear_equipment()
	return list(
		list("LEADER SET (MANDATORY)", 0, null, null, null),
		list("Essential Leader Set", 0, /obj/effect/essentials_set/leader/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("GENERAL SUPPLIES", 0, null, null, null),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Insulated Gloves", 3, /obj/item/clothing/gloves/yellow, null, VENDOR_ITEM_REGULAR),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),
		list("Tools Pouch (Full)", 5, /obj/item/storage/pouch/tools/full, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 5, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),

		list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_MANDATORY),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Breaching Charge", 10, /obj/item/explosive/plastic/breaching_charge, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/high_explosive/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 15, /obj/item/device/motiondetector/hacked, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),

		list("BINOCULARS", 0, null, null, null),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/upp/commando/low_threat
	name = "UPP Commando"

/datum/equipment_preset/upp/commando/low_threat/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/kdo, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/commando, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/np92/suppressed, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/scout_cloak/upp/weak, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/upp, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp, WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_BACK)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine/commando, /obj/item/ammo_magazine/rifle/type71, new_human, 0, 8)

/datum/equipment_preset/upp/commando/medic/low_threat
	name = "UPP Commando Medic"

/datum/equipment_preset/upp/commando/medic/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/kdo/medic, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/medic, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/commando, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/scout_cloak/upp/weak, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/upp, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp, WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_IN_BACK)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_L_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_JACKET)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine/commando, /obj/item/ammo_magazine/rifle/type71, new_human, 0, 5)

/datum/equipment_preset/upp/commando/leader/low_threat
	name = "UPP Commando Leader"

/datum/equipment_preset/upp/commando/leader/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/kdo/command, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/commando, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/scout_cloak/upp/weak, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/upp, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp, WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/np92/suppressed, WEAR_WAIST)

	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_L_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/handcuffs, WEAR_IN_BACK)

//*****************************************************************************************************/

//============//
//  Other  //
//========//

/datum/equipment_preset/upp/tank
	name = "UPP Vehicle Crewman (TANK, cryo)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_UPP_CREWMAN
	rank = JOB_UPP_CREWMAN
	paygrades = list(PAY_SHORT_UE5 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "TANK"

	minimap_icon = "upp_vc"

	minimum_age = 30
	skills = /datum/skills/tank_crew

/datum/equipment_preset/upp/tank/dressed
	name = "UPP Vehicle Crewman (TANK)"
	access = ACCESS_LIST_UPP_ALL


/datum/equipment_preset/upp/tank/dressed/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/cct(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/revolver(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/weldpack(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tank(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/engi(new_human), WEAR_HEAD)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine, /obj/item/ammo_magazine/rifle/type71, new_human, 0, 3)

/datum/equipment_preset/upp/tank/load_status()
	return

/datum/equipment_preset/upp/tank/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/insulated, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("UM5 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("UM4-V Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP/engi, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Welding Kit", 0, /obj/item/tool/weldpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Binoculars", 0, /obj/item/device/binoculars, null, VENDOR_ITEM_MANDATORY),

		list("PERSONAL SIDEARM (CHOOSE 1)", 0, null, null, null),
		list("Type 73 Pistol", 0, /obj/item/weapon/gun/pistol/t73, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_RECOMMENDED),
		list("NP92 Pistol", 0, /obj/item/weapon/gun/pistol/np92, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("ZHNK-72 Revolver", 0, /obj/item/weapon/gun/revolver/upp, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M103 Vehicle-Ammo Rig", 0, /obj/item/storage/belt/tank, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/tank, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),

		list("WELDING PROTECTION (CHOOSE 1)", 0, null, null, null),
		list("Welding Goggles", 0, /obj/item/clothing/glasses/welding, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
		list("Welding Helmet", 0, /obj/item/clothing/head/welding, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas/pmc/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	)

/datum/equipment_preset/upp/tank/get_antag_gear_equipment()
	return list(
		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/high_explosive/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", 5, /obj/item/storage/pouch/flamertank, null, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 15, /obj/item/storage/pouch/magazine/large, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 15, /obj/item/device/motiondetector/hacked, null, VENDOR_ITEM_REGULAR),
		list("Plastic Explosive", 10, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 15, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
	)

/datum/job/antag/upp/pilot
	title = JOB_UPP_PILOT
	gear_preset = /datum/equipment_preset/upp/pilot

/datum/equipment_preset/upp/pilot
	name = "UPP Pilot (Cryo)"
	assignment = JOB_UPP_PILOT
	role_comm_title = "Pilot"
	rank = JOB_UPP_PILOT
	paygrades = list(PAY_SHORT_UO1 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/pilot
	access = list(ACCESS_UPP_GENERAL, ACCESS_UPP_ENGINEERING, ACCESS_UPP_FLIGHT)

/datum/equipment_preset/upp/pilot/dressed
	name = "UPP Pilot"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/upp/pilot/load_gear(mob/living/carbon/human/new_human)

	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK)
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/cct, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator(new_human), WEAR_EYES)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP(new_human), WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP(new_human), WEAR_JACKET)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/revolver(new_human), WEAR_WAIST)
	//limb
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(new_human), WEAR_R_STORE)

/datum/equipment_preset/upp/pilot/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("UM5 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/upp, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP/cct, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Welderpack", 0, /obj/item/storage/backpack/marine/engineerpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Binoculars", 0, /obj/item/device/binoculars, null, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Armored Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BELT (Choose 1)", 0, null, null, null),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Type 41 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (Choose 2)", 0, null, null, null),
		list("Construction Pouch", 0, /obj/item/storage/pouch/construction, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Electronics Pouch (Full)", 0, /obj/item/storage/pouch/electronics/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/pilot/get_antag_gear_equipment()
	return list(
		list("EXPLOSIVES", 0, null, null, null),
		list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/high_explosive/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", 5, /obj/item/storage/pouch/flamertank, null, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 15, /obj/item/storage/pouch/magazine/large, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 15, /obj/item/device/motiondetector/hacked, null, VENDOR_ITEM_REGULAR),
		list("Plastic Explosive", 10, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 15, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
	)

//*****************************************************************************************************/
/datum/job/antag/upp/commisar
	title = JOB_UPP_COMMISSAR
	selection_class = "job_cl"
	gear_preset = /datum/equipment_preset/upp/commissar

/datum/equipment_preset/upp/commissar
	name = "UPP Political Commissar (Cryo)"

	assignment = JOB_UPP_COMMISSAR
	rank = JOB_UPP_COMMISSAR
	paygrades = list(PAY_SHORT_UO4P = JOB_PLAYTIME_TIER_0)
	role_comm_title = "Commissar"
	minimap_icon = "upp_plt"
	minimum_age = 30
	skills = /datum/skills/upp/commissar

/datum/equipment_preset/upp/commissar/dressed
	name = "UPP Political Commissar"
	flags = EQUIPMENT_PRESET_EXTRA
	access = ACCESS_LIST_UPP_ALL

/datum/equipment_preset/upp/commissar/load_gear(mob/living/carbon/human/new_human)
	. = ..()
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/command(new_human), WEAR_L_EAR)

/datum/equipment_preset/upp/commissar/dressed/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP/command(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/revolver(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/gimmick/jason(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret(new_human), WEAR_HEAD)

/datum/equipment_preset/upp/commissar/load_status()
	return

/datum/equipment_preset/upp/commissar/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("UL2 Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UL3 Beret", 0, /obj/item/clothing/head/uppcap/beret, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UL8 Ushanka", 0, /obj/item/clothing/head/uppcap/beret, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Binoculars", 0, /obj/item/device/binoculars, null, VENDOR_ITEM_MANDATORY),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/commissar/get_antag_gear_equipment()
	return list(
		list("SQUAD LEADER SET (MANDATORY)", 0, null, null, null),
		list("Essential SL Set", 0, /obj/effect/essentials_set/leader/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("GENERAL SUPPLIES", 0, null, null, null),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Insulated Gloves", 3, /obj/item/clothing/gloves/yellow, null, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 5, /obj/item/storage/pouch/tools/full, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 5, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),

		list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_MANDATORY),

		list("UTILITIES", 0, null, null, null),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 15, /obj/item/device/motiondetector/hacked, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),

		list("BINOCULARS", 0, null, null, null),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),
	)

//*****************************************************************************************************/
/datum/job/antag/upp/conscript
	title = JOB_UPP_CONSCRIPT
	selection_class = "job_antag"
	gear_preset = /datum/equipment_preset/upp/conscript
	flags_startup_parameters = ROLE_ADD_TO_SQUAD

/datum/equipment_preset/upp/conscript
	//meme role
	name = "UPP Conscript"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp
	assignment = JOB_UPP_CONSCRIPT
	rank = JOB_UPP_CONSCRIPT
	role_comm_title = "Cons"
	minimap_icon = "upp_pvt"
	paygrades = list(PAY_SHORT_UE1 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/upp/conscript/load_gear(mob/living/carbon/human/new_human)
	//back
	var/maybebackpack = prob(20) ? pick(/obj/item/storage/backpack/lightpack/upp, /obj/item/storage/backpack/lightpack) : null
	if(maybebackpack)
		new_human.equip_to_slot_or_del(new maybebackpack, WEAR_BACK) //what in back?
	//face
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)

	//head
	var/maybehat = prob(66) ? pick(/obj/item/clothing/head/uppcap, /obj/item/clothing/head/uppcap/beret, /obj/item/clothing/head/ushanka, /obj/item/clothing/head/uppcap/ushanka) : null
	if(maybehat)
		new_human.equip_to_slot_or_del(new maybehat, WEAR_HEAD)

	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)

	var/maybejacket = prob(50) ? pick(/obj/item/clothing/suit/storage/marine/faction/UPP/jacket, /obj/item/clothing/suit/storage/snow_suit/soviet) : null
	if(maybejacket)
		new_human.equip_to_slot_or_del(new maybejacket, WEAR_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/vodka, WEAR_IN_JACKET)
		//limit of snowcoat
		new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/upp, WEAR_IN_JACKET)

	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	var/maybegloves = prob(80) ? pick(/obj/item/clothing/gloves/black, /obj/item/clothing/gloves/marine/veteran/upp, /obj/item/clothing/gloves/combat) : null
	if(maybegloves)
		new_human.equip_to_slot_or_del(new maybegloves, WEAR_HANDS)

	//gun
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/carbine, WEAR_R_HAND)

	//webbing or belt?
	if(prob(30))
		var/obj/item/clothing/accessory/storage/webbing/W = new()
		UPP.attach_accessory(new_human, W)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_ACCESSORY)
		new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_ACCESSORY)
	else if(prob(30))
		new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp/scarce, WEAR_WAIST)
	//if you fail the rolls you must scavenge the ammo from your fallen brethren

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

	if(prob(10))
		//sometimes Ivan smiles upon the corps
		new_human.set_species("Human Hero")

/datum/equipment_preset/upp/conscript/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/upp/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Binoculars", 0, /obj/item/device/binoculars, null, VENDOR_ITEM_MANDATORY),

		list("HELMET", 0, null, null, null),
		list("Armored Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Armored Ushanka", 0, /obj/item/clothing/head/uppcap/ushanka, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("Type 41 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Tactical Bandana", 0, /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/upp/conscript/get_antag_gear_equipment()
	return list(
		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_RECOMMENDED),
		list("Sandbags x25", 5, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),

		list("EXPLOSIVES", 0, null, null, null),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest, null, VENDOR_ITEM_RECOMMENDED),
		list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 10, /obj/item/clothing/accessory/storage/droppouch, null, VENDOR_ITEM_REGULAR)
	)

///Hunting Grounds UPP///

/datum/equipment_preset/upp/soldier/hunted
	name = "UPP Soldier (Hunted)"
	faction = FACTION_HUNTED_UPP

/datum/equipment_preset/upp/soldier/hunted/load_gear(mob/living/carbon/human/new_human)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate, WEAR_R_STORE)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, WEAR_FACE)

	load_upp_soldier(new_human, UPP)

/datum/equipment_preset/upp/soldier/hunted/load_upp_soldier(mob/living/carbon/human/new_human, obj/item/clothing/under/marine/veteran/UPP/UPP)
	var/percentage = rand(1, 100)
	switch(percentage)
		if(1 to 66)
			load_upp_rifleman(new_human, UPP)
		if(67 to 85)
			load_upp_breacher(new_human, UPP)
		else
			load_upp_double(new_human, UPP)


/datum/equipment_preset/upp/machinegunner/hunted
	name = "UPP Machinegunner (Hunted)"
	faction = FACTION_HUNTED_UPP

/datum/equipment_preset/upp/machinegunner/hunted/load_gear(mob/living/carbon/human/new_human)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/heavy, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, WEAR_JACKET)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate, WEAR_R_STORE)

	//body
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/minigun/upp, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun, WEAR_IN_JACKET)
	//waist
	var/uppvetsidearm = prob(50) ? /obj/item/storage/belt/gun/type47/t73 : /obj/item/storage/belt/gun/type47/np92
	new_human.equip_to_slot_or_del(new uppvetsidearm, WEAR_WAIST)

/datum/equipment_preset/upp/leader/hunted
	name = "UPP Squad Leader (Hunted)"
	faction = FACTION_HUNTED_UPP

/datum/equipment_preset/upp/leader/hunted/load_gear(mob/living/carbon/human/new_human)
	var/UPPleadsidearm = rand(1,4)
	//back
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_BACK)
	//head
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	var/obj/item/clothing/accessory/storage/webbing/webbing = new()
	UPP.attach_accessory(new_human, webbing)
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/t73, WEAR_WAIST)
	switch(UPPleadsidearm)
		if(1 to 2) // 50%
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/t73, WEAR_WAIST)
		if(3) //25%
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/np92, WEAR_WAIST)
		if(4) //25%
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/revolver, WEAR_WAIST)
	//limbs
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp, WEAR_HANDS)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate, WEAR_R_STORE)

/datum/equipment_preset/upp/sapper/hunted
	name = "UPP Sapper (Hunted)"
	faction = FACTION_HUNTED_UPP

/datum/equipment_preset/upp/sapper/hunted/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/upp, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas, WEAR_FACE)
	//head
	var/headgear = prob(70) ? /obj/item/clothing/head/helmet/marine/veteran/UPP/engi : /obj/item/clothing/head/uppcap/ushanka
	new_human.equip_to_slot_or_del(new headgear, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/engi/UPP = new()
	var/obj/item/clothing/accessory/storage/tool_webbing/equipped/webbing = new()
	UPP.attach_accessory(new_human, webbing)
	new_human.equip_to_slot_or_del(UPP, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/upp/naval, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/sapper, WEAR_J_STORE)
	//waist
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp/sapper(new_human), WEAR_WAIST)
	//limb
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	//pockets
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate, WEAR_R_STORE)
