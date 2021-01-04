//// Sorokyne's map holder

/datum/weather_ss_map_holder/sorokyne
    name = "Sorokyne Map Holder"

    min_time_between_events = MINUTES_20
    no_weather_turf_icon_state = "strata_clearsky"

/datum/weather_ss_map_holder/sorokyne/New()
    ..()
    potential_weather_events += /datum/weather_event/snow
    potential_weather_events += /datum/weather_event/snowstorm
    potential_weather_events += /datum/weather_event/blizzard

/datum/weather_ss_map_holder/sorokyne/should_affect_area(var/area/A)
    return (A.temperature <= SOROKYNE_TEMPERATURE)

/datum/weather_ss_map_holder/sorokyne/should_start_event()
    if (prob(PROB_WEATHER_SOROKYNE))
        return TRUE
    return FALSE

/datum/weather_ss_map_holder/sorokyne/weather_warning()
    for (var/obj/structure/machinery/weather_siren/WS in weather_notify_objects)
        WS.weather_warning()
