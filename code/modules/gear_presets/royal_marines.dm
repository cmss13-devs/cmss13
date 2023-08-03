/datum/equipment_preset/royal_marine
	name = "Royal Marines"

	assignment = "Royal Marine"
	rank = JOB_TWE_RMC_RIFLEMAN
	idtype = /obj/item/card/id/dogtag
	faction = FACTION_TWE

/datum/equipment_preset/royal_marine/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(80;MALE,20;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(new_human)
	var/random_name
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
	idtype = /obj/item/card/id/data
	if(new_human.gender == MALE)
		random_name = "[pick(first_names_male)] [pick(last_names)]"
		new_human.h_style = pick("Crewcut", "Shaved Head", "Buzzcut", "Undercut", "Side Undercut", "Pvt. Joker", "Marine Fade", "Low Fade", "Medium Fade", "High Fade", "No Fade", "Coffee House Cut", "Flat Top",)
		new_human.f_style = pick("5 O'clock Shadow", "Shaved", "Full Beard", "3 O'clock Moustache", "5 O'clock Shadow", "5 O'clock Moustache", "7 O'clock Shadow", "7 O'clock Moustache",)
	else
		random_name = "[pick(first_names_female)] [pick(last_names)]"
		new_human.h_style = pick("Ponytail 1", "Ponytail 2", "Ponytail 3", "Ponytail 4", "Pvt. Redding", "Pvt. Clarison", "Cpl. Dietrich", "Pvt. Vasquez", "Marine Bun", "Marine Bun 2", "Marine Flat Top",)
	new_human.change_real_name(new_human, random_name)
	new_human.age = rand(20,45)
	new_human.r_hair = rand(15,35)
	new_human.g_hair = rand(15,35)
	new_human.b_hair = rand(25,45)

//*****************************************************************************************************/

/datum/equipment_preset/royal_marine
	name = "Royal Marine Commando"
	faction = FACTION_TWE
	rank = JOB_TWE_RMC_RIFLEMAN
	faction = FACTION_TWE
	faction_group = FACTION_LIST_ERT
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	var/human_versus_human = FALSE
	var/headset_type = /obj/item/device/radio/headset/distress/royal_marine

/datum/equipment_preset/royal_marine/load_name(mob/living/carbon/human/new_human)
	new_human.gender = pick(60;MALE,40;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(new_human)
	var/random_name
	random_name = capitalize(pick(new_human.gender == MALE ? first_names_male : first_names_female)) + " " + capitalize(pick(last_names))
	new_human.change_real_name(new_human, random_name)
	new_human.name = new_human.real_name
	new_human.age = rand(22,45)

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
	idtype = /obj/item/card/id/data
	if(new_human.gender == MALE)
		new_human.h_style = pick("Crewcut", "Shaved Head", "Buzzcut", "Undercut", "Side Undercut", "Pvt. Joker", "Marine Fade", "Low Fade", "Medium Fade", "High Fade", "No Fade", "Coffee House Cut", "Flat Top",)
		new_human.f_style = pick("5 O'clock Shadow", "Shaved", "Full Beard", "3 O'clock Moustache", "5 O'clock Shadow", "5 O'clock Moustache", "7 O'clock Shadow", "7 O'clock Moustache",)
	else
		new_human.h_style = pick("Ponytail 1", "Ponytail 2", "Ponytail 3", "Ponytail 4", "Pvt. Redding", "Pvt. Clarison", "Cpl. Dietrich", "Pvt. Vasquez", "Marine Bun", "Marine Bun 2", "Marine Flat Top",)
	new_human.change_real_name(new_human, random_name)
	new_human.age = rand(20,45)
	new_human.r_hair = rand(15,35)
	new_human.g_hair = rand(15,35)
	new_human.b_hair = rand(25,45)

/datum/equipment_preset/royal_marine/load_id(mob/living/carbon/human/new_human, client/mob_client)
	if(human_versus_human)
		var/obj/item/clothing/under/uniform = new_human.w_uniform
		if(istype(uniform))
			uniform.has_sensor = UNIFORM_HAS_SENSORS
			uniform.sensor_faction = FACTION_TWE
	return ..()

//*****************************************************************************************************/

/datum/equipment_preset/royal_marine/standard
	name = "RMC TWE Royal Marine Commando (Rifleman)"
	paygrade = "TC1"
	role_comm_title = "RMC"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Royal Marine Rifleman"
	rank = JOB_TWE_RMC_RIFLEMAN
	skills = /datum/skills/rmc/rifleman
	faction = FACTION_TWE

/datum/equipment_preset/royal_marine/standard/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/royal_marine, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/royal_marines, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/royal_marine/light, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/rmc/rmc_f90_ammo, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/royal_marine, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/royal_marine, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/royal_marine/knife, WEAR_FEET)
	//
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/rmc/heavy, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/surgical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/compact, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK)
	//
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/rmc_f90, WEAR_J_STORE)
	//
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)
	//
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/royal_marine, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/royal_marine, WEAR_FACE)

