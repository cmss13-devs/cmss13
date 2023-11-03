/datum/xeno_mutator/healer
	name = "STRAIN: Drone - Healer"
	description = "You lose your choice of resin secretions, a chunk of your slash damage, and you will experience a slighty-increased difficulty in tackling tallhosts in exchange for strong pheromones, the ability to use a bit of your health to plant a maximum of three lesser resin fruits, and the ability to heal your sisters' wounds by secreting a regenerative resin salve by using your vital fluids and a fifth of your plasma. Be wary, this is a dangerous process; overexert yourself and you may exhaust yourself to unconsciousness, or die..."
	flavor_description = "To the very last drop, your blood belongs to The Hive; share it with your sisters to keep them fighting."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_DRONE) //Only drone.
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/secrete_resin,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/transfer_plasma,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/onclick/plant_resin_fruit, // Second macro. Resin fruits belong to Gardener, but Healer has a minor variant.
		/datum/action/xeno_action/activable/apply_salve, //Third macro, heal over time ability.
		/datum/action/xeno_action/activable/transfer_plasma/healer, //Fourth macro, an improved plasma transfer.
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
	drone.damage_modifier -= XENO_DAMAGE_MOD_VERY_SMALL

	drone.max_placeable = 3
	drone.available_fruits = list(/obj/effect/alien/resin/fruit)
	drone.selected_fruit = /obj/effect/alien/resin/fruit
	drone.tackle_chance_modifier -= 5
	mutator_update_actions(drone)
	apply_behavior_holder(drone)
	mutator_set.recalculate_actions(description, flavor_description)
	drone.recalculate_health()
	drone.recalculate_damage()
	drone.recalculate_pheromones()
	drone.recalculate_tackle()

/*
	Improved Plasma Transfer
*/

/datum/action/xeno_action/activable/transfer_plasma/healer //Improved plasma transfer, but not as much as Hivey.
	ability_primacy = XENO_PRIMARY_ACTION_4
	plasma_transfer_amount = 100
	transfer_delay = 15
	max_range = 1

/*
	Apply Resin Salve
*/

/datum/action/xeno_action/activable/apply_salve
	name = "Apply Resin Salve"
	action_icon_state = "apply_salve"
	ability_name = "Apply Resin Salve"
	var/health_transfer_amount = 100
	var/max_range = 1
	var/damage_taken_mod = 0.75
	macro_path = /datum/action/xeno_action/verb/verb_apply_salve
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3

/datum/action/xeno_action/activable/apply_salve/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.xeno_apply_salve(target_atom, health_transfer_amount, max_range, damage_taken_mod)
	return ..()

/datum/action/xeno_action/verb/verb_apply_salve()
	set category = "Alien"
	set name = "Apply Resin Salve"
	set hidden = TRUE
	var/action_name = "Apply Resin Salve"
	handle_xeno_macro(src, action_name)

/mob/living/carbon/xenomorph/proc/xeno_apply_salve(mob/living/carbon/xenomorph/target_xeno, amount = 100, max_range = 1, damage_taken_mod = 0.75)

	if(!check_plasma(amount * 2))
		return

	if(!istype(target_xeno))
		return

	if(target_xeno == src)
		to_chat(src, SPAN_XENOWARNING("You can't heal yourself with your own resin salve!"))
		return

	if(!check_state())
		return

	if(SEND_SIGNAL(target_xeno, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
		to_chat(src, SPAN_XENOWARNING("Extinguish [target_xeno] first or the flames will burn your resin salve away!"))
		return

	if(!can_not_harm(target_xeno)) //We don't wanna heal hostile hives, but we do want to heal our allies!
		to_chat(src, SPAN_XENOWARNING("[target_xeno] is hostile to your hive! Go find one of your sisters or allies!"))
		return

	if(!isturf(loc))
		to_chat(src, SPAN_XENOWARNING("You can't apply your resin salve from here!"))
		return

	if(get_dist(src, target_xeno) > max_range)
		to_chat(src, SPAN_XENOWARNING("You need to be closer to [target_xeno] to apply your resin salve!"))
		return

	if(target_xeno.stat == DEAD)
		to_chat(src, SPAN_XENOWARNING("[target_xeno] is dead!"))
		return

	if(target_xeno.health >= target_xeno.maxHealth)
		to_chat(src, SPAN_XENOWARNING("[target_xeno] is already at max health!"))
		return

///Tiny xenos (Larva and Facehuggers), don't need as much health so don't cost as much.
	if(target_xeno.mob_size == 0)
		amount = amount * 0.15
		damage_taken_mod = 1

//Forces an equivalent exchange of health between healers so they do not spam heal each other to full health.
	if(target_xeno.mutation_type == DRONE_HEALER)
		damage_taken_mod = 1

	face_atom(target_xeno)
	adjustBruteLoss(amount * damage_taken_mod)
	use_plasma(amount * 2)
	updatehealth()
	new /datum/effects/heal_over_time(target_xeno, amount, 10, 1)
	target_xeno.xeno_jitter(1 SECONDS)
	target_xeno.flick_heal_overlay(10 SECONDS, "#00be6f")
	to_chat(target_xeno, SPAN_XENOWARNING("[src] covers your wounds with a regenerative resin salve. You feel reinvigorated!"))
	to_chat(src, SPAN_XENOWARNING("You regurgitate your vital fluids and some plasma to create a regenerative resin salve and apply it to [target_xeno]'s wounds. You feel weakened..."))
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
	else if(bound_xeno.body_position == LYING_DOWN)
		if(!HAS_TRAIT(bound_xeno, TRAIT_INCAPACITATED) && !HAS_TRAIT(bound_xeno, TRAIT_FLOORED))
			salve_applied_icon.icon_state = "Healer Drone Sleeping"
		else
			salve_applied_icon.icon_state = "Healer Drone Knocked Down"
	else
		salve_applied_icon.icon_state = "Healer Drone Walking"

	bound_xeno.overlays += salve_applied_icon

/datum/behavior_delegate/drone_healer/proc/un_salve()
	salve_applied_recently = FALSE
	bound_xeno.update_icons()
