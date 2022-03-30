/datum/action/xeno_action/onclick/toggle_speed/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Hivelord/X = owner
	if(!X.check_state())
		return

	X.recalculate_move_delay = TRUE

	if(X.weedwalking_activated)
		to_chat(X, SPAN_WARNING("You feel less in tune with the resin."))
		X.weedwalking_activated = 0
		return

	if(!X.check_plasma(plasma_cost))
		return
	X.weedwalking_activated = 1
	X.use_plasma(plasma_cost)
	to_chat(X, SPAN_NOTICE("You become one with the resin. You feel the urge to run!"))

/datum/action/xeno_action/activable/spore_puff/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!istype(X) || !X.check_state() || !action_cooldown_check() || X.action_busy)
		return FALSE

	var/turf/T = get_turf(A)

	if(isnull(T) || istype(T, /turf/closed) || !T.can_bombard(owner))
		to_chat(X, SPAN_XENODANGER("You can't bombard that!"))
		return FALSE

	if (!check_plasma_owner())
		return FALSE

	if(T.z != X.z)
		to_chat(X, SPAN_WARNING("That target is too far away!"))
		return FALSE

	var/atom/bombard_source = get_bombard_source()
	if (!X.can_bombard_turf(T, range, bombard_source))
		return FALSE

	for (var/action_type in action_types_to_cd)
		var/datum/action/xeno_action/XA = get_xeno_action_by_type(X, action_type)
		if (!istype(XA))
			continue

		XA.apply_cooldown_override(cooldown_duration)

	apply_cooldown()
	..()

	X.visible_message(SPAN_XENODANGER("[X] spews out spores!"), SPAN_XENODANGER("you release spores!"))
	if (!do_after(X, activation_delay, BUSY_ICON_HOSTILE))
		to_chat(X, SPAN_XENODANGER("You decide to cancel your bombard."))
		return FALSE

	if (!X.can_bombard_turf(T, range, bombard_source)) //Second check in case something changed during the do_after.
		return FALSE

	if (!check_and_use_plasma_owner())
		return FALSE

	X.visible_message(SPAN_XENODANGER("[X] launches a cloud of spores at [A]!"), SPAN_XENODANGER("You launch a cloud of spores at [A]!"))
	playsound(get_turf(X), 'sound/effects/blobattack.ogg', 25, 1)

	recursive_spread(T, effect_range, effect_range)

	return ..()

/datum/action/xeno_action/activable/spore_puff/proc/recursive_spread(turf/T, dist_left, orig_depth)
	if(!istype(T))
		return
	else if(dist_left == 0)
		return
	else if(istype(T, /turf/closed) || istype(T, /turf/open/space))
		return
	else if(!T.can_bombard(owner))
		return

	addtimer(CALLBACK(src, .proc/new_effect, T, owner), 2*(orig_depth - dist_left))

	for(var/mob/living/L in T)
		to_chat(L, SPAN_XENOHIGHDANGER("You see a cloud of spores flying towards you!"))

	for(var/dirn in alldirs)
		recursive_spread(get_step(T, dirn), dist_left - 1, orig_depth)


/datum/action/xeno_action/activable/spore_puff/proc/new_effect(turf/T, mob/living/carbon/Xenomorph/X)
	if(!istype(T))
		return

	for(var/obj/effect/xenomorph/spore_puff/SP in T)
		return

	new effect_type(T, X)

/datum/action/xeno_action/activable/spore_puff/proc/get_bombard_source()
	return owner



/datum/action/xeno_action/activable/spore_puff_shield/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!istype(X) || !X.check_state() || !action_cooldown_check() || X.action_busy)
		return FALSE

	var/turf/T = get_turf(A)

	if(isnull(T) || istype(T, /turf/closed) || !T.can_bombard(owner))
		to_chat(X, SPAN_XENODANGER("You can't bombard that!"))
		return FALSE

	if (!check_plasma_owner())
		return FALSE

	if(T.z != X.z)
		to_chat(X, SPAN_WARNING("That target is too far away!"))
		return FALSE

	var/atom/bombard_source = get_bombard_source()
	if (!X.can_bombard_turf(T, range, bombard_source))
		return FALSE

	for (var/action_type in action_types_to_cd)
		var/datum/action/xeno_action/XA = get_xeno_action_by_type(X, action_type)
		if (!istype(XA))
			continue

		XA.apply_cooldown_override(cooldown_duration)

	apply_cooldown()
	..()

	X.visible_message(SPAN_XENODANGER("[X] spews out spores!"), SPAN_XENODANGER("You you release spores!"))
	if (!do_after(X, activation_delay, BUSY_ICON_HOSTILE))
		to_chat(X, SPAN_XENODANGER("You decide to cancel your bombard."))
		return FALSE

	if (!X.can_bombard_turf(T, range, bombard_source)) //Second check in case something changed during the do_after.
		return FALSE

	if (!check_and_use_plasma_owner())
		return FALSE

	X.visible_message(SPAN_XENODANGER("[X] launches a cloud of spores at [A]!"), SPAN_XENODANGER("You launch a cloud of spores at [A]!"))
	playsound(get_turf(X), 'sound/effects/blobattack.ogg', 25, 1)

	recursive_spread(T, effect_range, effect_range)

	return ..()

/datum/action/xeno_action/activable/spore_puff_shield/proc/recursive_spread(turf/T, dist_left, orig_depth)
	if(!istype(T))
		return
	else if(dist_left == 0)
		return
	else if(istype(T, /turf/closed) || istype(T, /turf/open/space))
		return
	else if(!T.can_bombard(owner))
		return

	addtimer(CALLBACK(src, .proc/new_effect, T, owner), 2*(orig_depth - dist_left))

	for(var/mob/living/L in T)
		to_chat(L, SPAN_XENOHIGHDANGER("You see a massive cloud of spores flying towards you!"))

	for(var/dirn in alldirs)
		recursive_spread(get_step(T, dirn), dist_left - 1, orig_depth)


/datum/action/xeno_action/activable/spore_puff_shield/proc/new_effect(turf/T, mob/living/carbon/Xenomorph/X)
	if(!istype(T))
		return

	for(var/obj/effect/xenomorph/spore_puff_shield/SP in T)
		return

	new effect_type(T, X)

/datum/action/xeno_action/activable/spore_puff_shield/proc/get_bombard_source()
	return owner
