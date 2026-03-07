/datum/effects/tethering
	effect_name = "tethering"
	flags = INF_DURATION
	var/range = 0
	var/datum/effects/tethered/tethered
	var/tether_icon // The icon used for the Beam proc for the tether
	var/datum/beam/tether_beam
	var/always_face
	var/datum/action/human_action/tether_pull/pull_action

/datum/effects/tethering/New(atom/target, range, icon, always_face)
	..()
	src.range = range
	tether_icon = icon
	src.always_face = always_face

/datum/effects/tethering/validate_atom(atom/target)
	if(isturf(target))
		return TRUE

	if(istype(target, /atom/movable))
		return TRUE

	return FALSE

/datum/effects/tethering/on_apply_effect()
	RegisterSignal(affected_atom, COMSIG_MOVABLE_MOVED, PROC_REF(moved))
	RegisterSignal(affected_atom, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(pre_move))
	if(ishuman(affected_atom))
		pull_action = new(affected_atom)
		pull_action.tethering = src
		pull_action.give_to(affected_atom)

/datum/effects/tethering/Destroy()
	if(pull_action)
		if(affected_atom)
			pull_action.remove_from(affected_atom)
		QDEL_NULL(pull_action)

	if(tethered)
		tethered.tether = null
		qdel(tethered)
		tethered = null
	if(affected_atom)
		QDEL_NULL(tether_beam)
		UnregisterSignal(affected_atom, list(COMSIG_MOVABLE_MOVED, COMSIG_MOVABLE_PRE_MOVE))
	. = ..()

/datum/effects/tethering/proc/moved()
	SIGNAL_HANDLER

	if(isnull(tethered))
		return

	if(isStructure(tethered.affected_atom))//we are attached to a structure, shouldn't move it (too heavy)
		var/obj/structure/anchored_object = tethered.affected_atom
		if(anchored_object.anchored)
			return

	var/atom/movable/tethered_atom = tethered.affected_atom
	if(get_dist(affected_atom, tethered_atom) <= range)
		return

	var/turf/target_turf
	var/dir_away = get_dir(affected_atom, tethered_atom)
	for(var/dir in GLOB.alldirs)
		if(dir & dir_away)
			continue
		target_turf = get_step(tethered_atom, dir)
		if(get_dist(target_turf, affected_atom) <= range && tethered_atom.Move(target_turf))
			return

	// Integrity of tether is compromised (cannot maintain range), so delete it
	qdel(src)

/datum/effects/tethering/proc/pre_move(atom/movable/source, atom/target)
	SIGNAL_HANDLER

	if(isnull(tethered))
		return

	if(isitem(source) && source.throwing && get_dist(target, tethered.affected_atom) > range)
		return COMPONENT_CANCEL_MOVE

	if((ishuman(source) || isStructure(source)) && (ishuman(tethered.affected_atom) || isStructure(tethered.affected_atom)))
		if(get_dist(target, tethered.affected_atom) > range)
			to_chat(source, SPAN_WARNING("You are tethered to [tethered.affected_atom] and cannot move further away!"))
			return COMPONENT_CANCEL_MOVE

/datum/effects/tethering/proc/set_tethered(datum/effects/tethered/tethered_effect)
	tethered = tethered_effect
	tethered_effect.tether = src
	tether_beam = affected_atom.beam(tethered_effect.affected_atom, tether_icon, time = BEAM_INFINITE_DURATION, maxdistance = range+1, always_turn = always_face)

/datum/effects/tethered
	effect_name = "tethered"
	flags = INF_DURATION
	var/datum/effects/tethering/tether
	var/resistible = FALSE
	var/resist_time = 15 SECONDS
	var/datum/action/human_action/tether_pull/pull_action

/datum/effects/tethered/New(atom/target, resistible)
	src.resistible = resistible
	..()

/datum/effects/tethered/validate_atom(atom/target)
	if(istype(target, /atom/movable))
		return TRUE

	return FALSE

/datum/effects/tethered/on_apply_effect()
	RegisterSignal(affected_atom, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(check_move))
	RegisterSignal(affected_atom, COMSIG_ITEM_PICKUP, PROC_REF(check_pickup))
	if(resistible)
		RegisterSignal(affected_atom, COMSIG_MOB_RESISTED, PROC_REF(resist_callback))
	if(ishuman(affected_atom))
		pull_action = new(affected_atom)
		pull_action.tethered = src
		pull_action.give_to(affected_atom)

// affected is always going to be the same as affected_atom
/datum/effects/tethered/proc/check_move(dummy, turf/target)
	SIGNAL_HANDLER

	if(isnull(tether))
		return

	var/atom/tethered_atom = tether.affected_atom

	// If the target turf is out of range, can't move
	if(get_dist(target, tethered_atom) > tether.range)
		to_chat(affected_atom, SPAN_WARNING("Your tether to \the [tethered_atom] prevents you from moving any further!"))
		return COMPONENT_CANCEL_MOVE

