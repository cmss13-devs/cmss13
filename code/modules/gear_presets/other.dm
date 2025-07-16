/datum/equipment_preset/other
	name = "Other"
	languages = list(LANGUAGE_ENGLISH)
	paygrades = list(PAY_SHORT_CIV = JOB_PLAYTIME_TIER_0)

//*****************************************************************************************************/

/datum/equipment_preset/other/freelancer
	name = "Freelancer"

	assignment = "Freelancer"
	job_title = FACTION_FREELANCER
	idtype = /obj/item/card/id/data
	faction = FACTION_FREELANCER

/datum/equipment_preset/other/freelancer/New()
	. = ..()
	access = get_access(ACCESS_LIST_EMERGENCY_RESPONSE) //ACCESS_COME_BACK_TO_ME

/datum/equipment_preset/other/freelancer/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(60;MALE,40;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(new_human)
	var/random_name
	if(new_human.gender == MALE)
		random_name = "[pick(GLOB.first_names_male_colonist)] [pick(GLOB.last_names_colonist)]"
		new_human.f_style = "5 O'clock Shadow"
	else
		random_name = "[pick(GLOB.first_names_female_colonist)] [pick(GLOB.last_names_colonist)]"
	new_human.change_real_name(new_human, random_name)
	new_human.age = rand(20,45)
	new_human.r_hair = 25
	new_human.g_hair = 25
	new_human.b_hair = 35

//*****************************************************************************************************/

/datum/equipment_preset/other/freelancer/standard
	name = "Freelancer (Standard)"
	paygrades = list(PAY_SHORT_FL_S = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/freelancer

/datum/equipment_preset/other/freelancer/standard/load_gear(mob/living/carbon/human/new_human)
	//generic clothing
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/freelancer, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/freelancer_patch, WEAR_ACCESSORY)
	spawn_merc_helmet(new_human)
	//storage and specific stuff, they all get an ERT medpouch.
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/attachments(new_human), WEAR_IN_BACK)

	load_freelancer_soldier(new_human)

/datum/equipment_preset/other/freelancer/standard/proc/load_freelancer_soldier(mob/living/carbon/human/new_human)
	var/percentage = rand(1, 100)
	switch(percentage)
		//most freelancers are rifleman, most others are breachers, some have HPRs.
		if(1 to 66)
			load_freelancer_rifleman(new_human)
		if(67 to 85)
			load_freelancer_shotgunner(new_human)
		else
			load_freelancer_machinegunner(new_human)

/datum/equipment_preset/other/freelancer/standard/proc/load_freelancer_machinegunner(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	spawn_merc_weapon(new_human,1,6)
	spawn_weapon(/obj/item/weapon/gun/rifle/lmg, /obj/item/ammo_magazine/rifle/lmg, new_human, 0, 5) //HPR mini-spec
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/lmg/holo_target, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/lmg/holo_target, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_R_STORE)

/datum/equipment_preset/other/freelancer/standard/proc/load_freelancer_shotgunner(mob/living/carbon/human/new_human)
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	spawn_weapon(/obj/item/weapon/gun/shotgun/type23, pick(GLOB.shotgun_handfuls_8g), new_human, 0, 14) //shotgunner mini-spec
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/stick, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/stick, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/stick, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/stick, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied_incendiary, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied_incendiary, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular/response, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/smokebomb, WEAR_IN_BACK)


/datum/equipment_preset/other/freelancer/standard/proc/load_freelancer_rifleman(mob/living/carbon/human/new_human)
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/upp, WEAR_R_STORE)
	spawn_merc_weapon(new_human)
	//backpack stuff
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular/response, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/stick, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/stick, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular/response, WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/other/freelancer/medic
	name = "Freelancer (Medic)"
	paygrades = list(PAY_SHORT_FL_M = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Freelancer Medic"
	skills = /datum/skills/freelancer/combat_medic

/datum/equipment_preset/other/freelancer/medic/load_gear(mob/living/carbon/human/new_human)
	var/shotgunner = FALSE
	if(prob(50))
		shotgunner = TRUE
		new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer, WEAR_BODY)
	else
		var/obj/item/clothing/under/marine/veteran/freelancer/FREELANCER = new()
		var/obj/item/clothing/accessory/storage/surg_vest/equipped/W = new()
		FREELANCER.attach_accessory(new_human, W)
		new_human.equip_to_slot_or_del(FREELANCER, WEAR_BODY)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/freelancer, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/freelancer_patch, WEAR_ACCESSORY)
	spawn_merc_helmet(new_human)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/attachments(new_human), WEAR_IN_BACK)

	load_freelancer_medic(new_human, shotgunner)

