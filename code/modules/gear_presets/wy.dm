
/datum/equipment_preset/wy
	name = "WY"

/datum/equipment_preset/wy/load_languages(mob/living/carbon/human/H)
	H.set_languages(list("English"))


/datum/equipment_preset/wy/load_name(mob/living/carbon/human/H)
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

/datum/equipment_preset/wy/pmc_standard/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(src)
	W.assignment = "Weyland-Yutani PMC (Standard)"
	W.rank = "PMC Standard"
	W.registered_name = H.real_name
	W.name = "[H.real_name]'s ID Card ([W.assignment])"
	W.icon_state = "centcom"
	W.access = get_all_accesses()
	W.access += get_all_centcom_access()
	W.paygrade = "PMC1"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "PMC"
		H.mind.special_role = "MODE"

/datum/equipment_preset/wy/pmc_standard/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/pfc)

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

/datum/equipment_preset/wy/pmc_leader/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(src)
	W.assignment = "PMC Officer"
	W.rank = "PMC Leader"
	W.registered_name = H.real_name
	W.name = "[H.real_name]'s ID Card ([W.assignment])"
	W.icon_state = "centcom"
	W.access = get_all_accesses()
	W.access += get_all_centcom_access()
	W.paygrade = "PMC4"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "SL"
		H.mind.assigned_role = "PMC Leader"
		H.mind.special_role = "MODE"

/datum/equipment_preset/wy/pmc_leader/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/SL/pmc)

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

/datum/equipment_preset/wy/pmc_gunner/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(src)
	W.assignment = "PMC Specialist"
	W.rank = "PMC Gunner"
	W.registered_name = H.real_name
	W.name = "[H.real_name]'s ID Card ([W.assignment])"
	W.icon_state = "centcom"
	W.access = get_all_accesses()
	W.access += get_all_centcom_access()
	W.paygrade = "PMC3"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "Spc"
		H.mind.assigned_role = "PMC"
		H.mind.special_role = "MODE"

/datum/equipment_preset/wy/pmc_gunner/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/smartgunner/pmc)

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

/datum/equipment_preset/wy/pmc_sniper/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(src)
	W.assignment = "PMC Sniper"
	W.rank = "PMC Sharpshooter"
	W.registered_name = H.real_name
	W.name = "[H.real_name]'s ID Card ([W.assignment])"
	W.icon_state = "centcom"
	W.access = get_all_accesses()
	W.access += get_all_centcom_access()
	W.paygrade = "PMC3"
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.role_comm_title = "Spc"
		H.mind.assigned_role = "PMC"
		H.mind.special_role = "MODE"

/datum/equipment_preset/wy/pmc_sniper/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/specialist/pmc)

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

/datum/equipment_preset/wy/deathsquad/load_name(mob/living/carbon/human/H)
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
	
/datum/equipment_preset/wy/deathsquad/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.assignment = "Deathsquad"
	W.rank = "PMC Commando"
	W.registered_name = H.real_name
	W.name = "[H.real_name]'s ID Card ([W.assignment])"
	W.icon_state = "centcom"
	W.access = get_antagonist_pmc_access()
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "DEATH SQUAD"

/datum/equipment_preset/wy/deathsquad/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/commando/deathsquad)

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
	
/datum/equipment_preset/wy/deathsquad/leader/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.assignment = "Deathsquad Leader"
	W.rank = "PMC Commando"
	W.registered_name = H.real_name
	W.name = "[H.real_name]'s ID Card ([W.assignment])"
	W.icon_state = "centcom"
	W.access = get_antagonist_pmc_access()
	H.equip_to_slot_or_del(W, WEAR_ID)
	if(H.mind)
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "DEATH SQUAD"
