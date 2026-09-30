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
	var/list/echo
	var/atom/atom //! Tracked atom so we get the exact position even after delay in SSsound firing - replaces x/y/z if applicable
	var/x //Map coordinates, not sound coordinates
	var/y
	var/z
	/// Horizontal sound offset, added to the dynamic offsets calculated using map coordinates above.
	var/x_s_offset
	/// Vertical (as in on screen) sound offset, added to the dynamic offsets calculated using map coordinates above. Get it right: Y in sound is up from the ground. Y in game is up on the screen. Game North is Sound Z axis.
	var/z_s_offset

/datum/sound_template/proc/get_hearers()
	RETURN_TYPE(/list/client)
	. = list()
	var/list/atom/movable/all_contents = SSmapgrids.get_movables_in_region(z, x - range, x + range, y - range, y + range)
	for(var/mob/mob in all_contents)
		if(mob.client)
			. += mob.client

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

/proc/playsound(atom/source, sound/soundin, vol = 100, vary = FALSE, sound_range, vol_cat = VOLUME_SFX, channel = 0, status, falloff = 1, list/echo, z_s_offset, x_s_offset)
	if(isarea(source))
		error("[source] is an area and is trying to make the sound: [soundin]")
		return FALSE

	var/can_play_rare = prob(1) //only way i can think of to do this and it sucks

	var/datum/sound_template/template = new()
	if(istype(soundin))
		template.file = soundin.file
		template.wait = soundin.wait
		template.repeat = soundin.repeat
	else
		template.file = pick(soundin)
	template.channel = channel ? channel : get_free_channel()
	template.status = status
	template.falloff = falloff
	template.volume = vol
	template.volume_cat = vol_cat

	while(islist(template.file))
		if(can_play_rare)
			template.file = pick(template.file)
			break
		else
			template.file = pick(soundin)

	if(echo)
		template.echo = echo.Copy()
	template.z_s_offset = z_s_offset
	template.x_s_offset = x_s_offset
	if(vary != FALSE)
		if(vary > 1)
			template.frequency = vary
		else
			template.frequency = GET_RANDOM_FREQ // Same frequency for everybody

	if(!sound_range)
		sound_range = floor(0.25*vol) //if no specific range, the max range is equal to a quarter of the volume.
	template.range = sound_range

	if(ismovable(source))
		template.atom = source

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
				template.atom = vehicle_interior.exterior
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
/proc/playsound_client(client/client, sound/soundin, atom/origin, vol = 100, random_freq, vol_cat = VOLUME_SFX, channel = 0, status, list/echo, z_s_offset, x_s_offset)
	if(!istype(client) || !client.soundOutput)
		return FALSE

	var/can_play_rare = prob(1)

	var/datum/sound_template/template = new()
	if(origin)
		if(isatom(origin))
			template.atom = origin
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
		template.file = pick(soundin)

	while(islist(template.file))
		if(can_play_rare)
			template.file = pick(template.file)
			break
		else
			template.file = pick(soundin)

	if(random_freq)
		if(random_freq == "minor")
			template.frequency = GET_RANDOM_FREQ_MINOR
		else
			template.frequency = GET_RANDOM_FREQ
	template.volume = vol
	template.volume_cat = vol_cat
	template.channel = channel
	template.status = status
	if(echo)
		template.echo = echo.Copy()
	template.z_s_offset = z_s_offset
	template.x_s_offset = x_s_offset
	SSsound.queue(template, list(client))

/// Plays sound to all mobs that are map-level contents of an area
/proc/playsound_area(area/A, soundin, vol = 100, channel = 0, status, vol_cat = VOLUME_SFX, list/echo, z_s_offset, x_s_offset)
	if(!isarea(A))
		return FALSE

	var/can_play_rare = prob(1)

	var/datum/sound_template/template = new()
	template.file = pick(soundin)

	template.volume = vol
	template.channel = channel
	template.status = status
	template.volume_cat = vol_cat

	while(islist(template.file))
		if(can_play_rare)
			template.file = pick(template.file)
			break
		else
			template.file = pick(soundin)

	if(echo)
		template.echo = echo.Copy()



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
/proc/playsound_z(z, soundin, volume = 100, vol_cat = VOLUME_SFX, list/echo, z_s_offset, x_s_offset)
	var/datum/sound_template/template = new()
	template.file = pick(soundin)
	template.volume = volume
	template.channel = SOUND_CHANNEL_Z
	template.volume_cat = vol_cat

	var/can_play_rare = prob(1)

	while(islist(template.file))
		if(can_play_rare)
			template.file = pick(template.file)
			break
		else
			template.file = pick(soundin)

	if(echo)
		template.echo = echo.Copy()
	template.z_s_offset = z_s_offset
	template.x_s_offset = x_s_offset
	var/list/hearers = list()
	for(var/mob/M in GLOB.player_list)
		if((M.z in z) && M.client.soundOutput)
			hearers += M.client
	SSsound.queue(template, hearers)

/client/proc/generate_sound_queues()
	set name = "Queue sounds"
	set desc = "Stress test this bich."
	set category = "Debug"

	var/ammount = tgui_input_number(usr, "How many sounds to queue?")
	var/range = tgui_input_number(usr, "Range")
	var/x = tgui_input_number(usr, "Center X")
	var/y = tgui_input_number(usr, "Center Y")
	var/z = tgui_input_number(usr, "Z level")
	var/datum/sound_template/template
	for(var/i = 1, i <= ammount, i++)
		template = new
		template.file = pick(SOUND_MALE_WARCRY) // warcry has variable length, lots of variations
		template.channel = get_free_channel() // i'm convinced this is bad, but it's here to mirror playsound() behaviour
		template.range = range
		template.x = x
		template.y = y
		template.z = z
		SSsound.queue(template)

		var/can_play_rare = prob(1)

		while(islist(template.file))
			if(can_play_rare)
				template.file = pick(template.file)
				break
			else
				template.file = pick(SOUND_MALE_WARCRY)

/client/proc/sound_debug_query()
	set name = "Dump Playing Client Sounds"
	set desc = "Dumps info about locally, playing sounds."
	set category = "Debug"

	for(var/sound/soundin in SoundQuery())
		to_chat(src, "channel#[soundin.channel]: [soundin.status] - [soundin.file] - len=[length(soundin)], wait=[soundin.wait], offset=[soundin.offset], repeat=[soundin.repeat]")
