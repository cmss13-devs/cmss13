/*
	Screen objects

	Screen objects are only used for the hud and should not appear anywhere "in-game".
	They are used with the client/screen list and the screen_loc var.
	For more information, see the byond documentation on the screen_loc and screen vars.
*/

/atom/movable/screen/text
	icon = null
	icon_state = null
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = CINEMATIC_PLANE
	layer = CINEMATIC_LAYER
	maptext_height = 480
	maptext_width = 480
	appearance_flags = NO_CLIENT_COLOR|PIXEL_SCALE

/atom/movable/screen/cinematic
	plane = CINEMATIC_PLANE
	layer = CINEMATIC_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	screen_loc = "1,0"

/atom/movable/screen/cinematic/explosion
	icon = 'icons/effects/station_explosion.dmi'
	icon_state = "intro_ship"

/atom/movable/screen/inventory
	var/slot_id
	//The indentifier for the slot. It has nothing to do with ID cards.
	var/icon_empty
	/// Icon when contains an item. For now used only by humans.
	var/icon_full
	/// The overlay when hovering over with an item in your hand

/atom/movable/screen/inventory/Initialize(mapload, ...)
	. = ..()

	RegisterSignal(src, COMSIG_ATOM_DROPPED_ON, PROC_REF(handle_dropped_on))

/atom/movable/screen/inventory/MouseEntered()
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	add_stored_outline()

/atom/movable/screen/inventory/MouseExited()
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	remove_stored_outline()

/atom/movable/screen/inventory/proc/add_stored_outline()
	// if(!slot_id || !usr.client.prefs.outline_enabled)
	// 	return
	var/obj/item/inv_item = usr.get_item_by_slot(slot_id)
	if(!inv_item)
		return
	if(usr.is_mob_incapacitated())
		inv_item.apply_outline(COLOR_RED_GRAY)
	else
		inv_item.apply_outline()

/atom/movable/screen/inventory/proc/remove_stored_outline()
	if(!slot_id)
		return
	var/obj/item/inv_item = usr.get_item_by_slot(slot_id)
	if(!inv_item)
		return
	inv_item.remove_outline()

/atom/movable/proc/remove_outline()
	usr.client.images -= usr.client.outlined_item[src]
	usr.client.outlined_item -= src

/client/var/list/image/outlined_item = list()

/atom/movable/proc/apply_outline(color)
	// if(anchored || !usr.client.prefs.outline_enabled)
	// 	return
	// if(!color)
	// 	color = usr.client.prefs.outline_color || COLOR_BLUE_LIGHT
	if(anchored)
		return
	if(!color)
		color = COLOR_HUD_BLUE
	if(usr.client.outlined_item[src])
		return

	if(usr.client.outlined_item.len)
		remove_outline()

	var/image/IMG = image(null, src, layer = layer, pixel_x = -pixel_x, pixel_y = -pixel_y)
	IMG.appearance_flags |= KEEP_TOGETHER | RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	IMG.vis_contents += src

	IMG.filters += filter(type = "outline", size = 1, color = color)
	usr.client.images |= IMG
	usr.client.outlined_item[src] = IMG

/atom/movable/screen/inventory/update_icon()
	if(!icon_empty)
		icon_empty = icon_state

	if(hud?.mymob && slot_id && icon_full)
		icon_state = hud.mymob.get_item_by_slot(slot_id) ? icon_full : icon_empty
	return ..()

/atom/movable/screen/close
	name = "close"
	icon_state = "close"

/atom/movable/screen/close/clicked(mob/user)
	if(isobserver(user))
		return TRUE
	if(master)
		if(isstorage(master))
			var/obj/item/storage/master_storage = master
			master_storage.storage_close(user)
	return TRUE

/atom/movable/screen/action_button
	icon = 'icons/mob/hud/actions.dmi'
	icon_state = "template"
	plane = ABOVE_TACMAP_PLANE
	var/datum/action/source_action
	var/image/maptext_overlay

/atom/movable/screen/action_button/attack_ghost(mob/dead/observer/user)
	return

/atom/movable/screen/action_button/clicked(mob/user, list/mods)
	if(!user || !source_action)
		return TRUE
	if(source_action.owner != user)
		return TRUE

	if(source_action.can_use_action())
		source_action.action_activate()
	return TRUE

/atom/movable/screen/action_button/Destroy()
	source_action = null
	QDEL_NULL(maptext_overlay)
	return ..()

