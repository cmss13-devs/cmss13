/datum/weather_event/point_loma/heat
	name = "High Heat"
	display_name = "High Heat"
	length = 15 MINUTES // 15 minutes long, happens every 15 minutes
	cleaning = FALSE
	ambience = null

	effect_message = "It is unbelievably hot. You can't wait to get indoors."
	damage_per_tick = 0

/datum/weather_event/point_loma/heat/heat_wave
	name = "High Heat Extra"
	display_name = "Heat Wave"
	length = 15 MINUTES
	cleaning = FALSE
	ambience = null

	effect_message = "It is unbelievably, unbearably, hot. You start to feel lightheaded."
	damage_per_tick = 0.01
	damage_type = BURN
