


/*
 * Table Parts
 */

/obj/item/frame/table
	name = "tan table parts"
	desc = "A kit for a table, including a large, flat metal surface and four legs. Some assembly required."
	gender = PLURAL
	icon = 'icons/obj/items/items.dmi'
	icon_state = "tan_table_parts"
	item_state = "tan_table_parts"
	matter = list("metal" = 7500) //A table, takes two sheets to build
	flags_atom = FPRINT|CONDUCT
	attack_verb = list("slammed", "bashed", "battered", "bludgeoned", "thrashed", "whacked")
	var/table_type = /obj/structure/table //what type of table it creates when assembled

/obj/item/frame/table/attackby(obj/item/W, mob/user)

	..()
	if(istype(W, /obj/item/tool/wrench))
		new /obj/item/stack/sheet/metal(user.loc)
		qdel(src)

	if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = W
		if(R.use(4))
			new /obj/item/frame/table/reinforced(get_turf(src))
			to_chat(user, SPAN_NOTICE("You reinforce [src]."))
			user.temp_drop_inv_item(src)
			qdel(src)
		else
			to_chat(user, SPAN_WARNING("You need at least four rods to reinforce [src]."))

	if(istype(W, /obj/item/stack/sheet/wood))
		var/obj/item/stack/sheet/wood/S = W
		if(S.use(2))
			new /obj/item/frame/table/wood(get_turf(src))
			new /obj/item/stack/sheet/metal(get_turf(src))
			to_chat(user, SPAN_NOTICE("You replace the metal parts of [src]."))
			user.temp_drop_inv_item(src)
			qdel(src)
		else
			to_chat(user, SPAN_WARNING("You need at least two wood sheets to swap the metal parts of [src]."))

/obj/item/frame/table/attack_self(mob/user)

	if(istype(get_area(loc), /area/shuttle))  //HANGAR/SHUTTLE BUILDING
		to_chat(user, SPAN_WARNING("No. This area is needed for the dropship."))
		return

	if(!do_after(user, SECONDS_3, INTERRUPT_ALL, BUSY_ICON_BUILD))
		to_chat(user, SPAN_WARNING("Hold still while you're constructing a table!"))
		return

	var/obj/structure/table/T = new table_type(user.loc)
	T.add_fingerprint(user)
	user.drop_held_item()
	qdel(src)

/*
 * Reinforced Table Parts
 */

/obj/item/frame/table/reinforced
	name = "reinforced table parts"
	desc = "A kit for a table, including a large, flat metal surface and four legs. This kit has side panels. Some assembly required."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "reinf_tableparts"
	matter = list("metal" = 15000) //A reinforced table. Two sheets of metal and four rods
	table_type = /obj/structure/table/reinforced

/obj/item/frame/table/reinforced/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/tool/wrench))
		new /obj/item/stack/sheet/metal(get_turf(src))
		new /obj/item/stack/rods(get_turf(src))
		qdel(src)

/*
 * Wooden Table Parts
 */

/obj/item/frame/table/wood
	name = "wooden table parts"
	desc = "A kit for a table, including a large, flat wooden surface and four legs. Some assembly required."
	icon_state = "wood_tableparts"
	flags_atom = FPRINT
	table_type = /obj/structure/table/woodentable

/obj/item/frame/table/wood/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/tool/wrench))
		new /obj/item/stack/sheet/wood(get_turf(src))
		qdel(src)

	if(istype(W, /obj/item/stack/tile/carpet) && table_type == /obj/structure/table/woodentable)
		var/obj/item/stack/tile/carpet/C = W
		if(C.use(1))
			to_chat(user, SPAN_NOTICE("You put a layer of carpet on [src]."))
			new /obj/item/frame/table/gambling(get_turf(src))
			qdel(src)

/obj/item/frame/table/wood/poor
	name = "poor wooden table parts"
	desc = "A kit for a poorly crafted table, including a large, flat wooden surface and four legs. Some assembly required."
	icon_state = "pwood_tableparts"
	table_type = /obj/structure/table/woodentable/poor

/obj/item/frame/table/wood/fancy
	name = "fancy wooden table parts"
	desc = "A kit for a finely crafted mahogany table, including a large, flat wooden surface and four legs. Some assembly required."
	icon_state = "fwood_tableparts"
	table_type = /obj/structure/table/woodentable/fancy

/*
 * Gambling Table Parts
 */

/obj/item/frame/table/gambling
	name = "gamble table parts"
	desc = "A kit for a table, including a large, flat wooden and carpet surface and four legs. Some assembly required."
	icon_state = "gamble_tableparts"
	flags_atom = null
	table_type = /obj/structure/table/gamblingtable

/obj/item/frame/table/gambling/attackby(obj/item/W as obj, mob/user as mob)

	if(istype(W, /obj/item/tool/wrench))
		new /obj/item/stack/sheet/wood(get_turf(src))
		new /obj/item/stack/tile/carpet(get_turf(src))
		qdel(src)

	if(istype(W, /obj/item/tool/crowbar))
		to_chat(user, SPAN_NOTICE("You pry the carpet out of [src]."))
		new /obj/item/stack/tile/carpet(get_turf(src))
		new /obj/item/frame/table/wood(get_turf(src))
		qdel(src)

/*
 * Almayer Tables
 */
/obj/item/frame/table/almayer
	name = "gray table parts"
	icon_state = "table_parts"
	table_type = /obj/structure/table/almayer



/*
 * Rack Parts
 */

/obj/item/frame/rack
	name = "rack parts"
	desc = "A kit for a storage rack with multiple metal shelves. Relatively cheap, useful for mass storage. Some assembly required."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "rack_parts"
	flags_atom = FPRINT|CONDUCT
	matter = list("metal" = 3750) //A big storage shelf, takes five sheets to build

/obj/item/frame/rack/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/tool/wrench))
		new /obj/item/stack/sheet/metal(get_turf(src))
		qdel(src)

/obj/item/frame/rack/attack_self(mob/user as mob)

	if(istype(get_area(loc), /area/shuttle))  //HANGAR/SHUTTLE BUILDING
		to_chat(user, SPAN_WARNING("No. This area is needed for the dropship."))
		return

	if(locate(/obj/structure/table) in user.loc || locate(/obj/structure/barricade) in user.loc)
		to_chat(user, SPAN_WARNING("There is already a structure here."))
		return

	if(locate(/obj/structure/rack) in user.loc)
		to_chat(user, SPAN_WARNING("There already is a rack here."))
		return

	var/obj/structure/rack/R = new /obj/structure/rack(user.loc)
	R.add_fingerprint(user)
	user.drop_held_item()
	qdel(src)
