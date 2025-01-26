/datum/config_entry/string/tts_http_url
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/string/tts_http_token
	protection = CONFIG_ENTRY_LOCKED|CONFIG_ENTRY_HIDDEN

/datum/config_entry/number/tts_max_concurrent_requests
	default = 4
	min_val = 1

/datum/config_entry/str_list/tts_voice_blacklist

#define SS_PRIORITY_TTS 153

GLOBAL_LIST_INIT(tts_voices_men_whitelists, list(
	"papich",
	"bebey",
	"puchkow",
	"moriarti",
	"biden",
	"obama",
	"trump",
	"dbkn2",
	"xrenoid",
	"briman",
	"father_grigori",
	"vance",
	"barni",
	"squidward",
	"robert_maccready",
	"threedog",
	"jericho_fl3",
	"elder_lyons_fl3",
	"colin_moriarty_fl3",
	"romka",
	"boris_petrov_father_tb",
	"semen_baburin_tb",
	"tihonov_tb",
	"cicero",
	"sheogorath",
	"kodlakwhitemane",
	"khajiit",
	"emperor",
	"guard",
	"hagraven",
	"nord",
	"ulfric",
	"nazir",
	"lord_harkon",
	"geralt",
	"lambert",
	"kovir_nobleman",
	"zoltan_chivay",
	"ekko",
	"ziggs",
	"arthas",
	"rexxar",
	"voljin",
	"bandit",
	"sidorovich",
	"strelok",
	"soldier",
	"engineer",
	"heavy",
	"medic",
	"demoman",
	"sniper",
	"spy",
	"punisher",
	"mitch",
	"jackie",
	"oswald_forrest",
	"steve",
	"butch",
	"marcus",
	"sulik",
	"narrator_d3",
	"dude",
	"anduin",
	"garrosh",
	"uther_hs",
	"bralik",
	"horner",
	"tosh",
	"tychus",
	"amitkakkar",
	"eleazarfig",
	"lodgok",
	"phineasblack",
	"ranrak",
	"gladwinmoon",
	"ominisgaunt",
	"generic_goblin_c",
	"aesop_sharp",
	"abraham_ronen"
))

GLOBAL_LIST_INIT(tts_voices_woman_whitelists, list(
	"charlotte",
	"amina",
	"alyx",
	"moira_brown",
	"sarah_lyons_fl3",
	"karina_petrova_tb",
	"elenwen",
	"astrid",
	"maven",
	"female_commander",
	"serana",
	"glados",
	"cirilla",
	"cerys",
	"triss",
	"caitlyn",
	"tracer",
	"panam",
	"v_female",
	"judy",
	"maiko",
	"nancy_hartley",
	"good_thalya",
	"evil_thalya",
	"hanson",
	"ignatiaflootravel",
	"matildaweasley",
	"natsaionai",
	"poppysweeting",
	"dinah_hecat",
	"samantha_dale",
	"sirona_ryan"
))

SUBSYSTEM_DEF(tts)
	name = "Text To Speech"
	wait = 0.05 SECONDS
	init_order = 84
	priority = SS_PRIORITY_TTS
	runlevels = RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	/// Queued HTTP requests that have yet to be sent. TTS requests are handled as lists rather than datums.
	var/datum/heap/queued_http_messages

	/// An associative list of mobs mapped to a list of their own /datum/tts_request_target
	var/list/queued_tts_messages = list()

	/// TTS audio files that are being processed on when to be played.
	var/list/current_processing_tts_messages = list()

	/// HTTP requests currently in progress but not being processed yet
	var/list/in_process_http_messages = list()

	/// HTTP requests that are being processed to see if they've been finished
	var/list/current_processing_http_messages = list()

	/// A list of available speakers, which are string identifiers of the TTS voices that can be used to generate TTS messages.
	var/list/available_speakers = list()

	/// Whether TTS is enabled or not
	var/tts_enabled = FALSE
	/// Whether the TTS engine supports pitch adjustment or not.
	var/pitch_enabled = FALSE

	/// TTS messages won't play if requests took longer than this duration of time.
	var/message_timeout = 7 SECONDS

	/// The max concurrent http requests that can be made at one time. Used to prevent 1 server from overloading the tts server
	var/max_concurrent_requests = 4

	/// Used to calculate the average time it takes for a tts message to be received from the http server
	/// For tts messages which time out, it won't keep tracking the tts message and will just assume that the message took
	/// 7 seconds (or whatever the value of message_timeout is) to receive back a response.
	var/average_tts_messages_time = 0

