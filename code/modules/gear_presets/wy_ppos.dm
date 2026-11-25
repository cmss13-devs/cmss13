/datum/equipment_preset/wy_ppo
	name = "Weyland-Yutani Personal Protection Officer"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_WY
	faction_group =	FACTION_LIST_MARINE_WY
	origin_override = ORIGIN_WY_SEC

	idtype = /obj/item/card/id/silver/cl
	assignment = JOB_WY_PPO
	job_title = JOB_WY_PPO
	paygrades = list(PAY_SHORT_WY_SEC_PPO = JOB_PLAYTIME_TIER_0)
	role_comm_title = "WY-PPO"
	skills = /datum/skills/wy_ppo
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)

	minimap_icon = "goon_guard"
	minimap_background = "background_goon"

	var/belt_item = /obj/item/storage/belt/gun/m4a3/wy/es4
	var/head_item = /obj/item/clothing/head/helmet/marine/veteran/pmc/guard/ppo
	var/jacket_item = /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/ppo
	var/primary_weapon = null
	var/primary_ammo = null
	var/back_item = /obj/item/storage/backpack/satchel/black
	var/headset_type = /obj/item/device/radio/headset/distress/WY/security/guard

/datum/equipment_preset/wy_ppo/New()
	. = ..()
	access = get_access(ACCESS_LIST_WY_PPO)

/datum/equipment_preset/wy_ppo/load_vanity(mob/living/carbon/human/new_human)
	return

/datum/equipment_preset/wy_ppo/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(MALE, FEMALE)

	var/datum/preferences/A = new()
	A.randomize_appearance(new_human)

	var/first_name
	var/last_name
	switch(new_human.gender)
		if(FEMALE)
			first_name = capitalize(pick(GLOB.first_names_female_pmc))
		if(PLURAL, NEUTER) // Not currently possible
			first_name = capitalize(pick(MALE, FEMALE) == MALE ? pick(GLOB.first_names_male_pmc) : pick(GLOB.first_names_female_pmc))
		else // MALE
			first_name = capitalize(pick(GLOB.first_names_male_pmc))
			new_human.f_style = pick("3 O'clock Shadow", "3 O'clock Moustache", "5 O'clock Shadow", "5 O'clock Moustache")
	last_name = capitalize(pick(GLOB.last_names_pmc))
	new_human.change_real_name(new_human, "[first_name] [last_name]")

	new_human.age = rand(17,35)

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

/datum/equipment_preset/wy_ppo/load_id(mob/living/carbon/human/new_human, client/mob_client)
	var/obj/item/clothing/under/uniform = new_human.w_uniform
	if(istype(uniform))
		uniform.has_sensor = UNIFORM_HAS_SENSORS
	return ..()

/datum/equipment_preset/wy_ppo/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/black, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/ppo, WEAR_HANDS)

	new_human.equip_to_slot_or_del(new head_item, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new jacket_item, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new belt_item, WEAR_WAIST)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/blue/prescription, WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/blue, WEAR_EYES)

	new_human.equip_to_slot_or_del(new back_item, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/wy, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert/wy, WEAR_R_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/storage/box/zipcuffs/small, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical/sec/full, WEAR_L_STORE)

	if(primary_weapon)
		new_human.equip_to_slot_or_del(new primary_weapon, WEAR_J_STORE)
	if(primary_ammo)
		new_human.equip_to_slot_or_del(new primary_ammo, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new primary_ammo, WEAR_IN_JACKET)
		new_human.equip_to_slot_or_del(new primary_ammo, WEAR_IN_BACK)
		new_human.equip_to_slot_or_del(new primary_ammo, WEAR_IN_BACK)
		new_human.equip_to_slot_or_del(new primary_ammo, WEAR_IN_BACK)

