
/*
	The hud datum
	Used to show and hide huds for all the different mob types,
	including inventories and item quick actions.
*/

/datum/hud
	var/mob/mymob
	var/datum/custom_hud/ui_datum

	var/hud_version = HUD_STYLE_STANDARD //the hud version used (standard, reduced, none)
	var/hud_shown = TRUE //Used for the HUD toggle (F12)
	var/inventory_shown = TRUE //the inventory
	var/show_intent_icons = 0
	var/hotkey_ui_hidden = 0 //This is to hide the buttons that can be used via hotkeys. (hotkeybuttons list of buttons)

	var/atom/movable/screen/r_hand_hud_object
	var/atom/movable/screen/l_hand_hud_object
	var/atom/movable/screen/action_intent
	var/atom/movable/screen/mov_intent/move_intent
	var/atom/movable/screen/alien_plasma_display
	var/atom/movable/screen/alien_armor_display
	var/atom/movable/screen/locate_leader
	var/atom/movable/screen/locate_marker
	var/atom/movable/screen/locate_nuke
	var/atom/movable/screen/pred_power_icon

	var/atom/movable/screen/frame_hud
	var/atom/movable/screen/pulse_line

	var/atom/movable/screen/slowed_icon
	var/atom/movable/screen/bleeding_icon
	var/atom/movable/screen/transfusion_icon
	var/atom/movable/screen/shrapnel_icon
	var/atom/movable/screen/tethering_icon
	var/atom/movable/screen/tethered_icon

	var/atom/movable/screen/module_store_icon

	var/atom/movable/screen/nutrition_icon

	var/atom/movable/screen/use_attachment
	var/atom/movable/screen/toggle_raillight
	var/atom/movable/screen/eject_mag
	var/atom/movable/screen/toggle_burst
	var/atom/movable/screen/unique_action

	var/atom/movable/screen/zone_sel/zone_sel
	var/atom/movable/screen/pull_icon
	var/atom/movable/screen/throw_icon
	var/atom/movable/screen/oxygen_icon
	var/atom/movable/screen/fire_icon
	var/atom/movable/screen/healths
	var/atom/movable/screen/bodytemp_icon

	var/atom/movable/screen/gun_setting_icon
	var/atom/movable/screen/gun_item_use_icon
	var/atom/movable/screen/gun_move_icon
	var/atom/movable/screen/gun_run_icon

	var/list/atom/movable/screen/plane_master/plane_masters = list() // see "appearance_flags" in the ref, assoc list of "[plane]" = object
	///Assoc list of controller groups, associated with key string group name with value of the plane master controller ref
	var/list/atom/movable/plane_master_controller/plane_master_controllers = list()

	var/list/static_inventory = list() //the screen objects which are static
	var/list/toggleable_inventory = list() //the screen objects which can be hidden
	var/list/atom/movable/screen/hotkeybuttons = list() //the buttons that can be used via hotkeys
	var/list/infodisplay = list() //the screen objects that display mob info (health, alien plasma, etc...)

	var/atom/movable/screen/action_button/hide_toggle/hide_actions_toggle
	var/action_buttons_hidden = 0

	var/list/equip_slots = list()


/datum/hud/New(mob/owner)
	mymob = owner
	hide_actions_toggle = new

	for(var/mytype in subtypesof(/atom/movable/screen/plane_master)- /atom/movable/screen/plane_master/rendering_plate)
		var/atom/movable/screen/plane_master/instance = new mytype()
		plane_masters["[instance.plane]"] = instance
		if(owner.client)
			instance.backdrop(mymob)

	for(var/mytype in subtypesof(/atom/movable/plane_master_controller))
		var/atom/movable/plane_master_controller/controller_instance = new mytype(null,src)
		plane_master_controllers[controller_instance.name] = controller_instance

