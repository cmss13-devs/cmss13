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

/datum/element/drop_retrieval/pouch_sling
	compatible_types = list(/obj/item/device, /obj/item/tool)
	var/obj/item/storage/pouch/sling/container

/datum/element/drop_retrieval/pouch_sling/Attach(datum/target, obj/item/storage/pouch/sling/new_container)
	. = ..()
	if(.)
		return
	container = new_container

/datum/element/drop_retrieval/pouch_sling/dropped(obj/item/I, mob/user)
	container.handle_retrieval(user)

/datum/element/drop_retrieval/mister
	compatible_types = list(/obj/item/reagent_container/spray/mister)

/datum/element/drop_retrieval/mister/dropped(obj/item/I, mob/user)
	var/obj/item/reagent_container/glass/watertank/WT = user.back
	if(!istype(WT))
		return ..()
	WT.remove_noz()
	to_chat(user, SPAN_WARNING("\The [I]'s magnetic harness snaps it back onto \the [WT]!"))
	WT.update_icon()
