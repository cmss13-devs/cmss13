/datum/component/weed_damage_mult
	dupe_mode = COMPONENT_DUPE_HIGHLANDER

	var/hivenumber = XENO_HIVE_NORMAL
	var/damage_mult = 1
	var/static/list/signal_damage_types = list(
		COMSIG_MOB_TAKE_DAMAGE,
		COMSIG_HUMAN_TAKE_DAMAGE,
		COMSIG_XENO_TAKE_DAMAGE
	)
	var/glow_color = "#ff14ff"
	var/base_alpha = 110

/datum/component/weed_damage_mult/Initialize(hivenumber, damage_mult, glow_color = "#ff14ff")
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE

	. = ..()
	src.hivenumber = hivenumber
	src.damage_mult = damage_mult
	src.glow_color = glow_color

/datum/component/weed_damage_mult/RegisterWithParent()
	RegisterSignal(parent, signal_damage_types, .proc/set_incoming_damage)
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, .proc/check_for_filter)

	var/mob/M = parent
	check_for_filter(M, M.loc, 0, FALSE)

/datum/component/weed_damage_mult/UnregisterFromParent()
	UnregisterSignal(parent, signal_damage_types)
	var/mob/M = parent
	M.remove_filter("weed_damage_mult")

/datum/component/weed_damage_mult/proc/check_for_filter(var/mob/M, var/turf/oldloc, direction, forced)
	SIGNAL_HANDLER

	var/turf/T = M.loc
	if(!istype(T))
		return

	if(!T.weeds)
		if(oldloc.weeds)
			M.remove_filter("weed_damage_mult")
		return

	if(M.get_filter("weed_damage_mult"))
		return

	var/alpha = base_alpha*max(1-damage_mult, 0)
	M.add_filter("weed_damage_mult", 3, list("type" = "outline", "color" = "[glow_color][num2text(alpha, 2, 16)]", "size" = 1))

/datum/component/weed_damage_mult/proc/set_incoming_damage(var/mob/M, var/list/damages)
	SIGNAL_HANDLER
	var/turf/T = get_turf(M)
	if(!T)
		return

	// This shouldn't affect healing
	if(damages["damage"] <= 0)
		return

	if(T.weeds && T.weeds.hivenumber == hivenumber)
		damages["damage"] *= damage_mult
