/datum/equipment_preset/cmb
	name = "Colonial Marshal"
	faction = FACTION_MARSHAL
	faction_group = list(FACTION_MARSHAL, FACTION_MARINE)
	rank = JOB_CMB
	idtype = /obj/item/card/id/deputy
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	var/human_versus_human = FALSE
	var/headset_type = /obj/item/device/radio/headset/distress/CMB

/datum/equipment_preset/cmb/New()
	. = ..()
	access = get_access(ACCESS_LIST_UA)

/datum/equipment_preset/cmb/load_name(mob/living/carbon/human/new_human)
	new_human.gender = pick(80;MALE,20;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(new_human)
	var/random_name
	random_name = capitalize(pick(new_human.gender == MALE ? GLOB.first_names_male : GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
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

/datum/equipment_preset/cmb/load_id(mob/living/carbon/human/new_human, client/mob_client)
	if(human_versus_human)
		var/obj/item/clothing/under/uniform = new_human.w_uniform
		if(istype(uniform))
			uniform.has_sensor = UNIFORM_HAS_SENSORS
			uniform.sensor_faction = FACTION_MARINE
	return ..()

//*****************************************************************************************************/

/datum/equipment_preset/cmb/standard
	name = "CMB - Colonial Marshal Deputy"
	paygrade = PAY_SHORT_CMBD
	role_comm_title = "CMB DEP"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "CMB Deputy"
	rank = JOB_CMB
	skills = /datum/skills/cmb

/datum/equipment_preset/cmb/standard/load_gear(mob/living/carbon/human/new_human)

	var/choice = rand(1,10)
	new_human.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/CM_uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/CMB/full, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/CMB, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/holdout, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/camera, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/taperecorder, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)

	switch(choice)
		if(1 to 6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/cmb, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs/zip, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/flashbang, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/large, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/beanbag, WEAR_IN_R_STORE)
		if(7 to 8)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs/zip, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge/rubber, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/large, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/beanbag, WEAR_IN_R_STORE)
		if(9 to 10)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/cmb, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs/zip, WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector, WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5, WEAR_IN_R_STORE)


//*****************************************************************************************************/

/datum/equipment_preset/cmb/leader
	name = "CMB - The Colonial Marshal"
	paygrade = PAY_SHORT_CMBM
	idtype = /obj/item/card/id/marshal
	role_comm_title = "CMB MAR"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "CMB Marshal"
	rank = JOB_CMB_TL
	skills = /datum/skills/cmb/leader
	minimum_age = 30
	languages = ALL_HUMAN_LANGUAGES

/datum/equipment_preset/cmb/leader/load_gear(mob/living/carbon/human/new_human)
	//clothes
	new_human.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/CM_uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/cmb, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/cigar, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB/marshal, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb/m3717, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/CMB/full, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/CMB, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud, WEAR_EYES)
	//pouches
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/large, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot/incendiary, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/incendiary, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/beanbag, WEAR_IN_R_STORE)
	//backpack
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/holdout, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/m15/rubber, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/handheld_distress_beacon/cmb, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/camera, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/taperecorder, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)

//*****************************************************************************************************/
/datum/equipment_preset/cmb/synth
	name = "CMB - Colonial Marshal Investigative Synthetic"
	paygrade = PAY_SHORT_CMBS
	idtype = /obj/item/card/id/deputy
	role_comm_title = "CMB Syn"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "CMB Investigative Synthetic"
	rank = JOB_CMB_SYN
	languages = ALL_SYNTH_LANGUAGES

/datum/equipment_preset/cmb/synth/load_skills(mob/living/carbon/human/new_human)
		new_human.set_skills(/datum/skills/synthetic/cmb)
		new_human.allow_gun_usage = FALSE

