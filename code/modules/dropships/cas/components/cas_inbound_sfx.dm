/// Causes the projectile to play a sound file at the current impact location
/datum/component/cas_inbound_sfx
	dupe_mode = COMPONENT_DUPE_ALLOWED
	/// Sound file to play
	var/sfx_file
	/// Volume
	var/vol
	/// Time after which to play
	var/time_left

/datum/component/cas_inbound_sfx/Initialize(time_to_play = 2 SECONDS, sfx_file, vol = 100)
	if(!istype(parent, /datum/cas_firing_solution))
		return COMPONENT_INCOMPATIBLE
	if(time_to_play)
		src.time_left = time_to_play
	src.sfx_file = sfx_file
	src.vol = vol
	RegisterSignal(parent, COMSIG_CAS_SOLUTION_PROCESS, .proc/fly)

/datum/component/cas_inbound_sfx/proc/fly(source, delta_time)
	SIGNAL_HANDLER
	var/datum/cas_firing_solution/P = parent
	time_left -= delta_time * 10
	if(time_left <= 0)
		playsound(P.target, sfx_file, vol, FALSE, 32)
		qdel(src)