/datum/equipment_preset/other/freelancer/medic/proc/load_freelancer_medic(mob/living/carbon/human/new_human, shotgunner)
	if(shotgunner)
		load_shotgunner_medic(new_human)
	else
		load_standard_medic(new_human)

/datum/equipment_preset/other/freelancer/medic/proc/load_shotgunner_medic(mob/living/carbon/human/new_human)
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/large, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_suture_and_graft, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BELT)
	//stuff in backpack
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/stick, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/stick, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/fsr, WEAR_IN_BACK)
	//gun
	spawn_merc_shotgun(new_human)

/datum/equipment_preset/other/freelancer/medic/proc/load_standard_medic(mob/living/carbon/human/new_human, /obj/item/clothing/under/marine/veteran/freelancer/FREELANCER)
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	//stuff in backpack
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK) //Line is in vest.
	spawn_merc_rifle(new_human)

//*****************************************************************************************************/

/datum/equipment_preset/other/freelancer/leader
	name = "Freelancer (Leader)"
	paygrades = list(PAY_SHORT_FL_WL = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Freelancer Warlord"
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_RUSSIAN, LANGUAGE_CHINESE, LANGUAGE_JAPANESE)

	skills = /datum/skills/freelancer/SL

/datum/equipment_preset/other/freelancer/leader/load_gear(mob/living/carbon/human/new_human)

	//No random helmet, so that it's more clear that he's the leader
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/freelancer, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/freelancer/beret, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/freelancer_patch, WEAR_ACCESSORY)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/attachments(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/stick, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/fsr, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_R_STORE)

	spawn_weapon(/obj/item/weapon/gun/rifle/m41aMK1, /obj/item/ammo_magazine/rifle/m41aMK1, new_human, 0, 9)
	spawn_merc_weapon(new_human,1,2)

///Hunting Grounds Freelancers///

/datum/equipment_preset/other/freelancer/standard/hunted
	name = "Freelancer (Hunted)"
	faction = FACTION_HUNTED_MERC

/datum/equipment_preset/other/freelancer/standard/hunted/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/freelancer, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	spawn_merc_helmet(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/attachments(new_human), WEAR_IN_BACK)

	load_freelancer_soldier(new_human)

	var/percentage = rand(1, 100)
	switch(percentage)
		if(1 to 66)
			load_freelancer_rifleman(new_human)
		else
			load_freelancer_machinegunner(new_human)

/datum/equipment_preset/other/freelancer/leader/hunted
	name = "Freelancer Leader (Hunted)"
	faction = FACTION_HUNTED_MERC


/datum/equipment_preset/other/freelancer/leader/hunted/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/freelancer, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/freelancer/beret, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/attachments(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive/stick, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)

	spawn_weapon(/obj/item/weapon/gun/rifle/m41aMK1, /obj/item/ammo_magazine/rifle/m41aMK1, new_human, 0, 9)
	spawn_merc_weapon(new_human,1,2)

//*****************************************************************************************************/

/datum/equipment_preset/other/elite_merc
	name = "Elite Mercenary"

	assignment = "Elite Mercenary"
	job_title = "Mercenary"
	idtype = /obj/item/card/id/centcom
	faction = FACTION_MERCENARY

/datum/equipment_preset/other/elite_merc/New()
	. = ..()
	access = get_access(ACCESS_LIST_EMERGENCY_RESPONSE)

