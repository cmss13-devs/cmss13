var/datum/subsystem/inactivity/SSxenocon

/datum/subsystem/xenocon
	name = "XENOCON"
	wait = 5 SECONDS
	priority = SS_PRIORITY_INACTIVITY
	
	var/rewarded = FALSE

/datum/subsystem/xenocon/New()
	NEW_SS_GLOBAL(SSxenocon)

/datum/subsystem/xenocon/fire(resumed = FALSE)
	if(rewarded)
		return

	for(var/datum/hive_status/hive in hive_datum)
		if(hive.xenocon_points >= XENOCON_THRESHOLD)
			ticker.mode.picked_call = new /datum/emergency_call/xenos()
			ticker.mode.picked_call.activate()
			rewarded = TRUE