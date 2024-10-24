/**
 * Generic implementation to get a URL that can be sent to
 * clients to play audio via [/datum/tgui_panel/proc/play_music], from a provided URL
 */
/datum/internet_media
	/**
	 * If we have encountered an error while attempting to retrieve the URL
	 */
	var/error

/**
 * Handles a request for an audio file, from a provided media URL
 * Must return a [/datum/media_response], which must have at least the [/datum/media_response/var/url] filled out
 *
 * If we are not returning a media_response, set the [/datum/internet_media/var/error] to be an error
 */
/datum/internet_media/proc/get_media(url)
	RETURN_TYPE(/datum/media_response)

	CRASH("[type] does not override [nameof(__PROC__)].")

/datum/internet_media/yt_dlp

/datum/internet_media/yt_dlp/get_media(url)
	var/ytdl = CONFIG_GET(string/invoke_youtubedl)
	if(!ytdl)
		error = "Youtube-dl FAILED: Not configured"
		return

	if(findtext(url, ":") && !findtext(url, GLOB.is_http_protocol))
		error = "Youtube-dl FAILED: Non-http(s) URIs are not allowed. For youtube-dl shortcuts like ytsearch: please use the appropriate full url from the website."
		return

	var/list/output = world.shelleo("[ytdl] --geo-bypass --format \"bestaudio\[ext=mp3]/best\[ext=mp4]\[height<=360]/bestaudio\[ext=m4a]/bestaudio\[ext=aac]\" --dump-single-json --no-playlist -- \"[shell_url_scrub(url)]\"")
	var/errorlevel = output[SHELLEO_ERRORLEVEL]
	var/stdout = output[SHELLEO_STDOUT]
	var/stderr = output[SHELLEO_STDERR]

	if(errorlevel)
		error = "Youtube-dl URL retrieval FAILED: [stderr]"
		return

	var/data

	try
		data = json_decode(stdout)
	catch(var/exception/decode_error)
		error = "Youtube-dl JSON parsing FAILED: [decode_error]: [stdout]"
		return

	return new /datum/media_response(data["url"], data["title"], data["start_time"], data["end_time"])

/datum/internet_media/cobalt

/datum/internet_media/cobalt/get_media(url)
	var/cobalt = CONFIG_GET(string/cobalt_base_api)
	if(!cobalt)
		error = "cobalt.tools FAILED: Not configured"
		return

	var/list/headers = list()
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"

	var/auth_key = CONFIG_GET(string/cobalt_api_key)
	if(auth_key)
		headers["Authorization"] = "Api-Key [auth_key]"

	var/datum/http_request/request = new
	request.prepare(RUSTG_HTTP_METHOD_POST, cobalt, json_encode(list(
		"url" = url,
		"downloadMode" = "audio"
	)), headers)

	request.execute_blocking()

	var/datum/http_response/response_raw = request.into_response()

	if(response_raw.errored)
		error = "cobalt.tools web request FAILED: [response_raw.error]"
		return

	var/list/response
	try
		response = json_decode(response_raw.body)
	catch(var/exception/decode_error)
		error = "cobalt.tools JSON parsing FAILED: [decode_error]: [response_raw.body]"
		return

	if(!(response["status"] in list("redirect", "tunnel")))
		error = "cobalt.tools request FAILED - invalid response: [response_raw.body]"
		return

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
