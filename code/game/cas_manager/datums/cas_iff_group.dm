/datum/cas_iff_group
	var/list/cas_signals = list() //of type cas_signal
	var/list/dropship_consoles = list() //of type ... ? dropship console?
	var/datum/event/signal_removed = new /datum/event()
	var/datum/event/signal_added = new /datum/event()

/datum/cas_iff_group/proc/add_signal(datum/cas_signal/signal)
	cas_signals += signal
	signal_added.fire_event(signal)

/datum/cas_iff_group/proc/remove_signal(datum/cas_signal/signal)	
	cas_signals -= signal
	signal_removed.fire_event(signal)

var/global/datum/cas_iff_group/uscm_cas_group = new /datum/cas_iff_group()

var/global/datum/cas_iff_group/upp_cas_group = new /datum/cas_iff_group()

var/global/list/datum/cas_iff_group/cas_groups = list(FACTION_MARINE = uscm_cas_group, FACTION_UPP = upp_cas_group, FACTION_NEUTRAL = uscm_cas_group)
