#define GLE_STAGE_NONE		0
#define GLE_STAGE_FIRST		1
#define GLE_STAGE_SECOND	2
#define GLE_STAGE_THIRD		3
#define GLE_STAGE_FOUR		4
#define GLE_TAGE_FIVE		5
#define GLE_STAGE_SIX		6

/turf
	var/obj/structure/snow/snow

//SPECIAL EVENTS
/datum/weather_event
	var/name = ""
	var/affecting_value
	var/duration = 0
	var/started_at = 0
	var/repeats = 0
	var/max_stages = 0
	var/stage = GLE_STAGE_NONE
	var/stage_processing = FALSE
	var/datum/particle_weather/initiator_ref

/datum/weather_event/New(datum/particle_weather/particle_weather)
	..()
	initiator_ref = particle_weather
	start_process()

/datum/weather_event/proc/start_process()
	return

/datum/weather_event/proc/stage_process()
	return

/datum/weather_event/thunder
	name = "Thunder"
	duration = 1 SECONDS
	affecting_value = list("#74DFF7", "#81A7DB", "#7997FC", "#5b73c3", "#2e5fff")
	max_stages = 3
	stage = GLE_STAGE_FIRST
	var/sound_effects = list(
		'sound/weather/rain/thunder_1.ogg', 'sound/weather/rain/thunder_2.ogg', 'sound/weather/rain/thunder_3.ogg', 'sound/weather/rain/thunder_4.ogg',
		'sound/weather/rain/thunder_5.ogg', 'sound/weather/rain/thunder_6.ogg', 'sound/weather/rain/thunder_7.ogg',
	)

/datum/weather_event/thunder/start_process()
	repeats = rand(1, 3)
	duration = duration + rand(-duration*5, duration*10)/10
	SSsunlighting.weather_light_affecting_event = src
	stage_processing = TRUE
	stage_process()

/datum/weather_event/thunder/stage_process()
	var/color_animating
	var/animate_flags = CIRCULAR_EASING
	switch(stage)
		if(GLE_STAGE_FIRST)
			color_animating = pick(affecting_value)
			animate_flags = ELASTIC_EASING | EASE_IN | EASE_OUT
			spawn(duration - rand(0, duration*10)/10)
				playsound_z(SSmapping.levels_by_trait(ZTRAIT_GROUND), pick(sound_effects))
		if(GLE_STAGE_THIRD)
			color_animating = SSsunlighting.current_color
			animate_flags = CIRCULAR_EASING | EASE_IN

	if(color_animating)
		animate(SSsunlighting.sun_color, color = color_animating, easing = animate_flags, time = duration)

	sleep(duration)
	stage++
	if(repeats && stage > max_stages)
		repeats--
		stage = GLE_STAGE_FIRST
		sleep(duration)

	else if(stage > max_stages)
		SSsunlighting.weather_light_affecting_event = null
		SSsunlighting.update_color()
		qdel(src)
		return

	stage_process()

/datum/weather_event/wind
	name = "Wind"
	duration = 10 SECONDS
	affecting_value = list("min_value" = 10, "max_value" = 60)
	max_stages = 2
	stage = GLE_STAGE_FIRST

/datum/weather_event/wind/start_process()
	duration = duration + rand(-duration, duration)
	stage_processing = TRUE
	stage_process()

/datum/weather_event/wind/stage_process()
	switch(stage)
		if(GLE_STAGE_FIRST)
			initiator_ref.wind_severity = rand(affecting_value["min_value"], affecting_value["max_value"])
		if(GLE_STAGE_SECOND)
			initiator_ref.wind_severity = rand(0, affecting_value["max_value"])
		if(GLE_STAGE_THIRD)
			initiator_ref.wind_severity = rand(0, affecting_value["min_value"])

	initiator_ref.change_severity(FALSE)

	sleep(duration)
	stage++
	if(repeats)
		repeats--
		stage = initial(stage)
		start_process()
		return

	else if(stage > max_stages)
		SSsunlighting.weather_light_affecting_event = null
		SSsunlighting.update_color()
		initiator_ref.wind_severity = 0
		qdel(src)
		return

	stage_process()


/datum/weather_effect
	var/name = "effect"
	var/probability = 0
	var/datum/particle_weather/initiator_ref

/datum/weather_effect/proc/effect_affect(turf/target_turf)
	return FALSE

/datum/weather_effect/rain
	name = "rain effect"
	probability = 70

/datum/weather_effect/rain/effect_affect(turf/target_turf)
	for(var/obj/effect/decal/cleanable/decal in target_turf)
		qdel(decal)

	if(target_turf.snow && prob(probability * 0.25))
		target_turf.snow.damage_act(1)

