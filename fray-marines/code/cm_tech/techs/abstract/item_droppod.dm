/datum/tech/droppod/item
	name = "PLEASE SET ME!!!!!!"

	var/droppod_input_message = "Choose an item to retrieve from the droppod."
	var/list/slots_to_equip_to = list(
		WEAR_L_HAND,
		WEAR_R_HAND,
		WEAR_IN_BACK,
		WEAR_IN_JACKET,
		WEAR_IN_L_STORE,
		WEAR_IN_R_STORE
	)
	var/options_to_give = 1
	var/restricted_usecase = FALSE

/datum/tech/droppod/item/proc/pre_item_stats()
	return list(list(
		"content" = "Quantity to give: [options_to_give]",
		"color" = "orange",
		"icon" = "warehouse"
	))

/datum/tech/droppod/item/ui_static_data(mob/user)
	. = ..()
	.["stats"] += pre_item_stats()
	var/list/data = get_options()
	for(var/i in data)
		var/obj/item/A = data[i]
		.["stats"] += list(list(
			"content" = "Item: [i]",
			"color" = "green",
			"icon" = "arrow-alt-circle-right",
			"tooltip" = "[initial(A.desc)]"
		))

/datum/tech/droppod/item/proc/get_options(mob/living/carbon/human/H, obj/structure/droppod/D)
	return list()

/// This proc can potentially be blocking! Don't use unless you know what you're doing!
/datum/tech/droppod/item/proc/get_items_to_give(mob/living/carbon/human/H, obj/structure/droppod/D)
	var/list/options = get_options(H, D)
	if(!length(options))
		return

	if(length(options) == 1)
		// thanks byond
		return list(options[options[1]])
	else
		var/list/items_to_give = list()
		for(var/i in 1 to min(length(options), options_to_give))
			var/player_input = tgui_input_list(H, droppod_input_message, name, options)
			// Early return here because they decided to cancel their selection or the option no longer exists.
			if(!player_input || !(player_input in get_options(H, D)))
				return

			items_to_give += options[player_input]
			options -= player_input

		return items_to_give

/datum/tech/droppod/item/on_pod_access(mob/living/carbon/human/H, obj/structure/droppod/D)
	var/list/items_to_give = get_items_to_give(H, D)

	if(!length(items_to_give))
		return

	if(!can_access(H, D))
		return

	for(var/i in items_to_give)
		var/atom/movable/item_to_give = i

		if(ispath(i))
			item_to_give = new i()

		if(H.put_in_active_hand(item_to_give))
			continue

		for(var/slot in slots_to_equip_to)
			if(H.equip_to_slot_if_possible(item_to_give, slot, disable_warning=TRUE))
				break

		if(!item_to_give.loc)
			item_to_give.forceMove(get_turf(H))

	. = ..()

/datum/tech/droppod/item/on_unlock()
	. = ..()
	for(var/i in GLOB.radio_packs)
		var/obj/item/storage/backpack/marine/satchel/rto/backpack = i
		backpack.new_droppod_tech_unlocked(src)
