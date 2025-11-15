/datum/element/blood_trail
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 2
	/// Color of the tracks left behind
	var/color
	/// Necessary because of how Crossed is called before Moved, from bloody_feet.dm
	var/list/entered_bloody_turf

/datum/element/blood_trail/Attach(datum/target, bcolor)
	. = ..()
	if(!iscarbon(target))
		return ELEMENT_INCOMPATIBLE

	color = bcolor
	LAZYADD(entered_bloody_turf, target)

	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(target, COMSIG_XENO_REVIVED_FROM_CRIT, PROC_REF(clear_trail))
	RegisterSignal(target, COMSIG_MOB_STAT_SET_DEAD, PROC_REF(clear_trail))

/datum/element/blood_trail/Detach(datum/target, force)
	UnregisterSignal(target, list(
		COMSIG_MOVABLE_MOVED,
		COMSIG_XENO_REVIVED_FROM_CRIT,
		COMSIG_MOB_STAT_SET_DEAD
	))
	LAZYREMOVE(entered_bloody_turf, target)
	return ..()

/datum/element/blood_trail/proc/on_moved(mob/living/carbon/target, oldLoc, direction)
	SIGNAL_HANDLER
	if(HAS_TRAIT(target, TRAIT_HAULED) || HAS_TRAIT(target, TRAIT_CARRIED)  || HAS_TRAIT_FROM(target,  TRAIT_IMMOBILIZED, BUCKLED_TRAIT))
		return
	INVOKE_ASYNC(src, PROC_REF(add_tracks), target, oldLoc, direction)

/datum/element/blood_trail/proc/add_tracks(mob/living/carbon/target, oldLoc, direction)
	if(GLOB.perf_flags & PERF_TOGGLE_NOBLOODPRINTS)
		Detach(target)
		return

	if(prob(15)) // dont want to leave a trail everytime
		return

	// FIXME: This shit is silly and Entered should be refactored
	if(LAZYISIN(entered_bloody_turf, target))
		LAZYREMOVE(entered_bloody_turf, target)
		return

	var/turf/T_in = target.loc
	var/turf/T_out = oldLoc

	if(istype(T_in))
		var/obj/effect/decal/cleanable/blood/tracks/FP = LAZYACCESS(T_in.cleanables, CLEANABLE_TRACKS)
		if(FP)
			if(!LAZYACCESS(FP.steps_in, "[direction]"))
				FP.add_tracks(direction, color, FALSE)
		else
			FP = new /obj/effect/decal/cleanable/blood/tracks/dragged(T_in)
			FP.add_tracks(direction, color, FALSE)

	if(istype(T_out))
		var/obj/effect/decal/cleanable/blood/tracks/FP = LAZYACCESS(T_out.cleanables, CLEANABLE_TRACKS)
		if(FP)
			if(!LAZYACCESS(FP.steps_out, "[direction]"))
				FP.add_tracks(direction, color, TRUE)
		else
			FP = new /obj/effect/decal/cleanable/blood/tracks/dragged(T_out)
			FP.add_tracks(direction, color, TRUE)

/datum/element/blood_trail/proc/clear_trail(mob/living/carbon/target)
	SIGNAL_HANDLER
	Detach(target)