//*****************************************************************************************************/

/datum/equipment_preset/royal_marine/spec
	name = "RMC TWE Royal Marine Commando (Marksman)"
	paygrade = "TC2"
	role_comm_title = "RMC"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Royal Marine Marksman"
	rank = JOB_TWE_RMC_SPECIALIST
	skills = /datum/skills/rmc/specialist

/datum/equipment_preset/royal_marine/spec/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/royal_marine, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/royal_marines, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/royal_marine/light, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/rmc/rmc_f90_ammo/marksman, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/royal_marine, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/royal_marine, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/royal_marine/knife, WEAR_FEET)
	//
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/rmc/medium, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/surgical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/compact, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK)
	//
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/rmc_f90/scope, WEAR_J_STORE)
	//
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)
	//
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/royal_marine, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/royal_marine, WEAR_FACE)

//*****************************************************************************************************/

/datum/equipment_preset/royal_marine/spec/breacher
	name = "RMC TWE Royal Marine Commando (Breacher)"
	paygrade = "TC2"
	role_comm_title = "RMC"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Royal Marine Breacher"
	rank = JOB_TWE_RMC_SPECIALIST
	skills = /datum/skills/rmc/specialist

/datum/equipment_preset/royal_marine/spec/breacher/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/royal_marine, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/royal_marines, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/royal_marine/pointman, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/rmc/rmc_f90_ammo, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/royal_marine, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/royal_marine, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/royal_marine/knife, WEAR_FEET)
	//
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/rmc/medium, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/surgical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/compact, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK)
	//
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/rmc_f90/shotgun, WEAR_J_STORE)
	//
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)
	//
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/royal_marine, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/royal_marine, WEAR_FACE)

//*****************************************************************************************************/
/datum/equipment_preset/royal_marine/spec/machinegun
	name = "RMC TWE Royal Marine Commando (Smartgunner)"
	paygrade = "TC2"
	role_comm_title = "RMC"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Royal Marine Smartgunner"
	rank = JOB_TWE_RMC_SPECIALIST
	skills = /datum/skills/rmc/specialist

/datum/equipment_preset/royal_marine/spec/machinegun/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/royal_marine, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/royal_marines, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/royal_marine/medium, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/l905/full, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/royal_marine, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/royal_marine, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/royal_marine/knife, WEAR_FEET)
	//
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/rmc/medium, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/surgical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/compact, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK)
	//
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun/rmc, WEAR_J_STORE)
	//
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)
	//
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/royal_marine, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/royal_marine, WEAR_FACE)
	new_human.equip_to_slot(new /obj/item/smartgun_battery(new_human), WEAR_IN_BACK)


//*****************************************************************************************************/
/datum/equipment_preset/royal_marine/team_leader
	name = "RMC TWE Royal Marine Commando (Teamleader)"
	paygrade = "TC4"
	role_comm_title = "RMC"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Royal Marine Team Leader"
	rank = JOB_TWE_RMC_TEAMLEADER
	skills = /datum/skills/rmc/leader

/datum/equipment_preset/royal_marine/team_leader/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/royal_marine/tl, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/royal_marines, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/royal_marine/light/team_leader, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/l905/full, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/royal_marine, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/royal_marine/team_leader, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/royal_marine/knife, WEAR_FEET)
	//
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/rmc/light, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/surgical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/compact, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK)
	//
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/rmc_f90/a_grip, WEAR_J_STORE)
	//
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)
	//
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/royal_marine/team_lead, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/royal_marine, WEAR_IN_ACCESSORY)

//*****************************************************************************************************/

/datum/equipment_preset/royal_marine/lieuteant //they better say it Lef-tenant or they should be banned for LRP
	name = "RMC TWE Royal Marine Commando (Officer)"
	paygrade = "TO1"
	role_comm_title = "RMC"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Royal Marine Officer"
	rank = JOB_TWE_RMC_LIEUTENANT
	skills = /datum/skills/rmc/leader

/datum/equipment_preset/royal_marine/lieuteant/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/royal_marine/lt, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/royal_marines, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/royal_marine/light/team_leader, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/l905/full, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/royal_marine, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/royal_marine/team_leader, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/royal_marine/knife, WEAR_FEET)
	//
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/rmc/light, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/surgical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/compact, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/rmc_f90, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/rmc_f90, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/rmc_f90, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/rmc_f90, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/rmc_f90, WEAR_IN_BACK)
	//
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/rmc_f90/a_grip, WEAR_J_STORE)
	//
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)
	//
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/royal_marine, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/royal_marine, WEAR_IN_ACCESSORY)
