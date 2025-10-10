/datum/element/corp_label
	var/manufacturer
	var/icon

/datum/element/corp_label/wy
	manufacturer = "weyland_yutani"

/datum/element/corp_label/armat
	manufacturer = "armat"

/datum/element/corp_label/Attach(datum/target)
	. = ..()
	if(!manufacturer)
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/element/corp_label/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, list(COMSIG_PARENT_EXAMINE))

/datum/element/corp_label/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	var/logo = "[icon2html('icons/ui_icons/logos.dmi', viewers(source), manufacturer, non_standard_size = TRUE)]"
	examine_list += SPAN_INFO("On [source] you can see a manufactuer logo, it reads: [SPAN_CORP_LOGO(FONT_SIZE_TITANIC("[logo]"))]")
