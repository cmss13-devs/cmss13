
SUBSYSTEM_DEF(explosions)
	name  = "Explosions"
	wait  = 0.5 SECONDS
	priority = SS_PRIORITY_EXPLOSIONS
	flags = SS_NO_INIT

	var/list/exploded_articles = list()
	var/list/currentrun = list()

/datum/controller/subsystem/explosions/stat_entry(msg)
	msg = "C: [length(exploded_articles)]"
	return ..()

/datum/controller/subsystem/explosions/proc/queued_ex_act(exploded_article, power, direction, explosion_cause_data)
	exploded_articles.Insert(1, list(list(
		"exploded_article" = WEAKREF(exploded_article),
		"power" = power,
		"direction" = direction,
		"explosion_cause_data" = explosion_cause_data
	)))

/datum/controller/subsystem/explosions/fire(resumed = FALSE)
	if(!resumed)
		currentrun = exploded_articles.Copy()
		exploded_articles.Cut()

	while(length(currentrun))
		var/list/ex_args = currentrun[length(currentrun)]
		currentrun.len--

		var/datum/weakref/exploded_ref = ex_args["exploded_article"]

		if (!exploded_ref || QDELETED(exploded_ref))
			continue

		var/atom/exploded_article = exploded_ref.resolve()

		if (!exploded_article || QDELETED(exploded_article))
			continue

		exploded_article.ex_act(ex_args["power"], ex_args["direction"], ex_args["explosion_cause_data"])

		if (MC_TICK_CHECK)
			return
