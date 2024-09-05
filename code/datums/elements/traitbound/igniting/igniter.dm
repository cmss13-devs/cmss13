/datum/element/traitbound/igniter
	compatible_types = list(/obj/item)
	associated_trait = TRAIT_IGNITER

	/// Proc to check whether ignition can happen
	VAR_PRIVATE/check_ignition_proc
	/// Message to send to user if ignition fails
	VAR_PRIVATE/failure_message

/datum/element/traitbound/igniter/Attach(obj/item/target)
	. = ..()
	if (. & ELEMENT_INCOMPATIBLE)
		return

	check_ignition_proc = TYPE_PROC_REF(/obj/item, _check_can_ignite)
	failure_message = target.get_igniter_failure_message()
	RegisterSignal(target, COMSIG_PARENT_AFTERATTACK, PROC_REF(try_ignite))

/datum/element/traitbound/igniter/proc/try_ignite(obj/item/igniter, atom/ignitable, mob/user)
	SIGNAL_HANDLER

	if (!call(igniter, check_ignition_proc)())
		if (failure_message)
			to_chat(user, failure_message)
		return
	SEND_SIGNAL(ignitable, COMSIG_ATOM_IGNITE, igniter, user)

/datum/element/traitbound/igniter/Detach(datum/source, force)
	UnregisterSignal(source, COMSIG_PARENT_AFTERATTACK)
	return ..()

/obj/item/proc/_check_can_ignite(self)
	return check_can_ignite()

/// Proc to overwrite when specifying how an atom checks whether it can ignition. Default is to always ignite.
/obj/item/proc/check_can_ignite()
	return TRUE

/obj/item/proc/get_igniter_failure_message()
	return
