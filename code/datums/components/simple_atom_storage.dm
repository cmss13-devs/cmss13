/// Simple component for handling storage of items into a simple atom.
/datum/component/simple_atom_storage
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/list/atom/movable/stored_items = list()
	var/list/allowed_types
	var/maximum_slots
	var/sound_file

/datum/component/simple_atom_storage/Initialize(list/allowed_types, maximum_slots, sound_file)
	. = ..()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	src.allowed_types = allowed_types
	src.maximum_slots = maximum_slots
	src.sound_file = sound_file
	RegisterSignal(parent, COMSIG_ATOM_CAN_STORE, PROC_REF(can_store))
	RegisterSignal(parent, COMSIG_ATOM_CAN_RETRIEVE, PROC_REF(can_retrieve))
	RegisterSignal(parent, COMSIG_ATOM_ATTEMPT_STORE, PROC_REF(attempt_store))
	RegisterSignal(parent, COMSIG_ATOM_ATTEMPT_RETRIEVE, PROC_REF(attempt_retrieve))

/datum/component/simple_atom_storage/Destroy(force)
	QDEL_LIST(stored_items)
	return ..()

/datum/component/simple_atom_storage/proc/can_store(atom/storage, obj/item/item)
	SIGNAL_HANDLER
	if(isnum(maximum_slots) && length(stored_items) >= maximum_slots)
		return NONE
	if(islist(allowed_types))
		for(var/item_type in allowed_types)
			if(istype(item, item_type))
				return COMPONENT_ATOM_CAN_STORE

/datum/component/simple_atom_storage/proc/can_retrieve(atom/storage)
	SIGNAL_HANDLER
	if(!length(stored_items))
		return COMPONENT_ATOM_NOTHING_TO_RETRIEVE
	return COMPONENT_ATOM_CAN_RETRIEVE

/datum/component/simple_atom_storage/proc/attempt_store(atom/storage, mob/living/user, obj/item/item)
	SIGNAL_HANDLER
	if(!(can_store(storage, item) & COMPONENT_ATOM_CAN_STORE))
		return
	if(user)
		user.drop_inv_item_to_loc(item, storage)
	else
		item.forceMove(storage)
	stored_items += item
	. = COMPONENT_ATOM_STORAGE_STORED
	SEND_SIGNAL(parent, COMSIG_ATOM_STORAGE_UPDATED, stored_items)
	if(user)
		to_chat(user, SPAN_NOTICE("You put the [item] into [storage]."))
		if(sound_file)
			playsound(user, sound_file, 15, TRUE)

/datum/component/simple_atom_storage/proc/attempt_retrieve(atom/storage, mob/living/user)
	SIGNAL_HANDLER
	if(!length(stored_items))
		return COMPONENT_ATOM_NOTHING_TO_RETRIEVE
	var/atom/movable/item = stored_items[1]
	if(!user?.put_in_active_hand(item))
		return
	stored_items -= item
	. = COMPONENT_ATOM_STORAGE_RETRIEVED
	SEND_SIGNAL(parent, COMSIG_ATOM_STORAGE_UPDATED, stored_items)
	to_chat(user, SPAN_NOTICE("You take [item] out of [storage]."))
	if(sound_file)
		playsound(user, sound_file, 15, TRUE)
