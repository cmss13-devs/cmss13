/datum/effects/sentinel_neuro_stacks
	effect_name = "Sentinel neuro spit stacks"
	duration = null
	flags = DEL_ON_DEATH | INF_DURATION // We always clean ourselves up
	///number of stacks on mob
	var/stack_count = 0
	///maximal number of stacks on mob
	var/max_stacks = 30
	///word time when was stack count decreased
	var/last_decrement_time = 0
	///number of ticks of waiting for next decrease
	var/time_between_decrements = 1
	///word time of last stack increase
	var/last_increment_time = 0
	///how long should pass from last increase till decreasing begins
	var/increment_grace_time = 50
	///how much oxy damage should be given per process
	var/proc_damage = 1
	///stopgrap for oxy damage on mob when this stops causing harm
	var/max_oxyloss = 20
	///particles
	var/obj/effect/abstract/particle_holder/particle_holder

/datum/effects/sentinel_neuro_stacks/New(mob/living/carbon/human/human, mob/from = null, last_dmg_source = null, zone = "chest")
	last_decrement_time = world.time
	last_increment_time = world.time
	particle_holder = new(human, /particles/neuro_particles)
	particle_holder.particles.spawning = 1 + round(stack_count / 2)
	particle_holder.pixel_x = -2
	particle_holder.pixel_y = 0
	. = ..(human, from, last_dmg_source, zone)
	human.update_xeno_hostile_hud()


/datum/effects/sentinel_neuro_stacks/validate_atom(mob/living/carbon/human/human)
	if (human.stat == DEAD)
		return FALSE

	return ..()

/datum/effects/sentinel_neuro_stacks/process_mob()
	. = ..()
	if (!istype(affected_atom, /mob/living/carbon/human))
		return

	var/mob/living/carbon/human/human = affected_atom
	if(human.oxyloss < max_oxyloss)
		human.apply_damage(proc_damage, OXY)
	human.update_xeno_hostile_hud()

	if (last_decrement_time + time_between_decrements < world.time && !(last_increment_time + increment_grace_time > world.time))
		stack_count--
		last_decrement_time = world.time

		if (stack_count <= 0)
			qdel(src)
			return
	particle_holder.particles.spawning = 1 + round(stack_count / 2)


/datum/effects/sentinel_neuro_stacks/Destroy()
	if (!ishuman(affected_atom))
		return ..()

	var/mob/living/carbon/human/human = affected_atom
	QDEL_NULL(particle_holder)
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

	var/mob/living/carbon/human/human = affected_atom
	human.update_xeno_hostile_hud()

	last_increment_time = world.time

/particles/neuro_particles
	icon = 'icons/effects/particles/generic_particles.dmi'
	icon_state = "x"
	width = 100
	height = 100
	count = 1000
	spawning = 4
	lifespan = 9
	fade = 10
	grow = 0.2
	velocity = list(0, 0)
	position = generator(GEN_CIRCLE, 10, 10, NORMAL_RAND)
	drift = generator(GEN_VECTOR, list(0, -0.15), list(0, 0.15))
	gravity = list(0, 0.4)
	scale = generator(GEN_VECTOR, list(0.3, 0.3), list(0.9,0.9), NORMAL_RAND)
	rotation = 0
	spin = generator(GEN_NUM, 10, 20)
	color = "#7DCC00"

