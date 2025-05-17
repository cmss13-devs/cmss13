/**
 * A component that should be on all fob machinery to make sure it turns on and off as the transformer is broken or repaired
 */
/datum/component/fob_defense
	var/datum/callback/on_callback
	var/datum/callback/off_callback

/datum/component/fob_defense/Initialize(datum/callback/on_callback, datum/callback/off_callback)
	src.on_callback = on_callback
	src.off_callback = off_callback

/datum/component/fob_defense/RegisterWithParent()
	RegisterSignal(SSdcs, COMSIG_GLOB_TRASNFORMER_ON, PROC_REF(invoke_on_callback))
	RegisterSignal(SSdcs, COMSIG_GLOB_TRASNFORMER_OFF, PROC_REF(invoke_off_callback))

/datum/component/fob_defense/proc/invoke_on_callback()
	SIGNAL_HANDLER
	on_callback.InvokeAsync()

/datum/component/fob_defense/proc/invoke_off_callback()
	SIGNAL_HANDLER

	off_callback.InvokeAsync()

/datum/component/fob_defense/UnregisterFromParent()
	UnregisterSignal(src, list(COMSIG_GLOB_TRASNFORMER_ON, COMSIG_GLOB_TRASNFORMER_OFF))
