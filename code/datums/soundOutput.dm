/datum/soundOutput
	var/client/owner
	var/scape_cooldown = INITIAL_SOUNDSCAPE_COOLDOWN //This value is changed when entering an area. Time it takes for a soundscape sound to be triggered
	var/list/soundscape_playlist = list() //Updated on changing areas
	var/ambience = null //The file currently being played as ambience
	var/status_flags = 0 //For things like ear deafness, psychodelic effects, and other things that change how all sounds behave

	/// Currently applied environmental reverb.
	VAR_PROTECTED/owner_environment = SOUND_ENVIRONMENT_NONE
	/// Assoc list of tracked channels currently playing on the client and their assigned template, in the form of: "[channel]" = template
	var/list/channel_templates = list()

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
	UnregisterSignal(owner.mob, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_LOGOUT))
	UnregisterSignal(owner, COMSIG_CLIENT_MOB_LOGGED_IN)
	owner = null
	return ..()

/**
 * Translates a sound_template into an appropriate sound for the owner and sends it.
 *
 * Arguments:
 * * template - the sound_template
 * * update - if truthy updates the existing sound on the template's channel, otherwise overwrites it
 */
/datum/soundOutput/proc/process_template(datum/sound_template/template, update = FALSE)
	var/sound/sound = template.get_sound(update)

	sound.volume *= owner.volume_preferences[template.volume_cat]

	if(template.sound_flags & SOUND_TEMPLATE_CAN_DEAFEN && src.status_flags & EAR_DEAF_MUTE)
		sound.status |= SOUND_MUTE

	if(template.sound_flags & SOUND_TEMPLATE_TRACKED && !update)
		channel_templates["[sound.channel]"] = template

	if(!(template.sound_flags & SOUND_TEMPLATE_SPATIAL)) //non-spatial
		sound.x = template.x
		sound.y = template.y
		sound.z = template.z
		sound_to(owner, sound)
		return

	var/turf/owner_turf = get_turf(owner.mob)
	var/turf/source_turf = get_turf(template.source)
	//soundsys only traverses one "step", so will never send from one interior to another
	if(owner_turf.z == source_turf.z) //both in exterior, or both in same interior
		sound.x = source_turf.x - owner_turf.x
		sound.z = source_turf.y - owner_turf.y
	else if(SSinterior.in_interior(owner_turf)) //source in exterior, owner in interior
		var/datum/interior/interior = SSinterior.get_interior_by_coords(owner_turf.x, owner_turf.y, owner_turf.z)
		sound.falloff *= 0.5
		sound.x = source_turf.x - interior.exterior.x
		sound.z = source_turf.y - interior.exterior.y
	else if(SSinterior.in_interior(source_turf)) //source in interior, owner in exterior
		var/datum/interior/interior = SSinterior.get_interior_by_coords(source_turf.x, source_turf.y, source_turf.z)
		sound.falloff *= 0.5
		sound.x = interior.exterior.x - owner_turf.x
		sound.z = interior.exterior.y - owner_turf.y
	else //moved to unrelated z while sound was playing, leave it alone
		return

	sound_to(owner, sound)

/datum/soundOutput/proc/update_tracked_channels()
	for(var/channel as anything in channel_templates)
		var/datum/sound_template/template = channel_templates[channel]
		if(!(template.sound_flags & SOUND_TEMPLATE_SPATIAL))
			continue
		if(template.source == owner.mob)
			continue
		process_template(template, update = TRUE)

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


	S.volume = 100 * owner.volume_preferences[VOLUME_AMB]
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
			S.volume = 100 * owner.volume_preferences[VOLUME_AMB]
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
	SSsound.hearer_updates |= owner

/datum/soundOutput/proc/on_mob_logout(datum/source)
	SIGNAL_HANDLER //COMSIG_MOB_LOGOUT
	UnregisterSignal(owner.mob, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_LOGOUT))

/datum/soundOutput/proc/on_client_mob_logged_in(datum/source, mob/new_mob)
	SIGNAL_HANDLER //COMSIG_CLIENT_MOB_LOGGED_IN
	RegisterSignal(owner.mob, COMSIG_MOVABLE_MOVED, PROC_REF(on_mob_moved))
	RegisterSignal(owner.mob, COMSIG_MOB_LOGOUT, PROC_REF(on_mob_logout))
	update_mob_environment_override()

/client/proc/adjust_volume_prefs(volume_key, prompt = "", channel_update = 0)
	volume_preferences[volume_key] = (tgui_input_number(src, prompt, "Volume", volume_preferences[volume_key]*100)) / 100
	if(volume_preferences[volume_key] > 1)
		volume_preferences[volume_key] = 1
	if(volume_preferences[volume_key] < 0)
		volume_preferences[volume_key] = 0
	if(channel_update)
		var/sound/S = sound()
		S.channel = channel_update
		S.volume = 100 * volume_preferences[volume_key]
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
