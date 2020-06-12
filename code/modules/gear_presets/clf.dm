#define EQUIPMENT_PRESET_STUB 			0
#define EQUIPMENT_PRESET_START_OF_ROUND 1
#define EQUIPMENT_PRESET_EXTRA 			2
#define EQUIPMENT_PRESET_START_OF_ROUND_WO 4

/datum/equipment_preset/clf
	name = FACTION_CLF
	languages = list("Tradeband", "English")
	assignment = "Colonist"
	rank = FACTION_CLF
	faction = FACTION_CLF
	idtype = /obj/item/card/id/data

/datum/equipment_preset/clf/New()
	. = ..()
	access = get_antagonist_access()

/datum/equipment_preset/clf/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(60;MALE, 40;FEMALE)
	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(first_names_male_clf)] [pick(last_names_clf)]"
	else
		random_name = "[pick(first_names_female_clf)] [pick(last_names_clf)]"
	H.change_real_name(H, random_name)
	H.age = rand(17,45)
	H.r_hair = 25
	H.g_hair = 25
	H.b_hair = 35
	H.r_eyes = 139
	H.g_eyes = 62
	H.b_eyes = 19

/*****************************************************************************************************/

/datum/equipment_preset/clf/fighter
	name = "CLF Fighter (Standard)"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/clf

/datum/equipment_preset/clf/fighter/load_gear(mob/living/carbon/human/H)

	spawn_rebel_uniform(H)
	spawn_rebel_suit(H)
	spawn_rebel_helmet(H)
	spawn_rebel_shoes(H)
	spawn_rebel_gloves(H)
	spawn_rebel_belt(H)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary/molotov(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary/molotov(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(H), WEAR_R_STORE)

	spawn_rebel_weapon(H)
	spawn_rebel_weapon(H,1)

/*****************************************************************************************************/

/datum/equipment_preset/clf/survivor
	name = "CLF Survivor"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/civilian/survivor/doctor

/datum/equipment_preset/clf/survivor/load_gear(mob/living/carbon/human/H)

	spawn_rebel_uniform(H)
	spawn_rebel_suit(H)
	spawn_rebel_helmet(H)
	spawn_rebel_shoes(H)
	spawn_rebel_gloves(H)
	spawn_rebel_belt(H)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/clf/fighter_medic
	name = "CLF Fighter (Medic)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "Colonist Medic"
	skills = /datum/skills/clf/combat_medic

/datum/equipment_preset/clf/fighter_medic/load_gear(mob/living/carbon/human/H)

	spawn_rebel_uniform(H)
	spawn_rebel_suit(H)
	spawn_rebel_helmet(H)
	spawn_rebel_shoes(H)
	spawn_rebel_gloves(H)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/medical/full(H), WEAR_WAIST)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/defibrillator(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol/skillless(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(H), WEAR_R_STORE)


	spawn_rebel_weapon(H)

/*****************************************************************************************************/

/datum/equipment_preset/clf/fighter_leader
	name = "CLF Fighter (Leader)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = "Colonist Leader"
	role_comm_title = "Lead"
	skills = /datum/skills/clf/leader

/datum/equipment_preset/clf/fighter_leader/load_gear(mob/living/carbon/human/H)

	//No random armor, so that it's more clear that he's the leader
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/clf(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/sec/hos(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	spawn_rebel_belt(H)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied_incendiary(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/ied_incendiary(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/handcuffs(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars/range(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(H), WEAR_R_STORE)

	spawn_rebel_weapon(H)
	spawn_rebel_weapon(H,1)