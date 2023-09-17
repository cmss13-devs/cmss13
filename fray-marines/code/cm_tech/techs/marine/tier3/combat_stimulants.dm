/datum/tech/droppod/item/combat_stimulants
	name = "Combat Stimulants"
	desc = "Marines get access to combat stimulants to assist them in their activities."
	icon_state = "stimulants"
	droppod_name = "Stimulants"
	flags = TREE_FLAG_MARINE

	required_points = 25
	tier = /datum/tier/three

	droppod_input_message = "Choose a stimulant to retrieve from the droppod."

/datum/tech/droppod/item/combat_stimulants/get_options(mob/living/carbon/human/H, obj/structure/droppod/D)
	. = ..()

	.["Speed Stimulant"] = /obj/item/storage/pouch/stimulant_injector/speed
	.["Redemption Stimulant"] = /obj/item/storage/pouch/stimulant_injector/redemption
	.["Brain Stimulant"] = /obj/item/storage/pouch/stimulant_injector/brain