/datum/equipment_preset/cmb/synth/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(50;MALE,50;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(new_human)
	var/random_name
	if(new_human.gender == MALE)
		random_name = "[pick(GLOB.first_names_male)]"
	else
		random_name = "[pick(GLOB.first_names_female)]"

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

/datum/equipment_preset/cmb/synth/load_race(mob/living/carbon/human/new_human)
	new_human.set_species(SYNTH_COLONY)

/datum/equipment_preset/cmb/synth/load_gear(mob/living/carbon/human/new_human)
	//backpack
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/security, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb/normalpoint, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/autopsy_scanner, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/camera, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/taperecorder, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	//face
	new_human.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/pen, WEAR_R_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/CMB, WEAR_HEAD)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/CM_uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/holobadge/cord, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/candy, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector, WEAR_J_STORE)
	//belt
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/CMB/synth, WEAR_WAIST)
	//holding
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full, WEAR_L_HAND)
	//pouches
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs/zip, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs/zip, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/flashbang, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/teargas, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/screwdriver/tactical, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/wirecutters/tactical, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/wrench, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/multitool, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/cable_coil, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/weldingtool/hugetank, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/weldingtool/hugetank, WEAR_IN_R_STORE)


//*****************************************************************************************************/

/datum/equipment_preset/cmb/liaison
	name = "CMB - ICC Liaison"
	paygrade = PAY_SHORT_ICCL
	idtype = /obj/item/card/id/silver/cl
	role_comm_title = "ICC Rep."
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "Interstellar Commerce Commission Corporate Liaison"
	rank = JOB_CMB_ICC
	skills = /datum/skills/civilian/survivor
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_SPANISH, LANGUAGE_JAPANESE)

/datum/equipment_preset/cmb/liaison/load_gear(mob/living/carbon/human/new_human)

	//clothes
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CMB/ICC, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/black, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/mod88, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/mod88, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/mod88, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/white, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/yellow, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/spray/pepper, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/folder/blue, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_J_STORE)
	//holding
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clipboard, WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses, WEAR_EYES)
	//pouches
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/wypacket, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/spacecash/c1000, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/spacecash/c1000, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/taperecorder, WEAR_IN_R_STORE)
	//backpack and stuff in it
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable/liaison, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/paper/carbon, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/paper/carbon, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/red, WEAR_IN_BACK)

/datum/equipment_preset/cmb/liaison/black_market
	name = "CMB - ICC Liaison - Black Market ERT"
	skills = /datum/skills/civilian/icc_investigation

/datum/equipment_preset/cmb/liaison/black_market/load_gear(mob/living/carbon/human/new_human)
	. = ..()
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full, WEAR_WAIST) //Tool belt to open ASRS
	new_human.equip_to_slot_or_del(new /obj/item/device/cmb_black_market_tradeband, WEAR_IN_BACK) //Tradeband to disable black market

//*****************************************************************************************************/

/datum/equipment_preset/cmb/observer
	name = "CMB - Interstellar Human Rights Observer"
	paygrade = PAY_SHORT_IHRO
	idtype = /obj/item/card/id/lanyard
	role_comm_title = "OBS"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "Interstellar Human Rights Observer"
	rank = JOB_CMB_OBS
	skills = /datum/skills/civilian/survivor/doctor
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_SPANISH, LANGUAGE_RUSSIAN)

/datum/equipment_preset/cmb/observer/load_gear(mob/living/carbon/human/new_human)

	//clothes
	new_human.equip_to_slot_or_del(new headset_type, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/pen, WEAR_R_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/blue, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full, WEAR_WAIST)
	//holding
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/sensor, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/device/camera, WEAR_R_HAND)
	//pouches
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/spray/pepper, WEAR_IN_R_STORE)
	//backpack and stuff in it
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable/liaison, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/camera_film, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/clicky, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/paper/carbon, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/folder, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clipboard, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/taperecorder, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)


//############ Anchorpoint Station Colonial Marines - They serve as reinforcements for the Colonial Marshals of Anchorpoint Station. #############
//Anchorpoint Station Squad Marine - Similar to the Movie squad but nerfed a bit.

/datum/equipment_preset/uscm/cmb
	name = "USCM Anchorpoint Station Squad Marine"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

/datum/equipment_preset/uscm/cmb/New()
	. = ..()
	access = get_access(ACCESS_LIST_UA)

	assignment = "Anchorpoint Station Marine Rifleman"
	rank = JOB_SQUAD_MARINE
	paygrade = PAY_SHORT_ME2
	role_comm_title = "A-RFN"
	skills = /datum/skills/pfc/crafty
	faction = FACTION_MARSHAL
	faction_group = list(FACTION_MARSHAL, FACTION_MARINE)

