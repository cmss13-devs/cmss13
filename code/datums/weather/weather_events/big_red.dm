/datum/weather_event/dust
	name = "Duststorm"
	display_name = "Duststorm"
	length = 10 MINUTES
	fullscreen_type = /atom/movable/screen/fullscreen/weather/low
	turf_overlay_icon_state = "strata_snowing"

	effect_message = "You feel dust blow into every crevice of your body, annoying."
	damage_per_tick = 0

	ambience = 'sound/ambience/strata/strata_snow.ogg'

/datum/weather_event/sand
	name = "Sandstorm"
	display_name = "Sandstorm"
	length = 6 MINUTES
	fullscreen_type = /atom/movable/screen/fullscreen/weather/medium
	turf_overlay_icon_state = "strata_storm"

	effect_message = "You feel sand scraping your soft skin away!"
	damage_per_tick = 0.125

	ambience = 'sound/ambience/strata/strata_snowstorm.ogg'

/datum/weather_event/rock
	name = "Rockstorm"
	display_name = "Rockstorm"
	length = 4 MINUTES
	fullscreen_type = /atom/movable/screen/fullscreen/weather/high
	turf_overlay_icon_state = "strata_blizzard"

	effect_message = "You feel multiple small rocks hit all over your body!"
	damage_per_tick = 0.25

	ambience = 'sound/ambience/strata/strata_blizzard.ogg'
