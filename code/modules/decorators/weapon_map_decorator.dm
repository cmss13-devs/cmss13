/datum/decorator/weapon_map_decorator
	var/list/map_array = list()

	var/icon/c_icon
	var/icon/l_icon
	var/icon/r_icon
	var/icon/b_icon
	var/icon/j_icon

/datum/decorator/weapon_map_decorator/is_active_decor()
	return map_array.Find(map_tag)

/datum/decorator/weapon_map_decorator/get_decor_types()
	return typesof(/obj/item/weapon/gun) - /obj/item/weapon/gun

/datum/decorator/weapon_map_decorator/decorate(var/obj/item/weapon/gun/gun)
	if(!istype(gun))
		return
	if(!gun.map_specific_decoration)
		return

	gun.icon = c_icon

	gun.item_icons = list()	
	
	gun.item_icons += list(WEAR_L_HAND = l_icon)
	gun.item_icons += list(WEAR_R_HAND = r_icon)
	gun.item_icons += list(WEAR_BACK = b_icon)
	gun.item_icons += list(WEAR_J_STORE = j_icon)

/datum/decorator/weapon_map_decorator/classic
	c_icon = 'icons/obj/items/weapons/guns/guns_by_map/classic/guns_obj.dmi'
	l_icon = 'icons/obj/items/weapons/guns/guns_by_map/classic/guns_lefthand.dmi'
	r_icon = 'icons/obj/items/weapons/guns/guns_by_map/classic/guns_righthand.dmi'
	b_icon = 'icons/obj/items/weapons/guns/guns_by_map/classic/back.dmi'
	j_icon = 'icons/obj/items/weapons/guns/guns_by_map/classic/suit_slot.dmi'
	map_array = list(MAP_PRISON_STATION)

/datum/decorator/weapon_map_decorator/desert
	c_icon = 'icons/obj/items/weapons/guns/guns_by_map/desert/guns_obj.dmi'
	l_icon = 'icons/obj/items/weapons/guns/guns_by_map/desert/guns_lefthand.dmi'
	r_icon = 'icons/obj/items/weapons/guns/guns_by_map/desert/guns_righthand.dmi'
	b_icon = 'icons/obj/items/weapons/guns/guns_by_map/desert/back.dmi'
	j_icon = 'icons/obj/items/weapons/guns/guns_by_map/desert/suit_slot.dmi'
	map_array = list(MAP_WHISKEY_OUTPOST, MAP_DESERT_DAM, MAP_BIG_RED)

/datum/decorator/weapon_map_decorator/jungle
	c_icon = 'icons/obj/items/weapons/guns/guns_by_map/jungle/guns_obj.dmi'
	l_icon = 'icons/obj/items/weapons/guns/guns_by_map/jungle/guns_lefthand.dmi'
	r_icon = 'icons/obj/items/weapons/guns/guns_by_map/jungle/guns_righthand.dmi'
	b_icon = 'icons/obj/items/weapons/guns/guns_by_map/jungle/back.dmi'
	j_icon = 'icons/obj/items/weapons/guns/guns_by_map/jungle/suit_slot.dmi'
	map_array = list(MAP_LV_624)

/datum/decorator/weapon_map_decorator/snow
	c_icon = 'icons/obj/items/weapons/guns/guns_by_map/snow/guns_obj.dmi'
	l_icon = 'icons/obj/items/weapons/guns/guns_by_map/snow/guns_lefthand.dmi'
	r_icon = 'icons/obj/items/weapons/guns/guns_by_map/snow/guns_righthand.dmi'
	b_icon = 'icons/obj/items/weapons/guns/guns_by_map/snow/back.dmi'
	j_icon = 'icons/obj/items/weapons/guns/guns_by_map/snow/suit_slot.dmi'
	map_array = list(MAP_CORSAT, MAP_SOROKYNE_STRATA, MAP_ICE_COLONY)

/datum/decorator/weapon_map_decorator/urban
	c_icon = 'icons/obj/items/weapons/guns/guns_by_map/urban/guns_obj.dmi'
	l_icon = 'icons/obj/items/weapons/guns/guns_by_map/urban/guns_lefthand.dmi'
	r_icon = 'icons/obj/items/weapons/guns/guns_by_map/urban/guns_righthand.dmi'
	b_icon = 'icons/obj/items/weapons/guns/guns_by_map/urban/back.dmi'
	j_icon = 'icons/obj/items/weapons/guns/guns_by_map/urban/suit_slot.dmi'
	map_array = list()