/**
 * A vehicle's crew HUD. A small maptext readout of speed/acceleration/gear/temperature/battery/fuel,
 * shown above the driver and gunner's hand slots while they're seated.
 *
 * Laid out as a 3x3 grid of separate screen objects, plus a Cruise Control readout above SPEED:
 *    CC
 *   SPEED        .        TEMP
 *     .        GEARS      FUEL
 *   ACCEL        .      BATTERY
 *
 * Speed/acceleration/gears/cruise control show "N/A" for a vehicle that doesn't use the
 * gear-transmission movement model (uses_gear_transmission FALSE). Temperature/battery/fuel are
 * independent of that and show real data whenever the matching hardpoint is actually installed.
 */
/atom/movable/screen/tank_crew_hud
	icon = null
	icon_state = null
	plane = HUD_PLANE
	layer = HUD_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	maptext_width = 90
	maptext_height = 20
	// Opts out of F12's clear_screen() wipe. crew_hud_loop() below decides visibility itself,
	// avoiding a flicker on style transitions that shouldn't touch the HUD at all.
	clear_with_screen = FALSE

/**
 * Builds one fresh set of the 7 grid-cell screen objects making up the crew HUD. A new set is made
 * every time a seat is taken, so the driver and gunner each get their own.
 */
/obj/vehicle/multitile/proc/build_crew_hud_elements()
	// Rows sit 14px apart within tile 3 to pack the grid tighter vertically. The right column
	// sits a full tile further out than the middle one to avoid clipping the gear column's maptext.
	var/atom/movable/screen/tank_crew_hud/cc_elem = new()
	cc_elem.screen_loc = "WEST+5:16,3:31"

	var/atom/movable/screen/tank_crew_hud/speed_elem = new()
	speed_elem.screen_loc = "WEST+5:16,3:17"

	var/atom/movable/screen/tank_crew_hud/temp_elem = new()
	temp_elem.screen_loc = "WEST+8:16,3:17"

	var/atom/movable/screen/tank_crew_hud/gear_elem = new()
	gear_elem.screen_loc = "WEST+6:16,3:3"
	gear_elem.maptext_width = 160

	var/atom/movable/screen/tank_crew_hud/fuel_elem = new()
	fuel_elem.screen_loc = "WEST+8:16,3:3"

	var/atom/movable/screen/tank_crew_hud/accel_elem = new()
	accel_elem.screen_loc = "WEST+5:16,3:-11"

	var/atom/movable/screen/tank_crew_hud/battery_elem = new()
	battery_elem.screen_loc = "WEST+8:16,3:-11"

	return list(
		"cc" = cc_elem,
		"speed" = speed_elem,
		"temp" = temp_elem,
		"gear" = gear_elem,
		"fuel" = fuel_elem,
		"accel" = accel_elem,
		"battery" = battery_elem,
	)

/**
 * Creates and shows this vehicle's crew HUD to a freshly-seated driver or gunner. No-op for a
 * headless/SSD crewman.
 */
/obj/vehicle/multitile/proc/start_crew_hud(mob/living/M, seat)
	if(!M.client)
		return
	var/list/elements = build_crew_hud_elements()
	crew_hud_elements[seat] = elements
	for(var/key in elements)
		M.client.add_to_screen(elements[key])
	update_crew_hud(M, seat)
	INVOKE_ASYNC(src, PROC_REF(crew_hud_loop), M, seat, elements)

/// Tears down the crew HUD created by start_crew_hud() the instant that seat is vacated.
/obj/vehicle/multitile/proc/stop_crew_hud(mob/living/M, seat)
	var/list/elements = crew_hud_elements[seat]
	if(!elements)
		return
	for(var/key in elements)
		var/atom/movable/screen/element = elements[key]
		M.client?.remove_from_screen(element)
		qdel(element)
	crew_hud_elements -= seat

/**
 * Self-rescheduling refresh loop for one seat's crew HUD, paced at CREW_HUD_UPDATE_INTERVAL. Ends
 * itself once this element set stops being crew_hud_elements[seat].
 *
 * Also polls M's F12 HUD style each tick, adding/removing the elements from screen on the
 * transitions that matter: hidden at HUD_STYLE_NOHUD, shown again at HUD_STYLE_STANDARD.
 */
/obj/vehicle/multitile/proc/crew_hud_loop(mob/living/M, seat, list/elements)
	var/hud_currently_shown = TRUE
	while(crew_hud_elements[seat] == elements)
		sleep(CREW_HUD_UPDATE_INTERVAL)
		if(crew_hud_elements[seat] != elements)
			return

		var/should_show = M.hud_used ? (M.hud_used.hud_version != HUD_STYLE_NOHUD) : TRUE
		if(should_show != hud_currently_shown)
			hud_currently_shown = should_show
			for(var/key in elements)
				if(hud_currently_shown)
					M.client?.add_to_screen(elements[key])
				else
					M.client?.remove_from_screen(elements[key])

		if(hud_currently_shown)
			update_crew_hud(M, seat)

