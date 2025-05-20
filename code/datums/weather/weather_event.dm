// Each subtype of weather_event defines a distinct weather event type
// E.G. blizzard, snowstorm, dust storm, etc.
// These are basically just "state holders"
// that hold state necessary for the weather event to
// be handled across the world and by the weather subsystem

/datum/weather_event
	//// MANDATORY vars

	/// Make this a copy of display name unless theres a good reason
	var/name = "set this"

	/// The "display name" of this event
	var/display_name = "set this"

	/// Length of the event
	var/length = 0

	//// Optional vars

	/// If this is set, display a fullscreen type to mobs
	var/fullscreen_type = null

	/// The icon to set on the VFX holder instanced into every turf at round start
	var/turf_overlay_icon_state
	var/turf_overlay_alpha = 255

	var/effect_message = "tell a coder to fix this | WEATHER EVENT EFFECT MESSAGE"
	var/damage_per_tick = 200 // more likely to report the bug if it instantly kills them
	var/damage_type = BURN

	var/ambience = 'sound/ambience/strata/strata_snow.ogg'

	/// to be used with handle_weather_process()
	var/has_process = FALSE
	var/lightning_chance = 0

	/// How much will this weather smother fires on turfs and on mobs - should be 0 to 10
	var/fire_smothering_strength = 0

	/// If this weather event should wash away decals exposed to it
	var/cleaning = TRUE

/datum/weather_event/proc/start_weather_event()
	return

// remember, this happens every five seconds or so
/datum/weather_event/proc/handle_weather_process()
	if(lightning_chance && prob(lightning_chance))
		playsound_z(SSmapping.levels_by_trait(ZTRAIT_GROUND), pick('sound/soundscape/thunderclap1.ogg', 'sound/soundscape/thunderclap2.ogg'))
		for(var/mob/mob as anything in GLOB.mob_list)
			if(mob.hud_used)
				var/atom/movable/screen/plane_master/lighting/exterior/exterior_lighting = mob.hud_used.plane_masters["[EXTERIOR_LIGHTING_PLANE]"]
				if(exterior_lighting)
					exterior_lighting.alpha = 0
					animate(exterior_lighting, 1.5 SECONDS, alpha = min(GLOB.minimum_exterior_lighting_alpha, mob.lighting_alpha))

/datum/weather_event/proc/process_mob_effect(mob/living/carbon/affected_mob, delta_time = 1)
	if(effect_message && prob(WEATHER_MESSAGE_PROB))
		to_chat(affected_mob, SPAN_WARNING(effect_message))
	if(damage_per_tick)
		var/calculated_damage = (isxeno(affected_mob) ? damage_per_tick * 3 : damage_per_tick) * delta_time
		affected_mob.apply_damage(calculated_damage, damage_type)
		affected_mob.last_damage_data = create_cause_data("Exposure")
