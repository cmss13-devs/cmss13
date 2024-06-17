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
		.["21S Tesla Coil"] = /obj/item/storage/box/combat_zone_engi_package_tesla
		.["UA 42-F Sentry Flamer"] = /obj/item/storage/box/combat_zone_engi_package_flamer
		.["UA 571-C Sentry Gun"] = /obj/item/storage/box/combat_zone_engi_package
	else if(H.job == JOB_SQUAD_MARINE)
		.["Portable Composite Barricade"] = /obj/item/stack/folding_barricade
	else
		.["Random Tool"] = pick(GLOB.common_tools)

/obj/item/storage/box/combat_zone_engi_package
	name = "Engineer sentry gun czsp"
	icon_state = "guncase"
	storage_slots = 4

/obj/item/storage/box/combat_zone_engi_package_flamer
	name = "Engineer sentry flamer czsp"
	icon_state = "guncase"
	storage_slots = 4

/obj/item/storage/box/combat_zone_engi_package_tesla
	name = "Engineer tesla czsp"
	icon_state = "guncase"
	storage_slots = 4

/obj/item/storage/box/combat_zone_engi_package/Initialize()
	. = ..()
	new /obj/item/defenses/handheld/sentry(src)
	new /obj/item/engi_upgrade_kit(src)
	new /obj/item/weapon/gun/smg/nailgun/compact(src)
	new /obj/item/ammo_magazine/smg/nailgun(src)

/obj/item/storage/box/combat_zone_engi_package_flamer/Initialize()
	. = ..()
	new /obj/item/defenses/handheld/sentry/flamer(src)
	new /obj/item/engi_upgrade_kit(src)
	new /obj/item/weapon/gun/smg/nailgun/compact(src)
	new /obj/item/ammo_magazine/smg/nailgun(src)

/obj/item/storage/box/combat_zone_engi_package_tesla/Initialize()
	. = ..()
	new /obj/item/defenses/handheld/tesla_coil(src)
	new /obj/item/engi_upgrade_kit(src)
	new /obj/item/weapon/gun/smg/nailgun/compact(src)
	new /obj/item/ammo_magazine/smg/nailgun(src)
