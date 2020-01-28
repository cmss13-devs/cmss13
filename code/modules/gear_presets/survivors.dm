

/datum/equipment_preset/survivor
	name = JOB_SURVIVOR
	assignment = JOB_SURVIVOR
	rank = JOB_SURVIVOR
	special_role = JOB_SURVIVOR

	skills = /datum/skills/civilian
	languages = list("English")
	paygrade = "C"
	idtype = /obj/item/card/id/lanyard
	faction = FACTION_SURVIVOR
	access = list(ACCESS_CIVILIAN_PUBLIC)

	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(MALE, FEMALE)
	var/datum/preferences/A = new
	A.randomize_appearance(H)
	H.real_name = capitalize(pick(H.gender == MALE ? first_names_male : first_names_female)) + " " + capitalize(pick(last_names))
	H.name = H.real_name
	H.age = rand(21,45)

/*****************************************************************************************************/

/datum/equipment_preset/survivor/scientist
	name = "Survivor - Scientist"
	assignment = "Scientist"
	skills = /datum/skills/civilian/survivor/scientist
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge/scientist
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH)

	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH)

/datum/equipment_preset/survivor/scientist/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)
	if(map_tag in MAPS_COLD_TEMP)
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), WEAR_JACKET)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)
		H.equip_to_slot_or_del(new /obj/item/attachable/bayonet(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/tox(H), WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/paper/research_notes/good(H), WEAR_IN_JACKET)
	H.equip_to_slot_or_del(new /obj/item/reagent_container/glass/beaker/vial/random/good(H), WEAR_IN_JACKET)

	if(map_tag != MAP_PRISON_STATION)
		add_random_survivor_weapon(H)

	add_random_survivor_equipment(H)

/*****************************************************************************************************/

/datum/equipment_preset/survivor/doctor
	name = "Survivor - Doctor"
	assignment = "Doctor"
	skills = /datum/skills/civilian/survivor/doctor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH)


/datum/equipment_preset/survivor/doctor/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), WEAR_BODY)

	if(map_tag in MAPS_COLD_TEMP)
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), WEAR_JACKET)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/med(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H.back), WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)

	if(map_tag != MAP_PRISON_STATION)
		add_random_survivor_weapon(H)

	add_random_survivor_equipment(H)

/*****************************************************************************************************/

/datum/equipment_preset/survivor/corporate
	name = "Survivor - Corporate"
	assignment = "Corporate Liaison"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/clearance_badge/cl
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/corporate/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit(H), WEAR_BODY)
	if(map_tag in MAPS_COLD_TEMP)
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)
		H.equip_to_slot_or_del(new /obj/item/attachable/bayonet(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(H), WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)

	if(map_tag != MAP_PRISON_STATION)
		add_random_survivor_weapon(H)

	add_random_survivor_equipment(H)

/*****************************************************************************************************/

/datum/equipment_preset/survivor/security
	name = "Survivor - Security"
	assignment = "Security"
	skills = /datum/skills/civilian/survivor/marshall
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/data
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS, ACCESS_CIVILIAN_RESEARCH)


/datum/equipment_preset/survivor/security/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security/corp(H), WEAR_BODY)
	if(map_tag in MAPS_COLD_TEMP)
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/cmb(H), WEAR_L_HAND)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)

	if(map_tag != MAP_PRISON_STATION)
		add_random_survivor_weapon(H)

	add_random_survivor_equipment(H)

/*****************************************************************************************************/

/datum/equipment_preset/survivor/prisoner
	name = "Survivor - Prisoner"
	assignment = "Prisoner"
	skills = /datum/skills/civilian/survivor/prisoner
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/prisoner/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/color/orange(H), WEAR_BODY)

	if(map_tag in MAPS_COLD_TEMP)
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(H), WEAR_FEET)
		H.equip_to_slot_or_del(new /obj/item/attachable/bayonet(H), WEAR_L_HAND)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)

	if(map_tag != MAP_PRISON_STATION)
		add_random_survivor_weapon(H)

	add_random_survivor_equipment(H)

/*****************************************************************************************************/

