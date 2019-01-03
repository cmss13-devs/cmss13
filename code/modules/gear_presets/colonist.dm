

/datum/equipment_preset/colonist
	name = "Colonist"
	flags = EQUIPMENT_PRESET_EXTRA

/datum/equipment_preset/colonist/load_languages(mob/living/carbon/human/H)
	H.set_languages(list("English"))


/datum/equipment_preset/colonist/load_id(mob/living/carbon/human/H)
	. = ..()
	if(H.mind)
		H.mind.assigned_role = "Colonist"
		H.mind.special_role = "MODE"

/datum/equipment_preset/colonist/load_name(mob/living/carbon/human/H)
	H.gender = pick(MALE, FEMALE)
	var/datum/preferences/A = new
	A.randomize_appearance_for(H)
	H.real_name = capitalize(pick(H.gender == MALE ? first_names_male : first_names_female)) + " " + capitalize(pick(last_names))
	H.name = H.real_name
	H.age = rand(21,45)

/datum/equipment_preset/colonist/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
	H.equip_to_slot(new /obj/item/weapon/combat_knife(H), WEAR_L_STORE)
	H.equip_to_slot(new /obj/item/device/flashlight(H), WEAR_R_STORE)

/datum/equipment_preset/colonist/fighter/load_skills(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.set_cm_skills(/datum/skills/civilian)