/datum/equipment_preset/other/elite_merc/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(70;MALE,30;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(new_human)
	var/random_name
	if(new_human.gender == MALE)
		random_name = "[pick(GLOB.first_names_male_colonist)] [pick(GLOB.last_names_colonist)]"
		new_human.f_style = "5 O'clock Shadow"
	else
		random_name = "[pick(GLOB.first_names_female_colonist)] [pick(GLOB.last_names_colonist)]"
	new_human.change_real_name(new_human, random_name)
	new_human.age = rand(20,45)
	new_human.r_hair = rand(15,35)
	new_human.g_hair = rand(15,35)
	new_human.b_hair = rand(25,45)

//*****************************************************************************************************/

/datum/equipment_preset/other/elite_merc/standard
	name = "Elite Mercenary (Standard Miner)"
	paygrades = list(PAY_SHORT_EFL_S = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/centcom
	assignment = "Mercenary Miner"
	job_title = "Mercenary"
	skills = /datum/skills/mercenary/elite
	faction = FACTION_MERCENARY

/datum/equipment_preset/other/elite_merc/standard/load_gear(mob/living/carbon/human/new_human)
	//TODO: add unique backpacks and satchels
	//clothes
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary/miner, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary/miner, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary/miner, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles, WEAR_EYES)
	//storage items, belt spawning is handled in the spawn elite weapon proc.
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/upp, WEAR_R_STORE)
	//backpack and stuff in it
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular/response, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/hefa, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/attachments(new_human), WEAR_IN_BACK)

	spawn_merc_elite_weapon(new_human, 12, 50, 1)

//*****************************************************************************************************/

/datum/equipment_preset/other/elite_merc/heavy
	name = "Elite Mercenary (Heavy)"
	paygrades = list(PAY_SHORT_EFL_H = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/centcom
	assignment = "Mercenary Heavy"
	job_title = "Mercenary"
	skills = /datum/skills/mercenary/elite/heavy
	faction = FACTION_MERCENARY

/datum/equipment_preset/other/elite_merc/heavy/load_gear(mob/living/carbon/human/new_human)
	//TODO: add backpacks and satchels
	//clothes
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary/heavy, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles, WEAR_EYES)
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/heavy, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/pressurized_reagent_canister/oxycodone, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_R_STORE)
	//backpack and stuff in it
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular/response, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/m15, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/phosphorus, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(new_human), WEAR_IN_BACK)
	//gun
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/minigun(new_human), WEAR_J_STORE)


//*****************************************************************************************************/
/datum/equipment_preset/other/elite_merc/engineer
	name = "Elite Mercenary (Engineer)"
	paygrades = list(PAY_SHORT_EFL_E = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "Mercenary Engineer"
	job_title = "Mercenary"
	skills = /datum/skills/mercenary/elite/engineer
	faction = FACTION_MERCENARY


/datum/equipment_preset/other/elite_merc/engineer/load_gear(mob/living/carbon/human/new_human)
	//TODO: add backpacks and satchels
	//snowflake webbing
	var/obj/item/clothing/under/marine/veteran/mercenary/support/SUPPORT = new()
	var/obj/item/clothing/accessory/storage/black_vest/W = new()
	SUPPORT.attach_accessory(new_human, W)
	W.hold.storage_slots = 7
	new_human.equip_to_slot_or_del(SUPPORT, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/bicaridine, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/bicaridine, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/kelotane, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/kelotane, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/tramadol, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/tramadol, WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/emergency, WEAR_IN_ACCESSORY)
	//clothes
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary/support, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary/support/engineer, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles, WEAR_EYES)
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked/elite_merc, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/large, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical/full, WEAR_R_STORE)
	//backpack and stuff in it
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/large_stack, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/mini, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/mini, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular/response, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/attachments(new_human), WEAR_IN_BACK)
	//gun
	spawn_merc_elite_weapon(new_human, 9, 100, 0) //only shotguns

//*****************************************************************************************************/

/datum/equipment_preset/other/elite_merc/medic
	name = "Elite Mercenary (Medic)"
	paygrades = list(PAY_SHORT_EFL_M = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/centcom
	assignment = "Mercenary Medic"
	job_title = "Mercenary"
	skills = /datum/skills/mercenary/elite/medic
	faction = FACTION_MERCENARY

/datum/equipment_preset/other/elite_merc/medic/load_gear(mob/living/carbon/human/new_human)
	//webbing
	var/obj/item/clothing/under/marine/veteran/mercenary/support/SUPPORT = new()
	var/obj/item/clothing/accessory/storage/surg_vest/equipped/W = new()
	SUPPORT.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(SUPPORT, WEAR_BODY)
	//clothing
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/medhud, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary/support, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary/support, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary/support, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc, WEAR_FACE)
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	//backpack and stuff in it
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK) //Line in vest.
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/attachments(new_human), WEAR_IN_BACK)
	//gun
	spawn_merc_elite_weapon(new_human, 7, 0, 0) //no shotguns

