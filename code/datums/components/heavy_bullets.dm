/datum/component/heavy_buildup
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/heavy_shots = 1

/datum/component/heavy_buildup/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	apply_effects()
	addtimer(CALLBACK(src, PROC_REF(expire)), 2 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)

/datum/component/heavy_buildup/InheritComponent(datum/component/heavy_buildup/component_var, i_am_original)
	heavy_shots = min(heavy_shots + 1, 7)
	apply_effects()
	addtimer(CALLBACK(src, PROC_REF(expire)), 2 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)

/datum/component/heavy_buildup/proc/apply_effects()
	var/mob/living/target = parent
	target.Slow(1.5 + heavy_shots * 0.5)

	if(heavy_shots >= 2)
		target.KnockDown((heavy_shots - 1) * 0.25)
		target.Stun((heavy_shots - 1) * 0.25)

	if(heavy_shots >= 3)
		target.Superslow((heavy_shots - 1) * 0.5)

/datum/component/heavy_buildup/proc/expire()
	qdel(src)
