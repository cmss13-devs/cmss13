/datum/equipment_preset/survivor/engineer/kutjevo
	name = "Survivor - Kutjevo Engineer"
	assignment = "Kutjevo Engineer"

/datum/equipment_preset/survivor/engineer/kutjevo/load_gear(mob/living/carbon/human/new_human)
	add_random_kutjevo_survivor_uniform(new_human)
	add_random_kutjevo_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/eng(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hazardvest/black(new_human), WEAR_JACKET)
	..()

/datum/equipment_preset/survivor/chaplain/kutjevo
	name = "Survivor - Kutjevo Chaplain"
	assignment = "Kutjevo Chaplain"

/datum/equipment_preset/survivor/chaplain/kutjevo/load_gear(mob/living/carbon/human/new_human)
	add_random_kutjevo_survivor_uniform(new_human)
	add_random_kutjevo_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(new_human), WEAR_HANDS)

	..()

/datum/equipment_preset/survivor/security/kutjevo
	name = "Survivor - Kutjevo Security Guard"
	assignment = "Kutjevo Security Guard"


/datum/equipment_preset/survivor/security/kutjevo/load_gear(mob/living/carbon/human/new_human)
	add_random_kutjevo_survivor_uniform(new_human)
	add_random_kutjevo_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/sec(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate/knife(new_human), WEAR_FEET)
	..()

/datum/equipment_preset/survivor/doctor/kutjevo
	name = "Survivor - Kutjevo Doctor"
	assignment = "Kutjevo Doctor"

/datum/equipment_preset/survivor/doctor/kutjevo/load_gear(mob/living/carbon/human/new_human)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	add_random_kutjevo_survivor_uniform(new_human)
	add_random_kutjevo_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(new_human), WEAR_HANDS)
	..()

/datum/equipment_preset/survivor/colonial_marshal/kutjevo
	name = "Survivor - Kutjevo Colonial Marshal Deputy"
	assignment = "CMB Deputy"

/datum/equipment_preset/survivor/colonial_marshal/kutjevo/load_gear(mob/living/carbon/human/new_human)
	add_random_kutjevo_survivor_uniform(new_human)
	add_random_kutjevo_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/veteran/pmc(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/distress/CMB/limited(new_human), WEAR_L_EAR)
	..()

/datum/equipment_preset/survivor/trucker/kutjevo
	name = "Survivor - Kutjevo Heavy Vehicle Operator"
	assignment = "Kutjevo Heavy Vehicle Operator"

/datum/equipment_preset/survivor/trucker/kutjevo/load_gear(mob/living/carbon/human/new_human)
	add_random_kutjevo_survivor_uniform(new_human)
	add_random_kutjevo_survivor_equipment(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_human), WEAR_BACK)
	..()
