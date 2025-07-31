SUBSYSTEM_DEF(sentry)
	name = "Sentry"
	wait = 2 SECONDS
	flags = SS_NO_INIT
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/list/datum/error_envelope/envelopes = list()

	var/static/list/characters = splittext("abcdef012345679", "")

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

			stacktrace += list(list(
				"filename" = called.file,
				"function" = replacetext(called.name, " ", "_"),
				"lineno" = called.line,
				"vars" = parsed_args,
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

		to_chat(world, "assembled: [assembled]")
		to_chat(world, rustg_http_request_blocking(RUSTG_HTTP_METHOD_POST, "https://sentry.cm-ss13.com/api/2/envelope/", assembled, headers, null))

	envelopes = list()

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

/datum/controller/subsystem/sentry/proc/divide_zero(do_it = TRUE, yep = "mhm")
	var/my_important_maths = (5012312 + rand(1, 5)) / (0 + 0)

	pass(my_important_maths)

/client/verb/cause_a_problem()
	SSsentry.divide_zero(FALSE, "nah")
