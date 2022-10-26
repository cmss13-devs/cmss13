
/**
 * Ordnance effect
 * This is the main gameplay effect component, for example an explosion
 */
/datum/cas_effect/ordnance
	var/atom/target
	var/mob/source_mob
	var/dir

/datum/cas_effect/ordnance/Destroy()
	. = ..()
	target = null
	source_mob = null

/datum/cas_effect/ordnance/proc/arm(datum/cas_firing_solution/FS)
	dir = FS.dir
	target = FS.target
	source_mob = FS.source_mob
	name = FS.name
