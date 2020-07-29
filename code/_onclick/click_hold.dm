/*
	The intent of this code isn't to delegate held clicks directly,
	but to provide a simpler interface for when held clicks occur.
*/

// This just checks if A is the click catcher (i.e. the user clicked a black tile on their screen), then updates A and B to be what's "under" the black tile
#define CONVERT_CLICK_CATCHER(A,B) if(istype(A,/obj/screen/click_catcher)) { var/list/mods = params2list(params); var/turf/TU = params2turf(mods["screen-loc"], get_turf(eye)); A = TU; B = TU }

/client
	// Whether or not the player is holding their mouse click
	var/holding_click = FALSE
	// The history of all atoms that were hovered over while the mouse was depressed
	var/list/mouse_trace_history

/client/MouseDown(var/atom/A, var/turf/T, var/skin_ctl, var/params)
	if(!A)
		return

	// If we're clicking on the black part of the screen
	CONVERT_CLICK_CATCHER(A, T)
	holding_click = TRUE

	mouse_trace_history = null
	LAZYADD(mouse_trace_history, A)

	var/list/mods = params2list(params)
	if(mods["left"])
		raiseEvent(src, EVENT_LMBDOWN, A, mods)

/client/MouseUp(var/atom/A, var/turf/T, var/skin_ctl, var/params)
	if(!A)
		return

	CONVERT_CLICK_CATCHER(A, T)
	holding_click = FALSE

	var/list/mods = params2list(params)
	if(mods["left"])
		raiseEvent(src, EVENT_LMBUP, A, params)

/client/MouseDrag(var/atom/src_obj, var/atom/over_obj, var/turf/src_loc, var/turf/over_loc, var/src_ctl, var/over_ctl, var/params)
	if(!over_obj)
		return

	CONVERT_CLICK_CATCHER(over_obj, over_loc)

	var/list/mods = params2list(params)
	if(mods["left"])
		raiseEvent(src, EVENT_LMBDRAG, src_obj, over_obj, params)

	var/atom/last_atom = LAZYACCESS(mouse_trace_history, mouse_trace_history.len)
	if(over_obj == last_atom)
		return

	// Add the hovered atom to the trace
	LAZYADD(mouse_trace_history, over_obj)
