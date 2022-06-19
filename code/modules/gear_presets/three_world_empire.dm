/datum/equipment_preset/three_world_empire
	name = FACTION_TWE
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)
	faction = FACTION_TWE
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/three_world_empire/New()
	. = ..()
	access = get_antagonist_access()

/datum/equipment_preset/three_world_empire/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(60;MALE,40;FEMALE)

	var/datum/preferences/A = new()
	A.randomize_appearance(H)

	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(first_names_male_clf)] [pick(last_names_clf)]"
	else
		random_name = "[pick(first_names_female_clf)] [pick(last_names_clf)]"

	H.change_real_name(H, random_name)

/datum/equipment_preset/three_world_empire/seaman
	name = JOB_TWE_SEAMAN
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/twe
	assignment = JOB_TWE_SEAMAN
	rank = JOB_TWE_SEAMAN
	role_comm_title = "SN"
	paygrade = "RO1"

/datum/equipment_preset/three_world_empire/seaman/load_gear(mob/living/carbon/human/H)
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/TWE, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/twe, WEAR_HEAD)
	//body
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/twe, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/twe, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/twe, WEAR_IN_BACK)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/twe, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/twe, WEAR_HANDS)

/datum/equipment_preset/three_world_empire/leading_seaman
	name = JOB_TWE_LSEAMAN
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/twe/leader
	assignment = JOB_TWE_LSEAMAN
	rank = JOB_TWE_LSEAMAN
	role_comm_title = "LR"
	paygrade = "RO2"

/datum/equipment_preset/three_world_empire/leading_seaman/load_gear(mob/living/carbon/human/H)
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/TWE/cct, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/twe/beret/tl, WEAR_HEAD)
	//body
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/twe/lead, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/twe/light/padded, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/twe, WEAR_IN_BACK)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/twe, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/twe, WEAR_HANDS)

/datum/equipment_preset/three_world_empire/standing_officer
	name = JOB_TWE_SO
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/twe/leader
	assignment = JOB_TWE_SO
	rank = JOB_TWE_SO
	role_comm_title = "SO"
	paygrade = "RO3"

/datum/equipment_preset/three_world_empire/standing_officer/load_gear(mob/living/carbon/human/H)
	//face
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/TWE/cct, WEAR_L_EAR)
	//head
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/twe/beret, WEAR_HEAD)
	//body
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/twe/lt, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/twe/light, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars, WEAR_IN_JACKET)
	//back
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/twe, WEAR_IN_BACK)
	//limbs
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/twe, WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/twe, WEAR_HANDS)
