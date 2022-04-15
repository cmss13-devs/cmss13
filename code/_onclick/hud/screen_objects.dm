/*
	Screen objects
	Todo: improve/re-implement

	Screen objects are only used for the hud and should not appear anywhere "in-game".
	They are used with the client/screen list and the screen_loc var.
	For more information, see the byond documentation on the screen_loc and screen vars.
*/

/obj/screen
	name = ""
	icon = 'icons/mob/hud/screen1.dmi'
	icon_state = "x"
	layer = ABOVE_HUD_LAYER
	unacidable = TRUE
	appearance_flags = NO_CLIENT_COLOR //So that saturation/desaturation etc. effects don't hit the HUD.
	var/obj/master = null	//A reference to the object in the slot. Grabs or items, generally.

/obj/screen/text
	icon = null
	icon_state = null
	mouse_opacity = 0
	plane = CINEMATIC_PLANE
	layer = CINEMATIC_LAYER
	maptext_height = 480
	maptext_width = 480
	appearance_flags = NO_CLIENT_COLOR|PIXEL_SCALE

/obj/screen/cinematic
	plane = CINEMATIC_PLANE
	layer = CINEMATIC_LAYER
	mouse_opacity = 0
	screen_loc = "1,0"

/obj/screen/cinematic/explosion
	icon = 'icons/effects/station_explosion.dmi'
	icon_state = "intro_ship"

/obj/screen/inventory
	var/slot_id	//The indentifier for the slot. It has nothing to do with ID cards.


/obj/screen/close
	name = "close"
	icon_state = "x"


/obj/screen/close/clicked(var/mob/user)
	if(master)
		if(isstorage(master))
			var/obj/item/storage/S = master
			S.storage_close(user)
	return TRUE


/obj/screen/action_button
	icon = 'icons/mob/hud/actions.dmi'
	icon_state = "template"
	var/datum/action/source_action

/obj/screen/action_button/clicked(var/mob/user)
	if(!user || !source_action)
		return TRUE

	if(source_action.can_use_action())
		source_action.action_activate()
	return TRUE

/obj/screen/action_button/Destroy()
	source_action = null
	. = ..()

/obj/screen/action_button/proc/get_button_screen_loc(button_number)
	var/row = round((button_number-1)/13) //13 is max amount of buttons per row
	var/col = ((button_number - 1)%(13)) + 1
	var/coord_col = "+[col-1]"
	var/coord_col_offset = 4+2*col
	var/coord_row = "[-1 - row]"
	var/coord_row_offset = 26
	return "WEST[coord_col]:[coord_col_offset],NORTH[coord_row]:[coord_row_offset]"



/obj/screen/action_button/hide_toggle
	name = "Hide Buttons"
	icon = 'icons/mob/hud/actions.dmi'
	icon_state = "hide"
	var/hidden = 0

/obj/screen/action_button/hide_toggle/clicked(var/mob/user, mods)
	user.hud_used.action_buttons_hidden = !user.hud_used.action_buttons_hidden
	hidden = user.hud_used.action_buttons_hidden
	if(hidden)
		name = "Show Buttons"
		icon_state = "show"
	else
		name = "Hide Buttons"
		icon_state = "hide"
	user.update_action_buttons()
	return 1


/obj/screen/storage
	name = "storage"
	layer = HUD_LAYER

/obj/screen/storage/proc/update_fullness(obj/item/storage/S)
	if(!S.contents.len)
		color = null
	else
		var/total_w = 0
		for(var/obj/item/I in S)
			total_w += I.w_class

		//Calculate fullness for etiher max storage, or for storage slots if the container has them
		var/fullness = 0
		if (S.storage_slots == null)
			fullness = round(10*total_w/S.max_storage_space)
		else
			fullness = round(10*S.contents.len/S.storage_slots)
		switch(fullness)
			if(10) color = "#ff0000"
			if(7 to 9) color = "#ffa500"
			else color = null



/obj/screen/gun
	name = "gun"
	dir = SOUTH
	var/gun_click_time = -100

