/// Impacts roof when going terminal if applicable
/datum/component/cas_roof_impact
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	/// Minimum roof level to block firing
	var/threshold

/datum/component/cas_roof_impact/Initialize(threshold = CEILING_PROTECTION_TIER_3)
	if(!istype(parent, /datum/cas_firing_solution))
		return COMPONENT_INCOMPATIBLE
	src.threshold = threshold
	RegisterSignal(parent, COMSIG_CAS_SOLUTION_TERMINAL, .proc/pre_impact)

/datum/component/cas_roof_impact/proc/pre_impact(source, atom/target)
	SIGNAL_HANDLER
	var/turf/turf = get_turf(target)
	var/area/area = get_area(turf)
	turf.ceiling_debris_check(3)
	if(area && CEILING_IS_PROTECTED(area.ceiling, threshold))
		return COMPONENT_CAS_SOLUTION_MISS
