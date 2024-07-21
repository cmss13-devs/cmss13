// /obj/effect/landmark/survivor_spawner/shivas_assistant_manager
// panic_room_insert_shivas.dmm

/datum/equipment_preset/survivor/wy/asstmanager
	name = "Survivor - Corporate Assistant Manager"
	flags = EQUIPMENT_PRESET_EXTRA
	paygrades = list(PAY_SHORT_WYC7 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/civilian/survivor/manager
	assignment = "Assistant Operations Manager"
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

/datum/equipment_preset/survivor/wy/asstmanager/load_gear(mob/living/carbon/human/new_human)
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
