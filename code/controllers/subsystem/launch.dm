/// Subsystem to handled scheduling of the processing of all thrown items
SUBSYSTEM_DEF(launch)
	name       =  "Launch/Throws"
	flags      =  SS_TICKER | SS_NO_INIT
	wait       =  2 // Every 2 ticks, so 0.1s
	priority   =  SS_PRIORITY_LAUNCH
	runlevels   = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	/// All launch metadata queued for throwing right now, mapped to elapsed ticks since last process. It's here not in LM, no cheating.
	var/list/datum/launch_metadata/queued_launches = list()
	/// List of /datum/launch_metadata we'll handle this tick
	var/list/datum/launch_metadata/working_launches

/datum/controller/subsystem/launch/fire(resumed = FALSE)
	if(!resumed)
		working_launches = queued_launches.Copy()
	for(var/datum/launch_metadata/LM, carry in working_launches)
		working_launches -= LM
		carry += world.tick_lag * wait
		if(!LM?.thrown)
			cancel_throw(LM)
			qdel(LM) // Hard reset
			continue
		if(carry >= LM.delay)
			carry -= LM.delay
			if(!LM.thrown.tick_throw(LM))
				cancel_throw(LM)
				LM?.thrown?.reset_throw() // Stop the throw. Might be legit.
				continue
		if(!isnull(queued_launches[LM])) // Just in case sideeffects stopped the throw...
			queued_launches[LM] = carry // Requeue with incremented value

/// Start a throw for the given atom
/datum/controller/subsystem/launch/proc/launch(datum/launch_metadata/LM)
	if(QDELETED(LM?.thrown))
		return // Pains me to have to write this, but read the comment just below.
	// Most of the prep logic is in /atom procs, but we still handle the ones relevant to our scheduling here
	// Recalc the speed. Trust no-one with how this code is used.
	LM.speed = clamp(LM.speed, MIN_SPEED, MAX_SPEED)
	LM.delay = 10 / LM.speed - 0.5
	// We clamp it additionally to our own run rate
	LM.delay = max(LM.delay, wait * world.tick_lag)
	queued_launches[LM] = 0
	return TRUE

/// Cancel the throw at subsystem level. No funny effects, we snap it.
/datum/controller/subsystem/launch/proc/cancel_throw(datum/launch_metadata/LM)
	queued_launches  -= LM
	working_launches -= LM
