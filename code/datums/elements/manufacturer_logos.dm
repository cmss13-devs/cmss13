/datum/element/corp_label
	var/manufacturer
	var/full_name
	var/icon

/datum/element/corp_label/wy
	manufacturer = "weyland_yutani"
	full_name = "Weyland-Yutani Corporation"

/datum/element/corp_label/armat
	manufacturer = "armat"
	full_name = "Armat Battlefield Systems"

/datum/element/corp_label/seegson
	manufacturer = "seegson"
	full_name = "Seegson Corporation"

/datum/element/corp_label/hyperdyne
	manufacturer = "hyperdyne"
	full_name = "Hyperdyne Systems"

/datum/element/corp_label/gemba
	manufacturer = "gemba_systec"
	full_name = "Gemba Systec"

/datum/element/corp_label/koorlander
	manufacturer = "koorlander"
	full_name = "Koorlander Corporation"

/datum/element/corp_label/chigusa
	manufacturer = "chigusa"
	full_name = "Chigusa Corporation"

/datum/element/corp_label/alphatech
	manufacturer = "alphatech"
	full_name = "AlphaTech Hardware"

/datum/element/corp_label/henjin_garcia
	manufacturer = "henjin_garcia"
	full_name = "Henjin-Garcia Armaments Company"

/datum/element/corp_label/bionational
	manufacturer = "lasalle_bionational"
	full_name = "Lasalle Bionational"

/datum/element/corp_label/kelland
	manufacturer = "kelland"
	full_name = "Kelland Mining Company"

/datum/element/corp_label/lockmart
	manufacturer = "lock_mart"
	full_name = "Lockheed Martin Corporation"

/datum/element/corp_label/spearhead
	manufacturer = "spearhead"
	full_name = "Spearhead Armory"

/datum/element/corp_label/norcomm
	manufacturer = "norcomm"
	full_name = "Norcomm"

/datum/element/corp_label/souta
	manufacturer = "souta"
	full_name = "Souta Corporation"

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
	var/logo = "[icon2html('icons/ui_icons/logos.dmi', viewers(source), manufacturer, extra_classes = "corplogo", non_standard_size = TRUE)]"
	examine_list += SPAN_INFO("On [source] you can see [full_name] logo, it reads: [logo]")