/datum/effects/tethered/Destroy()
	if(pull_action)
		if(affected_atom)
			pull_action.remove_from(affected_atom)
		QDEL_NULL(pull_action)

	if(tether)
		tether.tethered = null
		qdel(tether)
		tether = null
	if(affected_atom)
		UnregisterSignal(affected_atom, list(COMSIG_MOVABLE_PRE_MOVE, COMSIG_ITEM_PICKUP))
		if(resistible)
			UnregisterSignal(affected_atom, COMSIG_MOB_RESISTED)
	. = ..()

/datum/effects/tethered/proc/resist_callback()
	SIGNAL_HANDLER

	if(isnull(tether))
		return

	INVOKE_ASYNC(src, PROC_REF(resisted))

/datum/effects/tethered/proc/check_pickup(datum/source, mob/user)
	SIGNAL_HANDLER

	if(isnull(tether))
		return

	if(get_dist(user, tether.affected_atom) > tether.range)
		to_chat(user, SPAN_WARNING("[source] is tethered too far away to pick up!"))
		return COMSIG_ITEM_PICKUP_CANCELLED

/datum/action/human_action/tether_pull
	name = "Pull Tether"
	action_icon_state = "pull_tether"
	var/datum/effects/tethering/tethering
	var/datum/effects/tethered/tethered

/datum/action/human_action/tether_pull/action_activate()
	. = ..()
	if(tethering)
		tethering.pull_tether()
	else if(tethered)
		tethered.pull_anchor()


/datum/effects/tethering/proc/pull_tether()
	if(isnull(tethered))
		return

	if(isStructure(tethered.affected_atom))
		var/obj/structure/anchored_object = tethered.affected_atom
		if(anchored_object.anchored)
			return

	var/atom/movable/tethered_atom = tethered.affected_atom
	var/distance = get_dist(affected_atom, tethered_atom)

	if(!do_after(affected_atom, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		return

	for(var/i in 1 to distance)
		if(!tethered || !affected_atom)
			return
		if(get_dist(affected_atom, tethered_atom) <= 1)
			break
		var/turf/target_loc = tethered_atom.loc
		if(!do_after(affected_atom, 3 DECISECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			break
		if(!tethered || !affected_atom || !tethered_atom)
			return
		if(tethered_atom.loc != target_loc)
			to_chat(affected_atom, SPAN_WARNING("[tethered_atom] is resisting the pull!"))
			break
		step_towards(tethered_atom, affected_atom)

/datum/effects/tethered/proc/pull_anchor()
	if(isnull(tether))
		return

	var/atom/movable/anchored_atom = tether.affected_atom
	if(isStructure(anchored_atom))
		var/obj/structure/anchored_object = anchored_atom
		if(anchored_object.anchored)
			to_chat(affected_atom, SPAN_WARNING("Try as you might, but you can't pull [anchored_object]!"))
			return

	if(isitem(anchored_atom))
		var/obj/item/anchored_object = anchored_atom
		if(anchored_object.anchored)
			to_chat(affected_atom, SPAN_WARNING("Try as you might, but you can't pull [anchored_object]!"))
			return

	var/distance = get_dist(affected_atom, anchored_atom)

	if(!do_after(affected_atom, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		return

	for(var/i in 1 to distance)
		if(!tether || !affected_atom)
			return
		if(get_dist(affected_atom, anchored_atom) <= 1)
			break
		var/turf/target_loc = anchored_atom.loc
		if(!do_after(affected_atom, 3 DECISECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			break
		if(!tether || !affected_atom || !anchored_atom)
			return
		if(anchored_atom.loc != target_loc)
			to_chat(affected_atom, SPAN_WARNING("[anchored_atom] is resisting the pull!"))
			break
		step_towards(anchored_atom, affected_atom)

/datum/effects/tethered/proc/resisted()
	to_chat(affected_atom, SPAN_DANGER("You attempt to break out of your tether to [tether.affected_atom]. (This will take around [resist_time/10] seconds and you need to stand still)"))
	if(!do_after(affected_atom, resist_time, INTERRUPT_NO_NEEDHAND^INTERRUPT_RESIST, BUSY_ICON_HOSTILE))
		return
	to_chat(affected_atom, SPAN_WARNING("You have broken out of your tether to [tether.affected_atom]!"))
	qdel(src)

// Tethers the tethered atom to the tetherer
// If you want both atoms to be tethered to each other, pass in TRUE to the two_way arg
/proc/apply_tether(atom/tetherer, atom/tethered, two_way = FALSE, range = 1, resistible = FALSE, icon = "chain", always_face = TRUE)
	var/list/ret_list = list()

	var/datum/effects/tethering/anchor = new /datum/effects/tethering(tetherer, range, icon, always_face)
	var/datum/effects/tethered/target = new /datum/effects/tethered(tethered, resistible)
	anchor.set_tethered(target)

	ret_list["tetherer_tether"] = anchor
	ret_list["tethered_tethered"] = target

	if(two_way)
		anchor = new /datum/effects/tethering(tethered, icon)
		target = new /datum/effects/tethered(tetherer, resistible)
		anchor.set_tethered(target)
		ret_list["tetherer_tethered"] = target
		ret_list["tethered_tether"] = anchor

	return ret_list
