/sound
	echo = SOUND_ECHO_REVERB_OFF //disable environment reverb by default, soundOutput re-enables for spatial sounds

/// Similar to a sound datum, carries info to the sound subsysem and soundOutput.
/datum/sound_template
	//copied sound datum vars; environment, pan, params, priority deliberately omitted
	/// This is the file that will be played when the sound is sent to a player.
	var/file
	/// Set to 1 to repeat the sound indefinitely once it begins playing, 2 to repeat it forwards and backwards.
	var/repeat = 0
	/// Set to TRUE to wait for other sounds in this channel to finish before playing this one.
	var/wait = FALSE
	/// For sound effects, set to 1 through 1024 to choose a specific sound channel. For values of 0 or less, any available channel will be chosen.
	var/channel = 0
	/// Set to a percentage from 0 to 100 of the sound's full volume.
	var/volume = 100
	/// Any value from -100 to 100 will play this sound at a multiple of its normal frequency. A value of 0 or 1 will play the sound at its normal frequency.
	var/frequency = 0
	/// Can be used to set a starting time, in seconds, for a sound.
	var/offset
	/// Can be used to shift the pitch of a sound up or down. This works similarly to frequency except that it doesn't impact playback speed.
	var/pitch = 0
	/// Alter the way the sound is heard by affecting several different on/off values which combine as bit flags: SOUND_MUTE, SOUND_PAUSED, SOUND_STREAM, SOUND_UPDATE
	var/status = NONE
	/// For non-spatial sounds, apparent audio left/right position.
	var/x = 0
	/// For non-spatial sounds, apparent audio down/up position.
	var/y = 0
	/// For non-spatial sounds, apparent audio back/front position.
	var/z = 0
	/// Within the falloff distance a sound stays at a constant volume. Outside of this distance it attenuates at a rate determined by the falloff. Higher values fade more slowly.
	var/falloff = 1
	/// If set to an 18-element list, this value customizes reverbration settings for this sound only. A null or non-numeric value for any setting will select its default.
	var/list/echo = SOUND_ECHO_REVERB_OFF

	//custom vars
	/// Origin atom for the sound. Used for sound position.
	var/atom/source
	/// The category of this sound for client volume purposes: VOLUME_SFX (Sound effects), VOLUME_AMB (Ambience and Soundscapes), and VOLUME_ADM (Admin sounds and some other stuff).
	var/volume_cat = VOLUME_SFX
	/// For spatial sounds, maximum range the sound is played. Defaults to volume * 0.25.
	var/range = 0
	/// Additional control flags for use by SSsound and soundOutput.
	var/sound_flags = NONE
	/// List of all hearers of this template, for use by SSsound.
	var/list/hearers
	/// Indicates that deletion timer and movement signal are set up. Set TRUE when sound has been sent to all hearers.
	var/playing = FALSE

/datum/sound_template/New(soundin)
	if(istype(soundin, /datum/sound_template))
		var/datum/sound_template/source_template = soundin
		src.file = source_template.file
		src.repeat = source_template.repeat
		src.wait = source_template.wait
		src.channel = source_template.channel
		src.volume = source_template.volume
		src.frequency = source_template.frequency
		src.offset = source_template.offset
		src.pitch = source_template.pitch
		src.status = source_template.status
		src.x = source_template.x
		src.y = source_template.y
		src.z = source_template.z
		src.falloff = source_template.falloff
		src.echo = source_template.echo.Copy()

		set_source(source_template.source)
		src.volume_cat = source_template.volume_cat
		src.range = source_template.range
		src.sound_flags = source_template.sound_flags
		src.hearers = source_template.hearers.Copy()
	else if(istype(soundin, /sound))
		var/sound/source_sound = soundin
		src.file = source_sound.file
		src.repeat = source_sound.repeat
		src.wait = source_sound.wait
		src.channel = source_sound.channel
		src.volume = source_sound.volume
		src.frequency = source_sound.frequency
		src.offset = source_sound.offset
		src.pitch = source_sound.pitch
		src.status = source_sound.status
		src.x = source_sound.x
		src.y = source_sound.y
		src.z = source_sound.z
		src.falloff = source_sound.falloff
		if(islist(source_sound.echo))
			var/list/source_sound_echo = source_sound.echo
			src.echo = source_sound_echo.Copy()
		else
			src.echo = source_sound.echo
	else
		src.file = get_sfx(soundin)

	return ..()

/datum/sound_template/Destroy()
	source = null

	SSsound.channel_templates -= "[channel]"
	SSsound.source_updates -= src

	for(var/client/client in hearers)
		client.soundOutput.channel_templates -= "[channel]"
	hearers = null

	return ..()

/datum/sound_template/proc/set_source(atom/new_source)
	if(source)
		UnregisterSignal(source, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED))

	source = new_source

	if(!source)
		return
	RegisterSignal(source, COMSIG_PARENT_QDELETING, PROC_REF(on_source_qdel))

