/datum/xeno_mutator/healer
	name = "STRAIN: Drone - Healer"
	description = "You trade your choice of resin secretions and ten slash damage for 100 more health, strong pheromones, lesser resin fruits, and the ability to heal your sisters' wounds by secreting a regenerative resin salve using your vital fluids. Be wary, this is a dangerous process; overexert yourself and you may die..."
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
		/datum/action/xeno_action/activable/apply_salve, //Third macro.
		/datum/action/xeno_action/activable/transfer_plasma //fourth macro
		)
	keystone = TRUE
	behavior_delegate_type = /datum/behavior_delegate/drone_healer


/datum/xeno_mutator/healer/apply_mutator(datum/mutator_set/individual_mutators/mutator_set)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/xenomorph/drone/drone = mutator_set.xeno
	drone.mutation_type = DRONE_HEALER
	drone.phero_modifier += XENO_PHERO_MOD_LARGE
	drone.plasma_types += PLASMA_PHEROMONE
	drone.health_modifier += XENO_HEALTH_MOD_VERYLARGE // 500HP -> 600HP
	drone.damage_modifier -= XENO_DAMAGE_MOD_SMALL
	drone.max_placeable = 3
	drone.available_fruits = list(/obj/effect/alien/resin/fruit)
	drone.selected_fruit = /obj/effect/alien/resin/fruit
	drone.tackle_chance_modifier -= 10
	mutator_update_actions(drone)
	apply_behavior_holder(drone)
	mutator_set.recalculate_actions(description, flavor_description)
	drone.recalculate_health()
	drone.recalculate_damage()
	drone.recalculate_pheromones()
	drone.recalculate_tackle()

/*
	Apply Resin Salve
*/

/datum/action/xeno_action/activable/apply_salve
	name = "Apply Resin Salve"
	action_icon_state = "apply_salve"
	ability_name = "Apply Resin Salve"
	var/health_transfer_amount = 100
	var/max_range = 1
	var/self_health_drain_mod = 1.2
	macro_path = /datum/action/xeno_action/verb/verb_apply_salve
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3

/datum/action/xeno_action/activable/apply_salve/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.xeno_apply_salve(target_atom, health_transfer_amount, max_range, self_health_drain_mod)
	..()

/datum/action/xeno_action/verb/verb_apply_salve()
	set category = "Alien"
	set name = "Apply Resin Salve"
	set hidden = TRUE
	var/action_name = "Apply Resin Salve"
	handle_xeno_macro(src, action_name)

/mob/living/carbon/xenomorph/proc/xeno_apply_salve(mob/living/carbon/xenomorph/target_xeno, amount = 100, max_range = 1, damage_taken_mod = 1.2)

	if(!istype(target_xeno))
		return

	if(target_xeno == src)
		to_chat(src, "You can't heal yourself with your own resin!")
		return

	if(!check_state())
		return

	if (SEND_SIGNAL(target_xeno, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
		to_chat(src, SPAN_XENOWARNING("Extinguish [target_xeno] first or the flames will burn your resin salve away!"))
		return

	if(!can_not_harm(target_xeno)) //We don't wanna heal hostile hives, but we do want to heal our allies!
		to_chat(src, SPAN_WARNING("[target_xeno] is hostile to your hive, so your regenerative resin is incompatible!"))
		return

	if(!isturf(loc))
		to_chat(src, SPAN_WARNING("You can't apply your regenerative resin from here!"))
		return

	if(get_dist(src, target_xeno) > max_range)
		to_chat(src, SPAN_WARNING("You need to be closer to [target_xeno]."))
		return

	if(target_xeno.stat == DEAD)
		to_chat(src, SPAN_WARNING("[target_xeno] is dead!"))
		return

	if(target_xeno.health >= target_xeno.maxHealth)
		to_chat(src, SPAN_WARNING("\The [target_xeno] is already at max health!"))
		return

	if(health <= 0)
		to_chat(src, SPAN_WARNING("You do not have enough health to make regenerative resin!"))
		return

	adjustBruteLoss(amount * damage_taken_mod)
	updatehealth()
	new /datum/effects/heal_over_time(target_xeno, amount, 12, 2) //Healer now sacrifices the same amount of health that will heal the other xenomorph. Previously, she healed 100 damage while sacrificing 120 health of her own. That is not the law of equivalent exchange!
	target_xeno.xeno_jitter(1 SECONDS)
	target_xeno.flick_heal_overlay(10 SECONDS, "#00be6f")
	to_chat(target_xeno, SPAN_XENOWARNING("\The [src] covers your wounds with regenerative resin. You feel reinvigorated!"))
	to_chat(src, SPAN_XENOWARNING("You regurgitate your vital fluids to create a regenerative resin and apply it to \the [target_xeno]'s wounds. You feel weakened...")) //The vital fluids mix with sticky saliva.
	playsound(src, "alien_drool", 25)
	var/datum/behavior_delegate/drone_healer/healer_delegate = src.behavior_delegate
	healer_delegate.salve_applied_recently = TRUE
	update_icons()
	addtimer(CALLBACK(healer_delegate, /datum/behavior_delegate/drone_healer/proc/un_salve), 10 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE)

/datum/behavior_delegate/drone_healer
	name = "Healer Drone Behavior Delegate"

	var/salve_applied_recently = FALSE
	var/mutable_appearance/salve_applied_icon

/datum/behavior_delegate/drone_healer/on_update_icons()
	if(!salve_applied_icon)
		salve_applied_icon = mutable_appearance('icons/mob/xenos/drone_strain_overlays.dmi',"Healer Drone Walking")

	bound_xeno.overlays -= salve_applied_icon
	salve_applied_icon.overlays.Cut()

	if(!salve_applied_recently)
		return

	if(bound_xeno.stat == DEAD)
		salve_applied_icon.icon_state = "Healer Drone Dead"
	else if(bound_xeno.lying)
		if((bound_xeno.resting || bound_xeno.sleeping) && (!bound_xeno.knocked_down && !bound_xeno.knocked_out && bound_xeno.health > 0))
			salve_applied_icon.icon_state = "Healer Drone Sleeping"
		else
			salve_applied_icon.icon_state = "Healer Drone Knocked Down"
	else
		salve_applied_icon.icon_state = "Healer Drone Walking"

	bound_xeno.overlays += salve_applied_icon

/datum/behavior_delegate/drone_healer/proc/un_salve()
	salve_applied_recently = FALSE
	bound_xeno.update_icons()
