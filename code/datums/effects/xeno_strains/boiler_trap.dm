// Trapper effect, freezing in place and used for combos

/datum/effects/boiler_trap
	effect_name = "boiler trap"
	duration = null
	flags = INF_DURATION
	/// Ghetto flag indicating whether we actually placed the freeze or not, until we have an actual effects system
	var/freezer = FALSE

/datum/effects/boiler_trap/New(atom/A, mob/from, last_dmg_source, zone)
	. = ..()
	if(!QDELETED(src))
		var/mob/M = affected_atom
		freezer = M.freeze()

/datum/effects/boiler_trap/Destroy(force)
	if(ismob(affected_atom) && freezer)
		var/mob/M = affected_atom
		M.unfreeze()
	return ..()

/datum/effects/boiler_trap/validate_atom(atom/A)
	if(!isXenoOrHuman(A))
		return FALSE
	var/mob/M = A
	return (M.stat != DEAD)

/datum/effects/boiler_trap/process_mob()
	. = ..()
	if(!.) return FALSE
	var/mob/M = affected_atom
	if(M.frozen) return TRUE
	if(!freezer)
		freezer = M.freeze()
	return TRUE