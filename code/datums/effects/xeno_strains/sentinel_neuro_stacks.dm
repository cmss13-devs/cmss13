/datum/effects/sentinel_neuro_stacks
	effect_name = "Sentinel neuro spit stacks"
	duration = null
	flags = DEL_ON_DEATH | INF_DURATION // We always clean ourselves up

	var/stack_count = 0
	var/max_stacks = 30
	var/last_decrement_time = 0
	var/time_between_decrements = 1
	var/last_increment_time = 0
	var/increment_grace_time = 50
	var/proc_damage = 1

/datum/effects/sentinel_neuro_stacks/New(mob/living/carbon/human/H, mob/from = null, last_dmg_source = null, zone = "chest")
	last_decrement_time = world.time
	last_increment_time = world.time
	. = ..(H, from, last_dmg_source, zone)
	H.update_xeno_hostile_hud()


/datum/effects/sentinel_neuro_stacks/validate_atom(mob/living/carbon/human/H)
	if (H.stat == DEAD)
		return FALSE

	return ..()

/datum/effects/sentinel_neuro_stacks/process_mob()
	. = ..()
	if (!istype(affected_atom, /mob/living/carbon/human))
		return

	var/mob/living/carbon/human/H = affected_atom
	H.apply_damage(proc_damage, OXY)
	H.update_xeno_hostile_hud()

	if (last_decrement_time + time_between_decrements < world.time && !(last_increment_time + increment_grace_time > world.time))
		stack_count--
		last_decrement_time = world.time

		if (stack_count <= 0)
			qdel(src)
			return


/datum/effects/sentinel_neuro_stacks/Destroy()
	if (!ishuman(affected_atom))
		return ..()

	var/mob/living/carbon/human/human = affected_atom
	if(!QDELETED(human))
		addtimer(CALLBACK(human, TYPE_PROC_REF(/mob/living/carbon/human, update_xeno_hostile_hud)), 3)

	return ..()

/datum/effects/sentinel_neuro_stacks/proc/increment_stack_count(difference = 5)
	stack_count = min(max_stacks, floor( stack_count + difference))

	if(stack_count <= 0)
		qdel(src)
		return

	if (!istype(affected_atom, /mob/living/carbon/human))
		return

	var/mob/living/carbon/human/H = affected_atom
	H.update_xeno_hostile_hud()

	last_increment_time = world.time
