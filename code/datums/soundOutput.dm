/datum/soundOutput
	var/client/owner
	var/scape_cooldown = INITIAL_SOUNDSCAPE_COOLDOWN //This value is changed when entering an area. Time it takes for a soundscape sound to be triggered
	var/list/soundscape_playlist = list() //Updated on changing areas
	var/ambience = null //The file currently being played as ambience
	var/status_flags = 0 //For things like ear deafness, psychodelic effects, and other things that change how all sounds behave

	/// Currently applied environmental reverb.
	VAR_PROTECTED/owner_environment = SOUND_ENVIRONMENT_NONE

/datum/soundOutput/New(client/client)
	if(!client)
		qdel(src)
		return
	owner = client
	RegisterSignal(owner.mob, COMSIG_MOVABLE_MOVED, PROC_REF(on_mob_moved))
	RegisterSignal(owner.mob, COMSIG_MOB_LOGOUT, PROC_REF(on_mob_logout))
	RegisterSignal(owner, COMSIG_CLIENT_MOB_LOGGED_IN, PROC_REF(on_client_mob_logged_in))
	return ..()

/datum/soundOutput/Destroy()
	owner = null
	return ..()

/datum/soundOutput/proc/process_sound(datum/sound_template/T)
	var/sound/S = sound(T.file, T.wait, T.repeat)
	S.volume = owner.prefs.volume_preferences[T.volume_cat] * T.volume
	if(T.channel == 0)
		S.channel = get_free_channel()
	else
		S.channel = T.channel
	S.frequency = T.frequency
	S.falloff = T.falloff
	S.status = T.status
	if(T.x && T.y && T.z)
		var/turf/owner_turf = get_turf(owner.mob)
		if(owner_turf)
			// We're in an interior and sound came from outside
			if(SSinterior.in_interior(owner_turf) && owner_turf.z != T.z)
				var/datum/interior/VI = SSinterior.get_interior_by_coords(owner_turf.x, owner_turf.y, owner_turf.z)
				if(VI && VI.exterior)
					var/turf/candidate = get_turf(VI.exterior)
					if(candidate.z != T.z)
						return // Invalid location
					S.falloff /= 2
					owner_turf = candidate
			S.x = T.x - owner_turf.x
			S.y = T.z - owner_turf.z
			S.z = T.y - owner_turf.y
		S.y += T.y_s_offset
		S.x += T.x_s_offset
		S.echo = SOUND_ECHO_REVERB_ON //enable environment reverb for positional sounds
	for(var/pos = 1 to length(T.echo))
		if(!T.echo[pos])
			continue
		S.echo[pos] = T.echo[pos]
	if(owner.mob.ear_deaf > 0)
		S.status |= SOUND_MUTE

	sound_to(owner, S)

/datum/soundOutput/proc/update_ambience(area/target_area, ambience_override, force_update = FALSE)
	var/status_flags = SOUND_STREAM
	var/target_ambience = ambience_override

	if(!(owner.prefs.toggles_sound & SOUND_AMBIENCE))
		if(!force_update)
			return
		status_flags |= SOUND_MUTE

	// Autodetect mode
	if(!target_area && !target_ambience)
		target_area = get_area(owner.mob)
		if(!target_area)
			return
	if(!target_ambience)
		target_ambience = target_area.get_sound_ambience(owner)
	if(target_area)
		soundscape_playlist = target_area.soundscape_playlist

	var/sound/S = sound(null,1,0,SOUND_CHANNEL_AMBIENCE)

	if(ambience == target_ambience)
		if(!force_update)
			return
		status_flags |= SOUND_UPDATE
	else
		S.file = target_ambience
		ambience = target_ambience


	S.volume = 100 * owner.prefs.volume_preferences[VOLUME_AMB]
	S.status = status_flags

	if(target_area)
		var/muffle
		if(target_area.ceiling_muffle)
			switch(target_area.ceiling)
				if(CEILING_NONE)
					muffle = 0
				if(CEILING_GLASS)
					muffle = MUFFLE_MEDIUM
				if(CEILING_METAL)
					muffle = MUFFLE_HIGH
				else
					S.volume = 0
		muffle += target_area.base_muffle
		S.echo = list(muffle)
	sound_to(owner, S)


