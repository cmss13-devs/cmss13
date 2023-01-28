/datum/element/yautja_tracked_item
	element_flags = ELEMENT_DETACH

/datum/element/yautja_tracked_item/Attach(obj/item/target)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_ITEM_PICKUP, PROC_REF(item_picked_up))
	RegisterSignal(target, COMSIG_ITEM_DROPPED, PROC_REF(item_dropped))


	if(!is_honorable_carrier(recursive_holder_check(target)))
		add_to_missing_pred_gear(target)
	GLOB.tracked_yautja_gear += target

/datum/element/yautja_tracked_item/Detach(datum/source, force)
	UnregisterSignal(source, list(
		COMSIG_ITEM_PICKUP,
		COMSIG_ITEM_DROPPED
	))
	remove_from_missing_pred_gear(source)
	GLOB.tracked_yautja_gear -= source
	return ..()

/datum/element/yautja_tracked_item/proc/item_picked_up(obj/item/picked_up_item, mob/living/carbon/human/user)
	SIGNAL_HANDLER

	if(is_honorable_carrier(user))
		remove_from_missing_pred_gear(picked_up_item)

/datum/element/yautja_tracked_item/proc/item_dropped(obj/item/dropped_item, mob/living/carbon/human/user)
	SIGNAL_HANDLER

	if(!is_honorable_carrier(recursive_holder_check(dropped_item)))
		add_to_missing_pred_gear(dropped_item)

/proc/is_honorable_carrier(mob/living/carbon/human/carrier)
	if(isyautja(carrier))
		return TRUE
	if(ishumansynth_strict(carrier) && (carrier.hunter_data.honored || carrier.hunter_data.thralled) && !(carrier.hunter_data.dishonored || carrier.stat == DEAD))
		return TRUE
	if(istype(carrier, /mob/hologram/falcon))
		return TRUE
	return FALSE
