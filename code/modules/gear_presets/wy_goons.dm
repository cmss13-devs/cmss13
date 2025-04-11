/datum/equipment_preset/goon
	name = "WY Goons"
	faction = FACTION_WY
	rank = FACTION_WY
	idtype = /obj/item/card/id/silver/cl
	faction_group = list(FACTION_WY)
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	minimap_background = "background_goon"
	var/uniform_type = /obj/item/clothing/under/marine/veteran/pmc/corporate
	var/helmet_type = /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate

/datum/equipment_preset/goon/New()
	. = ..()
	access = get_access(ACCESS_LIST_WY_GOON)

/datum/equipment_preset/goon/load_vanity(mob/living/carbon/human/new_human)
	return

/datum/equipment_preset/goon/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(MALE, FEMALE)

	var/datum/preferences/A = new()
	A.randomize_appearance(new_human)

	var/random_name
	var/first_name
	var/last_name
	//gender checks
	if(new_human.gender == MALE)
		first_name = "[pick(GLOB.first_names_male_pmc)]"
		new_human.f_style = pick("3 O'clock Shadow", "3 O'clock Moustache", "5 O'clock Shadow", "5 O'clock Moustache")
	else
		first_name = "[pick(GLOB.first_names_female_pmc)]"
	last_name = "[pick(GLOB.last_names_pmc)]"
	random_name = "[first_name] [last_name]"
	new_human.change_real_name(new_human, random_name)

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

/datum/equipment_preset/goon/load_id(mob/living/carbon/human/new_human, client/mob_client)
	var/obj/item/clothing/under/uniform = new_human.w_uniform
	if(istype(uniform))
		uniform.has_sensor = UNIFORM_HAS_SENSORS
	return ..()


/datum/equipment_preset/goon/standard
	name = "Weyland-Yutani Corporate Security Goon"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_WY_GOON
	rank = JOB_WY_GOON
	paygrades = list(PAY_SHORT_CPO = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/wy_goon
	minimap_icon = "goon_standard"

/datum/equipment_preset/goon/standard/kutjevo
	name = "Weyland-Yutani Corporate Security Goon (Kutjevo Camo)"
	uniform_type = /obj/item/clothing/under/marine/veteran/pmc/corporate/kutjevo
	helmet_type = /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/kutjevo

/datum/equipment_preset/goon/standard/hybrisa
	name = "Weyland-Yutani Corporate Security Goon (Hybrisa Camo)"
	uniform_type = /obj/item/clothing/under/marine/veteran/pmc/corporate/hybrisa
	helmet_type = /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/hybrisa

/datum/equipment_preset/goon/standard/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new uniform_type, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new helmet_type, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate/knife, WEAR_FEET)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/baton, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs/zip, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs/zip, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs/zip, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/wy, WEAR_IN_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/wy/mod88, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/wy, WEAR_R_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/corporate, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/wy, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_BACK)

/datum/equipment_preset/goon/engineer
	name = "Weyland-Yutani Corporate Security Technician"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_WY_GOON_TECH
	rank = JOB_WY_GOON_TECH
	paygrades = list(PAY_SHORT_CPO = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/wy_goon_tech
	minimap_icon = "goon_engi"
	uniform_type = /obj/item/clothing/under/marine/veteran/pmc/corporate/engineer
	helmet_type = /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/engi

/datum/equipment_preset/goon/engineer/kutjevo
	name = "Weyland-Yutani Corporate Security Technician (Kutjevo Camo)"
	uniform_type = /obj/item/clothing/under/marine/veteran/pmc/corporate/kutjevo
	helmet_type = /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/kutjevo

/datum/equipment_preset/goon/engineer/hybrisa
	name = "Weyland-Yutani Corporate Security Technician (Hybrisa Camo)"
	uniform_type = /obj/item/clothing/under/marine/veteran/pmc/corporate/hybrisa
	helmet_type = /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/hybrisa

/datum/equipment_preset/goon/engineer/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new uniform_type, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new helmet_type, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate/knife, WEAR_FEET)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/baton, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/wy, WEAR_IN_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/wy, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full/wy, WEAR_L_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/corporate, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_JACKET)


