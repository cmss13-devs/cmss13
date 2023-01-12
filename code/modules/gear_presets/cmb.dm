/datum/equipment_preset/CMB
	name = "Colonial Marshal"

	assignment = "CMB Deputy"
	rank = JOB_CMB
	idtype = /obj/item/card/id/data
	faction = FACTION_CMB

/datum/equipment_preset/CMB/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()

/datum/equipment_preset/CMB/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(80;MALE,20;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
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
	idtype = /obj/item/card/id/general
	if(H.gender == MALE)
		random_name = "[pick(first_names_male)] [pick(last_names)]"
		H.h_style = pick("Crewcut", "Shaved Head", "Buzzcut", "Undercut", "Side Undercut", "Pvt. Joker", "Marine Fade", "Low Fade", "Medium Fade", "High Fade", "No Fade", "Coffee House Cut", "Flat Top",)
		H.f_style = pick("5 O'clock Shadow", "Shaved", "Full Beard", "3 O'clock Moustache", "5 O'clock Shadow", "5 O'clock Moustache", "7 O'clock Shadow", "7 O'clock Moustache",)
	else
		random_name = "[pick(first_names_female)] [pick(last_names)]"
		H.h_style = pick("Ponytail 1", "Ponytail 2", "Ponytail 3", "Ponytail 4", "Pvt. Redding", "Pvt. Clarison", "Cpl. Dietrich", "Pvt. Vasquez", "Marine Bun", "Marine Bun 2", "Marine Flat Top",)
	H.change_real_name(H, random_name)
	H.age = rand(20,45)
	H.r_hair = rand(15,35)
	H.g_hair = rand(15,35)
	H.b_hair = rand(25,45)

//*****************************************************************************************************/

/datum/equipment_preset/CMB
	name = "Colonial Marshal"
	faction = FACTION_CMB
	rank = JOB_CMB
	idtype = /obj/item/card/id/data
	faction = FACTION_CMB
	faction_group = list(FACTION_LIST_MARINE_CMB)
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_SPANISH, LANGUAGE_RUSSIAN)
	var/human_versus_human = FALSE
	var/headset_type = /obj/item/device/radio/headset/distress/CMB

/datum/equipment_preset/CMB/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()


/datum/equipment_preset/dust_raider/load_name(mob/living/carbon/human/H)
	H.gender = pick(70;MALE,30;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	random_name = capitalize(pick(H.gender == MALE ? first_names_male : first_names_female)) + " " + capitalize(pick(last_names))
	H.change_real_name(H, random_name)
	H.name = H.real_name
	H.age = rand(22,45)

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
	if(H.gender == MALE)
		H.h_style = pick("Crewcut", "Shaved Head", "Buzzcut", "Undercut", "Side Undercut", "Pvt. Joker", "Marine Fade", "Low Fade", "Medium Fade", "High Fade", "No Fade", "Coffee House Cut", "Flat Top",)
		H.f_style = pick("5 O'clock Shadow", "Shaved", "Full Beard", "3 O'clock Moustache", "5 O'clock Shadow", "5 O'clock Moustache", "7 O'clock Shadow", "7 O'clock Moustache",)
	else
		H.h_style = pick("Ponytail 1", "Ponytail 2", "Ponytail 3", "Ponytail 4", "Pvt. Redding", "Pvt. Clarison", "Cpl. Dietrich", "Pvt. Vasquez", "Marine Bun", "Marine Bun 2", "Marine Flat Top",)
	H.change_real_name(H, random_name)
	H.age = rand(20,45)
	H.r_hair = rand(15,35)
	H.g_hair = rand(15,35)
	H.b_hair = rand(25,45)

/datum/equipment_preset/CMB/load_id(mob/living/carbon/human/H, client/mob_client)
	if(human_versus_human)
		var/obj/item/clothing/under/uniform = H.w_uniform
		if(istype(uniform))
			uniform.has_sensor = UNIFORM_HAS_SENSORS
			uniform.sensor_faction = FACTION_CMB
	return ..()

//*****************************************************************************************************/

/datum/equipment_preset/CMB/standard
	name = "CMB - Colonial Marshal Deputy"
	paygrade = "GS-9"
	role_comm_title = "CMB DEP"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "CMB Deputy"
	rank = JOB_CMB
	skills = /datum/skills/CMB
	faction = FACTION_CMB
	faction_group = list(FACTION_LIST_MARINE_CMB)

/datum/equipment_preset/CMB/standard/load_gear(mob/living/carbon/human/H)

	var/choice = rand(1,10)
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/CM_uniform, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/telebaton, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/CMB/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/centcom/officer, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/holdout, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/camera, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)

	switch(choice)
		if(1 to 6)
			H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/cmb, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/handcuffs/zip, WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/explosive/grenade/flashbang, WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/large, WEAR_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/beanbag, WEAR_IN_R_STORE)
		if(7 to 8)
			H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/highpower, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/handcuffs/zip, WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/large, WEAR_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/beanbag, WEAR_IN_R_STORE)
		if(9 to 10)
			H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/cmb, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_ACCESSORY)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/handcuffs/zip, WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/device/motiondetector, WEAR_L_HAND)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)


