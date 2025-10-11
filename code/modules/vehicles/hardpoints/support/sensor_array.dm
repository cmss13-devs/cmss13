#define SENSOR_MODE "sensor"
#define NIGHTVISION_MODE "nightvision"

#define RADAR_MODE_OFF -1
#define RADAR_MODE_PASSIVE 0
#define RADAR_MODE_ACTIVE 1

#define RADAR_CONTACT_BLANK "contact"
#define RADAR_CONTACT_NEUTRAL "neutral"
#define RADAR_CONTACT_UNKNOWN "unknown"
#define RADAR_CONTACT_FRIENDLY "friendly"
#define RADAR_CONTACT_HOSTILE "hostile"

/obj/item/hardpoint/support/sensor_array
	name = "\improper AQ-133 Acquisition System (WIP)"
	desc = "A short-range Air-to-Ground LIDAR target acquisition system designed to actively track and profile non-IFF signatures in a localized range of detection."
	icon = 'icons/obj/vehicles/hardpoints/blackfoot.dmi'
	icon_state = "radar"
	disp_icon = "blackfoot"
	disp_icon_state = "radar"

	health = 250

	var/active = FALSE
	var/interface_active = FALSE
	var/volume = 25
	var/map_zoom = 200
	var/minimap_shown = TRUE
	var/locking_mode
	var/radar_mode = RADAR_MODE_OFF
	/// Range of the wallhacks
	var/sensor_radius = 45
	/// weakrefs of xenos temporarily added to the marine minimap
	var/list/minimap_added = list()
	/// current mode, can be either nvg (gives nightvision to the pilot) or sensor (shows xenos on tacmap)
	var/mode = SENSOR_MODE
	var/datum/flattened_tacmap/map
	/// List of actively tracked radar contacts. Used to check if a contact blip is being seen for the first time
	var/list/stored_contacts = list()

	var/static/list/radar_modes = list(
		RADAR_MODE_OFF,
		RADAR_MODE_PASSIVE,
		RADAR_MODE_ACTIVE)

	var/contact_alert = TRUE
	var/proximity_alert = TRUE

//	to do list
//
// d


/obj/item/hardpoint/support/sensor_array/get_icon_image(x_offset, y_offset, new_dir)
	var/obj/vehicle/multitile/blackfoot/blackfoot_owner = owner

	if(!blackfoot_owner)
		return

	var/image/icon = image(icon = disp_icon, icon_state = "[disp_icon_state]_[blackfoot_owner.get_sprite_state()]", pixel_x = x_offset, pixel_y = y_offset, dir = new_dir)

	return icon

/obj/item/hardpoint/support/sensor_array/proc/toggle(mode)
	if(!active)
		activate_mode(mode)
	else if(src.mode == mode)
		deactivate_mode(mode)
	else
		deactivate_mode(src.mode)
		activate_mode(mode)

	src.mode = mode

/obj/item/hardpoint/support/sensor_array/proc/deactivate_mode(mode)
	var/obj/vehicle/multitile/blackfoot/blackfoot_owner = owner

	if(!blackfoot_owner)
		return

	var/mob/user = blackfoot_owner.seats[VEHICLE_DRIVER]

	if(!user)
		return

	switch(mode)
		if(SENSOR_MODE)
			STOP_PROCESSING(SSslowobj, src)
			for(var/datum/weakref/xeno as anything in minimap_added)
				SSminimaps.remove_marker(xeno.resolve())
				minimap_added.Remove(xeno)
			active = FALSE
		if(NIGHTVISION_MODE)
			deactivate_nightvision(user)

/obj/item/hardpoint/support/sensor_array/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VehicleRadar", "AQ-133 'Reaper' Targeting System", 900, 600)
		ui.open()

/obj/item/hardpoint/support/sensor_array/ui_status(mob/user)
	if(!(isatom(src)))
		return UI_INTERACTIVE

	if(user in owner.interior.get_passengers())
		return UI_INTERACTIVE
	else
		return UI_CLOSE

