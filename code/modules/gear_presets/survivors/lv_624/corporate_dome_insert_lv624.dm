// /obj/effect/landmark/survivor_spawner/lv624_corporate_dome/cl
// corporatedomehold.dmm

/datum/equipment_preset/survivor/corporate/executive
	name = "Survivor - LV-624 Paranoid Corporate Liaison"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	paygrades = list(PAY_SHORT_WYC5 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/civilian/survivor/manager
	assignment = "LV-624 Corporate Liaison"
	idtype = /obj/item/card/id/silver/clearance_badge/cl
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
	)
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE, LANGUAGE_RUSSIAN)

	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/survivor/corporate/executive/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/administrator(new_human), WEAR_BODY)
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
		add_ice_colony_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/wy_cap(new_human), WEAR_HEAD)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/wy/vp78(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/secure/briefcase(new_human), WEAR_L_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable/liaison(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/glass/beaker/vial/random/good(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/med_small_stack(new_human), WEAR_IN_BACK)
	add_random_cl_survivor_loot(new_human)
	add_random_cl_survivor_loot(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/document(new_human), WEAR_R_STORE)

/datum/equipment_preset/survivor/goon/medic
	name = "Survivor - Corporate Security Goon Medic"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	assignment = JOB_WY_GOON_MEDIC
	rank = JOB_WY_GOON_MEDIC
	skills = /datum/skills/civilian/survivor/goon/medic
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_BRIG, ACCESS_WY_COLONIAL, ACCESS_WY_MEDICAL)
	minimap_icon = "goon_med"

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/survivor/goon/medic/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/corporate/medic, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/medic, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/medic, WEAR_HEAD)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate/knife, WEAR_FEET)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/pmc, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/baton, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39/(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/robust(new_human), WEAR_R_HAND) //pills packs splints and analyzer
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/wy/mod88_near_empty, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/wy, WEAR_R_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/corporate/no_lock, WEAR_J_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/wy(new_human), WEAR_L_STORE)

/datum/equipment_preset/survivor/goon/engineer
	name = "Survivor - Corporate Security Goon Technician"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	assignment = JOB_WY_GOON_TECH
	rank = JOB_WY_GOON_TECH
	skills = /datum/skills/civilian/survivor/goon/tech
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_BRIG, ACCESS_WY_COLONIAL, ACCESS_WY_ENGINEERING)
	minimap_icon = "goon_engi"

	survivor_variant = ENGINEERING_SURVIVOR

/datum/equipment_preset/survivor/goon/engineer/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/corporate/engineer, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/engi, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate/knife, WEAR_FEET)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/ert/four_slot, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/baton, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/plasteel/med_small_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/wy/mod88_near_empty, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/wy, WEAR_R_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/corporate/no_lock, WEAR_J_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/wy(new_human), WEAR_L_STORE)

/datum/equipment_preset/survivor/goon/lead
	name = "Survivor - Corporate Security Goon Lead"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	assignment = JOB_WY_GOON_LEAD
	rank = JOB_WY_GOON_LEAD
	paygrades = list(PAY_SHORT_CSPO = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/civilian/survivor/goon/lead
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_BRIG, ACCESS_WY_COLONIAL, ACCESS_WY_MEDICAL, ACCESS_WY_ENGINEERING)
	minimap_icon = "goon_leader"

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/goon/lead/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc/corporate/lead, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/lead, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/lead, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate/knife, WEAR_FEET)

	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/pmc, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/baton, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sheet/metal/large_stack(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/nsg23(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/nsg23(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/nsg23(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/wy/mod88_near_empty, WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full/wy, WEAR_R_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/nsg23/no_lock/stripped, WEAR_J_STORE)

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full/wy(new_human), WEAR_L_STORE)

// only used on the spawner of all of those above...
/datum/equipment_preset/synth/survivor/wy/security_synth/goon
	name = "Survivor - Synthetic - Corporate Security Goon Synthetic"
	idtype = /obj/item/card/id/silver/cl
	assignment = JOB_WY_GOON_SYNTH
	rank = JOB_WY_GOON_SYNTH
	minimap_icon = "goon_synth"
	role_comm_title = "WY Syn"
	faction = FACTION_WY
	faction_group = list(FACTION_WY, FACTION_SURVIVOR, FACTION_PMC)
	equipment_to_spawn = list(
		WEAR_HEAD = /obj/item/clothing/head/cmcap/wy_cap,
		WEAR_L_EAR = /obj/item/device/radio/headset/distress/WY,
		WEAR_EYES = /obj/item/clothing/glasses/sunglasses/sechud,
		WEAR_BODY = /obj/item/clothing/under/marine/veteran/pmc/corporate,
		WEAR_BACK = /obj/item/storage/backpack/pmc,
		WEAR_IN_BACK = /obj/item/restraint/handcuffs,
		WEAR_IN_BACK = /obj/item/restraint/handcuffs,
		WEAR_JACKET = /obj/item/clothing/suit/storage/marine/veteran/pmc/light/synth/corporate,
		WEAR_WAIST = /obj/item/storage/belt/security/MP/full/synth,
		WEAR_IN_JACKET = /obj/item/weapon/telebaton,
		WEAR_HANDS = /obj/item/clothing/gloves/black,
		WEAR_R_STORE = /obj/item/storage/pouch/tools/full,
		WEAR_FEET = /obj/item/clothing/shoes/marine/corporate/knife
	)

	survivor_variant = SECURITY_SURVIVOR
	flags = EQUIPMENT_PRESET_EXTRA
