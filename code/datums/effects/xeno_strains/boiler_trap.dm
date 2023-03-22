// Trapper effect, freezing in place and used for combos

/datum/effects/boiler_trap
	effect_name = "boiler trap"
	duration = null
	flags = INF_DURATION
	/// Ghetto flag indicating whether we actually placed the freeze or not, until we have an actual effects system
	var/freezer = FALSE

/datum/effects/boiler_trap/New(atom/current_atom, mob/from, last_dmg_source, zone)
	. = ..()
	if(!QDELETED(src))
		var/mob/mob = affected_atom
		freezer = mob.freeze()

/datum/effects/boiler_trap/Destroy(force)
	if(ismob(affected_atom) && freezer)
		var/mob/mob = affected_atom
		mob.unfreeze()
	return ..()

/datum/effects/boiler_trap/validate_atom(atom/current_atom)
	if(!isxeno_human(current_atom))
		return FALSE
	var/mob/mob = current_atom
	return (mob.stat != DEAD)

/datum/effects/boiler_trap/process_mob()
	. = ..()
	if(!.) return FALSE
	var/mob/mob = affected_atom
	if(mob.frozen) return TRUE
	if(!freezer)
		freezer = mob.freeze()
	return TRUE
