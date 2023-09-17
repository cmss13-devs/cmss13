/datum/tech/droppod/item/engi_czsp
	name = "Combat Technician Combat Zone Support Package"
	desc = {"Gives upgraded composite (deployable) cades to regulars. \
			Gives ComTechs a mod kit for their deployable."}
	icon_state = "engi_kit"
	droppod_name = "Engi CZSP"

	flags = TREE_FLAG_MARINE

	required_points = 15
	tier = /datum/tier/one

/datum/tech/droppod/item/engi_czsp/pre_item_stats(mob/user)
	. = ..()
	. += list(list(
		"content" = "Restricted usecase",
		"color" = "orange",
		"icon" = "exclamation-triangle",
		"tooltip" = "Only usable by [JOB_SQUAD_ENGI]."
	))


/datum/tech/droppod/item/engi_czsp/get_options(mob/living/carbon/human/H, obj/structure/droppod/D)
	. = ..()
	if(!H || H.job == JOB_SQUAD_ENGI)
		.["Engineering Upgrade Kit"] = /obj/item/engi_upgrade_kit
	else
		.["Random Tool"] = pick(common_tools)
