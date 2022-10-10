/datum/equipment_preset/other
	name = "Other"
	languages = list(LANGUAGE_ENGLISH)

//*****************************************************************************************************/

/datum/equipment_preset/other/mutineer
	name = "Mutineer"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/mutineer/load_status(mob/living/carbon/human/H)
	. = ..()
	H.mob_flags |= MUTINEER
	H.hud_set_squad()

	to_chat(H, SPAN_HIGHDANGER("<hr>You are now a Mutineer!"))
	to_chat(H, SPAN_DANGER("Please check the rules to see what you can and can't do as a mutineer.<hr>"))

/datum/equipment_preset/other/mutineer/leader
	name = "Mutineer Leader"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/other/mutineer/leader/load_status(mob/living/carbon/human/H)
	for(var/datum/action/human_action/activable/mutineer/A in H.actions)
		A.remove_from(H)

	var/list/abilities = subtypesof(/datum/action/human_action/activable/mutineer)
	for(var/type in abilities)
		give_action(H, type)

/datum/equipment_preset/other/freelancer
	name = "Freelancer"

	assignment = "Freelancer"
	rank = FACTION_FREELANCER
	idtype = /obj/item/card/id/data
	faction = FACTION_FREELANCER

/datum/equipment_preset/other/freelancer/New()
	. = ..()
	access = get_all_accesses()

/datum/equipment_preset/other/freelancer/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(60;MALE,40;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(first_names_male_colonist)] [pick(last_names_colonist)]"
		H.f_style = "5 O'clock Shadow"
	else
		random_name = "[pick(first_names_female_colonist)] [pick(last_names_colonist)]"
	H.change_real_name(H, random_name)
	H.age = rand(20,45)
	H.r_hair = 25
	H.g_hair = 25
	H.b_hair = 35

//*****************************************************************************************************/

/datum/equipment_preset/other/freelancer/standard
	name = "Freelancer (Standard)"
	paygrade = "Freelancer Standard"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/freelancer

/datum/equipment_preset/other/freelancer/standard/load_gear(mob/living/carbon/human/H)
	//generic clothing
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/freelancer, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	spawn_merc_helmet(H)
	//storage and specific stuff, they all get an ERT medpouch.
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)

	load_freelancer_soldier(H)

/datum/equipment_preset/other/freelancer/standard/proc/load_freelancer_soldier(mob/living/carbon/human/H)
	var/percentage = rand(1, 100)
	switch(percentage)
		//most freelancers are rifleman, most others are breachers, some have HPRs.
		if(1 to 66)
			load_freelancer_rifleman(H)
		if(67 to 85)
			load_freelancer_shotgunner(H)
		else
			load_freelancer_machinegunner(H)

/datum/equipment_preset/other/freelancer/standard/proc/load_freelancer_machinegunner(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	spawn_merc_weapon(H,1,6)
	spawn_weapon(/obj/item/weapon/gun/rifle/lmg, /obj/item/ammo_magazine/rifle/lmg, H, 0, 5) //HPR mini-spec
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/lmg/holo_target, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/lmg/holo_target, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_R_STORE)

/datum/equipment_preset/other/freelancer/standard/proc/load_freelancer_shotgunner(mob/living/carbon/human/H)
	//storage items
	H.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	spawn_weapon(/obj/item/weapon/gun/shotgun/type23, pick(shotgun_handfuls_8g), H, 0, 14) //shotgunner mini-spec
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied_incendiary, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied_incendiary, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/smokebomb, WEAR_IN_BACK)


/datum/equipment_preset/other/freelancer/standard/proc/load_freelancer_rifleman(mob/living/carbon/human/H)
	//storage items
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/upp, WEAR_R_STORE)
	spawn_merc_weapon(H)
	//backpack stuff
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)

//*****************************************************************************************************/