/**
 * Rebuilds one seat's crew HUD grid cells from live gear/engine/battery/fuel state. No-op if that
 * seat's HUD isn't currently up.
 *
 * Speed: current_speed vs. this gear's reachable ceiling. White normally, yellow above
 * DRIFT_MIN_SPEED_FRACTION (80%) of that ceiling - the same threshold that gates whether a 90-degree
 * turn drifts instead of scrubbing speed - red above 95%. "N/A" if this vehicle doesn't use
 * gear-transmission movement.
 * Acceleration: this gear's live computed torque. "N/A" if not gear-transmission.
 * Gears: every entry in GLOB.vehicle_gear_order, current_gear shown bold and yellow. "N/A" if not gear-transmission.
 * Temperature: 0-200 scale. White under 80%, yellow under 100%, red beyond. "N/A" with no Engine installed.
 * Battery: white while charging, yellow while draining, red under 20%. "N/A" with no Battery installed.
 * Fuel: white normally, yellow under 40%, red under 20%. "N/A" with no Fuel Tank installed.
 *
 * Speed/acceleration show in km/h unless M's VEHICLE_UNITS_MPH preference is set, in which case
 * both switch to mph. Display units only.
 *
 * Cruise Control: only rendered under Complex acceleration, blank otherwise. White "CC: OFF" while
 * disabled, red "CC: <speed><unit>" while enabled. "N/A" if not gear-transmission. The reverse sign
 * is derived from current_gear == "R" rather than the stored (always non-negative) target speed.
 */
/obj/vehicle/multitile/proc/update_crew_hud(mob/living/M, seat)
	var/list/elements = crew_hud_elements[seat]
	if(!elements)
		return

	var/use_mph = M.client && (M.client.prefs.toggles_vehicle & VEHICLE_UNITS_MPH)
	var/unit_factor = use_mph ? VEHICLE_HUD_MPH_PER_TILE : VEHICLE_HUD_KMH_PER_TILE
	var/unit_name = use_mph ? "MPH" : "KM/H"

	var/cc_line = ""
	var/cc_color = "white"
	var/speed_line
	var/speed_color = "white"
	var/accel_line
	var/gear_line

	if(!uses_gear_transmission)
		cc_line = "CC: N/A"
		speed_line = "SPD N/A"
		accel_line = "ACC N/A"
		gear_line = "N/A"
	else
		if(!(get_driver_vehicle_prefs() & VEHICLE_SIMPLE_ACCELERATION))
			if(cruise_control_enabled)
				cc_color = "red"
				var/cc_sign = (current_gear == "R") ? "-" : ""
				cc_line = "CC: [cc_sign][round(cruise_control_target_speed * unit_factor, 0.1)][unit_name]"
			else
				cc_line = "CC: OFF"

		var/list/stats = get_current_gear_stats()
		var/traction_scale = get_effective_traction()
		var/part_scale = get_part_condition_scale()
		var/gear_max_speed = get_gear_max_speed(stats, traction_scale, part_scale)

		if(gear_max_speed > 0)
			if(current_speed > gear_max_speed * 0.95)
				speed_color = "red"
			else if(current_speed > gear_max_speed * DRIFT_MIN_SPEED_FRACTION)
				speed_color = "yellow"
		speed_line = "[round(current_speed * unit_factor, 0.1)]/[round(gear_max_speed * unit_factor, 0.1)] [unit_name]"

		var/computed_torque = get_gear_computed_torque(stats, traction_scale, part_scale)
		accel_line = "[round(computed_torque * unit_factor, 0.1)] [unit_name]²"

		gear_line = ""
		for(var/gear in GLOB.vehicle_gear_order)
			gear_line += (gear == current_gear) ? "<span style='color:yellow;font-weight:bold'>[gear]</span> " : "[gear] "

	var/obj/item/hardpoint/engine/engine_hardpoint = get_engine_hardpoint()
	var/temp_line = "TEMP N/A"
	var/temp_color = "white"
	if(engine_hardpoint)
		var/temp_percent = engine_hardpoint.get_temperature_percent()
		temp_line = "TEMP [round(temp_percent)]%"
		if(temp_percent >= 100)
			temp_color = "red"
		else if(temp_percent >= 80)
			temp_color = "yellow"

	var/obj/item/hardpoint/battery/battery_hardpoint = get_battery_hardpoint()
	var/battery_line = "BATT N/A"
	var/battery_color = "white"
	if(battery_hardpoint)
		var/charge_percent = battery_hardpoint.get_charge_percent()
		battery_line = "BATT [round(charge_percent)]%"
		if(charge_percent < 20)
			battery_color = "red"
		else if(!engine_on)
			battery_color = "yellow"

	var/obj/item/hardpoint/fuel_tank/fuel_hardpoint = get_fuel_tank_hardpoint()
	var/fuel_line = "FUEL N/A"
	var/fuel_color = "white"
	if(fuel_hardpoint)
		var/fuel_percent = fuel_hardpoint.get_fuel_percent()
		fuel_line = "FUEL [round(fuel_percent)]%"
		if(fuel_percent < 20)
			fuel_color = "red"
		else if(fuel_percent < 40)
			fuel_color = "yellow"

	var/atom/movable/screen/cc_elem = elements["cc"]
	cc_elem.maptext = cc_line ? SMALL_FONTS_COLOR(7, cc_line, cc_color) : ""
	var/atom/movable/screen/speed_elem = elements["speed"]
	speed_elem.maptext = SMALL_FONTS_COLOR(7, speed_line, speed_color)
	var/atom/movable/screen/accel_elem = elements["accel"]
	accel_elem.maptext = SMALL_FONTS_COLOR(7, accel_line, "white")
	var/atom/movable/screen/gear_elem = elements["gear"]
	gear_elem.maptext = SMALL_FONTS_COLOR(7, gear_line, "white")
	var/atom/movable/screen/temp_elem = elements["temp"]
	temp_elem.maptext = SMALL_FONTS_COLOR(7, temp_line, temp_color)
	var/atom/movable/screen/fuel_elem = elements["fuel"]
	fuel_elem.maptext = SMALL_FONTS_COLOR(7, fuel_line, fuel_color)
	var/atom/movable/screen/battery_elem = elements["battery"]
	battery_elem.maptext = SMALL_FONTS_COLOR(7, battery_line, battery_color)
