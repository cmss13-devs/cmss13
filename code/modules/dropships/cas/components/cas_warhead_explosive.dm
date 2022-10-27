/datum/component/cas_warhead_explosive
	var/exp_power
	var/exp_falloff
	var/exp_falloff_type

/datum/component/cas_warhead_explosive/Initialize(exp_power = 300, exp_falloff = 40, exp_falloff_type = EXPLOSION_FALLOFF_SHAPE_LINEAR)
	src.exp_power = exp_power
	src.exp_falloff = exp_falloff
	src.exp_falloff_type = exp_falloff_type
	RegisterSignal(parent, COMSIG_CAS_SOLUTION_IMPACT, .proc/boom)

/datum/component/cas_warhead_explosive/proc/boom(source, atom/target)
	SIGNAL_HANDLER
	var/datum/cas_firing_solution/P = parent
	var/turf/target_turf = get_turf(target)
	INVOKE_ASYNC(GLOBAL_PROC, /proc/cell_explosion, target_turf, exp_power, exp_falloff, exp_falloff_type, null, create_cause_data(P.name, P.source_mob))
	qdel(src)
