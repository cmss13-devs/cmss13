
/datum/element/crutch

/datum/element/crutch/Attach(datum/target)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE

	ADD_TRAIT(target, TRAIT_CRUTCH, TRAIT_SOURCE_ITEM)
	RegisterSignal(target, COMSIG_ITEM_PICKUP, .proc/picked_up)
	RegisterSignal(target, COMSIG_ITEM_DROPPED, .proc/dropped)

/datum/element/crutch/Detach(obj/item/source, force)
	. = ..()
	UnregisterSignal(source, list(COMSIG_ITEM_PICKUP, COMSIG_ITEM_DROPPED))
	if(ismob(source.loc))
		var/mob/M = source.loc
		M.update_can_stand()

/datum/element/crutch/proc/picked_up(item, mob/item_holder)
	item_holder.update_can_stand()

/datum/element/crutch/proc/dropped(item, mob/item_holder)
	var/old_state = item_holder.can_stand
	item_holder.update_can_stand()
	if((old_state != item_holder.can_stand) && (item_holder.can_stand == FALSE))
		to_chat(item_holder, SPAN_WARNING("You lose balance as you let go of the [item]!"))
