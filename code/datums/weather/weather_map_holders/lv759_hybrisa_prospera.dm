/datum/weather_ss_map_holder/lv759_hybrisa_prospera
	name = "LV-759 Map Holder"

	warn_time = 1 MINUTES
	min_time_between_events = 12 MINUTES
	min_time_between_checks = 0
	min_check_variance = 0

	no_weather_turf_icon_state = "strata_clearsky"

	potential_weather_events = list(
		/datum/weather_event/hybrisa_light_rain,
		/datum/weather_event/hybrisa_very_light_rain,
	)

/datum/weather_ss_map_holder/lv759_hybrisa_prospera/should_affect_area(area/A)
	return !CEILING_IS_PROTECTED(A.ceiling, CEILING_GLASS)

/datum/weather_ss_map_holder/lv759_hybrisa_prospera/should_start_event()
	return prob(PROB_WEATHER_LV759)
