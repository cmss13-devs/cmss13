/datum/equipment_preset/xeno_suit
	name = "Drone Suit"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/xeno_suit/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/xenos(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/xenos(new_human), WEAR_HEAD)

/datum/equipment_preset/xeno_suit/queen
	name = "Queen Suit"

/datum/equipment_preset/xeno_suit/queen/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/xenos/queen(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/xenos/queen(new_human), WEAR_HEAD)
