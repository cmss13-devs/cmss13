/datum/tts_provider/silero
	name = "Silero"
	is_enabled = TRUE

/datum/tts_provider/silero/request(text, datum/tts_seed/silero/seed, datum/callback/proc_callback)
	if(throttle_check())
		return FALSE

	var/ssml_text = "<speak>[text]</speak>"

	var/list/req_body = list(
		"api_token" = CONFIG_GET(string/tts_token_silero),
		"text" = ssml_text,
		"sample_rate" = 24000,
		"ssml" = TRUE,
		"speaker" = seed.value,
		"lang" = "ru",
		"remote_id" = "[world.port]",
		"put_accent" = TRUE,
		"put_yo" = FALSE,
		"symbol_durs" = list(),
		"format" = "ogg",
		"word_ts" = FALSE
	)


	SShttp.create_async_request(
		RUSTG_HTTP_METHOD_POST,
		CONFIG_GET(string/tts_api_url_silero),
		json_encode(req_body),
		list("Content-Type" = "application/json"),
		proc_callback
	)
	return TRUE

/datum/tts_provider/silero/process_response(datum/http_response/response)
	var/data = json_decode(response.body)
	// log_debug(response.body)

	if(data["timings"]["003_tts_time"] > 3)
		is_throttled = TRUE
		throttled_until = world.time + 15 SECONDS

	return data["results"][1]["audio"]

	//var/sha1 = data["original_sha1"]

/datum/tts_provider/silero/pitch_whisper(text)
	return {"<prosody pitch="x-low">[text]</prosody>"}

/datum/tts_provider/silero/rate_faster(text)
	return {"<prosody rate="fast">[text]</prosody>"}

/datum/tts_provider/silero/rate_medium(text)
	return {"<prosody rate="medium">[text]</prosody>"}
