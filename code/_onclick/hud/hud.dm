
/*
	The hud datum
	Used to show and hide huds for all the different mob types,
	including inventories and item quick actions.
*/

/datum/hud
	var/mob/mymob
	var/datum/custom_hud/ui_datum

	var/hud_version = HUD_STYLE_STANDARD	//the hud version used (standard, reduced, none)
	var/hud_shown = TRUE			//Used for the HUD toggle (F12)
	var/inventory_shown = TRUE		//the inventory
	var/show_intent_icons = 0
	var/hotkey_ui_hidden = 0	//This is to hide the buttons that can be used via hotkeys. (hotkeybuttons list of buttons)

	var/obj/screen/r_hand_hud_object
	var/obj/screen/l_hand_hud_object
	var/obj/screen/action_intent
	var/obj/screen/alien_plasma_display
	var/obj/screen/alien_armor_display
	var/obj/screen/locate_leader
	var/obj/screen/locate_nuke
	var/obj/screen/pred_power_icon

	var/obj/screen/frame_hud
	var/obj/screen/pulse_line

	var/obj/screen/slowed_icon
	var/obj/screen/bleeding_icon
	var/obj/screen/shrapnel_icon

	var/obj/screen/module_store_icon

	var/obj/screen/nutrition_icon

	var/obj/screen/use_attachment
	var/obj/screen/toggle_raillight
	var/obj/screen/eject_mag
	var/obj/screen/toggle_burst
	var/obj/screen/unique_action

	var/obj/screen/zone_sel
	var/obj/screen/pull_icon
	var/obj/screen/throw_icon
	var/obj/screen/oxygen_icon
	var/obj/screen/fire_icon
	var/obj/screen/healths
	var/obj/screen/bodytemp_icon

	var/obj/screen/gun_setting_icon
	var/obj/screen/gun_item_use_icon
	var/obj/screen/gun_move_icon
	var/obj/screen/gun_run_icon

	var/list/static_inventory = list() //the screen objects which are static
	var/list/toggleable_inventory = list() //the screen objects which can be hidden
	var/list/obj/screen/hotkeybuttons = list() //the buttons that can be used via hotkeys
	var/list/infodisplay = list() //the screen objects that display mob info (health, alien plasma, etc...)

	var/obj/screen/action_button/hide_toggle/hide_actions_toggle
	var/action_buttons_hidden = 0

	var/list/equip_slots = list()


/datum/hud/New(mob/owner)
	mymob = owner
	hide_actions_toggle = new

/datum/hud/Destroy()
	if(mymob.hud_used == src)
		mymob.hud_used = null
	if(static_inventory.len)
		for(var/thing in static_inventory)
			qdel(thing)
		static_inventory.Cut()
	if(toggleable_inventory.len)
		for(var/thing in toggleable_inventory)
			qdel(thing)
		toggleable_inventory.Cut()
	if(hotkeybuttons.len)
		for(var/thing in hotkeybuttons)
			qdel(thing)
		hotkeybuttons.Cut()
	if(infodisplay.len)
		for(var/thing in infodisplay)
			qdel(thing)
		infodisplay.Cut()

	qdel(hide_actions_toggle)
	hide_actions_toggle = null

	r_hand_hud_object = null
	l_hand_hud_object = null
	action_intent = null
	alien_plasma_display = null
	alien_armor_display = null
	locate_leader = null
	pred_power_icon = null

	module_store_icon = null

	frame_hud = null
	pulse_line = null

	slowed_icon = null
	shrapnel_icon = null
	bleeding_icon = null

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

	. = ..()


/mob/proc/create_hud()
	return


//Version denotes which style should be displayed. blank or 0 means "next version"
/datum/hud/proc/show_hud(version = 0)
	if(!ismob(mymob))
		return 0
	if(!mymob.client)
		return 0

	mymob.client.screen = list()
	mymob.client.apply_clickcatcher()

	var/display_hud_version = version
	if(!display_hud_version)	//If 0 or blank, display the next hud version
		display_hud_version = hud_version + 1
	if(display_hud_version > HUD_VERSIONS)	//If the requested version number is greater than the available versions, reset back to the first version
		display_hud_version = 1

	switch(display_hud_version)
		if(HUD_STYLE_STANDARD)	//Default HUD
			hud_shown = 1	//Governs behavior of other procs
			if(static_inventory.len)
				mymob.client.screen += static_inventory
			if(toggleable_inventory.len && inventory_shown)
				mymob.client.screen += toggleable_inventory
			if(hotkeybuttons.len && !hotkey_ui_hidden)
				mymob.client.screen += hotkeybuttons
			if(infodisplay.len)
				mymob.client.screen += infodisplay

		if(HUD_STYLE_REDUCED)	//Reduced HUD
			hud_shown = 0	//Governs behavior of other procs
			if(static_inventory.len)
				mymob.client.screen -= static_inventory
			if(toggleable_inventory.len)
				mymob.client.screen -= toggleable_inventory
			if(hotkeybuttons.len)
				mymob.client.screen -= hotkeybuttons
			if(infodisplay.len)
				mymob.client.screen += infodisplay

			//These ones are a part of 'static_inventory', 'toggleable_inventory' or 'hotkeybuttons' but we want them to stay
			if(l_hand_hud_object)
				mymob.client.screen += l_hand_hud_object	//we want the hands to be visible
			if(r_hand_hud_object)
				mymob.client.screen += r_hand_hud_object	//we want the hands to be visible
			if(action_intent)
				mymob.client.screen += action_intent		//we want the intent switcher visible

		if(HUD_STYLE_NOHUD)	//No HUD
			hud_shown = 0	//Governs behavior of other procs
			if(static_inventory.len)
				mymob.client.screen -= static_inventory
			if(toggleable_inventory.len)
				mymob.client.screen -= toggleable_inventory
			if(hotkeybuttons.len)
				mymob.client.screen -= hotkeybuttons
			if(infodisplay.len)
				mymob.client.screen -= infodisplay

	hud_version = display_hud_version
	persistant_inventory_update()
	mymob.update_action_buttons(TRUE)
	mymob.reload_fullscreens()



