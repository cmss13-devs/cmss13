/datum/tech/droppod/item/barrel
	name = "Upgraded barrel charger modification"
	desc = "Gives marines powerful modification UBC for your weapon"
	icon = 'fray-marines/icons/effects/techtree/tech.dmi'
	icon_state = "adv_bc"
	droppod_name = "UBC Modification"

	flags = TREE_FLAG_MARINE

	required_points = 15
	tier = /datum/tier/one

	droppod_input_message = "Choose a deployable to retrieve from the droppod."

/datum/tech/droppod/item/barrel/get_options(mob/living/carbon/human/H, obj/structure/droppod/D)
	. = ..()

	.["Upgraded Barrel Charger"] = /obj/item/attachable/heavy_barrel/upgraded
