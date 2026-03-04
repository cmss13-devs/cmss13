// **Alpha-Tech Hardware Corporation Survivors**
/datum/equipment_preset/survivor/alphatech
	name = "Survivor - Alpha-Tech Hardware Corporation"
	job_title = JOB_SURVIVOR

	skills = /datum/skills/civilian/survivor
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_CHINESE)
	idtype = /obj/item/card/id/lanyard
	faction = FACTION_ALPHATECH
	faction_group = list(FACTION_ALPHATECH, FACTION_SURVIVOR)
	origin_override = ORIGIN_ALPHATECH
	flags = EQUIPMENT_PRESET_STUB

	access = list(ACCESS_CIVILIAN_PUBLIC)

	minimap_icon = "surv"
	minimap_background = "background_civilian"
	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/survivor/alphatech/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/alphatech, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black, WEAR_FEET)

/datum/equipment_preset/survivor/alphatech/corporate
	name = "Survivor - Alpha-Tech Corporate Liaison"
	job_title = JOB_ALPHATECH_CL
	assignment = JOB_ALPHATECH_CL
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_CHINESE, LANGUAGE_JAPANESE, LANGUAGE_RUSSIAN)
	skills = /datum/skills/civilian/survivor/manager // ToDO: Check what manager skills actually are
	paygrades = list(PAY_SHORT_ATHC1 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ATHC2 = JOB_PLAYTIME_TIER_1, PAY_SHORT_ATHC3 = JOB_PLAYTIME_TIER_2)
	flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/survivor/alphatech/corporate/load_gear(mob/living/carbon/human/new_human)
	..()
	var/random_clothing = rand(1,6)
	var/random_suit = rand (1,2)
	switch(random_clothing)
		if (1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/black, WEAR_BODY)
		if (2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/blue, WEAR_BODY)
		if (3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/brown, WEAR_BODY)
		if (4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/corporate_formal, WEAR_BODY)
		if (5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/field, WEAR_BODY)
		if (6)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/sl_suit, WEAR_BODY)
	switch(random_suit)
		if (1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/bomber, WEAR_JACKET)
		if (2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/vest, WEAR_JACKET)
		if (3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/bomber, WEAR_JACKET)
		if (4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/windbreaker/windbreaker_brown, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable(new_human), WEAR_BACK)

// /datum/equipment_preset/survivor/alphatech/chief_engineer
// 	name = "Alpha-Tech Mining Colony Chief Engineer"
// 	job_title = JOB_ALPHATECH_CHIEF_ENGINEER
// 	assignment = JOB_ALPHATECH_CHIEF_ENGINEER
// 	languages = list(LANGUAGE_ENGLISH, LANGUAGE_CHINESE)
// 	paygrades = list(PAY_SHORT_ATHC_ENG_CE = JOB_PLAYTIME_TIER_0)
// 	skills = /datum/skills/civilian/survivor/engineer // ToDO: Consider making this a CO-like Civ Engineer
// 	survivor_variant = ENGINEERING_SURVIVOR


/datum/equipment_preset/survivor/alphatech/scientist
	name = "Survivor - Alpha-Tech Scientist"
	job_title = JOB_ALPHATECH_SCIENTIST
	assignment = JOB_ALPHATECH_SCIENTIST
	languages = list(LANGUAGE_CHINESE)
	skills = /datum/skills/civilian/survivor/scientist
	paygrades = list(PAY_SHORT_ATHC_SCI = JOB_PLAYTIME_TIER_0)
	survivor_variant = SCIENTIST_SURVIVOR
	flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/survivor/alphatech/scientist/load_gear(mob/living/carbon/human/new_human) // ToDO: Uncopypaste this
	..()
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/brown, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/alphatech, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/tox(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/paper/research_notes/unique/tier_three(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/full(new_human), WEAR_R_STORE)

// /datum/equipment_preset/survivor/alphatech/scientist/research_director
// 	name = "Alpha-Tech Research Director"
// 	job_title = JOB_ALPHATECH_RESEARCH_DIRECTOR // ToDO: Consider making this a CO-like Civ role
// 	assignment = JOB_ALPHATECH_RESEARCH_DIRECTOR
// 	paygrades = list(PAY_SHORT_ATHC_SCI_RD = JOB_PLAYTIME_TIER_0)
// 	languages = list(LANGUAGE_CHINESE, LANGUAGE_ENGLISH)
// 	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/survivor/alphatech/miner
	name = "Survivor - Alpha-Tech Mining Contractor"
	job_title = JOB_ALPHATECH_EMPLOYEE
	assignment = JOB_ALPHATECH_EMPLOYEE
	languages = list(LANGUAGE_CHINESE)
	skills = /datum/skills/civilian/survivor/miner // ToDO: Make this an Engineer-type
	paygrades = list(PAY_SHORT_ATHC1 = JOB_PLAYTIME_TIER_0)
	survivor_variant = CIVILIAN_SURVIVOR
	flags = EQUIPMENT_PRESET_START_OF_ROUND

/datum/equipment_preset/survivor/alphatech/miner/load_gear(mob/living/carbon/human/new_human) // TODO: Uncopypaste this
	..()
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/blue(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/yellow(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pickaxe(new_human), WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(new_human), WEAR_HEAD)

// /datum/equipment_preset/survivor/alphatech/off_duty //TODO: Find something to do with this...
// 	name = "Alpha-Tech Hardware Corporation Employee"
// 	job_title = JOB_ALPHATECH_EMPLOYEE
// 	assignment = JOB_ALPHATECH_EMPLOYEE
// 	languages = list(LANGUAGE_CHINESE)
// 	skills = /datum/skills/military/survivor/usasf/pilot
// 	paygrades = list(PAY_SHORT_CIV = JOB_PLAYTIME_TIER_0)
// 	survivor_variant = CIVILIAN_SURVIVOR

// /datum/equipment_preset/survivor/alphatech/off_duty/load_gear(mob/living/carbon/human/new_human)
// 	..()
