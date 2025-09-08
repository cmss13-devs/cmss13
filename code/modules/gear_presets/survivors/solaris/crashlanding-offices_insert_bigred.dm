//those preset are only used on this insert.
// /obj/effect/landmark/survivor_spawner/bigred_crashed_pmc

/datum/equipment_preset/survivor/pmc
	name = "Survivor - PMC"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	assignment = JOB_PMC_STANDARD
	job_title = JOB_PMC_STANDARD
	faction = FACTION_PMC
	faction_group = list(FACTION_WY, FACTION_SURVIVOR, FACTION_PMC)
	paygrades = list(PAY_SHORT_PMC_OP = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/pmc
	skills = /datum/skills/civilian/survivor/pmc
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	minimap_icon = "pmc_gun"
	minimap_background = "background_pmc"
	origin_override = ORIGIN_WY_PMC

	access = list(
		ACCESS_WY_GENERAL,
		ACCESS_WY_COLONIAL,
		ACCESS_WY_MEDICAL,
		ACCESS_WY_SECURITY,
		ACCESS_WY_RESEARCH,
		ACCESS_WY_ARMORY,
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

/datum/equipment_preset/survivor/pmc/load_vanity(mob/living/carbon/human/new_human)
	return

/datum/equipment_preset/survivor/pmc/standard
	name = "Survivor - PMC Standard"

/datum/equipment_preset/survivor/pmc/standard/load_gear(mob/living/carbon/human/new_human)
	//uniform
	var/obj/item/clothing/under/marine/veteran/pmc/uniform = new()
	if(prob(50))
		uniform.roll_suit_sleeves() //source material demands it
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction(new_human), WEAR_ACCESSORY)
	//boots
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife(new_human), WEAR_FEET)
	//gloves
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	//mask
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc(new_human), WEAR_FACE)
	//radio
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/pmc/hvh(new_human), WEAR_L_EAR)
	//helmet + suit + backpack
	switch(rand(1,3))
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/pmc(new_human), WEAR_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/bulletproof(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/black(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/pmc(new_human), WEAR_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/no_lamp(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/enclosed(new_human), WEAR_HEAD)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/pmc/backpack(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/pmc(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)

	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/wy/mod88_near_empty, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/wy(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert/wy(new_human), WEAR_R_STORE)
	add_pmc_survivor_weapon(new_human)
	add_random_survivor_equipment(new_human)

// /obj/effect/landmark/survivor_spawner/bigred_crashed_pmc_medic

/datum/equipment_preset/survivor/pmc/medic
	name = "Survivor - PMC Medic"
	assignment = JOB_PMC_MEDIC
	job_title = JOB_PMC_MEDIC
	paygrades = list(PAY_SHORT_PMC_MS = JOB_PLAYTIME_TIER_0)
	role_comm_title = "CM"
	skills = /datum/skills/civilian/survivor/pmc/medic
	minimap_icon = "pmc_md"

/datum/equipment_preset/survivor/pmc/medic/load_gear(mob/living/carbon/human/new_human)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction(new_human), WEAR_ACCESSORY)
	//boots
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife(new_human), WEAR_FEET)
	//gloves
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	//mask
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc(new_human), WEAR_FACE)
	//radio
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/pmc/medic/hvh(new_human), WEAR_L_EAR)
	//helmet
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc(new_human), WEAR_HEAD)
	//suit
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/pmc(new_human), WEAR_IN_JACKET)
	//backpack
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/pmc/medic(new_human), WEAR_BACK)
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/wy/mod88_near_empty, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/wy(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert/wy(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(new_human), WEAR_R_HAND)
	//eyewear
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	add_pmc_survivor_weapon(new_human)
	add_random_survivor_equipment(new_human)

// /obj/effect/landmark/survivor_spawner/bigred_crashed_pmc_engineer

/datum/equipment_preset/survivor/pmc/engineer
	name = "Survivor - PMC Engineer"
	assignment = JOB_PMC_ENGINEER
	job_title = JOB_PMC_ENGINEER
	paygrades = list(PAY_SHORT_PMC_TEC = JOB_PLAYTIME_TIER_0)
	role_comm_title = "TEC"
	skills = /datum/skills/civilian/survivor/pmc/engineer
	minimap_icon = "mt"

/datum/equipment_preset/survivor/pmc/engineer/load_gear(mob/living/carbon/human/new_human)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/engineer(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction(new_human), WEAR_ACCESSORY)
	//boots
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife(new_human), WEAR_FEET)
	//gloves
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc(new_human), WEAR_HANDS)
	//mask
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc(new_human), WEAR_FACE)
	//radio
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/pmc/cct/hvh(new_human), WEAR_L_EAR)
	//helmet
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/enclosed/engineer(new_human), WEAR_HEAD)
	//suit
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/engineer(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/pmc(new_human), WEAR_IN_JACKET)
	//backpack
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert/pmc, WEAR_BACK)
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/wy/mod88_near_empty(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/wy(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert/wy(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/med_small_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_R_HAND)
	add_pmc_survivor_weapon(new_human)
	add_random_survivor_equipment(new_human)

// /obj/effect/landmark/survivor_spawner/bigred_crashed_pmc_leader

/datum/equipment_preset/survivor/pmc/pmc_leader
	name = "Survivor - PMC Leader"
	assignment = JOB_PMC_LEADER
	job_title = JOB_PMC_LEADER
	paygrades = list(PAY_SHORT_PMC_TL = JOB_PLAYTIME_TIER_0)
	role_comm_title = "SL"
	skills = /datum/skills/civilian/survivor/pmc/lead
	minimap_icon = "pmc_ld"

/datum/equipment_preset/survivor/pmc/pmc_leader/load_gear(mob/living/carbon/human/new_human)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/leader(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction(new_human), WEAR_ACCESSORY)
	//boots
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife(new_human), WEAR_FEET)
	//gloves
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc(new_human), WEAR_HANDS)
	//mask
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/leader(new_human), WEAR_FACE)
	//radio
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/pmc/command/hvh(new_human), WEAR_L_EAR)
	//helmet
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/leader(new_human), WEAR_HEAD)
	//suit
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/leader(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/pmc(new_human), WEAR_IN_JACKET)
	//backpack
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/pmc/backpack(new_human), WEAR_BACK)
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/wy/mod88_near_empty(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/wy(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert/wy(new_human), WEAR_R_STORE)
	//eyewear
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/sensor(new_human), WEAR_EYES)
	add_pmc_survivor_weapon(new_human)
	add_random_survivor_equipment(new_human)

