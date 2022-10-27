/datum/component/cas_laser_guidance
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	/// Maximum possible deviation
	var/ammo_max_inaccuracy
	/// Inaccuracy (in turf range) gained by second without laser guidance
	var/inaccuracy_increment
	/// Effective accuracy
	var/ammo_accuracy_range

/datum/component/cas_laser_guidance/Initialize(ammo_max_inaccuracy = 5, ammo_accuracy_range = 2, inaccuracy_increment = 1)
	if(!istype(parent, /datum/cas_firing_solution))
		return COMPONENT_INCOMPATIBLE
	src.ammo_max_inaccuracy = ammo_max_inaccuracy
	src.inaccuracy_increment = inaccuracy_increment
	src.ammo_accuracy_range = ammo_accuracy_range
	RegisterSignal(parent, COMSIG_CAS_SOLUTION_PROCESS, .proc/fly)
	RegisterSignal(parent, COMSIG_CAS_SOLUTION_TERMINAL, .proc/retarget)
	RegisterSignal(parent, COMSIG_CAS_SOLUTION_RETARGET, .proc/fallback)
	RegisterSignal(parent, list(
		COMSIG_CAS_SOLUTION_IMPACT,
		COMSIG_CAS_SOLUTION_INTERCEPTED,
		COMSIG_CAS_SOLUTION_MISSED), .proc/disable)

/datum/component/cas_laser_guidance/proc/fly(source, delta_time)
	SIGNAL_HANDLER
	var/datum/cas_firing_solution/P = parent
	if(!P.signal_target.signal_loc.loc)
		ammo_accuracy_range += (delta_time * inaccuracy_increment)

/datum/component/cas_laser_guidance/proc/retarget(source, atom/target)
	SIGNAL_HANDLER
	var/datum/cas_firing_solution/P = parent
	ammo_accuracy_range = Clamp(ammo_accuracy_range, 0, ammo_max_inaccuracy)
	var/turf/T = get_turf(target)
	var/list/turf/turf_list = RANGE_TURFS(ammo_accuracy_range, T)
	var/turf/new_target = pick(turf_list)
	P.retarget(new_target)

/datum/component/cas_laser_guidance/proc/disable(source, atom/target)
	SIGNAL_HANDLER
	qdel(src)

/datum/component/cas_laser_guidance/proc/fallback(source, atom/old_target)
	SIGNAL_HANDLER
	var/datum/cas_firing_solution/P = parent
	P.retarget(get_turf(old_target))
