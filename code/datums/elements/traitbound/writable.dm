/// Element for objs that can be written on
/datum/element/traitbound/writable
	compatible_types = list(/obj)
	associated_trait = TRAIT_WRITABLE

/datum/element/traitbound/writable/Attach(obj/target)
	. = ..()
	if (. & ELEMENT_INCOMPATIBLE || !isobj(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, list(COMSIG_PARENT_ATTACKBY, COMSIG_ITEM_WRITE), PROC_REF(try_write))

/datum/element/traitbound/writable/Detach(obj/source, force)
	UnregisterSignal(source, list(COMSIG_PARENT_ATTACKBY, COMSIG_ITEM_WRITE))
	return ..()

/datum/element/traitbound/writable/proc/try_write(obj/writable, obj/item/attacked_by, mob/user, mods)
	SIGNAL_HANDLER

	var/datum/write_check_metadata/metadata = new /datum/write_check_metadata()
	var/sigresult = SEND_SIGNAL(attacked_by, COMSIG_ITEM_CAN_WRITE_CHECK, metadata)
	if (!(sigresult & COMPONENT_CAN_WRITE))
		if (sigresult & COMPONENT_IS_WRITER && user && metadata?.failure_reason)
			to_chat(user, SPAN_NOTICE("Could not write on [writable] because [attacked_by] [metadata.failure_reason]."))
		return
	var/color = metadata.color
	var/crayon = metadata.crayon
	writable.write(attacked_by, user, mods, color, crayon)
	return ATTACK_HINT_NO_AFTERATTACK|ATTACK_HINT_NO_TELEGRAPH

/obj/proc/write(obj/item/writer, mob/user, mods, color, crayon)
	return

/datum/write_check_metadata
	/// Color of any text output by the writer item
	var/color
	/// Whether writer is a crayon
	var/crayon
	/// Failure reason in active voice (e.g. "is not on" "ran out of ink")
	var/failure_reason
