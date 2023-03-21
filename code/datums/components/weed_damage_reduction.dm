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
	RegisterSignal(parent, signal_damage_types, PROC_REF(set_incoming_damage))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(check_for_filter))

	var/mob/current_mob = parent
	check_for_filter(current_mob, current_mob.loc, 0, FALSE)

/datum/component/weed_damage_mult/UnregisterFromParent()
	UnregisterSignal(parent, signal_damage_types)
	var/mob/current_mob = parent
	current_mob.remove_filter("weed_damage_mult")

/datum/component/weed_damage_mult/proc/check_for_filter(mob/current_mob, turf/oldloc, direction, forced)
	SIGNAL_HANDLER

	var/turf/current_turf = current_mob.loc
	if(!istype(current_turf))
		return

	if(!current_turf.weeds || current_turf.weeds.hivenumber != hivenumber)
		current_mob.remove_filter("weed_damage_mult")
		return

	if(current_mob.get_filter("weed_damage_mult"))
		return

	var/alpha = base_alpha*max(1-damage_mult, 0)
	current_mob.add_filter("weed_damage_mult", 3, list("type" = "outline", "color" = "[glow_color][num2text(alpha, 2, 16)]", "size" = 1))

/datum/component/weed_damage_mult/proc/set_incoming_damage(mob/current_mob, list/damages)
	SIGNAL_HANDLER
	var/turf/current_turf = get_turf(current_mob)
	if(!current_turf)
		return

	// This shouldn't affect healing
	if(damages["damage"] <= 0)
		return

	if(current_turf.weeds && current_turf.weeds.hivenumber == hivenumber)
		damages["damage"] *= damage_mult
