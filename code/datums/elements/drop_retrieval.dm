/datum/element/drop_retrieval
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 2
	var/compatible_types = list(/obj/item)

/datum/element/drop_retrieval/Attach(datum/target)
	. = ..()
	if (!is_type_in_list(target, compatible_types))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_MOVABLE_PRE_THROW, PROC_REF(cancel_throw))
	RegisterSignal(target, COMSIG_ITEM_DROPPED, PROC_REF(dropped))
	RegisterSignal(target, COMSIG_DROP_RETRIEVAL_CHECK, PROC_REF(dr_check))

/datum/element/drop_retrieval/Detach(datum/source, force)
	UnregisterSignal(source, list(
		COMSIG_MOVABLE_PRE_THROW,
		COMSIG_ITEM_DROPPED,
		COMSIG_DROP_RETRIEVAL_CHECK
	))
	return ..()

/datum/element/drop_retrieval/proc/cancel_throw(datum/source, mob/thrower)
	SIGNAL_HANDLER

	if(thrower)
		to_chat(thrower, SPAN_WARNING("\The [source] clanks on the ground."))
	return COMPONENT_CANCEL_THROW

/datum/element/drop_retrieval/proc/dropped(obj/item/I, mob/user)
	SIGNAL_HANDLER

/datum/element/drop_retrieval/proc/dr_check(obj/item/I)
	SIGNAL_HANDLER

	return COMPONENT_DROP_RETRIEVAL_PRESENT

/datum/element/drop_retrieval/gun
	compatible_types = list(/obj/item/weapon/gun)
	var/retrieval_slot

/datum/element/drop_retrieval/gun/Attach(datum/target, slot)
	. = ..()
	if (.)
		return
	RegisterSignal(target, COMSIG_ITEM_HOLSTER, PROC_REF(holster))
	retrieval_slot = slot

/datum/element/drop_retrieval/gun/proc/holster(obj/item/weapon/gun/holstered_gun, mob/user)
	SIGNAL_HANDLER
	if(holstered_gun.retrieve_to_slot(user, retrieval_slot, FALSE, TRUE))
		return COMPONENT_ITEM_HOLSTER_CANCELLED

/datum/element/drop_retrieval/gun/dropped(obj/item/weapon/gun/G, mob/user)
	G.handle_retrieval(user, retrieval_slot)

//-------------------------------------------------------

// STORAGE - SPECIFIC RETRIEVAL START

/datum/element/drop_retrieval/storage
	compatible_types = list(/obj/item)
	var/obj/item/storage/container
	var/datum/effects/tethering/active_tether

/datum/element/drop_retrieval/storage/Attach(datum/target, obj/item/storage/new_container)
	. = ..()
	if(.)
		return
	container = new_container
	UnregisterSignal(target, COMSIG_MOVABLE_PRE_THROW) // necessary since we are calling parent
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(check_tether))
	RegisterSignal(container, COMSIG_MOVABLE_MOVED, PROC_REF(container_moved))
	RegisterSignal(target, COMSIG_ITEM_PICKUP, PROC_REF(check_pickup))

/datum/element/drop_retrieval/storage/Detach(datum/source, force)
	if(active_tether)
		UnregisterSignal(active_tether, COMSIG_PARENT_QDELETING)
		QDEL_NULL(active_tether)
	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(source, COMSIG_ITEM_PICKUP)
	if(container)
		UnregisterSignal(container, COMSIG_MOVABLE_MOVED)
	return ..()

/datum/element/drop_retrieval/storage/dropped(obj/item/object, mob/user)
	maintain_tether()

/datum/element/drop_retrieval/storage/proc/check_tether(atom/movable/source)
	SIGNAL_HANDLER

	if(active_tether)
		if(source.loc == container)
			QDEL_NULL(active_tether)
			return
		var/atom/current_target = active_tether.tethered?.affected_atom
		var/atom/desired_target = get_tether_target()
		if(current_target != desired_target)
			qdel(active_tether)

/datum/element/drop_retrieval/storage/proc/container_moved(datum/source)
	SIGNAL_HANDLER

	if(active_tether)
		var/atom/current_anchor = active_tether.affected_atom
		var/atom/desired_anchor = get_anchor()
		if(current_anchor != desired_anchor)
			qdel(active_tether)

/datum/element/drop_retrieval/storage/proc/check_pickup(obj/item/source, mob/user) // ordinarily attack_hand would be cleaner here, but signal shenanigans
	SIGNAL_HANDLER

	var/atom/anchor = get_anchor()
	if(get_dist(user, anchor) > container.sling_range)
		to_chat(user, SPAN_WARNING("\The [source] is tethered too far away to pick up!"))
		return COMSIG_ITEM_PICKUP_CANCELLED

/datum/element/drop_retrieval/storage/proc/tether_deleted(datum/source)
	SIGNAL_HANDLER

	if(active_tether == source)
		active_tether = null

	maintain_tether()

/datum/element/drop_retrieval/storage/proc/maintain_tether()
	if(active_tether)
		return

	if(container.slung_item && container.slung_item.z && container.z && container.slung_item.z != container.z) // some nullspace z nonsense necessitated this
		container.unsling(TRUE)
		return

	var/obj/item/object = container.slung_item
	if(!object || object.loc == container)
		return

	var/atom/anchor = get_anchor()
	var/atom/target = get_tether_target()

	if(anchor == target) // lets not tether to self
		return

	if(get_dist(anchor, target) > container.sling_range) // really annoying edgecase code i needed to do here if the storage item is picked up farther than the sling_range yet phone.dm has this handled safely somehow, probably some element limitation or something w/e - nihi
		step_towards(target, anchor)

	var/list/tether_data = apply_tether(anchor, target, range = container.sling_range)
	active_tether = tether_data["tetherer_tether"]
	RegisterSignal(active_tether, COMSIG_PARENT_QDELETING, PROC_REF(tether_deleted))

/datum/element/drop_retrieval/storage/proc/get_anchor()
	var/atom/object = container
	var/i = 0
	while(object && !ismob(object) && i < 10)
		if(isturf(object.loc))
			return container
		object = object.loc
		i++
	if(ismob(object))
		return object
	return container

/datum/element/drop_retrieval/storage/proc/get_tether_target() // god just drive me insane, tldr responsible for checking where the item currently is
	var/obj/item/object = container.slung_item
	if(!object)
		return null
	var/atom/item = object
	var/i = 0
	while(item && !ismob(item) && i < 10)
		if(isturf(item.loc))
			return object
		item = item.loc
		i++
	if(ismob(item))
		return item
	return object

// STORAGE - SPECIFIC RETRIEVAL END

//-------------------------------------------------------

/datum/element/drop_retrieval/mister
	compatible_types = list(/obj/item/reagent_container/spray/mister)

/datum/element/drop_retrieval/mister/dropped(obj/item/I, mob/user)
	var/obj/item/reagent_container/glass/watertank/WT = user.back
	if(!istype(WT))
		return ..()
	WT.remove_noz()
	to_chat(user, SPAN_WARNING("\The [I]'s magnetic harness snaps it back onto \the [WT]!"))
	WT.update_icon()