/datum/hud/Destroy()
	if(mymob.hud_used == src)
		mymob.hud_used = null
	if(length(static_inventory))
		for(var/thing in static_inventory)
			qdel(thing)
		static_inventory.Cut()
	if(length(toggleable_inventory))
		for(var/thing in toggleable_inventory)
			qdel(thing)
		toggleable_inventory.Cut()
	if(length(hotkeybuttons))
		for(var/thing in hotkeybuttons)
			qdel(thing)
		hotkeybuttons.Cut()
	if(length(infodisplay))
		for(var/thing in infodisplay)
			qdel(thing)
		infodisplay.Cut()

	mymob = null
	qdel(hide_actions_toggle)
	hide_actions_toggle = null

	r_hand_hud_object = null
	l_hand_hud_object = null
	action_intent = null
	move_intent = null
	alien_plasma_display = null
	alien_armor_display = null
	locate_leader = null
	locate_marker = null
	pred_power_icon = null

	module_store_icon = null

	frame_hud = null
	pulse_line = null

	slowed_icon = null
	shrapnel_icon = null
	bleeding_icon = null
	transfusion_icon = null
	tethering_icon = null
	tethered_icon = null

	nutrition_icon = null

	use_attachment = null
	toggle_raillight = null
	eject_mag = null
	toggle_burst = null
	unique_action = null

	zone_sel = null
	pull_icon = null
	throw_icon = null
	oxygen_icon = null
	fire_icon = null
	healths = null
	bodytemp_icon = null

	gun_setting_icon = null
	gun_item_use_icon = null
	gun_move_icon = null
	gun_run_icon = null

	QDEL_LIST_ASSOC_VAL(plane_masters)
	QDEL_LIST_ASSOC_VAL(plane_master_controllers)

	return ..()


/mob/proc/create_hud()
	if(!hud_used)
		hud_used = new /datum/hud(src)


//Version denotes which style should be displayed. blank or 0 means "next version"
/datum/hud/proc/show_hud(version = 0, mob/viewmob)
	if(!ismob(mymob))
		return FALSE
// if(!mymob.client)
// return FALSE
	var/mob/screenmob = viewmob || mymob
	if(!screenmob.client)
		return FALSE

	screenmob.client.clear_screen()
	screenmob.client.apply_clickcatcher()

	var/display_hud_version = version
	if(!display_hud_version) //If 0 or blank, display the next hud version
		display_hud_version = hud_version + 1
	if(display_hud_version > HUD_VERSIONS) //If the requested version number is greater than the available versions, reset back to the first version
		display_hud_version = 1

	switch(display_hud_version)
		if(HUD_STYLE_STANDARD) //Default HUD
			hud_shown = 1 //Governs behavior of other procs
			if(length(static_inventory))
				screenmob.client.add_to_screen(static_inventory)
			if(length(toggleable_inventory) && inventory_shown)
				screenmob.client.add_to_screen(toggleable_inventory)
			if(length(hotkeybuttons) && !hotkey_ui_hidden)
				screenmob.client.add_to_screen(hotkeybuttons)
			if(length(infodisplay))
				screenmob.client.add_to_screen(infodisplay)

		if(HUD_STYLE_REDUCED) //Reduced HUD
			hud_shown = 0 //Governs behavior of other procs
			if(length(static_inventory))
				screenmob.client.remove_from_screen(static_inventory)
			if(length(toggleable_inventory))
				screenmob.client.remove_from_screen(toggleable_inventory)
			if(length(hotkeybuttons))
				screenmob.client.remove_from_screen(hotkeybuttons)
			if(length(infodisplay))
				screenmob.client.add_to_screen(infodisplay)

			//These ones are a part of 'static_inventory', 'toggleable_inventory' or 'hotkeybuttons' but we want them to stay
			if(l_hand_hud_object)
				screenmob.client.add_to_screen(l_hand_hud_object) //we want the hands to be visible
			if(r_hand_hud_object)
				screenmob.client.add_to_screen(r_hand_hud_object) //we want the hands to be visible
			if(action_intent)
				screenmob.client.add_to_screen(action_intent) //we want the intent switcher visible

		if(HUD_STYLE_NOHUD) //No HUD
			hud_shown = 0 //Governs behavior of other procs
			if(length(static_inventory))
				screenmob.client.remove_from_screen(static_inventory)
			if(length(toggleable_inventory))
				screenmob.client.remove_from_screen(toggleable_inventory)
			if(length(hotkeybuttons))
				screenmob.client.remove_from_screen(hotkeybuttons)
			if(length(infodisplay))
				screenmob.client.remove_from_screen(infodisplay)

	hud_version = display_hud_version
	persistent_inventory_update(screenmob)
	mymob.update_action_buttons(TRUE)
	reorganize_alerts(screenmob)
	mymob.reload_fullscreens()

	// ensure observers get an accurate and up-to-date view
	if(!viewmob)
		plane_masters_update()
		for(var/M in mymob.observers)
			show_hud(hud_version, M)
	else if(viewmob.hud_used)
		viewmob.hud_used.plane_masters_update()

	return TRUE

