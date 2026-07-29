// Source: https://pixabay.com/sound-effects/film-special-effects-long-blinker-loop-24863/
/datum/looping_sound/turn_signal
	mid_sounds = 'sound/vehicles/blinkerloop.ogg'
	mid_length = 1.2 SECONDS
	volume = 35

// Source: https://pixabay.com/sound-effects/film-special-effects-tank-turret-rotate-14879/
/datum/looping_sound/tank_turret
	mid_sounds = 'sound/vehicles/tankturret.ogg'
	mid_length = 1 SECONDS
	// Matches this file's other vehicle loops. Also applies to turretdamaged.ogg.
	volume = 25

// Source: freesound.org/s/541240/ (Garuda1982, Attribution 4.0). See sound/ATTRIBUTION.txt
/datum/looping_sound/tank_tracks
	mid_sounds = 'sound/vehicles/trackrattling.ogg'
	mid_length = 1 SECONDS
	volume = 25
	/// Fixed channel reused for every play(), so on_stop() can immediately cut whatever's still playing.
	var/track_channel

/datum/looping_sound/tank_tracks/play(soundfile, volume_override)
	if(!track_channel)
		track_channel = get_free_channel()
	playsound(parent, soundfile, volume_override || volume, vary, extra_range, VOLUME_SFX, track_channel)

/**
 * Immediately silences whatever's still playing on track_channel, both to seated crew and to
 * anyone near the vehicle outside it.
 */
/datum/looping_sound/tank_tracks/on_stop()
	..()
	if(!track_channel || !parent)
		return

	var/obj/vehicle/multitile/vehicle = parent
	if(istype(vehicle))
		for(var/client/crew_client in vehicle.get_interior_mob_clients())
			SEND_SOUND(crew_client, sound(null, channel = track_channel))

	var/turf/source_turf = get_turf(parent)
	if(!source_turf)
		return
	var/datum/sound_template/template = new()
	template.channel = track_channel
	template.x = source_turf.x
	template.y = source_turf.y
	template.z = source_turf.z
	template.range = extra_range || floor(0.25 * volume)
	SSsound.queue(template)

// Source: freesound.org/s/681435/ (Department64, Attribution 4.0). See sound/ATTRIBUTION.txt
/datum/looping_sound/tank_drift
	mid_sounds = 'sound/vehicles/treadedDrift.ogg'
	// treadedDrift.ogg's exact duration. mid_length must match precisely or the loop cuts short or gaps.
	mid_length = 1.289478 SECONDS
	volume = 25
	/// Same reasoning as tank_tracks' track_channel above.
	var/drift_channel

/datum/looping_sound/tank_drift/play(soundfile, volume_override)
	if(!drift_channel)
		drift_channel = get_free_channel()
	playsound(parent, soundfile, volume_override || volume, vary, extra_range, VOLUME_SFX, drift_channel)

/// Same reasoning and mechanism as tank_tracks/on_stop() above.
/datum/looping_sound/tank_drift/on_stop()
	..()
	if(!drift_channel || !parent)
		return

	var/obj/vehicle/multitile/vehicle = parent
	if(istype(vehicle))
		for(var/client/crew_client in vehicle.get_interior_mob_clients())
			SEND_SOUND(crew_client, sound(null, channel = drift_channel))

	var/turf/source_turf = get_turf(parent)
	if(!source_turf)
		return
	var/datum/sound_template/template = new()
	template.channel = drift_channel
	template.x = source_turf.x
	template.y = source_turf.y
	template.z = source_turf.z
	template.range = extra_range || floor(0.25 * volume)
	SSsound.queue(template)

