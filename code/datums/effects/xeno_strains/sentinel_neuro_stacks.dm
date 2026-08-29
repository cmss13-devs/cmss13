#define COOLDOWN_START_DECREMENT "cooldown_start_decrement"
#define COOLDOWN_NEXT_DECREMENT "cooldown_next_decrement"

/datum/effects/sentinel_neuro_stacks
	effect_name = "Sentinel neuro spit stacks"
	duration = null
	flags = DEL_ON_DEATH | INF_DURATION // We always clean ourselves up
	///number of stacks on mob
	var/stack_count = 0
	///maximal number of stacks on mob
	var/max_stacks = 30
	///number of ticks of waiting for next decrease
	var/time_between_decrements = 1
	///how long should pass from last increase till decreasing begins
	var/increment_grace_time = 50
	///how much oxy damage should be given per process
	var/proc_damage_per_stack = 0.2
	///Maximum oxyloss is clamped between these two bounds, this prevents someone from achieving high oxyloss by keeping someone on 5-10 stacks for a long time. To get high damage, you need high stacks.
	var/max_oxyloss_lower_bound = 10
	var/max_oxyloss_upper_bound = 40
	var/max_oxyloss = 10
	///particles
	var/obj/effect/abstract/particle_holder/particle_holder

/datum/effects/sentinel_neuro_stacks/New(mob/living/carbon/human/human, mob/from = null, last_dmg_source = null, zone = "chest")
	S_TIMER_COOLDOWN_START(src, COOLDOWN_START_DECREMENT, increment_grace_time)
	particle_holder = new(human, /particles/neuro_particles)
	particle_holder.particles.spawning = 1 + round(stack_count / 2)
	particle_holder.pixel_x = -2
	particle_holder.pixel_y = 0
	. = ..(human, from, last_dmg_source, zone)
	human.update_xeno_hostile_hud()

/datum/effects/sentinel_neuro_stacks/validate_atom(mob/living/carbon/human/human)
	if (human.stat == DEAD || !ishuman(human))
		return FALSE

	return ..()

/datum/effects/sentinel_neuro_stacks/process_mob()
	. = ..()

	var/mob/living/carbon/human/human = affected_atom
	var/stack_ratio = stack_count / max_stacks
	max_oxyloss = max_oxyloss_lower_bound + (stack_ratio * (max_oxyloss_upper_bound - max_oxyloss_lower_bound))
	if(human.oxyloss < max_oxyloss)
		human.apply_damage(min(max_oxyloss - human.oxyloss, proc_damage_per_stack * stack_count, 5), OXY)
	human.update_xeno_hostile_hud()

	if (!TIMER_COOLDOWN_CHECK(src, COOLDOWN_NEXT_DECREMENT) && !TIMER_COOLDOWN_CHECK(src, COOLDOWN_START_DECREMENT))
		stack_count--
		S_TIMER_COOLDOWN_RESET(src, COOLDOWN_NEXT_DECREMENT)
		S_TIMER_COOLDOWN_START(src, COOLDOWN_NEXT_DECREMENT, time_between_decrements)

		if (stack_count <= 0)
			qdel(src)
			return
	if(particle_holder)
		particle_holder.particles.spawning = 1 + round(stack_count / 2)


/datum/effects/sentinel_neuro_stacks/Destroy()
	QDEL_NULL(particle_holder)
	if (!ishuman(affected_atom))
		return ..()

	var/mob/living/carbon/human/human = affected_atom
	if(!QDELETED(human))
		human.update_xeno_hostile_hud()
		human.med_hud_set_health()

	return ..()

/datum/effects/sentinel_neuro_stacks/proc/increment_stack_count(difference = 5)
	stack_count = min(max_stacks, floor(stack_count + difference))

	if(stack_count <= 0)
		qdel(src)
		return

	if (!istype(affected_atom, /mob/living/carbon/human))
		return
	S_TIMER_COOLDOWN_RESET(src, COOLDOWN_START_DECREMENT)
	S_TIMER_COOLDOWN_START(src, COOLDOWN_START_DECREMENT, increment_grace_time)

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

