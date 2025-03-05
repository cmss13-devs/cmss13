// /obj/effect/landmark/survivor_spawner/shivas_assistant_manager
// panic_room_insert_shivas.dmm

/datum/equipment_preset/survivor/corporate/asstmanager
	name = "Survivor - Corporate Assistant Manager"
	flags = EQUIPMENT_PRESET_EXTRA
	paygrades = list(PAY_SHORT_WYC7 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/civilian/survivor/manager
	assignment = "Assistant Operations Manager"
	minimap_background = "background_wy_management"
	minimap_icon = "ass_man"
	rank = JOB_ASSISTANT_MANAGER
	idtype = /obj/item/card/id/silver/clearance_badge/manager
	faction_group = list(FACTION_WY, FACTION_SURVIVOR)
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
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)

	survivor_variant = CORPORATE_SURVIVOR

/datum/equipment_preset/survivor/corporate/asstmanager/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/manager(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/lockable/liaison, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/glass/beaker/vial/random/good(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/paper/research_notes/grant, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/survivor/parka/navy(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_R_STORE)
	add_survivor_weapon_civilian(new_human)
	..()

/datum/equipment_preset/survivor/pmc/shivas
	name = "Survivor - PMC (Shivas)"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	assignment = JOB_PMC_STANDARD
	rank = JOB_PMC_STANDARD
	faction = FACTION_PMC
	faction_group = list(FACTION_WY, FACTION_SURVIVOR, FACTION_PMC)
	paygrades = list(PAY_SHORT_PMC_OP = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/pmc
	skills = /datum/skills/civilian/survivor/pmc
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	minimap_icon = "private"
	minimap_background = "background_pmc"

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

/datum/equipment_preset/survivor/pmc/shivas/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/pmc/hvh, WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/pmc, WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/pmc, WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/pmc, WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc, WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc/knife, WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf, WEAR_FACE)

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot, WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/baton, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/restraint/handcuffs/zip, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/wypacket, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/lighter/zippo, WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/flask/weylandyutani, WEAR_IN_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/corporate, WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41a, WEAR_WAIST)

