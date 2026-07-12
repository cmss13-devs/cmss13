// Weather events for Fire Colony

/datum/weather_event/fire_colony/ash_dust_very_light
	name = "Very Light Ash Rain"

	display_name = "Light Ash Rain"

	length = 4 MINUTES

	lightning_chance = 4

	turf_overlay_icon_state = "ash_dust_slow"

	effect_message = null
	damage_per_tick = 0

/datum/weather_event/fire_colony/ash_dust_light
	name = "Light Ash Rain"

	display_name = "Ash Rain"

	length = 4 MINUTES

	lightning_chance = 4

	turf_overlay_icon_state = "ash_dust_fast"

	effect_message = null
	damage_per_tick = 0

/datum/weather_event/fire_colony/ash_dust_heavy
	name = "Heavy Ash Rain"
	display_name = "Heavy Ash Rain"

	length = 6 MINUTES

	turf_overlay_icon_state = "ash_dust_storm"

	effect_message = null
	damage_per_tick = 0

	has_process = TRUE
	lightning_chance = 4

	ambience = 'sound/ambience/lava/ash_storm_light.ogg' // Need better sounds.

/datum/weather_event/fire_colony/ash_storm_light
	name = "Light Ash Storm"
	display_name = "Ash Storm Warning"

	should_sound_weather_alarm = TRUE

	length = 3 MINUTES
	fullscreen_type = /atom/movable/screen/fullscreen/weather/low

	turf_overlay_icon_state = "ash_storm_light"

	effect_message = null
	damage_per_tick = 0

	has_process = TRUE
	lightning_chance = 1

	ambience = 'sound/ambience/lava/ash_storm_medium.ogg' // Need better sounds.

/datum/weather_event/fire_colony/ash_storm_heavy
	name = "Heavy Ash Storm"
	display_name = "Ash Storm Warning"

	should_sound_weather_alarm = TRUE

	length = 3 MINUTES
	fullscreen_type = /atom/movable/screen/fullscreen/weather/high

	turf_overlay_icon_state = "ash_storm"
	turf_overlay_alpha = 185

	effect_message = null
	damage_per_tick = 1
	damage_type = BURN

	ambience = 'sound/ambience/lava/ash_storm_heavy.ogg' // Need better sounds.

	has_process = TRUE
	lightning_chance = 6