/datum/equipment_preset/uscm/cmb/load_status(mob/living/carbon/human/new_human)
	. = ..()
	new_human.nutrition = rand(NUTRITION_MAX, NUTRITION_NORMAL)

/datum/equipment_preset/uscm/cmb/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/hp, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/rubber, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/helmet_gasmask, WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/emergency, WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/baton/cattleprod, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_box/rounds, WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/m94, WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1/anchorpoint/gl, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41amk1, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/high_explosive, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/high_explosive, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)

//Anchorpoint Station Marine Squad Leader

/datum/equipment_preset/uscm/cmb/leader
	name = "USCM Anchorpoint Station Team Leader"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
/datum/equipment_preset/uscm/cmb/leader/New()
	. = ..()

	assignment = "Anchorpoint Station Marine Team Leader"
	rank = JOB_SQUAD_LEADER
	paygrade = PAY_SHORT_ME6
	role_comm_title = "A-TL"
	minimum_age = 25
	skills = /datum/skills/SL

/datum/equipment_preset/uscm/cmb/leader/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/custom, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/hp, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/rubber, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/m37, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/sensor, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/leader, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/helmet_gasmask, WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/emergency, WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo/lead, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium/leader, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/m15, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1/anchorpoint, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_R_STORE) // he's collected the squad's supply of these magazines on request of OW
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/shotgun/buckshot, WEAR_L_HAND)

//Anchorpoint Station Marine RTO - technical specialist, has the responsibility of engineering as well
/datum/equipment_preset/uscm/cmb/rto
	name = "USCM Anchorpoint Station Technical Specialist"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
/datum/equipment_preset/uscm/cmb/rto/New()
	. = ..()

	assignment = "Anchorpoint Station Marine Technical Specialist"
	rank = JOB_SQUAD_TEAM_LEADER
	paygrade = PAY_SHORT_ME4
	role_comm_title = "A-TS"
	skills = /datum/skills/tl

/datum/equipment_preset/uscm/cmb/rto/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/rto, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/hp, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/rubber, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/rto, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/helmet_gasmask, WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/emergency, WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding/superior, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo/tl, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium/rto, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range/designator, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/rto, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector, WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1/anchorpoint, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/mini, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic/breaching_charge, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)

//Anchorpoint Station Corpsman
/datum/equipment_preset/uscm/cmb/medic
	name = "USCM Anchorpoint Station Corpsman"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
/datum/equipment_preset/uscm/cmb/medic/New()
	. = ..()

	assignment = "Anchorpoint Station Hospital Corpsman"
	rank = JOB_SQUAD_MEDIC
	paygrade = PAY_SHORT_ME3
	role_comm_title = "A-HM"
	skills = /datum/skills/combat_medic

	utility_under = list(/obj/item/clothing/under/marine/medic)

/datum/equipment_preset/uscm/cmb/medic/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/medic, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/hp, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/rubber, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/medic, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/prop/helmetgarb/helmet_gasmask, WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/emergency, WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_HELMET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo/med, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/medic, WEAR_BACK)
	if(prob(50))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/adrenaline, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/adrenaline, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/emergency, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/emergency, WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/bodybag/cryobag, WEAR_IN_BELT)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription, WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1/anchorpoint, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1/ap, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/imidazoline, WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full, WEAR_R_STORE)

//Anchorpoint Station Marine Smartgunnner
/datum/equipment_preset/uscm/cmb/smartgunner
	name = "USCM Anchorpoint Station Smartgunner"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
/datum/equipment_preset/uscm/cmb/smartgunner/New()
	. = ..()

	assignment = "Anchorpoint Station Marine Smartgunner"
	rank = JOB_SQUAD_SMARTGUN
	paygrade = PAY_SHORT_ME3
	role_comm_title = "A-SG"
	skills = /datum/skills/smartgunner

/datum/equipment_preset/uscm/cmb/smartgunner/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3/custom, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/hp, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/rubber, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch, WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/smartgunner, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/smartgunner/full/, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/headband/red, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles, WEAR_EYES)
