/datum/equipment_preset/survivor/scientist/lv
	name = "Survivor - LV-624 Archeologist"
	assignment = "LV-624 Archeologist"

/datum/equipment_preset/survivor/scientist/lv/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/researcher(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap/boonie(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/science(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/colonial_marshal/lv
	name = "Survivor - LV-624 Head of Security"
	assignment = "LV-624 Head of Security"

/datum/equipment_preset/survivor/colonial_marshal/lv/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/head_of_security/navyblue(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/beret/sec/hos(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/trucker/lv
	name = "Survivor - LV-624 Cargo Technician"
	assignment = "LV-624 Cargo Technician"

/datum/equipment_preset/survivor/trucker/lv/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/cargo(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/meson(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/yellow(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	..()

/datum/equipment_preset/survivor/engineer/lv
	name = "Survivor - LV-624 Engineer"
	assignment = "LV-624 Engineer"

/datum/equipment_preset/survivor/engineer/lv/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/dispatch(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/orange(new_human), WEAR_HEAD)
	..()

/datum/equipment_preset/survivor/chaplain/lv
	name = "Survivor - LV-624 Priest"
	assignment = "LV-624 Priest"

/datum/equipment_preset/survivor/chaplain/lv/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chaplain(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/priest_robe(new_human), WEAR_JACKET)
	..()

/datum/equipment_preset/survivor/doctor/lv
	name = "Survivor - LV-624 Emergency Medical Technician"
	assignment = "LV-624 Emergency Medical Technician"

/datum/equipment_preset/survivor/doctor/lv/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(new_human.back), WEAR_IN_BACK)
	..()

/datum/equipment_preset/survivor/security/lv
	name = "Survivor - LV-624 Security Guard"
	assignment = "Weyland-Yutani Security Guard"
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE)

/datum/equipment_preset/survivor/security/lv/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/formal/servicedress(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/WY(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/pmc(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle(new_human), WEAR_FEET)
	..()

