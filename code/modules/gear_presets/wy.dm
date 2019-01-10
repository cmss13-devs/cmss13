
/datum/equipment_preset/wy
	name = "WY"

	idtype = /obj/item/card/id/centcom
	special_role = "MODE"

/datum/equipment_preset/wy/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()

/datum/equipment_preset/wy/load_languages(mob/living/carbon/human/H)
	H.set_languages(list("English"))


/datum/equipment_preset/wy/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(MALE,FEMALE)
	var/list/first_names_m = list("Owen","Luka","Nelson","Branson", "Tyson", "Leo", "Bryant", "Kobe", "Rohan", "Riley", "Aidan", "Watase","Egawa", "Hisakawa", "Koide", "Remy", "Martial", "Magnus", "Heiko", "Lennard")
	var/list/first_names_f = list("Madison","Jessica","Anna","Juliet", "Olivia", "Lea", "Diane", "Kaori", "Beatrice", "Riley", "Amy", "Natsue","Yumi", "Aiko", "Fujiko", "Jennifer", "Ashley", "Mary", "Hitomi", "Lisa")
	var/list/last_names_mb = list("Bates","Shaw","Hansen","Black", "Chambers", "Hall", "Gibson", "Weiss", "Waller", "Burton", "Bakin", "Rohan", "Naomichi", "Yakumo", "Yosai", "Gallagher", "Hiles", "Bourdon", "Strassman", "Palau")
	var/datum/preferences/A = new()
	A.randomize_appearance_for(H)
	if(H.gender == MALE)
		H.real_name = "PMC [pick(first_names_m)] [pick(last_names_mb)]"
		H.f_style = "5 O'clock Shadow"
	else
		H.real_name = "PMC [pick(first_names_f)] [pick(last_names_mb)]"
	H.name = H.real_name
	H.age = rand(25,35)
	H.h_style = "Shaved Head"
	H.r_hair = 25
	H.g_hair = 25
	H.b_hair = 35

/*****************************************************************************************************/

/datum/equipment_preset/wy/pmc_standard
	name = "Weyland-Yutani PMC (Standard)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "Weyland-Yutani PMC (Standard)"
	rank = "PMC Standard"
	paygrade = "PMC1"
	skills = /datum/skills/pfc

/datum/equipment_preset/wy/pmc_standard/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	var/choice = rand(1,4)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC(H), WEAR_FACE)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/PMC(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/baton(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp70(H), WEAR_WAIST)

	switch(choice)
		if(1,2,3)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/elite(H), WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39(H), WEAR_L_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39(H), WEAR_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap(H.back), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/ap(H.back), WEAR_IN_BACK)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/flamer(H), WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/pmc_vp70(H), WEAR_L_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/pmc_vp70(H), WEAR_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank(H.back), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank(H.back), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank(H.back), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/flamer_tank(H.back), WEAR_IN_BACK)

/*****************************************************************************************************/

/datum/equipment_preset/wy/pmc_leader
	name = "Weyland-Yutani PMC (Leader)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "PMC Officer"
	rank = "PMC Leader"
	paygrade = "PMC4"
	role_comm_title = "SL"
	skills = /datum/skills/SL/pmc

/datum/equipment_preset/wy/pmc_leader/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC/leader(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC/leader(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/leader(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/leader(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/baton(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp78(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle(H), WEAR_R_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/wy/pmc_gunner
	name = "Weyland-Yutani PMC (Gunner)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "PMC Specialist"
	rank = "PMC Gunner"
	paygrade = "PMC3"
	role_comm_title = "Spc"
	skills = /datum/skills/smartgunner/pmc

/datum/equipment_preset/wy/pmc_gunner/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/smartgunner/veteran/PMC(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/gunner(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/leader(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/smartgun_powerpack/snow(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp70(H), WEAR_WAIST)

/*****************************************************************************************************/

/datum/equipment_preset/wy/pmc_sniper
	name = "Weyland-Yutani PMC (Sniper)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "PMC Sniper"
	rank = "PMC Sharpshooter"
	paygrade = "PMC3"
	role_comm_title = "Spc"
	skills = /datum/skills/specialist/pmc

/datum/equipment_preset/wy/pmc_sniper/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/PMC(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC/sniper(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/sniper(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/m42_goggles(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp70(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/sniper/elite(H), WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_sniper(H), WEAR_L_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/wy/deathsquad
	name = "Weyland-Yutani Deathsquad"
	flags = EQUIPMENT_PRESET_EXTRA
	uses_special_name = TRUE //We always use a codename!

	assignment = "Deathsquad"
	rank = "PMC Commando"
	special_role = "DEATH SQUAD"
	skills = /datum/skills/commando/deathsquad

/datum/equipment_preset/wy/deathsquad/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/wy/deathsquad/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(MALE)
	//var/datum/preferences/A = new()
	//A.randomize_appearance_for(mob)
	var/list/first_names_mr = list("Alpha","Beta", "Gamma", "Delta","Epsilon", "Zeta", "Eta", "Theta", "Iota", "Kappa", "Lambda", "Mu", "Nu", "Xi", "Omnicron", "Pi", "Rho", "Sigma", "Tau", "Upsilon", "Phi", "Chi", "Psi", "Omega")
	if(H.gender == MALE)
		H.real_name = "[pick(first_names_mr)]"
	else
		H.real_name = "[pick(first_names_mr)]"
	H.name = H.real_name
	H.age = rand(17,45)

/datum/equipment_preset/wy/deathsquad/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/commando(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/m42_goggles	(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC/commando(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC/commando(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC/commando(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/commando(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/commando(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/commando(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC/leader(H), WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/tank/emergency_oxygen/engi(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_rifle(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/pmc_mateba(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/mateba/full(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/elite(H), WEAR_J_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/wy/deathsquad/leader
	name = "Weyland-Yutani Deathsquad Leader"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "Deathsquad Leader"
	rank = "PMC Commando"
	special_role = "DEATH SQUAD"

/*****************************************************************************************************/
/******************************************SCP FLUFF**************************************************/
/*****************************************************************************************************/

/datum/equipment_preset/wy/pmc_standard/scp
	name = "Weyland-Yutani SCP PMC (Standard)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "Weyland-Yutani SCP PMC (Standard)"
	rank = "SCP PMC Standard"

/*****************************************************************************************************/

/datum/equipment_preset/wy/pmc_leader/scp
	name = "Weyland-Yutani SCP PMC (Leader)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "SCP PMC Officer"
	rank = "SCP PMC Leader"

/*****************************************************************************************************/

/datum/equipment_preset/wy/pmc_gunner/scp
	name = "Weyland-Yutani SCP PMC (Gunner)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "SCP PMC Specialist"
	rank = "SCP PMC Gunner"

/*****************************************************************************************************/

/datum/equipment_preset/wy/pmc_sniper/scp
	name = "Weyland-Yutani SCP PMC (Sniper)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "SCP PMC Sniper"
	rank = "SCP PMC Sharpshooter"