/datum/effects/tethering
	effect_name = "tethering"
	flags = INF_DURATION
	var/range = 0
	var/datum/effects/tethered/tethered
	var/tether_icon // The icon used for the Beam proc for the tether
	var/beam_id
	var/always_face

/datum/effects/tethering/New(var/atom/A, var/range, var/icon, var/always_face)
	..()
	src.range = range
	tether_icon = icon
	src.always_face = always_face

/datum/effects/tethering/validate_atom(var/atom/A)
	if (isturf(A))
		return TRUE

	if (istype(A, /atom/movable))
		return TRUE

	return FALSE

/datum/effects/tethering/on_apply_effect()
	RegisterSignal(affected_atom, COMSIG_MOVABLE_MOVED, .proc/moved)

/datum/effects/tethering/Destroy()
	if (tethered)
		tethered.tether = null
		qdel(tethered)
		tethered = null
	if (affected_atom)
		if (islist(affected_atom.beams))
			affected_atom.beams -= "[beam_id]"
		UnregisterSignal(affected_atom, COMSIG_MOVABLE_MOVED)
	. = ..()

/datum/effects/tethering/proc/moved()
	SIGNAL_HANDLER

	if (isnull(tethered))
		return

	var/atom/movable/A = tethered.affected_atom
	if (get_dist(affected_atom, A) <= range)
		return

	var/turf/T
	var/dir_away = get_dir(affected_atom, A)
	for (var/dir in alldirs)
		if (dir & dir_away)
			continue
		T = get_step(A, dir)
		if (get_dist(T, affected_atom) <= range && A.Move(T))
			return

	// Integrity of tether is compromised (cannot maintain range), so delete it
	qdel(src)

/datum/effects/tethering/proc/set_tethered(var/datum/effects/tethered/T)
	tethered = T
	T.tether = src
	beam_id = affected_atom.Beam(T.affected_atom, tether_icon, 'icons/effects/beam.dmi', BEAM_INFINITE_DURATION, range+1, always_face)

/datum/effects/tethered
	effect_name = "tethered"
	flags = INF_DURATION
	var/datum/effects/tethering/tether
	var/resistable = FALSE
	var/resist_time = 15 SECONDS

/datum/effects/tethered/New(var/atom/A, var/resistable)
	src.resistable = resistable
	..()

/datum/effects/tethered/validate_atom(var/atom/A)
	if (istype(A, /atom/movable))
		return TRUE

	return FALSE

/datum/effects/tethered/on_apply_effect()
	RegisterSignal(affected_atom, COMSIG_MOVABLE_PRE_MOVE, .proc/check_move)
	if (resistable)
		RegisterSignal(affected_atom, COMSIG_MOB_RESISTED, .proc/resist_callback)

// affected is always going to be the same as affected_atom
/datum/effects/tethered/proc/check_move(var/dummy, var/turf/target)
	SIGNAL_HANDLER

	if (isnull(tether))
		return

	var/atom/A = tether.affected_atom

	// If the target turf is out of range, can't move
	if (get_dist(target, A) > tether.range)
		to_chat(affected_atom, SPAN_WARNING("Your tether to \the [A] prevents you from moving any further!"))
		return COMPONENT_CANCEL_MOVE

/datum/effects/tethered/Destroy()
	if (tether)
		tether.tethered = null
		qdel(tether)
		tether = null
	if (affected_atom)
		UnregisterSignal(affected_atom, COMSIG_MOVABLE_PRE_MOVE)
		if (resistable)
			UnregisterSignal(affected_atom, COMSIG_MOB_RESISTED)
	. = ..()

/datum/effects/tethered/proc/resist_callback()
	SIGNAL_HANDLER

	if (isnull(tether))
		return

	INVOKE_ASYNC(src, .proc/resisted)

/datum/effects/tethered/proc/resisted()
	to_chat(affected_atom, SPAN_DANGER("You attempt to break out of your tether to [tether.affected_atom]. (This will take around [resist_time/10] seconds and you need to stand still)"))
	if(!do_after(affected_atom, resist_time, INTERRUPT_NO_NEEDHAND^INTERRUPT_RESIST, BUSY_ICON_HOSTILE))
		return
	to_chat(affected_atom, SPAN_WARNING("You have broken out of your tether to [tether.affected_atom]!"))
	qdel(src)

// Tethers the tethered atom to the tetherer
// If you want both atoms to be tethered to each other, pass in TRUE to the two_way arg
/proc/apply_tether(var/atom/tetherer, var/atom/tethered, var/two_way = FALSE, var/range = 1, var/resistable = FALSE, var/icon = "chain", var/always_face = TRUE)
	var/list/ret_list = list()

	var/datum/effects/tethering/TR = new /datum/effects/tethering(tetherer, range, icon, always_face)
	var/datum/effects/tethered/TD = new /datum/effects/tethered(tethered, resistable)
	TR.set_tethered(TD)

	ret_list["tetherer_tether"] = TR
	ret_list["tethered_tethered"] = TD

	if (two_way)
		TR = new /datum/effects/tethering(tethered, icon)
		TD = new /datum/effects/tethered(tetherer, resistable)
		TR.set_tethered(TD)
		ret_list["tetherer_tethered"] = TD
		ret_list["tethered_tether"] = TR

	return ret_list
