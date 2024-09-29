// /obj/effect/landmark/survivor_spawner/lv624_crashed_clf
// clfship.dmm
/datum/equipment_preset/survivor/clf
	name = "CLF Survivor"
	flags = EQUIPMENT_PRESET_EXTRA
	skills = /datum/skills/civilian/survivor/clf
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	faction = FACTION_CLF
	faction_group = list(FACTION_CLF, FACTION_SURVIVOR)
	access = list(ACCESS_CIVILIAN_PUBLIC)
	survivor_variant = HOSTILE_SURVIVOR

/datum/equipment_preset/survivor/clf/load_gear(mob/living/carbon/human/new_human)

	spawn_rebel_uniform(new_human)
	spawn_rebel_suit(new_human)
	spawn_rebel_helmet(new_human)
	spawn_rebel_shoes(new_human)
	spawn_rebel_gloves(new_human)
	spawn_rebel_belt(new_human)

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CLF(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack/five_slot(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/ert(new_human), WEAR_R_STORE)
	add_survivor_weapon_security(new_human)
	add_survivor_weapon_pistol(new_human)

	..()
