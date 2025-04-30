/datum/equipment_preset/survivor/security/corsat
	name = "Survivor - CORSAT Security Guard"
	assignment = JOB_WY_SEC
	rank = JOB_WY_SEC
	minimap_background = "background_goon"
	minimap_icon = "cmp"
	idtype = /obj/item/card/id/silver/cl
	faction = FACTION_WY
	faction_group = list(FACTION_WY, FACTION_SURVIVOR)
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)

/datum/equipment_preset/survivor/security/corsat/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist/white_service(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/patch/wy_faction(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc/sec(new_human), WEAR_HEAD)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/doctor/corsat
	name = "Survivor - CORSAT Doctor"
	assignment = "CORSAT Doctor"

/datum/equipment_preset/survivor/doctor/corsat/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/green(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/green(new_human), WEAR_HEAD)
	..()

/datum/equipment_preset/survivor/scientist/corsat
	name = "Survivor - CORSAT Researcher"
	assignment = "CORSAT Researcher"

/datum/equipment_preset/survivor/scientist/corsat/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/researcher(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/interstellar_commerce_commission_liaison/corsat
	name = "Survivor - Interstellar Commerce Commission Liaison CORSAT"
	assignment = "Interstellar Commerce Commission Corporate Liaison"

/datum/equipment_preset/survivor/interstellar_commerce_commission_liaison/corsat/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit/corporate_formal(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CMB/limited(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/white(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(new_human), WEAR_JACKET)
	..()

/datum/equipment_preset/survivor/engineer/corsat
	name = "Survivor - Corsat Station Engineer"
	assignment = "Corsat Station Engineer"

/datum/equipment_preset/survivor/engineer/corsat/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/engi(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/marine/techofficer(new_human), WEAR_HEAD)
	..()
