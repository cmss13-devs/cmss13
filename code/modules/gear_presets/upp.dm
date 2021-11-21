/datum/equipment_preset/upp
	name = FACTION_UPP

	languages = list("Russian", "English")
	faction = FACTION_UPP
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/upp/New()
	. = ..()
	access = get_antagonist_access()

/datum/equipment_preset/upp/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(60;MALE,40;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(first_names_male_upp)] [pick(last_names_upp)]"
		H.f_style = "5 O'clock Shadow"
	else
		random_name = "[pick(first_names_female_upp)] [pick(last_names_upp)]"

	H.change_real_name(H, random_name)
	H.age = rand(17,35)
	H.h_style = "Shaved Head"
	H.r_hair = 15
	H.g_hair = 15
	H.b_hair = 25
	H.r_eyes = 139
	H.g_eyes = 62
	H.b_eyes = 19
	idtype = /obj/item/card/id/dogtag

//*****************************************************************************************************/

/datum/equipment_preset/upp/soldier
	name = "UPP Soldier"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp
	assignment = JOB_UPP
	rank = JOB_UPP
	role_comm_title = "Sol"
	paygrade = "UE1"

/datum/equipment_preset/upp/soldier/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	H.equip_to_slot_or_del(UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)

	load_upp_soldier(H, UPP)

/datum/equipment_preset/upp/soldier/proc/load_upp_soldier(mob/living/carbon/human/H, obj/item/clothing/under/marine/veteran/UPP/UPP)
	var/percentage = rand(1, 100)
	switch(percentage)
		//most UPP are rifleman, most others are breachers, some have both primaries.
		if(1 to 66)
			load_upp_rifleman(H, UPP)
		if(67 to 85)
			load_upp_breacher(H, UPP)
		else
			load_upp_double(H, UPP)

/datum/equipment_preset/upp/soldier/proc/load_upp_rifleman(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //.75
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //1.5
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_BACK) //2.25
	H.equip_to_slot_or_del(new /obj/item/storage/box/m94, WEAR_IN_BACK) //3.25
	H.equip_to_slot_or_del(new /obj/item/storage/box/m94, WEAR_IN_BACK) //4.25
	//body
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/rifleman, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp/full, WEAR_WAIST)
	//rpocket
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_R_STORE)
	//lpocket
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)

/datum/equipment_preset/upp/soldier/proc/load_upp_breacher(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //.75
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //1.5
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini, WEAR_IN_BACK) //2.25
	H.equip_to_slot_or_del(new /obj/item/storage/box/m94, WEAR_IN_BACK) //3.25
	H.equip_to_slot_or_del(new /obj/item/storage/box/m94, WEAR_IN_BACK) //4.25
	//waist
	var/gunbelt = prob(50) ? /obj/item/storage/belt/gun/type47/NY : /obj/item/storage/belt/gun/type47/PK9
	H.equip_to_slot_or_del(new gunbelt, WEAR_WAIST)
	pick_ammotype(H)

/datum/equipment_preset/upp/soldier/proc/pick_ammotype(mob/living/carbon/human/H)
	var/percentage = rand(1, 100)
	switch(percentage)
		if(1 to 33)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/type23/breacher, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/heavybuck, WEAR_L_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/heavybuck, WEAR_R_STORE)
		if(34 to 66)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/type23/breacher/slug, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/heavyslug, WEAR_L_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/heavyslug, WEAR_R_STORE)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/type23/breacher/flechette, WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/heavyflechette, WEAR_L_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/heavyflechette, WEAR_R_STORE)

/datum/equipment_preset/upp/soldier/proc/load_upp_double(mob/living/carbon/human/H, obj/item/clothing/under/marine/veteran/UPP/UPP)
	//back
	var/rifle = prob(50) ? /obj/item/weapon/gun/rifle/type71/dual : /obj/item/weapon/gun/rifle/type71/carbine/dual
	H.equip_to_slot_or_del(new rifle, WEAR_BACK)
	//body
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/type23/dual, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp/full, WEAR_WAIST)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/heavybuck, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/upp/medic
	name = "UPP Medic"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/combat_medic
	assignment = JOB_UPP_MEDIC
	rank = JOB_UPP_MEDIC
	role_comm_title = "Med"
	paygrade = "UE3M"