/obj/screen/gun/move
	name = "Allow Walking"
	icon_state = "no_walk0"

	update_icon(mob/user)
		if(user.gun_mode)
			if(user.target_can_move)
				icon_state = "no_walk1"
				name = "Disallow Walking"
			else
				icon_state = "no_walk0"
				name = "Allow Walking"
			screen_loc = initial(screen_loc)
			return
		screen_loc = null

/obj/screen/gun/move/clicked(var/mob/user)
	if (..())
		return 1

	if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
		return 1
	if(!isgun(user.get_held_item()))
		to_chat(user, "You need your gun in your active hand to do that!")
		return 1
	user.AllowTargetMove()
	gun_click_time = world.time
	return 1


/obj/screen/gun/run
	name = "Allow Running"
	icon_state = "no_run0"

	update_icon(mob/user)
		if(user.gun_mode)
			if(user.target_can_move)
				if(user.target_can_run)
					icon_state = "no_run1"
					name = "Disallow Running"
				else
					icon_state = "no_run0"
					name = "Allow Running"
				screen_loc = initial(screen_loc)
				return
		screen_loc = null

/obj/screen/gun/run/clicked(var/mob/user)
	if (..())
		return 1

	if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
		return 1
	if(!isgun(user.get_held_item()))
		to_chat(user, "You need your gun in your active hand to do that!")
		return 1
	user.AllowTargetRun()
	gun_click_time = world.time
	return 1


/obj/screen/gun/item
	name = "Allow Item Use"
	icon_state = "no_item0"

	update_icon(mob/user)
		if(user.gun_mode)
			if(user.target_can_click)
				icon_state = "no_item1"
				name = "Allow Item Use"
			else
				icon_state = "no_item0"
				name = "Disallow Item Use"
			screen_loc = initial(screen_loc)
			return
		screen_loc = null

/obj/screen/gun/item/clicked(var/mob/user)
	if (..())
		return 1

	if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
		return 1
	if(!isgun(user.get_held_item()))
		to_chat(user, "You need your gun in your active hand to do that!")
		return 1
	user.AllowTargetClick()
	gun_click_time = world.time
	return 1


/obj/screen/gun/mode
	name = "Toggle Gun Mode"
	icon_state = "gun0"

	update_icon(mob/user)
		if(user.gun_mode) icon_state = "gun1"
		else icon_state = "gun0"

/obj/screen/gun/mode/clicked(var/mob/user)
	if (..())
		return 1
	user.ToggleGunMode()
	return 1


/obj/screen/zone_sel
	name = "damage zone"
	icon_state = "zone_sel"
	var/selecting = "chest"

/obj/screen/zone_sel/update_icon(mob/living/user)
	overlays.Cut()
	overlays += image('icons/mob/hud/zone_sel.dmi', "[selecting]")
	user.zone_selected = selecting

/obj/screen/zone_sel/clicked(var/mob/user, var/list/mods)
	if (..())
		return 1

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
		update_icon(user)
	return 1

/obj/screen/zone_sel/robot
	icon = 'icons/mob/hud/screen1_robot.dmi'

/obj/screen/clicked(var/mob/user)
	if(!user)	return 1

	switch(name)
		if("equip")
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.quick_equip()
			return 1

		if("Reset Machine")
			user.unset_interaction()
			return 1

		if("module")
			if(isSilicon(user))
				if(usr:module)
					return 1
				user:pick_module()
			return 1

		if("radio")
			if(isSilicon(user))
				user:radio_menu()
			return 1
		if("panel")
			if(isSilicon(user))
				user:installed_modules()
			return 1

		if("store")
			if(isSilicon(user))
				user:uneq_active()
			return 1

		if("module1")
			if(isrobot(user))
				user:toggle_module(1)
			return 1

		if("module2")
			if(isrobot(user))
				user:toggle_module(2)
			return 1

		if("module3")
			if(isrobot(user))
				user:toggle_module(3)
			return 1

		if("Activate weapon attachment")
			var/obj/item/weapon/gun/G = user.get_held_item()
			if(istype(G))
				G.activate_attachment_verb()
			return 1

		if("Toggle Rail Flashlight")
			var/obj/item/weapon/gun/G = user.get_held_item()
			if(istype(G))
				G.activate_rail_attachment_verb()
			return 1

		if("Eject magazine")
			var/obj/item/weapon/gun/G = user.get_held_item()
			if(istype(G)) G.empty_mag()
			return 1

		if("Toggle burst fire")
			var/obj/item/weapon/gun/G = user.get_held_item()
			if(istype(G)) G.toggle_burst()
			return 1

		if("Use unique action")
			var/obj/item/weapon/gun/G = user.get_held_item()
			if(istype(G)) G.use_unique_action()
			return 1
	return 0


