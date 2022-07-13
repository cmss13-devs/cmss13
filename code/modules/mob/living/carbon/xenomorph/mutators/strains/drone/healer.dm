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
	D.available_fruits = list(/obj/effect/alien/resin/fruit)
	D.selected_fruit = /obj/effect/alien/resin/fruit
	D.tackle_chance_modifier -= 10
	mutator_update_actions(D)
	MS.recalculate_actions(description, flavor_description)
	D.recalculate_health()
	D.recalculate_damage()
	D.recalculate_pheromones()
	D.recalculate_tackle()

/*
	TRANSFER HEALTH
*/

/datum/action/xeno_action/activable/transfer_health
	name = "Transfer Health"
	action_icon_state = "transfer_health"
	ability_name = "transfer health"
	var/health_transfer_amount = 100
	var/max_range = 1
	var/self_health_drain_mod = 1.2
	macro_path = /datum/action/xeno_action/verb/verb_transfer_health
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3

/datum/action/xeno_action/activable/transfer_health/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.xeno_transfer_health(A, health_transfer_amount, max_range, self_health_drain_mod)
	..()

/datum/action/xeno_action/verb/verb_transfer_health()
	set category = "Alien"
	set name = "Transfer Health"
	set hidden = 1
	var/action_name = "Transfer Health"
	handle_xeno_macro(src, action_name)

/mob/living/carbon/Xenomorph/proc/xeno_transfer_health(mob/living/carbon/Xenomorph/target, amount = 100, max_range = 1, damage_taken_mod = 1.2)
	if(!istype(target))
		return

	if(target == src)
		to_chat(src, "You can't heal yourself!")
		return

	if(!check_state())
		return

	if(!isturf(loc))
		to_chat(src, SPAN_WARNING("You can't transfer health from here!"))
		return

	if(get_dist(src, target) > max_range)
		to_chat(src, SPAN_WARNING("You need to be closer to [target]."))
		return

	if(target.stat == DEAD)
		to_chat(src, SPAN_WARNING("[target] is already dead!"))
		return

	if(target.health >= target.maxHealth)
		to_chat(src, SPAN_WARNING("\The [target] is already at max health!"))
		return

	if(health <= 0)
		to_chat(src, SPAN_WARNING("You have no health left to give!"))
		return

	adjustBruteLoss(amount * damage_taken_mod)
	updatehealth()
	new /datum/effects/heal_over_time(target, amount, 10, 2)
	target.xeno_jitter(1 SECONDS)
	target.flick_heal_overlay(10 SECONDS, "#00be6f")
	to_chat(target, SPAN_XENOWARNING("\The [src] has transfered some of their health to you. You feel reinvigorated!"))
	to_chat(src, SPAN_XENOWARNING("You have transferred some of your health to \the [target]. You feel weakened..."))
	playsound(src, "alien_drool", 25)