/datum/equipment_preset/upp/medic/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator/compact, WEAR_IN_BACK) //1
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK) //2
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK) //2.33
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //2.66
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //3
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //3.33
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap, WEAR_HEAD)
	//body
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/medic, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/tricordrazine, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/skorpion/upp/medic, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//póckets
	var/obj/item/storage/pouch/magazine/pistol/large/ppouch = new()
	H.equip_to_slot_or_del(ppouch, WEAR_R_STORE)
	for(var/i = 1 to ppouch.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/skorpion, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new/obj/item/storage/pouch/medical/full, WEAR_L_STORE)

/datum/equipment_preset/upp/sapper
	name = "UPP Sapper"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/combat_engineer
	assignment = JOB_UPP_ENGI
	rank = JOB_UPP_ENGI
	role_comm_title = "Sap"
	paygrade = "UE3S"

/datum/equipment_preset/upp/sapper/load_gear(mob/living/carbon/human/H)
	//Sappers should have lots of gear and whatnot that helps them attack or siege marines
	//But that'll need a lot of effort so for now they are just soldiers with a toolbox.
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //.33
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //.66
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked, WEAR_IN_BACK) //1.66
	H.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/mini, WEAR_IN_BACK) //2.66
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas, WEAR_FACE)
	//head
	var/headgear = prob(70) ? /obj/item/clothing/head/helmet/marine/veteran/UPP/engi : /obj/item/clothing/head/uppcap/ushanka
	H.equip_to_slot_or_del(new headgear, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/engi/UPP = new()
	var/obj/item/clothing/accessory/storage/black_vest/W = new()
	UPP.attach_accessory(H, W)
	W.hold.storage_slots = 7
	H.equip_to_slot_or_del(UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/tool/screwdriver, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/wrench, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/weldingtool, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/wirecutters, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/cable_coil, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/device/multitool, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/sapper, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp/sapper(H), WEAR_WAIST)
	//limb
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/upp/specialist
	name = "UPP Specialist"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/specialist
	assignment = JOB_UPP_SPECIALIST
	rank = JOB_UPP_SPECIALIST
	role_comm_title = "Spc"
	paygrade = "UE5"

/datum/equipment_preset/upp/specialist/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_BACK) //1
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //1.33
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //1.66
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_IN_BACK) //2
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_IN_BACK) //2.33
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_IN_BACK) //2.66
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP/heavy, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	H.equip_to_slot_or_del(UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, WEAR_JACKET)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)

	var/obj/item/device/internal_implant/subdermal_armor/implant = new()
	implant.on_implanted(H)

	load_specialist(H, UPP)

/datum/equipment_preset/upp/specialist/proc/load_specialist(mob/living/carbon/human/H, obj/item/clothing/under/marine/veteran/UPP/UPP)
	if(prob(50))
		//body
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/minigun/upp, WEAR_J_STORE)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun, WEAR_IN_JACKET)
		//waist
		H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/NY/shrapnel, WEAR_WAIST)
	else
		//body
		var/obj/item/clothing/accessory/storage/black_vest/W = new()
		UPP.attach_accessory(H, W)
		for(var/i in 1 to W.hold.storage_slots)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/heavy/dragonsbreath, WEAR_IN_ACCESSORY)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/type23/dragon, WEAR_J_STORE)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/heavy/dragonsbreath, WEAR_IN_JACKET)
		//waist
		H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/NY, WEAR_WAIST)

//*****************************************************************************************************/

/datum/equipment_preset/upp/leader
	name = "UPP Squad Leader"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/SL
	assignment = JOB_UPP_LEADER
	rank = JOB_UPP_LEADER
	role_comm_title = "SL"
	paygrade = "UE6"

