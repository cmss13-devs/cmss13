//WIP FILE

/datum/equipment_preset/survivor/scientist/sekhmet
	name = "Survivor - UPP - Cosmos Exploration Corps Researcher"
	assignment = "Issledovatel' Korpusa Kosmicheskoy Eksploratsii"
	minimap_icon = "upp_sci"
	minimap_background = "background_upp_charlie"
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_RUSSIAN, LANGUAGE_GERMAN, LANGUAGE_CHINESE)
	faction = FACTION_UPP
	faction_group = FACTION_LIST_SURVIVOR_UPP
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	origin_override = ORIGIN_UPP

	survivor_variant = SCIENTIST_SURVIVOR

/datum/equipment_preset/survivor/scientist/sekhmet/load_gear(mob/living/carbon/human/new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/brown(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/cec_patch(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran/upp(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/upp_pfb(new_human.back), WEAR_IN_BACK)

	var/random_scientist_satchel= rand(1,3)
	switch(random_scientist_satchel)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/black(new_human), WEAR_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/blue(new_human), WEAR_BACK)

	var/random_scientist_glasses= rand(1,3)
	switch(random_scientist_glasses)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(new_human), WEAR_FACE)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular/hippie(new_human), WEAR_FACE)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular/hipster(new_human), WEAR_FACE)

	var/random_professional_shoe = rand(1,3)
	switch(random_professional_shoe)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(new_human), WEAR_FEET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup/brown(new_human), WEAR_FEET)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/upp(new_human), WEAR_FEET)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist/hybrisa(new_human), WEAR_BODY)

	..()
