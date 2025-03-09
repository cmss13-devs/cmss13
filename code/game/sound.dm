/sound
	echo = SOUND_ECHO_REVERB_OFF //disable enviroment reverb by default, soundOutput re-enables for positional sounds

/datum/sound_template //Basically a sound datum, but only serves as a way to carry info to soundOutput
	var/file //The sound itself
	var/file_muffled // Muffled variant for those that are deaf
	var/wait = 0
	var/repeat = 0
	var/channel = 0
	var/volume = 100
	var/status = 0 //Sound status flags
	var/frequency = 1
	var/falloff = 1
	var/volume_cat = VOLUME_SFX
	var/range = 0
	var/list/echo = new /list(18)
	var/x //Map coordinates, not sound coordinates
	var/y
	var/z
	var/y_s_offset // Vertical sound offset
	var/x_s_offset // Horizontal sound offset

/datum/sound_template/proc/get_hearers()
	var/list/hearers_to_return = list()
	var/datum/shape/rectangle/zone = SQUARE(x, y, range * 2)
	hearers_to_return += SSquadtree.players_in_range(zone, z)
	
	var/turf/above = SSmapping.get_turf_above(locate(x, y, z))
	while(above)
		hearers_to_return += SSquadtree.players_in_range(zone, above.z)
		above = SSmapping.get_turf_above(above)

	var/turf/below = SSmapping.get_turf_below(locate(x, y, z))
	while(below)
		hearers_to_return += SSquadtree.players_in_range(zone, below.z)
		below = SSmapping.get_turf_below(below)
	return hearers_to_return

/proc/get_free_channel()
	var/static/cur_chan = 1
	. = cur_chan++
	if(cur_chan > FREE_CHAN_END)
		cur_chan = 1

//Proc used to play a sound effect. Avoid using this proc for non-IC sounds, as there are others
//source: self-explanatory.
//soundin: the .ogg to use.
//vol: the initial volume of the sound, 0 is no sound at all, 75 is loud queen screech.
//freq: the frequency of the sound. Setting it to 1 will assign it a random frequency
//sound_range: the maximum theoretical range (in tiles) of the sound, by default is equal to the volume.
//vol_cat: the category of this sound, used in client volume. There are 3 volume categories: VOLUME_SFX (Sound effects), VOLUME_AMB (Ambience and Soundscapes) and VOLUME_ADM (Admin sounds and some other stuff)
//channel: use this only when you want to force the sound to play on a specific channel
//status: the regular 4 sound flags
//falloff: max range till sound volume starts dropping as distance increases

/proc/playsound(atom/source, sound/soundin, vol = 100, vary = FALSE, sound_range, vol_cat = VOLUME_SFX, channel = 0, status, falloff = 1, list/echo, y_s_offset, x_s_offset)
	if(isarea(source))
		error("[source] is an area and is trying to make the sound: [soundin]")
		return FALSE

	var/datum/sound_template/template = new()
	if(istype(soundin))
		template.file = soundin.file
		template.wait = soundin.wait
		template.repeat = soundin.repeat
	else
		template.file = get_sfx(soundin)
	template.channel = channel ? channel : get_free_channel()
	template.status = status
	template.falloff = falloff
	template.volume = vol
	template.volume_cat = vol_cat
	for(var/pos = 1 to length(echo))
		if(!echo[pos])
			continue
		template.echo[pos] = echo[pos]
	template.y_s_offset = y_s_offset
	template.x_s_offset = x_s_offset
	if(vary != FALSE)
		if(vary > 1)
			template.frequency = vary
		else
			template.frequency = GET_RANDOM_FREQ // Same frequency for everybody

	if(!sound_range)
		sound_range = floor(0.25*vol) //if no specific range, the max range is equal to a quarter of the volume.
	template.range = sound_range

	var/turf/turf_source = get_turf(source)
	if(!turf_source || !turf_source.z)
		return FALSE
	template.x = turf_source.x
	template.y = turf_source.y
	template.z = turf_source.z

	if(!SSinterior)
		SSsound.queue(template)
		return template.channel

	var/list/datum/interior/extra_interiors = list()
	// If we're in an interior, range the chunk, then adjust to do so from outside instead
	if(SSinterior.in_interior(turf_source))
		var/datum/interior/vehicle_interior = SSinterior.get_interior_by_coords(turf_source.x, turf_source.y, turf_source.z)
		if(vehicle_interior?.ready)
			extra_interiors |= vehicle_interior
			if(vehicle_interior.exterior)
				var/turf/new_turf_source = get_turf(vehicle_interior.exterior)
				template.x = new_turf_source.x
				template.y = new_turf_source.y
				template.z = new_turf_source.z
			else
				sound_range = 0
	// Range for 'nearby interiors' aswell
	for(var/datum/interior/vehicle_interior in SSinterior.interiors)
		if(vehicle_interior?.ready && vehicle_interior.exterior?.z == turf_source.z && get_dist(vehicle_interior.exterior, turf_source) <= sound_range)
			extra_interiors |= vehicle_interior

	SSsound.queue(template, null, extra_interiors)
	return template.channel