/atom/movable/screen/action_button/proc/get_button_screen_loc(button_number)
	var/row = floor((button_number-1)/13) //13 is max amount of buttons per row
	var/col = ((button_number - 1)%(13)) + 1
	var/coord_col = "+[col-1]"
	var/coord_col_offset = 4+2*col
	var/coord_row = "[-1 - row]"
	var/coord_row_offset = 26
	return "WEST[coord_col]:[coord_col_offset],NORTH[coord_row]:[coord_row_offset]"

/atom/movable/screen/action_button/proc/get_xeno_button_screen_loc(button_number)
	return GLOB.xeno_action_hud_coords[button_number]

/atom/movable/screen/action_button/proc/set_maptext(new_maptext, new_maptext_x, new_maptext_y)
	overlays -= maptext_overlay
	if(!new_maptext)
		return
	maptext_overlay = image(null, null, null, layer + 0.1)
	maptext_overlay.maptext = new_maptext
	if(new_maptext_x)
		maptext_overlay.maptext_x = new_maptext_x
	if(new_maptext_y)
		maptext_overlay.maptext_y = new_maptext_y
	overlays += maptext_overlay

/atom/movable/screen/action_button/hide_toggle
	name = "Hide Buttons"
	icon = 'icons/mob/hud/actions.dmi'
	icon_state = "hide"
	var/hidden = 0
	var/base_icon

/atom/movable/screen/action_button/hide_toggle/clicked(mob/user, list/mods)
	user.hud_used.action_buttons_hidden = !user.hud_used.action_buttons_hidden
	hidden = user.hud_used.action_buttons_hidden
	update_button_icon(user)
	user.update_action_buttons()
	return TRUE

/atom/movable/screen/action_button/hide_toggle/proc/update_button_icon(mob/user)
	if(isyautja(user))
		base_icon = "pred"
	else if(isxeno(user))
		base_icon = "xeno"
	else
		base_icon = "marine"

	if(hidden)
		name = "Show Buttons"
		icon_state = "[base_icon]_show"
	else
		name = "Hide Buttons"
		icon_state = "[base_icon]_hide"

/atom/movable/screen/action_button/ghost/minimap/get_button_screen_loc(button_number)
	return "SOUTH:6,CENTER+1:24"

/atom/movable/screen/storage
	name = "storage"
	layer = HUD_LAYER

/atom/movable/screen/storage/proc/update_fullness(obj/item/storage/master_storage)
	if(!length(master_storage.contents))
		color = null
	else
		var/total_w = 0
		for(var/obj/item/storage_item in master_storage)
			total_w += storage_item.w_class

		//Calculate fullness for etiher max storage, or for storage slots if the container has them
		var/fullness = 0
		if (master_storage.storage_slots == null)
			fullness = floor(10*total_w/master_storage.max_storage_space)
		else
			fullness = floor(10*length(master_storage.contents)/master_storage.storage_slots)
		switch(fullness)
			if(10)
				color = "#ff0000"
			if(7 to 9)
				color = "#ffa500"
			else
				color = null

/atom/movable/screen/zone_sel
	name = "damage zone"
	icon_state = "zone_sel"
	plane = HUD_PLANE
	layer = HUD_LAYER
	var/overlay_icon = 'icons/mob/hud/cm_hud/cm_hud_zone_sel_xeno.dmi'
	var/static/list/hover_overlays_cache = list()
	var/hovering

/atom/movable/screen/zone_sel/clicked(mob/user, list/mods)
	if(isobserver(usr))
		return

	var/icon_x = text2num(LAZYACCESS(mods, ICON_X))
	var/icon_y = text2num(LAZYACCESS(mods, ICON_Y))
	var/choice = get_zone_at(icon_x, icon_y, user)
	if(!choice)
		return 1

	return set_selected_zone(choice, usr)

/atom/movable/screen/zone_sel/MouseEntered(location, control, params)
	. = ..()
	MouseMove(location, control, params)

/atom/movable/screen/zone_sel/MouseMove(location, control, params)
	if(isobserver(usr))
		return

	var/list/modifiers = params2list(params)
	var/icon_x = text2num(LAZYACCESS(modifiers, ICON_X))
	var/icon_y = text2num(LAZYACCESS(modifiers, ICON_Y))
	var/choice = get_zone_at(icon_x, icon_y, usr)

	if(hovering == choice)
		return
	vis_contents -= hover_overlays_cache[hovering]
	hovering = choice

	// Don't need to account for turf cause we're on the hud babyyy
	var/obj/effect/overlay/zone_sel/overlay_object = hover_overlays_cache[choice]
	if(!overlay_object)
		overlay_object = new
		overlay_object.icon_state = "[choice]"
		hover_overlays_cache[choice] = overlay_object
	vis_contents += overlay_object