/datum/weather_effect/snow
	name = "snow effect"
	probability = 40

/datum/weather_effect/snow/effect_affect(turf/target_turf)
	if(!target_turf.snow)
		new /obj/structure/snow(target_turf, 1)
	else
		target_turf.snow.weathered(src)

/obj/structure/snow
	name = "Snow"
	desc = "Big pile of snow"
	icon = 'icons/effects/snow.dmi'
	icon_state = "snow_1"
	var/icon_prefix = "snow"
	anchored = TRUE
	density = FALSE
	throwpass = TRUE
	plane = GAME_PLANE
	layer = BELOW_TABLE_LAYER
	var/bleed_layer = 0
	var/pts = 0
	var/turf/snowed_turf
	var/list/snows_connections = list(list("0", "0", "0", "0"), list("0", "0", "0", "0"), list("0", "0", "0", "0"))
	var/list/diged = list("2" = 0, "1" = 0, "8" = 0, "4" = 0)

/obj/structure/snow/Initialize(mapload, bleed_layers)
	. = ..()
	icon_state = "blank"
	bleed_layer = bleed_layers
	if(!bleed_layer)
		bleed_layer = rand(1, 3)

	AddElement(/datum/element/mob_overlay_effect, bleed_layer * 2, bleed_layer * 3)

	START_PROCESSING(SSslowobj, src)

	return INITIALIZE_HINT_LATELOAD

/obj/structure/snow/LateInitialize()
	. = ..()
	update_corners()
	update_overlays()

/obj/structure/snow/Destroy(force)
	STOP_PROCESSING(SSslowobj, src)
	snowed_turf.snow = null
	snowed_turf = null

	. = ..()

/obj/structure/snow/process(delta_time)
	if(!weather_conditions.running_weather)
		damage_act(3 * delta_time)
	else if(!istype(weather_conditions.running_weather, /datum/weather_effect/snow))
		damage_act(6 * delta_time)
	update_overlays()

/obj/structure/snow/proc/update_corners(propagate = FALSE)
	var/list/snow_dirs = list(list(), list(), list())
	var/turf/turf = get_turf(src)
	if(!turf)
		return
	else if(turf != snowed_turf)
		snowed_turf.snow = null
		snowed_turf = turf
		snowed_turf.snow = src

	if(snowed_turf.weeds)
		snowed_turf.weeds.Destroy()

	for(var/obj/structure/snow/bordered_snow in orange(src, 1))
		if(!bordered_snow)
			continue

		if(propagate)
			bordered_snow.update_corners()
			bordered_snow.update_overlays()

		var/direction = get_dir(src, bordered_snow)
		for(var/deep = 1 to length(snow_dirs))
			if(deep > bleed_layer)
				continue

			if(deep > bordered_snow.bleed_layer)
				continue

			snow_dirs[deep] += direction

	for(var/deep = 1 to length(snow_dirs))
		snows_connections[deep] = dirs_to_corner_states(snow_dirs[deep])

/obj/structure/snow/update_overlays()
	. = ..()
	if(overlays)
		overlays.Cut()

	for(var/deep = 1 to length(snows_connections))
		if(deep > bleed_layer)
			continue

		for(var/i = 1 to 4)
			overlays += image(icon, "[icon_prefix]_[deep]_[snows_connections[deep][i]]", dir = 1<<(i-1))

	var/new_overlay = ""
	for(var/i in diged)
		if(diged[i] > world.time)
			new_overlay += i
	overlays += "[new_overlay]"
	RemoveElement(/datum/element/mob_overlay_effect)
	AddElement(/datum/element/mob_overlay_effect, bleed_layer * 2, bleed_layer * 3)

/obj/structure/snow/proc/damage_act(damage)
	if(pts > damage / 5)
		pts -= damage / 5
	else
		changing_layer(min(bleed_layer - round(damage / bleed_layer * 8, 1), MAX_LAYER_SNOW_LEVELS))
		pts = 0

/obj/structure/snow/get_projectile_hit_boolean(obj/item/projectile/proj)
	return FALSE

/obj/structure/snow/bullet_act(obj/item/projectile/proj)
	return FALSE

/obj/structure/snow/flamer_fire_act(damage)
	damage_act(damage)

/obj/structure/snow/proc/weathered(datum/weather_effect/effect)
	if(pts < bleed_layer * 8)
		pts++
	else
		if(bleed_layer >= 3)
			for(var/direction in GLOB.alldirs)
				var/turf/turf = get_step(loc, direction)
				if(!turf.snow)
					turf.apply_weather_effect(effect)
					break

				else if(turf.snow && turf.snow.bleed_layer != 3)
					turf.snow.pts += pts
					break
		else
			changing_layer(min(bleed_layer + 1, MAX_LAYER_SNOW_LEVELS))

		pts = 0

