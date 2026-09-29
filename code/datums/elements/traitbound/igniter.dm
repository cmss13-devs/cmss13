/datum/element/traitbound/igniter
	compatible_types = list(/obj/item)
	associated_trait = TRAIT_IGNITER

/datum/element/traitbound/igniter/Attach(obj/item/target)
	. = ..()
	if (. & ELEMENT_INCOMPATIBLE)
		return

	RegisterSignal(target, COMSIG_PARENT_AFTERATTACK, PROC_REF(on_afterattack))
	RegisterSignal(target, COMSIG_ITEM_ATTACK, PROC_REF(on_attack))

/datum/element/traitbound/igniter/proc/on_attack(obj/item/igniter, mob/living/user, mob/living/target)
	SIGNAL_HANDLER

	if(isnull(target.wear_mask) || user.zone_selected != "mouth")
		return
	var/flavor_text = text_dynamic_insertion_custom(
		igniter.get_ignite_in_mouth_flavor_text(),
		list("igniter", "user", "target", "ignitable"),
		igniter, user, target, target.wear_mask,
	)
	try_ignite(igniter, target.wear_mask, user, flavor_text)
	return COMPONENT_CANCEL_ATTACK

/datum/element/traitbound/igniter/proc/on_afterattack(obj/item/igniter, atom/ignitable, mob/user, click_parameters)
	SIGNAL_HANDLER
	try_ignite(igniter, ignitable, user)

/datum/element/traitbound/igniter/proc/try_ignite(obj/item/igniter, atom/ignitable, mob/user, flavor_text)
	if (!isnull(flavor_text) && !istext(flavor_text))
		CRASH("try_ignite received non-null, non-text flavor_text argument")
	if (!igniter.check_can_ignite())
		var/failure_message = igniter.get_igniter_failure_message()
		if (failure_message)
			to_chat(user, failure_message)
		return
	SEND_SIGNAL(ignitable, COMSIG_ATOM_IGNITE, igniter, user, flavor_text)

/datum/element/traitbound/igniter/Detach(datum/source, force)
	UnregisterSignal(source, COMSIG_PARENT_AFTERATTACK)
	return ..()

/// Proc to override when specifying how an atom checks whether it can ignition. Default is to always ignite.
/obj/item/proc/check_can_ignite()
	return TRUE

/// Proc to override if we want flavor text for why igniting something failed. Default is that there is no flavor text.
/obj/item/proc/get_igniter_failure_message()
	return

/// Proc to override when specifying flavor text when igniting something in another mob's mouth
/obj/item/proc/get_ignite_in_mouth_flavor_text()
	RETURN_TYPE(/datum/text_dynamic_insertion_constants)
	return
