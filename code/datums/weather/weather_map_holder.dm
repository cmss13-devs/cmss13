// Delegate object that holds all the map-dependent pieces of the
// One of these is instanced into the weather subsystem when it's initialized
// based on the current map_tag (should be the only map_tag dependent piece of code)

/datum/weather_ss_map_holder
	var/name = "set this" // For VV

	// Weather SS configuration options
	var/min_time_between_events = 5 MINUTES // Self explanatory
	var/min_time_between_checks = 15 MINUTES
	var/min_check_variance = 10 MINUTES
	var/warn_time = 30 SECONDS   // Warning time between the call to
	var/no_weather_turf_icon_state = "" // Icon state to set on the global VFX holder
										// when there's no weather.
	var/list/potential_weather_events   // List of types of possible weather events

/datum/weather_ss_map_holder/New()
	..()
	min_time_between_checks += rand(min_check_variance * -0.5, min_check_variance * 0.5)

// Should the weather for this map include the passed area?
/datum/weather_ss_map_holder/proc/should_affect_area(area/A)
	log_debug("Weather subsystem map holder [src] is improperly configured. Code: WSSMH01")
	return FALSE

// Should we start an event? This just deals with the logic that an event is starting
// period, nothing to do with what the type of the event will be when its
// eventually chosen
/datum/weather_ss_map_holder/proc/should_start_event()
	log_debug("Weather subsystem map holder [src] is improperly configured. Code: WSSMH02")
	return FALSE

// Return a type that can be initialized into the next weather event.
// Feel free to override this
/datum/weather_ss_map_holder/proc/get_new_event()
	if (LAZYLEN(potential_weather_events) != 0)
		return pick(potential_weather_events)
	else
		log_debug("Weather subsystem map holder [src] is improperly configured. Code: WSSMH03")
		return null

// Called whenever the weather SS decides to start an event, but
// warn_time deciseconds before it actually starts
// (think weather sirens on sorokyne)
/datum/weather_ss_map_holder/proc/weather_warning(event_type)
	var/datum/weather_event/incoming_event = event_type
	var/weather_name = initial(incoming_event.display_name)
	var/list/ground_levels = SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND))
	for(var/mob/living/carbon/human/affected_human in GLOB.alive_human_list)
		if(!affected_human.stat && affected_human.client && (affected_human.z in ground_levels))
			playsound_client(affected_human.client, 'sound/effects/radiostatic.ogg', affected_human.loc, 25, FALSE)
			affected_human.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>Weather Alert:</u></span><br>" + "Incoming [weather_name]", /atom/movable/screen/text/screen_text/command_order, rgb(103, 214, 146))
	for(var/mob/living/carbon/xenomorph/affected_xeno in GLOB.living_xeno_list)
		if(!affected_xeno.stat && affected_xeno.client)
			playsound_client(affected_xeno.client, 'sound/voice/alien_distantroar_3.ogg', affected_xeno.loc, 25, FALSE)
			affected_xeno.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>The Hivemind Senses:</u></span><br>" + "Incoming [weather_name]", /atom/movable/screen/text/screen_text/command_order, rgb(175, 0, 175))
	for(var/mob/living/carbon/human/affected_pred in GLOB.yautja_mob_list)
		if(!affected_pred.stat && affected_pred.client && (affected_pred.z in ground_levels))
			elder_overseer_message("Incoming [weather_name].")