/datum/equipment_preset/upp/leader/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/jima, WEAR_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	UPP.attach_accessory(H, W)
	H.equip_to_slot_or_del(UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/NY/shrapnel, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/flamertank, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/upp/military_police
	name = "UPP Military Police"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/military_police
	assignment = JOB_UPP_POLICE
	rank = JOB_UPP_POLICE
	role_comm_title = "MP"
	paygrade = "UE6"

/datum/equipment_preset/upp/military_police/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp, WEAR_FACE)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/UPP/mp/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)
	H.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_ACCESSORY)
	//jacket
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/mp, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/security/MP/UPP/full, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/taperecorder, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/upp/officer
	name = "UPP Lieutenant"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/officer
	assignment = JOB_UPP_LT_OFFICER
	rank = JOB_UPP_LT_OFFICER
	role_comm_title = "Lt."
	paygrade = "UO1"

/datum/equipment_preset/upp/officer/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/megaphone, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/UPP/officer/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)
	H.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_ACCESSORY)
	//jacket
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/officer, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer/leader, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/NY, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/upp/officer/senior
	name = "UPP Senior Lieutenant"
	assignment = JOB_UPP_SRLT_OFFICER
	rank = JOB_UPP_SRLT_OFFICER
	role_comm_title = "Sr-Lt."
	paygrade = "UO1E"

/datum/equipment_preset/upp/officer/senior/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/megaphone, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/UPP/officer/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)
	H.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_ACCESSORY)
	//jacket
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/officer, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer/leader, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/NY/shrapnel, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/upp/officer/major
	name = "UPP Major"
	assignment = JOB_UPP_MAY_OFFICER
	rank = JOB_UPP_MAY_OFFICER
	role_comm_title = "May."
	paygrade = "UO3"

/datum/equipment_preset/upp/officer/major/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/megaphone, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/peaked, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/UPP/officer/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)
	H.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_ACCESSORY)
	//jacket
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/kapitan, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer/leader, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/admiral/impact, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/upp/officer/kolonel
	name = "UPP Kolonel"
	assignment = JOB_UPP_KOL_OFFICER
	rank = JOB_UPP_KOL_OFFICER
	role_comm_title = "Kol."
	paygrade = "UO5"
	skills = /datum/skills/upp/commander

/datum/equipment_preset/upp/officer/kolonel/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/extinguisher, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/accessory/health/ceramic_plate, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/megaphone, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/peaked, WEAR_HEAD)
	//uniform
	var/obj/item/clothing/under/marine/veteran/UPP/officer/M = new()
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	M.attach_accessory(H, W)
	H.equip_to_slot_or_del(M, WEAR_BODY)
	for(var/i in 1 to W.hold.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71/ap, WEAR_IN_ACCESSORY)
	//jacket
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/officer, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/flamer/leader, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/admiral/impact, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_R_STORE)

//*****************************************************************************************************/
/datum/equipment_preset/upp/sapper/survivor
	name = "UPP Sapper (Survivor)"

