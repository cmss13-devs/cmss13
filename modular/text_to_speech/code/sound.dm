///Percentage of sound's range where no falloff is applied
#define SOUND_DEFAULT_FALLOFF_DISTANCE 1 //For a normal sound this would be 1 tile of no falloff
///The default exponent of sound falloff
#define SOUND_FALLOFF_EXPONENT 6

/datum/preferences/New(TopicData)
	// Пример работы: S.volume = 100 * owner.volume_preferences[VOLUME_AMB]
	volume_preferences |= (list(
		1, // Local - VOLUME_TTS_LOCAL (5) - у ОФФов это тупо сделано, но как есть...
		0.5 // Radio - VOLUME_TTS_RADIO (6)
	))

	// А еще они зачем-то засунули это сюда (дубликат и брейнрот):
	// 	code/modules/client/preferences_savefile.dm

	. = ..()

/client/verb/adjust_volume_tts_local()
	set name = "Громкость TTS (Говор)"
	set category = "Preferences.Sound"
	adjust_volume_prefs(VOLUME_TTS_LOCAL, "Громкость TTS в радиусе слышимости", CHANNEL_TTS_LOCAL)

/client/verb/adjust_volume_tts_radio()
	set name = "Громкость TTS (Радио)"
	set category = "Preferences.Sound"
	adjust_volume_prefs(VOLUME_TTS_RADIO, "Громкость TTS в радио", CHANNEL_TTS_RADIO)

/proc/get_rand_frequency()
	return rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.

/mob/proc/playsound_local(turf/turf_source, soundin, vol as num, vary, frequency, falloff_exponent = SOUND_FALLOFF_EXPONENT, channel = 0, pressure_affected = TRUE, sound/S, max_distance, falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, distance_multiplier = 1, use_reverb = TRUE, wait = FALSE) // SS220 EDIT
	if(!client || ear_deaf)
		return

	if(!S)
		S = sound(get_sfx(soundin))

	S.wait = wait
	S.channel = channel || get_free_channel()
	S.volume = vol

	if(vary)
		if(frequency)
			S.frequency = frequency
		else
			S.frequency = get_rand_frequency()

	if(isturf(turf_source))
		var/turf/T = get_turf(src)

		//sound volume falloff with distance
		var/distance = get_dist(T, turf_source)

		distance *= distance_multiplier

		if(max_distance && distance > falloff_distance) //If theres no max_distance we're not a 3D sound, so no falloff.
			S.volume -= (max(distance - falloff_distance, 0) ** (1 / falloff_exponent)) / ((max(max_distance, distance) - falloff_distance) ** (1 / falloff_exponent)) * S.volume
			//https://www.desmos.com/calculator/sqdfl8ipgf

		if(S.volume <= 0)
			return //No sound

		var/dx = turf_source.x - T.x // Hearing from the right/left
		S.x = dx * distance_multiplier
		var/dz = turf_source.y - T.y // Hearing from infront/behind
		S.z = dz * distance_multiplier
		// The y value is for above your head, but there is no ceiling in 2d spessmens.
		S.y = 1

		S.falloff = max_distance || 1 //use max_distance, else just use 1 as we are a direct sound so falloff isnt relevant.

		// Sounds can't have their own environment. A sound's environment will be:
		// 1. the mob's
		// 2. the area's (defaults to SOUND_ENVRIONMENT_NONE)
		if(sound_environment_override != SOUND_ENVIRONMENT_NONE)
			S.environment = sound_environment_override
		else
			var/area/A = get_area(src)
			S.environment = A.sound_environment

		if(use_reverb && S.environment != SOUND_ENVIRONMENT_NONE) //We have reverb, reset our echo setting
			// Check that the user has reverb enabled in their prefs
			//if(!(client?.prefs?.toggles2 & PREFTOGGLE_2_REVERB_DISABLE))
			S.echo[3] = 0 //Room setting, 0 means normal reverb
			S.echo[4] = 0 //RoomHF setting, 0 means normal reverb.

	// S.volume *= USER_VOLUME(src, CHANNEL_GENERAL)
	// if(channel)
	// 	S.volume *= USER_VOLUME(src, channel)
	S.volume *= client.prefs.volume_preferences[VOLUME_TTS_LOCAL]

	SEND_SOUND(src, S)

/proc/apply_sound_effect(effect, filename_input, filename_output)
	if(!effect)
		CRASH("Invalid sound effect chosen.")

	var/taskset
	if((CONFIG_GET(string/ffmpeg_cpuaffinity)))
		taskset = "taskset -ac [CONFIG_GET(string/ffmpeg_cpuaffinity)]"

	var/list/output
	switch(effect)
		if(SOUND_EFFECT_RADIO)
			output = world.shelleo({"[taskset] ffmpeg -y -hide_banner -loglevel error -i [filename_input] -filter:a "highpass=f=1000, lowpass=f=3000, acrusher=1:1:50:0:log" [filename_output]"})
		if(SOUND_EFFECT_ROBOT)
			output = world.shelleo({"[taskset] ffmpeg -y -hide_banner -loglevel error -i [filename_input] -filter:a "afftfilt=real='hypot(re,im)*sin(0)':imag='hypot(re,im)*cos(0)':win_size=1024:overlap=0.5, deesser=i=0.4, volume=volume=1.5" [filename_output]"})
		if(SOUND_EFFECT_RADIO_ROBOT)
			output = world.shelleo({"[taskset] ffmpeg -y -hide_banner -loglevel error -i [filename_input] -filter:a "afftfilt=real='hypot(re,im)*sin(0)':imag='hypot(re,im)*cos(0)':win_size=1024:overlap=0.5, deesser=i=0.4, volume=volume=1.5, highpass=f=1000, lowpass=f=3000, acrusher=1:1:50:0:log" [filename_output]"})
		if(SOUND_EFFECT_MEGAPHONE)
			output = world.shelleo({"[taskset] ffmpeg -y -hide_banner -loglevel error -i [filename_input] -filter:a "highpass=f=500, lowpass=f=4000, volume=volume=10, acrusher=1:1:45:0:log" [filename_output]"})
		if(SOUND_EFFECT_MEGAPHONE_ROBOT)
			output = world.shelleo({"[taskset] ffmpeg -y -hide_banner -loglevel error -i [filename_input] -filter:a "afftfilt=real='hypot(re,im)*sin(0)':imag='hypot(re,im)*cos(0)':win_size=1024:overlap=0.5, deesser=i=0.4, highpass=f=500, lowpass=f=4000, volume=volume=10, acrusher=1:1:45:0:log" [filename_output]"})
		else
			CRASH("Invalid sound effect chosen.")
	var/errorlevel = output[SHELLEO_ERRORLEVEL]
	var/stdout = output[SHELLEO_STDOUT]
	var/stderr = output[SHELLEO_STDERR]
	if(errorlevel)
		error("Error: apply_sound_effect([effect], [filename_input], [filename_output]) - See debug logs.")
		log_debug("apply_sound_effect([effect], [filename_input], [filename_output]) STDOUT: [stdout]")
		log_debug("apply_sound_effect([effect], [filename_input], [filename_output]) STDERR: [stderr]")
		return FALSE
	return TRUE
