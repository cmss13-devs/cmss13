// Each subtype of weather_event defines a distinct weather event type
// E.G. blizzard, snowstorm, dust storm, etc.
// These are basically just "state holders"
// that hold state necessary for the weather event to
// be handled across the world and by the weather subsystem

/datum/weather_event
	//// MANDATORY vars
	var/name = "set this" // Make this a copy of display name unless theres a good reason
	var/display_name = "set this" // The "display name" of this event
	var/length = 0 // Length of the event

	//// Optional vars
	var/fullscreen_type = null  // If this is set, display a fullscreen type to mobs
	var/turf_overlay_icon_state // The icon to set on the VFX holder instanced into every turf at round start
	var/turf_overlay_alpha = 255

	var/effect_message = "tell a coder to fix this | WEATHER EVENT EFFECT MESSAGE"
	var/damage_per_tick = 200 // more likely to report the bug if it instantly kills them
	var/damage_type = BURN

	var/ambience = 'sound/ambience/strata/strata_snow.ogg'

	var/has_process = FALSE // to be used with handle_weather_process()

// remember, this happens every five seconds or so
/datum/weather_event/proc/handle_weather_process()
	return

/datum/weather_event/proc/process_mob_effect(var/mob/living/carbon/affected_mob, var/delta_time = 1)
	if(effect_message && prob(WEATHER_MESSAGE_PROB))
		to_chat(affected_mob, SPAN_WARNING(effect_message))
	if(damage_per_tick)
		var/calculated_damage = (isXeno(affected_mob) ? damage_per_tick * 3 : damage_per_tick) * delta_time
		affected_mob.apply_damage(calculated_damage, damage_type)
		affected_mob.last_damage_data = create_cause_data("Exposure")
