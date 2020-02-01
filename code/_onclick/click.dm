
// 1 decisecond click delay (above and beyond mob/next_move)
/mob/var/next_click = 0
/*
	client/Click is called every time a client clicks anywhere, it should never be overridden.

	For all mobs that should have a specific click function and/or a modified click function
	(modified means click+shift, click+ctrl, etc.) add a custom mob/click() proc.

	For anything being clicked by a mob that should have a specific or modified click function,
	add a custom atom/clicked() proc.

	For both click() and clicked(), make sure they return 1 if the click is resolved,
	if not, return 0 to perform regular click functions like picking up items off the ground.
	~ BMC777
*/

/client/Click(atom/A, location, control, params)
	if (control)	// No .click macros allowed
		return usr.do_click(A, location, params)

/mob/proc/do_click(atom/A, location, params)
	// No clicking on atoms with the NOINTERACT flag
	if ((A.flags_atom & NOINTERACT))
		if (istype(A, /obj/screen/click_catcher))
			var/list/mods = params2list(params)
			var/turf/TU = params2turf(mods["screen-loc"], get_turf(usr.client ? usr.client.eye : usr), usr.client)
			if (TU)
				do_click(TU, location, params)
		return

	if (world.time <= next_click)
		return

	next_click = world.time + 1
	var/list/mods = params2list(params)

	if (!clicked_something)
		clicked_something = list("" = null)

	for (var/mod in mods)
		clicked_something[mod] = TRUE

	// Don't allow any other clicks while dragging something
	if (mods["drag"])
		return

	if (client.buildmode)
		if (istype(A, /obj/effect/bmode))
			A.clicked(src, mods)
			return

		build_click(src, client.buildmode, mods, A)
		return

	// Click handled elsewhere. (These clicks are not affected by the next_move cooldown)
	if (click(A, mods) | A.clicked(src, mods, location, params))
		return

	// Default click functions from here on.

	if (is_mob_incapacitated(TRUE))
		return

	face_atom(A)

	// Special type of click.
	if (is_mob_restrained())
		RestrainedClickOn(A)
		return

	// Throwing stuff.
	if (throw_mode)
		throw_item(A)
		return

	// Last thing clicked is tracked for something somewhere.
	if(!istype(A,/obj/item/weapon/gun) && !isturf(A) && !istype(A,/obj/screen))
		last_target_click = world.time

	var/obj/item/W = get_active_hand()

	// Special gun mode stuff.
	if (W == A)
		mode()
		return


	if (A == src && client && client.prefs && client.prefs.toggle_prefs & TOGGLE_IGNORE_SELF && src.a_intent != "help" && (!W || !(W.flags_item & (NOBLUDGEON|ITEM_ABSTRACT))))
		if (world.time % 3)
			to_chat(src, SPAN_NOTICE("You have the discipline not to hurt yourself."))
		return


	// Don't allow doing anything else if inside a container of some sort, like a locker.
	if (!isturf(loc))
		return

	if (world.time <= next_move)	// Attack click cooldown check
		return

	next_move = world.time
	// If standing next to the atom clicked.
	if (A.Adjacent(src))
		if (W)
			if (W.attack_speed)
				next_move += W.attack_speed
			if (!A.attackby(W, src, mods) && A && !A.disposed)
				// in case the attackby slept
				if(!W)
					next_move += 4
					UnarmedAttack(A, 1)
					return

				W.afterattack(A, src, 1, mods)
		else
			next_move += 4
			UnarmedAttack(A, 1)

		return

	// If not standing next to the atom clicked.
	if (W)
		W.afterattack(A, src, 0, mods)
		return

	RangedAttack(A, mods)
	return


/*	OLD DESCRIPTION
	Standard mob ClickOn()
	Handles exceptions: Buildmode, middle click, modified clicks, mech actions

	After that, mostly just check your state, check whether you're holding an item,
	check whether you're adjacent to the target, then pass off the click to whoever
	is recieving it.
	The most common are:
	* mob/UnarmedAttack(atom,adjacent) - used here only when adjacent, with no item in hand; in the case of humans, checks gloves
	* atom/attackby(item,user) - used only when adjacent
	* item/afterattack(atom,user,adjacent,params) - used both ranged and adjacent
	* mob/RangedAttack(atom,params) - used only ranged, only used for tk and laser eyes but could be changed
*/

/mob/proc/click(var/atom/A, var/list/mods)
	return FALSE

/atom/proc/clicked(var/mob/user, var/list/mods)
	if (mods["shift"] && !mods["middle"])
		if(user.client && user.client.eye == user)
			examine(user)
			user.face_atom(src)
		if(isAI(user))
			examine(user)
		return TRUE

	if (mods["alt"])
		var/turf/T = get_turf(src)
		if(T && user.TurfAdjacent(T) && T.contents.len)
			user.tile_contents = T.contents.Copy()

			var/atom/A
			for (A in user.tile_contents)
				if (A.invisibility > user.see_invisible)
					user.tile_contents -= A

			if (user.tile_contents.len)
				user.tile_contents_change = 1
		return TRUE
	return FALSE