/atom/movable/screen/zone_sel/proc/set_selected_zone(choice, mob/user, should_log = TRUE)
	if(choice != user.hud_used.mymob.zone_selected)
		user.hud_used.mymob.zone_selected = choice
		update_icon(user)

	return TRUE

/atom/movable/screen/zone_sel/update_icon(mob/user)
	// if(!hud?.mymob)
	// 	return
	user.hud_used?.zone_sel.overlays.Cut()
	user.hud_used?.zone_sel.overlays += mutable_appearance(overlay_icon, "[user.zone_selected]")

/atom/movable/screen/zone_sel/MouseExited(location, control, params)
	if(!isobserver(usr) && hovering)
		vis_contents -= hover_overlays_cache[hovering]
		hovering = null

/obj/effect/overlay/zone_sel
	icon = 'icons/mob/hud/cm_hud/cm_hud_zone_sel_xeno.dmi'
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 128
	anchored = TRUE
	plane = ABOVE_HUD_PLANE
	layer = ABOVE_HUD_LAYER

/atom/movable/screen/zone_sel/proc/get_zone_at(icon_x, icon_y, mob/user)
	if(isxeno(user))
		switch(icon_y)
			if(2 to 5) //Feet
				switch(icon_x)
					if(20 to 23)
						return BODY_ZONE_R_FOOT
					if(24 to 26)
						return BODY_ZONE_L_FOOT
			if(6 to 13) //Legs
				switch(icon_x)
					if(20 to 23)
						return BODY_ZONE_R_LEG
					if(24 to 26)
						return BODY_ZONE_L_LEG
			if(14 to 19) //Hands and groin
				switch(icon_x)
					if(17 to 20)
						return BODY_ZONE_R_HAND
					if(21 to 25)
						return BODY_ZONE_GROIN
					if(26 to 29)
						return BODY_ZONE_L_HAND
			if(20 to 32) //Chest and arms to shoulders
				switch(icon_x)
					if(17 to 20)
						return BODY_ZONE_R_ARM
					if(21 to 25)
						return BODY_ZONE_CHEST
					if(26 to 29)
						return BODY_ZONE_L_ARM
			if(33 to 40) //Head, but we need to check for eye or mouth
				if(icon_x in 20 to 26)
					switch(icon_y)
						if(33 to 35)
							if(icon_x in 22 to 24)
								return BODY_ZONE_MOUTH
						if(36 to 38) //Eyeline, eyes are on 15 and 17
							if(icon_x in 20 to 26)
								return BODY_ZONE_EYES
					return BODY_ZONE_HEAD
	// else
	// 	switch(icon_y)
	// 		if(1 to 3) //Feet
	// 			switch(icon_x)
	// 				if(10 to 15)
	// 					selecting = "r_foot"
	// 				if(17 to 22)
	// 					selecting = "l_foot"
	// 				else
	// 					return 1
	// 		if(4 to 9) //Legs
	// 			switch(icon_x)
	// 				if(10 to 15)
	// 					selecting = "r_leg"
	// 				if(17 to 22)
	// 					selecting = "l_leg"
	// 				else
	// 					return 1
	// 		if(10 to 13) //Hands and groin
	// 			switch(icon_x)
	// 				if(8 to 11)
	// 					selecting = "r_hand"
	// 				if(12 to 20)
	// 					selecting = "groin"
	// 				if(21 to 24)
	// 					selecting = "l_hand"
	// 				else
	// 					return 1
	// 		if(14 to 22) //Chest and arms to shoulders
	// 			switch(icon_x)
	// 				if(8 to 11)
	// 					selecting = "r_arm"
	// 				if(12 to 20)
	// 					selecting = "chest"
	// 				if(21 to 24)
	// 					selecting = "l_arm"
	// 				else
	// 					return 1
	// 		if(23 to 30) //Head, but we need to check for eye or mouth
	// 			if(icon_x in 12 to 20)
	// 				selecting = "head"
	// 				switch(icon_y)
	// 					if(23 to 24)
	// 						if(icon_x in 15 to 17)
	// 							selecting = "mouth"
	// 					if(26) //Eyeline, eyes are on 15 and 17
	// 						if(icon_x in 14 to 18)
	// 							selecting = "eyes"
	// 					if(25 to 27)
	// 						if(icon_x in 15 to 17)
	// 							selecting = "eyes"

