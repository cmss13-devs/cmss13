// A slowing effect that can be applied to humans or Xenos.
// Very simple: just updates the 'slowed' var for its duration

// As to why this is an effect and I'm not just updating the 'slowed' var wherever necessary:
// for a lot of MOBA xenos things, you need to check the originator of a status effect
// not just that one is applied
// or else you'd get crushers combo-ing off of effects applied by a lurker
// applies to HUDs as well

/datum/effects/xeno_slow
	effect_name = "slow"
	duration = null
	flags = DEL_ON_DEATH | INF_DURATION

/datum/effects/xeno_slow/New(var/atom/A, var/mob/from = null, var/last_dmg_source = null, var/zone = "chest", ttl = 35)
	. = ..(A, from, last_dmg_source, zone)

	addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, src), ttl)

	if (ishuman(A))
		var/mob/living/carbon/human/H = A
		H.update_xeno_hostile_hud()


/datum/effects/xeno_slow/validate_atom(var/atom/A)
	if (!ishuman(A) && !isXeno(A))
		return FALSE

	var/mob/M = A
	if (M.stat == DEAD)
		return FALSE

	. = ..()

/datum/effects/xeno_slow/process_mob()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/affected_mob = affected_atom
	affected_mob.AdjustSlowed(1.1) // Prevent you from getting 'unslowed'
	return TRUE

/datum/effects/xeno_slow/Destroy()

	if (!ishuman(affected_atom))
		. = ..()
		return

	var/mob/living/carbon/human/H = affected_atom
	addtimer(CALLBACK(H, /mob/living/carbon/human.proc/update_xeno_hostile_hud), 3)

	. = ..()

/datum/effects/xeno_slow/superslow/process_mob()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/affected_mob = affected_atom
	affected_mob.AdjustSuperslowed(1.1) // Prevent you from getting 'unslowed'
	return TRUE