/datum/particle_weather/rain_gentle
	name = "Rain"
	display_name = "Rain"
	desc = "Gentle Rain, la la description."
	particle_effect_type = /particles/weather/rain

	scale_vol_with_severity = TRUE
	weather_sounds = /datum/looping_sound/rain
	weather_messages = list("The rain cools your skin.", "The rain bluring your eyes.")

	damage_type = TOX
	min_severity = 1
	max_severity = 10
	max_severity_change = 5
	severity_steps = 5
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 5
	target_trait = PARTICLEWEATHER_RAIN

	weather_special_effect = /datum/weather_effect/rain
	weather_color_offset = "#23386b"
	weather_additional_events = list("thunder" = list(1, /datum/weather_event/thunder), "wind" = list(2, /datum/weather_event/wind))
	weather_warnings = list("siren" = null, "message" = FALSE)
	fire_smothering_strength = 6

/datum/particle_weather/rain_storm
	name = "Rain Storm"
	display_name = "Rain Storm"
	desc = "Intense rain."
	particle_effect_type = /particles/weather/rain/storm

	scale_vol_with_severity = TRUE
	weather_sounds = /datum/looping_sound/rain
	weather_messages = list("The rain cools your skin.", "The storm is really picking up!")

	damage_type = TOX
	min_severity = 4
	max_severity = 150
	max_severity_change = 50
	severity_steps = 50
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 3
	target_trait = PARTICLEWEATHER_RAIN

	weather_special_effect = /datum/weather_effect/rain
	weather_color_offset = "#102356"
	weather_additional_events = list("thunder" = list(2, /datum/weather_event/thunder), "wind" = list(4, /datum/weather_event/wind))
	weather_warnings = list("siren" = null, "message" = FALSE)
	fire_smothering_strength = 6
