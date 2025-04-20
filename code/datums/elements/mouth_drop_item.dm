/datum/element/mouth_drop_item
	element_flags = ELEMENT_DETACH

/datum/element/mouth_drop_item/Attach(datum/target)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_ITEM_EQUIPPED, PROC_REF(item_equipped))
	RegisterSignal(target, COMSIG_ITEM_DROPPED, PROC_REF(item_dropped))

/datum/element/mouth_drop_item/Detach(datum/source, force)
	UnregisterSignal(source, list(
		COMSIG_ITEM_EQUIPPED,
		COMSIG_ITEM_DROPPED
	))
	return ..()

/datum/element/mouth_drop_item/proc/item_equipped(obj/item/I, mob/living/carbon/human/user, slot)
	SIGNAL_HANDLER

	if(slot == WEAR_FACE && !HAS_TRAIT(user, TRAIT_IRON_TEETH))
		I.RegisterSignal(user, COMSIG_LIVING_SET_BODY_POSITION, TYPE_PROC_REF(/obj/item, drop_to_floor))

/datum/element/mouth_drop_item/proc/item_dropped(obj/item/I, mob/living/carbon/human/user)
	SIGNAL_HANDLER

	I.UnregisterSignal(user, COMSIG_LIVING_SET_BODY_POSITION)
