/datum/xeno_mutator/healer
	name = "STRAIN: Drone - Healer"
	description = "In exchange for your ability to build, you gain better pheromones, lesser resin fruits, and the ability to transfer life to other Xenomorphs. Be wary, this is a dangerous process, overexert yourself and you might die..."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_DRONE) //Only drone.
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/secrete_resin,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/transfer_plasma,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/onclick/plant_resin_fruit, // Second macro. Resin fruits belong to Gardener, but Healer has a minor variant
		/datum/action/xeno_action/activable/transfer_health, //Third macro.
		/datum/action/xeno_action/activable/transfer_plasma //fourth macro
		)
	keystone = TRUE


/datum/xeno_mutator/healer/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Drone/D = MS.xeno
	D.mutation_type = DRONE_HEALER
	D.phero_modifier += XENO_PHERO_MOD_LARGE
	D.plasma_types += PLASMA_PHEROMONE
	D.health_modifier += XENO_HEALTH_MOD_VERYLARGE // 500HP -> 600HP
	D.damage_modifier -= XENO_DAMAGE_MOD_SMALL
	D.max_placeable = 3
	D.tackle_chance_modifier -= 10
	mutator_update_actions(D)
	MS.recalculate_actions(description, flavor_description)
	D.recalculate_health()
	D.recalculate_damage()
	D.recalculate_pheromones()
	D.recalculate_tackle()
	D.available_placeable = list("Lesser Resin Fruit")

/*
	TRANSFER HEALTH
*/

/datum/action/xeno_action/activable/transfer_health
	name = "Transfer Health"
	action_icon_state = "transfer_health"
	ability_name = "transfer health"
	var/health_transfer_amount = 30
	var/transfer_delay = 2.5 SECONDS
	var/max_range = 2
	var/self_health_drain_mod = 1.2
	macro_path = /datum/action/xeno_action/verb/verb_transfer_health
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3

/datum/action/xeno_action/activable/transfer_health/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.xeno_transfer_health(A, health_transfer_amount, transfer_delay, max_range, self_health_drain_mod)
	..()

/datum/action/xeno_action/verb/verb_transfer_health()
	set category = "Alien"
	set name = "Transfer Health"
	set hidden = 1
	var/action_name = "Transfer Health"
	handle_xeno_macro(src, action_name)

/mob/living/carbon/Xenomorph/proc/xeno_transfer_health(mob/living/carbon/Xenomorph/target, amount = 30, transfer_delay = 2.5 SECONDS, max_range = 2, damage_taken_mod = 1.2)
	if(!istype(target))
		return

	if(target == src)
		to_chat(src, "You can't heal yourself!")
		return

	if(!check_state())
		return

	if(target.stat == DEAD)
		to_chat(src, SPAN_WARNING("[target] is already dead!"))
		return

	if(target.health >= target.maxHealth)
		to_chat(src, SPAN_WARNING("\The [target] is already at max health!"))
		return

	if(!isturf(loc))
		to_chat(src, SPAN_WARNING("You can't transfer health from here!"))
		return

	if(get_dist(src, target) > max_range)
		to_chat(src, SPAN_WARNING("You need to be closer to [target]."))
		return

	if(health <= 0)
		to_chat(src, SPAN_WARNING("You have no health left to give!"))
		return

	to_chat(src, SPAN_NOTICE("You start transfering some of your health towards [target]."))
	to_chat(target, SPAN_NOTICE("You feel that [src] starts transferring some of their health to you."))
	if(!do_after(src, transfer_delay, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, target, INTERRUPT_MOVED, BUSY_ICON_MEDICAL, numticks = 10))
		return

	if(!check_state())
		return

	if(target.stat == DEAD)
		to_chat(src, SPAN_WARNING("[target] is already dead!"))
		return

	if(target.health >= target.maxHealth)
		to_chat(src, SPAN_WARNING("\The [target] is already at max health!"))
		return

	if(!isturf(loc))
		to_chat(src, SPAN_WARNING("You can't transfer health from here!"))
		return

	if(get_dist(src, target) > max_range)
		to_chat(src, SPAN_WARNING("You need to be closer to [target]."))
		return

	if(health <= 0)
		to_chat(src, SPAN_WARNING("You have no health left to give!"))
		return

	adjustBruteLoss(amount * damage_taken_mod)
	updatehealth()
	target.gain_health(amount)
	target.updatehealth()
	to_chat(target, SPAN_XENOWARNING("\The [src] has transfered some of their health to you. You feel reinvigorated!"))
	to_chat(src, SPAN_XENOWARNING("You have transferred some of your health to \the [target]. You feel weakened..."))
	playsound(src, "alien_drool", 25)