/datum/equipment_preset/other/freelancer/medic
	name = "Freelancer (Medic)"
	paygrade = "Freelancer Medic"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Freelancer Medic"
	skills = /datum/skills/freelancer/combat_medic

/datum/equipment_preset/other/freelancer/medic/load_gear(mob/living/carbon/human/H)
	var/shotgunner = FALSE
	if(prob(50))
		shotgunner = TRUE
		H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer, WEAR_BODY)
	else
		var/obj/item/clothing/under/marine/veteran/freelancer/FREELANCER = new()
		var/obj/item/clothing/accessory/storage/surg_vest/equipped/W = new()
		FREELANCER.attach_accessory(H, W)
		H.equip_to_slot_or_del(FREELANCER, WEAR_BODY)

	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/freelancer, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/PMC, WEAR_HANDS)
	spawn_merc_helmet(H)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)

	load_freelancer_medic(H, shotgunner)

/datum/equipment_preset/other/freelancer/medic/proc/load_freelancer_medic(mob/living/carbon/human/H, shotgunner)
	if(shotgunner)
		load_shotgunner_medic(H)
	else
		load_standard_medic(H)

/datum/equipment_preset/other/freelancer/medic/proc/load_shotgunner_medic(mob/living/carbon/human/H)
	//storage items
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/large, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full/with_suture_and_graft, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BELT)
	//stuff in backpack
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	//gun
	spawn_merc_shotgun(H)

/datum/equipment_preset/other/freelancer/medic/proc/load_standard_medic(mob/living/carbon/human/H, /obj/item/clothing/under/marine/veteran/freelancer/FREELANCER)
	//storage items
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	//stuff in backpack
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK) //Line is in vest.
	spawn_merc_rifle(H)

//*****************************************************************************************************/

/datum/equipment_preset/other/freelancer/leader
	name = "Freelancer (Leader)"
	paygrade = "Freelancer Leader"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "Freelancer Warlord"
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_RUSSIAN, LANGUAGE_CHINESE, LANGUAGE_JAPANESE, LANGUAGE_YAUTJA)

	skills = /datum/skills/freelancer/SL

/datum/equipment_preset/other/freelancer/leader/load_gear(mob/living/carbon/human/H)

	//No random helmet, so that it's more clear that he's the leader
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/freelancer, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/freelancer/beret, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	if(H.disabilities & NEARSIGHTED)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(H), WEAR_EYES)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/marine, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)

	spawn_weapon(/obj/item/weapon/gun/rifle/m41aMK1, /obj/item/ammo_magazine/rifle/m41aMK1, H, 0, 9)
	spawn_merc_weapon(H,1,2)

//*****************************************************************************************************/

/datum/equipment_preset/other/elite_merc
	name = "Elite Mercenary"

	assignment = "Elite Mercenary"
	rank = "Mercenary"
	idtype = /obj/item/card/id/centcom
	faction = FACTION_MERCENARY

/datum/equipment_preset/other/elite_merc/New()
	. = ..()
	access = get_all_accesses()

/datum/equipment_preset/other/elite_merc/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(70;MALE,30;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(first_names_male_colonist)] [pick(last_names_colonist)]"
		H.f_style = "5 O'clock Shadow"
	else
		random_name = "[pick(first_names_female_colonist)] [pick(last_names_colonist)]"
	H.change_real_name(H, random_name)
	H.age = rand(20,45)
	H.r_hair = rand(15,35)
	H.g_hair = rand(15,35)
	H.b_hair = rand(25,45)

//*****************************************************************************************************/

/datum/equipment_preset/other/elite_merc/standard
	name = "Elite Mercenary (Standard Miner)"
	paygrade = "Elite Freelancer Standard"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/centcom
	assignment = "Mercenary Miner"
	rank = "Mercenary"
	skills = /datum/skills/mercenary/elite
	faction = FACTION_MERCENARY

