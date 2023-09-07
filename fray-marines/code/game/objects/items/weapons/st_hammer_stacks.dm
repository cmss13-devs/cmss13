/datum/effects/hammer_stacks
	effect_name = "Stormtrooper hammer combo stack"
	duration = null
	flags = INF_DURATION // We always clean ourselves up

	var/stack_count = 1
	var/max_stacks = 4
	var/last_decrement_time = 0
	var/time_between_decrements = 40
	var/last_increment_time = 0
	var/increment_grace_time = 50
	var/combo_sound = 'sound/effects/alien_tail_swipe2.ogg'
	var/combo_hit_sound = 'sound/effects/slam1.ogg'

/datum/effects/hammer_stacks/New(mob/living/carbon/xenomorph/X, mob/from = null, last_dmg_source = null, zone = "chest")
	last_decrement_time = world.time
	last_increment_time = world.time
	. = ..(X, from, last_dmg_source, zone)


/datum/effects/hammer_stacks/validate_atom(mob/living/carbon/xenomorph/X)
	if (!isxeno(X))
		return FALSE

	return ..()

/datum/effects/hammer_stacks/process_mob()
	. = ..()
	if (!isxeno(affected_atom))
		return

	if (last_decrement_time + time_between_decrements < world.time && !(last_increment_time + increment_grace_time > world.time))
		stack_count--
		last_decrement_time = world.time

		if (stack_count <= 0)
			qdel(src)
			return

	// TODO: добавить оверлей на ксене

/datum/effects/hammer_stacks/Destroy()
	if (!isxeno(affected_atom))
		return ..()

	// TODO: впилить удаление оверлея

	return ..()

/datum/effects/hammer_stacks/proc/increment_stack_count(increment_number = 1, mob/living/carbon/human/attacker)
	stack_count = min(max_stacks, stack_count + increment_number)

	if (!isxeno(affected_atom))
		return

	var/mob/living/carbon/xenomorph/X = affected_atom
	// TODO: добавить оверлей на ксене

	last_increment_time = world.time
	var/throw_range = 1

	if (prob(25)) X.emote("roar")

	if (stack_count > 0) X.apply_effect(3, SLOW)
	if (stack_count > 1) X.apply_effect(1, SUPERSLOW)
	if (stack_count > 2) X.apply_effect(2, SUPERSLOW)
	if (stack_count > 3)
		playsound(attacker, combo_sound, 85, 1)
		playsound(X, combo_hit_sound, 45, 1)
		if (X.stat != DEAD)
			attacker.apply_effect(1, STUN)
		attacker.spin_circle(1, 1.5)

		shake_camera(X, 1, 4)
		if (X.mob_size >= MOB_SIZE_IMMOBILE)
			X.apply_effect(2, SUPERSLOW)
			qdel(src)
			return

		X.apply_effect(2, WEAKEN)
		if (!X.anchored)
			var/turf/throw_to = get_step_away(X, attacker)
			X.throw_atom(throw_to, throw_range)
			qdel(src)