/datum/sound_template/proc/on_playing()
	if(playing)
		return
	playing = TRUE

	QDEL_IN_CLIENT_TIME(src, GLOB.sound_lengths["[file]"] SECONDS)

	if(!((sound_flags & SOUND_TEMPLATE_SPATIAL) && (sound_flags & SOUND_TEMPLATE_TRACKED)))
		return
	if(!ismovable(source))
		return
	RegisterSignal(source, COMSIG_MOVABLE_MOVED, PROC_REF(on_source_moved))

/datum/sound_template/proc/on_source_qdel(/* datum/source, forced */)
	SIGNAL_HANDLER //COMSIG_PARENT_QDELETING
	set_source(get_turf(src.source))

/datum/sound_template/proc/on_source_moved(/* datum/source, atom/oldloc, direction, Forced */)
	SIGNAL_HANDLER //COMSIG_MOVABLE_MOVED
	SSsound.source_updates |= src

/**
 * Creates a sound datum based on the template.
 *
 * Arguments:
 * * update - if truthy the sound datum only has values that will cause no change to the sound, and can be modified from there
 *
 * Returns a sound datum
 */
/datum/sound_template/proc/get_sound(update)
	var/sound/sound = sound(/*repeat = src.repeat,*/ /*wait = src.wait,*/ channel = src.channel, volume = src.volume)
	//sound.pan = src.pan
	//sound.params = src.pan
	//sound.priority = src.priority
	sound.status = src.status
	sound.x = src.x
	sound.y = src.y
	sound.z = src.z
	sound.falloff = src.falloff
	//repeat, wait, pan, params, priority commented out as currently unused

	if(update)
		sound.status |= SOUND_UPDATE
		sound.echo = null
	else //only needed when not updating as their default values indicate no change
		sound.file = src.file
		sound.frequency = src.frequency
		sound.offset = src.offset
		sound.pitch = src.pitch
		//sound.environment = src.environment
		if(sound_flags & SOUND_TEMPLATE_ENVIRONMENTAL)
			sound.echo[ECHO_ROOM] = 0
			sound.echo[ECHO_ROOMHF] = 0
	//environment commented out as currently nonexistent on templates

	return sound

/proc/get_free_channel()
	var/static/cur_chan = 1
	. = cur_chan++
	if(cur_chan > FREE_CHAN_END)
		cur_chan = 1

/**
 * Play a spatialized sound effect to everyone within hearing distance.
 *
 * Arguments:
 * * source - origin atom for the sound
 * * soundin - sound datum ( `sound()` ), sound file ('mysound.ogg'), or string to get a SFX ("male_warcry")
 * * vol - the initial volume of the sound, 0 is no sound at all, 75 is loud queen screech.
 * * vary - the frequency of the sound. Setting it to TRUE will assign it a random frequency
 * * sound_range - maximum theoretical range (in tiles) of the sound, by default is equal to the volume.
 * * vol_cat - the category of this sound for client volume purposes: VOLUME_SFX (Sound effects), VOLUME_AMB (Ambience and Soundscapes), VOLUME_ADM (Admin sounds)
 * * channel - force the sound to play on a specific channel, otherwise one is selected automatically
 * * status - combined bit flags: SOUND_MUTE, SOUND_PAUSED, SOUND_STREAM, SOUND_UPDATE
 * * falloff - range when apparent sound volume starts dropping
 *
 * Returns selected channel on success, FALSE on failure
 */
/proc/playsound(atom/source, sound/soundin, vol = 100, vary, sound_range, vol_cat = VOLUME_SFX, channel, status, falloff = 1, list/echo)
	if(!get_turf(source))
		error("[source] has no turf and is trying to play a spatial sound: [soundin]")
		return FALSE
	if(isarea(source))
		error("[source] is an area and is trying to play a spatial sound: [soundin]")
		return FALSE

	var/datum/sound_template/template = new(soundin)
	if(!isfile(template.file))
		error("[source] is trying to play a spatial sound but provided no sound: [soundin]")
		return FALSE

	template.channel = channel || get_free_channel()
	template.volume = vol
	if(vary > 1)
		template.frequency = vary
	else if(vary)
		template.frequency = GET_RANDOM_FREQ // Same frequency for everybody
	template.status = status
	template.falloff = falloff
	if(islist(echo))
		for(var/pos in 1 to length(echo))
			if(!isnum(echo[pos]))
				continue
			template.echo[pos] = echo[pos]

	template.set_source(source)
	template.volume_cat = vol_cat
	template.range = sound_range || vol * 0.25
	if(GLOB.spatial_sound_tracking && GLOB.sound_lengths["[template.file]"] SECONDS >= GLOB.spatial_sound_tracking_min_length) //debug
		template.sound_flags |= SOUND_TEMPLATE_SPATIAL|SOUND_TEMPLATE_ENVIRONMENTAL|SOUND_TEMPLATE_CAN_DEAFEN|SOUND_TEMPLATE_TRACKED //TODO: limit to sounds that need it

	SSsound.queue(template)
	return template.channel

