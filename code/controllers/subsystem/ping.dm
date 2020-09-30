SUBSYSTEM_DEF(ping)
	name = "Ping"
	priority = SS_PRIORITY_PING
	wait = 3 SECONDS
	flags = SS_NO_INIT | SS_DISABLE_FOR_TESTING
	runlevels = RUNLEVELS_DEFAULT|RUNLEVEL_LOBBY
	var/list/currentrun = list()

/datum/controller/subsystem/ping/stat_entry()
	..("P:[GLOB.clients.len]")

/datum/controller/subsystem/ping/fire(resumed = 0)
	if (!resumed)
		src.currentrun = GLOB.clients.Copy()

	var/list/currentrun = src.currentrun

	while (currentrun.len)
		var/client/C = currentrun[currentrun.len]
		currentrun.len--

		if (!C || !C.chatOutput || !C.chatOutput.loaded)
			if (MC_TICK_CHECK)
				return
			continue

		// softPang isn't handled anywhere but it'll always reset the opts.lastPang.
		var/data = (C.is_afk(29) ? "softPang" : "pang")
		C.chatOutput.browser_send(C, data)
		if (MC_TICK_CHECK)
			return