/datum/controller/subsystem/tts/vv_edit_var(var_name, var_value)
	// tts being enabled depends on whether it actually exists
	if(NAMEOF(src, tts_enabled) == var_name)
		return FALSE
	return ..()

/datum/controller/subsystem/tts/stat_entry(msg)
	msg = "Active:[length(in_process_http_messages)]|Standby:[length(queued_http_messages?.L)]|Avg:[average_tts_messages_time]"
	return ..()

/proc/cmp_word_length_asc(datum/tts_request/a, datum/tts_request/b)
	return length(b.message) - length(a.message)

/datum/controller/subsystem/tts/Shutdown()
	tts_enabled = FALSE
	if (fexists("tmp/tts/"))
		fdel("tmp/tts/")
	for(var/datum/tts_request/data in in_process_http_messages)
		var/datum/http_request/request = data.request
		UNTIL(request.is_complete())

/// Establishes (or re-establishes) a connection to the TTS server and updates the list of available speakers.
/// This is blocking, so be careful when calling.
/datum/controller/subsystem/tts/proc/establish_connection_to_tts()
	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_GET, "[CONFIG_GET(string/tts_http_url)]/speakers", "")
	request.begin_async()
	UNTIL(request.is_complete())
	var/datum/http_response/response = request.into_response()
	if(response.errored || response.status_code != 200)
		stack_trace(response.error)
		return FALSE
	var/list/temp_speakers = json_decode(response.body)?["voices"]
	for(var/speaker in temp_speakers)
		available_speakers.Add(speaker["speakers"][1])
	tts_enabled = TRUE
	if(CONFIG_GET(str_list/tts_voice_blacklist))
		var/list/blacklisted_voices = CONFIG_GET(str_list/tts_voice_blacklist)
		log_config("Processing the TTS voice blacklist.")
		for(var/voice in blacklisted_voices)
			if(available_speakers.Find(voice))
				log_config("Removed speaker [voice] from the TTS voice pool per config.")
				available_speakers.Remove(voice)
	var/datum/http_request/request_pitch = new()
	request_pitch.prepare(RUSTG_HTTP_METHOD_GET, "[CONFIG_GET(string/tts_http_url)]/pitch-available", "")
	request_pitch.begin_async()
	UNTIL(request_pitch.is_complete())
	pitch_enabled = TRUE
	var/datum/http_response/response_pitch = request_pitch.into_response()
	if(response_pitch.errored || response_pitch.status_code != 200)
		if(response_pitch.errored)
			stack_trace(response.error)
		pitch_enabled = FALSE
	rustg_file_write(json_encode(available_speakers), "data/cached_tts_voices.json")
	rustg_file_write("rustg HTTP requests can't write to folders that don't exist, so we need to make it exist.", "tmp/tts/init.txt")
	return TRUE

/datum/controller/subsystem/tts/Initialize()
	if(!CONFIG_GET(string/tts_http_url))
		return SS_INIT_NO_NEED

	queued_http_messages = new /datum/heap(GLOBAL_PROC_REF(cmp_word_length_asc))
	max_concurrent_requests = CONFIG_GET(number/tts_max_concurrent_requests)
	if(!establish_connection_to_tts())
		return SS_INIT_FAILURE
	return SS_INIT_SUCCESS

/datum/controller/subsystem/tts/proc/should_play_hivemind_tts(client/listener, target)
	var/hivemind_preference = listener?.prefs.tts_hivemind_mode
	if(hivemind_preference == TTS_HIVEMIND_ALL)
		return TRUE
	else if(hivemind_preference == TTS_HIVEMIND_LEADERS)
		var/mob/living/carbon/xenomorph/xeno = target
		if(!istype(xeno))
			return FALSE
		if(isqueen(xeno) || IS_XENO_LEADER(xeno))
			return TRUE
	else if(hivemind_preference == TTS_HIVEMIND_QUEEN)
		if(isqueen(target))
			return TRUE
	return FALSE

