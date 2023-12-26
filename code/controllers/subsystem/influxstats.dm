/// Sends generic round running statistics to the InfluxDB backend
SUBSYSTEM_DEF(influxstats)
	name       = "InfluxDB Game Stats"
	wait       = 60 SECONDS
	priority   = SS_PRIORITY_INFLUXSTATS
	init_order = SS_INIT_INFLUXSTATS
	runlevels  = RUNLEVEL_LOBBY|RUNLEVELS_DEFAULT
	flags      = SS_KEEP_TIMING

	var/checkpoint = 0 //! Counter of data snapshots sent
	var/step = 1 //! Current task in progress, for pausing/resuming

/datum/controller/subsystem/influxstats/Initialize()
	var/period = text2num(CONFIG_GET(number/influxdb_stats_period))
	if(isnum(period))
		wait = max(period * (1 SECONDS), 10 SECONDS)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/influxstats/stat_entry(msg)
	msg += "period=[wait] checkpoint=[checkpoint] step=[step]"
	return ..()

/datum/controller/subsystem/influxstats/fire(resumed)
	if(!SSinfluxdriver.can_fire)
		can_fire = FALSE
		return

	checkpoint++
	while(step < 5) // Yes, you could make one SS per stats category, and have proper scheduling and variable periods,  but...
		switch(step++)
			if(1) // Connected players statistics
				run_player_statistics()
			if(2) // Job occupations
				if(SSticker.current_state == GAME_STATE_PLAYING)
					run_job_statistics()
			if(3) // Round-wide gameplay statistics held in entity
				if(SSticker.current_state == GAME_STATE_PLAYING)
					run_round_statistics()
			if(4) // Handpicked Round-wide gameplay statistics
				if(SSticker.current_state == GAME_STATE_PLAYING)
					run_special_round_statistics()
		if(MC_TICK_CHECK)
			return

	step = 1

/datum/controller/subsystem/influxstats/proc/flatten_entity_list(list/data)
	var/list/result = list()
	for(var/key in data)
		var/datum/entity/statistic/entry = data[key]
		result[key] = entry.value
	return result

/datum/controller/subsystem/influxstats/proc/run_special_round_statistics()
	for(var/hive_tag in GLOB.hive_datum)
		var/datum/hive_status/hive = GLOB.hive_datum[hive_tag]
		SSinfluxdriver.enqueue_stats("pooled_larva", list("hive" = hive.reporting_id), list("count" = hive.stored_larva))
		var/burst_larvas = GLOB.larva_burst_by_hive[hive] || 0
		SSinfluxdriver.enqueue_stats("burst_larva", list("hive" = hive.reporting_id), list("count" = burst_larvas))

/datum/controller/subsystem/influxstats/proc/run_round_statistics()
	var/datum/entity/statistic/round/stats = SSticker?.mode?.round_stats
	if(!stats)
		return // Sadge

	SSinfluxdriver.enqueue_stats_crude("chestbursts", stats.total_larva_burst)
	SSinfluxdriver.enqueue_stats_crude("hugged", stats.total_huggers_applied)
	SSinfluxdriver.enqueue_stats_crude("friendlyfire", stats.total_friendly_fire_instances)

	var/list/participants = flatten_entity_list(stats.participants)
	if(length(participants))
		SSinfluxdriver.enqueue_stats("participants", list(), participants)

	var/list/total_deaths = flatten_entity_list(stats.total_deaths)
	if(length(total_deaths))
		SSinfluxdriver.enqueue_stats("deaths", list(), total_deaths)

	SSinfluxdriver.enqueue_stats("shots", list(),
		list("fired" = stats.total_projectiles_fired, "hits" = stats.total_projectiles_hit,
		"hits_human" = stats.total_projectiles_hit_human, "hits_xeno" = stats.total_projectiles_hit_xeno)
	)

/datum/controller/subsystem/influxstats/proc/run_player_statistics()
	var/staff_count = 0
	var/mentor_count = 0
	for(var/client/client in GLOB.admins)
		if(CLIENT_IS_STAFF(client))
			staff_count++
		else if(CLIENT_HAS_RIGHTS(client, R_MENTOR))
			mentor_count++
	SSinfluxdriver.enqueue_stats("online", null, list("count" = length(GLOB.clients)))

	var/list/adm = get_admin_counts()
	var/present_admins = length(adm["present"])
	var/afk_admins = length(adm["afk"])
	SSinfluxdriver.enqueue_stats("online_staff", null, list("total" = staff_count, "mentors" = mentor_count, "present" = present_admins, "afk" = afk_admins))

	// Grab ahelp stats
	SSinfluxdriver.enqueue_stats("tickets", null, list(
		"open" = length(GLOB.ahelp_tickets.active_tickets),
		"closed" = length(GLOB.ahelp_tickets.closed_tickets),
		"resolved" = length(GLOB.ahelp_tickets.resolved_tickets),
	))

/datum/controller/subsystem/influxstats/proc/run_job_statistics()
	var/list/team_job_stats = list()
	var/list/squad_job_stats = GLOB.ROLES_SQUAD_ALL.Copy()
	for(var/squad in squad_job_stats)
		squad_job_stats[squad] = list()

	for(var/client/client in GLOB.clients)
		var/team
		var/mob/mob = client.mob
		if(!mob || mob.statistic_exempt)
			continue
		var/area/area = get_area(mob)
		if(!area || area.statistic_exempt)
			continue
		var/job = mob.job
		if(isobserver(mob) || mob.stat == DEAD)
			job = JOB_OBSERVER
			team = "observers"
		else if(!job)
			continue
		else if(mob.faction == FACTION_MARINE || mob.faction == FACTION_SURVIVOR)
			team = "humans"
			var/mob/living/carbon/human/employed_human = mob
			if(istype(employed_human))
				var/squad = employed_human.assigned_squad?.name
				if(squad in squad_job_stats)
					squad_job_stats[squad][job] = (squad_job_stats[squad][job] || 0) + 1
					continue // Defer to squad stats instead
			// else: So you're in the USCM and have a job but aren't an human? Tell me more Dr Jones...
		else if(ishuman(mob))
			team = "humans_others"
		else if(isxeno(mob))
			var/mob/living/xeno_enabled_mob = mob
			var/datum/hive_status/hive = GLOB.hive_datum[xeno_enabled_mob.hivenumber]
			if(!hive)
				team = "xenos_others"
			else
				team = "xenos_[hive.reporting_id]"
		else
			team = "others"
		LAZYINITLIST(team_job_stats[team])
		if(!team_job_stats[team][job])
			team_job_stats[team][job] = 0
		team_job_stats[team][job] += 1

	for(var/team in team_job_stats)
		for(var/job in team_job_stats[team])
			SSinfluxdriver.enqueue_stats("job_stats", list("team" = team, "job" = job), list("count" = team_job_stats[team][job]))

	for(var/squad in squad_job_stats)
		for(var/job in squad_job_stats[squad])
			SSinfluxdriver.enqueue_stats("job_stats", list("team" = "humans", "job" = job, "squad" = squad), list("count" = squad_job_stats[squad][job]))
