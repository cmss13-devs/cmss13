/datum/element/traitbound/igniter
	compatible_types = list(/obj/item)
	associated_trait = TRAIT_IGNITER

/datum/element/traitbound/igniter/Attach(obj/item/target)
	. = ..()
	if (. & ELEMENT_INCOMPATIBLE)
		return

	RegisterSignal(target, COMSIG_PARENT_AFTERATTACK, PROC_REF(try_ignite))

/datum/element/traitbound/igniter/proc/try_ignite(obj/item/igniter, atom/ignitable, mob/user)
	SIGNAL_HANDLER

	if (!igniter.check_can_ignite())
		var/failure_message = igniter.get_igniter_failure_message()
		if (failure_message)
			to_chat(user, failure_message)
		return
	SEND_SIGNAL(ignitable, COMSIG_ATOM_IGNITE, igniter, user)

/datum/element/traitbound/igniter/Detach(datum/source, force)
	UnregisterSignal(source, COMSIG_PARENT_AFTERATTACK)
	return ..()

/// Proc to overwrite when specifying how an atom checks whether it can ignition. Default is to always ignite.
/obj/item/proc/check_can_ignite()
	return TRUE

/obj/item/proc/get_igniter_failure_message()
	return
