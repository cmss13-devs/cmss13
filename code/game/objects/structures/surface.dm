//Surface structures are structures that can have items placed on them
/obj/structure/surface
	health = 100
	var/list/update_types = list(
		/obj/item/reagent_container/glass,
		/obj/item/storage,
		/obj/item/reagent_container/food/snacks
	)

/obj/structure/surface/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/surface/LateInitialize()
	attach_all()
	update_icon()

/obj/structure/surface/Destroy()
	detach_all()
	. = ..()

/obj/structure/surface/ex_act(severity, direction)
	health -= severity
	if(health <= 0)
		var/location = get_turf(src)
		handle_debris(severity, direction)
		detach_all()
		for(var/obj/item/O in loc)
			O.explosion_throw(severity, direction)
		qdel(src)
		if(prob(66))
			create_shrapnel(location, rand(1,4), direction, , /datum/ammo/bullet/shrapnel/light)
		return TRUE

/obj/structure/surface/proc/attach_all()
	for(var/obj/item/O in loc)
		attach_item(O, FALSE)
	draw_item_overlays()

/obj/structure/surface/proc/attach_item(var/obj/item/O, var/update = TRUE)
	if(!O)
		return
	if(O.luminosity) //it can't make light as an overlay
		return
	O.forceMove(src)
	RegisterSignal(O, COMSIG_ATOM_DECORATED, .proc/decorate_update)
	if(update)
		draw_item_overlays()

/obj/structure/surface/proc/detach_item(var/obj/item/O)
	O.pixel_x = initial(O.pixel_x)
	O.pixel_y = initial(O.pixel_y)
	UnregisterSignal(O, COMSIG_ATOM_DECORATED)
	draw_item_overlays()
	return

/obj/structure/surface/proc/decorate_update(obj/item/O)
	SIGNAL_HANDLER
	draw_item_overlays()

/obj/structure/surface/proc/detach_all()
	overlays.Cut()
	for(var/obj/item/O in contents)
		UnregisterSignal(O, COMSIG_ATOM_DECORATED)
		O.forceMove(loc)

/obj/structure/surface/proc/get_item(var/list/click_data)
	var/i = LAZYLEN(contents)
	if(!click_data)
		return
	if(i < 1)
		return FALSE
	for(i, i >= 1, i--)//starting from the end because that's where the topmost is
		var/obj/item/O = contents[i]
		var/bounds_x = text2num(click_data["icon-x"])-1 - O.pixel_x
		var/bounds_y = text2num(click_data["icon-y"])-1 - O.pixel_y
		if(bounds_x < 0 || bounds_y < 0)
			continue
		var/icon/I = icon(O.icon, O.icon_state)
		var/p = I.GetPixel(bounds_x, bounds_y)
		if(p)
			return O
	return FALSE

/obj/structure/surface/proc/draw_item_overlays()
    overlays.Cut()
    for(var/obj/item/O in contents)
        var/image/I = image(O.icon) 
        I.appearance = O.appearance
        I.appearance_flags = RESET_COLOR
        I.overlays = O.overlays
        LAZYADD(overlays, I)

/obj/structure/surface/clicked(var/mob/user, var/list/mods)
	if(mods["shift"] && !mods["middle"])
		var/obj/item/O = get_item(mods)
		if(!O)
			return ..()
		if(O.can_examine(user))
			O.examine(user)
		return TRUE
	if(mods["alt"])
		var/turf/T = get_turf(src)
		if(T && user.TurfAdjacent(T) && LAZYLEN(T.contents))
			user.tile_contents = contents.Copy()
			LAZYADD(user.tile_contents, T.contents.Copy())
			LAZYADD(user.tile_contents, T)

			for(var/atom/A in user.tile_contents)
				if (A.invisibility > user.see_invisible)
					LAZYREMOVE(user.tile_contents, A)

			if(LAZYLEN(user.tile_contents))
				user.tile_contents_change = TRUE
		return TRUE
	..()

/obj/structure/surface/proc/try_to_open_container(var/mob/user, mods)
	if(!Adjacent(user))
		return

	if(ishuman(user) || isrobot(user))
		var/obj/item/O = get_item(mods)
		if(O && isstorage(O))
			var/obj/item/storage/S = O
			S.open(usr)
			return TRUE

/obj/structure/surface/attack_hand(mob/user, click_data)
	. = ..()
	var/obj/item/O = get_item(click_data)
	if(!O)
		return
	O.attack_hand(user)
	if(!LAZYISIN(contents, O))//in case attack_hand did not pick up the item
		detach_item(O)

/obj/structure/surface/attackby(obj/item/W, mob/user, click_data)
	var/obj/item/O = get_item(click_data)
	if(!O || click_data["ctrl"])//holding the ALT key will force it to place the object
		// Placing stuff on tables
		if(user.drop_inv_item_to_loc(W, loc))
			auto_align(W, click_data)
			return TRUE
	else if(!O.attackby(W, user))
		W.afterattack(O, user, TRUE)
	for(var/type in update_types)
		if(istype(O, type))
			draw_item_overlays()

/obj/structure/surface/proc/auto_align(obj/item/W, click_data)
	if(!W.center_of_mass) // Clothing, material stacks, generally items with large sprites where exact placement would be unhandy.
		W.pixel_x = rand(-W.randpixel, W.randpixel)
		W.pixel_y = rand(-W.randpixel, W.randpixel)
		W.pixel_z = 0
		return

	if(!click_data)
		return

	if(!click_data["icon-x"] || !click_data["icon-y"])
		return

	// Calculation to apply new pixelshift.
	var/mouse_x = text2num(click_data["icon-x"])-1 // Ranging from 0 to 31
	var/mouse_y = text2num(click_data["icon-y"])-1

	var/cell_x = Clamp(round(mouse_x/CELLSIZE), 0, CELLS-1) // Ranging from 0 to CELLS-1
	var/cell_y = Clamp(round(mouse_y/CELLSIZE), 0, CELLS-1)

	var/list/center = cached_key_number_decode(W.center_of_mass)

	W.pixel_x = (CELLSIZE * (cell_x + 0.5)) - center["x"]
	W.pixel_y = (CELLSIZE * (cell_y + 0.5)) - center["y"]
	W.pixel_z = 0
	attach_item(W)

/obj/structure/surface/MouseDrop(atom/over)
	. = ..()
	if(over == usr && usr && usr.client && usr.client.lmb_last_mousedown_mods)
		return try_to_open_container(usr, usr.client.lmb_last_mousedown_mods)