// Source: freesound.org/s/542582/ (adr1911, Creative Commons 0). See sound/ATTRIBUTION.txt
/datum/looping_sound/tank_engine
	mid_sounds = 'sound/vehicles/turbineidle.ogg'
	volume = ENGINE_SOUND_MIN_VOLUME
	/// turbineidle.ogg's real duration at its native frequency. Raising playback frequency for the
	/// pitch effect shrinks the clip length, so this subtype reschedules off the real per-play
	/// duration instead of a fixed mid_length. See sound_loop() below.
	var/native_duration = 2.630260
	// Played once before the loop starts / once after it stops. Both route through this subtype's
	// play() override, so they get the same speed-based volume/pitch treatment.
	start_sound = 'sound/vehicles/turbinestartup.ogg'
	start_length = 5.054898 SECONDS
	end_sound = 'sound/vehicles/turbineoff.ogg'
	/// Fixed channels reused for every play(), same reasoning as tank_tracks/track_channel above.
	var/crew_channel
	var/outside_channel

/**
 * Overrides the base play() entirely. Volume/frequency are computed fresh each trigger from
 * whichever of current_speed or engine_rev_level is currently higher.
 *
 * Sends ttwo separate copies via play_direct_to_crew() and play_to_outside_hearers(), so both the
 * crew and anyone standing near the tank hear the engine without doubling up.
 *
 * Arguments:
 * * soundfile = The sound file picked by get_sound().
 * * volume_override = Unused. Volume is always computed from speed/revving for this subtype.
 *
 * Returns:
 * * The frequency actually used to play this instance, so sound_loop() can reschedule off the
 *   real pitch-shifted playback duration.
 */
/datum/looping_sound/tank_engine/play(soundfile, volume_override)
	var/obj/vehicle/multitile/vehicle = parent
	var/speed_fraction = 0
	if(istype(vehicle) && vehicle.uses_gear_transmission)
		var/list/stats = vehicle.get_current_gear_stats()
		if(stats["max_speed"])
			// current_speed and drift_speed sit on perpendicular axes, so this combines them as a
			// vector magnitude instead of a flat sum.
			var/effective_speed = sqrt(vehicle.current_speed ** 2 + vehicle.drift_speed ** 2)
			speed_fraction = clamp(effective_speed / stats["max_speed"], 0, 1)

	// Revving in Park/Neutral never moves current_speed. Blended in as a separate fraction (not
	// added) so idle revving sounds as loud/pitched as reaching that fraction of top speed would.
	var/rev_fraction = istype(vehicle) ? vehicle.engine_rev_level : 0
	var/effective_fraction = max(speed_fraction, rev_fraction)

	var/computed_volume = ENGINE_SOUND_MIN_VOLUME + effective_fraction * (ENGINE_SOUND_MAX_VOLUME - ENGINE_SOUND_MIN_VOLUME)
	var/computed_frequency = ENGINE_SOUND_MIN_FREQUENCY + effective_fraction * (ENGINE_SOUND_MAX_FREQUENCY - ENGINE_SOUND_MIN_FREQUENCY)

	play_direct_to_crew(vehicle, soundfile, computed_volume, computed_frequency)
	play_to_outside_hearers(vehicle, soundfile, computed_volume, computed_frequency)
	return computed_frequency

/**
 * Queues a sound_template to every client inside the vehicle's interior, seated or not, so it's
 * also audible to unbuckled crew walking around the fighting compartment.
 *
 * Deliberately leaves template.x/y/z unset so the sound plays centered, same as any other
 * non-positional sound, rather than going through the world-posittion/stereo-pan/reverb branch.
 *
 * Arguments:
 * * vehicle = The vehicle whose interior occupants shoul hear this.
 * * soundfile = The sound file to play.
 * * sound_volume = Playback volume.
 * * sound_frequency = Playback frequency (pitch/speed) override.
 */
/datum/looping_sound/tank_engine/proc/play_direct_to_crew(obj/vehicle/multitile/vehicle, soundfile, sound_volume, sound_frequency)
	if(!istype(vehicle))
		return

	var/list/hearer_clients = vehicle.get_interior_mob_clients()
	if(!length(hearer_clients))
		return

	if(!crew_channel)
		crew_channel = get_free_channel()

	var/datum/sound_template/template = new()
	template.file = get_sfx(soundfile)
	template.volume = sound_volume
	template.frequency = sound_frequency
	template.channel = crew_channel
	SSsound.queue(template, hearer_clients)

