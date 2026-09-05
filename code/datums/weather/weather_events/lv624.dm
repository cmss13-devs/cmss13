/datum/weather_event/light_rain
	name = "Light Rain"
	display_name = "Light Rain"
	length = 8 MINUTES
	fullscreen_type = /atom/movable/screen/fullscreen/weather/low

	turf_overlay_icon_state = "strata_storm"
	turf_overlay_alpha = 50

	effect_message = null
	damage_per_tick = 0

	ambience = 'sound/ambience/rainforest.ogg'

	fire_smothering_strength = 1

/datum/weather_event/heavy_rain
	name = "Heavy Rain"
	display_name = "Heavy Rain"
	length = 12 MINUTES
	fullscreen_type = /atom/movable/screen/fullscreen/weather/medium

	turf_overlay_icon_state = "strata_storm"
	turf_overlay_alpha = 125

	effect_message = null
	damage_per_tick = 0

	ambience = 'sound/ambience/rainforest.ogg'

	has_process = TRUE
	lightning_chance = 2

	fire_smothering_strength = 4


/datum/weather_event/acid_rain

	name = "Acid Rain"
	display_name = "Acid Rain"

	// This is simply a weather event to break up fights or let a side back on their feet.
	length = 10 MINUTES

	fullscreen_type = /atom/movable/screen/fullscreen/weather/medium
	turf_overlay_icon_state = "acid_rain"
	turf_overlay_alpha = 125

	effect_message = "The acid burns!"
	damage_per_tick = 20

	ambience = 'sound/ambience/rainforest.ogg'
	has_process = TRUE
	lightning_chance = 5

	fire_smothering_strength = 4
