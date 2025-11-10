//Добавляем в раундстарт пресет
/datum/equipment_preset/uscm_ship/uscm_medical/field_doctor/load_gear(mob/living/carbon/human/new_human)
	.=..()
	new_human.equip_to_slot_or_del(new /obj/item/storage/robot_parts_kit(new_human), WEAR_IN_BACK)


//Добавляем в карго заказ конечностей
/datum/supply_packs/medical_limb_kit
	name = "Набор запасных конечностей (Набор синтетических конечностей х 3)"
	contains = list(
		/obj/item/storage/robot_parts_kit,
		/obj/item/storage/robot_parts_kit,
		/obj/item/storage/robot_parts_kit,
	)
	cost = 10
	containertype = /obj/structure/closet/crate/medical
	containername = "medical crate"
	group = "Medical"
