/datum/soundOutput
	var/client/owner 
	var/scape_cooldown				= INITIAL_SOUNDSCAPE_COOLDOWN //This value is changed when entering an area. Time it takes for a soundscape sound to be triggered
	var/list/soundscape_playlist 	= list() //Updated on changing areas
	var/ambience 					= null //The file currently being played as ambience
	var/status_flags 				= 0 //For things like ear deafness, psychodelic effects, and other things that change how all sounds behave

/datum/soundOutput/New(client/C)
	if(!C)
		qdel(src)
		return	
	owner = C
	. = ..()

/datum/soundOutput/proc/process_sound(datum/sound_template/T)
	var/sound/S = sound(T.file, T.wait, T.repeat)
	S.volume = owner.volume_preferences[T.volume_cat] * T.volume
	if(T.channel == 0)
		S.channel = get_free_channel()
	else
		S.channel = T.channel
	S.frequency = T.frequency
	if(T.x && T.y && T.z)		
		var/turf/owner_turf = get_turf(owner.mob)
		if(owner_turf)
			S.x = T.x - owner_turf.x
			S.y = 0
			S.z = T.y - owner_turf.y
			S.falloff = T.falloff
	S.status = T.status
	if(owner.mob.ear_deaf > 0)
		S.status |= SOUND_MUTE

	sound_to(owner,S)

/datum/soundOutput/proc/update_ambience(area/new_area, force_cur_amb)
	if(!istype(new_area))
		new_area = get_area(owner.mob)

	soundscape_playlist = new_area.soundscape_playlist

	var/sound/S = sound(null,1,0,SOUND_CHANNEL_AMBIENCE)
	
	S.volume = 100 * owner.volume_preferences[VOLUME_AMB]
	S.environment = new_area.sound_environment
	S.status = SOUND_STREAM
	
	if(!force_cur_amb)
		if(new_area.ambience_exterior == ambience)
			S.status |= SOUND_UPDATE
		else 
			ambience = new_area.ambience_exterior
	
	var/muffle
	if(new_area.ceiling_muffle)
		switch(new_area.ceiling)
			if(CEILING_NONE)
				muffle = 0 
			if(CEILING_GLASS)
				muffle = MUFFLE_MEDIUM
			if(CEILING_METAL)
				muffle = MUFFLE_HIGH
			else
				S.volume = 0
	
	muffle += new_area.base_muffle
	
	S.echo = list(muffle)
	S.file = ambience
	if(!owner.prefs.toggles_sound & SOUND_AMBIENCE)
		S.status |= SOUND_MUTE
	sound_to(owner, S)


/datum/soundOutput/proc/update_soundscape()
	scape_cooldown--
	if(scape_cooldown <= 0)
		if(soundscape_playlist.len)
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

/client/verb/adjust_volume_sfx()
	set name = "S : Adjust Volume SFX"
	set category = "Preferences"
	volume_preferences[VOLUME_SFX]	= (input("Set the volume for sound effects", "Volume", volume_preferences[VOLUME_SFX]*100) as num) / 100
	if(volume_preferences[VOLUME_SFX] > 1)
		volume_preferences[VOLUME_SFX] = 1
	if(volume_preferences[VOLUME_SFX] < 0)
		volume_preferences[VOLUME_SFX] = 0
			
/client/verb/adjust_volume_ambience()
	set name = "S : Adjust Volume Ambience"
	set category = "Preferences"
	volume_preferences[VOLUME_AMB]	= (input("Set the volume for ambience sounds and music", "Volume", volume_preferences[VOLUME_AMB]*100) as num) / 100
	if(volume_preferences[VOLUME_AMB] > 1)
		volume_preferences[VOLUME_AMB] = 1
	if(volume_preferences[VOLUME_AMB] < 0)
		volume_preferences[VOLUME_AMB] = 0			
	soundOutput.update_ambience()

/client/verb/adjust_volume_admin_music()
	set name = "S : Adjust Volume Admin Music"
	set category = "Preferences"
	volume_preferences[VOLUME_ADM]	= (input("Set the volume for admin music", "Volume", volume_preferences[VOLUME_ADM] *100) as num) / 100
	if(volume_preferences[VOLUME_ADM] > 1)
		volume_preferences[VOLUME_ADM] = 1
	if(volume_preferences[VOLUME_ADM] < 0)
		volume_preferences[VOLUME_ADM] = 0	
	var/sound/S = sound()
	S.channel = SOUND_CHANNEL_ADMIN_MIDI
	S.volume = 100 * volume_preferences[VOLUME_ADM]
	S.status = SOUND_UPDATE
	sound_to(src, S)