//*****************************************************************************************************/

/datum/equipment_preset/other/elite_merc/leader
	name = "Elite Mercenary (Leader)"
	paygrades = list(PAY_SHORT_EFL_TL = JOB_PLAYTIME_TIER_0)
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/centcom
	assignment = "Mercenary Warlord"
	job_title = "Mercenary"
	skills = /datum/skills/mercenary/elite/leader
	faction = FACTION_MERCENARY

/datum/equipment_preset/other/elite_merc/leader/load_gear(mob/living/carbon/human/new_human)
	//clothes
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/medhud, WEAR_EYES)
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_R_STORE)
	//backpack and stuff in it
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/attachments(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/m15, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/packet/phosphorus/upp, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular/response, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked/elite_merc, WEAR_IN_BACK)
	//gun
	spawn_merc_elite_weapon(new_human, 7, 25, 1) //lower shotgun chance, but not zero

//*****************************************************************************************************/

/datum/equipment_preset/other/pizza
	name = "Pizza"
	flags = EQUIPMENT_PRESET_EXTRA

	languages = list(LANGUAGE_ENGLISH, LANGUAGE_RUSSIAN, LANGUAGE_JAPANESE, LANGUAGE_CHINESE) //Just in case they are delivering to UPP or CLF...
	idtype = /obj/item/card/id/pizza
	assignment = "Pizza Deliverer"
	job_title = FACTION_PIZZA
	skills = /datum/skills/civilian
	paygrades = list(PAY_SHORT_CIV = JOB_PLAYTIME_TIER_0)
	faction = FACTION_PIZZA

/datum/equipment_preset/other/pizza/New()
	. = ..()
	access = get_access(ACCESS_LIST_DELIVERY)

/datum/equipment_preset/other/pizza/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(MALE,FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(new_human)
	var/random_name
	if(new_human.gender == MALE)
		random_name = "[pick(GLOB.first_names_male)] [pick(GLOB.last_names)]"
	else
		random_name = "[pick(GLOB.first_names_female)] [pick(GLOB.last_names)]"
	new_human.change_real_name(new_human, random_name)
	new_human.age = rand(17,45)

/datum/equipment_preset/other/pizza/load_gear(mob/living/carbon/human/new_human)
	//TODO: add backpacks and satchels
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/pizza, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/red, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/red, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/pizzabox/margherita, WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/dr_gibb, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/holdout, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/pizzabox/vegetable, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/pizzabox/mushroom, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/pizzabox/meat, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/dr_gibb, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/thirteenloko, WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/other/souto
	name = "Souto Man"
	flags = EQUIPMENT_PRESET_EXTRA

	languages = list(LANGUAGE_ENGLISH, LANGUAGE_RUSSIAN, LANGUAGE_JAPANESE, LANGUAGE_CHINESE) //Just in case they are delivering to UPP or CLF...
	idtype = /obj/item/card/id/souto
	assignment = FACTION_SOUTO
	job_title = "Souto Man"
	skills = /datum/skills/souto
	faction = FACTION_SOUTO

/datum/equipment_preset/other/souto/New()
	. = ..()
	access = get_access(ACCESS_LIST_DELIVERY)

/datum/equipment_preset/other/souto/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = MALE
	new_human.change_real_name(new_human, "Souto Man")
	new_human.age = 40

/datum/equipment_preset/other/souto/load_gear(mob/living/carbon/human/new_human)
	//TODO: add backpacks and satchels
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/souto, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/souto, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/souto, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/souto, WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/fake_mustache, WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/space/souto, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/souto, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/souto, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses, WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/souto, WEAR_FEET)
	var/obj/vehicle/souto/super/V = new
	V.forceMove(new_human.loc)
	V.buckle_mob(new_human, new_human)

//*****************************************************************************************************/

/datum/equipment_preset/other/zombie
	name = "Zombie"
	flags = EQUIPMENT_PRESET_EXTRA
	job_title = FACTION_ZOMBIE
	languages = list("Zombie")
	skills = null //no restrictions
	faction = FACTION_ZOMBIE