//This is the replacement for playsound_local. Use this for sending sounds directly to a client
/proc/playsound_client(client/client, sound/soundin, atom/origin, vol = 100, random_freq, vol_cat = VOLUME_SFX, channel = 0, status, list/echo, y_s_offset, x_s_offset)
	if(!istype(client) || !client.soundOutput)
		return FALSE

	var/datum/sound_template/template = new()
	if(origin)
		var/turf/T = get_turf(origin)
		if(T)
			template.x = T.x
			template.y = T.y
			template.z = T.z
	if(istype(soundin))
		template.file = soundin.file
		template.wait = soundin.wait
		template.repeat = soundin.repeat
	else
		template.file = get_sfx(soundin)

	if(random_freq)
		if(random_freq == "minor")
			template.frequency = GET_RANDOM_FREQ_MINOR
		else
			template.frequency = GET_RANDOM_FREQ
	template.volume = vol
	template.volume_cat = vol_cat
	template.channel = channel
	template.status = status
	for(var/pos = 1 to length(echo))
		if(!echo[pos])
			continue
		template.echo[pos] = echo[pos]
	template.y_s_offset = y_s_offset
	template.x_s_offset = x_s_offset
	SSsound.queue(template, list(client))

/// Plays sound to all mobs that are map-level contents of an area
/proc/playsound_area(area/A, soundin, vol = 100, channel = 0, status, vol_cat = VOLUME_SFX, list/echo, y_s_offset, x_s_offset)
	if(!isarea(A))
		return FALSE

	var/datum/sound_template/template = new()
	template.file = soundin
	template.volume = vol
	template.channel = channel
	template.status = status
	template.volume_cat = vol_cat
	for(var/pos = 1 to length(echo))
		if(!echo[pos])
			continue
		template.echo[pos] = echo[pos]

	var/list/hearers = list()
	for(var/mob/living/M in A.contents)
		if(!M || !M.client || !M.client.soundOutput)
			continue
		hearers += M.client
	SSsound.queue(template, hearers)

/client/proc/playtitlemusic()
	if(!SSticker?.login_music)
		return FALSE
	if(prefs && prefs.toggles_sound & SOUND_LOBBY)
		playsound_client(src, SSticker.login_music, null, 70, 0, VOLUME_LOBBY, SOUND_CHANNEL_LOBBY, SOUND_STREAM)


