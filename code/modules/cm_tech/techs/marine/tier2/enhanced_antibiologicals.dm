/datum/tech/droppod/item/enhanced_antibiologicals
	name = "Enhanced Antibiologicals"
	desc = "Marines get access to limited-use kits that can convert ammo magazines into the specified ammo."
	icon_state = "ammo"
	droppod_name = "Ammo Kits"
	flags = TREE_FLAG_MARINE

	required_points = 25
	tier = /datum/tier/two

	droppod_input_message = "Choose an ammo kit to retrieve from the droppod."

/datum/tech/droppod/item/enhanced_antibiologicals/get_options(mob/living/carbon/human/H, obj/structure/droppod/D)
	. = ..()

	.["Incendiary Buckshot Kit"] = /obj/item/storage/box/shotgun/buckshot
	.["Incendiary Slug Kit"] = /obj/item/storage/box/shotgun/slug
	.["Incendiary Ammo Kit"] = /obj/item/ammo_kit/incendiary
	.["Wall-Piercing Ammo Kit"] = /obj/item/ammo_kit/penetrating
	.["Toxin Ammo Kit"] = /obj/item/ammo_kit/toxin

/obj/item/ammo_kit
	name = "ammo kit"
	icon = 'icons/obj/items/devices.dmi'
	desc = "An ammo kit used to convert regular ammo magazines of various weapons into a different variation."
	icon_state = "kit_generic"

	var/list/convert_map
	var/uses = 5

/obj/item/ammo_kit/Initialize(mapload, ...)
	. = ..()
	convert_map = get_convert_map()

/obj/item/ammo_kit/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("It has [uses] uses remaining."))

/obj/item/ammo_kit/afterattack(atom/target, mob/living/user, proximity_flag, click_parameters)
	if(!(target.type in convert_map))
		return ..()

	if(uses <= 0)
		return ..()

	var/obj/item/ammo_magazine/M = target
	if(M.current_rounds < M.max_rounds)
		to_chat(user, SPAN_WARNING("The magazine needs to be full for you to apply this kit onto it."))
		return

	if(user.l_hand != M && user.r_hand != M)
		to_chat(user, SPAN_WARNING("The magazine needs to be in your hands for you to apply this kit onto it."))
		return

	var/type_to_convert_to = convert_map[target.type]

	user.drop_held_item(M)
	QDEL_NULL(M)
	M = new type_to_convert_to(get_turf(user))
	user.put_in_any_hand_if_possible(M)
	uses -= 1
	playsound(get_turf(user), "sound/machines/fax.ogg", 5)

	if(uses <= 0)
		user.drop_held_item(src)
		qdel(src)

/obj/item/ammo_kit/proc/get_convert_map()
	return list()

/obj/item/ammo_kit/incendiary
	name = "incendiary ammo kit"
	icon_state = "kit_incendiary"
	desc = "Converts magazines into incendiary ammo."

/obj/item/ammo_kit/incendiary/get_convert_map()
	. = ..()
	.[/obj/item/ammo_magazine/smg/m39] = /obj/item/ammo_magazine/smg/m39/incendiary
	.[/obj/item/ammo_magazine/rifle] = /obj/item/ammo_magazine/rifle/incendiary
	.[/obj/item/ammo_magazine/rifle/l42a] = /obj/item/ammo_magazine/rifle/l42a/incendiary
	.[/obj/item/ammo_magazine/rifle/m41aMK1] = /obj/item/ammo_magazine/rifle/m41aMK1/incendiary
	.[/obj/item/ammo_magazine/pistol] =  /obj/item/ammo_magazine/pistol/incendiary
	.[/obj/item/ammo_magazine/pistol/vp78] =  /obj/item/ammo_magazine/pistol/vp78/incendiary
	.[/obj/item/ammo_magazine/pistol/mod88] =  /obj/item/ammo_magazine/pistol/mod88/incendiary
	.[/obj/item/ammo_magazine/revolver] =  /obj/item/ammo_magazine/revolver/incendiary

/obj/item/storage/box/shotgun
	name = "incendiary shotgun kit"
	desc = "A kit containing incendiary shotgun shells."
	icon_state = "incenbuck"
	storage_slots = 5
	var/amount = 5
	var/to_hold

/obj/item/storage/box/shotgun/fill_preset_inventory()
	if(to_hold)
		for(var/i in 1 to amount)
			new to_hold(src)

/obj/item/storage/box/shotgun/buckshot
	name = "incendiary buckshot kit"
	desc = "A box containing 5 handfuls of incendiary buckshot."
	can_hold = list(
		/obj/item/ammo_magazine/handful/shotgun/custom_color/incendiary
	)
	to_hold = /obj/item/ammo_magazine/handful/shotgun/custom_color/incendiary

/obj/item/storage/box/shotgun/slug
	name = "incendiary slug kit"
	desc = "A box containing 5 handfuls of incendiary slugs."
	icon_state = "incenslug"
	can_hold = list(
		/obj/item/ammo_magazine/handful/shotgun/incendiary
	)
	to_hold = /obj/item/ammo_magazine/handful/shotgun/incendiary

/obj/item/ammo_kit/penetrating
	name = "wall-piercing ammo kit"
	icon_state = "kit_penetrating"
	desc = "Converts magazines into wall-piercing ammo."

/obj/item/ammo_kit/penetrating/get_convert_map()
	. = ..()
	.[/obj/item/ammo_magazine/smg/m39] = /obj/item/ammo_magazine/smg/m39/penetrating
	.[/obj/item/ammo_magazine/rifle] = /obj/item/ammo_magazine/rifle/penetrating
	.[/obj/item/ammo_magazine/rifle/l42a] = /obj/item/ammo_magazine/rifle/l42a/penetrating
	.[/obj/item/ammo_magazine/rifle/m41aMK1] = /obj/item/ammo_magazine/rifle/m41aMK1/penetrating
	.[/obj/item/ammo_magazine/pistol] =  /obj/item/ammo_magazine/pistol/penetrating
	.[/obj/item/ammo_magazine/pistol/vp78] =  /obj/item/ammo_magazine/pistol/vp78/penetrating
	.[/obj/item/ammo_magazine/pistol/mod88] =  /obj/item/ammo_magazine/pistol/mod88/penetrating
	.[/obj/item/ammo_magazine/revolver] =  /obj/item/ammo_magazine/revolver/penetrating

/obj/item/ammo_kit/toxin
	name = "toxin ammo kit"
	icon_state = "kit_toxin"
	desc = "Converts magazines into toxin ammo."

/obj/item/ammo_kit/toxin/get_convert_map()
	. = ..()
	.[/obj/item/ammo_magazine/smg/m39] = /obj/item/ammo_magazine/smg/m39/toxin
	.[/obj/item/ammo_magazine/rifle] = /obj/item/ammo_magazine/rifle/toxin
	.[/obj/item/ammo_magazine/rifle/l42a] = /obj/item/ammo_magazine/rifle/l42a/toxin
	.[/obj/item/ammo_magazine/rifle/m41aMK1] = /obj/item/ammo_magazine/rifle/m41aMK1/toxin
	.[/obj/item/ammo_magazine/pistol] =  /obj/item/ammo_magazine/pistol/toxin
	.[/obj/item/ammo_magazine/pistol/vp78] =  /obj/item/ammo_magazine/pistol/vp78/toxin
	.[/obj/item/ammo_magazine/pistol/mod88] =  /obj/item/ammo_magazine/pistol/mod88/toxin
	.[/obj/item/ammo_magazine/revolver] =  /obj/item/ammo_magazine/revolver/marksman/toxin