/obj/item/hardpoint/support/sensor_array/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	switch (action)
		if("power")
			interface_active = !interface_active
			if(interface_active)
				playsound(src, 'sound/machines/tcomms_on.ogg', 10, FALSE)
		if("mode")
			minimap_shown = !minimap_shown
		if("zoom_in")
			return
		if("zoom_out")
			return
		if("zone_lock")
			return
		if("target_lock")
			return
		if("volume")
			var/volume_change = params["volume"]
			switch(volume_change)
				if("up")
					volume = volume + 5
				if("down")
					volume = volume - 5
				if("mute")
					volume = 0
			volume = clamp(volume, 0, 25)
		if("switch_radar_mode")
			radar_mode = next_in_list(radar_mode, radar_modes)
		if("proximity_alert")
			proximity_alert = !proximity_alert
		if("contact_alert")
			contact_alert = !contact_alert
		if("manual_pulse")
			tgui_interact(ui.user)
		if("automatic_pulse")
			return
		if("pulse_control")
			var/pulse_speed = params["pulse_change"]
			switch(pulse_speed)
				if("up")
					pulse_speed = pulse_speed + 5
				if("down")
					pulse_speed = pulse_speed - 5
				if("mute")
					pulse_speed = 0
			pulse_speed = clamp(pulse_speed, 0, 25)


	var/click_sound = pick(
		'sound/machines/terminal_button01.ogg',
		'sound/machines/terminal_button04.ogg',
		'sound/machines/terminal_button05.ogg')

	playsound(src, click_sound, volume, FALSE)

/obj/item/hardpoint/support/sensor_array/ui_static_data(mob/user)
	var/list/data = list()

	data["blackfoot_icon"] = 'icons/ui_icons/map_blips_extra_large.dmi'
	data["radar_blip_icons"] = 'icons/ui_icons/map_blips_vehicle_radar.dmi'
	for(var/datum/space_level/map as anything in SSmapping.z_list)
		if(map.z_value == 2)
			data["map_size_x"] = map.bounds[MAP_MAXX]
			data["map_size_y"] = map.bounds[MAP_MAXY]

	return data

/obj/item/hardpoint/support/sensor_array/ui_data(mob/user)
	var/list/data = list()

	map = get_unannounced_tacmap_data_png(FACTION_MARINE)
	if(map)
		data["radar_map"] = map.flat_tacmap
	data["interface_active"] = interface_active
	data["minimap_shown"] = minimap_shown
	data["blackfoot_dir"] = owner.dir
	data["blackfoot_x"] = owner.x
	data["blackfoot_y"] = owner.y
	data["radar_mode"] = radar_mode

	if(radar_mode != RADAR_MODE_OFF)
		data = gather_radar_contact_data(data)

	return data

/obj/item/hardpoint/support/sensor_array/proc/on_update_sight(mob/user)
	SIGNAL_HANDLER

	user.see_in_dark = 12
	user.lighting_alpha = 100
	user.sync_lighting_plane_alpha()

/obj/item/hardpoint/support/sensor_array/proc/deactivate_nightvision(mob/user)
	SIGNAL_HANDLER
	user.remove_client_color_matrix("nvg_visor", 1 SECONDS)
	user.clear_fullscreen("nvg_visor", 0.5 SECONDS)
	user.clear_fullscreen("nvg_visor_blur", 0.5 SECONDS)

	UnregisterSignal(user, COMSIG_HUMAN_POST_UPDATE_SIGHT)
	UnregisterSignal(user, COMSIG_MOB_CHANGE_VIEW)

	user.update_sight()
	STOP_PROCESSING(SSobj, src)
	active = FALSE

/obj/item/hardpoint/support/sensor_array/proc/gather_radar_contact_data(list/data)

	for(var/mob/living/carbon/xenomorph/current_xeno as anything in GLOB.living_xeno_list)
		var/turf/xeno_turf = get_turf(current_xeno)
		var/area/xeno_area = get_area(current_xeno)

		if(!is_ground_level(xeno_turf.z))
			continue

		//var/datum/weakref/xeno_weakref = WEAKREF(current_xeno)

		if(get_dist(src, current_xeno) >= sensor_radius)
			if(current_xeno in stored_contacts)
				stored_contacts -= current_xeno
			continue

		if(xeno_area.ceiling > CEILING_GLASS)
			continue

		data["contact_data"] += list(list(
			"name" = current_xeno.name,
			"icon" = RADAR_CONTACT_HOSTILE,
			"position_x" = current_xeno.x,
			"position_y" = current_xeno.y,
			"contact_ref" = REF(current_xeno)
		))

		if(!(current_xeno in stored_contacts) && contact_alert)
			stored_contacts += current_xeno
			notify_radar_contact(current_xeno)

	return data

