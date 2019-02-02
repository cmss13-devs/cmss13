
/datum/equipment_preset/fun
	name = "Fun"
	flags = EQUIPMENT_PRESET_STUB
	assignment = "Fun"
	special_role = "FUN"

	skills = /datum/skills/civilian
	idtype = /obj/item/card/id

/*****************************************************************************************************/

/datum/equipment_preset/fun/pirate
	name = "Fun - Pirate"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = "Pirates"

	skills = /datum/skills/pfc/crafty

/datum/equipment_preset/fun/pirate/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/pirate(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/bandana(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/eyepatch(H), WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/weapon/energy/sword/pirate(H), WEAR_L_HAND)

	H.equip_to_slot(new /obj/item/weapon/combat_knife(H), WEAR_L_STORE)
	H.equip_to_slot(new /obj/item/device/flashlight(H), WEAR_R_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/fun/pirate/captain
	name = "Fun - Pirate Captain"
	flags = EQUIPMENT_PRESET_EXTRA

	skills = /datum/skills/SL
	idtype = /obj/item/card/id/silver

/datum/equipment_preset/fun/pirate/captain/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/pirate(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/pirate(H), WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/pirate(H), WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/eyepatch(H), WEAR_EYES)

	H.equip_to_slot_or_del(new /obj/item/weapon/energy/sword/pirate(H), WEAR_L_HAND)
	
	H.equip_to_slot(new /obj/item/weapon/combat_knife(H), WEAR_L_STORE)
	H.equip_to_slot(new /obj/item/device/flashlight(H), WEAR_R_STORE)

/*****************************************************************************************************/

/datum/equipment_preset/fun/clown
	name = "Fun - Clown"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/fun/clown/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/clown(H), WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/clown(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/clown_shoes(H), WEAR_FEET)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/clown_hat(H), WEAR_FACE)

	H.equip_to_slot(new /obj/item/toy/bikehorn(H), WEAR_L_STORE)
	H.equip_to_slot(new /obj/item/device/flashlight(H), WEAR_R_STORE)