/datum/hud/human/show_hud(version = 0)
	..()
	hidden_inventory_update()

/datum/hud/proc/hidden_inventory_update()
	return

/datum/hud/proc/persistant_inventory_update()
	return

//Triggered when F12 is pressed (Unless someone changed something in the DMF)
/mob/verb/button_pressed_F12()
	set name = "F12"
	set hidden = 1

	if(hud_used && client)
		hud_used.show_hud()
		to_chat(usr, SPAN_INFO("Switched HUD mode. Press F12 to toggle."))
	else
		to_chat(usr, SPAN_WARNING("This mob type does not use a HUD."))


/datum/hud/proc/draw_act_intent(var/datum/custom_hud/ui_datum, var/ui_alpha)
	var/obj/screen/using = new /obj/screen/act_intent/corner()
	using.icon = ui_datum.ui_style_icon
	if(ui_alpha)
		using.alpha = ui_alpha
	using.icon_state = "intent_"+ intent_text(mymob.a_intent)
	using.screen_loc = ui_datum.ui_acti
	static_inventory += using
	action_intent = using

/datum/hud/proc/draw_drop(var/datum/custom_hud/ui_datum, var/ui_alpha, var/ui_color)
	var/obj/screen/using = new /obj/screen/drop()
	using.icon = ui_datum.ui_style_icon
	using.screen_loc = ui_datum.ui_drop_throw
	if(ui_alpha)
		using.alpha = ui_alpha
	if(ui_color)
		using.color = ui_color
	static_inventory += using

/datum/hud/proc/draw_throw(var/datum/custom_hud/ui_datum, var/ui_alpha, var/ui_color)
	throw_icon = new /obj/screen/throw_catch()
	throw_icon.icon = ui_datum.ui_style_icon
	throw_icon.screen_loc = ui_datum.ui_drop_throw
	if(ui_alpha)
		throw_icon.alpha = ui_alpha
	if(ui_color)
		throw_icon.color = ui_color
	hotkeybuttons += throw_icon

/datum/hud/proc/draw_pull(var/datum/custom_hud/ui_datum)
	pull_icon = new /obj/screen/pull()
	pull_icon.icon = ui_datum.ui_style_icon
	pull_icon.screen_loc = ui_datum.ui_pull
	pull_icon.update_icon(mymob)
	hotkeybuttons += pull_icon

/datum/hud/proc/draw_resist(var/datum/custom_hud/ui_datum, var/ui_alpha, var/ui_color)
	var/obj/screen/using = new /obj/screen/resist()
	using.icon = ui_datum.ui_style_icon
	using.screen_loc = ui_datum.ui_resist
	if(ui_alpha)
		using.alpha = ui_alpha
	if(ui_color)
		using.color = ui_color
	hotkeybuttons += using

/datum/hud/proc/draw_left_hand(var/datum/custom_hud/ui_datum, var/ui_alpha, var/ui_color)
	var/obj/screen/inventory/inv_box = new /obj/screen/inventory()
	inv_box.name = WEAR_L_HAND
	inv_box.icon = ui_datum.ui_style_icon
	inv_box.dir = EAST
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

/datum/hud/proc/draw_right_hand(var/datum/custom_hud/ui_datum, var/ui_alpha, var/ui_color)
	var/obj/screen/inventory/inv_box = new /obj/screen/inventory()
	inv_box.name = WEAR_R_HAND
	inv_box.icon = ui_datum.ui_style_icon
	inv_box.dir = WEST
	inv_box.screen_loc = ui_datum.ui_rhand
	inv_box.icon_state = "hand_inactive"
	if(mymob && !mymob.hand)	//This being 0 or null means the right hand is in use
		inv_box.icon_state = "hand_active"
	if(ui_alpha)
		inv_box.alpha = ui_alpha
	if(ui_color)
		inv_box.color = ui_color
	inv_box.layer = HUD_LAYER
	inv_box.slot_id = WEAR_R_HAND
	r_hand_hud_object = inv_box
	static_inventory += inv_box

/datum/hud/proc/draw_swaphand(var/handswap_part, var/handswap_part_loc, var/datum/custom_hud/ui_datum, var/ui_alpha, var/ui_color)
	var/obj/screen/using = new /obj/screen/inventory()
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

/datum/hud/proc/draw_healths(var/datum/custom_hud/ui_datum, var/ui_alpha)
	healths = new /obj/screen/healths()
	healths.icon = ui_datum.ui_style_icon
	healths.screen_loc = ui_datum.UI_HEALTH_LOC
	infodisplay += healths

/datum/hud/proc/draw_zone_sel(var/datum/custom_hud/ui_datum, var/ui_alpha, var/ui_color)
	zone_sel = new /obj/screen/zone_sel()
	zone_sel.icon = ui_datum.ui_style_icon
	zone_sel.screen_loc = ui_datum.ui_zonesel
	if(ui_alpha)
		zone_sel.alpha = ui_alpha
	if(ui_color)
		zone_sel.color = ui_color
	zone_sel.update_icon(mymob)
	static_inventory += zone_sel
