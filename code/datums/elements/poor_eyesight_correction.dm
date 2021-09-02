/datum/element/poor_eyesight_correction
	element_flags = ELEMENT_DETACH
	var/list/attached_clothing

/datum/element/poor_eyesight_correction/Attach(datum/target)
	. = ..()
	if(!isclothing(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_ITEM_EQUIPPED, .proc/prescription_equipped)
	RegisterSignal(target, COMSIG_ITEM_DROPPED, .proc/prescription_dropped)

/datum/element/poor_eyesight_correction/Detach(datum/source, force)
	UnregisterSignal(source, list(
		COMSIG_ITEM_EQUIPPED,
		COMSIG_ITEM_DROPPED
	))
	return ..()

/datum/element/poor_eyesight_correction/proc/prescription_equipped(obj/item/I, mob/living/carbon/human/user, slot)
	SIGNAL_HANDLER

	if(slot == WEAR_EYES || slot == WEAR_FACE || slot == WEAR_HEAD)
		LAZYINITLIST(attached_clothing)
		LAZYADD(attached_clothing[user], I)
		ADD_TRAIT(user, TRAIT_NEARSIGHTED_EQUIPMENT, TRAIT_SOURCE_CLOTHING)

/datum/element/poor_eyesight_correction/proc/prescription_dropped(obj/item/I, mob/living/carbon/human/user, slot)
	SIGNAL_HANDLER

	var/list/L = attached_clothing[user]
	L -= I
	if(!length(L))
		REMOVE_TRAIT(user, TRAIT_NEARSIGHTED_EQUIPMENT, TRAIT_SOURCE_CLOTHING)