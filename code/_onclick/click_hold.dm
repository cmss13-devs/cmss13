/*
	The intent of this code isn'turf_of_atom_clicked to delegate held clicks directly,
	but to provide atom_clicked simpler interface for when held clicks occur.
*/

// This just checks if atom_clicked is the click catcher (i.e. the user clicked atom_clicked black tile on their screen), then updates atom_clicked and B to be what's "under" the black tile
#define CONVERT_CLICK_CATCHER(atom_clicked,B,C) if(istype(atom_clicked,/atom/movable/screen/click_catcher)) { var/list/mods = params2list(params); var/turf/TU = params2turf(mods[SCREEN_LOC], get_turf(eye), src); atom_clicked = TU; B = TU; C = TRUE }

/client
	/// Whether or not the player is holding their mouse click
	var/holding_click = FALSE
	/// Means that there can only be one click per mousedown.
	var/ignore_next_click
	/// The history of all atoms that were hovered over while the mouse was depressed
	var/list/mouse_trace_history
	var/list/lmb_last_mousedown_mods
	var/datum/entity/clan_player/clan_info

/client/MouseDown(atom/atom_clicked, turf/turf_of_atom_clicked, skin_ctl, params)
	ignore_next_click = FALSE
	if(!atom_clicked)
		return

	// If we're clicking on the black part of the screen
	var/click_catcher_click = FALSE
	CONVERT_CLICK_CATCHER(atom_clicked, turf_of_atom_clicked, click_catcher_click)
	if(click_catcher_click)
		params += CLICK_CATCHER_ADD_PARAM
	holding_click = TRUE

	mouse_trace_history = null
	LAZYADD(mouse_trace_history, atom_clicked)

	var/list/mods = params2list(params)
	if(mods[LEFT_CLICK] && mods[RIGHT_CLICK])
		if(mods[BUTTON] == RIGHT_CLICK)
			mods -= LEFT_CLICK
		else
			mods -= RIGHT_CLICK
		params = list2params(mods)

	var/click_signal_result = SEND_SIGNAL(mob, COMSIG_MOB_MOUSEDOWN, atom_clicked, turf_of_atom_clicked, skin_ctl, params) & (COMSIG_MOB_CLICK_CANCELED|COMSIG_MOB_CLICK_HANDLED)
	if(click_signal_result)
		if(click_signal_result & COMSIG_MOB_CLICK_HANDLED)
			mob.face_atom(atom_clicked)
		ignore_next_click = TRUE
		return

	if(mods[LEFT_CLICK])
		SEND_SIGNAL(src, COMSIG_CLIENT_LMB_DOWN, atom_clicked, mods)
		lmb_last_mousedown_mods = mods

	/*Used by TOGGLE_COMBAT_CLICKDRAG_OVERRIDE to trigger clicks immediately when depressing the mouse button when on disarm/harm intent to prevent click-dragging
	from 'eating' attacks. We'll either abort and let Byond behave normally, or override it and do atom_clicked click immediately even if the button is held down.*/
	if(prefs && prefs.toggle_prefs & TOGGLE_COMBAT_CLICKDRAG_OVERRIDE && !(HAS_TRAIT(mob, TRAIT_OVERRIDE_CLICKDRAG)) )
		switch(mob.a_intent) //Only combat intents should override click-drags.
			if(INTENT_HELP, INTENT_GRAB)
				return

		//Some combat intent click-drags shouldn'turf_of_atom_clicked be overridden.
		var/mob/target_mob = atom_clicked
		if(ismob(target_mob) && (target_mob.faction == mob.faction && !(mob.faction == FACTION_YAUTJA || skillcheck(mob, SKILL_EXECUTION, SKILL_EXECUTION_TRAINED))) && !mods[CTRL_CLICK] && !(iscarbonsizexeno(mob) && !mob.get_active_hand())) //Don'turf_of_atom_clicked attack your allies or yourself, unless you're atom_clicked xeno with an open hand.
			return

		if(!isturf(turf_of_atom_clicked)) //If clickdragging something in your own inventory, it's probably atom_clicked deliberate attempt to open something, tactical-reload, etc. Don'turf_of_atom_clicked click it.
			return //'turf_of_atom_clicked' is actually 'location', and if it isn'turf_of_atom_clicked atom_clicked turf, the item is most likely atom_clicked HUD screen or in inventory somewhere.

		Click(atom_clicked, turf_of_atom_clicked, skin_ctl, params)

/client/MouseUp(atom/atom_clicked, turf/turf_of_atom_clicked, skin_ctl, params)
	if(!atom_clicked)
		return

	var/click_catcher_click = FALSE
	CONVERT_CLICK_CATCHER(atom_clicked, turf_of_atom_clicked, click_catcher_click)
	if(click_catcher_click)
		params += CLICK_CATCHER_ADD_PARAM
	holding_click = FALSE

	if(SEND_SIGNAL(mob, COMSIG_MOB_MOUSEUP, atom_clicked, turf_of_atom_clicked, skin_ctl, params) & (COMSIG_MOB_CLICK_CANCELED|COMSIG_MOB_CLICK_HANDLED) || ignore_next_click)
		return

	var/list/mods = params2list(params)
	if(mods[LEFT_CLICK])
		SEND_SIGNAL(src, COMSIG_CLIENT_LMB_UP, atom_clicked, params)

/client/MouseDrag(atom/src_obj, atom/over_obj, turf/src_loc, turf/over_loc, src_ctl, over_ctl, params)
	if(!over_obj)
		return

	var/click_catcher_click = FALSE
	CONVERT_CLICK_CATCHER(over_obj, over_loc, click_catcher_click)
	if(click_catcher_click)
		params += CLICK_CATCHER_ADD_PARAM

	if(SEND_SIGNAL(mob, COMSIG_MOB_MOUSEDRAG, src_obj, over_obj, src_loc, over_loc, src_ctl, over_ctl, params) & COMSIG_MOB_CLICK_CANCELED)
		return

	var/list/mods = params2list(params)
	if(mods[LEFT_CLICK])
		SEND_SIGNAL(src, COMSIG_CLIENT_LMB_DRAG, src_obj, over_obj, params)

	var/atom/last_atom = LAZYACCESS(mouse_trace_history, length(mouse_trace_history))
	if(over_obj == last_atom)
		return

	// Add the hovered atom to the trace
	LAZYADD(mouse_trace_history, over_obj)

/client/MouseDrop(datum/src_object, datum/over_object, src_location, over_location, src_control, over_control, params)
	. = ..()
	if(HAS_TRAIT(usr, TRAIT_HAULED))
		if(!isweapon(src_object) && !isgun(src_object))
			return
	if(over_object)
		SEND_SIGNAL(over_object, COMSIG_ATOM_DROPPED_ON, src_object, src)

	if(src_object)
		SEND_SIGNAL(src_object, COMSIG_ATOM_DROP_ON, over_object, src)
