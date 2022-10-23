/datum/weather_ss_map_holder/faction_clash
	name = "Faction Clash Map Holder"

	warn_time = 0
	min_time_between_events = 0
	min_time_between_checks = 0
	min_check_variance = 0

	no_weather_turf_icon_state = "strata_clearsky"

	potential_weather_events = list(
		/datum/weather_event/clash_rain
	)

/datum/weather_ss_map_holder/faction_clash/should_affect_area(var/area/A)
	return !CEILING_IS_PROTECTED(A.ceiling, CEILING_GLASS)

/datum/weather_ss_map_holder/faction_clash/should_start_event()
	return TRUE
