///water_overlay component. adds and removes
/datum/component/water_overlay
	dupe_mode = COMPONENT_DUPE_HIGHLANDER //pepega-moment what does this do?
	var/datum/effects/water_overlay/my_water_overlay

/datum/component/water_overlay/Initialize()
	if(!istype(parent, /atom/movable))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, list(COMSIG_UPDATE_MOB_EFFECTS_FROM_TURF), .proc/update_water_effects)

/datum/component/water_overlay/proc/update_water_effects(var/atom/movable/AM, turf/open/O, entered)
	SIGNAL_HANDLER
	if(entered)
		if(!my_water_overlay)
			my_water_overlay = new /datum/effects/water_overlay(AM, O)
	else
		my_water_overlay = qdel(my_water_overlay)
