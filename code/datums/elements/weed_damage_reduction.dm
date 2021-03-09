/datum/element/weed_damage_mult
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 2

	var/hivenumber = XENO_HIVE_NORMAL
	var/damage_mult = 1
	var/static/list/signal_damage_types = list(
		COMSIG_MOB_TAKE_DAMAGE,
		COMSIG_HUMAN_TAKE_DAMAGE,
		COMSIG_XENO_TAKE_DAMAGE
	)

/datum/element/weed_damage_mult/Attach(datum/target, hivenumber, damage_mult)
	. = ..()
	if(!ismob(target))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, signal_damage_types, .proc/set_incoming_damage)
	src.hivenumber = hivenumber
	src.damage_mult = damage_mult

/datum/element/weed_damage_mult/proc/set_incoming_damage(var/mob/M, var/list/damages)
	SIGNAL_HANDLER
	var/turf/T = get_turf(M)
	if(!T)
		return

	// This shouldn't affect healing
	if(damages["damage"] <= 0)
		return

	if(T.weeds && T.weeds.hivenumber == hivenumber)
		damages["damage"] *= damage_mult

/datum/element/weed_damage_mult/Detach(datum/source, force)
	UnregisterSignal(source, signal_damage_types)
	return ..()