/datum/equipment_preset/survivor/assistant
	name = "Survivor - Assistant"
	assignment = "Assistant"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/assistant/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)

	if(map_tag in MAPS_COLD_TEMP)
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)
		H.equip_to_slot_or_del(new /obj/item/attachable/bayonet(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(H), WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)

	if(map_tag != MAP_PRISON_STATION)
		add_random_survivor_weapon(H)

	add_random_survivor_equipment(H)

/*****************************************************************************************************/

/datum/equipment_preset/survivor/civilian
	name = "Survivor - Civilian"
	assignment = "Civilian"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/civilian/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/pj/red(H), WEAR_BODY)

	if(map_tag in MAPS_COLD_TEMP)
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)
		H.equip_to_slot_or_del(new /obj/item/attachable/bayonet(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(H), WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)

	if(map_tag != MAP_PRISON_STATION)
		add_random_survivor_weapon(H)

	add_random_survivor_equipment(H)

/*****************************************************************************************************/

/datum/equipment_preset/survivor/chef
	name = "Survivor - Chef"
	assignment = "Chef"
	skills = /datum/skills/civilian/survivor/chef
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/chef/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)

	if(map_tag in MAPS_COLD_TEMP)
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/chef(H), WEAR_JACKET)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/kitchen/rollingpin(H), WEAR_L_HAND)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)

	if(map_tag != MAP_PRISON_STATION)
		add_random_survivor_weapon(H)

	add_random_survivor_equipment(H)

/*****************************************************************************************************/

/datum/equipment_preset/survivor/botanist
	name = "Survivor - Botanist"
	assignment = "Botanist"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH)

/datum/equipment_preset/survivor/botanist/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels

	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)

	if(map_tag in MAPS_COLD_TEMP)
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/apron(H), WEAR_JACKET)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/tool/hatchet(H), WEAR_L_HAND)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)

	if(map_tag != MAP_PRISON_STATION)
		add_random_survivor_weapon(H)

	add_random_survivor_equipment(H)

/*****************************************************************************************************/

/datum/equipment_preset/survivor/atmos_tech
	name = "Survivor - Atmos Tech"
	assignment = "Atmos Tech"
	skills = /datum/skills/civilian/survivor/atmos
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_ENGINEERING)

	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/datum/equipment_preset/survivor/atmos_tech/load_gear(mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)

	if(map_tag in MAPS_COLD_TEMP)
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/atmostech(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(H), WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)

	if(map_tag != MAP_PRISON_STATION)
		add_random_survivor_weapon(H)

	add_random_survivor_equipment(H)

/*****************************************************************************************************/

/datum/equipment_preset/survivor/chaplain
	name = "Survivor - Chaplain"
	assignment = "Chaplain"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/chaplain/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chaplain(H), WEAR_BODY)

	if(map_tag in MAPS_COLD_TEMP)
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/bible/booze(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/double/sawn(H), WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/shotgun/buckshot(H), WEAR_L_HAND)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)

	if(map_tag != MAP_PRISON_STATION)
		add_random_survivor_weapon(H)

	add_random_survivor_equipment(H)

/*****************************************************************************************************/

/datum/equipment_preset/survivor/miner
	name = "Survivor - Miner"
	assignment = "Miner"
	skills = /datum/skills/civilian/survivor/miner
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_ENGINEERING)

	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/datum/equipment_preset/survivor/miner/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/miner(H), WEAR_BODY)

	if(map_tag in MAPS_COLD_TEMP)
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/tool/pickaxe(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(H.back), WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)

	if(map_tag != MAP_PRISON_STATION)
		add_random_survivor_weapon(H)

	add_random_survivor_equipment(H)

/*****************************************************************************************************/

/datum/equipment_preset/survivor/salesman
	name = "Survivor - Salesman"
	assignment = "Salesman"
	skills = /datum/skills/civilian/survivor
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/data
	access = list(ACCESS_CIVILIAN_PUBLIC)

/datum/equipment_preset/survivor/salesman/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit(H), WEAR_BODY)

	if(map_tag in MAPS_COLD_TEMP)
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/wcoat(H), WEAR_JACKET)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/storage/briefcase(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/mod88(H), WEAR_WAIST)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)

	if(map_tag != MAP_PRISON_STATION)
		add_random_survivor_weapon(H)

	add_random_survivor_equipment(H)

/*****************************************************************************************************/

/datum/equipment_preset/survivor/colonial_marshall
	name = "Survivor - Colonial Marshall"
	assignment = "Colonial Marshall"
	skills = /datum/skills/civilian/survivor/marshall
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = /obj/item/card/id/silver/cl
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS, ACCESS_CIVILIAN_RESEARCH)


/datum/equipment_preset/survivor/colonial_marshall/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/CM_uniform(H), WEAR_BODY)

	if(map_tag in MAPS_COLD_TEMP)
		add_ice_colony_survivor_equipment(H)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/CMB(H), WEAR_JACKET)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/cmb(H), WEAR_L_HAND)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(H), WEAR_BACK)

	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)

	if(map_tag != MAP_PRISON_STATION)
		add_random_survivor_weapon(H)

	add_random_survivor_equipment(H)
