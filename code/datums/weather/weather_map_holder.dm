// Delegate object that holds all the map-dependent pieces of the
// One of these is instanced into the weather subsystem when it's initialized
// based on the current map_tag (should be the only map_tag dependent piece of code)

/datum/weather_ss_map_holder
    var/name = "set this" // For VV

    // Weather SS configuration options
    var/min_time_between_events = 5 MINUTES // Self explanatory
    var/warn_time = 30 SECONDS          // Warning time between the call to
    var/no_weather_turf_icon_state = "" // Icon state to set on the global VFX holder
                                        // when there's no weather.
    var/list/potential_weather_events   // List of types of possible weather events


/datum/weather_ss_map_holder/New()
    potential_weather_events = list()

// Should the weather for this map include the passed area?
/datum/weather_ss_map_holder/proc/should_affect_area(var/area/A)
    log_debug("Weather subsystem map holder [src] is improperly configured. Code: WSSMH01")
    return FALSE

// Use our current area to decide whether or not we should affect a given atom
/datum/weather_ss_map_holder/proc/should_affect_atom(var/atom/A)
    if (!istype(A))
        return FALSE

    var/area/target_area = get_area(A)
    return should_affect_area(target_area)

// Should we start an event? This just deals with the logic that an event is starting
// period, nothing to do with what the type of the event will be when its
// eventually chosen
/datum/weather_ss_map_holder/proc/should_start_event()
    log_debug("Weather subsystem map holder [src] is improperly configured. Code: WSSMH02")
    return FALSE

// Return a type that can be initialized into the next weather event.
// Feel free to override this
/datum/weather_ss_map_holder/proc/get_new_event()
    if (potential_weather_events && potential_weather_events.len != 0)
        return pick(potential_weather_events)
    else
        log_debug("Weather subsystem map holder [src] is improperly configured. Code: WSSMH03")
        return null

// Called whenever the weather SS decides to start an event, but
// warn_time deciseconds before it actually starts
// (think weather sirens on sorokyne)
// This can do nothing safely, so you don't have to override it
/datum/weather_ss_map_holder/proc/weather_warning(var/event_type)
    return
