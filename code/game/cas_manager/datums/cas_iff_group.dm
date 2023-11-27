/datum/cas_iff_group
	var/list/cas_signals = list() //of type cas_signal
	var/list/dropship_consoles = list() //of type ... ? dropship console?

/datum/cas_iff_group/proc/add_signal(datum/cas_signal/signal)
	cas_signals += signal

/datum/cas_iff_group/proc/remove_signal(datum/cas_signal/signal)
	cas_signals -= signal

GLOBAL_DATUM_INIT(uscm_cas_group, /datum/cas_iff_group, new())
GLOBAL_DATUM_INIT(upp_cas_group, /datum/cas_iff_group, new())

GLOBAL_LIST_INIT_TYPED(cas_groups, /datum/cas_iff_group, list(FACTION_MARINE = GLOB.uscm_cas_group, FACTION_UPP = GLOB.upp_cas_group, FACTION_NEUTRAL = GLOB.uscm_cas_group))
