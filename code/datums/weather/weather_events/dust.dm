/datum/particle_weather/dust_storm
	name = "Dust"
	display_name = "Dust"
	desc = "Gentle Rain, la la description."
	particle_effect_type = /particles/weather/dust

	scale_vol_with_severity = TRUE
	weather_sounds = /datum/looping_sound/dust_storm
	weather_messages = list("The whipping sand stings your eyes!", "Sand hitting you very hard")

	damage_type = BRUTE
	damage_per_tick = 0.2
	min_severity = 1
	max_severity = 50
	max_severity_change = 10
	severity_steps = 20
	immunity_type = TRAIT_DUSTSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_DUST

	weather_color_offset = "#7c4f17"
	weather_warnings = list("siren" = "WARNING. A POTENTIALLY DANGEROUS WEATHER ANOMALY HAS BEEN DETECTED. SEEK SHELTER IMMEDIATELY.", "message" = TRUE)
	fire_smothering_strength = 2

//Makes you a little chilly
/datum/particle_weather/dust_storm/affect_mob_effect(mob/living/L, delta_time, calculated_damage)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/internal_damage = calculated_damage * (rand(1, 20) / 10) - H.get_eye_protection()
		if(internal_damage > 0)
			H.apply_internal_damage(internal_damage, "eyes")