/datum/equipment_preset/other/elite_merc/standard/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/other/elite_merc/standard/load_gear(mob/living/carbon/human/H)
	//TODO: add unique backpacks and satchels
	//clothes
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary/miner, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary/miner, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary/miner, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles, WEAR_EYES)
	//storage items, belt spawning is handled in the spawn elite weapon proc.
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/upp, WEAR_R_STORE)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/hefa, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)

	spawn_merc_elite_weapon(H, 12, 50, 1)

//*****************************************************************************************************/

/datum/equipment_preset/other/elite_merc/heavy
	name = "Elite Mercenary (Heavy)"
	paygrade = "Elite Freelancer Heavy"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/centcom
	assignment = "Mercenary Heavy"
	rank = "Mercenary"
	skills = /datum/skills/mercenary/elite/heavy
	faction = FACTION_MERCENARY

/datum/equipment_preset/other/elite_merc/heavy/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/other/elite_merc/heavy/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	//clothes
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary/heavy, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles, WEAR_EYES)
	//storage items
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/heavy, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/pressurized_reagent_canister/oxycodone, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_R_STORE)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/m15, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/phosphorus, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/minigun(H), WEAR_IN_BACK)
	//gun
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/minigun(H), WEAR_J_STORE)


//*****************************************************************************************************/
/datum/equipment_preset/other/elite_merc/engineer
	name = "Elite Mercenary (Engineer)"
	paygrade = "Elite Freelancer Engineer"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/data
	assignment = "Mercenary Engineer"
	rank = "Mercenary"
	skills = /datum/skills/mercenary/elite/engineer
	faction = FACTION_MERCENARY

/datum/equipment_preset/other/elite_merc/engineer/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/other/elite_merc/engineer/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	//snowflake webbing
	var/obj/item/clothing/under/marine/veteran/mercenary/support/SUPPORT = new()
	var/obj/item/clothing/accessory/storage/black_vest/W = new()
	SUPPORT.attach_accessory(H, W)
	W.hold.storage_slots = 7
	H.equip_to_slot_or_del(SUPPORT, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/bicaridine, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/bicaridine, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/kelotane, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/kelotane, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/tramadol, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/tramadol, WEAR_IN_ACCESSORY)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/hypospray/autoinjector/emergency, WEAR_IN_ACCESSORY)
	//clothes
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary/support, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary/support/engineer, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles, WEAR_EYES)
	//storage items
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked/elite_merc, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/large, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical/full, WEAR_R_STORE)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastic, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/large_stack, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/mini, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/defenses/handheld/sentry/mini, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)
	//gun
	spawn_merc_elite_weapon(H, 9, 100, 0) //only shotguns

//*****************************************************************************************************/

/datum/equipment_preset/other/elite_merc/medic
	name = "Elite Mercenary (Medic)"
	paygrade = "Elite Freelancer Medic"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/centcom
	assignment = "Mercenary Medic"
	rank = "Mercenary"
	skills = /datum/skills/mercenary/elite/medic
	faction = FACTION_MERCENARY

/datum/equipment_preset/other/elite_merc/medic/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/other/elite_merc/medic/load_gear(mob/living/carbon/human/H)
	//webbing
	var/obj/item/clothing/under/marine/veteran/mercenary/support/SUPPORT = new()
	var/obj/item/clothing/accessory/storage/surg_vest/equipped/W = new()
	SUPPORT.attach_accessory(H, W)
	H.equip_to_slot_or_del(SUPPORT, WEAR_BODY)
	//clothing
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/medhud, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary/support, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary/support, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary/support, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)
	//storage items
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/upp/full, WEAR_WAIST)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/roller/surgical, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft, WEAR_IN_BACK) //Line in vest.
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)
	//gun
	spawn_merc_elite_weapon(H, 7, 0, 0) //no shotguns

//*****************************************************************************************************/

