SUBSYSTEM_DEF(influxstats)
	name       = "InfluxDB Statistics"
	wait       = 60 SECONDS
	priority   = SS_PRIORITY_INFLUXSTATS
	init_order = SS_INIT_INFLUXSTATS
	runlevels  = RUNLEVEL_GAME
	flags      = SS_KEEP_TIMING
	var/sent   = 0

/datum/controller/subsystem/influxstats/Initialize()
	var/period = CONFIG_GET(string/round_results_influxdb_period)
	if(isnum(period))
		wait = max(period * (1 SECONDS), 5 SECONDS)
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
	var/data = "round_time=[(ROUND_TIME)/(1 SECONDS)]"

	var/list/job_stats_others = list(JOB_OBSERVER = 0)

	var/list/job_stats_humans = list()
	for(var/job in (ROLES_MARINES|ROLES_USCM|ROLES_SPECIAL))
		job_stats_humans[job] = 0

	var/list/job_stats_xenos = list()
	for(var/job in ALL_XENO_CASTES)
		job_stats_xenos[job] = 0

	for(var/client/client in GLOB.clients)
		if(!client?.mob)
			continue
		else if(isobserver(client.mob))
			job_stats_others[JOB_OBSERVER] += 1
		else if(isxeno(client.mob))
			job_stats_xenos[client.mob.job] += 1
		else if(client?.mob && client.mob.stat != DEAD)
			job_stats_humans[client.mob.job] += 1

	var/datum/http_request/req
	var/list/measurements = list()

	var/others_data = data
	for(var/job in job_stats_others)
		var/short_job = replacetext(sanitize(job), " ", "")
		others_data += ",[short_job]=[job_stats_others[job]]"
	measurements += "[measurement],team=others [others_data] [timestamp]"

	var/humans_data = data
	for(var/job in job_stats_humans)
		var/short_job = replacetext(sanitize(job), " ", "")
		humans_data += ",[short_job]=[job_stats_humans[job]]"
	measurements += "[measurement],team=humans [humans_data] [timestamp]"

	var/xenos_data = data
	for(var/job in job_stats_xenos)
		var/short_job = replacetext(sanitize(job), " ", "")
		xenos_data += ",[short_job]=[job_stats_xenos[job]]"
	measurements += "[measurement],team=xenos [xenos_data] [timestamp]"

	req = new
	var/payload = ""
	for(var/line in measurements)
		payload += "[line]\n"
	req.prepare(RUSTG_HTTP_METHOD_POST, url, payload, headers)
	req.begin_async()
	sent++
