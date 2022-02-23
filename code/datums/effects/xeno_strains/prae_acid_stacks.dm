/datum/effects/prae_acid_stacks
	effect_name = "Praetorian acid spit stacks"
	duration = null
	flags = DEL_ON_DEATH | INF_DURATION // We always clean ourselves up

	var/stack_count = 1
	var/max_stacks = 5
	var/last_decrement_time = 0
	var/time_between_decrements = 40
	var/last_increment_time = 0
	var/increment_grace_time = 50
	var/proc_damage = 30

/datum/effects/prae_acid_stacks/New(mob/living/carbon/human/H, var/mob/from = null, var/last_dmg_source = null, var/zone = "chest")
	last_decrement_time = world.time
	last_increment_time = world.time
	. = ..(H, from, last_dmg_source, zone)
	H.update_xeno_hostile_hud()


/datum/effects/prae_acid_stacks/validate_atom(mob/living/carbon/human/H)
	if (H.stat == DEAD)
		return FALSE

	return ..()

/datum/effects/prae_acid_stacks/process_mob()
	. = ..()
	if (!istype(affected_atom, /mob/living/carbon/human))
		return

	if (last_decrement_time + time_between_decrements < world.time && !(last_increment_time + increment_grace_time > world.time))
		stack_count--
		last_decrement_time = world.time

		if (stack_count <= 0)
			qdel(src)
			return

	var/mob/living/carbon/human/H = affected_atom
	H.update_xeno_hostile_hud()


/datum/effects/prae_acid_stacks/Destroy()
	if (!ishuman(affected_atom))
		return ..()

	var/mob/living/carbon/human/H = affected_atom
	addtimer(CALLBACK(H, /mob/living/carbon/human.proc/update_xeno_hostile_hud), 3)

	return ..()

/datum/effects/prae_acid_stacks/proc/increment_stack_count(var/increment_number = 1)
	stack_count = min(max_stacks, stack_count + increment_number)

	if (!istype(affected_atom, /mob/living/carbon/human))
		return

	var/mob/living/carbon/human/H = affected_atom
	H.update_xeno_hostile_hud()

	last_increment_time = world.time

	if (stack_count == max_stacks)
		on_proc()

// What do to on proc
/datum/effects/prae_acid_stacks/proc/on_proc()
	if (!ishuman(affected_atom))
		return

	var/mob/living/carbon/human/H = affected_atom
	H.apply_damage(proc_damage, BURN)
	to_chat(H, SPAN_XENODANGER("You feel acid eat into your skin!"))
	qdel(src)
	return
