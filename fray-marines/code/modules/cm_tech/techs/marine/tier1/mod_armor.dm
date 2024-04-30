/datum/tech/droppod/item/modular_armor_upgrade
	name = "Modular Armor Upgrade Kits"
	desc = "Marines get access to plates they can put in their uniforms that act as temporary HP."
	icon_state = "combat_plates"
	droppod_name = "Armor Plates"

	flags = TREE_FLAG_MARINE

	required_points = 5
	tier = /datum/tier/one/additional

	droppod_input_message = "Choose a plate to retrieve from the droppod."

/datum/tech/droppod/item/modular_armor_upgrade/get_options(mob/living/carbon/human/H, obj/structure/droppod/D)
	. = ..()

	.["Ceramic Plate"] = /obj/item/clothing/accessory/health/ceramic_plate
	.["Metal Plate"] = /obj/item/clothing/accessory/health