/atom/movable/screen/gun
	/// The proc/verb which should be called on the gun.
	var/gun_proc_ref
	icon = 'icons/mob/hud/cm_hud/cm_hud_marine_attachment_buttons.dmi'

/atom/movable/screen/gun/clicked(mob/user, list/mods)
	. = ..()
	if(.)
		return
	// If the user has a gun in their active hand, call `gun_proc_ref` on it.
	var/obj/item/weapon/gun/held_item = user.get_held_item()
	if(istype(held_item))
		INVOKE_ASYNC(held_item, gun_proc_ref)

/atom/movable/screen/gun/attachment
	name = "Activate weapon attachment"
	icon_state = "gun_attach"
	gun_proc_ref = TYPE_VERB_REF(/obj/item/weapon/gun, activate_attachment_verb)

/atom/movable/screen/gun/rail_light
	name = "Toggle rail flashlight"
	icon_state = "gun_raillight"
	gun_proc_ref = TYPE_VERB_REF(/obj/item/weapon/gun, activate_rail_attachment_verb)

// /atom/movable/screen/gun/eject_magazine
// 	name = "Eject magazine"
// 	icon_state = "gun_loaded"
// 	gun_proc_ref = TYPE_VERB_REF(/obj/item/weapon/gun, empty_mag)

/atom/movable/screen/gun/toggle_firemode
	name = "Toggle firemode"
	icon_state = "gun_burst"
	gun_proc_ref = TYPE_VERB_REF(/obj/item/weapon/gun, use_toggle_burst)

/atom/movable/screen/gun/unique_action
	name = "Use unique action"
	icon_state = "gun_unique"
	gun_proc_ref = TYPE_VERB_REF(/obj/item/weapon/gun, use_unique_action)


/atom/movable/screen/clicked(mob/user, list/mods)
	if(!user)
		return TRUE

	if(isobserver(user))
		return TRUE

	return FALSE

/atom/movable/screen/inventory/clicked(mob/user, list/mods)
	if(..())
		return TRUE
	if(user.is_mob_incapacitated(TRUE))
		return TRUE
	//If there is an item in the slot you are clicking on, this will relay the click to the item within the slot
	///REMOVE THIS COMMENT WHEN IT STARTS TO WORK PROPERLY
	if(user?.hud_used && slot_id)
		var/atom/item_in_slot = user.get_item_by_slot(slot_id)
		if(item_in_slot)
			return item_in_slot.clicked(user, mods)
	///REMOVE THIS COMMENT WHEN IT STARTS TO WORK PROPERLY
	switch(name)
		if("r_hand")
			if(iscarbon(user))
				var/mob/living/carbon/carbon = user
				carbon.activate_hand("r")
			return TRUE
		if("l_hand")
			if(iscarbon(user))
				var/mob/living/carbon/carbon = user
				carbon.activate_hand("l")
			return TRUE
		if("swap")
			user.swap_hand()
			return TRUE
		if("hand")
			user.swap_hand()
			return TRUE
		else
			if(user.attack_ui(slot_id))
				user.update_inv_l_hand(0)
				user.update_inv_r_hand(0)
				return TRUE
	return FALSE

/atom/movable/screen/inventory/proc/handle_dropped_on(atom/dropped_on, atom/dropping, client/user)
	SIGNAL_HANDLER

	if(slot_id != WEAR_L_HAND && slot_id != WEAR_R_HAND)
		return

	if(!isstorage(dropping.loc))
		return

	if(!user.mob.Adjacent(dropping))
		return

	var/obj/item/storage/store = dropping.loc
	store.remove_from_storage(dropping, get_turf(user.mob))
	user.mob.put_in_active_hand(dropping)

/atom/movable/screen/throw_catch
	name = "throw/catch"
	icon = 'icons/mob/hud/human_midnight.dmi'
	icon_state = "act_throw_off"

/atom/movable/screen/throw_catch/clicked(mob/user, list/mods)
	var/mob/living/carbon/carbon = user

	if (!istype(carbon))
		return

	if(user.is_mob_incapacitated())
		return TRUE

	if (mods[CTRL_CLICK])
		carbon.toggle_throw_mode(THROW_MODE_HIGH)
	else
		carbon.toggle_throw_mode(THROW_MODE_NORMAL)
	return TRUE

