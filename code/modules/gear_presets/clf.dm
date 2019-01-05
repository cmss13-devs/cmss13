#define EQUIPMENT_PRESET_STUB 			0
#define EQUIPMENT_PRESET_START_OF_ROUND 1
#define EQUIPMENT_PRESET_EXTRA 			2
#define EQUIPMENT_PRESET_START_OF_ROUND_WO 4

/datum/equipment_preset/clf
	name = "CLF"
	languages = list("Tradeband", "English")
	assignment = "Colonist"
	rank = "MODE"
	special_role = "CLF"

/datum/equipment_preset/clf/New()
	. = ..()
	access = get_antagonist_access()

/datum/equipment_preset/clf/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(60;MALE, 40;FEMALE)
	var/list/first_names_mreb = list("Alan","Jack","Bil","Jonathan","John","Shiro","Gareth","Clark","Sam", "Lionel", "Aaron", "Charlie", "Scott", "Winston", "Aidan", "Ellis", "Mason", "Wesley", "Nicholas", "Calvin", "Nishikawa", "Hiroto", "Chiba", "Ouchi", "Furuse", "Takagi", "Oba", "Kishimoto")
	var/list/first_names_freb = list("Emma", "Adelynn", "Mary", "Halie", "Chelsea", "Lexie", "Arya", "Alicia", "Selah", "Amber", "Heather", "Myra", "Heidi", "Charlotte", "Oliva", "Lydia", "Tia", "Riko", "Ari", "Machida", "Ueki", "Mihara", "Noda")
	var/list/last_names_reb = list("Hawkins","Rickshaw","Elliot","Billard","Cooper","Fox", "Barlow", "Barrows", "Stewart", "Morgan", "Green", "Stone", "Burr", "Hunt", "Yuko", "Gesshin", "Takanibu", "Tetsuzan", "Tomomi", "Bokkai", "Takesi")
	if(H.gender == MALE)
		H.real_name = "[pick(first_names_mreb)] [pick(last_names_reb)]"
	else
		H.real_name = "[pick(first_names_freb)] [pick(last_names_reb)]"
	H.name = H.real_name
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

	skills = /datum/skills/pfc

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

	skills = /datum/skills/civilian/survivor/doctor

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

	assignment = "Colonist Medic"
	skills = /datum/skills/combat_medic

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
	
	assignment = "Colonist Leader"
	role_comm_title = "Lead"
	skills = /datum/skills/SL

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
