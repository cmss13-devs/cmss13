/datum/element/xeno_pounce_unhide
	element_flags = ELEMENT_DETACH

/datum/element/xeno_pounce_unhide/Attach(datum/target)
	. = ..()
	if(!isxeno(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_XENO_POUNCE_HIDE, PROC_REF(pounce_toggle))

/datum/element/xeno_pounce_unhide/Detach(datum/source, force)
	UnregisterSignal(source, list(
		COMSIG_XENO_POUNCE_HIDE
	))
	return ..()

/datum/element/xeno_pounce_unhide/proc/pounce_toggle(mob/living/carbon/xenomorph/xeno)
	SIGNAL_HANDLER
	for(var/datum/action/a in xeno.actions)
		a.update_button_icon(xeno)