/obj/screen/inventory/clicked(var/mob/user)
	if (..())
		return 1
	if(user.is_mob_incapacitated(TRUE))
		return 1
	switch(name)
		if("r_hand")
			if(iscarbon(usr))
				var/mob/living/carbon/C = user
				C.activate_hand("r")
			return 1
		if("l_hand")
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.activate_hand("l")
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

/obj/screen/throw_catch
	name = "throw/catch"
	icon = 'icons/mob/hud/human_midnight.dmi'
	icon_state = "act_throw_off"

/obj/screen/throw_catch/clicked(var/mob/user, var/list/mods)
	var/mob/living/carbon/C = user

	if (!istype(C))
		return

	if(user.is_mob_incapacitated())
		return TRUE

	if (mods["ctrl"])
		C.toggle_throw_mode(THROW_MODE_HIGH)
	else
		C.toggle_throw_mode(THROW_MODE_NORMAL)
	return TRUE

/obj/screen/drop
	name = "drop"
	icon = 'icons/mob/hud/human_midnight.dmi'
	icon_state = "act_drop"
	layer = HUD_LAYER

/obj/screen/drop/clicked(var/mob/user)
	user.drop_item_v()
	return 1


/obj/screen/resist
	name = "resist"
	icon = 'icons/mob/hud/human_midnight.dmi'
	icon_state = "act_resist"
	layer = HUD_LAYER

/obj/screen/resist/clicked(var/mob/user)
	if(isliving(user))
		var/mob/living/L = user
		L.resist()
		return 1

/obj/screen/act_intent
	name = "intent"
	icon_state = "intent_help"

/obj/screen/act_intent/clicked(var/mob/user)
	user.a_intent_change()
	return 1

/obj/screen/act_intent/corner/clicked(var/mob/user, var/list/mods)
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


/obj/screen/healths
	name = "health"
	icon_state = "health0"
	icon = 'icons/mob/hud/human_midnight.dmi'
	mouse_opacity = 0

/obj/screen/pull
	name = "stop pulling"
	icon = 'icons/mob/hud/human_midnight.dmi'
	icon_state = "pull0"

/obj/screen/pull/clicked(var/mob/user)
	if (..())
		return 1
	user.stop_pulling()
	return 1

/obj/screen/pull/update_icon(mob/user)
	if(!user) return
	if(user.pulling)
		icon_state = "pull"
	else
		icon_state = "pull0"



/obj/screen/squad_leader_locator
	name = "beacon tracker"
	icon = 'icons/mob/hud/human_midnight.dmi'
	icon_state = "trackoff"
	alpha = 0 //invisible
	mouse_opacity = 0

/obj/screen/squad_leader_locator/clicked(mob/living/carbon/human/user, mods)
	if(!istype(user))
		return
	var/obj/item/device/radio/headset/almayer/marine/earpiece = user.get_type_in_ears(/obj/item/device/radio/headset/almayer/marine)
	if(!user.assigned_squad || !istype(earpiece) || user.assigned_squad.radio_freq != earpiece.frequency)
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
	user.assigned_squad.ui_interact(user)

/obj/screen/mark_locator
	name = "mark locator"
	icon = 'icons/mob/hud/alien_standard.dmi'
	icon_state = "marker"

