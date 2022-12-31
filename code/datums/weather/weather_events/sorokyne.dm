// Weather events for Sorokyne
/datum/weather_event/snow
	name = "Snow"
	display_name = "Snow"
	length = 10 MINUTES
	fullscreen_type = /atom/movable/screen/fullscreen/weather/low
	turf_overlay_icon_state = "strata_snowing"

	effect_message = "You feel the icy winds chill you!"
	damage_per_tick = 0

	ambience = 'sound/ambience/strata/strata_snow.ogg'

	fire_smothering_strength = 3

/datum/weather_event/snowstorm
	name = "Snowstorm"
	display_name = "Snowstorm"
	length = 6 MINUTES
	fullscreen_type = /atom/movable/screen/fullscreen/weather/medium
	turf_overlay_icon_state = "strata_storm"

	effect_message = "You feel the icy winds of the snowstorm chill you to the bone!"
	damage_per_tick = 0.125

	ambience = 'sound/ambience/strata/strata_snowstorm.ogg'

	fire_smothering_strength = 4

/datum/weather_event/blizzard
	name = "Blizzard"
	display_name = "Blizzard"
	length = 4 MINUTES
	fullscreen_type = /atom/movable/screen/fullscreen/weather/high
	turf_overlay_icon_state = "strata_blizzard"

	effect_message = "You feel the winds of the blizzard sap all the warmth from your body!"
	damage_per_tick = 0.25

	ambience = 'sound/ambience/strata/strata_blizzard.ogg'

	fire_smothering_strength = 6
