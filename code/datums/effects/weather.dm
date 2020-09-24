/datum/effects/weather
	effect_name = "weather"
	duration = null
	flags = INF_DURATION | DEL_ON_DEATH
	var/damage_per_tick = 0 // By default, burn damage
	var/effect_message = "This shouldn't appear. Tell the devs. Code: WEATHER_01"
	var/ambience_path = null // Set this for ambience

/datum/effects/weather/validate_atom(var/atom/A)
	if(ishuman(A) || isXeno(A))
		return TRUE
	else
		return FALSE

/datum/effects/weather/process_mob()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/affected_mob = affected_atom

	if (prob(WEATHER_MESSAGE_PROB))
		to_chat(affected_mob, SPAN_WARNING(effect_message))

	var/calculated_damage = isXeno(affected_mob) ? damage_per_tick*3 : damage_per_tick
	affected_mob.apply_damage(calculated_damage, BURN)

	affected_mob.last_damage_source = "Exposure"
	affected_mob.last_damage_mob = null

	if (ambience_path \
		&& affected_mob.client && (affected_mob.client.prefs.toggles_sound & SOUND_AMBIENCE) \
		&& (affected_mob.client.soundOutput.ambience != ambience_path))
		affected_mob.client.soundOutput.ambience = ambience_path
		affected_mob.client.soundOutput.update_ambience(null, TRUE)

	return TRUE

/datum/effects/weather/process_obj()
	return FALSE

/datum/effects/weather/Destroy()
	if(affected_atom)
		affected_atom.effects_list -= src
	return ..()