// /obj/effect/landmark/survivor_spawner/bigred_crashed_cl

/datum/equipment_preset/survivor/corporate/manager
	name = "Survivor - Corporate Supervisor"
	flags = EQUIPMENT_PRESET_EXTRA
	paygrades = list(PAY_SHORT_WYC6 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/civilian/survivor/manager
	assignment = "Colony Supervisor"
	job_title = JOB_EXECUTIVE_SUPERVISOR
	minimap_icon = "exec_super"
	role_comm_title = "Supervisor"
	idtype = /obj/item/card/id/silver/clearance_badge/manager
	faction = FACTION_WY
	faction_group = list(FACTION_WY, FACTION_SURVIVOR, FACTION_PMC)
	access = list(
		ACCESS_WY_GENERAL,
		ACCESS_WY_COLONIAL,
		ACCESS_WY_MEDICAL,
		ACCESS_WY_SECURITY,
		ACCESS_WY_RESEARCH,
		ACCESS_WY_ARMORY,
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
		ACCESS_ILLEGAL_PIRATE,
	)
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)

	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/survivor/corporate/manager/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/manager(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable/liaison(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/pmc/command/hvh(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/paper/research_notes/grant, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/manager(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/manager(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert/wy(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/wy(new_human), WEAR_L_STORE)
	add_pmc_survivor_weapon(new_human)
	add_random_cl_survivor_loot(new_human)

// only used on the spawner of all of those above...
/datum/equipment_preset/synth/survivor/pmc
	name = "Survivor - Synthetic - PMC Support Synth"
	faction = FACTION_PMC
	faction_group = list(FACTION_WY, FACTION_SURVIVOR, FACTION_PMC)
	access = list(
		ACCESS_WY_GENERAL,
		ACCESS_WY_COLONIAL,
		ACCESS_WY_MEDICAL,
		ACCESS_WY_SECURITY,
		ACCESS_WY_RESEARCH,
		ACCESS_WY_ARMORY,
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_RESEARCH,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)
	skills = /datum/skills/synthetic
	idtype = /obj/item/card/id/pmc
	assignment = JOB_PMC_SYNTH
	job_title = JOB_PMC_SYNTH
	paygrades = list(PAY_SHORT_SYN = JOB_PLAYTIME_TIER_0)
	role_comm_title = "WY Syn"
	skills = /datum/skills/synthetic
	preset_generation_support = FALSE
	minimap_icon = "pmc_syn"
	minimap_background = "background_pmc"
	origin_override = ORIGIN_WY_PMC

/datum/equipment_preset/synth/survivor/pmc/load_race(mob/living/carbon/human/new_human)
	new_human.set_species(SYNTH_GEN_THREE)

/datum/equipment_preset/synth/survivor/pmc/load_skills(mob/living/carbon/human/new_human)
	new_human.set_skills(/datum/skills/synthetic)
	new_human.allow_gun_usage = FALSE

/datum/equipment_preset/synth/survivor/pmc/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/droppouch/black(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/scalpel/manager(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/flask/weylandyutani(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs/zip(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/synth(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/telebaton(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/pmc(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction(new_human), WEAR_ACCESSORY)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/leader(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/pmc/command/hvh(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife(new_human), WEAR_FEET)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/smartpack/a1/white(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/roller/surgical(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/extinguisher/mini(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/upgraded(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crew_monitor(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/synthetic(new_human), WEAR_IN_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/wy/partial(new_human), WEAR_WAIST)

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tactical(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/screwdriver/tactical(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar/tactical(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/wirecutters/tactical(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/wrench(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/cable_coil(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/stack/cable_coil(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/multitool(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/tool/weldingtool/hugetank(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full_barbed_wire/wy(new_human), WEAR_R_STORE)

// only used on the spawner of all of those above...
/datum/equipment_preset/survivor/pmc/pmc_commander
	name = "Survivor - PMC Field Operations Leader"
	assignment = JOB_PMC_FIELD_OP_LEADER
	job_title = JOB_PMC_FIELD_OP_LEADER
	paygrades = list(PAY_SHORT_PMC_FOL = JOB_PLAYTIME_TIER_0)
	role_comm_title = "FOL"
	skills = /datum/skills/civilian/survivor/pmc/co_survivor
	minimap_icon = "pmc_fol"

/datum/equipment_preset/survivor/pmc/pmc_commander/load_gear(mob/living/carbon/human/new_human)
	//uniform
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/leader(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/vp78(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/vp78(new_human), WEAR_IN_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/vp78(new_human), WEAR_IN_ACCESSORY)
	//boots
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife(new_human), WEAR_FEET)
	//gloves
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc(new_human), WEAR_HANDS)
	//mask
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc/leader(new_human), WEAR_FACE)
	//radio
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/pmc/command/hvh(new_human), WEAR_L_EAR)
	//helmet
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/fieldleader(new_human), WEAR_HEAD)
	//suit
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/leader(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/pmc(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range(new_human), WEAR_IN_JACKET)
	//backpack
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/pmc/backpack/rto_broken(new_human), WEAR_BACK)
	//storage items
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/med_small_stack(new_human), WEAR_IN_BACK) // There is a chance PMC CO replaces PMC Engi during spawn.
	new_human.equip_to_slot_or_del(new /obj/item/attachable/flashlight/grip(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/attachable/reflex(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m39/corporate/no_lock/full/extended(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/wy(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/wy/full_advanced(new_human), WEAR_R_STORE) //In case a medic doesn't spawn.
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator/compact(new_human), WEAR_IN_BACK) //In case a medic doesn't spawn.
	new_human.equip_to_slot_or_del(new /obj/item/tool/crew_monitor(new_human), WEAR_IN_BACK)
	//eyewear
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/sensor(new_human), WEAR_EYES)
	add_random_survivor_equipment(new_human) //No random PMC gun for them. Overwatch esque role, so SMG.