/obj/item/hardpoint/support/sensor_array/proc/notify_radar_contact(mob/contact)
	var/obj/vehicle/multitile/blackfoot/blackfoot_owner = owner

	if(!blackfoot_owner)
		return

	var/mob/user = blackfoot_owner.seats[VEHICLE_DRIVER]

	playsound_client(user.client, 'sound/vehicles/vtol/radar_new_contact.ogg', src, volume, FALSE)

/obj/item/hardpoint/support/sensor_array/proc/activate_mode(mode)
	var/obj/vehicle/multitile/blackfoot/blackfoot_owner = owner

	if(!blackfoot_owner)
		return

	var/mob/user = blackfoot_owner.seats[VEHICLE_DRIVER]

	if(!user)
		return

	switch(mode)
		if(SENSOR_MODE)
			tgui_interact(user)
			START_PROCESSING(SSslowobj, src)
		if(NIGHTVISION_MODE)
			var/matrix_color = NV_COLOR_GREEN
			RegisterSignal(user, COMSIG_HUMAN_POST_UPDATE_SIGHT, PROC_REF(on_update_sight))
			if(user.client?.prefs?.night_vision_preference)
				matrix_color = user.client.prefs.nv_color_list[user.client.prefs.night_vision_preference]
			user.add_client_color_matrix("nvg_visor", 99, color_matrix_multiply(color_matrix_saturation(0), color_matrix_from_string(matrix_color)))
			user.overlay_fullscreen("nvg_visor", /atom/movable/screen/fullscreen/flash/noise/nvg)
			user.overlay_fullscreen("nvg_visor_blur", /atom/movable/screen/fullscreen/brute/nvg, 3)
			user.update_sight()
			RegisterSignal(user, COMSIG_MOB_CHANGE_VIEW, PROC_REF(deactivate_nightvision))
			START_PROCESSING(SSobj, src)

	active = TRUE

/obj/item/hardpoint/support/sensor_array/process(delattime)
	var/turf/blackfoot_turf = get_turf(src)
	var/obj/vehicle/multitile/blackfoot/blackfoot_owner = owner

	if(!blackfoot_owner)
		return

	for(var/atom/movable/screen/blackfoot/custom_screen as anything in blackfoot_owner.custom_hud)
		custom_screen.update(blackfoot_owner.fuel, blackfoot_owner.max_fuel, blackfoot_owner.health, blackfoot_owner.maxhealth, blackfoot_owner.battery, blackfoot_owner.max_battery)

	if((health <= 0) || !blackfoot_owner.visible_in_tacmap || (!is_ground_level(blackfoot_turf.z) && mode == SENSOR_MODE))
		return

	blackfoot_owner.battery = max(0, blackfoot_owner.battery - delattime)

	if(health <= 0 || blackfoot_owner.battery <= 0)
		deactivate_mode(mode)
		return

	if(mode != SENSOR_MODE)
		return

	for(var/mob/living/carbon/xenomorph/current_xeno as anything in GLOB.living_xeno_list)
		var/turf/xeno_turf = get_turf(current_xeno)
		if(!is_ground_level(xeno_turf.z))
			continue

		var/datum/weakref/xeno_weakref = WEAKREF(current_xeno)

		if(get_dist(src, current_xeno) <= sensor_radius)
			if(xeno_weakref in minimap_added)
				continue

			SSminimaps.remove_marker(current_xeno)
			current_xeno.add_minimap_marker(MINIMAP_FLAG_USCM|MINIMAP_FLAG_XENO)
			minimap_added += xeno_weakref
		else if(xeno_weakref in minimap_added)
			SSminimaps.remove_marker(current_xeno)
			current_xeno.add_minimap_marker()
			minimap_added -= xeno_weakref

#undef RADAR_MODE_OFF
#undef RADAR_MODE_PASSIVE
#undef RADAR_MODE_ACTIVE

#undef SENSOR_MODE
#undef NIGHTVISION_MODE
