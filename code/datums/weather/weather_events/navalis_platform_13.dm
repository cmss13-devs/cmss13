/datum/weather_event/light_rain
	name = "Tropical Storm"
	display_name = "Tropical Storm"
	length = 4 MINUTES
	fullscreen_type = /atom/movable/screen/fullscreen/weather/low

	turf_overlay_icon_state = "strata_storm"
	turf_overlay_alpha = 40

	effect_message = null
	damage_per_tick = 0

	has_process = TRUE
	lightning_chance = 1

	ambience = 'sound/ambience/rainforest.ogg'

	fire_smothering_strength = 1

/datum/weather_event/monsoon
	name = "Monsoon Warning"
	display_name = "Monsoon Warning"
	length = 6 MINUTES
	fullscreen_type = /atom/movable/screen/fullscreen/weather/high

	turf_overlay_icon_state = "strata_storm"
	turf_overlay_alpha = 115

	effect_message = null
	damage_per_tick = 0


	ambience = 'sound/ambience/varadero_storm.ogg'

	has_process = TRUE
	lightning_chance = 6

	fire_smothering_strength = 4
