#define SENSOR_MODE "sensor"
#define NIGHTVISION_MODE "nightvision"

/obj/item/hardpoint/support/sensor_array
	name = "\improper AQ-133 Acquisition System"
	desc = "A short-range Air-to-Ground LIDAR target acquisition system designed to actively track and profile non-IFF signatures in a localized range of detection."
	icon = 'icons/obj/vehicles/hardpoints/blackfoot.dmi'
	icon_state = "radar"
	disp_icon = "blackfoot"
	disp_icon_state = "radar"

	health = 250

	var/active = FALSE

	/// Range of the wallhacks
	var/sensor_radius = 45
	/// weakrefs of xenos temporarily added to the marine minimap
	var/list/minimap_added = list()
	/// current mode, can be either nvg (gives nightvision to the pilot) or sensor (shows xenos on tacmap)
	var/mode = SENSOR_MODE

/obj/item/hardpoint/support/sensor_array/get_icon_image(x_offset, y_offset, new_dir)
	var/obj/vehicle/multitile/blackfoot/blackfoot_owner = owner

	if(!blackfoot_owner)
		return

	var/image/I = image(icon = disp_icon, icon_state = "[disp_icon_state]_[blackfoot_owner.get_sprite_state()]", pixel_x = x_offset, pixel_y = y_offset, dir = new_dir)

	return I

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

/obj/item/hardpoint/support/sensor_array/proc/activate_mode(mode)
	var/obj/vehicle/multitile/blackfoot/blackfoot_owner = owner

	if(!blackfoot_owner)
		return

	var/mob/user = blackfoot_owner.seats[VEHICLE_DRIVER]

	if(!user)
		return

	switch(mode)
		if(SENSOR_MODE)
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

#undef SENSOR_MODE
#undef NIGHTVISION_MODE
