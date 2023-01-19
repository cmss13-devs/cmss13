/datum/element/photo_sensitivity_correction
	element_flags = ELEMENT_DETACH

/datum/element/photo_sensitivity_correction/Attach(datum/target)
	. = ..()
	if(!isclothing(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_ITEM_EQUIPPED, PROC_REF(tinted_equipped))
	RegisterSignal(target, COMSIG_ITEM_UNEQUIPPED, PROC_REF(tinted_unequipped))

/datum/element/photo_sensitivity_correction/Detach(datum/source, force)
	UnregisterSignal(source, list(
		COMSIG_ITEM_EQUIPPED,
		COMSIG_ITEM_UNEQUIPPED
	))
	return ..()

/datum/element/photo_sensitivity_correction/proc/tinted_equipped(obj/item/I, mob/living/carbon/human/user, slot)
	SIGNAL_HANDLER

	if(slot == WEAR_EYES || slot == WEAR_FACE || slot == WEAR_HEAD)
		ADD_TRAIT(user, TRAIT_PHOTOSENSITIVITY_EQUIPMENT, TRAIT_SOURCE_EQUIPMENT(slot))

/datum/element/photo_sensitivity_correction/proc/tinted_unequipped(obj/item/I, mob/living/carbon/human/user, slot)
	SIGNAL_HANDLER

	REMOVE_TRAIT(user, TRAIT_PHOTOSENSITIVITY_EQUIPMENT, TRAIT_SOURCE_EQUIPMENT(slot))
