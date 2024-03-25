GLOBAL_LIST_EMPTY(weather_notify_objects)

SUBSYSTEM_DEF(weather)
	name   = "Weather"
	wait   = 5 SECONDS
	priority   = SS_PRIORITY_LIGHTING

	// Tracking vars for controller state
	var/is_weather_event = FALSE // Is there a weather event going on right now?
	var/is_weather_event_starting = FALSE // Is there a weather event starting right now?
	var/controller_state_lock = FALSE // Used to prevent double-calls of important methods. Is set anytime
											// the controller enters a proc that significantly modifies its state
	var/current_event_start_time // Self explanatory

	COOLDOWN_DECLARE(last_event_end_time)
	COOLDOWN_DECLARE(last_event_check_time)

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

	/// List of master areas to use for applying effects
	var/list/area/weather_areas = list()

/datum/controller/subsystem/weather/Initialize(start_timeofday)
	// Set up our map delegate datum for supported maps
	// The ONLY place where things should depend on map_tag
	// in the weather subsystem
	if(SSmapping.configs[GROUND_MAP].weather_holder)
		var/weathertype = SSmapping.configs[GROUND_MAP].weather_holder
		map_holder = new weathertype
		setup_weather_areas()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/weather/proc/setup_weather_areas()
	weather_areas = list()
	for(var/area/A in GLOB.all_areas)
		if(A.weather_enabled && map_holder.should_affect_area(A))
			weather_areas += A

	curr_master_turf_overlay = new /obj/effect/weather_vfx_holder
	if (map_holder.no_weather_turf_icon_state)
		curr_master_turf_overlay.icon_state = map_holder.no_weather_turf_icon_state
	else
		curr_master_turf_overlay.icon_state = ""

/datum/controller/subsystem/weather/proc/force_weather_holder(weather_holder)
	if(weather_holder)
		if(istext(weather_holder)) weather_holder = text2path(weather_holder)
		if(ispath(weather_holder))
			map_holder = new weather_holder
			setup_weather_areas()

/datum/controller/subsystem/weather/stat_entry(msg)
	var/time_left = 0
	if(weather_event_instance?.length)
		time_left = (current_event_start_time + weather_event_instance.length - world.time) / 10
	if (is_weather_event && weather_event_instance.display_name)
		msg = "P: Current event: [weather_event_instance.display_name] - [time_left] seconds left"
	else if (is_weather_event)
		msg = "P: Current event of unknown type ([weather_event_type]) - [time_left] seconds left"
	else
		msg = "P: No event"
	return ..()

/datum/controller/subsystem/weather/fire()
	if (!map_holder || controller_state_lock)
		return

	// End our current event if we must
	if (is_weather_event && current_event_start_time + weather_event_instance.length < world.time)
		end_weather_event()
		return

	if(weather_event_instance?.has_process)
		weather_event_instance.handle_weather_process()

	// If there's a weather event, return
	if (is_weather_event)
		return

	// Check if we have had enough time between events
	if (!COOLDOWN_FINISHED(src, last_event_end_time) || !COOLDOWN_FINISHED(src, last_event_check_time))
		return

	// Each map decides its own logic for implementing weather events.
	if (!is_weather_event_starting)
		COOLDOWN_START(src, last_event_check_time, map_holder.min_time_between_checks)
		if(map_holder.should_start_event())
			setup_weather_event(map_holder.get_new_event())



/// Startup of an arbitrary weather event if none is running. Returns TRUE if successful.
/datum/controller/subsystem/weather/proc/setup_weather_event(event_typepath)
	. = FALSE
	if(!map_holder || is_weather_event || is_weather_event_starting)
		return
	is_weather_event_starting = TRUE
	weather_event_type = event_typepath
	map_holder.weather_warning(weather_event_type)
	addtimer(CALLBACK(src, PROC_REF(start_weather_event)), map_holder.warn_time)
	return TRUE

// Adjust our state to indicate that we're starting a new event
// and tell all the mobs we care about to check back in to realize there's
// now weather.
/datum/controller/subsystem/weather/proc/start_weather_event()
	SHOULD_NOT_SLEEP(TRUE)
	if (controller_state_lock)
		return

	// Set up our instance of the weather event
	weather_event_instance = new weather_event_type()

	if(!weather_event_instance)
		message_admins(SPAN_BLUE("Bad weather event of type [weather_event_type]."))
		return

	weather_event_instance.start_weather_event()

	// Maintain the controller state
	controller_state_lock = TRUE
	is_weather_event_starting = FALSE

	is_weather_event = TRUE
	current_event_start_time = world.time

	if (weather_event_instance.display_name)
		message_admins(SPAN_BLUE("Weather Event of type [weather_event_instance.display_name] starting with duration of [DisplayTimeText(weather_event_instance.length)]."))
	else
		message_admins(SPAN_BLUE("Weather Event of unknown type [weather_event_type] starting with duration of [DisplayTimeText(weather_event_instance.length)]."))

	curr_master_turf_overlay.icon_state = weather_event_instance.turf_overlay_icon_state
	curr_master_turf_overlay.alpha = weather_event_instance.turf_overlay_alpha
	for(var/area/area as anything in weather_areas)
		area.overlays += curr_master_turf_overlay

	update_mobs_weather()
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_WEATHER_CHANGE)
	controller_state_lock = FALSE

// Adjust our state to indicate that the weather event that WAS running is over
// and tell all the mobs we care about to check back in to realize there's
// no more weather.
/datum/controller/subsystem/weather/proc/end_weather_event()
	SHOULD_NOT_SLEEP(TRUE)

	if (controller_state_lock)
		return
	controller_state_lock = TRUE

	if (weather_event_instance.display_name)
		message_admins(SPAN_BLUE("Weather Event of type [weather_event_instance.display_name] ending after [DisplayTimeText(world.time - current_event_start_time)]."))
	else
		message_admins(SPAN_BLUE("Weather Event of unknown type [weather_event_type] ending after [DisplayTimeText(world.time - current_event_start_time)]."))

	for(var/area/area as anything in weather_areas)
		area.overlays -= curr_master_turf_overlay

	if (map_holder.no_weather_turf_icon_state)
		curr_master_turf_overlay.icon_state = map_holder.no_weather_turf_icon_state
	else
		curr_master_turf_overlay.icon_state = ""

	// Controller state
	if (weather_event_instance)
		qdel(weather_event_instance)
		weather_event_instance = null

	is_weather_event = FALSE
	update_mobs_weather()
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_WEATHER_CHANGE)
	controller_state_lock = FALSE
	COOLDOWN_START(src, last_event_end_time, map_holder.min_time_between_events)

/datum/controller/subsystem/weather/proc/update_mobs_weather()
	for(var/mob/mob as anything in GLOB.living_mob_list)
		mob?.client?.soundOutput?.update_ambience(null, null, TRUE)
		if(!is_weather_event)
			mob.clear_fullscreen("weather")

/obj/effect/weather_vfx_holder
	name = "weather vfx holder"
	icon = 'icons/effects/weather.dmi'
	invisibility = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = WEATHER_LAYER

/obj/effect/weather_vfx_holder/rain
	icon_state = "strata_storm"
	alpha = 50
