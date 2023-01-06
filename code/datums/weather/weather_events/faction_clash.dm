/datum/weather_event/clash_rain
	name = "Rainstorm"
	display_name = "Rainstorm"
	length = INFINITY
	fullscreen_type = /atom/movable/screen/fullscreen/weather/low

	turf_overlay_icon_state = "strata_storm"
	turf_overlay_alpha = 80

	effect_message = null
	damage_per_tick = 0

	ambience = 'sound/ambience/rainforest.ogg'

	has_process = TRUE
	lightning_chance = 2

	fire_smothering_strength = 6

/datum/weather_event/clash_rain/start_weather_event()
	. = ..()
	GLOB.minimum_exterior_lighting_alpha = 200
	for(var/mob/mob as anything in GLOB.mob_list)
		mob.update_sight()
