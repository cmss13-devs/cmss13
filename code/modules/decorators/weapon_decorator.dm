/datum/decorator/manual/weapon_decorator
	var/weapon_type
	var/icon/icon
	var/icon/l_hand
	var/icon/r_hand
	var/icon/icon_override
	var/icon_state
	var/item_state
	var/base_gun_icon

/datum/decorator/manual/weapon_decorator/New(_weapon_type)
	weapon_type = _weapon_type

/datum/decorator/manual/weapon_decorator/get_decor_types()
	return list(text2path(weapon_type))

/datum/decorator/manual/weapon_decorator/decorate(var/atom/object)
	var/obj/item/weapon/gun/G = object
	if(!istype(G))
		return
	if(icon)
		G.icon = icon
	if(l_hand || r_hand)
		G.item_icons = list()
		if(l_hand)
			G.item_icons += list("l_hand" = l_hand)
		if(r_hand)
			G.item_icons += list("r_hand" = r_hand)
	if(icon_state)
		G.icon_state = icon_state
	if(base_gun_icon)
		G.base_gun_icon = base_gun_icon
	if(icon_override)
		G.icon_override = icon_override
	if(item_state)
		G.item_state = item_state


/datum/decorator/manual/item_decorator
	var/item_type
	var/icon/icon
	var/icon_state
	var/name
	var/desc

/datum/decorator/manual/item_decorator/New(_item_type)
	item_type = _item_type

/datum/decorator/manual/item_decorator/get_decor_types()
	return list(text2path(item_type))

/datum/decorator/manual/item_decorator/decorate(var/atom/object)
	var/obj/item/I = object
	if(icon)
		I.icon = icon
	if(icon_state)
		I.icon_state = icon_state
	if(name)
		I.name = name
	if(desc)
		I.desc = desc