//This is the replacement for playsound_local. Use this for sending sounds directly to a client
/proc/playsound_client(client/client, sound/soundin, atom/origin, vol = 100, random_freq, vol_cat = VOLUME_SFX, channel, status, list/echo)
	if(!istype(client))
		error("[client] is not a client and is trying to play a client sound: [soundin]")
		return FALSE

	var/datum/sound_template/template = new(soundin)

	template.channel = channel || get_free_channel()
	template.volume = vol
	if(random_freq)
		template.frequency = GET_RANDOM_FREQ
	template.status = status
	if(islist(echo))
		for(var/pos in 1 to length(echo))
			if(!isnum(echo[pos]))
				continue
			template.echo[pos] = echo[pos]

	template.volume_cat = vol_cat

	SSsound.queue(template, list(client))
	return template.channel

/// Plays sound to all mobs that are map-level contents of an area
/proc/playsound_area(area/area, sound/soundin, vol = 100, channel, vol_cat = VOLUME_SFX, status, list/echo)
	if(!isarea(area))
		error("[area] is not an area and is trying to play an area sound: [soundin]")
		return FALSE

	var/datum/sound_template/template = new(soundin)

	template.channel = channel || get_free_channel()
	template.volume = vol
	template.status = status
	if(islist(echo))
		for(var/pos in 1 to length(echo))
			if(!isnum(echo[pos]))
				continue
			template.echo[pos] = echo[pos]

	template.volume_cat = vol_cat

	var/list/hearers = list()
	for(var/mob/living/hearer in area.contents)
		if(!hearer.client)
			continue
		hearers += hearer.client

	SSsound.queue(template, hearers)
	return template.channel

/client/proc/playtitlemusic()
	if(!SSticker?.login_music)
		return FALSE
	if(prefs && prefs.toggles_sound & SOUND_LOBBY)
		playsound_client(src, SSticker.login_music, null, 70, 0, VOLUME_LOBBY, SOUND_CHANNEL_LOBBY, SOUND_STREAM)


/// Play sound for all on-map clients on a list of z-levels. Good for ambient sounds.
/proc/playsound_z(list/z_values, sound/soundin, volume = 100, vol_cat = VOLUME_SFX, list/echo)
	var/datum/sound_template/template = new(soundin)

	template.channel = SOUND_CHANNEL_Z
	template.volume = volume
	if(islist(echo))
		for(var/pos in 1 to length(echo))
			if(!isnum(echo[pos]))
				continue
			template.echo[pos] = echo[pos]

	template.volume_cat = vol_cat

	var/list/hearers = list()
	for(var/client/hearer as anything in GLOB.clients)
		//var/turf/hearer_turf = get_turf(hearer.mob)
		//if(!(hearer_turf.z in z_values))
		if(!((get_turf(hearer.mob)).z in z_values))
			continue
		hearers += hearer

	SSsound.queue(template, hearers)
	return template.channel

