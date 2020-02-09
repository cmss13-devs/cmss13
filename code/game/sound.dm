
/datum/sound_template //Basically a sound datum, but only serves as a way to carry info to soundOutput
	var/file //The sound itself
	var/wait = 0
	var/repeat = 0
	var/channel = 0
	var/volume = 100
	var/status = 0 //Sound status flags
	var/frequency = 1
	var/falloff = 1
	var/volume_cat = VOLUME_SFX
	var/x //Map coordinates, not sound coordinates 
	var/y
	var/z

/proc/get_free_channel()
	var/static/cur_chan = 1	
	. = cur_chan++
	if(cur_chan > FREE_CHAN_END) 
		cur_chan = 1

//Proc used to play a sound effect. Avoid using this proc for non-IC sounds, as there are others
//source: self-explanatory.
//soundin: the .ogg to use.
//vol: the initial volume of the sound, 0 is no sound at all, 75 is loud queen screech.
//vary: to make the frequency var of the sound vary (mostly unused).
//sound_range: the maximum theoretical range (in tiles) of the sound, by default is equal to the volume.
//vol_cat: the category of this sound, used in client volume. There are 3 volume categories: VOLUME_SFX (Sound effects), VOLUME_AMB (Ambience and Soundscapes) and VOLUME_ADM (Admin sounds and some other stuff)
//channel: use this only when you want to force the sound to play on an specific channel
//status: the regular 4 sound flags 
//falloff: max range till sound volume starts dropping as distance increases

/proc/playsound(atom/source, soundin, vol = 100, vary, sound_range, vol_cat = VOLUME_SFX, channel = 0, status , falloff = 1)
	if(isarea(source))
		error("[source] is an area and is trying to make the sound: [soundin]")
		return
	var/datum/sound_template/S = new()

	var/sound/SD = soundin
	if(istype(SD))
		S.file = SD.file
		S.wait = SD.wait
		S.repeat = SD.repeat
	else
		S.file = get_sfx(soundin)
	S.channel = channel ? channel : get_free_channel()
	S.status = status
	S.falloff = falloff

	var/turf/turf_source = get_turf(source)
	if(!turf_source) 
		return
	S.x = turf_source.x 
	S.y = turf_source.y
	S.z = turf_source.z

	S.volume = vol
	S.volume_cat = vol_cat

	if(!sound_range) 
		sound_range = round(0.25*vol) //if no specific range, the max range is equal to a quarter of the volume.
	
	if(vary)
		S.frequency = GET_RANDOM_FREQ // Same frequency for everybody
	
	var/turf/T
	for(var/mob/M in player_list)
		if(!M.client || !M.client.soundOutput) 
			continue
		T = get_turf(M)
		if(get_dist(T, turf_source) <= sound_range && T.z == turf_source.z)
			SSsound.queue(M.client, S)

	// Buuut it doesn't cover vehicle interiors, since they're in a physically different location
	// If you or a loved one are inside a vehicle, you may be eligible for hearing sounds
	for(var/datum/interior/I in interior_manager.interiors)
		if(!I.ready)
			continue

		if(I.exterior.z == turf_source.z && get_dist(I.exterior, turf_source) <= sound_range)
			var/list/bounds = I.get_bound_turfs()
			if(!bounds)
				continue

			for(var/turf/interior_turf in block(bounds[1], bounds[2]))
				// Play the sound to any mobs inside
				for(var/mob/P in interior_turf)
					if(!P.client)
						continue
					P.client.soundOutput.process_sound(S)

//This is the replacement for playsound_local. Use this for sending sounds directly to a client
/proc/playsound_client(client/C, soundin, atom/origin, vol = 100, random_freq, vol_cat = VOLUME_SFX, channel = 0, status)
	if(!istype(C) || !C.soundOutput) return FALSE
	var/datum/sound_template/S = new()
	if(origin)
		var/turf/T = get_turf(origin)
		if(T)
			S.x = T.x
			S.y = T.y
			S.z = T.z
	S.file = soundin
	if(random_freq)
		S.frequency = GET_RANDOM_FREQ
	S.volume = vol
	S.volume_cat = vol_cat
	S.channel = channel
	S.status = status
	SSsound.queue(C, S)

//Use this proc for things like OBs, dropships, or anything that plays a lenghty sound that needs to be heard even by those who arrive late
/proc/playsound_spacial(atom/source, soundin, vol = 100, falloff = 1, duration, range = 30)
	var/sound/S = sound(soundin)
	S.falloff = falloff //As DM reference states, all sound within this range will keep at max vol.
	S.channel = get_free_channel()
	S.volume = vol
	S.x = 1 //Adding coords is vital for the update in update_sound_pos to work,
	S.y = 1 //given that SOUND_UPDATE won't update a sound's coords if it was given none initially
	S.z = 1 //(this isn't 100% confirmed, but after many tests it seems to be the case)
	S.status = SOUND_MUTE //Send it muted
	sound_to(world, S)
	SSspacial_sound.add_spacial_sound(S, source, range, duration)
	for(var/client/C in clients)
		if(!C || !C.soundOutput)
			continue
		C.soundOutput.update_sound_pos()


