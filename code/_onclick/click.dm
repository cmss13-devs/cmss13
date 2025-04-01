// Enables a tool to test ingame click rate.
#define DEBUG_CLICK_RATE 0

/// 1 decisecond click delay (above and beyond mob/next_move)
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
	if (control && !ignore_next_click) // No .click macros allowed, and only one click per mousedown.
		ignore_next_click = TRUE
		return usr.do_click(A, location, params)

/mob/proc/do_click(atom/A, location, params)
	// We'll be sending a lot of signals and things later on, this will save time.
	if(!client)
		return
	// No clicking on atoms with the NOINTERACT flag
	if ((A.flags_atom & NOINTERACT))
		if (istype(A, /atom/movable/screen/click_catcher))
			var/list/mods = params2list(params)
			var/turf/TU = params2turf(mods[SCREEN_LOC], get_turf(client.eye), client)
			if (TU)
				params += CLICK_CATCHER_ADD_PARAM
				do_click(TU, location, params)
		return

	if (world.time < next_click)
		return

	next_click = world.time + 1 //Maximum code-permitted clickrate 10.26/s, practical maximum manual rate: 8.5, autoclicker maximum: between 7.2/s and 8.5/s.
	var/list/mods = params2list(params)

	if (!clicked_something)
		clicked_something = list("" = null)

	for (var/mod in mods)
		clicked_something[mod] = TRUE

	// Don't allow any other clicks while dragging something
	if(mods[DRAG])
		return

	if(SEND_SIGNAL(client, COMSIG_CLIENT_PRE_CLICK, A, mods) & COMPONENT_INTERRUPT_CLICK)
		return

	if(SEND_SIGNAL(src, COMSIG_MOB_PRE_CLICK, A, mods) & COMPONENT_INTERRUPT_CLICK)
		return

	if(istype(A, /obj/effect/statclick))
		A.clicked(src, mods)
		return

	if(client.click_intercept)
		if(istype(A, /atom/movable/screen/buildmode))
			A.clicked(src, mods)
			return

	if(check_click_intercept(params,A))
		return

	// Click handled elsewhere. (These clicks are not affected by the next_move cooldown)
	if(click(A, mods))
		return
	if(A.clicked(src, mods, location, params))
		return

	// Default click functions from here on.

	if (is_mob_incapacitated(TRUE))
		return

	face_atom(A)

	if(mods[MIDDLE_CLICK] || mods[BUTTON4] || mods[BUTTON5])
		return

	// Special type of click.
	if (is_mob_restrained())
		RestrainedClickOn(A)
		return

	// Throwing stuff, can't throw on inventory items nor screen objects nor items inside storages.
	if (throw_mode && A.loc != src && !isstorage(A.loc) && !istype(A, /atom/movable/screen))
		//if we're past the throw delay just throw, add the new delay time, and reset the buffer
		if(COOLDOWN_FINISHED(src, throw_delay))
			throw_item(A)
			COOLDOWN_START(src, throw_delay, THROW_DELAY)
			throw_buffer = 0
		//if we're still in the throw delay we check if the buffer is already used, if not then we throw the item and set the buffer as used
		else if(!throw_buffer)
			throw_item(A)
			throw_buffer++
		return

	var/obj/item/W = get_active_hand()

	// Special gun mode stuff.
	if(W == A)
		mode()
		return

	//Self-harm preference. isxeno check because xeno clicks on self are redirected to the turf below the pointer.
	if(A == src && client.prefs && client.prefs.toggle_prefs & TOGGLE_IGNORE_SELF && src.a_intent != INTENT_HELP && !isxeno(src))
		if(W)
			if(W.force && (!W || !(W.flags_item & (NOBLUDGEON|ITEM_ABSTRACT))))
				if(world.time % 3)
					to_chat(src, SPAN_NOTICE("You have the discipline not to hurt yourself."))
				return
		else
			if(world.time % 3)
				to_chat(src, SPAN_NOTICE("You have the discipline not to hurt yourself."))
			return


	// Don't allow doing anything else if inside a container of some sort, like a locker.
	if (!isturf(loc))
		return

	if (world.time <= next_move && A.loc != src) // Attack click cooldown check
		return

	next_move = world.time
	// If standing next to the atom clicked.
	if(A.Adjacent(src))
		click_adjacent(A, W, mods)
		return

	// If not standing next to the atom clicked.
	if(W)
		W.afterattack(A, src, 0, mods)
		return

	RangedAttack(A, mods)
	SEND_SIGNAL(src, COMSIG_MOB_POST_CLICK, A, mods)
	return