//Overloading the function to be able to spawn gear first
/datum/equipment_preset/other/zombie/load_preset(mob/living/carbon/human/new_human, randomise = FALSE)
	if(randomise)
		load_name(new_human)
	load_skills(new_human) //skills are set before equipment because of skill restrictions on certain clothes.
	load_languages(new_human)
	load_gear(new_human)
	load_id(new_human)
	load_status(new_human)
	load_vanity(new_human)
	load_race(new_human)//Race is loaded last, otherwise we wouldn't be able to equip gear!
	new_human.assigned_equipment_preset = src
	new_human.regenerate_icons()

/datum/equipment_preset/other/zombie/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(MALE, FEMALE)
	var/datum/preferences/A = new
	A.randomize_appearance(new_human)
	var/random_name = capitalize(pick(new_human.gender == MALE ? GLOB.first_names_male : GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
	new_human.change_real_name(new_human, random_name)
	new_human.age = rand(21,45)

/datum/equipment_preset/other/zombie/load_id(mob/living/carbon/human/new_human, client/mob_client)
	var/obj/item/clothing/under/uniform = new_human.w_uniform
	if(istype(uniform))
		uniform.has_sensor = UNIFORM_HAS_SENSORS
	new_human.job = "Zombie"
	new_human.faction = faction
	return ..()

/datum/equipment_preset/other/zombie/load_race(mob/living/carbon/human/new_human)
	new_human.set_species(SPECIES_HUMAN) // Set back, so that we can get our claws again
	new_human.set_species(SPECIES_ZOMBIE)

/datum/equipment_preset/other/zombie/load_gear(mob/living/carbon/human/new_human)
	var/uniform_path = pick(/obj/item/clothing/under/colonist, /obj/item/clothing/under/rank/utility/gray, /obj/item/clothing/under/rank/utility/brown, /obj/item/clothing/under/colonist/steward, /obj/item/clothing/under/marine/ua_riot, /obj/item/clothing/under/suit_jacket/manager, /obj/item/clothing/under/suit_jacket/director)
	new_human.equip_to_slot_or_del(new uniform_path, WEAR_BODY)
	var/shoe_path = pick(/obj/item/clothing/shoes/laceup, /obj/item/clothing/shoes/leather, /obj/item/clothing/shoes/jackboots)
	new_human.equip_to_slot_or_del(new shoe_path, WEAR_FEET)

//*****************************************************************************************************/

/datum/equipment_preset/other/gladiator
	name = "Gladiator"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/dogtag
	skills = /datum/skills/gladiator

	assignment = "Bestiarius"
	job_title = FACTION_GLADIATOR
	faction = FACTION_GLADIATOR

/datum/equipment_preset/other/gladiator/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(MALE, FEMALE)
	var/datum/preferences/A = new
	A.randomize_appearance(new_human)
	var/random_name = capitalize(pick(new_human.gender == MALE ? GLOB.first_names_male_gladiator : GLOB.first_names_female_gladiator))
	new_human.change_real_name(new_human, random_name)
	new_human.age = rand(21,45)

/datum/equipment_preset/other/gladiator/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/gladiator, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/chainshirt/hunter, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/gladiator, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/shield/riot, WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/sword, WEAR_L_HAND)

	var/obj/item/lantern = new /obj/item/device/flashlight/lantern(new_human)
	lantern.name = "Beacon of Holy Light"

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(lantern, WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/other/gladiator/champion
	name = "Gladiator Champion"
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/gladiator/champion
	assignment = "Samnite"
	job_title = "Samnite"

/datum/equipment_preset/other/gladiator/champion/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/gladiator, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/chainshirt/hunter, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/gladiator, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/shield/riot, WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/sword, WEAR_L_HAND)

	var/obj/item/lantern = new /obj/item/device/flashlight/lantern(new_human)
	lantern.name = "Beacon of Holy Light"

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(lantern, WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/other/gladiator/leader
	name = "Gladiator Leader"
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/gladiator/champion/leader
	assignment = "Spartacus"
	job_title = "Spartacus"

/datum/equipment_preset/other/gladiator/leader/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/gladiator, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/chainshirt/hunter, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/gladiator, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/shield/riot, WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/sword, WEAR_L_HAND)

	var/obj/item/lantern = new /obj/item/device/flashlight/lantern(new_human)
	lantern.name = "Beacon of Holy Light"

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)
	new_human.equip_to_slot_or_del(lantern, WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/other/xeno_cultist
	name = "Cultist - Xeno Cultist"
	faction = FACTION_XENOMORPH
	flags = EQUIPMENT_PRESET_EXTRA
	idtype = /obj/item/card/id/lanyard
	skills = /datum/skills/civilian/survivor

	languages = list(LANGUAGE_XENOMORPH, LANGUAGE_ENGLISH)

	assignment = "Cultist"
	job_title = "Cultist"

	minimap_icon = "cultist"
	minimap_background = "background_cultist"

/datum/equipment_preset/other/xeno_cultist/New()
	. = ..()
	access = get_access(ACCESS_LIST_COLONIAL_ALL)

/datum/equipment_preset/other/xeno_cultist/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chaplain/cultist(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)

	var/obj/item/clothing/suit/cultist_hoodie/hoodie = new /obj/item/clothing/suit/cultist_hoodie(new_human)
	hoodie.flags_item |= NODROP|DELONDROP
	new_human.equip_to_slot_or_del(hoodie, WEAR_JACKET)

	var/obj/item/clothing/head/cultist_hood/hood = new /obj/item/clothing/head/cultist_hood(new_human)
	hood.flags_item |= NODROP|DELONDROP
	new_human.equip_to_slot_or_del(hood, WEAR_HEAD)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)