// The pick() proc has a built-in chance that can be added to any option by adding ,X; to the end of an option, where X is the % chance it will play.
/proc/get_sfx(sound)
	if(istext(sound))
		switch(sound)
			// General effects
			if("shatter")
				sound = pick('sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg')
			if("windowshatter") //meaty window shattering sound
				sound = pick('sound/effects/window_shatter1.ogg','sound/effects/window_shatter2.ogg','sound/effects/window_shatter3.ogg')
			if("glassbreak") //small breaks for bottles/etc.
				sound = pick('sound/effects/glassbreak1.ogg','sound/effects/glassbreak2.ogg','sound/effects/glassbreak3.ogg','sound/effects/glassbreak4.ogg')
			if("explosion")
				sound = pick('sound/effects/explosion1.ogg','sound/effects/explosion2.ogg','sound/effects/explosion3.ogg','sound/effects/explosion4.ogg','sound/effects/explosion5.ogg')
			if("bigboom")
				sound = pick('sound/effects/bigboom1.ogg','sound/effects/bigboom2.ogg','sound/effects/bigboom3.ogg','sound/effects/bigboom4.ogg')
			if("sparks")
				sound = pick('sound/effects/sparks1.ogg','sound/effects/sparks2.ogg','sound/effects/sparks3.ogg','sound/effects/sparks4.ogg')
			if("rustle")
				sound = pick('sound/effects/rustle1.ogg','sound/effects/rustle2.ogg','sound/effects/rustle3.ogg','sound/effects/rustle4.ogg','sound/effects/rustle5.ogg')
			if("toolbox")
				sound = pick('sound/effects/toolbox.ogg')
			if("pillbottle")
				sound = pick('sound/effects/pillbottle.ogg')
			if("rip")
				sound = pick('sound/effects/rip1.ogg','sound/effects/rip2.ogg')
			if("lighter")
				sound = pick('sound/effects/lighter1.ogg','sound/effects/lighter2.ogg','sound/effects/lighter3.ogg')
			if("zippo_open")
				sound = pick('sound/effects/zippo_open.ogg')
			if("zippo_close")
				sound = pick('sound/effects/zippo_close.ogg')
			if("bonk") //somewhat quiet, increase volume
				sound = pick('sound/machines/bonk.ogg')
			if("cane_step")
				sound = pick('sound/items/cane_step_1.ogg', 'sound/items/cane_step_2.ogg', 'sound/items/cane_step_3.ogg', 'sound/items/cane_step_4.ogg', 'sound/items/cane_step_5.ogg', )
			if("match")
				sound = pick('sound/effects/match.ogg')
			if("throwing")
				sound = pick('sound/effects/throwing/swoosh1.ogg', 'sound/effects/throwing/swoosh2.ogg', 'sound/effects/throwing/swoosh3.ogg', 'sound/effects/throwing/swoosh4.ogg')
			if("punch")
				sound = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
			if("swing_hit")
				sound = pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg')
			if("clan_sword_hit")
				sound = pick('sound/weapons/clan_sword_hit_1.ogg', 'sound/weapons/clan_sword_hit_2.ogg')
			if("slam")
				sound = pick('sound/effects/slam1.ogg','sound/effects/slam2.ogg','sound/effects/slam3.ogg', 0.1;'sound/effects/slam_rare_1.ogg')
			if("pageturn")
				sound = pick('sound/effects/pageturn1.ogg', 'sound/effects/pageturn2.ogg','sound/effects/pageturn3.ogg')
			if("terminal_button")
				sound = pick('sound/machines/terminal_button01.ogg', 'sound/machines/terminal_button02.ogg', 'sound/machines/terminal_button03.ogg','sound/machines/terminal_button04.ogg', 'sound/machines/terminal_button05.ogg', 'sound/machines/terminal_button06.ogg', 'sound/machines/terminal_button07.ogg', 'sound/machines/terminal_button08.ogg')
			if("keyboard")
				sound = pick('sound/machines/keyboard1.ogg', 'sound/machines/keyboard2.ogg','sound/machines/keyboard3.ogg')
			if("keyboard_alt")
				sound = pick('sound/machines/computer_typing4.ogg', 'sound/machines/computer_typing5.ogg', 'sound/machines/computer_typing6.ogg')
			if("gunrustle")
				sound = pick('sound/effects/gunrustle1.ogg', 'sound/effects/gunrustle2.ogg','sound/effects/gunrustle3.ogg')
			if("gunequip")
				sound = pick('sound/handling/gunequip1.ogg','sound/handling/gunequip2.ogg','sound/handling/gunequip3.ogg')
			if("shotgunpump")
				sound = pick('sound/weapons/shotgunpump1.ogg','sound/weapons/shotgunpump2.ogg')
			if("clothingrustle")
				sound = pick('sound/handling/clothingrustle1.ogg', 'sound/handling/clothingrustle2.ogg','sound/handling/clothingrustle3.ogg','sound/handling/clothingrustle4.ogg','sound/handling/clothingrustle5.ogg')
			if("armorequip")
				sound = pick('sound/handling/armorequip_1.ogg','sound/handling/armorequip_2.ogg')
			if("pry")
				sound = pick('sound/effects/pry1.ogg', 'sound/effects/pry2.ogg','sound/effects/pry3.ogg','sound/effects/pry4.ogg')
			if("metalbang")
				sound = pick('sound/effects/thud1.ogg','sound/effects/thud2.ogg','sound/effects/thud3.ogg')
			if("paper_writing")
				sound = pick('sound/items/writing_noises/paper_writing_1.wav', 'sound/items/writing_noises/paper_writing_2.wav', 'sound/items/writing_noises/paper_writing_3.wav', 'sound/items/writing_noises/paper_writing_4.ogg')
			// Weapons/bullets
			if("shell_load")
				sound = pick('sound/weapons/shell_load1.ogg','sound/weapons/shell_load2.ogg','sound/weapons/shell_load3.ogg','sound/weapons/shell_load4.ogg')
			if("ballistic_hit")
				sound = pick('sound/bullets/bullet_impact1.ogg','sound/bullets/bullet_impact2.ogg','sound/bullets/bullet_impact1.ogg','sound/bullets/impact_flesh_1.ogg','sound/bullets/impact_flesh_2.ogg','sound/bullets/impact_flesh_3.ogg','sound/bullets/impact_flesh_4.ogg')
			if("ballistic_armor")
				sound = pick('sound/bullets/bullet_armor1.ogg','sound/bullets/bullet_armor2.ogg','sound/bullets/bullet_armor3.ogg','sound/bullets/bullet_armor4.ogg')
			if("ballistic_miss")
				sound = pick('sound/bullets/bullet_miss1.ogg','sound/bullets/bullet_miss2.ogg','sound/bullets/bullet_miss3.ogg','sound/bullets/bullet_miss4.ogg')
			if("ballistic_bounce")
				sound = pick('sound/bullets/bullet_ricochet1.ogg','sound/bullets/bullet_ricochet2.ogg','sound/bullets/bullet_ricochet3.ogg','sound/bullets/bullet_ricochet4.ogg','sound/bullets/bullet_ricochet5.ogg','sound/bullets/bullet_ricochet6.ogg','sound/bullets/bullet_ricochet7.ogg','sound/bullets/bullet_ricochet8.ogg')
			if("ballistic_shield_hit")
				sound = pick('sound/bullets/shield_impact_c1.ogg','sound/bullets/shield_impact_c2.ogg','sound/bullets/shield_impact_c3.ogg','sound/bullets/shield_impact_c4.ogg')
			if("shield_shatter")
				sound = pick('sound/bullets/shield_break_c1.ogg')
			if("rocket_bounce")
				sound = pick('sound/bullets/rocket_ricochet1.ogg','sound/bullets/rocket_ricochet2.ogg','sound/bullets/rocket_ricochet3.ogg')
			if("energy_hit")
				sound = pick('sound/bullets/energy_impact1.ogg')
			if("energy_miss")
				sound = pick('sound/bullets/energy_miss1.ogg')
			if("energy_bounce")
				sound = pick('sound/bullets/energy_ricochet1.ogg')
			if("alloy_hit")
				sound = pick('sound/bullets/spear_impact1.ogg')
			if("alloy_armor")
				sound = pick('sound/bullets/spear_armor1.ogg')
			if("alloy_bounce")
				sound = pick('sound/bullets/spear_ricochet1.ogg','sound/bullets/spear_ricochet2.ogg')
			if("gun_silenced")
				sound = pick('sound/weapons/gun_silenced_shot1.ogg','sound/weapons/gun_silenced_shot2.ogg')
			if("gun_pulse")
				sound = pick('sound/weapons/gun_m41a_1.ogg','sound/weapons/gun_m41a_2.ogg','sound/weapons/gun_m41a_3.ogg','sound/weapons/gun_m41a_4.ogg','sound/weapons/gun_m41a_5.ogg','sound/weapons/gun_m41a_6.ogg')
			if("gun_smartgun")
				sound = pick('sound/weapons/gun_smartgun1.ogg', 'sound/weapons/gun_smartgun2.ogg', 'sound/weapons/gun_smartgun3.ogg', 'sound/weapons/gun_smartgun4.ogg')
			if("gun_smartgun_rattle")
				sound = pick('sound/weapons/gun_smartgun1_rattle.ogg', 'sound/weapons/gun_smartgun2_rattle.ogg', 'sound/weapons/gun_smartgun3_rattle.ogg', 'sound/weapons/gun_smartgun4_rattle.ogg')
			if("gun_jam_rack")
				sound = pick('sound/weapons/handling/gun_jam_rack_1.ogg', 'sound/weapons/handling/gun_jam_rack_2.ogg', 'sound/weapons/handling/gun_jam_rack_3.ogg')
			//A:CM gun sounds
			if("gun_shotgun_tactical")
				sound = pick('sound/weapons/gun_shotgun_tactical_1.ogg','sound/weapons/gun_shotgun_tactical_2.ogg','sound/weapons/gun_shotgun_tactical_3.ogg','sound/weapons/gun_shotgun_tactical_4.ogg')
			if("m4a3")
				sound = pick('sound/weapons/gun_m4a3_1.ogg','sound/weapons/gun_m4a3_2.ogg','sound/weapons/gun_m4a3_3.ogg','sound/weapons/gun_m4a3_4.ogg','sound/weapons/gun_m4a3_5.ogg')
			if("88m4")
				sound = pick('sound/weapons/gun_88m4_v7.ogg')
			if("gun_casing_shotgun")
				sound = pick ('sound/bullets/bulletcasing_shotgun_fall1.ogg')
			if("gun_nsg23")
				sound = pick('sound/weapons/gun_nsg23_1.ogg','sound/weapons/gun_nsg23_2.ogg')
			if("gun_pkd")
				sound = pick('sound/weapons/gun_pkd_fire01.ogg','sound/weapons/gun_pkd_fire02.ogg','sound/weapons/gun_pkd_fire03.ogg')

			// Xeno
			if("acid_hit")
				sound = pick('sound/bullets/acid_impact1.ogg')
			if("acid_strike")
				sound = pick('sound/weapons/alien_acidstrike1.ogg','sound/weapons/alien_acidstrike2.ogg')
			if("acid_spit")
				sound = pick('sound/voice/alien_spitacid.ogg','sound/voice/alien_spitacid2.ogg')
			if("acid_sizzle")
				sound = pick('sound/effects/acid_sizzle1.ogg','sound/effects/acid_sizzle2.ogg','sound/effects/acid_sizzle3.ogg','sound/effects/acid_sizzle4.ogg')
			if("alien_doorpry")
				sound = pick('sound/effects/alien_doorpry1.ogg','sound/effects/alien_doorpry2.ogg')
			if("acid_bounce")
				sound = pick('sound/bullets/acid_impact1.ogg')
			if("alien_claw_flesh")
				sound = pick('sound/weapons/alien_claw_flesh1.ogg','sound/weapons/alien_claw_flesh2.ogg','sound/weapons/alien_claw_flesh3.ogg','sound/weapons/alien_claw_flesh4.ogg','sound/weapons/alien_claw_flesh5.ogg','sound/weapons/alien_claw_flesh6.ogg')
			if("alien_claw_metal")
				sound = pick('sound/weapons/alien_claw_metal1.ogg','sound/weapons/alien_claw_metal2.ogg','sound/weapons/alien_claw_metal3.ogg')
			if("alien_bite")
				sound = pick('sound/weapons/alien_bite1.ogg','sound/weapons/alien_bite2.ogg')
			if("alien_footstep_large")
				sound = pick('sound/effects/alien_footstep_large1.ogg','sound/effects/alien_footstep_large2.ogg','sound/effects/alien_footstep_large3.ogg')
			if("alien_footstep_medium")
				sound = pick('sound/effects/alien_footstep_medium1.ogg','sound/effects/alien_footstep_medium2.ogg','sound/effects/alien_footstep_medium3.ogg')
			if("alien_charge")
				sound = pick('sound/effects/alien_footstep_charge1.ogg','sound/effects/alien_footstep_charge2.ogg','sound/effects/alien_footstep_charge3.ogg')
			if("alien_resin_build")
				sound = pick('sound/effects/alien_resin_build1.ogg','sound/effects/alien_resin_build2.ogg','sound/effects/alien_resin_build3.ogg')
			if("alien_resin_break")
				sound = pick('sound/effects/alien_resin_break1.ogg','sound/effects/alien_resin_break2.ogg','sound/effects/alien_resin_break3.ogg')
			if("alien_resin_move")
				sound = pick('sound/effects/alien_resin_move1.ogg','sound/effects/alien_resin_move2.ogg')
			if("alien_talk")
				sound = pick('sound/voice/alien_talk.ogg','sound/voice/alien_talk2.ogg','sound/voice/alien_talk3.ogg')
			if("larva_talk")
				sound = pick('sound/voice/larva_talk1.ogg','sound/voice/larva_talk2.ogg','sound/voice/larva_talk3.ogg','sound/voice/larva_talk4.ogg')
			if("hiss_talk")
				sound = pick('sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
			if("alien_growl")
				sound = pick('sound/voice/alien_growl1.ogg','sound/voice/alien_growl2.ogg','sound/voice/alien_growl3.ogg')
			if("alien_hiss")
				sound = pick('sound/voice/alien_hiss1.ogg','sound/voice/alien_hiss2.ogg','sound/voice/alien_hiss3.ogg')
			if("alien_tail_swipe")
				sound = pick('sound/effects/alien_tail_swipe1.ogg','sound/effects/alien_tail_swipe2.ogg','sound/effects/alien_tail_swipe3.ogg')
			if("alien_help")
				sound = pick('sound/voice/alien_help1.ogg','sound/voice/alien_help2.ogg','sound/voice/alien_help3.ogg')
			if("alien_drool")
				sound = pick('sound/voice/alien_drool1.ogg','sound/voice/alien_drool2.ogg')
			if("alien_roar")
				sound = pick('sound/voice/alien_roar1.ogg','sound/voice/alien_roar2.ogg','sound/voice/alien_roar3.ogg','sound/voice/alien_roar4.ogg','sound/voice/alien_roar5.ogg','sound/voice/alien_roar6.ogg')
			if("alien_roar_larva")
				sound = pick('sound/voice/alien_roar_larva1.ogg','sound/voice/alien_roar_larva2.ogg')
			if("queen")
				sound = pick('sound/voice/alien_queen_command.ogg','sound/voice/alien_queen_command2.ogg','sound/voice/alien_queen_command3.ogg')
			// Human
			if("male_scream")
				sound = pick('sound/voice/human_male_scream_1.ogg','sound/voice/human_male_scream_2.ogg','sound/voice/human_male_scream_3.ogg','sound/voice/human_male_scream_4.ogg',5;'sound/voice/human_male_scream_5.ogg',5;'sound/voice/human_jackson_scream.ogg',5;'sound/voice/human_ack_scream.ogg','sound/voice/human_male_scream_6.ogg')
			if("male_pain")
				sound = pick('sound/voice/human_male_pain_1.ogg','sound/voice/human_male_pain_2.ogg','sound/voice/human_male_pain_3.ogg',5;'sound/voice/tomscream.ogg',5;'sound/voice/human_bobby_pain.ogg',5;'sound/voice/human_tantrum_scream.ogg', 5;'sound/voice/human_male_pain_rare_1.ogg')
			if("male_fragout")
				sound = pick('sound/voice/human_male_grenadethrow_1.ogg', 'sound/voice/human_male_grenadethrow_2.ogg', 'sound/voice/human_male_grenadethrow_3.ogg')
			if("male_warcry")
				sound = pick('sound/voice/warcry/male_go.ogg', 'sound/voice/warcry/male_attack.ogg', 'sound/voice/warcry/male_charge.ogg', 'sound/voice/warcry/male_charge2.ogg', 'sound/voice/warcry/warcry_male_1.ogg', 'sound/voice/warcry/warcry_male_2.ogg', 'sound/voice/warcry/warcry_male_3.ogg', 'sound/voice/warcry/warcry_male_4.ogg', 'sound/voice/warcry/warcry_male_5.ogg', 'sound/voice/warcry/warcry_male_6.ogg', 'sound/voice/warcry/warcry_male_7.ogg', 'sound/voice/warcry/warcry_male_8.ogg', 'sound/voice/warcry/warcry_male_9.ogg', 'sound/voice/warcry/warcry_male_10.ogg', 'sound/voice/warcry/warcry_male_11.ogg', 'sound/voice/warcry/warcry_male_12.ogg', 'sound/voice/warcry/warcry_male_13.ogg', 'sound/voice/warcry/warcry_male_14.ogg', 'sound/voice/warcry/warcry_male_15.ogg', 'sound/voice/warcry/warcry_male_16.ogg', 'sound/voice/warcry/warcry_male_17.ogg', 'sound/voice/warcry/warcry_male_18.ogg', 'sound/voice/warcry/warcry_male_19.ogg', 'sound/voice/warcry/warcry_male_20.ogg', 'sound/voice/warcry/warcry_male_21.ogg', 'sound/voice/warcry/warcry_male_22.ogg', 'sound/voice/warcry/warcry_male_23.ogg', 'sound/voice/warcry/warcry_male_24.ogg', 'sound/voice/warcry/warcry_male_25.ogg', 'sound/voice/warcry/warcry_male_26.ogg', 'sound/voice/warcry/warcry_male_27.ogg', 'sound/voice/warcry/warcry_male_28.ogg', 'sound/voice/warcry/warcry_male_29.ogg', 'sound/voice/warcry/warcry_male_30.ogg', 'sound/voice/warcry/warcry_male_31.ogg', 'sound/voice/warcry/warcry_male_32.ogg', 'sound/voice/warcry/warcry_male_33.ogg', 'sound/voice/warcry/warcry_male_34.ogg', 'sound/voice/warcry/warcry_male_35.ogg', 5;'sound/voice/warcry/warcry_male_rare_1.ogg', 5;'sound/voice/warcry/warcry_male_rare_2.ogg', 5;'sound/voice/warcry/warcry_male_rare_3.ogg', 5;'sound/voice/warcry/warcry_male_rare_4.ogg', 5;'sound/voice/warcry/warcry_male_rare_5.ogg')
			if("male_upp_warcry")
				sound = pick('sound/voice/upp_warcry/warcry_male_1.ogg', 'sound/voice/upp_warcry/warcry_male_2.ogg')
			if("female_scream")
				sound = pick('sound/voice/human_female_scream_1.ogg','sound/voice/human_female_scream_2.ogg','sound/voice/human_female_scream_3.ogg','sound/voice/human_female_scream_4.ogg',5;'sound/voice/human_female_scream_5.ogg')
			if("female_pain")
				sound = pick('sound/voice/human_female_pain_1.ogg','sound/voice/human_female_pain_2.ogg','sound/voice/human_female_pain_3.ogg')
			if("female_fragout")
				sound = pick("sound/voice/human_female_grenadethrow_1.ogg", 'sound/voice/human_female_grenadethrow_2.ogg', 'sound/voice/human_female_grenadethrow_3.ogg')
			if("female_warcry")
				sound = pick('sound/voice/warcry/female_charge.ogg', 'sound/voice/warcry/female_yell1.ogg', 'sound/voice/warcry/warcry_female_1.ogg', 'sound/voice/warcry/warcry_female_2.ogg', 'sound/voice/warcry/warcry_female_3.ogg', 'sound/voice/warcry/warcry_female_4.ogg', 'sound/voice/warcry/warcry_female_5.ogg', 'sound/voice/warcry/warcry_female_6.ogg', 'sound/voice/warcry/warcry_female_7.ogg', 'sound/voice/warcry/warcry_female_8.ogg', 'sound/voice/warcry/warcry_female_9.ogg', 'sound/voice/warcry/warcry_female_10.ogg', 'sound/voice/warcry/warcry_female_11.ogg', 'sound/voice/warcry/warcry_female_12.ogg', 'sound/voice/warcry/warcry_female_13.ogg', 'sound/voice/warcry/warcry_female_14.ogg', 'sound/voice/warcry/warcry_female_15.ogg', 'sound/voice/warcry/warcry_female_16.ogg', 'sound/voice/warcry/warcry_female_17.ogg', 'sound/voice/warcry/warcry_female_18.ogg', 'sound/voice/warcry/warcry_female_19.ogg', 'sound/voice/warcry/warcry_female_20.ogg')
			if("female_upp_warcry")
				sound = pick('sound/voice/upp_warcry/warcry_female_1.ogg', 'sound/voice/upp_warcry/warcry_female_2.ogg')
			if("rtb_handset")
				sound = pick('sound/machines/telephone/rtb_handset_1.ogg', 'sound/machines/telephone/rtb_handset_2.ogg', 'sound/machines/telephone/rtb_handset_3.ogg', 'sound/machines/telephone/rtb_handset_4.ogg', 'sound/machines/telephone/rtb_handset_5.ogg')
			if("talk_phone")
				sound = pick('sound/machines/telephone/talk_phone1.ogg', 'sound/machines/telephone/talk_phone2.ogg', 'sound/machines/telephone/talk_phone3.ogg', 'sound/machines/telephone/talk_phone4.ogg', 'sound/machines/telephone/talk_phone5.ogg', 'sound/machines/telephone/talk_phone6.ogg', 'sound/machines/telephone/talk_phone7.ogg')
			if("bone_break")
				sound = pick('sound/effects/bone_break1.ogg','sound/effects/bone_break2.ogg','sound/effects/bone_break3.ogg','sound/effects/bone_break4.ogg','sound/effects/bone_break5.ogg','sound/effects/bone_break6.ogg','sound/effects/bone_break7.ogg')
			if("plush")
				sound = pick('sound/items/plush1.ogg', 'sound/items/plush2.ogg', 'sound/items/plush3.ogg')
			//misc mobs
			if("cat_meow")
				sound = pick('sound/voice/cat_meow_1.ogg','sound/voice/cat_meow_2.ogg','sound/voice/cat_meow_3.ogg','sound/voice/cat_meow_4.ogg','sound/voice/cat_meow_5.ogg','sound/voice/cat_meow_6.ogg','sound/voice/cat_meow_7.ogg')
			if("pred_pain")
				sound = pick('sound/voice/pred_pain1.ogg','sound/voice/pred_pain2.ogg','sound/voice/pred_pain3.ogg','sound/voice/pred_pain4.ogg','sound/voice/pred_pain5.ogg',5;'sound/voice/pred_pain_rare1.ogg')
			if("clownstep")
				sound = pick('sound/effects/clownstep1.ogg', 'sound/effects/clownstep2.ogg')
			if("giant_lizard_growl")
				sound = pick('sound/effects/giant_lizard_growl1.ogg', 'sound/effects/giant_lizard_growl2.ogg')
			if("giant_lizard_hiss")
				sound = pick('sound/effects/giant_lizard_hiss1.ogg', 'sound/effects/giant_lizard_hiss2.ogg')
	return sound

/client/proc/generate_sound_queues()
	set category = "Debug.Sound"
	set name = "Queue Sounds"
	set desc = "generate many warcries for stress testing"

	var/amount = tgui_input_number(src, "How many sounds to queue?", default = 1, max_value = 2000, min_value = 1)
	if(!amount)
		return
	var/range = tgui_input_number(src, "Range", default = 1, min_value = 0)
	if(isnull(range))
		return
	var/x = tgui_input_number(src, "Center X", default = 1, max_value = world.maxx, min_value = 1)
	if(!x)
		return
	var/y = tgui_input_number(src, "Center Y", default = 1, max_value = world.maxy, min_value = 1)
	if(!y)
		return
	var/z = tgui_input_number(src, "Z level", default = 1, max_value = world.maxz, min_value = 1)
	if(!z)
		return

	var/turf/source_turf = locate(x, y, z)

	for(var/i in 1 to amount)
		var/datum/sound_template/template = new("male_warcry") // warcry has variable length, lots of variations
		template.channel = get_free_channel() // i'm convinced this is bad, but it's here to mirror playsound() behaviour
		template.set_source(source_turf)
		template.range = range
		template.sound_flags |= SOUND_TEMPLATE_SPATIAL|SOUND_TEMPLATE_ENVIRONMENTAL|SOUND_TEMPLATE_CAN_DEAFEN|SOUND_TEMPLATE_TRACKED
		SSsound.queue(template)

/client/proc/sound_debug_query()
	set category = "Debug.Sound"
	set name = "Dump Playing Client Sounds"
	set desc = "dumps info about locally, playing sounds"

	for(var/sound/playing_sound in SoundQuery())
		to_chat(src, "channel#[playing_sound.channel]: [playing_sound.status] - [playing_sound.file] - len=[playing_sound.len], wait=[playing_sound.wait], offset=[playing_sound.offset], repeat=[playing_sound.repeat]")

GLOBAL_VAR_INIT(spatial_sound_tracking, TRUE)
/client/proc/toggle_spatial_sound_tracking()
	set category = "Debug.Sound"
	set name = "Toggle Spatial Sound Tracking"
	set desc = "globally stop new sounds from being tracked"

	if(!check_rights(R_DEBUG|R_ADMIN))
		return

	GLOB.spatial_sound_tracking = !GLOB.spatial_sound_tracking
	message_admins("[src] has globally [GLOB.spatial_sound_tracking ? "enabled" : "disabled"] spatial sound tracking. New sounds [GLOB.spatial_sound_tracking ? "can now" : "will no longer"] be tracked.")

GLOBAL_VAR_INIT(spatial_sound_tracking_min_length, 0 SECONDS) //in deciseconds
/client/proc/set_spatial_sound_tracking_min_length()
	set category = "Debug.Sound"
	set name = "Set Min Tracking Limit"
	set desc = "limit tracked sounds to longer ones"

	if(!check_rights(R_DEBUG|R_ADMIN))
		return

	var/min_length = tgui_input_number(src, "Shortest sound to track in seconds:", "Seconds", default = GLOB.spatial_sound_tracking_min_length, max_value = 10, min_value = 0, integer_only = FALSE)
	if(isnull(min_length))
		return

	GLOB.spatial_sound_tracking_min_length = min_length SECONDS
	message_admins("[src] has set the spatial sound tracking minimum length to [GLOB.spatial_sound_tracking_min_length * 0.1] seconds.")
