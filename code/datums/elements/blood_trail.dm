/datum/element/blood_trail
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 2
	/// Color of the tracks left behind
	var/color

/datum/element/blood_trail/Attach(datum/target, bcolor)
	. = ..()
	if(!iscarbon(target))
		return ELEMENT_INCOMPATIBLE

	color = bcolor

	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(target, COMSIG_XENO_REVIVED_FROM_CRIT, PROC_REF(clear_trail))

/datum/element/blood_trail/Detach(datum/target, force)
	UnregisterSignal(target, list(
		COMSIG_MOVABLE_MOVED,
		COMSIG_XENO_REVIVED_FROM_CRIT
	))

	return ..()

/datum/element/blood_trail/proc/on_moved(mob/living/carbon/target, oldLoc, direction)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(add_tracks), target, oldLoc, direction)

/datum/element/blood_trail/proc/add_tracks(mob/living/carbon/target, oldLoc, direction)
	if(GLOB.perf_flags & PERF_TOGGLE_NOBLOODPRINTS)
		Detach(target)
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