/datum/equipment_preset/upp/sapper/survivor/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/nagant, WEAR_IN_BACK) //1
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/upp, WEAR_IN_BACK) //1.3
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/upp, WEAR_IN_BACK) //1.6
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/upp, WEAR_IN_BACK) //2
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked, WEAR_IN_BACK) //3
	H.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/mini, WEAR_IN_BACK) //4
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas, WEAR_FACE)
	//head
	var/headgear = prob(70) ? /obj/item/clothing/head/helmet/marine/veteran/UPP/engi : /obj/item/clothing/head/uppcap/ushanka
	H.equip_to_slot_or_del(new headgear, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/engi/UPP = new()
	var/obj/item/clothing/accessory/storage/black_vest/W = new()
	UPP.attach_accessory(H, W)
	W.hold.storage_slots = 7
	H.equip_to_slot_or_del(UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/tool/screwdriver, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/wrench, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/weldingtool, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/wirecutters, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/cable_coil, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/device/multitool, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/type23/dual, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/upp/heavybuck(H), WEAR_WAIST)
	//limb
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/insulated(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	//pockets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_R_STORE)

//*****************************************************************************************************/
/datum/equipment_preset/upp/synth
	name = "UPP Combat Synthetic"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/synthetic
	assignment = "UPP Combat Synthetic"
	rank = "UPP Combat Synthetic"
	paygrade = "SYN"
	idtype = /obj/item/card/id/gold

/datum/equipment_preset/upp/synth/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(50;MALE,50;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(first_names_male_upp)]"
		H.f_style = "5 O'clock Shadow"
	else
		random_name = "[pick(first_names_female_upp)]"
	H.change_real_name(H, random_name)
	H.r_hair = 15
	H.g_hair = 15
	H.b_hair = 25
	H.r_eyes = 139
	H.g_eyes = 62
	H.b_eyes = 19
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/upp/synth/load_race(mob/living/carbon/human/H)
	H.set_species(SPECIES_SYNTHETIC)

/datum/equipment_preset/upp/synth/load_gear(mob/living/carbon/human/H)
	load_name(H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator/compact, WEAR_IN_BACK) //1
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK) //2
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK) //2.33
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //2.66
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //3
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK) //3.33
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)
	//head
	var/hat = pick(/obj/item/clothing/head/uppcap, /obj/item/clothing/head/uppcap/beret, /obj/item/clothing/head/uppcap/ushanka)
	H.equip_to_slot_or_del(new hat, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/medic/UPP = new()
	var/obj/item/clothing/accessory/storage/black_vest/W = new()
	UPP.attach_accessory(H, W)
	W.hold.storage_slots = 7
	H.equip_to_slot_or_del(UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/tool/screwdriver, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/wrench, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/weldingtool, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/tool/wirecutters, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/stack/cable_coil, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/device/multitool, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/jacket, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/tricordrazine, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/tricordrazine, WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/skorpion/upp/medic, WEAR_J_STORE)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//póckets
	var/obj/item/storage/pouch/magazine/pistol/large/ppouch = new()
	H.equip_to_slot_or_del(ppouch, WEAR_R_STORE)
	for(var/i = 1 to ppouch.storage_slots)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/skorpion, WEAR_IN_R_STORE)
	H.equip_to_slot_or_del(new/obj/item/storage/pouch/medical/full, WEAR_L_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/upp/conscript
	//meme role
	name = "UPP Conscript"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp
	assignment = JOB_UPP_CONSCRIPT
	rank = JOB_UPP_CONSCRIPT
	role_comm_title = "Cons"
	paygrade = "UE0"

/datum/equipment_preset/upp/conscript/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	//back
	var/maybebackpack = prob(20) ? pick(/obj/item/storage/backpack/lightpack/upp, /obj/item/storage/backpack/lightpack) : null
	if(maybebackpack)
		H.equip_to_slot_or_del(new maybebackpack, WEAR_BACK) //what in back?
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)

	//head
	var/maybehat = prob(66) ? pick(/obj/item/clothing/head/uppcap, /obj/item/clothing/head/uppcap/beret, /obj/item/clothing/head/ushanka, /obj/item/clothing/head/uppcap/ushanka) : null
	if(maybehat)
		H.equip_to_slot_or_del(new maybehat, WEAR_HEAD)

	//body
	var/obj/item/clothing/under/marine/veteran/UPP/UPP = new()
	H.equip_to_slot_or_del(UPP, WEAR_BODY)

	var/maybejacket = prob(50) ? pick(/obj/item/clothing/suit/storage/marine/faction/UPP/jacket, /obj/item/clothing/suit/storage/snow_suit/soviet) : null
	if(maybejacket)
		H.equip_to_slot_or_del(new maybejacket, WEAR_JACKET)
		H.equip_to_slot_or_del(new /obj/item/stack/medical/bruise_pack, WEAR_IN_JACKET)
		H.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/bottle/vodka, WEAR_IN_JACKET)
		//limit of snowcoat
		H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/upp, WEAR_IN_JACKET)

	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	var/maybegloves = prob(80) ? pick(/obj/item/clothing/gloves/black, /obj/item/clothing/gloves/marine/veteran, /obj/item/clothing/gloves/combat) : null
	if(maybegloves)
		H.equip_to_slot_or_del(new maybegloves, WEAR_HANDS)

	//gun
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/carbine, WEAR_R_HAND)

	//webbing or belt?
	if(prob(30))
		var/obj/item/clothing/accessory/storage/webbing/W = new()
		UPP.attach_accessory(H, W)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_ACCESSORY)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_ACCESSORY)
		H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71, WEAR_IN_ACCESSORY)
	else if(prob(30))
		H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp/scarce, WEAR_WAIST)
	//if you fail the rolls you must scavenge the ammo from your fallen brethren

	if(prob(10))
		//sometimes Ivan smiles upon the corps
		H.set_species("Human Hero")


