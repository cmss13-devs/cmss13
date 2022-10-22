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

/datum/weather_event/heavy_rain/handle_weather_process()
	if(prob(2))
		playsound_z(SSmapping.levels_by_trait(ZTRAIT_GROUND), pick('sound/soundscape/thunderclap1.ogg', 'sound/soundscape/thunderclap2.ogg'))
		for(var/mob/M as anything in GLOB.mob_list)
			if(M.hud_used)
				var/atom/movable/screen/plane_master/lighting/exterior/exterior_lighting = M.hud_used.plane_masters["[EXTERIOR_LIGHTING_PLANE]"]
				if(exterior_lighting)
					exterior_lighting.alpha = 0
					animate(exterior_lighting, 1.5 SECONDS, alpha = M.lighting_alpha)