/obj/structure/snow/proc/changing_layer(new_layer)
	if(isnull(new_layer) || new_layer == bleed_layer)
		return

	bleed_layer = max(0, new_layer)

	switch(bleed_layer)
		if(1)
			throwpass= TRUE
			layer = BELOW_TABLE_LAYER
		if(2)
			throwpass= TRUE
			layer = BELOW_OBJ_LAYER
		if(3)
			throwpass= FALSE
			layer = OBJ_LAYER

	update_corners(TRUE)
	update_overlays()

	if(!bleed_layer)
		qdel(src)

/obj/structure/snow/ex_act(severity)
	damage_act(severity)

/obj/structure/snow/Crossed(atom/movable/arrived)
	. = ..()
	if(isliving(arrived))
		var/mob/living/living = arrived
		if(bleed_layer > 1)
			var/new_slowdown = living.next_move_slowdown + (0.35 * bleed_layer)
			if(prob(10))
				to_chat(living, SPAN_WARNING("Moving through [src] slows you down.")) //Warning only
				new_slowdown += 2 SECONDS
			else if(bleed_layer == 3 && prob(2))
				to_chat(living, SPAN_WARNING("You get stuck in [src] for a moment!"))
				new_slowdown += 4 SECONDS
			living.next_move_slowdown = new_slowdown
		set_diged_ways(GLOB.reverse_dir[living.dir])

/obj/structure/snow/Uncrossed(atom/movable/gone)
	. = ..()
	if(isliving(gone))
		set_diged_ways(gone.dir)

/obj/structure/snow/proc/set_diged_ways(dir)
	diged["[dir]"] = world.time + 1 MINUTES
	update_overlays()

