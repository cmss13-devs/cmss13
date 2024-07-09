/*
	Screen objects
	Todo: improve/re-implement

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
	var/slot_id //The indentifier for the slot. It has nothing to do with ID cards.

/atom/movable/screen/inventory/Initialize(mapload, ...)
	. = ..()

	RegisterSignal(src, COMSIG_ATOM_DROPPED_ON, PROC_REF(handle_dropped_on))

/atom/movable/screen/close
	name = "close"
	icon_state = "x"


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

/atom/movable/screen/action_button/proc/set_maptext(new_maptext, new_maptext_x, new_maptext_y)
	overlays -= maptext_overlay
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

/atom/movable/screen/action_button/hide_toggle/clicked(mob/user, list/mods)
	user.hud_used.action_buttons_hidden = !user.hud_used.action_buttons_hidden
	hidden = user.hud_used.action_buttons_hidden
	if(hidden)
		name = "Show Buttons"
		icon_state = "show"
	else
		name = "Hide Buttons"
		icon_state = "hide"
	user.update_action_buttons()
	return TRUE

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
	var/selecting = "chest"

/atom/movable/screen/zone_sel/update_icon(mob/living/user)
	overlays.Cut()
	overlays += image('icons/mob/hud/zone_sel.dmi', "[selecting]")

/atom/movable/screen/zone_sel/clicked(mob/user, list/mods)
	if (..())
		return TRUE

	var/icon_x = text2num(mods["icon-x"])
	var/icon_y = text2num(mods["icon-y"])
	var/old_selecting = selecting //We're only going to update_icon() if there's been a change

	switch(icon_y)
		if(1 to 3) //Feet
			switch(icon_x)
				if(10 to 15)
					selecting = "r_foot"
				if(17 to 22)
					selecting = "l_foot"
				else
					return 1
		if(4 to 9) //Legs
			switch(icon_x)
				if(10 to 15)
					selecting = "r_leg"
				if(17 to 22)
					selecting = "l_leg"
				else
					return 1
		if(10 to 13) //Hands and groin
			switch(icon_x)
				if(8 to 11)
					selecting = "r_hand"
				if(12 to 20)
					selecting = "groin"
				if(21 to 24)
					selecting = "l_hand"
				else
					return 1
		if(14 to 22) //Chest and arms to shoulders
			switch(icon_x)
				if(8 to 11)
					selecting = "r_arm"
				if(12 to 20)
					selecting = "chest"
				if(21 to 24)
					selecting = "l_arm"
				else
					return 1
		if(23 to 30) //Head, but we need to check for eye or mouth
			if(icon_x in 12 to 20)
				selecting = "head"
				switch(icon_y)
					if(23 to 24)
						if(icon_x in 15 to 17)
							selecting = "mouth"
					if(26) //Eyeline, eyes are on 15 and 17
						if(icon_x in 14 to 18)
							selecting = "eyes"
					if(25 to 27)
						if(icon_x in 15 to 17)
							selecting = "eyes"

	if(old_selecting != selecting)
		user.zone_selected = selecting
		update_icon(user)
	return 1

/atom/movable/screen/gun
	/// The proc/verb which should be called on the gun.
	var/gun_proc_ref

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

/atom/movable/screen/gun/eject_magazine
	name = "Eject magazine"
	icon_state = "gun_loaded"
	gun_proc_ref = TYPE_VERB_REF(/obj/item/weapon/gun, empty_mag)

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


/atom/movable/screen/inventory/clicked(mob/user)
	if (..())
		return 1
	if(user.is_mob_incapacitated(TRUE))
		return 1
	switch(name)
		if("r_hand")
			if(iscarbon(user))
				var/mob/living/carbon/carbon = user
				carbon.activate_hand("r")
			return 1
		if("l_hand")
			if(iscarbon(user))
				var/mob/living/carbon/carbon = user
				carbon.activate_hand("l")
			return 1
		if("swap")
			user.swap_hand()
			return 1
		if("hand")
			user.swap_hand()
			return 1
		else
			if(user.attack_ui(slot_id))
				user.update_inv_l_hand(0)
				user.update_inv_r_hand(0)
				return 1
	return 0

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

	if (mods["ctrl"])
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
	var/_x = text2num(mods["icon-x"])
	var/_y = text2num(mods["icon-y"])

	if(_x<=16 && _y<=16)
		user.a_intent_change(INTENT_HARM)

	else if(_x<=16 && _y>=17)
		user.a_intent_change(INTENT_HELP)

	else if(_x>=17 && _y<=16)
		user.a_intent_change(INTENT_GRAB)

	else if(_x>=17 && _y>=17)
		user.a_intent_change(INTENT_DISARM)

	return 1


/atom/movable/screen/healths
	name = "health"
	icon_state = "health0"
	icon = 'icons/mob/hud/human_midnight.dmi'
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

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
		icon_state = "pull"
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
	if(mods["shift"])
		var/area/current_area = get_area(user)
		to_chat(user, SPAN_NOTICE("You are currently at: <b>[current_area.name]</b>."))
		return
	else if(mods["alt"])
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
	if(mods["shift"] && user.tracked_marker)
		if(user.observed_xeno == user.tracked_marker)
			user.overwatch(user.tracked_marker, TRUE) //passing in an obj/effect into a proc that expects mob/xenomorph B)
		else
			to_chat(user, SPAN_XENONOTICE("We psychically observe the [user.tracked_marker.mark_meaning.name] resin mark in [get_area_name(user.tracked_marker)]."))
			user.overwatch(user.tracked_marker) //this is so scuffed, sorry if this causes errors
		return
	if(mods["alt"] && user.tracked_marker)
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
	if(mods["shift"])
		var/area/current_area = get_area(user)
		to_chat(user, SPAN_NOTICE("We are currently at: <b>[current_area.name]</b>."))
		return
	if(!user.hive)
		to_chat(user, SPAN_WARNING("We don't belong to a hive!"))
		return FALSE
	if(mods["alt"])
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
	user.overwatch(user.hive.living_xeno_queen)

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
			icon_state = "nightvision_half"
			vision_define = XENO_VISION_LEVEL_MID_NVG
		if(LIGHTING_PLANE_ALPHA_VISIBLE)
			icon_state = "nightvision_off"
			vision_define = XENO_VISION_LEVEL_NO_NVG
	to_chat(owner, SPAN_NOTICE("Night vision mode switched to <b>[vision_define]</b>."))

/atom/movable/screen/equip
	name = "equip"
	icon_state = "act_equip"
	layer = ABOVE_HUD_LAYER
	plane = ABOVE_HUD_PLANE

/atom/movable/screen/equip/clicked(mob/user)
	. = ..()
	if(. || !ishuman(user))
		return TRUE
	var/mob/living/carbon/human/human_user = user
	human_user.quick_equip()

/atom/movable/screen/bodytemp
	name = "body temperature"
	icon_state = "temp0"

/atom/movable/screen/oxygen
	name = "oxygen"
	icon_state = "oxy0"

/atom/movable/screen/toggle_inv
	name = "toggle"
	icon_state = "other"

/atom/movable/screen/toggle_inv/clicked(mob/user)
	if (..())
		return 1

	if(user && user.hud_used)
		if(user.hud_used.inventory_shown)
			user.hud_used.inventory_shown = 0
			user.client.remove_from_screen(user.hud_used.toggleable_inventory)
		else
			user.hud_used.inventory_shown = 1
			user.client.add_to_screen(user.hud_used.toggleable_inventory)

		user.hud_used.hidden_inventory_update()
	return 1

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