/datum/equipment_preset/other/elite_merc/leader
	name = "Elite Mercenary (Leader)"
	paygrade = "Elite Freelancer Leader"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/centcom
	assignment = "Mercenary Warlord"
	rank = "Mercenary"
	skills = /datum/skills/mercenary/elite/leader
	faction = FACTION_MERCENARY

/datum/equipment_preset/other/elite_merc/leader/New()
	. = ..()
	access = get_antagonist_pmc_access()

/datum/equipment_preset/other/elite_merc/leader/load_gear(mob/living/carbon/human/H)
	//clothes
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/PMC/knife, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/PMC, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/medhud, WEAR_EYES)
	//storage items
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/explosive/C4, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/autoinjector/full, WEAR_R_STORE)
	//backpack and stuff in it
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/m15, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/smoke, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/packet/phosphorus/upp, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/motiondetector/hacked/elite_merc, WEAR_IN_BACK)
	//gun
	spawn_merc_elite_weapon(H, 7, 25, 1) //lower shotgun chance, but not zero

//*****************************************************************************************************/

/datum/equipment_preset/other/business_person
	name = "Business Person"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_MARINE
	idtype = /obj/item/card/id/silver/cl
	assignment = "Corporate Representative"
	rank = "Corporate Representative"
	skills = /datum/skills/civilian

/datum/equipment_preset/other/business_person/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()

/datum/equipment_preset/other/business_person/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_if_possible(new /obj/item/clothing/under/lawyer/bluesuit, WEAR_BODY)
	H.equip_if_possible(new /obj/item/clothing/shoes/centcom, WEAR_FEET)
	H.equip_if_possible(new /obj/item/clothing/gloves/white, WEAR_HANDS)

	H.equip_if_possible(new /obj/item/clothing/glasses/sunglasses, WEAR_EYES)
	H.equip_if_possible(new /obj/item/clipboard, WEAR_WAIST)

//*****************************************************************************************************/

/datum/equipment_preset/other/compression_suit
	name = "Mk50 Compression Suit"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_PMC
	skills = /datum/skills/pfc
	idtype = /obj/item/card/id/data

/datum/equipment_preset/other/compression_suit/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots, WEAR_FEET)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/compression, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/compression, WEAR_HEAD)
	var /obj/item/tank/jetpack/J = new /obj/item/tank/jetpack/oxygen(H)
	H.equip_to_slot_or_del(J, WEAR_BACK)
	J.toggle()
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath, WEAR_FACE)
	J.Topic(null, list("stat" = 1))
	spawn_merc_weapon(H)


//*****************************************************************************************************/

/datum/equipment_preset/other/pizza
	name = "Pizza"
	flags = EQUIPMENT_PRESET_EXTRA

	languages = list(LANGUAGE_ENGLISH, LANGUAGE_RUSSIAN, LANGUAGE_JAPANESE, LANGUAGE_CHINESE) //Just in case they are delivering to UPP or CLF...
	idtype = /obj/item/card/id/pizza
	assignment = "Pizza Deliverer"
	rank = FACTION_PIZZA
	skills = /datum/skills/civilian
	faction = FACTION_PIZZA

/datum/equipment_preset/other/pizza/New()
	. = ..()
	access = get_freelancer_access()

/datum/equipment_preset/other/pizza/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(MALE,FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(first_names_male)] [pick(last_names)]"
	else
		random_name = "[pick(first_names_female)] [pick(last_names)]"
	H.change_real_name(H, random_name)
	H.age = rand(17,45)

/datum/equipment_preset/other/pizza/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/pizza, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/soft/red, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/red, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/pizzabox/margherita, WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/dr_gibb, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/holdout, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/pizzabox/vegetable, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/pizzabox/mushroom, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/pizzabox/meat, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/dr_gibb, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/thirteenloko, WEAR_IN_BACK)