//*****************************************************************************************************/

/datum/equipment_preset/CMB/leader
	name = "CMB - The Colonial Marshal"
	paygrade = "GS-13"
	role_comm_title = "CMB MAR"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "CMB Marshal"
	rank = JOB_CMB_TL
	skills = /datum/skills/CMB/leader
	faction = FACTION_CMB
	faction_group = list(FACTION_LIST_MARINE_CMB)

/datum/equipment_preset/CMB/leader/load_gear(mob/living/carbon/human/H)
	//clothes
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/CM_uniform, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/cmb, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/cigar, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/telebaton, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb/m3717, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/CMB/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/centcom/officer, WEAR_HEAD) //placeholder
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud, WEAR_EYES)
	//pouches
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot/incendiary, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/incendiary, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/beanbag, WEAR_IN_R_STORE)
	//backpack
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/holdout, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/camera, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)

//*****************************************************************************************************/
/datum/equipment_preset/CMB/synth
	name = "CMB - Colonial Marshal Investigative Synthetic"
	paygrade = "GS-C.9"
	role_comm_title = "CMB SYN"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "CMB Investigative Synthetic"
	rank = JOB_CMB_SYN
	faction = FACTION_CMB
	faction_group = list(FACTION_LIST_MARINE_CMB)
	languages = ALL_SYNTH_LANGUAGES

/datum/equipment_preset/CMB/synth/load_skills(mob/living/carbon/human/H)
		H.set_skills(/datum/skills/synthetic)
		H.allow_gun_usage = FALSE

/datum/equipment_preset/CMB/synth/load_name(mob/living/carbon/human/H, var/randomise)
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

/datum/equipment_preset/CMB/synth/load_race(mob/living/carbon/human/H)
	H.set_species(SYNTH_COLONY)

/datum/equipment_preset/CMB/synth/load_gear(mob/living/carbon/human/H)
	load_name(H)
	//backpack
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/security, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/flashbang, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/camera, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen, WEAR_R_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/centcom/officer, WEAR_HEAD)
	//uniform
	H.equip_to_slot_or_del(new /obj/item/clothing/under/CM_uniform, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/telebaton, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector, WEAR_J_STORE)
	//belt
	H.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/CMB/synth, WEAR_WAIST)
	//holding
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full, WEAR_L_HAND)
	//pouches
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/handcuffs/zip, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/handcuffs/zip, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/handcuffs/zip, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/handcuffs/zip, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/screwdriver/tactical, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/wirecutters/tactical, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/wrench, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/multitool, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/stack/cable_coil, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/weldingtool/hugetank, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/weldingtool/hugetank, WEAR_IN_R_STORE)


//*****************************************************************************************************/

/datum/equipment_preset/CMB/liaison
	name = "CMB - ICC Liaison"
	paygrade = "GS-6"
	idtype = /obj/item/card/id/silver/cl
	role_comm_title = "ICC Rep."
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "Interstellar Commerce Commission Corporate Liaison"
	rank = JOB_CMB_ICC
	skills = /datum/skills/civilian/survivor
	faction = FACTION_CMB
	faction_group = list(FACTION_LIST_MARINE_CMB)

/datum/equipment_preset/CMB/liaison/load_gear(mob/living/carbon/human/H)

    //clothes
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CMB/ICC, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/formal, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/mod88, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/mod88, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/mod88, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/white, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/yellow, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_J_STORE)
	//holding
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses, WEAR_EYES)
	//pouches
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/wypacket, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/spacecash/c1000, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/spacecash/c1000, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder, WEAR_IN_R_STORE)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable/liaison, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/spray/pepper, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/pen/clicky, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/paper/carbon, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/paper/carbon, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/folder/blue, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clipboard, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar/red, WEAR_IN_BACK)


//*****************************************************************************************************/

/datum/equipment_preset/CMB/observer
	name = "CMB - Interstellar Human Rights Observer"
	paygrade = "GS-3"
	role_comm_title = "OBS"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "Interstellar Human Rights Observer"
	rank = JOB_CMB_OBS
	skills = /datum/skills/civilian/survivor/doctor
	faction = FACTION_CMB
	faction_group = list(FACTION_LIST_MARINE_CMB)

/datum/equipment_preset/CMB/observer/load_gear(mob/living/carbon/human/H)

    //clothes
	H.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen, WEAR_R_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/suspenders, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full, WEAR_WAIST)
	//holding
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/sensor, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/device/camera, WEAR_R_HAND)
	//pouches
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/spray/pepper, WEAR_IN_R_STORE)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable/liaison, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/camera_film, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/pen/clicky, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/paper/carbon, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/folder, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clipboard, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
