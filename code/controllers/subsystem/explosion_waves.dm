SUBSYSTEM_DEF(explosion_waves)
	name     = "Explosion Waves"
	wait     = 1
	flags    = SS_TICKER | SS_NO_INIT
	priority = SS_PRIORITY_EXPLOSION_WAVES

	var/list/datum/explosion_wave/queued = list()
	var/list/datum/explosion_wave/currentrun

	/// List of synchronization checkpoints. An arbitrary tag, followed by the explosion_wave-s that existed at that time
	/// When all of these waves are gone, we fire a signal to let listeners know we've progressed past that state
	var/alist/checkpoints = alist()

/datum/controller/subsystem/explosion_waves/fire(resumed = FALSE)
	if(!resumed)
		currentrun = queued.Copy()

	while(length(currentrun))
		var/datum/explosion_wave/current = currentrun[currentrun.len]
		currentrun.len--
		var/ret = current?.process(wait * world.tick_lag)
		if(ret == PROCESS_KILL)
			queued -= current
		if(MC_TICK_CHECK)
			return

	for(var/name, checkpoint in checkpoints)
		if(!length(checkpoint & queued))
			checkpoints -= name
			SEND_GLOBAL_SIGNAL(COMSIG_SS_EXPLOSION_WAVES_CHECKPOINT_REACHED, name)

/datum/controller/subsystem/explosion_waves/proc/queue(datum/explosion_wave/item)
	queued += item

/datum/controller/subsystem/explosion_waves/proc/forget(datum/explosion_wave/item)
	queued -= item
	currentrun -= item

	for(var/name, contents in checkpoints)
		var/list/datum/explosion_wave/checkpoint_waves = contents
		contents -= item

/datum/controller/subsystem/explosion_waves/proc/set_checkpoint(name)
	checkpoints[name] = queued.Copy()

/// Waits until reaching said checkpoint. DON'T USE THIS PLEASE USE THE SIGNALS ABOVE
/datum/controller/subsystem/explosion_waves/proc/synchronize(name)
	if(isnull(name))
		var/static/notch = 1
		name = "_dynamic_checkpoint_[notch++]"
		set_checkpoint(name)
	else if(!(name in checkpoints))
		return TRUE
	UNTIL(!(name in checkpoints))
	return TRUE