/datum/equipment_preset/other/souto
	name = "Souto Man"
	flags = EQUIPMENT_PRESET_EXTRA

	languages = list(LANGUAGE_ENGLISH, LANGUAGE_RUSSIAN, LANGUAGE_JAPANESE, LANGUAGE_CHINESE) //Just in case they are delivering to UPP or CLF...
	idtype = /obj/item/card/id/souto
	assignment = FACTION_SOUTO
	rank = "Souto Man"
	skills = /datum/skills/souto
	faction = FACTION_SOUTO

/datum/equipment_preset/other/souto/New()
	. = ..()
	access = get_freelancer_access()

/datum/equipment_preset/other/souto/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = MALE
	H.change_real_name(H, "Souto Man")
	H.age = 40

/datum/equipment_preset/other/souto/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/souto, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/souto, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/souto, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/souto, WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/device/radio, WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/fake_mustache, WEAR_FACE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/souto, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/souto, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/souto, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses, WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/souto, WEAR_FEET)
	var/obj/vehicle/souto/super/V = new
	V.forceMove(H.loc)
	V.buckle_mob(H, H)

//*****************************************************************************************************/

/datum/equipment_preset/other/zombie
	name = "Zombie"
	flags = EQUIPMENT_PRESET_EXTRA
	rank = FACTION_ZOMBIE
	languages = list("Zombie")
	skills = null //no restrictions
	faction = FACTION_ZOMBIE

//Overloading the function to be able to spawn gear first
/datum/equipment_preset/other/zombie/load_preset(mob/living/carbon/human/H, var/randomise = FALSE)
	if(randomise)
		load_name(H)
	load_skills(H) //skills are set before equipment because of skill restrictions on certain clothes.
	load_languages(H)
	load_gear(H)
	load_id(H)
	load_status(H)
	load_vanity(H)
	load_race(H)//Race is loaded last, otherwise we wouldn't be able to equip gear!
	H.assigned_equipment_preset = src
	H.regenerate_icons()

/datum/equipment_preset/other/zombie/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(MALE, FEMALE)
	var/datum/preferences/A = new
	A.randomize_appearance(H)
	var/random_name = capitalize(pick(H.gender == MALE ? first_names_male : first_names_female)) + " " + capitalize(pick(last_names))
	H.change_real_name(H, random_name)
	H.age = rand(21,45)

/datum/equipment_preset/other/zombie/load_id(mob/living/carbon/human/H, client/mob_client)
	var/obj/item/clothing/under/uniform = H.w_uniform
	if(istype(uniform))
		uniform.has_sensor = UNIFORM_HAS_SENSORS
		uniform.sensor_faction = FACTION_COLONIST
	H.job = "Zombie"
	H.faction = faction
	return ..()

/datum/equipment_preset/other/zombie/load_race(mob/living/carbon/human/H)
	H.set_species("Human") // Set back, so that we can get our claws again

	H.set_species("Zombie")

/datum/equipment_preset/other/zombie/load_gear(mob/living/carbon/human/H)
	var/uniform_path = pick(/obj/item/clothing/under/colonist, /obj/item/clothing/under/colonist/ua_civvies, /obj/item/clothing/under/colonist/wy_davisone, /obj/item/clothing/under/colonist/wy_joliet_shopsteward, /obj/item/clothing/under/marine/ua_riot, /obj/item/clothing/under/suit_jacket/manager, /obj/item/clothing/under/suit_jacket/director)
	H.equip_to_slot_or_del(new uniform_path, WEAR_BODY)
	var/shoe_path = pick(/obj/item/clothing/shoes/laceup, /obj/item/clothing/shoes/leather, /obj/item/clothing/shoes/jackboots)
	H.equip_to_slot_or_del(new shoe_path, WEAR_FEET)

//*****************************************************************************************************/

/datum/equipment_preset/other/gladiator
	name = "Gladiator"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/dogtag
	skills = /datum/skills/gladiator

	assignment = "Bestiarius"
	rank = FACTION_GLADIATOR
	faction = FACTION_GLADIATOR

