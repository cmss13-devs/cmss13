/// Handles deferred click actions, to be scheduled on MC time
SUBSYSTEM_DEF(clicks)
	name = "Clicks"
	flags = SS_TICKER // Process every tick
	wait = 1
	priority = SS_PRIORITY_CLICKS
	init_order = SS_INIT_CLICKS

	/// Queued clicks for next tick: list(usr, target, location, params)
	var/list/list/clickqueue = list()
	/// Queued clicks to handle this tick
	var/list/list/currentrun

	// Stat counters
	var/stat = 0
	var/avg = 0

/datum/controller/subsystem/clicks/stat_entry(msg)
	msg = "Tick: [stat] | Avg: [copytext("[avg]", 1, 3)]"
	return ..()

/datum/controller/subsystem/clicks/fire(resumed)
	if(!resumed)
		currentrun = clickqueue
		clickqueue = list()
		stat = length(currentrun)
		var/lag = 10/world.tick_lag
		avg = ((lag-1)*avg + stat) / lag

	while(currentrun.len)
		var/list/clickdata = currentrun[currentrun.len]
		currentrun.len--
		usr = clickdata[1]
		var/atom/target = clickdata[2]
		var/atom/loc = clickdata[3]
		var/list/params = clickdata[4]
		usr.do_click(target, loc, params)
