/datum/tech/droppod/item/engi_czsp
	name = "Squad Engineer Combat Zone Support Package"
	desc = {"Gives upgraded composite (deployable) cades to regulars. \
			Gives squad engineers a mod kit for their deployable."}
	icon_state = "engi_kit"
	droppod_name = "Engi CZSP"

	flags = TREE_FLAG_MARINE

	required_points = 15
	tier = /datum/tier/one

/datum/tech/droppod/item/engi_czsp/get_options(mob/living/carbon/human/H, obj/structure/droppod/D)
	. = ..()
	if(H.job == JOB_SQUAD_ENGI)
		.["Engineering Upgrade Kit"] = /obj/item/engi_upgrade_kit
	else
		.["Random Tool"] = pick(common_tools)


/obj/item/engi_upgrade_kit
	name = "engineering upgrade kit"
	desc = "It seems to be a kit to upgrade an engineer's structure"

	icon = 'icons/obj/items/pro_case.dmi'
	icon_state = "pro_case_large"

/obj/item/engi_upgrade_kit/Initialize(mapload, ...)
	. = ..()
	update_icon()

/obj/item/engi_upgrade_kit/update_icon()
	overlays.Cut()
	. = ..()

	overlays += "+defense"

/obj/item/engi_upgrade_kit/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!ishuman(user))
		return ..()

	if(!istype(target, /obj/item/defenses/handheld))
		return ..()

	var/obj/item/defenses/handheld/D = target
	var/mob/living/carbon/human/H = user

	var/chosen_upgrade = tgui_input_list(user, "Please select a valid upgrade to apply to this kit", "Droppod", D.upgrade_list)

	if(QDELETED(D) || !D.upgrade_list[chosen_upgrade])
		return

	var/type_to_change_to = D.upgrade_list[chosen_upgrade]

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
