#define WAIT_SUNLIGHT_READY while(!SSsunlighting.initialized) {stoplag();}

/datum/time_of_day
	var/name = ""
	var/color = ""
	var/start_at = 0.25	// 06:00:00
	var/position_number = FALSE

/datum/time_of_day/New()
	..()
	if(SSmapping.configs[GROUND_MAP].map_day_night_modificator[name])
		start_at = SSmapping.configs[GROUND_MAP].map_day_night_modificator[name]
	if(SSmapping.configs[GROUND_MAP].custom_day_night_colors[name])
		color = SSmapping.configs[GROUND_MAP].custom_day_night_colors[name]

/datum/time_of_day/midnight
	name = "Midnight"
	color = "#000000"
	start_at = 0		//12:00:00
	position_number = 1

/datum/time_of_day/night
	name = "Night"
	color = "#050D29"
	start_at = 0.083	//02:00:00
	position_number = 2

/datum/time_of_day/dawn
	name = "Dawn"
	color = "#31211b"
	start_at = 0.16		//04:00:00
	position_number = 3

/datum/time_of_day/sunrise
	name = "Sunrise"
	color = "#F598AB"
	start_at = 0.25		//06:00:00
	position_number = 4

/datum/time_of_day/sunrise_morning
	name = "Sunrise-Morning"
	color = "#7e874a"
	start_at = 0.29		//07:00:00
	position_number = 5

/datum/time_of_day/morning
	name = "Morning"
	color = "#808599"
	start_at = 0.33		//08:00:00
	position_number = 6

/datum/time_of_day/daytime
	name = "Daytime"
	color = "#FFFFFF"
	start_at = 0.416	//10:00:00
	position_number = 7

/datum/time_of_day/evening
	name = "Evening"
	color = "#AFAFAF"
	start_at = 0.66		//14:00:00
	position_number = 8

/datum/time_of_day/sunset
	name = "Sunset"
	color = "#ff8a63"
	start_at = 0.7916	//17:00:00
	position_number = 9

/datum/time_of_day/dusk
	name = "Dusk"
	color = "#221f33"
	start_at = 0.916	//22:00:00
	position_number = 10

GLOBAL_VAR_INIT(global_light_range, 5)
GLOBAL_LIST_EMPTY(sunlight_queue_work)
GLOBAL_LIST_EMPTY(sunlight_queue_update)
GLOBAL_LIST_EMPTY(sunlight_queue_corner)

SUBSYSTEM_DEF(sunlighting)
	name = "Sun Lighting"
	wait = 2 SECONDS
	priority = SS_PRIORITY_SUNLIGHTING
	flags = SS_TICKER

	var/atom/movable/sun_color

	var/datum/time_of_day/current_step_datum
	var/datum/time_of_day/next_step_datum
	var/datum/particle_weather/weather_datum
	var/datum/weather_event/weather_light_affecting_event
	var/list/mutable_appearance/sunlight_overlays

	var/list/datum/time_of_day/steps = list()

	var/allow_updates = TRUE
	var/next_day = FALSE
	var/current_color = ""
	var/weather_blend_ammount = 0.3

	var/game_time_length = 24 HOURS
	var/custom_time_offset = 0

/datum/controller/subsystem/sunlighting/stat_entry(msg)
	msg = "W:[GLOB.sunlight_queue_work.len]|U:[GLOB.sunlight_queue_update.len]|C:[GLOB.sunlight_queue_corner.len]"
	return ..()

/datum/controller/subsystem/sunlighting/Initialize(timeofday)
	game_time_length = SSmapping.configs[GROUND_MAP].custom_time_length
	custom_time_offset = rand(0, game_time_length)
	create_steps()
	set_time_of_day()
	sun_color = new /atom/movable()
	sun_color.color = current_step_datum.color
	sun_color.appearance_flags = RESET_COLOR|RESET_ALPHA|RESET_TRANSFORM
	sun_color.vis_flags = VIS_INHERIT_PLANE|VIS_INHERIT_LAYER
	sun_color.blend_mode = BLEND_ADD
	sun_color.filters += filter(type = "layer", render_source = S_LIGHTING_VISUAL_RENDER_TARGET)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/sunlighting/proc/set_game_time_length(new_value)
	game_time_length = new_value

/datum/controller/subsystem/sunlighting/proc/set_game_time_offset(new_value)
	custom_time_offset = new_value