/datum/equipment_preset/other/gladiator/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(MALE, FEMALE)
	var/datum/preferences/A = new
	A.randomize_appearance(H)
	var/random_name = capitalize(pick(H.gender == MALE ? first_names_male_gladiator : first_names_female_gladiator))
	H.change_real_name(H, random_name)
	H.age = rand(21,45)

/datum/equipment_preset/other/gladiator/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/gladiator, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/chainshirt/hunter, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/gladiator, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/weapon/shield/riot, WEAR_R_HAND)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/claymore/mercsword, WEAR_L_HAND)

	var/obj/item/lantern = new /obj/item/device/flashlight/lantern(H)
	lantern.name = "Beacon of Holy Light"

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)
	H.equip_to_slot_or_del(lantern, WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/other/gladiator/champion
	name = "Gladiator Champion"
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/gladiator/champion
	assignment = "Samnite"
	rank = "Samnite"

/datum/equipment_preset/other/gladiator/champion/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/gladiator, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/chainshirt/hunter, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/gladiator, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/weapon/shield/riot, WEAR_R_HAND)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/claymore/mercsword, WEAR_L_HAND)

	var/obj/item/lantern = new /obj/item/device/flashlight/lantern(H)
	lantern.name = "Beacon of Holy Light"

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)
	H.equip_to_slot_or_del(lantern, WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/other/gladiator/leader
	name = "Gladiator Leader"
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/gladiator/champion/leader
	assignment = "Spartacus"
	rank = "Spartacus"

/datum/equipment_preset/other/gladiator/leader/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/UPP, WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/gladiator, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/chainshirt/hunter, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/gladiator, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/weapon/shield/riot, WEAR_R_HAND)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/claymore/mercsword, WEAR_L_HAND)

	var/obj/item/lantern = new /obj/item/device/flashlight/lantern(H)
	lantern.name = "Beacon of Holy Light"

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert, WEAR_L_STORE)
	H.equip_to_slot_or_del(lantern, WEAR_R_STORE)

//*****************************************************************************************************/

/datum/equipment_preset/other/xeno_cultist
	name = "Cultist - Xeno Cultist"
	faction = FACTION_XENOMORPH
	flags = EQUIPMENT_PRESET_EXTRA
	idtype = /obj/item/card/id/lanyard
	skills = /datum/skills/civilian/survivor

	languages = list(LANGUAGE_XENOMORPH, LANGUAGE_ENGLISH)

	assignment = "Cultist"
	rank = "Cultist"

/datum/equipment_preset/other/xeno_cultist/New()
	. = ..()
	access = get_all_civilian_accesses()

/datum/equipment_preset/other/xeno_cultist/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chaplain/cultist(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)

	var/obj/item/clothing/suit/cultist_hoodie/hoodie = new /obj/item/clothing/suit/cultist_hoodie(H)
	hoodie.flags_item |= NODROP|DELONDROP
	H.equip_to_slot_or_del(hoodie, WEAR_JACKET)

	var/obj/item/clothing/head/cultist_hood/hood = new /obj/item/clothing/head/cultist_hood(H)
	hood.flags_item |= NODROP|DELONDROP
	H.equip_to_slot_or_del(hood, WEAR_HEAD)

	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(H), WEAR_HANDS)