//Self explanatory
/proc/playsound_area(area/A, soundin, vol = 100, channel, status, vol_cat = VOLUME_SFX)
	if(!isarea(A)) 
		return FALSE
	var/datum/sound_template/S = new()
	S.file = soundin
	S.volume = vol
	S.channel = channel
	S.status = status
	S.volume_cat = vol_cat

	for(var/mob/living/M in A.contents)
		if(!M || !M.client || !M.client.soundOutput) 
			continue
		SSsound.queue(M.client, S)

/client/proc/playtitlemusic()
	if(!ticker || !ticker.login_music)	
		return FALSE
	if(prefs && prefs.toggles_sound & SOUND_LOBBY)
		playsound_client(src, ticker.login_music, null, 85, 0, VOLUME_ADM, SOUND_CHANNEL_LOBBY, SOUND_STREAM)


/proc/playsound_z(atom/z, soundin, volume = 100, vol_cat = VOLUME_SFX) // Play sound for all online mobs on a given Z-level. Good for ambient sounds.
	var/datum/sound_template/S = new()
	S.file = soundin
	S.volume = volume
	S.channel = SOUND_CHANNEL_Z
	S.volume_cat = vol_cat
	for(var/mob/M in player_list)
		if (M.z && M.client && M.client.soundOutput)
			SSsound.queue(M.client, S)

