/datum/component/cas_simple_guidance
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	/// Maximum possible deviation
	var/ammo_max_inaccuracy
	/// Effective accuracy
	var/ammo_accuracy_range

/datum/component/cas_simple_guidance/Initialize(ammo_max_inaccuracy = 5, ammo_accuracy_range = 2)
	if(!istype(parent, /datum/cas_firing_solution))
		return COMPONENT_INCOMPATIBLE
	src.ammo_max_inaccuracy = ammo_max_inaccuracy
	src.ammo_accuracy_range = ammo_accuracy_range
	RegisterSignal(parent, COMSIG_CAS_SOLUTION_TERMINAL, .proc/retarget)

/datum/component/cas_simple_guidance/proc/retarget(source, atom/target)
	SIGNAL_HANDLER
	var/datum/cas_firing_solution/P = parent
	ammo_accuracy_range = Clamp(ammo_accuracy_range, 0, ammo_max_inaccuracy)
	var/turf/T = get_turf(target)
	var/list/turf/turf_list = RANGE_TURFS(ammo_accuracy_range, T)
	var/turf/new_target = pick(turf_list)
	P.retarget(new_target)