/datum/hud/proc/plane_masters_update()
	// Plane masters are always shown to OUR mob, never to observers
	for(var/thing in plane_masters)
		var/atom/movable/screen/plane_master/PM = plane_masters[thing]
		PM.backdrop(mymob)
		mymob.client.add_to_screen(PM)

/datum/hud/human/show_hud(version = 0, mob/viewmob)
	. = ..()
	if(!.)
		return
	var/mob/screenmob = viewmob || mymob
	if(!screenmob.client)
		return FALSE
	hidden_inventory_update(screenmob)

/datum/hud/proc/hidden_inventory_update()
	return

/datum/hud/proc/persistent_inventory_update()
	return

//Triggered when F12 is pressed (Unless someone changed something in the DMF)
/mob/verb/button_pressed_F12()
	set name = "F12"
	set hidden = TRUE

	if(hud_used && client)
		hud_used.show_hud()
		to_chat(usr, SPAN_INFO("Switched HUD mode. Press F12 to toggle."))
	else
		to_chat(usr, SPAN_WARNING("This mob type does not use a HUD."))


/datum/hud/proc/draw_act_intent(datum/custom_hud/ui_datum, ui_alpha)
	var/atom/movable/screen/using = new /atom/movable/screen/act_intent/corner()
	using.icon = ui_datum.ui_style_icon
	if(ui_alpha)
		using.alpha = ui_alpha
	using.icon_state = "intent_"+ intent_text(mymob.a_intent)
	using.screen_loc = ui_datum.ui_acti
	static_inventory += using
	action_intent = using

/datum/hud/proc/draw_mov_intent(datum/custom_hud/ui_datum, ui_alpha, ui_color)
	var/atom/movable/screen/using = new /atom/movable/screen/mov_intent()
	using.icon = ui_datum.ui_style_icon
	using.screen_loc = ui_datum.ui_movi
	if(ui_alpha)
		using.alpha = ui_alpha
	if(ui_color)
		using.color = ui_color
	using.icon_state = (mymob.m_intent == MOVE_INTENT_RUN ? "running" : "walking")
	static_inventory += using
	move_intent = using

/datum/hud/proc/draw_drop(datum/custom_hud/ui_datum, ui_alpha, ui_color)
	var/atom/movable/screen/using = new /atom/movable/screen/drop()
	using.icon = ui_datum.ui_style_icon
	using.screen_loc = ui_datum.ui_drop_throw
	if(ui_alpha)
		using.alpha = ui_alpha
	if(ui_color)
		using.color = ui_color
	static_inventory += using

/datum/hud/proc/draw_throw(datum/custom_hud/ui_datum, ui_alpha, ui_color)
	throw_icon = new /atom/movable/screen/throw_catch()
	throw_icon.icon = ui_datum.ui_style_icon
	throw_icon.screen_loc = ui_datum.ui_drop_throw
	if(ui_alpha)
		throw_icon.alpha = ui_alpha
	if(ui_color)
		throw_icon.color = ui_color
	hotkeybuttons += throw_icon

/datum/hud/proc/draw_pull(datum/custom_hud/ui_datum)
	pull_icon = new /atom/movable/screen/pull()
	pull_icon.icon = ui_datum.ui_style_icon
	pull_icon.screen_loc = ui_datum.ui_pull
	pull_icon.update_icon(mymob)
	hotkeybuttons += pull_icon

/datum/hud/proc/draw_resist(datum/custom_hud/ui_datum, ui_alpha, ui_color)
	var/atom/movable/screen/using = new /atom/movable/screen/resist()
	using.icon = ui_datum.ui_style_icon
	using.screen_loc = ui_datum.ui_resist
	if(ui_alpha)
		using.alpha = ui_alpha
	if(ui_color)
		using.color = ui_color
	hotkeybuttons += using

