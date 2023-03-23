/datum/soundOutput
	var/client/owner
	var/scape_cooldown = INITIAL_SOUNDSCAPE_COOLDOWN //This value is changed when entering an area. Time it takes for a soundscape sound to be triggered
	var/list/soundscape_playlist = list() //Updated on changing areas
	var/ambience = null //The file currently being played as ambience
	var/status_flags = 0 //For things like ear deafness, psychodelic effects, and other things that change how all sounds behave
	var/list/echo
/datum/soundOutput/New(client/C)
	if(!C)
		qdel(src)
		return
	owner = C
	. = ..()

/datum/soundOutput/proc/process_sound(datum/sound_template/T)
	var/sound/current_sound = sound(T.file, T.wait, T.repeat)
	current_sound.volume = owner.volume_preferences[T.volume_cat] * T.volume
	if(T.channel == 0)
		current_sound.channel = get_free_channel()
	else
		current_sound.channel = T.channel
	current_sound.frequency = T.frequency
	current_sound.falloff = T.falloff
	current_sound.status = T.status
	current_sound.echo = T.echo
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
					current_sound.falloff /= 2
					owner_turf = candidate
			current_sound.x = T.x - owner_turf.x
			current_sound.y = 0
			current_sound.z = T.y - owner_turf.y
			var/area/current_area = owner_turf.loc
			current_sound.environment = current_area.sound_environment
		current_sound.y += T.y_s_offset
		current_sound.x += T.x_s_offset
	if(owner.mob.ear_deaf > 0)
		current_sound.status |= SOUND_MUTE

	if(owner.mob.sound_environment_override != SOUND_ENVIRONMENT_NONE)
		current_sound.environment = owner.mob.sound_environment_override

	sound_to(owner,current_sound)

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

	var/sound/current_sound = sound(null,1,0,SOUND_CHANNEL_AMBIENCE)

	if(ambience == target_ambience)
		if(!force_update)
			return
		status_flags |= SOUND_UPDATE
	else
		current_sound.file = target_ambience
		ambience = target_ambience


	current_sound.volume = 100 * owner.volume_preferences[VOLUME_AMB]
	current_sound.status = status_flags

	if(target_area)
		current_sound.environment = target_area.sound_environment
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
					current_sound.volume = 0
		muffle += target_area.base_muffle
		current_sound.echo = list(muffle)
	sound_to(owner, current_sound)


/datum/soundOutput/proc/update_soundscape()
	scape_cooldown--
	if(scape_cooldown <= 0)
		if(soundscape_playlist.len)
			var/sound/current_sound = sound()
			current_sound.file = pick(soundscape_playlist)
			current_sound.volume = 100 * owner.volume_preferences[VOLUME_AMB]
			current_sound.x = pick(1,-1)
			current_sound.z = pick(1,-1)
			current_sound.y = 1
			current_sound.channel = SOUND_CHANNEL_SOUNDSCAPE
			sound_to(owner, current_sound)
		var/area/current_area = get_area(owner.mob)
		if(current_area)
			scape_cooldown = pick(current_area.soundscape_interval, current_area.soundscape_interval + 1, current_area.soundscape_interval -1)
		else
			scape_cooldown = INITIAL_SOUNDSCAPE_COOLDOWN

/datum/soundOutput/proc/apply_status()
	var/sound/current_sound = sound()
	if(status_flags & EAR_DEAF_MUTE)
		current_sound.status = SOUND_MUTE | SOUND_UPDATE
		sound_to(owner, current_sound)
	else
		current_sound.status = SOUND_UPDATE
		sound_to(owner, current_sound)

/client/proc/adjust_volume_prefs(volume_key, prompt = "", channel_update = 0)
	volume_preferences[volume_key] = (tgui_input_number(src, prompt, "Volume", volume_preferences[volume_key]*100)) / 100
	if(volume_preferences[volume_key] > 1)
		volume_preferences[volume_key] = 1
	if(volume_preferences[volume_key] < 0)
		volume_preferences[volume_key] = 0
	if(channel_update)
		var/sound/current_sound = sound()
		current_sound.channel = channel_update
		current_sound.volume = 100 * volume_preferences[volume_key]
		current_sound.status = SOUND_UPDATE
		sound_to(src, current_sound)

/client/verb/adjust_volume_sfx()
	set name = "Adjust Volume SFX"
	set category = "Preferences.Sound"
	adjust_volume_prefs(VOLUME_SFX, "Set the volume for sound effects", 0)

/client/verb/adjust_volume_ambience()
	set name = "Adjust Volume Ambience"
	set category = "Preferences.Sound"
	adjust_volume_prefs(VOLUME_AMB, "Set the volume for ambience and soundscapes", 0)
	soundOutput.update_ambience(null, null, TRUE)

/client/verb/adjust_volume_admin_music()
	set name = "Adjust Volume Admin MIDIs"
	set category = "Preferences.Sound"
	adjust_volume_prefs(VOLUME_ADM, "Set the volume for admin MIDIs", SOUND_CHANNEL_ADMIN_MIDI)

/client/verb/adjust_volume_lobby_music()
	set name = "Adjust Volume LobbyMusic"
	set category = "Preferences.Sound"
	adjust_volume_prefs(VOLUME_LOBBY, "Set the volume for Lobby Music", SOUND_CHANNEL_LOBBY)
