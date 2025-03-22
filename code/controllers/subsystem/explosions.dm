
SUBSYSTEM_DEF(explosions)
	name  = "Explosions"
	wait  = 0.05 SECONDS
	priority = SS_PRIORITY_EXPLOSIONS
	flags = SS_NO_INIT

	var/list/exploded_turfs = list()
	var/list/currentrun = list()

/datum/controller/subsystem/explosions/stat_entry(msg)
	msg = "C: [length(exploded_turfs)]"
	return ..()

/datum/controller/subsystem/explosions/proc/turf_ex_act(turf, power, direction, explosion_cause_data)
	exploded_turfs.Insert(1, list(list(
		"exploded_turf" = turf,
		"power" = power,
		"direction" = direction,
		"explosion_cause_data" = explosion_cause_data
	)))

/datum/controller/subsystem/explosions/proc/is_exploding()
	if(length(SSexplosions.currentrun) || length(SSexplosions.exploded_turfs))
		return TRUE
	return FALSE

/datum/controller/subsystem/explosions/fire(resumed = FALSE)
	if(!resumed)
		currentrun = exploded_turfs.Copy()
		exploded_turfs.Cut()

	while(length(currentrun))
		var/list/ex_args = currentrun[length(currentrun)]
		currentrun.len--

		var/turf/exploded_turf = ex_args["exploded_turf"]

		if (!exploded_turf || QDELETED(exploded_turf))
			continue

		exploded_turf.ex_act(ex_args["power"], ex_args["direction"], ex_args["explosion_cause_data"])
		for(var/atom/exploded_article in exploded_turf)
			if(!exploded_article || QDELETED(exploded_article))
				continue
			exploded_article.ex_act(ex_args["power"], ex_args["direction"], ex_args["explosion_cause_data"])

		if (MC_TICK_CHECK)
			return
