SUBSYSTEM_DEF(sentry)
	name = "Sentry"
	wait = 2 SECONDS
	flags = SS_NO_INIT
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/list/datum/error_envelope/envelopes = list()

	var/static/list/characters = splittext("abcdef012345679", "")
	var/list/hashed_context = list()

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
		dsn = CONFIG_GET(string/sentry_dsn)

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

			stacktrace += list(list(
				"filename" = called.file,
				"function" = proc_path.type,
				"lineno" = called.line,
				"vars" = parsed_args,
				"pre_context" = pre_context,
				"context_line" = context,
				"post_context" = post_context,
				"source_link" = "https://github.com/cmss13-devs/cmss13/blob/[git_revision]/[called.file]#L[called.line]"
			))

		var/list/event_parts = list(
			"event_id" = event_id,
			"platform" = "other",
			"server_name" = CONFIG_GET(string/servername),
			"release" = git_revision,
			"exception" = list(
				"type" = error.error,
				"value" = "Runtime Error",
				"stacktrace" = list("frames" = stacktrace),
			),
		)

		var/event = json_encode(event_parts)

		var/event_header = "{\"type\":\"event\",\"length\":[length(event)]}"

		var/assembled = "[header]\n[event_header]\n[event]\n"

		rustg_http_request_async(RUSTG_HTTP_METHOD_POST, CONFIG_GET(string/sentry_endpoint), assembled, headers, null)

	envelopes = list()

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
