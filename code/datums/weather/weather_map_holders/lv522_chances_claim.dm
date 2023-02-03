/datum/weather_ss_map_holder/lv522_chances_claim
	name = "LV-522 Map Holder"

	warn_time = 1 MINUTES
	min_time_between_events = 30 MINUTES
	min_time_between_checks = 0
	min_check_variance = 0

	no_weather_turf_icon_state = "strata_clearsky"

	potential_weather_events = list(
		/datum/weather_event/light_rain/lv522,
	)

/datum/weather_ss_map_holder/lv522_chances_claim/should_affect_area(area/A)
	return !CEILING_IS_PROTECTED(A.ceiling, CEILING_GLASS)

/datum/weather_ss_map_holder/lv522_chances_claim/should_start_event()
	return TRUE
