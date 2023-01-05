/datum/element/poor_eyesight_correction
	element_flags = ELEMENT_DETACH

/datum/element/poor_eyesight_correction/Attach(datum/target)
	. = ..()
	if(!isclothing(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_ITEM_EQUIPPED, PROC_REF(prescription_equipped))
	RegisterSignal(target, COMSIG_ITEM_UNEQUIPPED, PROC_REF(prescription_unequipped))

/datum/element/poor_eyesight_correction/Detach(datum/source, force)
	UnregisterSignal(source, list(
		COMSIG_ITEM_EQUIPPED,
		COMSIG_ITEM_UNEQUIPPED
	))
	return ..()

/datum/element/poor_eyesight_correction/proc/prescription_equipped(obj/item/I, mob/living/carbon/human/user, slot)
	SIGNAL_HANDLER

	if(slot == WEAR_EYES || slot == WEAR_FACE || slot == WEAR_HEAD)
		ADD_TRAIT(user, TRAIT_NEARSIGHTED_EQUIPMENT, TRAIT_SOURCE_EQUIPMENT(slot))

/datum/element/poor_eyesight_correction/proc/prescription_unequipped(obj/item/I, mob/living/carbon/human/user, slot)
	SIGNAL_HANDLER

	REMOVE_TRAIT(user, TRAIT_NEARSIGHTED_EQUIPMENT, TRAIT_SOURCE_EQUIPMENT(slot))