/obj/structure/snow/attack_alien(mob/living/carbon/xenomorph/xenomorph)
	if(xenomorph.a_intent == INTENT_HARM) //Missed slash.
		return
	if(xenomorph.a_intent == INTENT_HELP || !bleed_layer)
		return ..()

	xenomorph.visible_message(SPAN_NOTICE("[xenomorph] starts clearing out \the [src]..."), SPAN_NOTICE("You start clearing out \the [src]..."), null, 5, CHAT_TYPE_XENO_COMBAT)
	playsound(xenomorph.loc, 'sound/weapons/alien_claw_swipe.ogg', 25, 1)

	while(bleed_layer > 0)
		xeno_attack_delay(xenomorph)
		if(!do_after(xenomorph, 12, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
			return XENO_NO_DELAY_ACTION

		if(!bleed_layer)
			to_chat(xenomorph, SPAN_WARNING("There is nothing to clear out!"))
			return XENO_NO_DELAY_ACTION

		var/new_layer = bleed_layer - 1
		changing_layer(new_layer)

	return XENO_NO_DELAY_ACTION


/datum/particle_weather
	var/name = "set this"
	var/display_name = "set this"
	var/desc = "set this"

	var/list/weather_messages = list()
	var/list/weather_warnings = list("siren" = null, "message" = TRUE)
	var/weather_sounds
	var/list/wind_sounds = list(/datum/looping_sound/wind)
	var/scale_vol_with_severity = TRUE

	var/particles/weather/particle_effect_type = /particles/weather/rain

	var/weather_duration_lower = 5 MINUTES
	var/weather_duration_upper = 20 MINUTES

	var/damage_type = null
	var/damage_per_tick = 0
	var/wind_severity = 0
	var/min_severity = 1
	var/max_severity = 100
	var/max_severity_change = 20
	var/severity_steps = 5
	var/immunity_type = TRAIT_WEATHER_IMMUNE
	var/probability = 0

	var/target_trait = PARTICLEWEATHER_RAIN
	var/severity_steps_taken = 0
	var/running = FALSE
	var/severity = 0
	var/barometer_predictable = FALSE

	COOLDOWN_DECLARE(time_left)
	var/weather_duration = 0
	var/weather_start_time = 0

	var/weather_special_effect
	var/weather_color_offset
	var/list/weather_additional_events = list()
	var/list/datum/weather_event/weather_additional_ongoing_events = list()
	var/list/messaged_mobs = list()
	var/list/current_sounds = list()
	var/list/current_wind_sounds = list()
	var/list/affected_zlevels = list()
	var/fire_smothering_strength = 0

	var/last_message = ""

/datum/particle_weather/proc/severity_mod()
	return severity / max_severity

/datum/particle_weather/proc/tick()
	if(weather_additional_events && prob(10))
		for(var/event in weather_additional_events)
			if(!prob(weather_additional_events[event][1]))
				continue
			var/str = weather_additional_events[event][2]
			weather_additional_ongoing_events += new str(src)

/datum/particle_weather/Destroy()
	for(var/S in current_sounds)
		var/datum/looping_sound/looping_sound = current_sounds[S]
		looping_sound.stop()
		qdel(looping_sound)

	for(var/S in current_wind_sounds)
		var/datum/looping_sound/looping_sound = current_wind_sounds[S]
		looping_sound.stop()
		qdel(looping_sound)

	return ..()

/datum/particle_weather/proc/start()
	if(running)
		return
	weather_duration = rand(weather_duration_lower, weather_duration_upper)
	COOLDOWN_START(src, time_left, weather_duration)
	weather_start_time = SSsunlighting.game_time_offseted() / SSsunlighting.game_time_length
	running = TRUE
	addtimer(CALLBACK(src, PROC_REF(wind_down)), weather_duration)
	weather_warnings()
	if(particle_effect_type)
		SSweather_conditions.set_particle_effect(new particle_effect_type);

	if(weather_special_effect)
		SSweather_conditions.weather_special_effect = new weather_special_effect(src)

	change_severity()


/datum/particle_weather/proc/change_severity(as_step = TRUE)
	if(!running)
		return
	if(as_step)
		severity_steps_taken++

	if(max_severity_change == 0)
		severity = rand(min_severity, max_severity)
	else
		var/new_severity = severity + rand(-max_severity_change, max_severity_change)
		new_severity = Clamp(new_severity, min_severity, max_severity)
		severity = new_severity

	severity += wind_severity

	if(SSweather_conditions.particle_effect)
		SSweather_conditions.particle_effect.animate_severity(severity)

	messaged_mobs = list()

	if(severity_steps_taken < severity_steps && as_step)
		addtimer(CALLBACK(src, PROC_REF(change_severity)), weather_duration / severity_steps)

/datum/particle_weather/proc/wind_down()
	severity = 0
	if(SSweather_conditions.particle_effect)
		SSweather_conditions.particle_effect.animate_severity(0)

		//Wait for the last particle to fade, then qdel yourself
		addtimer(CALLBACK(src, PROC_REF(end)), SSweather_conditions.particle_effect.lifespan + SSweather_conditions.particle_effect.fade)

/datum/particle_weather/proc/end()
	running = FALSE
	SSweather_conditions.stop_weather()

/datum/particle_weather/proc/can_weather(mob/living/mob_to_check)
	var/turf/mob_turf = get_turf(mob_to_check)

	if(!mob_turf)
		return

	if(mob_turf.turf_flags & TURF_WEATHER)
		return TRUE

	return FALSE

/datum/particle_weather/proc/can_weather_effect(mob/living/mob_to_check)

	//If mob is not in a turf
	var/turf/mob_turf = get_turf(mob_to_check)
	var/atom/loc_to_check = mob_to_check.loc
	while(loc_to_check != mob_turf)
		if((immunity_type && HAS_TRAIT(loc_to_check, immunity_type)) || HAS_TRAIT(loc_to_check, TRAIT_WEATHER_IMMUNE))
			return
		loc_to_check = loc_to_check.loc

	return TRUE

/datum/particle_weather/proc/process_mob_effect(mob/living/L, delta_time)
	if(can_weather(L) && running)
		weather_sound_effect(L)
		if(can_weather_effect(L))
			if((last_message || weather_messages) && (!messaged_mobs[L] || world.time > messaged_mobs[L]))
				weather_message(L)
			affect_mob_effect(L, delta_time)
	else
		stop_weather_sound_effect(L)
		messaged_mobs[L] = 0

/datum/particle_weather/proc/affect_mob_effect(mob/living/L, delta_time, calculated_damage)
	if(damage_per_tick)
		calculated_damage = damage_per_tick * delta_time
		L.apply_damage(calculated_damage, damage_type)

/datum/particle_weather/proc/weather_sound_effect(mob/living/L)
	var/datum/looping_sound/current_sound = current_sounds[L]
	if(current_sound)
		//SET VOLUME
		if(scale_vol_with_severity)
			current_sound.volume = initial(current_sound.volume) * severity_mod()
		if(!current_sound.loop_started) //don't restart already playing sounds
			current_sound.start()
		return

	if(weather_sounds)
		current_sound = new weather_sounds(L, FALSE, TRUE, FALSE, SOUND_CHANNEL_WEATHER)
		current_sounds[L] = current_sound
		//SET VOLUME
		if(scale_vol_with_severity)
			current_sound.volume = initial(current_sound.volume) * severity_mod()
		current_sound.start()

	if(wind_severity && weather_sounds)
		var/datum/looping_sound/current_wind_sound = current_wind_sounds[L]
		if(current_wind_sound)
			//SET VOLUME
			if(scale_vol_with_severity)
				current_wind_sound.volume = initial(current_wind_sound.volume) * severity_mod()
			if(!current_wind_sound.loop_started) //don't restart already playing sounds
				current_wind_sound.start()
			return

		var/temp_wind_sound = scale_range_pick(min_severity, max_severity, severity, wind_sounds)
		if(temp_wind_sound)
			current_wind_sound = new temp_wind_sound(L, FALSE, TRUE, FALSE, SOUND_CHANNEL_WEATHER)
			current_wind_sounds[L] = current_wind_sound
			//SET VOLUME
			if(scale_vol_with_severity)
				current_wind_sound.volume = initial(current_wind_sound.volume) * severity_mod()
			current_wind_sound.start()


/datum/particle_weather/proc/stop_weather_sound_effect(mob/living/L)
	var/datum/looping_sound/current_sound = current_sounds[L]
	if(current_sound)
		current_sound.stop()
	var/datum/looping_sound/current_wind_sound = current_wind_sounds[L]
	if(current_wind_sound)
		current_wind_sound.stop()

/datum/particle_weather/proc/weather_message(mob/living/L)
	messaged_mobs[L] = world.time + WEATHER_MESSAGE_DELAY
	last_message = scale_range_pick(min_severity, max_severity, severity, weather_messages)
	if(last_message)
		to_chat(L, SPAN_DANGER(last_message))

/datum/particle_weather/proc/weather_warnings()
	switch(weather_warnings)
		if("siren")
			for(var/obj/structure/machinery/siren/weather/weather_siren in GLOB.siren_objects["weather"])
				if(weather_siren.z in affected_zlevels)
					weather_siren.siren_warning(weather_warnings["siren"])
		if("message")
			var/list/message = list("xenomorph" = "Incoming [display_name]", "human" = "Incoming [display_name]")
			if(length(weather_warnings["message"]))
				var/weather_message = weather_warnings["message"]
				for(var/msg in weather_message)
					message[msg] += weather_message[msg]
			for(var/mob/living/carbon/human/affected_human in GLOB.alive_human_list)
				if(!affected_human.stat && affected_human.client && (affected_human.z in affected_zlevels))
					playsound_client(affected_human.client, 'sound/effects/radiostatic.ogg', affected_human.loc, 25, FALSE)
					affected_human.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>Weather Alert:</u></span><br>" + message["human"], /atom/movable/screen/text/screen_text/command_order, rgb(103, 214, 146))
			for(var/mob/living/carbon/xenomorph/affected_xeno in GLOB.living_xeno_list)
				if(!affected_xeno.stat && affected_xeno.client && (affected_xeno.z in affected_zlevels))
					playsound_client(affected_xeno.client, 'sound/voice/alien_distantroar_3.ogg', affected_xeno.loc, 25, FALSE)
					affected_xeno.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>The Hivemind Senses:</u></span><br>" + message["xenomorph"], /atom/movable/screen/text/screen_text/command_order, rgb(175, 0, 175))
    return FALSE

/datum/looping_sound/dust_storm
	mid_sounds = 'sound/weather/dust/weather_dust.ogg'
	mid_length = 80
	volume = 150

/datum/looping_sound/rain
	mid_sounds = 'sound/weather/rain/weather_rain.ogg'
	mid_length = 40 SECONDS
	volume = 200

/datum/looping_sound/storm
	mid_sounds = 'sound/weather/rain/weather_storm.ogg'
	mid_length = 30 SECONDS
	volume = 150

/datum/looping_sound/snow
	mid_sounds = 'sound/weather/snow/weather_snow.ogg'
	mid_length = 50 SECONDS
	volume = 150

/datum/looping_sound/wind
	mid_sounds = 'sound/weather/rain/wind_1.ogg'
	mid_sounds = list(
		'sound/weather/rain/wind_1.ogg'=1,
		'sound/weather/rain/wind_2.ogg'=1,
		'sound/weather/rain/wind_3.ogg'=1,
		'sound/weather/rain/wind_4.ogg'=1,
		'sound/weather/rain/wind_5.ogg'=1,
		'sound/weather/rain/wind_6.ogg'=1
		)
	mid_length = 30 SECONDS
	volume = 150
