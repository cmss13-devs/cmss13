/datum/equipment_preset/guardian
	name = "Guardian"
	flags = EQUIPMENT_PRESET_START_OF_ROUND
	idtype = null //No IDs for guardian for now
	languages = list(LANGUAGE_ENGLISH,LANGUAGE_XENOMORPH, LANGUAGE_HIVEMIND)
	job_title = "Guardian"
	faction = FACTION_XENO_CULTIST
	faction_group = FACTION_LIST_XENO_CULTIST
	uses_special_name = TRUE
	skills = /datum/skills/yautja/warrior //CHANGE THIS ONCE WE KNOW WHAT SKILLS WE WANT

	minimap_icon = "guardian"

/datum/equipment_preset/guardian/load_race(mob/living/carbon/human/guardian/new_human, client/mob_client)
	. = ..()
	new_human.set_species(SPECIES_GUARDIAN)
	new_human.bubble_icon = "guardian"

/datum/equipment_preset/guardian/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	. = ..()
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/guardian(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/guardian(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/guardian(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/guardian(new_human), WEAR_JACKET)


/obj/item/clothing/shoes/guardian
	name = "Guardian boots"
	icon = 'icons/mob/humans/species/t_guardian.dmi'
	icon_state = "guardian_boots"
	item_state = "guardian_boots"

/obj/item/clothing/under/guardian
	name = "Guardian uniform"
	icon = 'icons/mob/humans/species/t_guardian.dmi'
	icon_state = "guardian_uniform"
	item_state = "guardian_uniform"
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/misc_ert_colony.dmi'
	)
/obj/item/clothing/mask/gas/guardian
	name = "Guardian mask"
	icon = 'icons/mob/humans/species/t_guardian.dmi'
	icon_state = "guardian_mask"
	item_state = "guardian_mask"
	flags_inventory = COVERMOUTH|ALLOWINTERNALS|BLOCKGASEFFECT|ALLOWREBREATH
	flags_equip_slot = SLOT_FACE
	flags_inventory = CANTSTRIP

/obj/item/clothing/suit/armor/guardian
	name = "Guardian armor"
	icon = 'icons/mob/humans/species/t_guardian.dmi'
	icon_state = "guardian_torso"
	item_state= "guardian_torso"
	flags_inventory = CANTSTRIP
