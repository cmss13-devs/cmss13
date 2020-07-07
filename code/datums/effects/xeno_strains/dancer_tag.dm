/datum/effects/dancer_tag
	effect_name = "dancer tag"
	duration = null
	flags = DEL_ON_DEATH | INF_DURATION


/datum/effects/dancer_tag/New(var/atom/A, var/mob/from = null, var/last_dmg_source = null, var/zone = "chest", ttl = 35)
	. = ..(A, from, last_dmg_source, zone)

	add_timer(CALLBACK(GLOBAL_PROC, .proc/qdel, src), ttl)

	if (ishuman(A))
		var/mob/living/carbon/human/H = A
		H.update_xeno_hostile_hud()


/datum/effects/dancer_tag/validate_atom(mob/living/carbon/H)
	if (!isXenoOrHuman(H) || H.stat == DEAD)
		return FALSE
	return ..()


/datum/effects/dancer_tag/process_mob()
	. = ..()

	// Also checks for null atoms
	if (!istype(affected_atom, /mob/living/carbon/human))
		return 

	var/mob/living/carbon/human/H = affected_atom
	H.update_xeno_hostile_hud()


/datum/effects/dancer_tag/Dispose()
	if (!ishuman(affected_atom))
		return ..()

	var/mob/living/carbon/human/H = affected_atom
	add_timer(CALLBACK(H, /mob/living/carbon/human.proc/update_xeno_hostile_hud), 3)

	return ..()