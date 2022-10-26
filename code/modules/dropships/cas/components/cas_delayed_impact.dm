/// Causes the projectile to impact after a given time
/datum/component/cas_delayed_impact
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	/// Time of flight before impact
	var/flight_time = 2 SECONDS

/datum/component/cas_delayed_impact/Initialize(flight_time)
	if(!istype(parent, /datum/cas_firing_solution))
		return COMPONENT_INCOMPATIBLE
	if(flight_time)
		src.flight_time = flight_time
	RegisterSignal(parent, COMSIG_CAS_SOLUTION_PROCESS, .proc/fly)

/datum/component/cas_delayed_impact/proc/fly(source, delta_time)
	SIGNAL_HANDLER
	flight_time -= delta_time * 10
	if(flight_time <= 0)
		qdel(src)
		return COMPONENT_CAS_SOLUTION_IMPACT

