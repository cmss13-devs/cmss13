/datum/element/corp_label
	var/manufacturer
	var/full_name

/datum/element/corp_label/wy
	manufacturer = "weyland_yutani"
	full_name = "<span class='corp_label_gold'>Weyland-Yutani Corporation</span>"

/datum/element/corp_label/armat
	manufacturer = "armat"
	full_name = "<span class='corp_label_green'>Armat Battlefield Systems</span>"

/datum/element/corp_label/seegson
	manufacturer = "seegson"
	full_name = "<span class='corp_label_green'>Seegson Corporation</span>"

/datum/element/corp_label/hyperdyne
	manufacturer = "hyperdyne"
	full_name = "<span class='corp_label_red'>Hyperdyne Systems</span>"

/datum/element/corp_label/gemba
	manufacturer = "gemba_systec"
	full_name = "<span class='corp_label_blue'>Gemba Systec</span>"

/datum/element/corp_label/koorlander
	manufacturer = "koorlander"
	full_name = "<span class='corp_label_bluegreen'>Koorlander Corporation</span>"

/datum/element/corp_label/chigusa
	manufacturer = "chigusa"
	full_name = "<span class='corp_label_gold'>Chigusa Corporation</span>"

/datum/element/corp_label/alphatech
	manufacturer = "alphatech"
	full_name = "<span class='corp_label_yellow'>AlphaTech Hardware</span>"

/datum/element/corp_label/henjin_garcia
	manufacturer = "henjin_garcia"
	full_name = "<span class='corp_label_white'>Henjin-Garcia Armaments Company</span>"

/datum/element/corp_label/bionational
	manufacturer = "lasalle_bionational"
	full_name = "<span class='corp_label_blue'>Lasalle Bionational</span>"

/datum/element/corp_label/kelland
	manufacturer = "kelland"
	full_name = "<span class='corp_label_gold'>Kelland Mining Company</span>"

/datum/element/corp_label/lockmart
	manufacturer = "lock_mart"
	full_name = "<span class='corp_label_white'>Lockheed Martin Corporation</span>"

/datum/element/corp_label/spearhead
	manufacturer = "spearhead"
	full_name = "<span class='corp_label_white'>Spearhead Armory</span>"

/datum/element/corp_label/norcomm
	manufacturer = "norcomm"
	full_name = "<span class='corp_label_red'>Norcomm</span>"

/datum/element/corp_label/souta
	manufacturer = "souta"
	full_name = "<span class='corp_label_red'>Souta Corporation</span>"

/datum/element/corp_label/karnak
	manufacturer = "karnak"
	full_name = "<span class='corp_label_white'>Karnak Electronics</span>"

/datum/element/corp_label/grant
	manufacturer = "karnak"
	full_name = "<span class='corp_label_red'>Grant Corporation</span>"

/datum/element/corp_label/synsound
	manufacturer = "synsound"
	full_name = "<span class='corp_label_red'>Synsound Corporation</span>"

/datum/element/corp_label/Attach(datum/target)
	. = ..()
	if(!length(manufacturer))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/element/corp_label/Detach(datum/target)
	UnregisterSignal(target, list(COMSIG_PARENT_EXAMINE))
	return ..()

/datum/element/corp_label/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	var/logo = "[icon2html('icons/ui_icons/logos.dmi', user, manufacturer, extra_classes = "corplogo", non_standard_size = TRUE)]"
	examine_list += SPAN_INFO("On [source] you can see [full_name] logo, it reads: [logo]")