/atom/movable/screen/drop
	name = "drop"
	icon = 'icons/mob/hud/human_midnight.dmi'
	icon_state = "act_drop"
	layer = HUD_LAYER

/atom/movable/screen/drop/clicked(mob/user)
	user.drop_item_v()
	return 1


/atom/movable/screen/resist
	name = "resist"
	icon = 'icons/mob/hud/human_midnight.dmi'
	icon_state = "act_resist"
	layer = HUD_LAYER

/atom/movable/screen/resist/clicked(mob/user)
	if(isliving(user))
		var/mob/living/living = user
		living.resist()
		return 1

/atom/movable/screen/rest
	name = "rest"
	icon = 'icons/mob/hud/human_midnight.dmi'
	icon_state = "act_rest"
	layer = HUD_LAYER

/atom/movable/screen/rest/clicked(mob/user)
	if(.)
		return
	var/mob/living/living_mob = user
	living_mob.lay_down()
	return TRUE

/atom/movable/screen/mov_intent
	name = "run/walk toggle"
	icon = 'icons/mob/hud/human_midnight.dmi'
	icon_state = "running"

/atom/movable/screen/mov_intent/clicked(mob/living/user)
	. = ..()
	if(.)
		return TRUE
	user.toggle_mov_intent()

/mob/living/proc/set_movement_intent(new_intent)
	m_intent = new_intent
	if(hud_used?.move_intent)
		hud_used.move_intent.set_movement_intent_icon(m_intent)
	recalculate_move_delay = TRUE

/mob/living/proc/toggle_mov_intent()
	if(legcuffed)
		to_chat(src, SPAN_NOTICE("You are legcuffed! You cannot run until you get \the [legcuffed] removed!"))
		set_movement_intent(MOVE_INTENT_WALK)
		return FALSE
	switch(m_intent)
		if(MOVE_INTENT_RUN)
			set_movement_intent(MOVE_INTENT_WALK)
		if(MOVE_INTENT_WALK)
			set_movement_intent(MOVE_INTENT_RUN)
	return TRUE

/atom/movable/screen/mov_intent/proc/set_movement_intent_icon(new_intent)
	switch(new_intent)
		if(MOVE_INTENT_WALK)
			icon_state = "walking"
		if(MOVE_INTENT_RUN)
			icon_state = "running"

/mob/living/carbon/xenomorph/toggle_mov_intent()
	. = ..()
	if(.)
		update_icons()
		return TRUE

/atom/movable/screen/act_intent
	name = "intent"
	icon_state = "intent_help"

/atom/movable/screen/act_intent/clicked(mob/user)
	user.a_intent_change()
	return 1

/atom/movable/screen/act_intent/corner/clicked(mob/user, list/mods)
	var/_x = text2num(mods[ICON_X])
	var/_y = text2num(mods[ICON_Y])

	if(_x<=19 && _y<=20)
		user.a_intent_change(INTENT_HARM)
	else if(_x<=19 && _y>=22)
		user.a_intent_change(INTENT_HELP)
	else if(_x>=21 && _y<=20)
		user.a_intent_change(INTENT_GRAB)
	else if(_x>=21 && _y>=22)
		user.a_intent_change(INTENT_DISARM)
	return 1


/atom/movable/screen/healths
	name = "health"
	icon_state = "health0"
	icon = 'icons/mob/hud/human_midnight.dmi'

/atom/movable/screen/healths/xeno
	name = "health"
	icon_state = "health_doll"

/atom/movable/screen/pull
	name = "stop pulling"
	icon = 'icons/mob/hud/human_midnight.dmi'
	icon_state = "pull0"

/atom/movable/screen/pull/clicked(mob/user)
	if (..())
		return 1
	user.stop_pulling()
	return 1

/atom/movable/screen/pull/update_icon(mob/user)
	if(!user)
		return
	if(user.pulling)
		icon_state = "pull1"
	else
		icon_state = "pull0"

