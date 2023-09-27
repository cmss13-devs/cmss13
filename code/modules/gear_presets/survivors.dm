/datum/equipment_preset/survivor
	name = JOB_SURVIVOR
	assignment = JOB_SURVIVOR
	rank = JOB_SURVIVOR

	skills = /datum/skills/civilian/survivor
	languages = list(LANGUAGE_ENGLISH)
	paygrade = "C"
	idtype = /obj/item/card/id/lanyard
	faction = FACTION_SURVIVOR
	faction_group = list(FACTION_SURVIVOR)
	origin_override = ORIGIN_CIVILIAN

	access = list(ACCESS_CIVILIAN_PUBLIC)

	minimap_icon = "surv"
	minimap_background = MINIMAP_ICON_BACKGROUND_CIVILIAN

	var/survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(MALE, FEMALE)
	var/datum/preferences/A = new
	A.randomize_appearance(new_human)
	var/random_name = capitalize(pick(new_human.gender == MALE ? first_names_male : first_names_female)) + " " + capitalize(pick(last_names))
	new_human.change_real_name(new_human, random_name)
	new_human.age = rand(21,45)

/datum/equipment_preset/survivor/load_gear(mob/living/carbon/human/new_human) // Essentially where you will put the most essential piece of kit you want survivors to spawn with.
	add_random_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human), WEAR_IN_BACK)
	add_survivor_weapon_pistol(new_human)

/datum/equipment_preset/survivor/load_id(mob/living/carbon/human/new_human, client/mob_client)
	var/obj/item/clothing/under/uniform = new_human.w_uniform
	if(istype(uniform))
		uniform.has_sensor = UNIFORM_HAS_SENSORS
		uniform.sensor_faction = FACTION_COLONIST
	return ..()

/*
From map_config.dm

Standart Survivors :	/datum/equipment_preset/survivor/scientist,
						/datum/equipment_preset/survivor/doctor,
						/datum/equipment_preset/survivor/chef,
						/datum/equipment_preset/survivor/chaplain,
						/datum/equipment_preset/survivor/miner,
						/datum/equipment_preset/survivor/colonial_marshal,
						/datum/equipment_preset/survivor/engineer,

*/


// 1 ----- Scientist Survivor