//*****************************************************************************************************/
/datum/equipment_preset/other/xeno_cultist/load_status(mob/living/carbon/human/new_human, hivenumber = XENO_HIVE_NORMAL)
	if(SSticker.mode && new_human.mind)
		SSticker.mode.xenomorphs += new_human.mind

	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
	if(hive)
		new_human.faction = hive.internal_faction
		if(hive.leading_cult_sl == new_human)
			hive.leading_cult_sl = null
	new_human.hivenumber = hivenumber

	GLOB.xeno_cultists += new_human

	var/list/huds_to_add = list(MOB_HUD_XENO_INFECTION, MOB_HUD_XENO_STATUS)

	for(var/hud_to_add in huds_to_add)
		var/datum/mob_hud/hud = GLOB.huds[hud_to_add]
		hud.add_hud_to(new_human, new_human)

	var/list/actions_to_add = subtypesof(/datum/action/human_action/activable/cult)

	if(istype(new_human.wear_suit, /obj/item/clothing/suit/cultist_hoodie) || istype(new_human.head, /obj/item/clothing/head/cultist_hood))
		actions_to_add -= /datum/action/human_action/activable/cult/obtain_equipment

	for(var/action_to_add in actions_to_add)
		give_action(new_human, action_to_add)

	new_human.default_lighting_alpha = LIGHTING_PLANE_ALPHA_SOMEWHAT_INVISIBLE
	new_human.update_sight()

/datum/equipment_preset/other/xeno_cultist/leader
	name = "Cultist - Xeno Cultist Leader"
	uses_special_name = TRUE
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/cultist_leader

	assignment = "Cultist Leader"
	job_title = "Cultist Leader"

	minimap_icon = "cult_leader"

/datum/equipment_preset/other/xeno_cultist/leader/load_gear(mob/living/carbon/human/new_human)
	. = ..()
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/cultist(new_human), WEAR_EYES)

/datum/equipment_preset/other/xeno_cultist/leader/load_status(mob/living/carbon/human/new_human)
	. = ..()

	var/datum/hive_status/hive = GLOB.hive_datum[new_human.hivenumber]
	hive.leading_cult_sl = new_human

	var/list/types = subtypesof(/datum/action/human_action/activable/cult_leader)
	for(var/type in types)
		give_action(new_human, type)

//*****************************************************************************************************/

/datum/equipment_preset/other/professor_dummy
	name = "DUMMY"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "DUMMY"
	job_title = "DUMMY"
	paygrades = list(PAY_SHORT_CCMO)
	idtype = /obj/item/card/id/dogtag
	uses_special_name = TRUE

/datum/equipment_preset/other/professor_dummy/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(MALE, FEMALE)
	new_human.real_name = "Alex the Medical Mannequin"
	new_human.name = new_human.real_name
	new_human.age = rand(1,5)
	var/datum/preferences/A = new
	A.randomize_appearance(new_human)

/datum/equipment_preset/other/professor_dummy/load_race(mob/living/carbon/human/new_human)
	. = ..()
	//Can't hug the dummy! Otherwise it's basically human...
	new_human.huggable = FALSE
	new_human.mob_flags |= EASY_SURGERY //Nurses can practise surgery on it.

