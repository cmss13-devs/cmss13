SUBSYSTEM_DEF(weather_conditions)
	name = "Weather Conditions"
	flags = SS_BACKGROUND
	wait = 10 SECONDS
	runlevels = RUNLEVEL_GAME
	var/list/elligble_weathers = list()
	var/datum/particle_weather/next_hit
	var/datum/particle_weather/running_weather
	COOLDOWN_DECLARE(next_weather_start)

	var/list/weathered_turfs = list()
	var/list/turfs_to_process = list()

	var/particles/weather/particle_effect
	var/datum/weather_effect/weather_special_effect
	var/obj/weather_effect

/datum/controller/subsystem/weather_conditions/stat_entry(msg)
	if(running_weather?.running)
		var/time_left = COOLDOWN_SECONDSLEFT(running_weather, time_left)
		if(running_weather?.display_name)
			msg = "P:Current event: [running_weather.display_name] - [time_left] seconds left"
		else if(running_weather)
			msg = "P:Current event of unknown type ([running_weather]) - [time_left] seconds left"
	else if(running_weather)
		var/time_left = COOLDOWN_TIMELEFT(src, next_weather_start)
		if(running_weather?.display_name)
			msg = "P:Next event: [running_weather.display_name] hit in [time_left] seconds"
		else if(running_weather)
			msg = "P:Next event of unknown type ([running_weather]) hit in [time_left] seconds"
	else
		msg = "P:No event"
	return ..()

/datum/controller/subsystem/weather_conditions/Initialize(start_timeofday)
	for(var/i in subtypesof(/datum/particle_weather))
		var/datum/particle_weather/particle_weather = new i
		if(particle_weather.target_trait in SSmapping.configs[GROUND_MAP].weather)
			elligble_weathers[i] = particle_weather.probability
	return SS_INIT_SUCCESS

/datum/controller/subsystem/weather_conditions/fire()
	if(!running_weather && next_hit && COOLDOWN_FINISHED(src, next_weather_start))
		run_weather(next_hit)
		CHECK_TICK

	if((!running_weather || prob(1)) && COOLDOWN_FINISHED(src, next_weather_start) && !running_weather && length(elligble_weathers) && prob(10))
		var/our_event = pick(elligble_weathers)
		if(our_event && prob(elligble_weathers[our_event]))
			next_hit = new our_event()
			COOLDOWN_START(src, next_weather_start, rand(-3000, 3000) + initial(next_hit.weather_duration_upper) / 5)
			CHECK_TICK

	if(running_weather)
		running_weather.tick()

		if(weather_special_effect)
			if(!length(turfs_to_process))
				if(!weathered_turfs)
					return
				turfs_to_process = weathered_turfs.Copy()
			for(var/turf/turf in turfs_to_process)
				if(QDELETED(weather_special_effect))
					break
				turfs_to_process -= turf
				if(prob(weather_special_effect.probability))
					turf.apply_weather_effect(weather_special_effect)
				CHECK_TICK

/datum/controller/subsystem/weather_conditions/proc/run_weather(datum/particle_weather/weather_datum_type, force = 0)
	if(running_weather)
		if(force)
			running_weather.end()
		else
			return

	if(next_hit)
		next_hit = null

	if(!istype(weather_datum_type, /datum/particle_weather))
		CRASH("run_weather called with invalid weather_datum_type: [weather_datum_type || "null"]")
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_WEATHER_CHANGE)
	running_weather = weather_datum_type
	running_weather.start()

/datum/controller/subsystem/weather_conditions/proc/make_eligible(datum/particle_weather/possible_weather, probability = 10)
	elligble_weathers[possible_weather] = probability

/datum/controller/subsystem/weather_conditions/proc/get_weather_effect()
	if(!weather_effect)
		weather_effect = new /obj()
		weather_effect.particles = particle_effect
		weather_effect.add_filter("weather_alpha_mask", 1, alpha_mask_filter(render_source = WEATHER_RENDER_TARGET))
		weather_effect.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	return weather_effect

/datum/controller/subsystem/weather_conditions/proc/set_particle_effect(particles/new_particles)
	particle_effect = new_particles
	weather_effect.particles = new_particles

/datum/controller/subsystem/weather_conditions/proc/stop_weather()
	QDEL_NULL(weather_special_effect)
	QDEL_NULL(running_weather)
	if(weather_effect)
		weather_effect.particles = null
	QDEL_NULL(particle_effect)
