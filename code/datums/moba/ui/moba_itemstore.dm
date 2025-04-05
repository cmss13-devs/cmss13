GLOBAL_DATUM(moba_shop, /datum/moba_item_store)

/datum/moba_item_store
	var/static/list/lazy_ui_data = list()

/datum/moba_item_store/New()
	. = ..()

	if(!length(lazy_ui_data))
		lazy_ui_data["items_t1"] = list()
		lazy_ui_data["items_t2"] = list()
		lazy_ui_data["items_t3"] = list()
		for(var/datum/moba_item/item as anything in SSmoba.items)
			var/key_to_use = "items_t1"
			switch(item.tier)
				if(1)
					key_to_use = "items_t1"
				if(2)
					key_to_use = "items_t2"
				if(3)
					key_to_use = "items_t3"

			var/list/component_list = list()
			for(var/datum/moba_item/item_path as anything in item.component_items)
				component_list += item_path::name

			lazy_ui_data[key_to_use] += list(list(
				"name" = item.name,
				"description" = item.description,
				"cost" = item.total_gold_cost,
				"unique" = item.unique,
				"path" = item.type,
				"components" = component_list,
				"sell_value" = item.sell_value,
				"icon_state" = item.icon_state,
			))

/datum/moba_item_store/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MobaItemStore")
		ui.open()

/datum/moba_item_store/ui_state(mob/user)
	if(!istype(get_area(user), /area/misc/moba/base))
		return GLOB.never_state
	return GLOB.conscious_state

/datum/moba_item_store/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/moba_items),
	)

/datum/moba_item_store/ui_data(mob/user)
	var/list/data = list()

	var/list/datum/moba_item/items = list()
	var/list/item_name_list = list()
	SEND_SIGNAL(user, COMSIG_MOBA_GET_OWNED_ITEMS, items)
	for(var/datum/moba_item/item as anything in items)
		item_name_list += item.name

	var/list/gold_list = list()
	SEND_SIGNAL(user, COMSIG_MOBA_GET_GOLD, gold_list)

	data["owned_items"] = item_name_list
	data["at_item_capacity"] = (length(items) >= MOBA_MAX_ITEM_COUNT)
	data["gold"] = gold_list[1]

	return data

/datum/moba_item_store/ui_static_data(mob/user)
	var/list/data = list()

	data["items_t1"] = lazy_ui_data["items_t1"]
	data["items_t2"] = lazy_ui_data["items_t2"]
	data["items_t3"] = lazy_ui_data["items_t3"]
	data["gold_name_short"] = MOBA_GOLD_NAME_SHORT
	data["price_overrides"] = list()

	var/list/datum/moba_item/items = list()
	SEND_SIGNAL(user, COMSIG_MOBA_GET_OWNED_ITEMS, items)
	for(var/datum/moba_item/item as anything in SSmoba.items)
		var/recursive_gold = item.get_factored_cost(items)
		if(recursive_gold != item.total_gold_cost)
			data["price_overrides"][item.type] = recursive_gold

	return data

/datum/moba_item_store/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("buy_item")
			if(!params["path"] || !istype(get_area(ui.user), /area/misc/moba/base))
				ui.close()
				return
			var/item_path = text2path(params["path"])
			if(!ispath(item_path, /datum/moba_item))
				return

			var/list/gold_list = list()
			SEND_SIGNAL(ui.user, COMSIG_MOBA_GET_GOLD, gold_list)
			if(!length(gold_list) || !gold_list[1])
				return

			var/list/datum/moba_item/items = list()
			SEND_SIGNAL(ui.user, COMSIG_MOBA_GET_OWNED_ITEMS, items)
			var/datum/moba_item/item = SSmoba.item_dict[item_path]
			if(item.instanced)
				var/list/datum_list = list()
				SEND_SIGNAL(ui.user, COMSIG_MOBA_GET_PLAYER_DATUM, datum_list)
				item = new item_path(datum_list[1])
			var/factored_cost = item.get_factored_cost(items)
			var/list/held_components = item.get_recursive_held_components(items.Copy())

			if(gold_list[1] < factored_cost)
				return

			if((length(items) >= MOBA_MAX_ITEM_COUNT) && !length(held_components))
				return

			if(item.unique)
				for(var/datum/moba_item/item2 as anything in items)
					if(item.type == item2.type)
						return

			SEND_SIGNAL(ui.user, COMSIG_MOBA_GIVE_GOLD, -factored_cost)

			for(var/datum/moba_item/item2 as anything in held_components)
				SEND_SIGNAL(ui.user, COMSIG_MOBA_REMOVE_ITEM, item2)

			SEND_SIGNAL(ui.user, COMSIG_MOBA_ADD_ITEM, item)
			ui.update_static_data(ui.user, ui)
			return TRUE

		if("sell_item")
			if(!params["path"] || !istype(get_area(ui.user), /area/misc/moba/base))
				ui.close()
				return
			var/item_path = text2path(params["path"])
			if(!ispath(item_path, /datum/moba_item))
				return

			var/list/datum/moba_item/items = list()
			SEND_SIGNAL(ui.user, COMSIG_MOBA_GET_OWNED_ITEMS, items)
			for(var/datum/moba_item/item as anything in items)
				if(!istype(item, item_path))
					continue

				SEND_SIGNAL(ui.user, COMSIG_MOBA_GIVE_GOLD, item.sell_value)
				SEND_SIGNAL(ui.user, COMSIG_MOBA_REMOVE_ITEM, item)
				break

			return TRUE

