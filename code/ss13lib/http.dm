/// Attempts to perform a HTTP request where we don't care about the result
/// If it exists, attempts to use rustg_http_request_fire_and_forget,
/// if not, it uses world.Export. A custom handler can be provided,
/// which will take precedence.
/datum/ss13lib/proc/perform_fire_and_forget_http(method, url, data)
#if defined(SS13LIB_HTTP_FIRE_AND_FORGET)
	SS13LIB_HTTP_FIRE_AND_FORGET(method, url, data)
#elif defined(rustg_http_request_fire_and_forget)
	if(!isnull(data))
		rustg_http_request_fire_and_forget(method, url, json_encode(data), json_encode(list("Content-Type" = "application/json")), null)
	else
		rustg_http_request_fire_and_forget(method, url, null, null, null)
#elif DM_VERSION >= 516 && DM_BUILD >= 1664
	world.Export(url, data, 0, null, method)
#else
	#error Either `rustg_http_request_fire_and_forget` must be available, or 516.1664 must be in use.
	#error If your codebase has a custom HTTP implementation, it can be provided using
	#error #define SS13LIB_HTTP_FIRE_AND_FORGET(method, url, data)
#endif

/datum/ss13lib_http_response
	var/status_code
	var/body

	var/errored = FALSE

/// Attempts to perform a HTTP request. This proc will sleep until it gets a response.
/// If rustg_http_request_async is available, it will use that. If not, it will use world.Export.
/// A custom handler can be provided, which will take precedence. It is expected that this wrapper
/// returns a /datum/ss13lib_http_response
/datum/ss13lib/proc/perform_http_request(method, url, data) as /datum/ss13lib_http_response
	var/datum/ss13lib_http_response/response = null

#if defined(SS13LIB_HTTP_ASYNC)
	response = SS13LIB_HTTP_ASYNC(method, url, data)

	// The `data` field sent to rust-g will *always* be JSON-encoded here and put in the body.
#elif defined(rustg_http_request_async) && defined(rustg_http_check_request) && defined(RUSTG_JOB_NO_RESULTS_YET)
	var/identifier = rustg_http_request_async(method, url, json_encode(data), json_encode(list("Content-Type" = "application/json")), null)
	var/raw = rustg_http_check_request(identifier)
	while(raw == RUSTG_JOB_NO_RESULTS_YET)
		sleep(world.tick_lag)
		raw = rustg_http_check_request(identifier)

	response = new

	try
		var/decoded = json_decode(raw)
		response.status_code = decoded["status_code"]
		response.body = decoded["body"]
	catch(var/exception/rustg_http_error)
		SS13LIB_ERROR_LOG("Failed to decode rust-g HTTP, [raw]: [rustg_http_error.name]")
		response.errored = TRUE

	// The `data` field sent via world.Export is as an associative list, and will be received
	// as a form body. This avoids having to write to the file system here, but means the
	// consuming server must allow for both form body and JSON body input
#elif DM_VERSION >= 516 && DM_BUILD >= 1664
	SS13LIB_INFO_LOG("HTTP [method] [url] (world.Export)")
	var/raw = world.Export(url, data, 0, null, method)

	response = new

	if(!raw)
		SS13LIB_ERROR_LOG("HTTP [method] [url]: world.Export returned null")
		response.errored = TRUE
	else
		response.status_code = text2num(copytext(raw["STATUS"], 1, 4))
		response.body = file2text(raw["CONTENT"])
		SS13LIB_INFO_LOG("HTTP [method] [url]: status [response.status_code]")

		if(response.status_code == 0)
			response.errored = TRUE

#else
	#error Either `rustg_http_request_async` must be available, or 516.1664 must be in use.
	#error If your codebase has a custom HTTP implementation, it can be provided using
	#error #define SS13LIB_HTTP_ASYNC(method, url, data), returning a /datum/ss13lib_http_response
#endif

	return response