/datum/hud/proc/draw_left_hand(datum/custom_hud/ui_datum, ui_alpha, ui_color)
	var/atom/movable/screen/inventory/inv_box = new /atom/movable/screen/inventory()
	inv_box.name = WEAR_L_HAND
	inv_box.icon = ui_datum.ui_style_icon
	inv_box.setDir(EAST)
	inv_box.screen_loc = ui_datum.ui_lhand
	inv_box.icon_state = "hand_inactive"
	if(mymob && mymob.hand)
		inv_box.icon_state = "hand_active"
	if(ui_alpha)
		inv_box.alpha = ui_alpha
	if(ui_color)
		inv_box.color = ui_color
	inv_box.layer = HUD_LAYER
	inv_box.slot_id = WEAR_L_HAND
	l_hand_hud_object = inv_box
	static_inventory += inv_box

/datum/hud/proc/draw_right_hand(datum/custom_hud/ui_datum, ui_alpha, ui_color)
	var/atom/movable/screen/inventory/inv_box = new /atom/movable/screen/inventory()
	inv_box.name = WEAR_R_HAND
	inv_box.icon = ui_datum.ui_style_icon
	inv_box.setDir(WEST)
	inv_box.screen_loc = ui_datum.ui_rhand
	inv_box.icon_state = "hand_inactive"
	if(mymob && !mymob.hand) //This being 0 or null means the right hand is in use
		inv_box.icon_state = "hand_active"
	if(ui_alpha)
		inv_box.alpha = ui_alpha
	if(ui_color)
		inv_box.color = ui_color
	inv_box.layer = HUD_LAYER
	inv_box.slot_id = WEAR_R_HAND
	r_hand_hud_object = inv_box
	static_inventory += inv_box

/datum/hud/proc/draw_swaphand(handswap_part, handswap_part_loc, datum/custom_hud/ui_datum, ui_alpha, ui_color)
	var/atom/movable/screen/using = new /atom/movable/screen/inventory()
	using.name = "hand"
	using.icon = ui_datum.ui_style_icon
	using.icon_state = handswap_part
	using.screen_loc = handswap_part_loc
	if(ui_alpha)
		using.alpha = ui_alpha
	if(ui_color)
		using.color = ui_color
	using.layer = HUD_LAYER
	static_inventory += using

/datum/hud/proc/draw_healths(datum/custom_hud/ui_datum, ui_alpha)
	healths = new /atom/movable/screen/healths()
	healths.icon = ui_datum.ui_style_icon
	healths.screen_loc = ui_datum.UI_HEALTH_LOC
	infodisplay += healths

/datum/hud/proc/draw_zone_sel(datum/custom_hud/ui_datum, ui_alpha, ui_color)
	zone_sel = new /atom/movable/screen/zone_sel()
	zone_sel.icon = ui_datum.ui_style_icon
	zone_sel.screen_loc = ui_datum.ui_zonesel
	if(ui_alpha)
		zone_sel.alpha = ui_alpha
	if(ui_color)
		zone_sel.color = ui_color
	zone_sel.update_icon(mymob)
	static_inventory += zone_sel

// Re-render all alerts - also called in /datum/hud/show_hud() because it's needed there
/datum/hud/proc/reorganize_alerts(mob/viewmob)
	var/mob/screenmob = viewmob || mymob
	if(!screenmob.client)
		return
	var/list/alerts = mymob.alerts
	if(!length(alerts))
		return FALSE
	if(!hud_shown)
		for(var/category in alerts)
			var/atom/movable/screen/alert/alert = alerts[category]
			screenmob.client.remove_from_screen(alert)
		return TRUE
	var/c = 0
	for(var/category in alerts)
		var/atom/movable/screen/alert/alert = alerts[category]
		c++
		switch(c)
			if(1)
				. = ui_alert1
			if(2)
				. = ui_alert2
			if(3)
				. = ui_alert3
			if(4)
				. = ui_alert4
			if(5)
				. = ui_alert5 // Right now there's 5 slots
			else
				. = ""
		alert.screen_loc = .
		screenmob.client.add_to_screen(alert)
	if(!viewmob)
		for(var/obs in mymob.observers)
			reorganize_alerts(obs)
	return TRUE

/// Wrapper for adding anything to a client's screen
/client/proc/add_to_screen(screen_add)
	screen += screen_add
	SEND_SIGNAL(src, COMSIG_CLIENT_SCREEN_ADD, screen_add)

/// Wrapper for removing anything from a client's screen
/client/proc/remove_from_screen(screen_remove)
	screen -= screen_remove
	SEND_SIGNAL(src, COMSIG_CLIENT_SCREEN_REMOVE, screen_remove)