/datum/equipment_preset/goon/medic
	name = "Weyland-Yutani Corporate Security Medic"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_WY_GOON_MEDIC
	rank = JOB_WY_GOON_MEDIC
	paygrades = list(PAY_SHORT_CPO = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/wy_goon_medic
	minimap_icon = "goon_med"
	uniform_type = /obj/item/clothing/under/marine/veteran/pmc/corporate/medic
	helmet_type = /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/medic

/datum/equipment_preset/goon/medic/kutjevo
	name = "Weyland-Yutani Corporate Security Medic (Kutjevo Camo)"
	uniform_type = /obj/item/clothing/under/marine/veteran/pmc/corporate/kutjevo
	helmet_type = /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/kutjevo/medic

/datum/equipment_preset/goon/medic/hybrisa
	name = "Weyland-Yutani Corporate Security Medic (Hybrisa Camo)"
	uniform_type = /obj/item/clothing/under/marine/veteran/pmc/corporate/hybrisa
	helmet_type = /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/hybrisa/medic

/datum/equipment_preset/goon/medic/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new uniform_type, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/medic, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new helmet_type, WEAR_HEAD)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate/knife, WEAR_FEET)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/baton, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs/zip, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs/zip, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs/zip, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/surgical_case/regular, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/wy, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator(new_human), WEAR_IN_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_suture_and_graft, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/wy, WEAR_R_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/corporate, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/wy, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap, WEAR_IN_BACK)


/datum/equipment_preset/goon/lead
	name = "Weyland-Yutani Corporate Security Lead"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_WY_GOON_LEAD
	rank = JOB_WY_GOON_LEAD
	paygrades = list(PAY_SHORT_CSPO = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/wy_goon_lead
	minimap_icon = "goon_leader"
	uniform_type = /obj/item/clothing/under/marine/veteran/pmc/corporate/lead
	helmet_type = /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/lead

/datum/equipment_preset/goon/lead/kutjevo
	name = "Weyland-Yutani Corporate Security Lead (Kutjevo Camo)"
	uniform_type = /obj/item/clothing/under/marine/veteran/pmc/corporate/kutjevo/lead
	helmet_type = /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/kutjevo

/datum/equipment_preset/goon/lead/hybrisa
	name = "Weyland-Yutani Corporate Security Lead (Hybrisa Camo)"
	uniform_type = /obj/item/clothing/under/marine/veteran/pmc/corporate/hybrisa/lead
	helmet_type = /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/hybrisa/lead

/datum/equipment_preset/goon/lead/New()
	. = ..()
	access = get_access(ACCESS_LIST_WY_GOON) + list(ACCESS_WY_LEADERSHIP)

/datum/equipment_preset/goon/lead/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new uniform_type, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/lead, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new helmet_type, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate/knife, WEAR_FEET)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/baton, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs/zip, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs/zip, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs/zip, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/wy, WEAR_IN_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/wy/mod88, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/wy, WEAR_R_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/nsg23, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/wy/nsg_ap, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/nsg23/ap, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/nsg23/ap, WEAR_IN_BACK)

/datum/equipment_preset/goon/researcher
	name = "Weyland-Yutani Corporate Research Consultant"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_WY_RESEARCHER
	rank = JOB_WY_RESEARCHER
	paygrades = list(PAY_SHORT_CDOC = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/researcher
	minimap_icon = "goon_sci"

/datum/equipment_preset/goon/researcher/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular/hippie, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/detective/grey, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/wy, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/folder/white, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex, WEAR_HANDS)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/es4, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/es4, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/es4, WEAR_IN_ACCESSORY)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/reagent_scanner/adv, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/surgical, WEAR_IN_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/compact, WEAR_WAIST)

	var/obj/item/spacecash/bundle/money = new /obj/item/spacecash/bundle
	money.worth = 5000
	money.update_icon()

	new_human.equip_to_slot_or_del(money, WEAR_IN_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full/wy, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/wy/full_advanced, WEAR_L_STORE)

/datum/equipment_preset/goon/researcher/lead
	name = "Weyland-Yutani Corporate Research Consultant (Lead)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_WY_RESEARCH_LEAD
	rank = JOB_WY_RESEARCH_LEAD
	paygrades = list(PAY_SHORT_CCMO = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/researcher
	minimap_icon = "goon_sci_lead"