/datum/equipment_preset/survivor/scientist
	name = "Survivor - Scientist"
	assignment = "Scientist"
	skills = /datum/skills/civilian/survivor/scientist
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge/scientist
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY)

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/survivor/scientist/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/virologist(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/green(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/virologist(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/green(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/chem(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/green(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/paper/research_notes/good(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/glass/beaker/vial/random/good(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/full(new_human), WEAR_R_STORE)
	add_survivor_weapon_civilian(new_human)
	add_random_survivor_research_gear(new_human)

	..()

// 2 ----- Doctor Survivor

/datum/equipment_preset/survivor/doctor
	name = "Survivor - Doctor"
	assignment = "Doctor"
	skills = /datum/skills/civilian/survivor/doctor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_COMMAND)

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/survivor/doctor/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/med(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(new_human), WEAR_JACKET)
	var/random_gear = rand(0,4)
	switch(random_gear)
		if(0)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/alternate(new_human), WEAR_R_STORE)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medical/full(new_human), WEAR_R_STORE)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_R_STORE)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/first_responder/full(new_human), WEAR_R_STORE)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full_advanced(new_human), WEAR_R_STORE)
	add_random_survivor_medical_gear(new_human)
	add_survivor_weapon_civilian(new_human)

	..()

// 3 ----- Chef Survivor

/datum/equipment_preset/survivor/chef
	name = "Survivor - Chef"
	assignment = "Chef"
	skills = /datum/skills/civilian/survivor/chef
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/chef/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/chef(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/kitchen/rollingpin(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general(new_human), WEAR_R_STORE)
	add_survivor_weapon_civilian(new_human)

	..()

// 4 ----- Chaplain Survivor

/datum/equipment_preset/survivor/chaplain
	name = "Survivor - Chaplain"
	assignment = "Chaplain"
	skills = /datum/skills/civilian/survivor/chaplain
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/chaplain/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chaplain(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/holidaypriest(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/bible/booze(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general(new_human), WEAR_R_STORE)
	add_survivor_weapon_civilian(new_human)

	..()

// 5 ----- Miner Survivor

/datum/equipment_preset/survivor/miner
	name = "Survivor - Miner"
	assignment = "Miner"
	skills = /datum/skills/civilian/survivor/miner
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/datum/equipment_preset/survivor/miner/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/miner(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pickaxe(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(new_human), WEAR_HEAD)
	add_survivor_weapon_civilian(new_human)

	..()

// 6 ---- Colonial Marshal Survivor

/datum/equipment_preset/survivor/colonial_marshal
	name = "Survivor - Colonial Marshal Deputy"
	assignment = "CMB Deputy"
	paygrade = "GS-9"
	skills = /datum/skills/civilian/survivor/marshal
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/deputy
	role_comm_title = "CMB DEP"
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/colonial_marshal/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/CM_uniform(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CMB/limited(new_human), WEAR_L_EAR)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/CMB(new_human), WEAR_HEAD)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large(new_human), WEAR_R_STORE)
	add_survivor_weapon_security(new_human)

	..()

// 7 ----- Engineering Survivor

/datum/equipment_preset/survivor/engineer
	name = "Survivor - Engineer"
	assignment = "Engineer"
	skills = /datum/skills/civilian/survivor/engineer
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/engineer/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/engineer(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/weldingtool/largetank(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/med_small_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	add_survivor_weapon_civilian(new_human)

	..()
/*
Everything bellow is a parent used as a base for one or multiple maps.
*/

// ----- Interstellar Human Rights Survivor

// it's used as a base for soro map.
/datum/equipment_preset/survivor/interstellar_human_rights_observer
	name = "Survivor - Interstellar Human Rights Observer"
	assignment = "Interstellar Human Rights Observer(Colony)"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_COMMAND)

/datum/equipment_preset/survivor/interstellar_human_rights_observer/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/suspenders(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	add_random_cl_survivor_loot(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(new_human), WEAR_HEAD)
	add_survivor_weapon_civilian(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/document(new_human), WEAR_R_STORE)

	..()


// ----- CL Survivor
//used as a base for shiva and solaris spawn.

/datum/equipment_preset/survivor/corporate
	name = "Survivor - Corporate Liaison"
	assignment = "Corporate Liaison"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	paygrade = "WYC2"
	idtype = /obj/item/card/id/silver/clearance_badge/cl
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_COMMAND,
		ACCESS_WY_GENERAL,
		ACCESS_WY_COLONIAL,
		ACCESS_WY_EXEC,
	)
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)

	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/survivor/corporate/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/formal(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	add_random_cl_survivor_loot(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/centcom(new_human), WEAR_FEET)
	add_survivor_weapon_civilian(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/document(new_human), WEAR_R_STORE)

	..()

/datum/equipment_preset/survivor/corporate/load_rank(mob/living/carbon/human/new_human)
	if(new_human.client)
		var/playtime = get_job_playtime(new_human.client, JOB_CORPORATE_LIAISON)
		if(new_human.client.prefs.playtime_perks)
			if(playtime > JOB_PLAYTIME_TIER_4)
				return "WYC5"
			else if(playtime > JOB_PLAYTIME_TIER_3)
				return "WYC4"
			else if(playtime > JOB_PLAYTIME_TIER_2)
				return "WYC3"
			else
				return paygrade
	return paygrade

// ----- Security Survivor
/*

present in xenomorph.dm file

var/list/survivor_types = list(
		/datum/equipment_preset/survivor/scientist,
		/datum/equipment_preset/survivor/doctor,
		/datum/equipment_preset/survivor/security,
		/datum/equipment_preset/survivor/engineer
	)

and is used as a base for all of the maps.

*/

/datum/equipment_preset/survivor/security
	name = "Survivor - Security"
	assignment = "Security"
	skills = /datum/skills/civilian/survivor/marshal
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/data
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_BRIG,ACCESS_CIVILIAN_COMMAND)

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/security/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet(new_human), WEAR_HEAD)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine(new_human), WEAR_R_STORE)
	add_survivor_weapon_security(new_human)
	..()

// ---- Trucker Survivor

// it's used as a base for kutjevo lv nv solaris and trijent maps.
/datum/equipment_preset/survivor/trucker
	name = "Survivor - Trucker"
	assignment = "Trucker"
	skills = /datum/skills/civilian/survivor/trucker
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC,ACCESS_CIVILIAN_ENGINEERING,ACCESS_CIVILIAN_LOGISTICS)

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/trucker/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/overalls(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/yellow(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/hardpoint/locomotion/van_wheels(new_human), WEAR_R_HAND)
	add_survivor_weapon_civilian(new_human)

	..()

// ----- CL Survivor

//this is used as a base for corsat and nv
/datum/equipment_preset/survivor/interstellar_commerce_commission_liason
	name = "Survivor - Interstellar Commerce Commission Liaison"
	assignment = "Interstellar Commerce Commission Corporate Liaison"
	skills = /datum/skills/civilian/survivor
	idtype = /obj/item/card/id/silver/cl
	paygrade = "WYC2"
	role_comm_title = "ICC Rep."
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/survivor/interstellar_commerce_commission_liason/New()
	. = ..()
	access = get_access(ACCESS_LIST_CIVIL_LIAISON)

/datum/equipment_preset/survivor/interstellar_commerce_commission_liason/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CMB/limited(new_human), WEAR_L_EAR)

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/centcom(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/white(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/insulated(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/document(new_human), WEAR_R_STORE)
	add_survivor_weapon_civilian(new_human)
	add_random_cl_survivor_loot(new_human)

	..()


/*
everything bellow isn't used or out of place.

*/


// ----- Prisioner Survivors
// after double check prisoner isn't being used anywhere.
/datum/equipment_preset/survivor/prisoner
	name = "Survivor - Prisoner"
	assignment = "Prisoner"
	skills = /datum/skills/civilian/survivor/prisoner
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/prisoner/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/orange(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	if(prob(50)) new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet(new_human), WEAR_HEAD)
	if(prob(50)) new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(new_human.back), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(new_human), WEAR_R_STORE)
	add_survivor_weapon_civilian(new_human)
	..()

// after double check gangleader isn't being used anywhere.
/datum/equipment_preset/survivor/gangleader
	name = "Survivor - Gang Leader"
	assignment = "Gang Leader"
	skills = /datum/skills/civilian/survivor/gangleader
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/gangleader/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/orange(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	if(prob(50)) new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet(new_human), WEAR_HEAD)
	if(prob(50)) new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(new_human.back), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	add_survivor_weapon_civilian(new_human)
	..()

// ----- Civilian Survivor

// after double check civilian isn't being used anywhere.
/datum/equipment_preset/survivor/civilian
	name = "Survivor - Civilian"
	assignment = "Civilian"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/civilian/load_gear(mob/living/carbon/human/new_human)
	var/random_gear = rand(0, 3)
	switch(random_gear)
		if(0) // Normal Colonist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
		if(1) // Janitor
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/janitor(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/vir(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/purple(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/mgoggles(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/purple(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/galoshes(new_human), WEAR_FEET)
		if(2) // Bar Tender
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/waiter(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/lawyer/bluejacket(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/bowlerhat(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/fake_mustache(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/black(new_human), WEAR_HANDS)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/beer_pack(new_human.back), WEAR_IN_BACK)
		if(3) // Botanist
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/hyd(new_human), WEAR_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/apron(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/hatchet(new_human.back), WEAR_IN_BACK)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general(new_human), WEAR_R_STORE)
	add_survivor_weapon_civilian(new_human)

	..()

// --- Salesman Survivor

// after double check salesman isn't being used anywhere.
/datum/equipment_preset/survivor/salesman
	name = "Survivor - Salesman"
	assignment = "Salesman"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/data
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/salesman/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/wcoat(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/document(new_human), WEAR_R_STORE)
	add_random_cl_survivor_loot(new_human)
	add_survivor_weapon_civilian(new_human)
	..()


// ----- Roughneck Survivor

// after double check roughneck isn't being used anywhere.
/datum/equipment_preset/survivor/roughneck
	name = "Survivor - Roughneck"
	assignment = "Roughneck"
	skills = /datum/skills/civilian/survivor/pmc
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/roughneck/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/color/white(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/apron/overalls(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/centcom(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/centcom(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large(new_human), WEAR_R_STORE)
	add_pmc_survivor_weapon(new_human)

	..()

// ----- Bum Survivor

// after double check beachbum isn't being used anywhere.
/datum/equipment_preset/survivor/beachbum
	name = "Survivor - Beach Bum"
	assignment = "Beach Bum"
	skills = /datum/skills/civilian/survivor/prisoner
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/beachbum/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/shorts/red(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/boonie(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/botanic_leather(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/beer_pack(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/kitchen/knife/butcher(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/wypacket(new_human.back), WEAR_IN_BACK)
	add_survivor_weapon_civilian(new_human)

	..()

// ----- WY Survivors

// after double check goon isn't being used anywhere.
/datum/equipment_preset/survivor/goon
	name = "Survivor - Corporate Security Goon"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	assignment = JOB_WY_GOON
	paygrade = "WEY-GOON"
	idtype = /obj/item/card/id/silver/cl
	skills = /datum/skills/civilian/survivor/goon
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_BRIG)

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/goon/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/corporate, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate, WEAR_FEET)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/baton, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88_near_empty, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/corporate/no_lock, WEAR_J_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)


// ----- Mercenary Survivors

// after double check pmc/miner/one isn't being used anywhere.
/datum/equipment_preset/survivor/pmc/miner/one
	name = "Survivor - Mercenary"
	flags = EQUIPMENT_PRESET_START_OF_ROUND

	assignment = "Mercenary"
	skills = /datum/skills/civilian/survivor/pmc
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/pmc/miner/one/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/mercenary/miner, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/mercenary/miner, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/mercenary/miner, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_R_STORE)
	add_pmc_survivor_weapon(new_human)

	..()

// after double check pmc/freelancer isn't being used anywhere.
/datum/equipment_preset/survivor/pmc/freelancer
	name = "Survivor - Freelancer"
	assignment = "Freelancer"
	skills = /datum/skills/civilian/survivor/pmc
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/pmc/freelancer/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/freelancer, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/freelancer, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	spawn_merc_helmet(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_R_STORE)
	add_pmc_survivor_weapon(new_human)

	..()

// ----- Hostile Survivors

/*
//weirdness probably shouldn't be there....
// it's used for spawning in corpses to.... very strange...

*/

/datum/equipment_preset/survivor/clf/cold

/datum/equipment_preset/survivor/clf/cold/spawn_rebel_suit(mob/living/carbon/human/human)
	if(!istype(human))
		return
	var/suitpath = pick(
		/obj/item/clothing/suit/storage/militia,
		/obj/item/clothing/suit/storage/militia/vest,
		/obj/item/clothing/suit/storage/militia/brace,
		/obj/item/clothing/suit/storage/militia/partial,
		)
	human.equip_to_slot_or_del(new suitpath, WEAR_JACKET)

/datum/equipment_preset/survivor/clf/cold/spawn_rebel_helmet(mob/living/carbon/human/human)
	if(!istype(human))
		return
	var/helmetpath = pick(
		/obj/item/clothing/head/militia,
		/obj/item/clothing/head/militia/bucket,
		/obj/item/clothing/head/helmet,
		/obj/item/clothing/head/helmet/skullcap,
		/obj/item/clothing/head/helmet/swat,
		)
	human.equip_to_slot_or_del(new helmetpath, WEAR_HEAD)

/datum/equipment_preset/survivor/clf/cold/spawn_rebel_shoes(mob/living/carbon/human/human)
	if(!istype(human))
		return
	var/shoespath = /obj/item/clothing/shoes/combat
	human.equip_to_slot_or_del(new shoespath, WEAR_FEET)

// why it's there?
// can't find any usage of it....
/datum/equipment_preset/survivor/new_varadero/commander
	name = "Survivor - USASF Commander"
	assignment = "USASF Commander"
	skills = /datum/skills/commander
	paygrade = "NO5"
	idtype = /obj/item/card/id/gold
	role_comm_title = "USASF CDR"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

/datum/equipment_preset/survivor/new_varadero/commander/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/bridge(new_human), WEAR_BODY)

	var/obj/item/clothing/suit/storage/jacket/marine/service/suit = new()
	suit.icon_state = "[suit.initial_icon_state]_o"
	suit.buttoned = FALSE

	var/obj/item/clothing/accessory/ranks/navy/o5/pin = new()
	suit.attach_accessory(new_human, pin)

	new_human.equip_to_slot_or_del(suit, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/notepad(new_human), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/pen/fountain(new_human), WEAR_IN_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/m1911(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(new_human), WEAR_HEAD)

	..()
