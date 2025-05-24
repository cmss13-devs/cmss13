//// Sorokyne's map holder

/datum/weather_ss_map_holder/sorokyne
	name = "Sorokyne Map Holder"

	min_time_between_events = 30 MINUTES
	no_weather_turf_icon_state = "strata_clearsky"

	potential_weather_events = list(
		/datum/weather_event/soro/light_rain,
		/datum/weather_event/soro/monsoon,
		/datum/weather_event/soro/very_light_rain,
	)

/datum/weather_ss_map_holder/sorokyne/should_affect_area(area/A)
	return ((A.temperature <= TROPICAL_TEMP) && !CEILING_IS_PROTECTED(A.ceiling, CEILING_GLASS))

/datum/weather_ss_map_holder/sorokyne/should_start_event()
	if (prob(PROB_WEATHER_SOROKYNE))
		return TRUE
	return FALSE

/datum/weather_ss_map_holder/sorokyne/weather_warning(datum/weather_event/incoming_event)
	if(incoming_event.should_sound_weather_alarm)
		for (var/obj/structure/machinery/weather_siren/WS in GLOB.weather_notify_objects)
			WS.weather_warning()
	else
		..()
