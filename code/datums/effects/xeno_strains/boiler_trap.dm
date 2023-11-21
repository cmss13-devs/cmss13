// Trapper effect, freezing in place and used for combos

/datum/effects/boiler_trap
	effect_name = "boiler trap"
	duration = null
	flags = INF_DURATION

/datum/effects/boiler_trap/New(atom/A, mob/from, last_dmg_source, zone)
	. = ..()
	if(!QDELETED(src))
		var/mob/M = affected_atom
		ADD_TRAIT(M, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY(effect_name))

/datum/effects/boiler_trap/Destroy(force)
	if(ismob(affected_atom))
		var/mob/M = affected_atom
		REMOVE_TRAIT(M, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY(effect_name))
	return ..()

/datum/effects/boiler_trap/validate_atom(atom/A)
	if(!isxeno_human(A))
		return FALSE
	var/mob/M = A
	return (M.stat != DEAD)

/datum/effects/boiler_trap/process_mob()
	. = ..()
	if(!.) return FALSE
	var/mob/M = affected_atom
	ADD_TRAIT(M, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY(effect_name))
	return TRUE