/**
 * Queues a normal positional sound_template centered on the vehicle's exterior turf, for anyone
 * standing near it on the main map.
 *
 * Built manualy rather than via playsound() to skip its automatic interior-forwarding step,
 * which would otherwise double up with play_direct_to_crew()'s copy.
 *
 * Arguments:
 * * vehicle = The vehicle the sound originates from.
 * * soundfile = The sound file to play.
 * * sound_volume = Playback volume.
 * * sound_frequency = Playback frequency (pitch/speed) override.
 */
/datum/looping_sound/tank_engine/proc/play_to_outside_hearers(obj/vehicle/multitile/vehicle, soundfile, sound_volume, sound_frequency)
	var/turf/source_turf = get_turf(vehicle)
	if(!source_turf)
		return

	if(!outside_channel)
		outside_channel = get_free_channel()

	var/datum/sound_template/template = new()
	template.file = get_sfx(soundfile)
	template.volume = sound_volume
	template.frequency = sound_frequency
	template.channel = outside_channel
	template.x = source_turf.x
	template.y = source_turf.y
	template.z = source_turf.z
	template.range = max(ENGINE_SOUND_MIN_RANGE, floor(0.25 * sound_volume))
	// falloff is the range before volume starts dropping. Half of range keeps it strong through
	// the inner half of the audible radius, only tapering near the edge.
	template.falloff = template.range * 0.5

	SSsound.queue(template)

/**
 * Immediately silences whatever's still playing on the crew/outside channels, same trick as
 * tank_tracks/on_stop() doubled up for two channels. Runs before ..() so the shutdown one-shot
 * starts clean instead of racing the idle loop's tail.
 */
/datum/looping_sound/tank_engine/on_stop()
	if(crew_channel && parent)
		var/obj/vehicle/multitile/vehicle = parent
		if(istype(vehicle))
			for(var/client/crew_client in vehicle.get_interior_mob_clients())
				SEND_SOUND(crew_client, sound(null, channel = crew_channel))

	if(outside_channel)
		var/turf/source_turf = get_turf(parent)
		if(source_turf)
			var/datum/sound_template/template = new()
			template.channel = outside_channel
			template.x = source_turf.x
			template.y = source_turf.y
			template.z = source_turf.z
			template.range = extra_range || floor(0.25 * volume)
			SSsound.queue(template)

	..()

/// Doesn't use the base TIMER_LOOP since clip duration changes with pitch. Schedules its own
/// first play() and lets sound_loop() reschedule itself each time.
/datum/looping_sound/tank_engine/start_sound_loop()
	loop_started = TRUE
	sound_loop()

/**
 * Re-implements the base sound_loop() to reschedule off the actual pitch-shifted playback
 * duration instead of a fixed mid_length, avoiding an audible gap between loops.
 */
/datum/looping_sound/tank_engine/sound_loop(start_time)
	if(!parent)
		return

	var/computed_frequency = play(get_sound())
	var/playback_duration = native_duration * (ENGINE_SOUND_MIN_FREQUENCY / computed_frequency)
	timer_id = addtimer(CALLBACK(src, PROC_REF(sound_loop)), playback_duration SECONDS, TIMER_CLIENT_TIME | TIMER_STOPPABLE | TIMER_DELETE_ME, timer_subsystem = SSsound_loops)

// Source: quicksounds.com/sound/21067/tank-m551-start-stop. See sound/ATTRIBUTION.txt
/datum/looping_sound/tank_engine/apc
	mid_sounds = 'sound/vehicles/apcidle.ogg'
	native_duration = 1.662653
	start_sound = 'sound/vehicles/apcstart.ogg'
	start_length = 3.052517 SECONDS
	end_sound = 'sound/vehicles/apcstop.ogg'

// Source: quicksounds.com/sound/21044/tank-m2-bradley-start-and-stop. See sound/ATTRIBUTION.txt
/datum/looping_sound/tank_engine/arc
	mid_sounds = 'sound/vehicles/arcidle.ogg'
	native_duration = 3.058571
	start_sound = 'sound/vehicles/arcstart.ogg'
	start_length = 5.019161 SECONDS
	end_sound = 'sound/vehicles/arcstop.ogg'