/datum/equipment_preset/other/professor_dummy/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/device/professor_dummy_tablet/tablet = new /obj/item/device/professor_dummy_tablet(new_human)
	tablet.link_dummy(new_human)
	new_human.equip_to_slot_or_del(tablet, WEAR_R_HAND)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical, WEAR_BODY)

//*****************************************************************************************************/

/datum/equipment_preset/other/tank
	name = "Event Vehicle Crewman (CRMN)"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/dogtag
	assignment = JOB_TANK_CREW
	job_title = JOB_TANK_CREW
	paygrades = list(PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "CRMN"
	minimum_age = 30
	skills = /datum/skills/tank_crew

	faction = FACTION_NEUTRAL

/datum/equipment_preset/other/tank/New()
	. = ..()
	access = get_access(ACCESS_LIST_EMERGENCY_RESPONSE)

/datum/equipment_preset/other/tank/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/tanker(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/vc(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/tanker(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/weldpack(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tank(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/tech/tanker(new_human), WEAR_HEAD)

	spawn_weapon(/obj/item/weapon/gun/smg/m39, /obj/item/ammo_magazine/smg/m39/extended, new_human, 0, 3)

/datum/equipment_preset/other/tank/load_status()
	return

//*****************************************************************************************************/

//*****************************************************************************************************/
//adding one for VC training camp, cause I really need these
/datum/equipment_preset/other/tank/trainee
	name = "Vehicle Crewman Trainee (CRTR)"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/dogtag
	assignment = "Crewman Trainee"
	job_title = "Crewman Trainee"
	paygrades = list(PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "CRTR"
	minimum_age = 25
	skills = /datum/skills/tank_crew

	faction = FACTION_NEUTRAL

/datum/equipment_preset/other/tank/trainee/New()
	. = ..()
	access = list(
		ACCESS_MARINE_PREP,
		ACCESS_MARINE_CREWMAN,
		ACCESS_MARINE_ALPHA,
		ACCESS_MARINE_BRAVO,
		ACCESS_MARINE_CHARLIE,
		ACCESS_MARINE_DELTA,
	)

/datum/equipment_preset/other/tank/trainee/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/tanker(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tank(new_human), WEAR_R_STORE)

//*****************************************************************************************************/


/datum/equipment_preset/tutorial
	name = "Tutorial"
	faction = FACTION_MARINE
	flags = EQUIPMENT_PRESET_EXTRA
	faction_group = FACTION_LIST_MARINE
	languages = list(LANGUAGE_ENGLISH)
	idtype = /obj/item/card/id
	/// If the player should start out underfed
	var/underfed = TRUE

/datum/equipment_preset/tutorial/load_status(mob/living/carbon/human/new_human)
	if(underfed)
		new_human.nutrition = NUTRITION_LOW

/datum/equipment_preset/tutorial/fed
	name = "Tutorial (Fed)"
	underfed = FALSE
	paygrades = list(PAY_SHORT_ME1 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/uscm/tutorial_rifleman
	name = "Tutorial Rifleman"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = JOB_SQUAD_MARINE
	job_title = JOB_SQUAD_MARINE
	paygrades = list(PAY_SHORT_ME1 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "RFN"
	skills = /datum/skills/pfc/crafty
	minimap_icon = "private"

	uses_special_name = TRUE

/datum/equipment_preset/uscm/tutorial_rifleman/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(MALE, FEMALE)
	var/mob_name = "[random_name(new_human.gender)]"
	new_human.change_real_name(new_human, mob_name)
	var/datum/preferences/preferences = new
	preferences.randomize_appearance(new_human)

/datum/equipment_preset/uscm/tutorial_rifleman/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)

/datum/equipment_preset/uscm/tutorial_rifleman/mrdummy
	name = "Tutorial Rifleman (Dummy)"
	uses_special_name = TRUE

/datum/equipment_preset/uscm/tutorial_rifleman/mrdummy/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.change_real_name(new_human, "Dummy")

/datum/equipment_preset/uscm_ship/uscm_medical/cmo/npc
	name = "Chief Medical Officer (NPC)"
	uses_special_name = TRUE

/datum/equipment_preset/uscm_ship/uscm_medical/cmo/npc/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(MALE, FEMALE)
	var/mob_name = "[random_name(new_human.gender)]"
	new_human.change_real_name(new_human, mob_name)
	var/datum/preferences/preferences = new
	preferences.randomize_appearance(new_human)
