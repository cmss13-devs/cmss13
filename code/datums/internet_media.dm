/**
 * Generic implementation to get a URL that can be sent to
 * clients to play audio via [/datum/tgui_panel/proc/play_music], from a provided URL
 */
/datum/internet_media

/**
 * Handles a request for an audio file, from a provided media URL
 * Must return a [/datum/media_response], which must have at least the [/datum/media_response/var/url] filled out
 */
/datum/internet_media/proc/get_media(url)
	RETURN_TYPE(/datum/media_response)

	CRASH("[type] does not override [nameof(__PROC__)].")

/datum/internet_media/yt_dlp

/datum/internet_media/yt_dlp/get_media(url)
	var/ytdl = CONFIG_GET(string/invoke_youtubedl)
	if(!ytdl)
		return

	if(findtext(url, ":") && !findtext(url, GLOB.is_http_protocol))
		return

	var/list/output = world.shelleo("[ytdl] --geo-bypass --format \"bestaudio\[ext=mp3]/best\[ext=mp4]\[height<=360]/bestaudio\[ext=m4a]/bestaudio\[ext=aac]\" --dump-single-json --no-playlist -- \"[shell_url_scrub(url)]\"")
	var/errorlevel = output[SHELLEO_ERRORLEVEL]
	var/stdout = output[SHELLEO_STDOUT]
	var/stderr = output[SHELLEO_STDERR]

	if(errorlevel)
		CRASH("Youtube-dl URL retrieval FAILED: [stderr]")

	var/data

	try
		data = json_decode(stdout)
	catch(var/exception/e)
		CRASH("Youtube-dl JSON parsing FAILED: [e]: [stdout]")

	return new /datum/media_response(data["url"], data["title"], data["start_time"], data["end_time"])

/datum/internet_media/cobalt

/datum/internet_media/cobalt/get_media(url)
	var/list/headers = list()
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"

	var/auth_key = CONFIG_GET(string/cobalt_api_key)
	if(auth_key)
		headers["Authorization"] = "Api-Key [auth_key]"

	var/datum/http_request/request = new
	request.prepare(RUSTG_HTTP_METHOD_POST, CONFIG_GET(string/cobalt_base_api), json_encode(list(
		"url" = url,
		"downloadMode" = "audio"
	)), headers)

	request.execute_blocking()

	var/datum/http_response/response_raw = request.into_response()

	if(response_raw.errored)
		CRASH("cobalt.tools web request FAILED: [response_raw.error]")

	var/list/response
	try
		response = json_decode(response_raw.body)
	catch(var/exception/e)
		CRASH("cobalt.tools JSON parsing FAILED: [e]: [response_raw.body]")

	if(!(response["status"] in list("redirect", "tunnel")))
		CRASH("cobalt.tools request FAILED - invalid response: [response_raw.body]")
	return new /datum/media_response(response["url"])

/datum/media_response
	var/url
	var/title
	var/start_time
	var/end_time

/datum/media_response/New(url, title, start_time, end_time)
	if(isnull(url))
		CRASH("/datum/media_response created without a URL field.")

	src.url = url
	src.title = title
	src.start_time = start_time
	src.end_time = end_time

/datum/media_response/proc/get_list()
	return list("url" = url, "title" = title, "start_time" = start_time, "end_time" = end_time)