/mob/proc/click_adjacent(atom/targeted_atom, obj/item/used_item, mods)
	if(HAS_TRAIT(src, TRAIT_HAULED))
		if(!isstorage(targeted_atom) && !isclothing(targeted_atom) && !isweapon(targeted_atom) && !isgun(targeted_atom))
			return
	if(used_item)
		var/attackby_result = targeted_atom.attackby(used_item, src, mods)
		var/afterattack_result
		if(!QDELETED(targeted_atom) && !(attackby_result & ATTACKBY_HINT_NO_AFTERATTACK))
			// in case the attackby slept
			if(!used_item)
				if(!isitem(targeted_atom) && !issurface(targeted_atom))
					next_move += 4
				UnarmedAttack(targeted_atom, 1, mods)
				return

			afterattack_result = used_item.afterattack(targeted_atom, src, 1, mods)

		if(used_item.attack_speed && !src.contains(targeted_atom) && (attackby_result & ATTACKBY_HINT_UPDATE_NEXT_MOVE) || (afterattack_result & ATTACKBY_HINT_UPDATE_NEXT_MOVE) || (used_item.flags_item & ADJACENT_CLICK_DELAY))
			next_move += used_item.attack_speed
	else
		if(!isitem(targeted_atom) && !issurface(targeted_atom))
			next_move += 4
		UnarmedAttack(targeted_atom, 1, mods)

/mob/proc/check_click_intercept(params,A)
	//Client level intercept
	if(client?.click_intercept)
		if(call(client.click_intercept, "InterceptClickOn")(src, params, A))
			return TRUE

	//Mob level intercept
	if(click_intercept)
		if(call(click_intercept, "InterceptClickOn")(src, params, A))
			return TRUE

	return FALSE

/* OLD DESCRIPTION
	Standard mob ClickOn()
	Handles exceptions: Buildmode, middle click, modified clicks, mech actions

	After that, mostly just check your state, check whether you're holding an item,
	check whether you're adjacent to the target, then pass off the click to whoever
	is receiving it.
	The most common are:
	* mob/UnarmedAttack(atom,adjacent) - used here only when adjacent, with no item in hand; in the case of humans, checks gloves
	* atom/attackby(item,user) - used only when adjacent
	* item/afterattack(atom,user,adjacent,params) - used both ranged and adjacent
	* mob/RangedAttack(atom,params) - used only ranged, only used for tk and laser eyes but could be changed
*/

/*
	AI ClickOn()

	Note currently ai is_mob_restrained() returns 0 in all cases,
	therefore restrained code has been removed

	The AI can double click to move the camera (this was already true but is cleaner),
	or double click a mob to track them.

	Note that AI have no need for the adjacency proc, and so this proc is a lot cleaner.
*/

/mob/proc/click(atom/A, list/mods)
	if(!client || !client.remote_control)
		return FALSE

	if(mods[MIDDLE_CLICK])
		A.AIMiddleClick(src)
		return TRUE

	if(mods[SHIFT_CLICK])
		A.AIShiftClick(src)
		return TRUE

	if(mods[ALT_CLICK])
		A.AIAltClick(src)
		return TRUE

	if(mods[CTRL_CLICK])
		A.AICtrlClick(src)
		return TRUE

	if(world.time <= next_move)
		return TRUE

	A.attack_remote(src)
	return TRUE

/atom/proc/clicked(mob/user, list/mods)
	if (mods[SHIFT_CLICK] && !mods[MIDDLE_CLICK])
		if(can_examine(user))
			examine(user)
		return TRUE

	if (mods[ALT_CLICK])
		var/turf/T = get_turf(src)
		if(T && user.TurfAdjacent(T) && length(T.contents))
			user.set_listed_turf(T)

		return TRUE
	return FALSE

/atom/movable/clicked(mob/user, list/mods)
	if (..())
		return TRUE

	if (mods[CTRL_CLICK])
		if (Adjacent(user) && user.next_move < world.time)
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
/mob/proc/UnarmedAttack(atom/A, proximity_flag, click_parameters)
	if(!client || !client.remote_control)
		return FALSE
	A.attack_remote(src)

/*
	Ranged unarmed attack:

	This currently is just a default for all mobs, involving
	laser eyes and telekinesis.  You could easily add exceptions
	for things like ranged glove touches, spitting alien acid/neurotoxin,
	animals lunging, etc.
*/
/mob/proc/RangedAttack(atom/A, params)
	if(!client || !client.remote_control)
		return FALSE
	A.attack_remote(src)

