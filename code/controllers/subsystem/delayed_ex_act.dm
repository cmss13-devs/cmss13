/// Handles ex_act calls to expensive things like mobs as defered actions to preserve game under high load
SUBSYSTEM_DEF(delayed_ex_act)
	name       = "Delayed Explosion Effects"
	priority   = SS_PRIORITY_DELAYED_EX_ACT // High prio but not SS_TICKER and shouldn't be used much
	wait       = 0.5 DECISECONDS
	flags      = SS_NO_INIT
	runlevels  = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/list/list/queued_work = list()
	var/list/list/current_work

/datum/controller/subsystem/delayed_ex_act/fire(resumed = FALSE)
	if(!resumed)
		current_work = queued_work.Copy()

	while(length(current_work))
		var/list/order = current_work[current_work.len]
		current_work.len--
		queued_work -= list(order)
		var/atom/target = order[1]
		var/list/arguments = order.Copy(2, 0)
		target.ex_act(arglist(arguments))

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/delayed_ex_act/proc/queue(atom/target, power, dir, datum/cause_data/cause_data, pierce = FALSE, enviro = FALSE)
	queued_work += list(list(target, power, dir, cause_data, pierce, enviro))
