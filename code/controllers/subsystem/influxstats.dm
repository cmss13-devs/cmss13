SUBSYSTEM_DEF(influxstats)
	name       = "InfluxDB Statistics"
	wait       = 60 SECONDS
	priority   = SS_PRIORITY_INFLUXSTATS
	init_order = SS_INIT_INFLUXSTATS
	runlevels  = RUNLEVEL_GAME
	flags      = SS_KEEP_TIMING
	var/sent   = 0

/datum/controller/subsystem/influxstats/Initialize()
	var/period = text2num(CONFIG_GET(string/round_results_influxdb_period))
	if(isnum(period))
		wait = max(period * (1 SECONDS), 10 SECONDS)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/influxstats/stat_entry(msg)
	msg += "sent=[sent]"
	return ..()

/datum/controller/subsystem/influxstats/fire(resumed)
	var/host = CONFIG_GET(string/round_results_influxdb_host)
	var/token = CONFIG_GET(string/round_results_influxdb_token)
	var/bucket = CONFIG_GET(string/round_results_influxdb_bucket)
	var/org = CONFIG_GET(string/round_results_influxdb_org)
	if(!host || !token || !bucket || !org)
		can_fire = FALSE
		return
	if(!SSticker.mode)
		return // That shouldn't happen with runlevels

	var/url = "[host]/api/v2/write?org=[org]&bucket=[bucket]&precision=s"
	var/list/headers = list()
	headers["Authorization"] = "Token [token]"
	headers["Content-Type"] = "text/plain; charset=utf-8"
	headers["Accept"] = "application/json"

	var/measurement = "round_results,round_id=[GLOB.round_id]"
	var/timestamp = big_number_to_text(rustg_unix_timestamp())
	var/list/job_stats = list("others" = list(), "xenos" = list(), "humans" = list())

	for(var/client/client in GLOB.clients)
		var/mob/mob = client.mob
		if(!mob)
			continue
		var/job = mob.job
		var/team
		if(isobserver(mob))
			job = JOB_OBSERVER
			team = "others"
		else if(!job || mob.stat == DEAD)
			continue
		var/short_job = replacetext(sanitize(job), " ", "")
		if(isxeno(mob))
			team = "xenos"
		else if (ishuman(mob))
			team = "humans"
		else
			team = "others"
		if(!job_stats[team][short_job])
			job_stats[team][short_job] = 0
		job_stats[team][short_job] += 1

	var/list/measurements = list()
	for(var/iteam in job_stats)
		for(var/ijob in job_stats[iteam])
			measurements += "[measurement],team=[iteam],job=[ijob] count=[job_stats[iteam][ijob]] [timestamp]"

	var/datum/http_request/req
	req = new
	var/payload = ""
	for(var/line in measurements)
		payload += "[line]\n"
	req.prepare(RUSTG_HTTP_METHOD_POST, url, payload, headers)
	req.begin_async()
	sent++