/datum/soundOutput/proc/update_soundscape()
	scape_cooldown--
	if(scape_cooldown <= 0)
		if(length(soundscape_playlist))
			var/sound/S = sound()
			S.file = pick(soundscape_playlist)
			S.volume = 100 * owner.prefs.volume_preferences[VOLUME_AMB]
			S.x = pick(1,-1)
			S.z = pick(1,-1)
			S.y = 1
			S.channel = SOUND_CHANNEL_SOUNDSCAPE
			sound_to(owner, S)
		var/area/A = get_area(owner.mob)
		if(A)
			scape_cooldown = pick(A.soundscape_interval, A.soundscape_interval + 1, A.soundscape_interval -1)
		else
			scape_cooldown = INITIAL_SOUNDSCAPE_COOLDOWN

/datum/soundOutput/proc/apply_status()
	var/sound/S = sound()
	if(status_flags & EAR_DEAF_MUTE)
		S.status = SOUND_MUTE | SOUND_UPDATE
		sound_to(owner, S)
	else
		S.status = SOUND_UPDATE
		sound_to(owner, S)

/// Pulls mob's area's sound_environment and applies if necessary and not overridden.
/datum/soundOutput/proc/update_area_environment()
	var/area/owner_area = get_area(owner.mob)
	if(!owner_area)
		return
	var/new_environment = owner_area.sound_environment

	if(owner.mob.sound_environment_override != SOUND_ENVIRONMENT_NONE) //override in effect, can't apply
		return

	set_owner_environment(new_environment)

/// Pulls mob's sound_environment_override and applies if necessary.
/datum/soundOutput/proc/update_mob_environment_override()
	var/new_environment_override = owner.mob.sound_environment_override

	if(new_environment_override == SOUND_ENVIRONMENT_NONE) //revert to area environment
		update_area_environment()
		return

	set_owner_environment(new_environment_override)

/// Pushes new_environment to owner and updates owner_environment var.
/datum/soundOutput/proc/set_owner_environment(new_environment = SOUND_ENVIRONMENT_NONE)
	if(new_environment ~= src.owner_environment) //no need to change
		return

	var/sound/sound = sound()
	sound.environment = new_environment
	sound_to(owner, sound)

	src.owner_environment = new_environment

/datum/soundOutput/proc/on_mob_moved(datum/source, atom/oldloc, direction, Forced)
	SIGNAL_HANDLER //COMSIG_MOVABLE_MOVED
	update_area_environment()

/datum/soundOutput/proc/on_mob_logout(datum/source)
	SIGNAL_HANDLER //COMSIG_MOB_LOGOUT
	UnregisterSignal(owner.mob, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_LOGOUT))

/datum/soundOutput/proc/on_client_mob_logged_in(datum/source, mob/new_mob)
	SIGNAL_HANDLER //COMSIG_CLIENT_MOB_LOGGED_IN
	RegisterSignal(owner.mob, COMSIG_MOVABLE_MOVED, PROC_REF(on_mob_moved))
	RegisterSignal(owner.mob, COMSIG_MOB_LOGOUT, PROC_REF(on_mob_logout))
	update_mob_environment_override()

/client/proc/adjust_volume_prefs(volume_key, prompt = "", channel_update = 0)
	prefs.volume_preferences[volume_key] = (tgui_input_number(src, prompt, "Volume", prefs.volume_preferences[volume_key]*100)) / 100
	if(prefs.volume_preferences[volume_key] > 1)
		prefs.volume_preferences[volume_key] = 1
	if(prefs.volume_preferences[volume_key] < 0)
		prefs.volume_preferences[volume_key] = 0

	prefs.save_preferences()

	if(channel_update)
		var/sound/S = sound()
		S.channel = channel_update
		S.volume = 100 * prefs.volume_preferences[volume_key]
		S.status = SOUND_UPDATE
		sound_to(src, S)

/client/verb/adjust_volume_sfx()
	set name = "Adjust Volume SFX"
	set category = "Preferences.Sound"
	adjust_volume_prefs(VOLUME_SFX, "Set the volume for sound effects", 0)

/client/verb/adjust_volume_ambience()
	set name = "Adjust Volume Ambience"
	set category = "Preferences.Sound"
	adjust_volume_prefs(VOLUME_AMB, "Set the volume for ambience and soundscapes", 0)
	soundOutput.update_ambience(null, null, TRUE)

/client/verb/adjust_volume_lobby_music()
	set name = "Adjust Volume LobbyMusic"
	set category = "Preferences.Sound"
	adjust_volume_prefs(VOLUME_LOBBY, "Set the volume for Lobby Music", SOUND_CHANNEL_LOBBY)
