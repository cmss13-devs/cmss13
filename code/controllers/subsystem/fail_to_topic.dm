SUBSYSTEM_DEF(fail_to_topic)
	name = "Fail to Topic"
	init_order = SS_INIT_FAIL_TO_TOPIC
	flags = SS_BACKGROUND
	runlevels = ALL

	var/list/rate_limiting = list()
	var/list/fail_counts = list()
	var/list/active_bans = list()
	var/list/currentrun = list()

	var/rate_limit
	var/max_fails
	var/enabled = FALSE

/datum/controller/subsystem/fail_to_topic/Initialize(timeofday)
	rate_limit = ((CONFIG_GET(number/topic_rate_limit)) SECONDS)
	max_fails = CONFIG_GET(number/topic_max_fails)
	enabled = CONFIG_GET(flag/topic_enabled)

	if (world.system_type == UNIX && enabled)
		enabled = FALSE
		WARNING("fail_to_topic subsystem disabled. UNIX is not supported.")
		return SS_INIT_NO_NEED

	if (!enabled)
		can_fire = FALSE
		return SS_INIT_NO_NEED

	return SS_INIT_SUCCESS

/datum/controller/subsystem/fail_to_topic/fire(resumed = FALSE)
	if(!resumed)
		currentrun = rate_limiting.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = currentrun

	while(current_run.len)
		var/ip = current_run[current_run.len]
		var/last_attempt = current_run[ip]
		current_run.len--

		// last_attempt list housekeeping
		if(world.time - last_attempt > rate_limit)
			rate_limiting -= ip
			fail_counts -= ip

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/fail_to_topic/proc/IsRateLimited(ip)
	if(!enabled)
		return FALSE

	var/last_attempt = rate_limiting[ip]

	if (config.fail_to_topic_whitelisted_ips[ip])
		return FALSE

	if (active_bans[ip])
		return TRUE

	rate_limiting[ip] = world.time

	if (isnull(last_attempt))
		return FALSE

	if (world.time - last_attempt > rate_limit)
		fail_counts -= ip
		return FALSE
	else
		var/failures = fail_counts[ip]

		if (isnull(failures))
			fail_counts[ip] = 1
			return TRUE
		else if (failures > max_fails)
			return TRUE
		else
			fail_counts[ip] = failures + 1
			return TRUE
