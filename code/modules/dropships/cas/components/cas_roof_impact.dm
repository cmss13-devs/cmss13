/// Impacts roof when going terminal if applicable
/datum/component/cas_roof_impact
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	/// Minimum roof level to block firing
	var/threshold = CEILING_PROTECTION_TIER_3
	/// Effect to play if hitting roof
	var/datum/cas_effect/splash

/datum/component/cas_roof_impact/Initialize(threshold, datum/cas_effect/splash)
	if(!istype(parent, /datum/cas_firing_solution))
		return COMPONENT_INCOMPATIBLE
	src.threshold = threshold
	src.splash = splash
	RegisterSignal(parent, COMSIG_CAS_SOLUTION_TERMINAL, .proc/pre_impact)

/datum/component/cas_roof_impact/proc/pre_impact(source, atom/target)
	SIGNAL_HANDLER
	var/turf/turf = get_turf(target)
	var/area/area = get_area(turf)
	if(area && CEILING_IS_PROTECTED(area.ceiling, threshold))
		. = COMPONENT_CAS_SOLUTION_MISS
		splash?.fire()
