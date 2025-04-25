/datum/weather_event/dust
	name = "Duststorm"
	display_name = "Duststorm"
	length = 10 MINUTES
	fullscreen_type = /atom/movable/screen/fullscreen/weather/low
	turf_overlay_icon_state = "bigred_dust"

	effect_message = "You feel dust blow into every crevice of your body, annoying."
	damage_per_tick = 0
	damage_type = BRUTE

	ambience = 'sound/ambience/strata/strata_snow.ogg'

	fire_smothering_strength = 1

	cleaning = FALSE

/datum/weather_event/sand
	name = "Sandstorm"
	display_name = "Sandstorm"
	length = 6 MINUTES
	fullscreen_type = /atom/movable/screen/fullscreen/weather/medium
	turf_overlay_icon_state = "bigred_sand"

	effect_message = "You feel sand scraping the upper layers of your exterior away!"
	damage_per_tick = 0
	damage_type = BRUTE

	ambience = 'sound/ambience/strata/strata_snowstorm.ogg'

	fire_smothering_strength = 2

	cleaning = FALSE

/datum/weather_event/rock
	name = "Rockstorm"
	display_name = "Rockstorm"
	length = 4 MINUTES
	fullscreen_type = /atom/movable/screen/fullscreen/weather/high
	turf_overlay_icon_state = "bigred_rocks"

	effect_message = "You feel multiple small rocks hit all over your body!"
	damage_per_tick = 3
	damage_type = BRUTE

	ambience = 'sound/ambience/strata/strata_blizzard.ogg'

	fire_smothering_strength = 3

	cleaning = FALSE
