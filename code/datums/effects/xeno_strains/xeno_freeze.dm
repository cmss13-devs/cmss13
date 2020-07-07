// A slowing effect that can be applied to humans or Xenos.
// Very simple: just updates the 'freeze'

// applies to HUDs as well

/datum/effects/xeno_freeze
	effect_name = "freeze"
	duration = null
	flags = DEL_ON_DEATH | INF_DURATION

/datum/effects/xeno_freeze/New(var/atom/A, var/mob/from = null, var/last_dmg_source = null, var/zone = "chest", ttl = 20)
	. = ..(A, from, last_dmg_source, zone)

	add_timer(CALLBACK(GLOBAL_PROC, .proc/qdel, src), ttl)

	if (ishuman(A))
		var/mob/living/carbon/human/H = A
		H.update_xeno_hostile_hud()


/datum/effects/xeno_freeze/validate_atom(var/atom/A)
	if (!isXenoOrHuman(A))
		return FALSE

	var/mob/M = A
	if (M.stat == DEAD)
		return FALSE

	return TRUE

/datum/effects/xeno_freeze/Dispose()
	if(affected_atom)
		var/mob/living/carbon/affected_mob = affected_atom
		affected_mob.frozen = FALSE
		affected_mob.update_canmove()

		if(affected_atom && ishuman(affected_atom))
			var/mob/living/carbon/human/H = affected_atom
			add_timer(CALLBACK(H, /mob/living/carbon/human.proc/update_xeno_hostile_hud), 3)

	return ..()

/datum/effects/xeno_freeze/process_mob()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/affected_mob = affected_atom
	affected_mob.frozen = TRUE
	affected_mob.update_canmove()
	return TRUE
