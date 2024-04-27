/datum/tech/droppod/item/engi_czsp
	name = "Combat Technician Combat Zone Support Package"
	desc = {"Gives upgraded composite (deployable) cades to regulars. \
			Gives ComTechs a single brand-new deployable."}
	icon_state = "engi_kit"
	droppod_name = "Engi CZSP"

	flags = TREE_FLAG_MARINE

	required_points = 6
	tier = /datum/tier/one/additional

	droppod_input_message = "Choose a deployable to retrieve from the droppod."
/*
/datum/tech/droppod/item/engi_czsp/pre_item_stats(mob/user)
	. = ..()
	. += list(list(
		"content" = "Restricted usecase",
		"color" = "orange",
		"icon" = "exclamation-triangle",
		"tooltip" = "Only usable by [JOB_SQUAD_ENGI]."
	))
*/
/datum/tech/droppod/item/engi_czsp/get_options(mob/living/carbon/human/H, obj/structure/droppod/D)
	. = ..()
	if(!H || !D)
		return
	if(H.job == JOB_SQUAD_ENGI)
		.["R-1NG Bell Tower"] = /obj/item/defenses/handheld/bell_tower
		.["21S Tesla Coil"] = /obj/item/defenses/handheld/tesla_coil
		.["JIMA Planted Flag"] = /obj/item/defenses/handheld/planted_flag
		.["UA 42-F Sentry Flamer"] = /obj/item/defenses/handheld/sentry/flamer
		.["UA 571-C Sentry Gun"] = /obj/item/defenses/handheld/sentry
	else if(H.job == JOB_SQUAD_MARINE)
		.["Portable Composite Barricade"] = /obj/item/stack/folding_barricade
	else
		.["Random Tool"] = pick(GLOB.common_tools)
