/// Assigns an effects appearance to the appearance of a target atom
/datum/element/copy_appearance

/datum/element/copy_appearance/Attach(datum/target, atom/to_copy)
	. = ..()
	if (. == ELEMENT_INCOMPATIBLE)
		return
	if (!istype(target, /obj/effect))
		return ELEMENT_INCOMPATIBLE
	if (!isatom(to_copy))
		return ELEMENT_INCOMPATIBLE
	var/obj/effect/effect = target
	effect.name = to_copy.name
	effect.appearance = to_copy.appearance
	effect.setDir(to_copy.dir)
	effect.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
