/// Sets an effect to delete itself after a specific amount of time
/datum/element/temporary

/datum/element/temporary/Attach(datum/target, duration)
	. = ..()
	if (. == ELEMENT_INCOMPATIBLE)
		return
	if (!istype(target, /obj/effect))
		return ELEMENT_INCOMPATIBLE
	addtimer(CALLBACK(src, PROC_REF(delete_effect), WEAKREF(target)), duration)

/datum/element/temporary/proc/delete_effect(datum/weakref/target_ref)
	SIGNAL_HANDLER
	if (target_ref.resolve())
		qdel(target_ref)