/// Play sound for all on-map clients on a given Z-level. Good for ambient sounds.
/proc/playsound_z(z, soundin, volume = 100, vol_cat = VOLUME_SFX, echo, y_s_offset, x_s_offset)
	var/datum/sound_template/template = new()
	template.file = soundin
	template.volume = volume
	template.channel = SOUND_CHANNEL_Z
	template.volume_cat = vol_cat
	for(var/pos = 1 to length(echo))
		if(!echo[pos])
			continue
		template.echo[pos] = echo[pos]
	template.y_s_offset = y_s_offset
	template.x_s_offset = x_s_offset
	var/list/hearers = list()
	for(var/mob/M in GLOB.player_list)
		if((M.z in z) && M.client.soundOutput)
			hearers += M.client
	SSsound.queue(template, hearers)

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
			if("male_preburst")
				sound = pick('sound/voice/human_male_preburst1.ogg', 'sound/voice/human_male_preburst2.ogg', 'sound/voice/human_male_preburst3.ogg', 'sound/voice/human_male_preburst4.ogg', 'sound/voice/human_male_preburst5.ogg', 'sound/voice/human_male_preburst6.ogg', 'sound/voice/human_male_preburst7.ogg', 'sound/voice/human_male_preburst8.ogg', 'sound/voice/human_male_preburst9.ogg')
			if("male_hugged")
				sound = pick("sound/voice/human_male_facehugged1.ogg", 'sound/voice/human_male_facehugged2.ogg', 'sound/voice/human_male_facehugged3.ogg')
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
			if("female_preburst")
				sound = pick('sound/voice/human_female_preburst1.ogg', 'sound/voice/human_female_preburst2.ogg', 'sound/voice/human_female_preburst3.ogg', 'sound/voice/human_female_preburst4.ogg', 'sound/voice/human_female_preburst5.ogg',  'sound/voice/human_female_preburst6.ogg',  'sound/voice/human_female_preburst7.ogg')
			if("female_hugged")
				sound = pick("sound/voice/human_female_facehugged1.ogg", 'sound/voice/human_female_facehugged2.ogg')
			if("rtb_handset")
				sound = pick('sound/machines/telephone/rtb_handset_1.ogg', 'sound/machines/telephone/rtb_handset_2.ogg', 'sound/machines/telephone/rtb_handset_3.ogg', 'sound/machines/telephone/rtb_handset_4.ogg', 'sound/machines/telephone/rtb_handset_5.ogg')
			if("talk_phone")
				sound = pick('sound/machines/telephone/talk_phone1.ogg', 'sound/machines/telephone/talk_phone2.ogg', 'sound/machines/telephone/talk_phone3.ogg', 'sound/machines/telephone/talk_phone4.ogg', 'sound/machines/telephone/talk_phone5.ogg', 'sound/machines/telephone/talk_phone6.ogg', 'sound/machines/telephone/talk_phone7.ogg')
			if("bone_break")
				sound = pick('sound/effects/bone_break1.ogg','sound/effects/bone_break2.ogg','sound/effects/bone_break3.ogg','sound/effects/bone_break4.ogg','sound/effects/bone_break5.ogg','sound/effects/bone_break6.ogg','sound/effects/bone_break7.ogg')
			if("plush")
				sound = pick('sound/items/plush1.ogg', 'sound/items/plush2.ogg', 'sound/items/plush3.ogg')
			// working joe
			if("wj_death")
				sound = pick('sound/voice/joe/death_normal.ogg', 'sound/voice/joe/death_silence.ogg',10;'sound/voice/joe/death_tomorrow.ogg',5;'sound/voice/joe/death_dream.ogg')
			if("hj_death")
				sound = pick('sound/voice/joe/death_hj_normal.ogg', 'sound/voice/joe/death_hj_silence.ogg',10;'sound/voice/joe/death_hj_tomorrow.ogg')
			if("upp_wj_death")
				sound = pick('sound/voice/joe/upp_joe/smert1.ogg', 'sound/voice/joe/upp_joe/smert2.ogg', 'sound/voice/joe/upp_joe/smert3.ogg', 'sound/voice/joe/upp_joe/smert4.ogg', 'sound/voice/joe/upp_joe/smert5.ogg')
			//misc mobs
			if("cat_meow")
				sound = pick('sound/voice/cat_meow_1.ogg','sound/voice/cat_meow_2.ogg','sound/voice/cat_meow_3.ogg','sound/voice/cat_meow_4.ogg','sound/voice/cat_meow_5.ogg','sound/voice/cat_meow_6.ogg','sound/voice/cat_meow_7.ogg')
			if("pred_pain")
				sound = pick('sound/voice/pred_pain1.ogg','sound/voice/pred_pain2.ogg','sound/voice/pred_pain3.ogg','sound/voice/pred_pain4.ogg','sound/voice/pred_pain5.ogg',5;'sound/voice/pred_pain_rare1.ogg')
			if("pred_preburst")
				sound = pick('sound/voice/pred_pain_rare1.ogg')
			if("pred_death")
				sound = pick('sound/voice/pred_death1.ogg', 'sound/voice/pred_death2.ogg')
			if("pred_laugh4")
				sound = pick('sound/voice/pred_laugh4.ogg', 'sound/voice/pred_laugh5.ogg')
			if("clownstep")
				sound = pick('sound/effects/clownstep1.ogg', 'sound/effects/clownstep2.ogg')
			if("giant_lizard_growl")
				sound = pick('sound/effects/giant_lizard_growl1.ogg', 'sound/effects/giant_lizard_growl2.ogg')
			if("giant_lizard_hiss")
				sound = pick('sound/effects/giant_lizard_hiss1.ogg', 'sound/effects/giant_lizard_hiss2.ogg')
			if("evo_screech")
				sound = pick('sound/voice/alien_echoroar_1.ogg', 'sound/voice/alien_echoroar_2.ogg', 'sound/voice/alien_echoroar_3.ogg')
	return sound

/client/proc/generate_sound_queues()
	set name = "Queue sounds"
	set desc = "stress test this bich"
	set category = "Debug"

	var/ammount = tgui_input_number(usr, "How many sounds to queue?")
	var/range = tgui_input_number(usr, "Range")
	var/x = tgui_input_number(usr, "Center X")
	var/y = tgui_input_number(usr, "Center Y")
	var/z = tgui_input_number(usr, "Z level")
	var/datum/sound_template/template
	for(var/i = 1, i <= ammount, i++)
		template = new
		template.file = get_sfx("male_warcry") // warcry has variable length, lots of variations
		template.channel = get_free_channel() // i'm convinced this is bad, but it's here to mirror playsound() behaviour
		template.range = range
		template.x = x
		template.y = y
		template.z = z
		SSsound.queue(template)

/client/proc/sound_debug_query()
	set name = "Dump Playing Client Sounds"
	set desc = "dumps info about locally, playing sounds"
	set category = "Debug"

	for(var/sound/soundin in SoundQuery())
		UNLINT(to_chat(src, "channel#[soundin.channel]: [soundin.status] - [soundin.file] - len=[length(soundin)], wait=[soundin.wait], offset=[soundin.offset], repeat=[soundin.repeat]")) // unlint until spacemandmm suite-1.7
