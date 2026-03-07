#define DSN_CONFIG CONFIG_GET(string/sentry_dsn)
#define ENDPOINT_CONFIG CONFIG_GET(string/sentry_endpoint)

SUBSYSTEM_DEF(sentry)
	name = "Sentry"
	wait = 2 SECONDS
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/list/datum/error_envelope/envelopes = list()

	var/static/list/characters = splittext("abcdef012345679", "")
	var/list/hashed_context = list()

	var/static/regex/protected_datums

/datum/controller/subsystem/sentry/Initialize()
	. = ..()
	var/config_dsn = DSN_CONFIG
	var/config_endpoint = ENDPOINT_CONFIG
	if(!config_dsn || !config_endpoint)
		can_fire = FALSE
		return SS_INIT_NO_NEED

	if(length(GLOB.protected_sentry_datums))
		protected_datums = regex("([GLOB.protected_sentry_datums.Join(")|(")])", "g")

	return SS_INIT_SUCCESS

/datum/controller/subsystem/sentry/fire(resumed)
	var/static/list/headers = list(
		"Content-Type" = "application/x-sentry-envelope",
		"User-Agent" = "sentry.dm/1.0.0",
	)

	var/static/git_revision
	if(!git_revision)
		git_revision = GLOB.revdata.commit

	var/static/dsn
	if(!dsn)
		dsn = DSN_CONFIG

	var/static/endpoint
	if(!endpoint)
		endpoint = ENDPOINT_CONFIG

	var/static/regex/ip_regex = regex(@"(((?!25?[6-9])[12]\d|[1-9])?\d\.?\b){4}", "g")
	var/regex/pii_regex = regex("([GLOB.all_player_ckeys.Join(")|(")])|([GLOB.all_player_cids.Join(")|(")])", "g")

	for(var/datum/error_envelope/error as anything in envelopes)
		var/event_id = get_uuid()

		var/header = "{\"event_id\":\"[event_id]\",\"dsn\":\"[dsn]\"}"

		var/list/stacktrace = list()
		for(var/datum/static_callee/called as anything in error.stacktrace)

			var/list/parsed_args = list(
				"src" = called._src,
				"usr" = called._usr,
			)
			var/index = 1
			for(var/arg in called._args)
				parsed_args["argument #[index]"] = arg
				index++

			var/pre_context, context, post_context

			var/hash = "[called.file]:[called.line]"
			if(hash in hashed_context)
				pre_context = hashed_context[hash][1]
				context = hashed_context[hash][2]
				post_context = hashed_context[hash][3]
			else
				var/list/file_lines = splittext(rustg_file_read(called.file), "\n")

				pre_context = file_lines.Copy(clamp(called.line - 5, 1, length(file_lines)), called.line)
				context = file_lines[called.line]
				post_context = file_lines.Copy(called.line + 1, clamp(called.line + 6, 1, length(file_lines)))

				hashed_context[hash] = list(pre_context, context, post_context)

			var/procpath/proc_path = called.proc

			var/censor_args = FALSE
			if(proc_path.type in GLOB.protected_sentry_procs)
				censor_args = TRUE

			if(protected_datums.Find(proc_path.type))
				censor_args = TRUE

			var/to_add = list(
				"filename" = called.file,
				"function" = proc_path.type,
				"lineno" = called.line,
				"pre_context" = pre_context,
				"context_line" = context,
				"post_context" = post_context,
				"source_link" = "https://github.com/cmss13-devs/cmss13/blob/[git_revision]/[called.file]#L[called.line]"
			)

			if(!censor_args)
				to_add["vars"] = parsed_args

			stacktrace += list(to_add)

		var/list/event_parts = list(
			"event_id" = event_id,
			"platform" = "other",
			"server_name" = CONFIG_GET(string/servername),
			"release" = git_revision,
			"tags" = list(
				"round_id" = GLOB.round_id,
			),
			"exception" = list(
				"type" = error.error,
				"value" = "Runtime Error",
				"stacktrace" = list("frames" = stacktrace),
			),
		)

		var/event = json_encode(event_parts)

		ip_regex.Replace(event, "ip address")
		pii_regex.Replace(event, "user pii")

		var/event_header = "{\"type\":\"event\",\"length\":[length(event)]}"
		var/assembled = "[header]\n[event_header]\n[event]\n"

		rustg_http_request_fire_and_forget(RUSTG_HTTP_METHOD_POST, endpoint, assembled, headers, null)

	envelopes.Cut()

/// Generates a 32 character hex UUID, as random as BYOND will be
/datum/controller/subsystem/sentry/proc/get_uuid()
	var/uuid = ""
	for(var/i in 1 to 32)
		uuid += characters[rand(1, length(characters))]
	return uuid

/datum/error_envelope
	var/error

	var/list/callee/stacktrace

/datum/error_envelope/New(error, list/callee/stacktrace)
	. = ..()

	src.error = error
	src.stacktrace = stacktrace

#undef DSN_CONFIG
#undef ENDPOINT_CONFIG
