/// Element for objects that can write on writables
/datum/element/writer
	element_flags = ELEMENT_BESPOKE
	id_arg_index = 2

	/// Color to write (if writable takes in color)
	VAR_PRIVATE/color
	/// Whether it is a crayon
	VAR_PRIVATE/crayon

/datum/element/writer/Attach(obj/item/target, color, crayon)
	. = ..()
	if (. == ELEMENT_INCOMPATIBLE || !isitem(target))
		return ELEMENT_INCOMPATIBLE
	src.color = color
	src.crayon = crayon
	RegisterSignal(target, COMSIG_ITEM_CAN_WRITE_CHECK, PROC_REF(can_write_handler))

/datum/element/writer/Detach(obj/item/source, force)
	UnregisterSignal(source, COMSIG_ITEM_CAN_WRITE_CHECK)
	return ..()

/// Proc to handle whether write is successful. `metadata` is not guaranteed to be passed
/datum/element/writer/proc/can_write_handler(obj/item/target, datum/write_check_metadata/metadata)
	SIGNAL_HANDLER

	. = COMPONENT_IS_WRITER
	if (color)
		metadata?.color = color
	if (crayon)
		metadata?.crayon = crayon
	if (target.can_write(metadata))
		. |= COMPONENT_CAN_WRITE

/// Overwrite this proc if there is any special logic for determining can write logic
/obj/item/proc/can_write(datum/write_check_metadata/metadata)
	return TRUE
