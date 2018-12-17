#define EQUIPMENT_PRESET_STUB 			0
#define EQUIPMENT_PRESET_START_OF_ROUND 1
#define EQUIPMENT_PRESET_EXTRA 			2

/datum/equipment_preset/clf
	name = "CLF"

/datum/equipment_preset/clf/load_languages(mob/living/carbon/human/H)
	H.set_languages(list("Tradeband", "English"))

/*****************************************************************************************************/

/datum/equipment_preset/clf/fighter
	name = "CLF Fighter (Standard)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/clf/fighter/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.assignment = "Colonist"
	W.registered_name = H.real_name
	H.equip_to_slot_or_del(W, WEAR_ID)
	W.access = get_antagonist_access()
	if(H.mind)
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "CLF"

/datum/equipment_preset/clf/fighter/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/pfc)

/datum/equipment_preset/clf/fighter/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/militia(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary/molotov(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary/molotov(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general(H), WEAR_R_STORE)

	spawn_rebel_gun(H)
	spawn_rebel_gun(H,1)

/*****************************************************************************************************/

/datum/equipment_preset/clf/survivor
	name = "CLF Survivor"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/clf/survivor/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.assignment = "Colonist"
	W.registered_name = H.real_name
	H.equip_to_slot_or_del(W, WEAR_ID)
	W.access = get_antagonist_access()
	if(H.mind)
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "CLF"

/datum/equipment_preset/clf/survivor/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/civilian/survivor/doctor)

/datum/equipment_preset/clf/survivor/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/militia(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/survival/full(H), WEAR_L_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/clf/fighter_medic
	name = "CLF Fighter (Medic)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/clf/fighter_medic/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.assignment = "Colonist Medic"
	W.registered_name = H.real_name
	H.equip_to_slot_or_del(W, WEAR_ID)
	W.access = get_antagonist_access()
	if(H.mind)
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "CLF"

/datum/equipment_preset/clf/fighter_medic/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/combat_medic)

/datum/equipment_preset/clf/fighter_medic/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/militia(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick(H.back), WEAR_IN_BACK)

	H.equip_to_slot_or_del(new /obj/item/device/defibrillator(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/firstaid/fire(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pill_bottle/tramadol/skillless(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/healthanalyzer(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/medical(H), WEAR_R_STORE)


	spawn_rebel_gun(H)
	//spawn_rebel_gun(H,1)

/*****************************************************************************************************/

/datum/equipment_preset/clf/fighter_leader
	name = "CLF Fighter (Leader)"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/clf/fighter_leader/load_id(mob/living/carbon/human/H)
	var/obj/item/card/id/W = new(H)
	W.name = "[H.real_name]'s ID Card"
	W.assignment = "Colonist Leader"
	W.registered_name = H.real_name
	H.equip_to_slot_or_del(W, WEAR_ID)
	W.access = get_antagonist_access()
	if(H.mind)
		H.mind.role_comm_title = "Lead"
		H.mind.assigned_role = "MODE"
		H.mind.special_role = "CLF"

/datum/equipment_preset/clf/fighter_leader/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/SL)

/datum/equipment_preset/clf/fighter_leader/load_gear(mob/living/carbon/human/H)
	//TODO: add backpacks and satchels
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/dutch(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/militia(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/frelancer(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/grenade/HE/stick(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/explosive/plastique(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/box/handcuffs(H.back), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general/medium(H), WEAR_R_STORE)

	spawn_rebel_gun(H)
	spawn_rebel_gun(H,1)
