/datum/weather_ss_map_holder/usasf_point_loma
	name = "New Varadero Map Holder"

	min_time_between_events = 15 MINUTES
	no_weather_turf_icon_state = "strata_clearsky"

	potential_weather_events = list(
		/datum/weather_event/heatwave
	)

/datum/weather_ss_map_holder/usasf_point_loma/should_affect_area(area/A)
	return !CEILING_IS_PROTECTED(A.ceiling, CEILING_METAL)

/datum/weather_ss_map_holder/usasf_point_loma/should_start_event()
	return prob(PROB_WEATHER_NEW_VARADERO)
