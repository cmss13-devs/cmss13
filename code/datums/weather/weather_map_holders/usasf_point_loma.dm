/datum/weather_ss_map_holder/point_loma
	name = "Point_Loma Map Holder"


	min_time_between_events = 15 MINUTES

	warn_time = 0 SECONDS //No time between warning and effect

	potential_weather_events = list(
		/datum/weather_event/point_loma/heat,
		/datum/weather_event/point_loma/heat/heat_wave,
	)

/datum/weather_ss_map_holder/point_loma/should_affect_area(area/A)
	return !CEILING_IS_PROTECTED(A.ceiling, CEILING_GLASS)

/datum/weather_ss_map_holder/point_loma/should_start_event()
	return prob(PROB_WEATHER_POINT_LOMA) //100%

