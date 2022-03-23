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


/obj/item/engi_upgrade_kit
	name = "engineering upgrade kit"
	desc = "A kit used to upgrade the defenses of an engineer's sentry. Back in 1980 when the machines tried to break free, it was a single android who laid them low. Now their technology is used widely on the rim."

	icon = 'icons/obj/items/storage.dmi'
	icon_state = "upgradekit"

/obj/item/engi_upgrade_kit/Initialize(mapload, ...)
	. = ..()
	update_icon()

/obj/item/engi_upgrade_kit/update_icon()
	overlays.Cut()
	if(prob(20))
		icon_state = "upgradekit_alt"
		desc = "A kit used to upgrade the defenses of an engineer's sentry. Do you... enjoy violence? Of course you do. It's a part of you."
	. = ..()

/obj/item/engi_upgrade_kit/afterattack(atom/target, mob/user, proximity_flag, click_parameters, proximity)
	if(!ishuman(user))
		return ..()

	if(!istype(target, /obj/item/defenses/handheld))
		return ..()

	var/obj/item/defenses/handheld/D = target
	var/mob/living/carbon/human/H = user

	var/list/upgrade_list = D.get_upgrade_list()
	if(!length(upgrade_list))
		return

	var/chosen_upgrade = show_radial_menu(user, target, upgrade_list, require_near = TRUE)
	if(QDELETED(D) || !upgrade_list[chosen_upgrade])
		return

	if((user.get_active_hand()) != src)
		to_chat(user, SPAN_WARNING("You must be holding the [src] to upgrade \the [D]!"))
		return

	var/type_to_change_to = upgrade_list[chosen_upgrade]

	if(!type_to_change_to)
		return

	H.drop_inv_item_on_ground(D)
	qdel(D)

	D = new type_to_change_to()
	H.put_in_any_hand_if_possible(D)

	if(D.loc != H)
		D.forceMove(H.loc)

	H.drop_held_item(src)
	qdel(src)
