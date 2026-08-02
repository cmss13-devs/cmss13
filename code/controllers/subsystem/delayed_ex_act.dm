/// Handles ex_act calls to expensive things like mobs as defered actions to preserve game under high load
SUBSYSTEM_DEF(delayed_ex_act)
	name       = "Delayed Explosion Effects"
	priority   = SS_PRIORITY_DELAYED_EX_ACT // High prio but not SS_TICKER and shouldn't be used much
	wait       = 0.5 DECISECONDS
	flags      = SS_NO_INIT
	runlevels  = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/list/list/queued_work = list()
	var/list/list/current_work

	/// If true, callers are encouraged to defer everything to SSdelayed_ex_act for the time being.
	/// We use this so explosions during hijack crash can be processed quickly and avoid clipping into the
	/// landing dropship and gib xenos. It's less performant, and it will certainly look stupid,
	/// but it's better than the alternative. TESTING FOR NOW!!!
	var/defer_everything = FALSE

/datum/controller/subsystem/delayed_ex_act/fire(resumed = FALSE)
	if(!resumed)
		current_work = queued_work.Copy()
		queued_work = list()

	while(length(current_work))
		var/list/order = current_work[current_work.len]
		current_work.len--
		var/atom/target = order[1]
		if(!QDELETED(target)) // Very neccessary here
			var/list/arguments = order.Copy(2, 0)
			if(isliving(target) && length(arguments) >= 3)
				var/datum/cause_data/cause_data = arguments[3]
				log_explosion(target, cause_data)
			target.ex_act(arglist(arguments))

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/delayed_ex_act/proc/queue(atom/target, power, dir, datum/cause_data/cause_data, pierce = FALSE, enviro = FALSE)
	queued_work += list(list(target, power, dir, cause_data, pierce, enviro))
