/datum/element/magharness
	element_flags = ELEMENT_DETACH

/datum/element/magharness/Attach(datum/target)
	. = ..()
	if(!istype(target, /obj/item/weapon/gun))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_MOVABLE_PRE_THROW, .proc/cancel_throw)
	RegisterSignal(target, COMSIG_ITEM_DROPPED, .proc/dropped)

/datum/element/magharness/Detach(datum/source, force)
	UnregisterSignal(source, list(
		COMSIG_MOVABLE_PRE_THROW,
		COMSIG_ITEM_DROPPED,
	))
	return ..()

/datum/element/magharness/proc/cancel_throw(datum/source, mob/thrower)
	SIGNAL_HANDLER
	if(thrower)
		to_chat(thrower, SPAN_WARNING("\The [source] clanks on the ground."))
	return COMPONENT_CANCEL_THROW

/datum/element/magharness/proc/dropped(obj/item/weapon/gun/G, mob/user)
	SIGNAL_HANDLER
	G.handle_harness(user)
