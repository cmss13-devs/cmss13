/datum/moba_item_store
	var/static/list/lazy_ui_data = list()
	var/mob/living/carbon/xenomorph/xeno
	var/datum/weakref/shop

/datum/moba_item_store/New(mob/living/carbon/xenomorph/our_xeno, obj/effect/alien/resin/moba_shop/opened_from)
	. = ..()
	xeno = our_xeno
	shop = WEAKREF(opened_from)

	if(!length(lazy_ui_data))
		lazy_ui_data["items"] = list()
		for(var/datum/moba_item/item as anything in SSmoba.items)
			lazy_ui_data["items"] += list(list(
				"name" = item.name,
				"description" = item.description,
				"cost" = item.gold_cost,
				"unique" = item.unique,
				"path" = item.type,
			))

/datum/moba_item_store/Destroy(force, ...)
	xeno = null
	return ..()

/datum/moba_item_store/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MobaItemStore")
		ui.open()

/datum/moba_item_store/ui_state(mob/user)
	var/obj/effect/alien/resin/moba_shop/shop_ref = shop.resolve()
	if(get_dist(xeno, shop_ref) > 1)
		return GLOB.never_state
	return GLOB.conscious_state // zonenote eventually make this require someone being in spawn somehow

/datum/moba_item_store/ui_data(mob/user)
	var/list/data = list()

	var/list/datum/moba_item/items = list()
	var/list/item_name_list = list()
	SEND_SIGNAL(xeno, COMSIG_MOBA_GET_OWNED_ITEMS, items)
	for(var/datum/moba_item/item as anything in items)
		item_name_list += item.name

	data["owned_items"] = item_name_list

	return data

/datum/moba_item_store/ui_static_data(mob/user)
	var/list/data = list()

	data["items"] = lazy_ui_data["items"]

	return data

/datum/moba_item_store/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("buy_item")
			if(!params["path"])
				return
			var/item_path = text2path(params["path"])
			if(!ispath(item_path, /datum/moba_item))
				return

			var/list/gold_list = list()
			SEND_SIGNAL(xeno, COMSIG_MOBA_GET_GOLD, gold_list)
			if(!length(gold_list) || !gold_list[1])
				return

			var/datum/moba_item/item = new item_path
			if(gold_list[1] < item.gold_cost)
				return

			if(item.unique)
				var/list/datum/moba_item/items = list()
				SEND_SIGNAL(xeno, COMSIG_MOBA_GET_OWNED_ITEMS, items)
				for(var/datum/moba_item/item2 as anything in items)
					if(item.type == item2.type)
						return

			SEND_SIGNAL(xeno, COMSIG_MOBA_GIVE_GOLD, -item.gold_cost)
			SEND_SIGNAL(xeno, COMSIG_MOBA_ADD_ITEM, item)
			return TRUE