/datum/equipment_preset/upp/commando
	name = "UPP Commando"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/commando
	assignment = JOB_UPP_COMMANDO
	rank = JOB_UPP_COMMANDO
	role_comm_title = "JKdo"
	paygrade = "UC1"
	idtype = /obj/item/card/id/data
	languages = list("Russian", "English", "Tactical Sign Language", "Spanish")

/datum/equipment_preset/upp/commando/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/commando, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/PK9/tranq, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp, WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_L_STORE)

	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_BACK)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine/commando, /obj/item/ammo_magazine/rifle/type71/ap, H, 0, 8)

//*****************************************************************************************************/

/datum/equipment_preset/upp/commando/medic
	name = "UPP Commando Medic"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/commando/medic
	assignment = JOB_UPP_COMMANDO_MEDIC
	rank = JOB_UPP_COMMANDO_MEDIC
	role_comm_title = "2ndKdo"
	paygrade = "UC2"

/datum/equipment_preset/upp/commando/medic/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP/medic, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/commando, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp, WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol/skillless, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_L_STORE)

	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_BACK)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine/commando, /obj/item/ammo_magazine/rifle/type71/ap, H, 0, 5)

//*****************************************************************************************************/

/datum/equipment_preset/upp/commando/leader
	name = "UPP Commando Leader"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/commando/leader
	assignment = JOB_UPP_COMMANDO_LEADER
	rank = JOB_UPP_COMMANDO_LEADER
	role_comm_title = "1stKdo"
	paygrade = "UC3"
	idtype = /obj/item/card/id/silver

/datum/equipment_preset/upp/commando/leader/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/commando, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/upp, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles/upp, WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/PK9/tranq, WEAR_WAIST)

	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/phosphorus/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_L_STORE)

	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/handcuffs, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/handcuffs, WEAR_IN_BACK)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine/commando, /obj/item/ammo_magazine/rifle/type71/ap, H, 0, 7)

//*****************************************************************************************************/

/datum/equipment_preset/upp/tank
	name = "UPP Vehicle Crewman (TANK)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_UPP_CREWMAN
	rank = JOB_UPP_CREWMAN
	paygrade = "UE5"
	role_comm_title = "TANK"
	minimum_age = 30
	skills = /datum/skills/tank_crew

/datum/equipment_preset/upp/tank/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/PK9(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/tool/weldpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tank(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(pick(new /obj/item/clothing/head/helmet/marine/veteran/UPP, new /obj/item/clothing/head/uppcap/beret), WEAR_HEAD)

	spawn_weapon(/obj/item/weapon/gun/rifle/type71/carbine, /obj/item/ammo_magazine/rifle/type71, H, 0, 3)

/datum/equipment_preset/upp/tank/load_status()
	return

//*****************************************************************************************************/

/datum/equipment_preset/upp/doctor
	name = "UPP Doctor"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/upp/combat_medic
	assignment = JOB_UPP_LT_DOKTOR
	rank = JOB_UPP_LT_DOKTOR
	role_comm_title = "Lt. Med."
	paygrade = "UO1M"

/datum/equipment_preset/upp/doctor/load_gear(mob/living/carbon/human/H)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/upp, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/upp, WEAR_IN_BACK)
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health, WEAR_EYES)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/ushanka, WEAR_HEAD)
	//body
	var/obj/item/clothing/under/marine/veteran/UPP/medic/UPP = new()
	var/obj/item/clothing/accessory/storage/surg_vest/equipped/W = new()
	UPP.attach_accessory(H, W)
	H.equip_to_slot_or_del(UPP, WEAR_BODY)
	//waist
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	//póckets
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/full, WEAR_L_STORE)