/datum/controller/subsystem/tts/proc/play_tts(target, list/listeners, sound/audio, volume_offset = 0, flags)
	for(var/mob/receiver in listeners)
		if(!receiver.client || !receiver.client.prefs)
			continue
		if(receiver.client.prefs.tts_mode == TTS_SOUND_OFF)
			continue
		if((flags & TTS_FLAG_HIVEMIND) && !should_play_hivemind_tts(receiver.client, target))
			continue
		playsound_client(receiver.client, audio, flags ? null : target, volume_offset, vol_cat = VOLUME_TTS)

#define SHIFT_DATA_ARRAY(tts_message_queue, target, data) \
	popleft(##data); \
	if(length(##data) == 0) { \
		##tts_message_queue -= ##target; \
	};

#define TTS_ARBRITRARY_DELAY "arbritrary delay"

/datum/controller/subsystem/tts/fire(resumed)
	if(!tts_enabled)
		flags |= SS_NO_FIRE
		return

	if(!resumed)
		while(length(in_process_http_messages) < max_concurrent_requests && length(queued_http_messages.L) > 0)
			var/datum/tts_request/entry = queued_http_messages.pop()
			var/timeout = entry.start_time + message_timeout
			if(timeout < world.time)
				entry.timed_out = TRUE
				continue
			entry.start_requests()
			in_process_http_messages += entry
		current_processing_http_messages = in_process_http_messages.Copy()
		current_processing_tts_messages = queued_tts_messages.Copy()

	// For speed
	var/list/processing_messages = current_processing_http_messages
	while(processing_messages.len)
		var/datum/tts_request/current_request = processing_messages[processing_messages.len]
		processing_messages.len--
		if(!current_request.requests_completed())
			continue

		var/datum/http_response/response = current_request.get_primary_response()
		in_process_http_messages -= current_request
		average_tts_messages_time = MC_AVERAGE(average_tts_messages_time, world.time - current_request.start_time)
		var/identifier = current_request.identifier
		if(current_request.requests_errored())
			current_request.timed_out = TRUE
			continue
		current_request.audio_length = text2num(response.headers["audio-length"]) * 10
		if(!current_request.audio_length)
			current_request.audio_length = 0
		current_request.audio_file = "tmp/tts/[identifier].ogg"
		// Don't need the request anymore so we can deallocate it
		current_request.request = null
		if(MC_TICK_CHECK)
			return

	var/list/processing_tts_messages = current_processing_tts_messages
	while(processing_tts_messages.len)
		if(MC_TICK_CHECK)
			return

		var/datum/tts_target = processing_tts_messages[processing_tts_messages.len]
		var/list/data = processing_tts_messages[tts_target]
		processing_tts_messages.len--
		if(QDELETED(tts_target))
			queued_tts_messages -= tts_target
			continue

		var/datum/tts_request/current_target = data[1]
		// This determines when we start the timer to time out.
		// This is so that the TTS message doesn't get timed out if it's waiting
		// on another TTS message to finish playing their audio.

		// For example, if a TTS message plays for more than 7 seconds, which is our current timeout limit,
		// then the next TTS message would be unable to play.
		var/timeout_start = current_target.when_to_play
		if(!timeout_start)
			// In the normal case, we just set timeout to start_time as it means we aren't waiting on
			// a TTS message to finish playing
			timeout_start = current_target.start_time

		var/timeout = timeout_start + message_timeout
		// Here, we check if the request has timed out or not.
		// If current_target.timed_out is set to TRUE, it means the request failed in some way
		// and there is no TTS audio file to play.
		if(timeout < world.time || current_target.timed_out)
			SHIFT_DATA_ARRAY(queued_tts_messages, tts_target, data)
			continue

		if(current_target.audio_file)
			if(current_target.audio_file == TTS_ARBRITRARY_DELAY)
				if(current_target.when_to_play < world.time)
					SHIFT_DATA_ARRAY(queued_tts_messages, tts_target, data)
				continue
			var/sound/audio_file
			if(current_target.local)
				audio_file = new(current_target.audio_file)
				SEND_SOUND(current_target.target, audio_file)
				SHIFT_DATA_ARRAY(queued_tts_messages, tts_target, data)
			else if(current_target.when_to_play < world.time)
				audio_file = new(current_target.audio_file)
				if(current_target.start_noise)
					playsound(tts_target, current_target.start_noise, 5, TRUE)
				var/turf/turf_source = get_turf(tts_target)
				if(turf_source)
					play_tts(turf_source, current_target.listeners[1], audio_file, current_target.volume_offset + 60)
					play_tts(turf_source, current_target.listeners[2], audio_file, current_target.volume_offset + 30, TTS_FLAG_RADIO)
					play_tts(turf_source, current_target.listeners[3], audio_file, current_target.volume_offset + 30, TTS_FLAG_HIVEMIND)
				if(length(data) != 1)
					var/datum/tts_request/next_target = data[2]
					next_target.when_to_play = world.time + current_target.audio_length
				else
					// So that if the audio file is already playing whilst a new file comes in,
					// it won't play in the middle of the audio file.
					var/datum/tts_request/arbritrary_delay = new()
					arbritrary_delay.when_to_play = world.time + current_target.audio_length
					arbritrary_delay.audio_file = TTS_ARBRITRARY_DELAY
					queued_tts_messages[tts_target] += arbritrary_delay
				SHIFT_DATA_ARRAY(queued_tts_messages, tts_target, data)


#undef TTS_ARBRITRARY_DELAY

/datum/controller/subsystem/tts/proc/queue_tts_message(datum/target, message, speaker, filter, list/listeners, local = FALSE, volume_offset = 0, pitch = 0, special_filters = "", start_noise = null)
	if(!tts_enabled)
		return

	// TGS updates can clear out the tmp folder, so we need to create the folder again if it no longer exists.
	if(!fexists("tmp/tts/init.txt"))
		rustg_file_write("rustg HTTP requests can't write to folders that don't exist, so we need to make it exist.", "tmp/tts/init.txt")

	var/identifier = "[sha1(speaker + filter + num2text(pitch) + special_filters + message)].[world.time]"
	if(!(speaker in available_speakers))
		return

	var/list/headers = list()
	headers["Content-Type"] = "application/json"
	headers["Authorization"] = "Bearer [CONFIG_GET(string/tts_http_token)]"
	var/datum/http_request/request = new()
	var/file_name = "tmp/tts/[identifier].ogg"

	request.prepare(RUSTG_HTTP_METHOD_GET, "[CONFIG_GET(string/tts_http_url)]?speaker=[speaker]&effect=[url_encode(special_filters)]&pitch=[pitch]&ext=ogg&text=[message]", null, headers, file_name)
	var/datum/tts_request/current_request = new /datum/tts_request(identifier, request, message, target, local, volume_offset, listeners, pitch, start_noise)

	var/list/player_queued_tts_messages = queued_tts_messages[target]
	if(!player_queued_tts_messages)
		player_queued_tts_messages = list()
		queued_tts_messages[target] = player_queued_tts_messages
	player_queued_tts_messages += current_request
	if(length(in_process_http_messages) < max_concurrent_requests)
		current_request.start_requests()
		in_process_http_messages += current_request
	else
		queued_http_messages.insert(current_request)

/// A struct containing information on an individual player or mob who has made a TTS request
/datum/tts_request
	/// The mob to play this TTS message on
	var/mob/target
	/// The people who are going to hear this TTS message
	/// Does nothing if local is set to TRUE
	var/list/listeners
	/// The HTTP request of this message
	var/datum/http_request/request
	/// The message itself
	var/message
	/// The message identifier
	var/identifier
	/// The volume offset to play this TTS at.
	var/volume_offset = 0
	/// Whether this TTS message should be sent to the target only or not.
	var/local = FALSE
	/// The time at which this request was started
	var/start_time

	/// The audio file of this tts request.
	var/sound/audio_file
	/// The audio length of this tts request.
	var/audio_length
	/// When the audio file should play at the minimum
	var/when_to_play = 0
	/// Whether this request was timed out or not
	var/timed_out = FALSE
	/// What's the pitch adjustment?
	var/pitch = 0
	/// Sfx to play when the voice is ready to play.
	var/start_noise

BSQL_PROTECT_DATUM(/datum/tts_request)

/datum/tts_request/New(identifier, datum/http_request/request, message, target, local, volume_offset, list/listeners, pitch, start_noise)
	. = ..()
	src.identifier = identifier
	src.request = request
	src.message = message
	src.target = target
	src.local = local
	src.volume_offset = volume_offset
	src.listeners = listeners
	src.pitch = pitch
	src.start_noise = start_noise
	start_time = world.time

/datum/tts_request/proc/start_requests()
	request.begin_async()

/datum/tts_request/proc/get_primary_response()
	return request.into_response()

/datum/tts_request/proc/requests_errored()
	var/datum/http_response/response = request.into_response()
	return response.errored

/datum/tts_request/proc/requests_completed()
	return request.is_complete()

#undef SHIFT_DATA_ARRAY


//////////////////////
//datum/heap object
//////////////////////

/datum/heap
	var/list/L
	var/cmp

/datum/heap/New(compare)
	L = new()
	cmp = compare

/datum/heap/Destroy(force, ...)
	for(var/i in L) // because this is before the list helpers are loaded
		qdel(i)
	L = null
	return ..()

/datum/heap/proc/is_empty()
	return !length(L)

//insert and place at its position a new node in the heap
/datum/heap/proc/insert(A)

	L.Add(A)
	swim(length(L))

//removes and returns the first element of the heap
//(i.e the max or the min dependant on the comparison function)
/datum/heap/proc/pop()
	if(!length(L))
		return 0
	. = L[1]

	L[1] = L[length(L)]
	L.Cut(length(L))
	if(length(L))
		sink(1)

//Get a node up to its right position in the heap
/datum/heap/proc/swim(index)
	var/parent = round(index * 0.5)

	while(parent > 0 && (call(cmp)(L[index],L[parent]) > 0))
		L.Swap(index,parent)
		index = parent
		parent = round(index * 0.5)

//Get a node down to its right position in the heap
/datum/heap/proc/sink(index)
	var/g_child = get_greater_child(index)

	while(g_child > 0 && (call(cmp)(L[index],L[g_child]) < 0))
		L.Swap(index,g_child)
		index = g_child
		g_child = get_greater_child(index)

//Returns the greater (relative to the comparison proc) of a node children
//or 0 if there's no child
/datum/heap/proc/get_greater_child(index)
	if(index * 2 > length(L))
		return 0

	if(index * 2 + 1 > length(L))
		return index * 2

	if(call(cmp)(L[index * 2],L[index * 2 + 1]) < 0)
		return index * 2 + 1
	else
		return index * 2

//Replaces a given node so it verify the heap condition
/datum/heap/proc/resort(A)
	var/index = L.Find(A)

	swim(index)
	sink(index)

/datum/heap/proc/List()
	. = L.Copy()

/mob
	/// Text to speech voice. Set to null if no voice.
	var/tts_voice
	/// Text to speech filter. Filter that gets applied when passed in.
	var/tts_voice_filter = ""
	/// Text to speech pitch. Used to determine the pitch of the voice.
	var/tts_voice_pitch = 0

	var/speaking_noise
	var/has_tts_voice = TRUE

/client/verb/adjust_volume_tts()
	set name = "Adjust Volume TTS"
	set category = "Preferences.Sound"
	adjust_volume_prefs(VOLUME_TTS, "Set the volume for TTS", 0)

/datum/preferences
	var/voice = "Random"
	var/voice_pitch = 0
	var/xeno_voice = "Random"
	var/xeno_pitch = 0
	var/synth_voice = "Random"
	var/synth_pitch = 0
	var/tts_mode = TTS_SOUND_ENABLED
	var/tts_hivemind_mode = TTS_HIVEMIND_LEADERS
	var/tts_radio_mode = TTS_RADIO_BIG_VOICE_ONLY
	COOLDOWN_DECLARE(tts_test_cooldown)

/datum/preferences/proc/tts_hivemind_to_text(value)
	switch(value)
		if(TTS_HIVEMIND_OFF)
			return "Disabled"
		if(TTS_HIVEMIND_QUEEN)
			return "Queen"
		if(TTS_HIVEMIND_LEADERS)
			return "Queen and leaders"
		if(TTS_HIVEMIND_ALL)
			return "Everyone"

/datum/species
	/// Whether they have a TTS voice or not.
	var/has_tts_voice = TRUE

/datum/species/synthetic/colonial/working_joe
	has_tts_voice = FALSE

/datum/species/yautja
	has_tts_voice = FALSE

/mob/living/carbon/xenomorph
	speaking_noise = "alien_talk"
//	tts_voice_filter = TTS_FILTER_XENO

/mob/living/carbon/xenomorph/proc/init_voice()
	if(!client)
		return
	if(!SStts.tts_enabled)
		return
	tts_voice = sanitize_inlist(client.prefs?.xeno_voice, SStts.available_speakers, pick(SStts.available_speakers))
	tts_voice_pitch = client.prefs?.xeno_pitch