// The pick() proc has a built-in chance that can be added to any option by adding ,X; to the end of an option, where X is the % chance it will play.
/proc/get_sfx(S)
	if(istext(S))
		switch(S)
			// General effects
			if("shatter")
				S = pick('sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg')
			if("explosion")
				S = pick('sound/effects/Explosion1.ogg','sound/effects/Explosion2.ogg')
			if("sparks")
				S = pick('sound/effects/sparks1.ogg','sound/effects/sparks2.ogg','sound/effects/sparks3.ogg','sound/effects/sparks4.ogg')
			if("rustle")
				S = pick('sound/effects/rustle1.ogg','sound/effects/rustle2.ogg','sound/effects/rustle3.ogg','sound/effects/rustle4.ogg','sound/effects/rustle5.ogg')
			if("punch")
				S = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
			if("clownstep")
				S = pick('sound/effects/clownstep1.ogg','sound/effects/clownstep2.ogg')
			if("swing_hit")
				S = pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg')
			if("pageturn")
				S = pick('sound/effects/pageturn1.ogg', 'sound/effects/pageturn2.ogg','sound/effects/pageturn3.ogg')
			// Weapons/bullets
			if("ballistic_hit")
				S = pick('sound/bullets/bullet_impact1.ogg','sound/bullets/bullet_impact2.ogg','sound/bullets/bullet_impact1.ogg','sound/bullets/impact_flesh_1.ogg','sound/bullets/impact_flesh_2.ogg','sound/bullets/impact_flesh_3.ogg','sound/bullets/impact_flesh_4.ogg')
			if("ballistic_armor")
				S = pick('sound/bullets/bullet_armor1.ogg','sound/bullets/bullet_armor2.ogg','sound/bullets/bullet_armor3.ogg','sound/bullets/bullet_armor4.ogg')
			if("ballistic_miss")
				S = pick('sound/bullets/bullet_miss1.ogg','sound/bullets/bullet_miss2.ogg','sound/bullets/bullet_miss3.ogg','sound/bullets/bullet_miss3.ogg')
			if("ballistic_bounce")
				S = pick('sound/bullets/bullet_ricochet1.ogg','sound/bullets/bullet_ricochet2.ogg','sound/bullets/bullet_ricochet3.ogg','sound/bullets/bullet_ricochet4.ogg','sound/bullets/bullet_ricochet5.ogg','sound/bullets/bullet_ricochet6.ogg','sound/bullets/bullet_ricochet7.ogg','sound/bullets/bullet_ricochet8.ogg')
			if("rocket_bounce")
				S = pick('sound/bullets/rocket_ricochet1.ogg','sound/bullets/rocket_ricochet2.ogg','sound/bullets/rocket_ricochet3.ogg')
			if("energy_hit")
				S = pick('sound/bullets/energy_impact1.ogg')
			if("energy_miss")
				S = pick('sound/bullets/energy_miss1.ogg')
			if("energy_bounce")
				S = pick('sound/bullets/energy_ricochet1.ogg')
			if("alloy_hit")
				S = pick('sound/bullets/spear_impact1.ogg')
			if("alloy_armor")
				S = pick('sound/bullets/spear_armor1.ogg')
			if("alloy_bounce")
				S = pick('sound/bullets/spear_ricochet1.ogg','sound/bullets/spear_ricochet2.ogg')
			if("gun_silenced")
				S = pick('sound/weapons/gun_silenced_shot1.ogg','sound/weapons/gun_silenced_shot2.ogg')
			if("gun_pulse")
				S = pick('sound/weapons/gun_m41a_1.ogg','sound/weapons/gun_m41a_2.ogg','sound/weapons/gun_m41a_3.ogg','sound/weapons/gun_m41a_4.ogg','sound/weapons/gun_m41a_5.ogg','sound/weapons/gun_m41a_6.ogg')
			if("gun_smartgun")
				S = pick('sound/weapons/gun_smartgun1.ogg', 'sound/weapons/gun_smartgun2.ogg', 'sound/weapons/gun_smartgun3.ogg')
			// Xeno
			if("acid_hit")
				S = pick('sound/bullets/acid_impact1.ogg')
			if("acid_bounce")
				S = pick('sound/bullets/acid_impact1.ogg')
			if("alien_claw_flesh")
				S = pick('sound/weapons/alien_claw_flesh1.ogg','sound/weapons/alien_claw_flesh2.ogg','sound/weapons/alien_claw_flesh3.ogg')
			if("alien_claw_metal")
				S = pick('sound/weapons/alien_claw_metal1.ogg','sound/weapons/alien_claw_metal2.ogg','sound/weapons/alien_claw_metal3.ogg')
			if("alien_bite")
				S = pick('sound/weapons/alien_bite1.ogg','sound/weapons/alien_bite2.ogg')
			if("alien_footstep_large")
				S = pick('sound/effects/alien_footstep_large1.ogg','sound/effects/alien_footstep_large2.ogg','sound/effects/alien_footstep_large3.ogg')
			if("alien_charge")
				S = pick('sound/effects/alien_footstep_charge1.ogg','sound/effects/alien_footstep_charge2.ogg','sound/effects/alien_footstep_charge3.ogg')
			if("alien_resin_build")
				S = pick('sound/effects/alien_resin_build1.ogg','sound/effects/alien_resin_build2.ogg','sound/effects/alien_resin_build3.ogg')
			if("alien_resin_break")
				S = pick('sound/effects/alien_resin_break1.ogg','sound/effects/alien_resin_break2.ogg','sound/effects/alien_resin_break3.ogg')
			if("alien_resin_move")
				S = pick('sound/effects/alien_resin_move1.ogg','sound/effects/alien_resin_move2.ogg')
			if("alien_talk")
				S = pick('sound/voice/alien_talk.ogg','sound/voice/alien_talk2.ogg','sound/voice/alien_talk3.ogg')
			if("alien_growl")
				S = pick('sound/voice/alien_growl1.ogg','sound/voice/alien_growl2.ogg','sound/voice/alien_growl3.ogg')
			if("alien_hiss")
				S = pick('sound/voice/alien_hiss1.ogg','sound/voice/alien_hiss2.ogg','sound/voice/alien_hiss3.ogg')
			if("alien_tail_swipe")
				S = pick('sound/effects/alien_tail_swipe1.ogg','sound/effects/alien_tail_swipe2.ogg','sound/effects/alien_tail_swipe3.ogg')
			if("alien_help")
				S = pick('sound/voice/alien_help1.ogg','sound/voice/alien_help2.ogg')
			if("alien_drool")
				S = pick('sound/voice/alien_drool1.ogg','sound/voice/alien_drool2.ogg')
			if("alien_roar")
				S = pick('sound/voice/alien_roar1.ogg','sound/voice/alien_roar2.ogg','sound/voice/alien_roar3.ogg','sound/voice/alien_roar4.ogg','sound/voice/alien_roar5.ogg','sound/voice/alien_roar6.ogg')
			if("alien_roar_larva")
				S = pick('sound/voice/alien_roar_larva1.ogg','sound/voice/alien_roar_larva2.ogg')
			if("queen")
				S = pick('sound/voice/alien_queen_command.ogg','sound/voice/alien_queen_command2.ogg','sound/voice/alien_queen_command3.ogg')
			// Human
			if("male_scream")
				S = pick('sound/voice/human_male_scream_1.ogg','sound/voice/human_male_scream_2.ogg','sound/voice/human_male_scream_3.ogg','sound/voice/human_male_scream_4.ogg',5;'sound/voice/human_male_scream_5.ogg',5;'sound/voice/human_jackson_scream.ogg',5;'sound/voice/human_ack_scream.ogg')
			if("male_pain")
				S = pick('sound/voice/human_male_pain_1.ogg','sound/voice/human_male_pain_2.ogg','sound/voice/human_male_pain_3.ogg',5;'sound/voice/tomscream.ogg',5;'sound/voice/human_bobby_pain.ogg')
			if("male_fragout")
				S = pick('sound/voice/human_male_grenadethrow_1.ogg', 'sound/voice/human_male_grenadethrow_2.ogg', 'sound/voice/human_male_grenadethrow_3.ogg')
			if("female_scream")
				S = pick('sound/voice/human_female_scream_1.ogg','sound/voice/human_female_scream_2.ogg','sound/voice/human_female_scream_3.ogg','sound/voice/human_female_scream_4.ogg',5;'sound/voice/human_female_scream_5.ogg')
			if("female_pain")
				S = pick('sound/voice/human_female_pain_1.ogg','sound/voice/human_female_pain_2.ogg','sound/voice/human_female_pain_3.ogg')
			if("female_fragout")
				S = pick("sound/voice/human_female_grenadethrow_1.ogg", 'sound/voice/human_female_grenadethrow_2.ogg', 'sound/voice/human_female_grenadethrow_3.ogg')

	return S