//*****************************************************************************************************/
/datum/equipment_preset/other/xeno_cultist/load_status(mob/living/carbon/human/H, var/hivenumber = XENO_HIVE_NORMAL)
	if(SSticker.mode && H.mind)
		SSticker.mode.xenomorphs += H.mind

	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
	if(hive)
		H.faction = hive.internal_faction
		if(hive.leading_cult_sl == H)
			hive.leading_cult_sl = null
	H.hivenumber = hivenumber

	GLOB.xeno_cultists += H

	var/list/huds_to_add = list(MOB_HUD_XENO_INFECTION, MOB_HUD_XENO_STATUS)

	for(var/hud_to_add in huds_to_add)
		var/datum/mob_hud/hud = huds[hud_to_add]
		hud.add_hud_to(H)

	var/list/actions_to_add = subtypesof(/datum/action/human_action/activable/cult)

	if(istype(H.wear_suit, /obj/item/clothing/suit/cultist_hoodie) || istype(H.head, /obj/item/clothing/head/cultist_hood))
		actions_to_add -= /datum/action/human_action/activable/cult/obtain_equipment

	for(var/action_to_add in actions_to_add)
		give_action(H, action_to_add)

	H.default_lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	H.update_sight()

/datum/equipment_preset/other/xeno_cultist/leader
	name = "Cultist - Xeno Cultist Leader"
	uses_special_name = TRUE
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/cultist_leader

	assignment = "Cultist Leader"
	rank = "Cultist Leader"

/datum/equipment_preset/other/xeno_cultist/leader/load_gear(mob/living/carbon/human/H)
	. = ..()
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/cultist(H), WEAR_EYES)

/datum/equipment_preset/other/xeno_cultist/leader/load_status(mob/living/carbon/human/H)
	. = ..()

	var/datum/hive_status/hive = GLOB.hive_datum[H.hivenumber]
	hive.leading_cult_sl = H

	var/list/types = subtypesof(/datum/action/human_action/activable/cult_leader)
	for(var/type in types)
		give_action(H, type)

//*****************************************************************************************************/

/datum/equipment_preset/other/professor_dummy
	name = "DUMMY"
	flags = EQUIPMENT_PRESET_EXTRA
	assignment = "DUMMY"
	rank = "DUMMY"
	idtype = /obj/item/card/id/dogtag
	uses_special_name = TRUE

/datum/equipment_preset/other/professor_dummy/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(MALE, FEMALE)
	H.real_name = "Professor DUMMY the Medical Mannequin"
	H.name = H.real_name
	H.age = rand(1,5)
	var/datum/preferences/A = new
	A.randomize_appearance(H)


/datum/equipment_preset/other/professor_dummy/load_race(mob/living/carbon/human/H)
	. = ..()
	//Can't hug the dummy! Otherwise it's basically human...
	H.huggable = FALSE
	H.mob_flags |= EASY_SURGERY //Nurses can practise surgery on it.

/datum/equipment_preset/other/professor_dummy/load_gear(mob/living/carbon/human/H)
	var/obj/item/device/professor_dummy_tablet/tablet = new /obj/item/device/professor_dummy_tablet(H)
	tablet.link_mob(H)
	H.equip_to_slot_or_del(tablet, WEAR_R_HAND)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical, WEAR_BODY)

//*****************************************************************************************************/

/datum/equipment_preset/other/tank
	name = "Event Vehicle Crewman (CRMN)"
	flags = EQUIPMENT_PRESET_EXTRA

	idtype = /obj/item/card/id/dogtag
	assignment = JOB_CREWMAN
	rank = JOB_CREWMAN
	paygrade = "E4"
	role_comm_title = "CRMN"
	minimum_age = 30
	skills = /datum/skills/tank_crew

	faction = FACTION_NEUTRAL

/datum/equipment_preset/other/tank/New()
	. = ..()
	access = get_antagonist_access()

/datum/equipment_preset/other/tank/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/tanker(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/vc(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/commander(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/tanker(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/tool/weldpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tank(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/tech/tanker(H), WEAR_HEAD)

	spawn_weapon(/obj/item/weapon/gun/smg/m39, /obj/item/ammo_magazine/smg/m39/extended, H, 0, 3)

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
	rank = "Crewman Trainee"
	paygrade = "E3"
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

/datum/equipment_preset/other/tank/trainee/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/tanker(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(H), WEAR_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tank(H), WEAR_R_STORE)

//*****************************************************************************************************/