/atom/movable/clicked(var/mob/user, var/list/mods)
	if (..())
		return TRUE

	if (mods["ctrl"])
		if (Adjacent(user))
			user.start_pulling(src)
		return TRUE
	return FALSE

/*
	Translates into attack_hand, etc.

	Note: proximity_flag here is used to distinguish between normal usage (flag=1),
	and usage when clicking on things telekinetically (flag=0).  This proc will
	not be called at ranged except with telekinesis.

	proximity_flag is not currently passed to attack_hand, and is instead used
	in human click code to allow glove touches only at melee range.
*/
/mob/proc/UnarmedAttack(var/atom/A, var/proximity_flag)
	return

/*
	Ranged unarmed attack:

	This currently is just a default for all mobs, involving
	laser eyes and telekinesis.  You could easily add exceptions
	for things like ranged glove touches, spitting alien acid/neurotoxin,
	animals lunging, etc.
*/
/mob/proc/RangedAttack(var/atom/A, var/params)
	return

/*
	Restrained ClickOn

	Used when you are handcuffed and click things.
	Not currently used by anything but could easily be.
*/
/mob/proc/RestrainedClickOn(var/atom/A)
	return

/*
	Misc helpers

	face_atom: turns the mob towards what you clicked on
*/

// Simple helper to face what you clicked on, in case it should be needed in more than one place
/mob/proc/face_atom(var/atom/A)

	if( !A || !x || !y || !A.x || !A.y ) return
	var/dx = A.x - x
	var/dy = A.y - y
	if(!dx && !dy) return

	var/direction
	if(abs(dx) < abs(dy))
		if(dy > 0)	direction = NORTH
		else		direction = SOUTH
	else
		if(dx > 0)	direction = EAST
		else		direction = WEST

	facedir(direction)






// click catcher stuff


/obj/screen/click_catcher
	icon = 'icons/mob/hud/screen1.dmi'
	icon_state = "catcher"
	layer = 0
	plane = -99
	mouse_opacity = 2
	screen_loc = "CENTER-7,CENTER-7"
	flags_atom = NOINTERACT


/obj/screen/click_catcher/proc/UpdateGreed(view_size_x = 15, view_size_y = 15)
	var/icon/newicon = icon('icons/mob/hud/screen1.dmi', "catcher")
	var/ox = min((33 * 32)/ world.icon_size, view_size_x)
	var/oy = min((33 * 32)/ world.icon_size, view_size_y)
	var/px = view_size_x * world.icon_size
	var/py = view_size_y * world.icon_size
	var/sx = min(33 * 32, px)
	var/sy = min(33 * 32, py)
	newicon.Scale(sx, sy)
	icon = newicon
	screen_loc = "CENTER-[(ox-1)*0.5],CENTER-[(oy-1)*0.5]"
	var/matrix/M = new
	M.Scale(px/sx, py/sy)
	apply_transform(M)



/client/proc/change_view(new_size)
	view = new_size
	apply_clickcatcher()
	mob.reload_fullscreens()

/client/proc/create_clickcatcher()
	if(!void)
		void = new()
	screen += void

/client/proc/apply_clickcatcher()
	create_clickcatcher()
	var/list/actual_view = getviewsize(view)
	void.UpdateGreed(actual_view[1],actual_view[2])

/proc/params2turf(scr_loc, turf/origin, client/C)
	if(!scr_loc || !origin || !istype(C))
		return
	var/tX = splittext(scr_loc, ",")
	var/tY = splittext(tX[2], ":")
	var/tZ = origin.z
	tY = tY[1]
	tX = splittext(tX[1], ":")
	tX = tX[1]
	var/shiftX = C.pixel_x / world.icon_size
	var/shiftY = C.pixel_y / world.icon_size
	var/list/actual_view = getviewsize(C ? C.view : world.view)
	tX = Clamp(origin.x + text2num(tX) + shiftX - round(actual_view[1] / 2) - 1, 1, world.maxx)
	tY = Clamp(origin.y + text2num(tY) + shiftY - round(actual_view[2] / 2) - 1, 1, world.maxy)
	return locate(tX, tY, tZ)


/proc/getviewsize(view)
	var/viewX
	var/viewY
	if(isnum(view))
		var/totalviewrange = 1 + 2 * view
		viewX = totalviewrange
		viewY = totalviewrange
	else
		var/list/viewrangelist = splittext(view,"x")
		viewX = text2num(viewrangelist[1])
		viewY = text2num(viewrangelist[2])
	return list(viewX, viewY)