/atom/movable/screen/squad_leader_locator
	name = "beacon tracker"
	icon = 'icons/mob/hud/human_midnight.dmi'
	icon_state = "trackoff"
	alpha = 0 //invisible
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/squad_leader_locator/clicked(mob/living/carbon/human/user, mods)
	if(!istype(user))
		return
	var/obj/item/device/radio/headset/earpiece = user.get_type_in_ears(/obj/item/device/radio/headset)
	var/has_access = earpiece.misc_tracking || (user.assigned_squad && user.assigned_squad.radio_freq == earpiece.frequency)
	if(!istype(earpiece) || !earpiece.has_hud || !has_access)
		to_chat(user, SPAN_WARNING("Unauthorized access detected."))
		return
	if(mods[SHIFT_CLICK])
		var/area/current_area = get_area(user)
		to_chat(user, SPAN_NOTICE("You are currently at: <b>[current_area.name]</b>."))
		return
	else if(mods[ALT_CLICK])
		earpiece.switch_tracker_target()
		return
	if(user.get_active_hand())
		return
	if(user.assigned_squad)
		user.assigned_squad.tgui_interact(user)

/atom/movable/screen/mark_locator
	name = "mark locator"
	icon = 'icons/mob/hud/alien_standard.dmi'
	icon_state = "marker"

/atom/movable/screen/mark_locator/clicked(mob/living/carbon/xenomorph/user, mods)
	if(!istype(user))
		return FALSE
	if(mods[SHIFT_CLICK] && user.tracked_marker)
		if(user.observed_xeno == user.tracked_marker)
			user.overwatch(user.tracked_marker, TRUE) //passing in an obj/effect into a proc that expects mob/xenomorph B)
		else
			to_chat(user, SPAN_XENONOTICE("We psychically observe the [user.tracked_marker.mark_meaning.name] resin mark in [get_area_name(user.tracked_marker)]."))
			user.overwatch(user.tracked_marker) //this is so scuffed, sorry if this causes errors
		return
	if(mods[ALT_CLICK] && user.tracked_marker)
		user.stop_tracking_resin_mark()
		return
	if(!user.hive)
		to_chat(user, SPAN_WARNING("We don't belong to a hive!"))
		return FALSE
	if(!user.hive.living_xeno_queen)
		to_chat(user, SPAN_WARNING("Without a queen our psychic link is broken!"))
		return FALSE
	if(HAS_TRAIT(user, TRAIT_ABILITY_BURROWED) || user.is_mob_incapacitated() || user.buckled)
		return FALSE
	user.hive.mark_ui.update_all_data()
	user.hive.mark_ui.open_mark_menu(user)

/atom/movable/screen/queen_locator
	name = "queen locator"
	icon = 'icons/mob/hud/alien_standard.dmi'
	icon_state = "trackoff"
	/// A weak reference to the atom currently being tracked.
	/// (Note: This is null for `TRACKER_QUEEN` and `TRACKER_HIVE`, as those are accessed through the user's hive datum.)
	var/datum/weakref/tracking_ref = null
	/// The 'category' of the atom currently being tracked. (Defaults to `TRACKER_QUEEN`)
	var/tracker_type = TRACKER_QUEEN

/atom/movable/screen/queen_locator/clicked(mob/living/carbon/xenomorph/user, mods)
	if(!istype(user))
		return FALSE
	if(mods[SHIFT_CLICK])
		var/area/current_area = get_area(user)
		to_chat(user, SPAN_NOTICE("We are currently at: <b>[current_area.name]</b>."))
		return
	if(!user.hive)
		to_chat(user, SPAN_WARNING("We don't belong to a hive!"))
		return FALSE
	if(mods[ALT_CLICK])
		var/list/options = list()
		if(user.hive.living_xeno_queen)
			// Don't need weakrefs to this or the hive core, since there's only one possible target.
			options["Queen"] = list(null, TRACKER_QUEEN)

		if(user.hive.hive_location)
			options["Hive Core"] = list(null, TRACKER_HIVE)

		for(var/mob/living/carbon/xenomorph/leader in user.hive.xeno_leader_list)
			options["Xeno Leader [leader]"] = list(leader, TRACKER_LEADER)

		var/list/sorted_tunnels = sort_list_dist(user.hive.tunnels, get_turf(user))
		for(var/obj/structure/tunnel/tunnel as anything in sorted_tunnels)
			options["Tunnel [tunnel.tunnel_desc]"] = list(tunnel, TRACKER_TUNNEL)

		var/list/selected = tgui_input_list(user, "Select what you want the locator to track.", "Locator Options", options)
		if(selected)
			var/selected_data = options[selected]
			tracking_ref = WEAKREF(selected_data[1]) // Weakref to the tracked atom (or null)
			tracker_type = selected_data[2] // Tracker category
		return

	if(!user.hive.living_xeno_queen)
		to_chat(user, SPAN_WARNING("Our hive doesn't have a living queen!"))
		return FALSE
	if(HAS_TRAIT(user, TRAIT_ABILITY_BURROWED) || user.is_mob_incapacitated() || user.buckled)
		return FALSE
	//Xenos should not be able to track tunnels. Queen's weakref is equal to null if selected.
	if(tracker_type != TRACKER_LEADER || !tracking_ref)
		user.overwatch(user.hive.living_xeno_queen)
		return
	user.overwatch(tracking_ref.resolve())