/obj/screen/mark_locator/clicked(mob/living/carbon/Xenomorph/user, mods)
	if(!istype(user))
		return FALSE
	if(mods["shift"] && user.tracked_marker)
		if(user.observed_xeno == user.tracked_marker)
			user.overwatch(user.tracked_marker, TRUE) //passing in an obj/effect into a proc that expects mob/xenomorph B)
		else
			to_chat(user, SPAN_XENONOTICE("You psychically observe the [user.tracked_marker.mark_meaning.name] resin mark in [get_area_name(user.tracked_marker)]."))
			user.overwatch(user.tracked_marker) //this is so scuffed, sorry if this causes errors
		return
	if(mods["alt"] && user.tracked_marker)
		user.stop_tracking_resin_mark()
		return
	if(!user.hive)
		to_chat(user, SPAN_WARNING("You don't belong to a hive!"))
		return FALSE
	if(!user.hive.living_xeno_queen)
		to_chat(user, SPAN_WARNING("Without a queen your psychic link is broken!"))
		return FALSE
	if(user.burrow || user.is_mob_incapacitated() || user.buckled)
		return FALSE
	user.hive.mark_ui.update_all_data()
	user.hive.mark_ui.open_mark_menu(user)

/obj/screen/queen_locator
	name = "queen locator"
	icon = 'icons/mob/hud/alien_standard.dmi'
	icon_state = "trackoff"
	var/track_state = TRACKER_QUEEN

/obj/screen/queen_locator/clicked(mob/living/carbon/Xenomorph/user, mods)
	if(!istype(user))
		return FALSE
	if(mods["shift"])
		var/area/current_area = get_area(user)
		to_chat(user, SPAN_NOTICE("You are currently at: <b>[current_area.name]</b>."))
		return
	if(!user.hive)
		to_chat(user, SPAN_WARNING("You don't belong to a hive!"))
		return FALSE
	if(mods["alt"])
		var/list/options = list()
		if(user.hive.living_xeno_queen)
			options["Queen"] = TRACKER_QUEEN
		if(user.hive.hive_location)
			options["Hive Core"] = TRACKER_HIVE
		var/xeno_leader_index = 1
		for(var/xeno in user.hive.xeno_leader_list)
			var/mob/living/carbon/Xenomorph/xeno_lead = user.hive.xeno_leader_list[xeno_leader_index]
			if(xeno_lead)
				options["Xeno Leader [xeno_lead]"] = "[xeno_leader_index]"
			xeno_leader_index++
		var/selected = tgui_input_list(user, "Select what you want the locator to track.", "Locator Options", options)
		if(selected)
			track_state = options[selected]
		return
	if(!user.hive.living_xeno_queen)
		to_chat(user, SPAN_WARNING("Your hive doesn't have a living queen!"))
		return FALSE
	if(user.burrow || user.is_mob_incapacitated() || user.buckled)
		return FALSE
	user.overwatch(user.hive.living_xeno_queen)

/obj/screen/xenonightvision
	icon = 'icons/mob/hud/alien_standard.dmi'
	name = "toggle night vision"
	icon_state = "nightvision1"

/obj/screen/xenonightvision/clicked(var/mob/user)
	if (..())
		return 1
	var/mob/living/carbon/Xenomorph/X = user
	X.toggle_nightvision()
	if(X.lighting_alpha == LIGHTING_PLANE_ALPHA_VISIBLE)
		icon_state = "nightvision0"
	else
		icon_state = "nightvision1"
	return 1

/obj/screen/bodytemp
	name = "body temperature"
	icon_state = "temp0"

/obj/screen/oxygen
	name = "oxygen"
	icon_state = "oxy0"

/obj/screen/toggle_inv
	name = "toggle"
	icon_state = "other"

/obj/screen/toggle_inv/clicked(var/mob/user)
	if (..())
		return 1

	if(user && user.hud_used)
		if(user.hud_used.inventory_shown)
			user.hud_used.inventory_shown = 0
			user.client.screen -= user.hud_used.toggleable_inventory
		else
			user.hud_used.inventory_shown = 1
			user.client.screen += user.hud_used.toggleable_inventory

		user.hud_used.hidden_inventory_update()
	return 1

/obj/screen/rotate
	icon_state = "centred_arrow"
	dir = EAST
	var/atom/assigned_atom
	var/rotate_amount = 90

/obj/screen/rotate/Initialize(mapload, var/set_assigned_atom)
	. = ..()
	assigned_atom = set_assigned_atom

/obj/screen/rotate/clicked(mob/user)
	if(assigned_atom)
		assigned_atom.setDir(turn(assigned_atom.dir, rotate_amount))

/obj/screen/rotate/alt
	dir = WEST
	rotate_amount = -90
