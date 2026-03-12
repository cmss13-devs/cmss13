GLOBAL_LIST_INIT_TYPED(chest_hair_list, /datum/sprite_accessory/chest_hair, setup_chest_hair())

/proc/setup_chest_hair()
	var/list/styles = list()
	var/datum/sprite_accessory/chest_hair/none_datum = new /datum/sprite_accessory/chest_hair
	styles[none_datum.name] = none_datum
	for(var/chest_hair_type in subtypesof(/datum/sprite_accessory/chest_hair))
		var/datum/sprite_accessory/chest_hair/CH = new chest_hair_type
		styles[CH.name] = CH
	return styles

/datum/sprite_accessory/chest_hair
	name = "None"
	icon = 'icons/mob/humans/species/chest_hair.dmi'
	icon_state = "none"
	do_coloration = TRUE

/datum/sprite_accessory/chest_hair/light
	name = "Light"
	icon_state = "light"

/datum/sprite_accessory/chest_hair/medium
	name = "Medium"
	icon_state = "medium"

/datum/sprite_accessory/chest_hair/heavy
	name = "Heavy"
	icon_state = "heavy"
