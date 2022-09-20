/*
	The intent of this code isn't to delegate held clicks directly,
	but to provide a simpler interface for when held clicks occur.
*/

// This just checks if A is the click catcher (i.e. the user clicked a black tile on their screen), then updates A and B to be what's "under" the black tile
#define CONVERT_CLICK_CATCHER(A,B,C) if(istype(A,/atom/movable/screen/click_catcher)) { var/list/mods = params2list(params); var/turf/TU = params2turf(mods["screen-loc"], get_turf(eye), src); A = TU; B = TU; C = TRUE }

/client
	/// Whether or not the player is holding their mouse click
	var/holding_click = FALSE
	/// Means that there can only be one click per mousedown.
	var/ignore_next_click
	/// The history of all atoms that were hovered over while the mouse was depressed
	var/list/mouse_trace_history
	var/list/lmb_last_mousedown_mods

/client/MouseDown(var/atom/A, var/turf/T, var/skin_ctl, var/params)
	ignore_next_click = FALSE
	if(!A)
		return

	// If we're clicking on the black part of the screen
	var/click_catcher_click = FALSE
	CONVERT_CLICK_CATCHER(A, T, click_catcher_click)
	if(click_catcher_click)
		params += ";click_catcher=1"
	holding_click = TRUE

	mouse_trace_history = null
	LAZYADD(mouse_trace_history, A)

	var/list/mods = params2list(params)
	if(mods["left"])
		SEND_SIGNAL(src, COMSIG_CLIENT_LMB_DOWN, A, mods)
		lmb_last_mousedown_mods = mods

	/*Used by TOGGLE_COMBAT_CLICKDRAG_OVERRIDE to trigger clicks immediately when depressing the mouse button when on disarm/harm intent to prevent click-dragging
	from 'eating' attacks. We'll either abort and let Byond behave normally, or override it and do a click immediately even if the button is held down.*/
	if(prefs && prefs.toggle_prefs & TOGGLE_COMBAT_CLICKDRAG_OVERRIDE)
		switch(mob.a_intent) //Only combat intents should override click-drags.
			if(INTENT_HELP, INTENT_GRAB)
				return

		//Some combat intent click-drags shouldn't be overridden.
		var/mob/target_mob = A
		if(ismob(target_mob) && target_mob.faction == mob.faction && !mods["ctrl"] && !(isCarbonSizeXeno(mob) && !mob.get_active_hand())) //Don't attack your allies or yourself, unless you're a xeno with an open hand.
			return

		if(!isturf(T)) //If clickdragging something in your own inventory, it's probably a deliberate attempt to open something, tactical-reload, etc. Don't click it.
			return		//'T' is actually 'location', and if it isn't a turf, the item is most likely a HUD screen or in inventory somewhere.

		Click(A, T, skin_ctl, params)

/client/MouseUp(var/atom/A, var/turf/T, var/skin_ctl, var/params)
	if(!A)
		return

	var/click_catcher_click = FALSE
	CONVERT_CLICK_CATCHER(A, T, click_catcher_click)
	if(click_catcher_click)
		params += ";click_catcher=1"
	holding_click = FALSE

	var/list/mods = params2list(params)
	if(mods["left"])
		SEND_SIGNAL(src, COMSIG_CLIENT_LMB_UP, A, params)

/client/MouseDrag(var/atom/src_obj, var/atom/over_obj, var/turf/src_loc, var/turf/over_loc, var/src_ctl, var/over_ctl, var/params)
	if(!over_obj)
		return

	var/click_catcher_click = FALSE
	CONVERT_CLICK_CATCHER(over_obj, over_loc, click_catcher_click)
	if(click_catcher_click)
		params += ";click_catcher=1"

	var/list/mods = params2list(params)
	if(mods["left"])
		SEND_SIGNAL(src, COMSIG_CLIENT_LMB_DRAG, src_obj, over_obj, params)

	var/atom/last_atom = LAZYACCESS(mouse_trace_history, mouse_trace_history.len)
	if(over_obj == last_atom)
		return

	// Add the hovered atom to the trace
	LAZYADD(mouse_trace_history, over_obj)