/datum/equipment_preset/wy_ppo/spec
	name = "Weyland-Yutani Personal Protection Specialist"
	assignment = JOB_WY_PPS
	job_title = JOB_WY_PPS
	paygrades = list(PAY_SHORT_WY_SEC_PPS = JOB_PLAYTIME_TIER_0)
	role_comm_title = "WY-PPS"

	belt_item = /obj/item/storage/belt/shotgun/black/es7_mixed
	head_item = /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/ppo
	jacket_item = /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/ppo/strong
	primary_weapon = /obj/item/weapon/gun/shotgun/es7

/datum/equipment_preset/wy_ppo/coordinator
	name = "Weyland-Yutani Personal Protection Coordinator"
	assignment = JOB_WY_PPC
	job_title = JOB_WY_PPC
	paygrades = list(PAY_SHORT_WY_SEC_PPC = JOB_PLAYTIME_TIER_0)
	role_comm_title = "WY-PPC"
	skills = /datum/skills/wy_ppc

	belt_item = /obj/item/storage/belt/gun/m4a3/wy/es4
	head_item = /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/ppo
	jacket_item = /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/ppo/strong
	primary_weapon = /obj/item/weapon/gun/rifle/m41a/corporate
	primary_ammo = /obj/item/ammo_magazine/rifle/ap


/datum/equipment_preset/wy_ppo/directorate
	name = "Weyland-Yutani Directorate Protection Officer"
	assignment = JOB_WY_DPO
	job_title = JOB_WY_DPO
	paygrades = list(PAY_SHORT_WY_SEC_DPO = JOB_PLAYTIME_TIER_0)
	role_comm_title = "WY-DPO"
	skills = /datum/skills/pmc/commando

	belt_item = /obj/item/storage/belt/gun/m4a3/wy/es4
	head_item = /obj/item/clothing/head/helmet/marine/veteran/pmc/enclosed/commando
	jacket_item = /obj/item/clothing/suit/storage/marine/veteran/pmc/commando
	primary_weapon = /obj/item/weapon/gun/rifle/m41a/corporate/commando
	back_item = /obj/item/storage/backpack/pmc/backpack/commando
	headset_type = /obj/item/device/radio/headset/distress/pmc/commando


/datum/equipment_preset/wy_ppo/directorate/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/leader/commando, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc/commando, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/commando/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc, WEAR_FACE)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/black_vest, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/pmc, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/pmc, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/pmc, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_ACCESSORY)

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/socmed/commando, WEAR_R_STORE)

	new_human.equip_to_slot_or_del(new back_item, WEAR_BACK)
	new_human.equip_to_slot_or_del(new head_item, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new jacket_item, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new primary_weapon, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/wy, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/extended, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/extended, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/extended, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/extended, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/extended, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical/full, WEAR_L_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/weapon/baton, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked/pmc, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/zipcuffs/small, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/synthetic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/whiteout/medical/commando, WEAR_IN_BACK)


/datum/equipment_preset/wy_ppo/directorate/spec
	name = "Weyland-Yutani Directorate Protection Specialist"
	assignment = JOB_WY_DPS
	job_title = JOB_WY_DPS
	paygrades = list(PAY_SHORT_WY_SEC_DPS = JOB_PLAYTIME_TIER_0)
	role_comm_title = "WY-DPS"
	skills = /datum/skills/pmc/commando
	primary_weapon = /obj/item/weapon/gun/rifle/m41a/elite/commando

/datum/equipment_preset/wy_ppo/directorate/coordinator
	name = "Weyland-Yutani Directorate Protection Coordinator"
	assignment = JOB_WY_DPC
	job_title = JOB_WY_DPC
	paygrades = list(PAY_SHORT_WY_SEC_DPC = JOB_PLAYTIME_TIER_0)
	role_comm_title = "WY-DPC"
	skills = /datum/skills/pmc/commando/leader

	head_item = /obj/item/clothing/head/helmet/marine/veteran/pmc/enclosed/commando/leader
	jacket_item = /obj/item/clothing/suit/storage/marine/veteran/pmc/commando/leader
	back_item = /obj/item/storage/backpack/pmc/backpack/commando/leader
	primary_weapon = /obj/item/weapon/gun/rifle/m41a/elite/commando
	headset_type = /obj/item/device/radio/headset/distress/pmc/commando/leader