// Reset to the defaults
/atom/movable/screen/queen_locator/proc/reset_tracking()
	icon_state = "trackoff"
	tracking_ref = null
	tracker_type = TRACKER_QUEEN

/atom/movable/screen/xenonightvision
	icon = 'icons/mob/hud/alien_standard.dmi'
	name = "toggle night vision"
	icon_state = "nightvision_full"

/atom/movable/screen/xenonightvision/clicked(mob/user)
	if (..())
		return 1
	var/mob/living/carbon/xenomorph/X = user
	X.toggle_nightvision()
	update_icon(X)
	return 1

/atom/movable/screen/xenonightvision/update_icon(mob/living/carbon/xenomorph/owner)
	. = ..()
	var/vision_define
	switch(owner.lighting_alpha)
		if(LIGHTING_PLANE_ALPHA_INVISIBLE)
			icon_state = "nightvision_full"
			vision_define = XENO_VISION_LEVEL_FULL_NVG
		if(LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE)
			icon_state = "nightvision_three_quarters"
			vision_define = XENO_VISION_LEVEL_HIGH_NVG
		if(LIGHTING_PLANE_ALPHA_SOMEWHAT_INVISIBLE)
			icon_state = "nightvision_half"
			vision_define = XENO_VISION_LEVEL_MID_NVG
		if(LIGHTING_PLANE_ALPHA_VISIBLE)
			icon_state = "nightvision_off"
			vision_define = XENO_VISION_LEVEL_NO_NVG
	to_chat(owner, SPAN_NOTICE("Night vision mode switched to <b>[vision_define]</b>."))

/atom/movable/screen/xenoevo
	name = "Evolve Status"
	desc = "Click for evolve panel."

/atom/movable/screen/alien/evolvehud/clicked(mob/user, list/mods)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/xenomorph/X = user
	X.Evolve()

/atom/movable/screen/bodytemp
	name = "body temperature"
	icon_state = "temp0"

/atom/movable/screen/oxygen
	name = "oxygen"
	icon_state = "oxy0"

/atom/movable/screen/preview
	icon = 'icons/turf/almayer.dmi'
	icon_state = "blank"
	plane = -100
	layer = TURF_LAYER

/atom/movable/screen/rotate
	icon_state = "centred_arrow"
	dir = EAST
	var/atom/assigned_atom
	var/rotate_amount = 90

/atom/movable/screen/rotate/Initialize(mapload, set_assigned_atom)
	. = ..()
	assigned_atom = set_assigned_atom

/atom/movable/screen/rotate/clicked(mob/user)
	if(assigned_atom)
		assigned_atom.setDir(turn(assigned_atom.dir, rotate_amount))

/atom/movable/screen/rotate/alt
	dir = WEST
	rotate_amount = -90

/atom/movable/screen/vulture_scope // The part of the vulture's scope that drifts over time
	icon_state = "vulture_unsteady"
	screen_loc = "CENTER,CENTER"

/atom/movable/screen/surgery_mode
	name = "toggle surgery mode"
	icon = 'icons/mob/hud/cm_hud/cm_hud_marine_buttons.dmi'
	icon_state = "surgery_off"
	screen_loc = "hud:1:9,7:55"

// /atom/movable/screen/surgery_mode/give_to(mob/living/L)
// 	..()
// 	update_surgery_skill()

// /atom/movable/screen/surgery_mode/remove_from(mob/living/carbon/human/H)
// 	usr.mob_flags &= ~SURGERY_MODE_ON
// 	..()

// /atom/movable/screen/surgery_mode/proc/update_surgery_skill()
// 	if(skillcheck(usr, SKILL_SURGERY, SKILL_SURGERY_TRAINED) && !(usr.mob_flags & SURGERY_MODE_ON))
// 		icon_state = "surgery_on"
// 		usr.mob_flags |= SURGERY_MODE_ON

