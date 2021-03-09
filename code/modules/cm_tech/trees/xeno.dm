// XENOMORPH TREE
// Default hive only for now
/datum/techtree/xenomorph
	name = TREE_XENO
	flags = TREE_FLAG_XENO

	resource_icon_state = "node_xeno"

	resource_make_sound = 'sound/machines/resource_node/node_xeno_on.ogg'
	resource_destroy_sound = 'sound/machines/resource_node/node_xeno_die.ogg'

	resource_break_sound = "alien_resin_break"

	resource_harvest_sound = 'sound/machines/resource_node/node_xeno_harvest.ogg'

	var/hivenumber = XENO_HIVE_NORMAL
	var/heal_per_second = 5

	var/xeno_heal_amount = 30
	var/last_heal = 0

	var/bonus_wall_health = 100

	ui_theme = "xeno"
	background_icon = "xeno_background"
	background_icon_locked = "xeno"

	resource_receive_process = TRUE

/datum/techtree/xenomorph/ui_state(mob/user)
	return GLOB.hive_state[hivenumber]

/datum/techtree/xenomorph/has_access(var/mob/M, var/access_required)
	if(!isXeno(M))
		return FALSE

	var/mob/living/carbon/Xenomorph/X = M

	if(X.hivenumber != hivenumber)
		return FALSE

	if(access_required == TREE_ACCESS_VIEW)
		return TRUE

	return isXenoQueenLeadingHive(X)


/datum/techtree/xenomorph/can_attack(var/mob/living/carbon/H)
	return !(H.hivenumber == hivenumber)

/datum/techtree/xenomorph/on_node_gained(var/obj/structure/resource_node/RN)
	. = ..()

	if(RN == passive_node)
		return

	for(var/turf/T in RN.locs)
		var/obj/effect/alien/weeds/node/N = new(T)
		N.indestructible = TRUE // This node cannot be destroyed until the resource_node is destroyed

	var/area/A = RN.controlled_area
	if(!A)
		log_debug("[RN] passed as argument for on_node_gained. (Tech Tree: [name])")
		return

	for(var/turf/closed/wall/resin/R in A)
		R.damage_cap = initial(R.damage_cap) + bonus_wall_health


/datum/techtree/xenomorph/on_node_lost(var/obj/structure/resource_node/RN)
	. = ..()

	if(RN == passive_node)
		return

	for(var/turf/T in RN.locs)
		for(var/obj/effect/alien/weeds/W in T)
			qdel(W)

	var/area/A = RN.controlled_area
	if(!A)
		log_debug("[RN] passed as argument for on_node_gained. (Tech Tree: [name])")
		return

	for(var/turf/closed/wall/resin/R in A)
		R.damage_cap = max(initial(R.damage_cap), R.damage + 1)


/datum/techtree/xenomorph/proc/remove_heal_overlay(var/mob/living/carbon/Xenomorph/X, var/image/I)
	X.overlays -= I

/datum/techtree/xenomorph/on_process(var/obj/structure/resource_node/RN, delta_time)
	RN.take_damage(-heal_per_second * delta_time)

	if(last_heal > world.time)
		return

	var/area/A = RN.controlled_area
	if(!A)
		log_debug("[RN] passed as argument for on_process. (Tech Tree: [name])")
		return

	for(var/mob/living/carbon/Xenomorph/X in A)
		if(!X.resting)
			continue

		if(X.health >= X.maxHealth)
			continue

		X.visible_message(SPAN_HELPFUL("\The [X] glows as a warm aura envelops them."), \
					SPAN_HELPFUL("You feel a warm aura envelop you."))

		X.flick_heal_overlay(2 SECONDS, "#00FF00")
		X.gain_health(xeno_heal_amount)
	last_heal = world.time + 3 SECONDS // Every 3 second