/datum/controller/subsystem/sunlighting/proc/game_time_offseted()
	return (REALTIMEOFDAY + custom_time_offset) % game_time_length

/datum/controller/subsystem/sunlighting/proc/create_steps()
	for(var/path in typesof(/datum/time_of_day))
		var/datum/time_of_day/time_of_day = new path()
		if(time_of_day.position_number)
			steps["[time_of_day.position_number]"] = time_of_day

/datum/controller/subsystem/sunlighting/proc/check_cycle()
	if(!next_step_datum)
		set_time_of_day()
		return TRUE

	if(game_time_offseted() > next_step_datum.start_at * game_time_length)
		set_time_of_day()
		return TRUE
	return FALSE

/datum/controller/subsystem/sunlighting/proc/set_time_of_day()
	for(var/worked_length = 1 to length(steps))
		if(game_time_offseted() >= steps["[worked_length]"].start_at * game_time_length)
			current_step_datum = steps["[worked_length]"]
			next_step_datum = worked_length == length(steps) ? steps["1"] : steps["[worked_length + 1]"]

	if(!current_step_datum)
		current_step_datum = steps["1"]
		next_step_datum = steps["2"]

/datum/controller/subsystem/sunlighting/proc/update_color()
	if(!weather_light_affecting_event)
		var/time_to_animate = daytimeDiff(game_time_offseted(), next_step_datum.start_at * game_time_length)
		var/blend_amount = (game_time_offseted() - current_step_datum.start_at * game_time_length) / (next_step_datum.start_at * game_time_length - current_step_datum.start_at * game_time_length)
		current_color = BlendRGB(current_step_datum.color, next_step_datum.color, blend_amount)
		if(weather_datum && weather_datum.weather_color_offset)
			var/weather_blend_amount = (game_time_offseted() - weather_datum.weather_start_time) / (weather_datum.weather_start_time + (weather_datum.weather_duration / 12) - weather_datum.weather_start_time)
			current_color = BlendRGB(current_color, weather_datum.weather_color_offset, min(weather_blend_amount, weather_blend_ammount))
		animate(sun_color, color = current_color, time = time_to_animate)

/datum/controller/subsystem/sunlighting/fire(resumed)
	if(sun_color)
		sun_color.name = "SUN_COLOR_[rand()*rand(1,9999999)]" // force rendering refresh because byond is a bitch

	update_color()

	MC_SPLIT_TICK_INIT(3)
	var/worked_length = 0
	for(worked_length in 1 to GLOB.sunlight_queue_work.len)
		var/turf/turf = GLOB.sunlight_queue_work[worked_length]
		if(turf)
			turf.get_sky_and_weather_states()
			if(turf.outdoor_effect)
				GLOB.sunlight_queue_update += turf.outdoor_effect

		if(MC_TICK_CHECK)
			break
	if(worked_length)
		GLOB.sunlight_queue_work.Cut(1, worked_length+1)
		worked_length = 0

	MC_SPLIT_TICK

	for(worked_length in 1 to GLOB.sunlight_queue_update.len)
		var/atom/movable/outdoor_effect/outdoor_effect = GLOB.sunlight_queue_update[worked_length]
		if(outdoor_effect)
			outdoor_effect.process_state()
			update_outdoor_effect_overlays(outdoor_effect)

		if(MC_TICK_CHECK)
			break
	if(worked_length)
		GLOB.sunlight_queue_update.Cut(1, worked_length+1)
		worked_length = 0


	MC_SPLIT_TICK

	for(worked_length in 1 to GLOB.sunlight_queue_corner.len)
		var/turf/turf = GLOB.sunlight_queue_corner[worked_length]
		var/atom/movable/outdoor_effect/outdoor_effect = turf.outdoor_effect

		/* if we haven't initialized but we are affected, create new and check state */
		if(!outdoor_effect)
			turf.outdoor_effect = new /atom/movable/outdoor_effect(turf)
			turf.get_sky_and_weather_states()
			outdoor_effect = turf.outdoor_effect

			/* in case we aren't indoor somehow, wack us into the proc queue, we will be skipped on next indoor check */
			if(outdoor_effect.state != SKY_BLOCKED)
				GLOB.sunlight_queue_update += turf.outdoor_effect

		if(outdoor_effect.state != SKY_BLOCKED)
			continue

		//This might need to be run more liberally
		update_outdoor_effect_overlays(outdoor_effect)


		if(MC_TICK_CHECK)
			break

	if(worked_length)
		GLOB.sunlight_queue_corner.Cut(1, worked_length+1)
		worked_length = 0

	check_cycle()

