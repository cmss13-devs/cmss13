/datum/component/cas_warhead_incendiary
	var/fire_range
	var/fire_power
	var/fire_burn
	var/fire_color

/datum/component/cas_warhead_incendiary/Initialize(fire_range = 6, fire_power = 60, fire_burn = 30, fire_color)
	src.fire_range = fire_range
	src.fire_power = fire_power
	src.fire_burn = fire_burn
	src.fire_color = fire_color
	RegisterSignal(parent, COMSIG_CAS_SOLUTION_IMPACT, .proc/boom)

/datum/component/cas_warhead_incendiary/proc/boom(source, atom/target)
	SIGNAL_HANDLER
	var/datum/cas_firing_solution/P = parent
	var/turf/target_turf = get_turf(target)
	fire_spread(target_turf, create_cause_data(initial(P.name), P.source_mob), fire_range, fire_power, fire_burn, fire_color)
	qdel(src)
