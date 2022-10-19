/datum/weather_ss_map_holder/big_red
	name = "Big Red Map Holder"

	min_time_between_events = 20 MINUTES
	no_weather_turf_icon_state = "strata_clearsky"

	potential_weather_events = list(
		/datum/weather_event/dust,
		/datum/weather_event/sand,
		/datum/weather_event/rock
	)

/datum/weather_ss_map_holder/big_red/should_affect_area(var/area/A)
	return !CEILING_IS_PROTECTED(A.ceiling, CEILING_GLASS)

/datum/weather_ss_map_holder/big_red/should_start_event()
	return prob(PROB_WEATHER_BIG_RED)

/datum/weather_ss_map_holder/big_red/weather_warning(var/event_type)
	var/datum/weather_event/incoming_event = event_type
	var/weather_name = initial(incoming_event.display_name)
	var/list/ground_levels = SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND))
	for(var/mob/living/carbon/human/affected_human in GLOB.alive_human_list)
		if(!affected_human.stat && affected_human.client && (affected_human.z in ground_levels))
			playsound_client(affected_human.client, 'sound/effects/radiostatic.ogg', affected_human.loc, 25, FALSE)
			affected_human.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>Weather Alert:</u></span><br>" + "Incoming [weather_name]", /atom/movable/screen/text/screen_text/command_order, rgb(103, 214, 146))
