var/list/weather_notify_objects = list()

SUBSYSTEM_DEF(weather)
	name          = "Weather"
	wait          = 5 SECONDS
	priority      = SS_PRIORITY_LIGHTING
	flags         = SS_NO_TICK_CHECK

	// Tracking vars for controller state
	var/is_weather_event = FALSE			// Is there a weather event going on right now?
	var/is_weather_event_starting = FALSE	// Is there a weather event starting right now?
	var/controller_state_lock = FALSE		// Used to prevent double-calls of important methods. Is set anytime
											// the controller enters a proc that significantly modifies its state
	var/current_event_start_time			// Self explanatory
	var/last_event_end_time					// Self explanatory

	//// Important vars

	// Map delegate object that handles per-map config
	// and other map-dependent code
	var/datum/weather_ss_map_holder/map_holder

	// VFX delegate object instanced into all relevant turfs
	var/obj/effect/weather_vfx_holder/curr_master_turf_overlay

	// Current weather event type
	var/weather_event_type

	// If applicable, INSTANCE of weather_event_type
	// Holds necessary data for the current weather event
	var/datum/weather_event/weather_event_instance

/datum/controller/subsystem/weather/Initialize(start_timeofday)
	// Set up our map delegate datum for supported maps
	// The ONLY place where things should depend on map_tag
	// in the weather subsystem
	if(SSmapping.configs[GROUND_MAP].weather_holder)
		var/weathertype = SSmapping.configs[GROUND_MAP].weather_holder
		map_holder = new weathertype

	// Disable the weather subsystem on maps that don't currently implement it
	if (!map_holder)
		flags |= SS_NO_FIRE
		return

	var/list/weather_areas = list()

	// Each map defines which areas it wants to define as weather areas.
	for (var/area/A in all_areas)
		if (map_holder.should_affect_area(A))
			add_as_weather_area(A, weather_areas)

	curr_master_turf_overlay = new /obj/effect/weather_vfx_holder
	if (map_holder.no_weather_turf_icon_state)
		curr_master_turf_overlay.icon_state = map_holder.no_weather_turf_icon_state
	else
		curr_master_turf_overlay.icon_state = ""

	// We have successfully built weather areas, now place our effect holder
	for (var/area/A in weather_areas)
		for (var/turf/T in A)
			if (istype(T, /turf/open) && !(curr_master_turf_overlay in T.vis_contents))
				T.vis_contents += curr_master_turf_overlay

	. = ..()

/datum/controller/subsystem/weather/stat_entry(msg)
	if (is_weather_event && weather_event_instance.display_name)
		msg = "P: Current event: [weather_event_instance.display_name]"
	else if (is_weather_event)
		msg = "P: Current event of unknown type ([weather_event_type])"
	else
		msg = "P: No event"
	return ..()

/datum/controller/subsystem/weather/fire()
	if (controller_state_lock)
		return

	// End our current event if we must
	if (is_weather_event && current_event_start_time + weather_event_instance.length < world.time)
		end_weather_event()
		return

	// If there's a weather event, return
	if (is_weather_event)
		return

	// Check if we have had enough time between events
	if (last_event_end_time + map_holder.min_time_between_events > world.time)
		return

	// Each map decides its own logic for implementing weather events.
	if (!is_weather_event_starting && map_holder.should_start_event())
		// Set up controller state
		is_weather_event_starting = TRUE
		weather_event_type = map_holder.get_new_event()

		// Tell the map_holder we're starting
		map_holder.weather_warning(weather_event_type)

		addtimer(CALLBACK(src, .proc/start_weather_event), map_holder.warn_time)


// Adjust our state to indicate that we're starting a new event
// and tell all the mobs we care about to check back in to realize there's
// now weather.
/datum/controller/subsystem/weather/proc/start_weather_event()
	if (controller_state_lock)
		return

	// Set up our instance of the weather event
	weather_event_instance = new weather_event_type()

	if(!weather_event_instance)
		message_admins(SPAN_BLUE("Bad weather event of type [weather_event_type]."))
		return

	// Maintain the controller state
	controller_state_lock = TRUE
	is_weather_event_starting = FALSE

	is_weather_event = TRUE
	current_event_start_time = world.time

	if (weather_event_instance.display_name)
		message_admins(SPAN_BLUE("Weather Event of type [weather_event_instance.display_name] starting with duration of [weather_event_instance.length] ds."))
	else
		message_admins(SPAN_BLUE("Weather Event of unknown type [weather_event_type] starting with duration of [weather_event_instance.length] ds."))

	if (weather_event_instance.turf_overlay_icon_state)
		curr_master_turf_overlay.icon_state = weather_event_instance.turf_overlay_icon_state

	update_mobs()
	controller_state_lock = FALSE

// Adjust our state to indicate that the weather event that WAS running is over
// and tell all the mobs we care about to check back in to realize there's
// no more weather.
/datum/controller/subsystem/weather/proc/end_weather_event()

	if (controller_state_lock)
		return
	controller_state_lock = TRUE

	if (weather_event_instance.display_name)
		message_admins(SPAN_BLUE("Weather Event of type [weather_event_instance.display_name] ending after [weather_event_instance.length] ds."))
	else
		message_admins(SPAN_BLUE("Weather Event of unknown type [weather_event_type] ending after [weather_event_instance.length] ds."))

	if (map_holder.no_weather_turf_icon_state)
		curr_master_turf_overlay.icon_state = map_holder.no_weather_turf_icon_state
	else
		curr_master_turf_overlay.icon_state = ""

	// Controller state
	if (weather_event_instance)
		qdel(weather_event_instance)
		weather_event_instance = null

	is_weather_event = FALSE
	update_mobs()
	controller_state_lock = FALSE
	last_event_end_time = world.time


// Enqueue areas
/datum/controller/subsystem/weather/proc/add_as_weather_area(var/area/A, var/list/weather_areas)
	if (istype(A, /area/space) || !A.weather_enabled)
		return

	weather_areas += A
	for (var/area/relatedA in A.related)
		weather_areas += relatedA

// Check whether or not a given atom should be affected by weather.
// Uses a switch statement on map_tag to hand the execution off to
// map-dependent logic.
/datum/controller/subsystem/weather/proc/weather_affects_check(var/atom/A)
	return map_holder.should_affect_atom(A)


/datum/controller/subsystem/weather/proc/update_mobs()
	// Update weather for living mobs
	for (var/i in (GLOB.alive_human_list + GLOB.living_xeno_list))
		var/mob/living/L = i
		L.update_weather()

/obj/effect/weather_vfx_holder
	name = "weather vfx holder"
	icon = 'icons/effects/weather.dmi'
	invisibility = 0
	mouse_opacity = 0
	layer = ABOVE_MOB_LAYER