//get our weather overlay
/datum/controller/subsystem/sunlighting/proc/get_weather_overlay()
	var/mutable_appearance/MA = new /mutable_appearance()

	MA.icon			= 'icons/effects/weather_overlay.dmi'
	MA.icon_state	= "weather_overlay"
	MA.plane		= WEATHER_OVERLAY_PLANE /* we put this on a lower level than lighting so we dont multiply anything */
	MA.invisibility	= INVISIBILITY_LIGHTING
	MA.blend_mode	= BLEND_OVERLAY
	return MA

// Updates overlays and vis_contents for outdoor effects
/datum/controller/subsystem/sunlighting/proc/update_outdoor_effect_overlays(atom/movable/outdoor_effect/OE)
	if(!is_ground_level(OE.z) && !is_mainship_level(OE.z))
		return

	var/mutable_appearance/MA
	if(OE.state != SKY_BLOCKED)
		MA = get_sunlight_overlay(1,1,1,1) /* fully lit */
	else //Indoor - do proper corner checks
		/* check if we are globally affected or not */
		var/static/datum/static_lighting_corner/dummy/dummy_lighting_corner = new

		var/datum/static_lighting_corner/cr = OE.source_turf.lighting_corner_SW || dummy_lighting_corner
		var/datum/static_lighting_corner/cg = OE.source_turf.lighting_corner_SE || dummy_lighting_corner
		var/datum/static_lighting_corner/cb = OE.source_turf.lighting_corner_NW || dummy_lighting_corner
		var/datum/static_lighting_corner/ca = OE.source_turf.lighting_corner_NE || dummy_lighting_corner

		var/fr = cr.sun_falloff
		var/fg = cg.sun_falloff
		var/fb = cb.sun_falloff
		var/fa = ca.sun_falloff

		MA = get_sunlight_overlay(fr, fg, fb, fa)

	OE.sunlight_overlay = MA
	if(is_ground_level(OE.z) && OE.source_turf.ceiling_status & WEATHERVISIBLE)
		OE.overlays = list(OE.sunlight_overlay, get_weather_overlay())
	else
		OE.overlays = list(OE.sunlight_overlay)

	OE.luminosity = MA.luminosity

//Retrieve an overlay from the list - create if necessary
/datum/controller/subsystem/sunlighting/proc/get_sunlight_overlay(fr, fg, fb, fa)
	var/index = "[fr]|[fg]|[fb]|[fa]"
	LAZYINITLIST(sunlight_overlays)
	if(!sunlight_overlays[index])
		sunlight_overlays[index] = create_sunlight_overlay(fr, fg, fb, fa)
	return sunlight_overlays[index]

//Create an overlay appearance from corner values
/datum/controller/subsystem/sunlighting/proc/create_sunlight_overlay(fr, fg, fb, fa)
	var/mutable_appearance/MA = new /mutable_appearance()

	MA.blend_mode	= BLEND_OVERLAY
	MA.icon			= LIGHTING_ICON
	MA.icon_state	= null
	MA.plane		= S_LIGHTING_VISUAL_PLANE /* we put this on a lower level than lighting so we dont multiply anything */
	MA.invisibility	= INVISIBILITY_LIGHTING


	//MA gets applied as an overlay, but we pull luminosity out to set our outdoor_effect object's lum
	#if LIGHTING_SOFT_THRESHOLD != 0
	MA.luminosity = max(fr, fg, fb, fa) > LIGHTING_SOFT_THRESHOLD
	#else
	MA.luminosity = max(fr, fg, fb, fa) > 1e-6
	#endif

	if((fr & fg & fb & fa) && (fr + fg + fb + fa == 4)) /* this will likely never happen */
		MA.color = LIGHTING_BASE_MATRIX
	else if(!MA.luminosity)
		MA.color = LIGHTING_DARK_MATRIX
	else
		MA.color = list(
					fr, fr, fr,  00 ,
					fg, fg, fg,  00 ,
					fb, fb, fb,  00 ,
					fa, fa, fa,  00 ,
					00, 00, 00,  01 )
	return MA