/*
	Restrained ClickOn

	Used when you are handcuffed and click things.
	Not currently used by anything but could easily be.
*/
/mob/proc/RestrainedClickOn(atom/A)
	return

/*
	Misc helpers

	face_atom: turns the mob towards what you clicked on
*/

// Simple helper to face what you clicked on, in case it should be needed in more than one place
/mob/proc/face_atom(atom/A)

	if( !A || !x || !y || !A.x || !A.y )
		return
	var/dx = A.x - x
	var/dy = A.y - y
	if(!dx && !dy)
		return

	var/direction
	var/specific_direction
	if(abs(dx) < abs(dy))
		if(dy > 0)
			direction = NORTH
		else
			direction = SOUTH
		if(dx)
			if(dx > 0)
				specific_direction = direction|EAST
			else
				specific_direction = direction|WEST
	else
		if(dx > 0)
			direction = EAST
		else
			direction = WEST
		if(dy)
			if(dy > 0)
				specific_direction = direction|NORTH
			else
				specific_direction = direction|SOUTH
	if(!specific_direction)
		specific_direction = direction

	face_dir(direction, specific_direction)






// click catcher stuff


/atom/movable/screen/click_catcher
	icon = 'icons/mob/hud/screen1.dmi'
	icon_state = "catcher"
	layer = 0
	plane = -99
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	screen_loc = "CENTER-7,CENTER-7"
	flags_atom = NOINTERACT


/atom/movable/screen/click_catcher/proc/UpdateGreed(view_size_x = 15, view_size_y = 15)
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



/client/proc/change_view(new_size, atom/source)
	if(SEND_SIGNAL(mob, COMSIG_MOB_CHANGE_VIEW, new_size) & COMPONENT_OVERRIDE_VIEW)
		return TRUE
	view = mob.check_view_change(new_size, source)
	apply_clickcatcher()
	mob.reload_fullscreens()

	if(prefs.adaptive_zoom)
		INVOKE_ASYNC(src, PROC_REF(adaptive_zoom))
	else if(prefs.auto_fit_viewport)
		INVOKE_ASYNC(src, VERB_REF(fit_viewport))

/client/proc/get_adaptive_zoom_factor()
	if(!prefs.adaptive_zoom)
		return 0
	var/zoom = prefs.adaptive_zoom
	if(view <= 8)
		return zoom * 2
	else if(view <= 15)
		return zoom * 1
	else
		return 0

/// Attempts to scale client zoom automatically to fill 1080p multiples. Best used with auto fit viewport.
/client/proc/adaptive_zoom()
	var/icon_size = world.icon_size * get_adaptive_zoom_factor()
	winset(src, "mapwindow.map", "icon-size=[icon_size]")
	if(prefs.auto_fit_viewport)
		fit_viewport()

/client/proc/create_clickcatcher()
	if(!void)
		void = new()
	add_to_screen(void)

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
	var/list/actual_view = getviewsize(C ? C.view : GLOB.world_view_size)
	tX = clamp(origin.x + text2num(tX) + shiftX - floor(actual_view[1] / 2) - 1, 1, world.maxx)
	tY = clamp(origin.y + text2num(tY) + shiftY - floor(actual_view[2] / 2) - 1, 1, world.maxy)
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


#if DEBUG_CLICK_RATE
/obj/item/clickrate_test
	name = "clickrate tester"
	icon_state = "game_kit"
	var/started_testing
	var/clicks
	var/manual = FALSE //To test the maximum rate the code permits. Set to TRUE and to get actual ingame maximums.

/obj/item/clickrate_test/attack_self(mob/user)
	if(!started_testing)
		to_world(SPAN_DEBUG("Hadn't tested."))
		return
	var/test_time = (world.time - started_testing) * 0.1 //in seconds

	to_world(SPAN_DEBUG("We did <b>[clicks]</b> clicks over <b>[test_time]</b> seconds, for an average clicks-per-second of <b>[clicks / test_time]</b>."))
	started_testing = 0
	clicks = 0

/obj/item/clickrate_test/afterattack(atom/A, mob/living/user, flag, params)
	if(flag)
		to_world(SPAN_DEBUG("Too close, click something at range."))
		return
	if(!started_testing)
		started_testing = world.time
		if(!manual)
			autoclick(user, A, params)
	clicks++

/obj/item/clickrate_test/proc/autoclick(mob/user, atom/A, params)
	if(clicks >= 20)
		attack_self(user)
		return
	user.do_click(A, null, params)
	addtimer(CALLBACK(src, PROC_REF(autoclick), user, A, params), 0.1)
#endif