// Called when the action is clicked on.
/atom/movable/screen/surgery_mode/clicked()
	. = ..()
	if(usr.mob_flags & SURGERY_MODE_ON)
		icon_state = "surgery_off"
		usr.mob_flags &= ~SURGERY_MODE_ON
	else
		icon_state = "surgery_on"
		usr.mob_flags |= SURGERY_MODE_ON
		to_chat(usr, "You prepare to perform surgery.")

/atom/movable/screen/minimap_button
	name = "open minimap"
	icon = 'icons/mob/hud/cm_hud/cm_hud_marine_buttons.dmi'
	icon_state = "minimap_off"

/atom/movable/screen/minimap_button/clicked(mob/user, list/mods)
	. = ..()
	if(!istype(user))
		return
	for(var/datum/action/minimap/user_map in user.actions)
		user_map.action_activate()
	return TRUE


/atom/movable/screen/gun_ammo_counter
	name = "ammo"
	icon = 'icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi'
	icon_state = "ammo"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/warned = FALSE
	var/is_warning = FALSE

/atom/movable/screen/gun_ammo_counter/proc/add_hud(mob/living/user)
	if(!user?.client)
		return

	var/obj/item/weapon/gun/G = user.get_held_item()

	if(!(G.flags_gun_features & GUN_AMMO_COUNTER) && !G.active_attachable)
		return

	user.client.screen += src

/atom/movable/screen/gun_ammo_counter/proc/remove_hud(mob/living/user)
	user?.client?.screen -= src

/atom/movable/screen/gun_ammo_counter/proc/update_hud(mob/living/user)
	if(!user?.client?.screen.Find(src))
		return
	var/obj/item/weapon/gun/G = user.get_held_item()

	if(!istype(G))
		remove_hud(user)
		return

	if(!(G.flags_gun_features & GUN_AMMO_COUNTER) || !G.get_ammo_type() || isnull(G.get_ammo_count()) && !G.active_attachable)
		remove_hud(user)
		return

	if(G.active_attachable)
		update_attachable_hud(user, G)
		return

	var/list/ammo_type = G.get_ammo_type()
	var/rounds = G.get_ammo_count()

	var/hud_state = ammo_type[1]
	var/hud_state_empty = ammo_type[2]

	overlays.Cut()

	var/empty = image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "[hud_state_empty]")

	if(rounds == 0)
		overlays += empty
	else
		overlays += image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "[hud_state]")

	rounds = num2text(rounds)

	//Handle the amount of rounds
	switch(length(rounds))
		if(1)
			overlays += image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "o[rounds[1]]")
		if(2)
			overlays += image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "o[rounds[2]]")
			overlays += image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "t[rounds[1]]")
		if(3)
			overlays += image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "o[rounds[3]]")
			overlays += image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "t[rounds[2]]")
			overlays += image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "h[rounds[1]]")
		else //"0" is still length 1 so this means it's over 999
			overlays += image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "o9")
			overlays += image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "t9")
			overlays += image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "h9")

/atom/movable/screen/gun_ammo_counter/proc/update_attachable_hud(mob/living/user, obj/item/weapon/gun/G)
	var/obj/item/attachable/attached_gun/AG = G.active_attachable

	var/list/ammo_type = AG.get_attachment_ammo_type()
	var/rounds = AG.get_attachment_ammo_count()

	var/hud_state = ammo_type[1]
	var/hud_state_empty = ammo_type[2]

	overlays.Cut()

	var/empty = image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "[hud_state_empty]")

	if(rounds == 0)
		overlays += empty
	else
		overlays += image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "[hud_state]")

	rounds = num2text(rounds)

	//Handle the amount of rounds
	switch(length(rounds))
		if(1)
			overlays += image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "o[rounds[1]]")
		if(2)
			overlays += image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "o[rounds[2]]")
			overlays += image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "t[rounds[1]]")
		if(3)
			overlays += image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "o[rounds[3]]")
			overlays += image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "t[rounds[2]]")
			overlays += image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "h[rounds[1]]")
		else //"0" is still length 1 so this means it's over 999
			overlays += image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "o9")
			overlays += image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "t9")
			overlays += image('icons/mob/hud/cm_hud/cm_hud_ammo_counter.dmi', src, "h9")
