/datum/element/mouth_drop_item
	element_flags = ELEMENT_DETACH

/datum/element/mouth_drop_item/Attach(datum/target)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_ITEM_EQUIPPED, .proc/item_equipped)
	RegisterSignal(target, COMSIG_ITEM_DROPPED, .proc/item_dropped)

/datum/element/mouth_drop_item/Detach(datum/source, force)
	UnregisterSignal(source, list(
		COMSIG_ITEM_EQUIPPED,
		COMSIG_ITEM_DROPPED
	))
	return ..()

/datum/element/mouth_drop_item/proc/item_equipped(obj/item/I, mob/living/carbon/human/user, slot)
	SIGNAL_HANDLER

	if(slot == WEAR_FACE)
		I.RegisterSignal(user, COMSIG_MOB_KNOCKED_DOWN, /obj/item.proc/drop_to_floor)

/datum/element/mouth_drop_item/proc/item_dropped(obj/item/I, mob/living/carbon/human/user)
	SIGNAL_HANDLER

	I.UnregisterSignal(user, COMSIG_MOB_KNOCKED_DOWN)
