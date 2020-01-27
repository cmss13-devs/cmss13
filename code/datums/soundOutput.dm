/datum/soundOutput
	var/client/owner 
	var/ambience 					= null //The file currently being played as ambience
	var/scape_cooldown				= INITIAL_SOUNDSCAPE_COOLDOWN //This value is changed when entering an area. Time it takes for a soundscape sound to be triggered
	var/list/soundscape_playlist 	= list() //Updated on changing areas
	var/list/globalsounds_channels	= list() //Assoc list of global sound - assigned channel. Used with the Global Sounds SS
	var/status_flags 				= 0 //For things like ear deafness, psychodelic effects, and other things that change how all sounds behave
	var/last_free_chan 				= 1 //The last channel given out by get_free_channel()

/datum/soundOutput/New(client/C)
	if(!C)
		qdel(src)
		return	
	owner = C
	. = ..()

/datum/soundOutput/proc/process_sound(soundin, atom/emit_pos, relat_vol, frequency, vol_cat = VOLUME_SFX, channel, status, falloff_mod = 1)
	var/sound/S = sound(soundin)
	S.volume = owner.volume_preferences[vol_cat] * relat_vol

	if(!channel)
		S.channel = get_free_channel()
	else
		S.channel = channel
	
	S.frequency = frequency
	var/muffling = 0
	var/turf/T = get_turf(emit_pos)
	if(isturf(T))
		var/turf/owner_turf = get_turf(owner.mob)
		S.x = emit_pos.x - owner_turf.x
		S.y = 0
		S.z = emit_pos.y - owner_turf.y
		S.falloff = FALLOFF_SOUNDS * falloff_mod * max(round(S.volume * 0.025), 1)

		if(status & SOUND_MUFFLE)
			var/dist = get_dist(emit_pos, owner.mob)
			var/list/line = getline2(emit_pos, owner.mob)
			for(var/turf/closed/C in line)
				if(C.sound_muffling < muffling)
					muffling = C.sound_muffling
			if(dist <= 1 && muffling != 0)
				muffling = MUFFLE_LOW
			if(muffling > 0)
				S.falloff = (500 / muffling) * -1
			S.echo = list(muffling)
			
	S.status = status
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

/datum/soundOutput/proc/on_movement(atom/A)
	update_globalsounds()

//Someone might ask why even have the subsystem time the duration of the sound instead of letting
//soundOutput do so in process(). Well, that would mean giving one base copy of each global sound
//to every player and losing the ability to modify the base sound for everyone equally

/datum/soundOutput/proc/update_globalsound_list()//This proc's purpose is to add our own channel to each sound in the SS
	if(SSglobal_sound.soundlen_map.len)
		var/sound/S = sound()	
		for(var/sound/I in SSglobal_sound.soundlen_map)
			if(!istype(I))
				continue
			if(!globalsounds_channels[I]) 
				globalsounds_channels[I] = get_free_channel()
				S.file = I.file
				S.status = SOUND_MUTE
				S.channel = globalsounds_channels[I]
				S.y = 1 //A hack way of making BYOND treat this sound as 3D
				sound_to(owner, S) //Send the sound we just received to the owner but muted, so we can use SOUND_UPDATE on update_global_sounds
		update_globalsounds()

/datum/soundOutput/proc/update_globalsounds()//This proc deals with removing references to sounds that have ended and also with updating their position relative to us	
	if(globalsounds_channels.len)
		var/sound/S = sound()
		var/turf/owner_turf = get_turf(owner.mob)
		for(var/sound/I in globalsounds_channels)
			if(!istype(I) || I.disposed)
				globalsounds_channels -= I
				continue
			S.file = I.file
			S.falloff = I.falloff / 5 //One fifth of the range will be an area where the volume is unaltered
			S.status = SOUND_UPDATE
			S.channel = globalsounds_channels[I]//The advantage of having the subsystem keep the sound
			S.volume = I.volume * owner.volume_preferences[VOLUME_SFX]
			S.x = I.x - owner_turf.x
			S.z = I.y - owner_turf.y
			S.y = 1
			if(I.z != owner_turf.z || abs(S.x) > I.falloff || abs(S.z) > I.falloff  || owner.mob.ear_deaf > 0) 
				S.status |= SOUND_MUTE
			sound_to(owner, S)
		return TRUE
	else
		return FALSE

/datum/soundOutput/proc/get_free_channel()	
	. = last_free_chan++
	if(last_free_chan > FREE_CHAN_END) last_free_chan = 1

/datum/soundOutput/proc/process()
	
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

	if(status_flags != 0)
		if(owner.mob.stat == DEAD)
			var/sound/S = sound()
			S.channel = 0
			S.status = SOUND_UPDATE
			sound_to(owner, S)
			status_flags = 0
			return
		
		if(iscarbon(owner.mob))
			var/mob/living/carbon/C = owner.mob
			if((status_flags & EAR_DEAF_MUTE) && C.ear_deaf <= 0)
				// Unmute all channels
				var/sound/S = sound(null)
				S.status = SOUND_UPDATE
				sound_to(owner, S)
				status_flags ^= EAR_DEAF_MUTE

/datum/soundOutput/proc/apply_status()
	if(status_flags & EAR_DEAF_MUTE)
		var/sound/S = sound()
		S.status = SOUND_MUTE | SOUND_UPDATE
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
