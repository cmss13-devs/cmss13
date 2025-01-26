/datum/xeno_strain/scout
	name = "Scout"
	description = "You lose your plasma pool, You gain ability to speed you up and see far, but your slash weaker when you sprinting."
	flavor_description = "Run! Mini rouney! Run!"
	icon_state_prefix = "Scout"

	actions_to_remove = list(
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/activable/corrosive_acid/weak,
		/datum/action/xeno_action/onclick/plant_weeds/lesser,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/secrete_resin,
	)
	actions_to_add = list(
		/datum/action/xeno_action/onclick/lesser_run,
		/datum/action/xeno_action/onclick/toggle_long_range/lesser_scout,
	)

/datum/xeno_strain/scout/apply_strain(mob/living/carbon/xenomorph/lesser_drone/lesser)
	lesser.health_modifier -= XENO_HEALTH_MOD_SMALL

	lesser.recalculate_everything()
	lesser.viewsize = 9
	lesser.recalculate_everything()

//	Способности

/datum/action/xeno_action/onclick/toggle_long_range/lesser_scout
	handles_movement = FALSE
	should_delay = FALSE
	ability_primacy = XENO_PRIMARY_ACTION_3

/datum/action/xeno_action/onclick/lesser_run
	name = "On four paws"
	action_icon_state = "agility_on"
	macro_path = /datum/action/xeno_action/verb/verb_lesser_shield
	ability_primacy = XENO_PRIMARY_ACTION_1
	plasma_cost = 100
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 45 SECONDS
	cooldown_message = "We rest and ready to run again."
	var/speed_bonus = XENO_SPEED_TIER_8

/datum/action/xeno_action/verb/verb_lesser_run()
	set category = "Alien"
	set name = "On four paws"
	set hidden = TRUE
	var/action_name = "lesser_run"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/onclick/lesser_run/use_ability(atom/Target)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] stand on four paws and ready to run!"), SPAN_XENOHIGHDANGER("We stand on four paws and run much faster!"))
	button.icon_state = "template_active"

	xeno.speed_modifier += speed_bonus
	xeno.damage_modifier -= XENO_DAMAGE_MOD_SMALL
	xeno.recalculate_everything()

	addtimer(CALLBACK(src, PROC_REF(remove_lesser_run)), 150, TIMER_UNIQUE|TIMER_OVERRIDE)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/lesser_run/proc/remove_lesser_run()
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.speed_modifier = initial(xeno.speed_modifier)
	xeno.damage_modifier = initial(xeno.damage_modifier)
	xeno.recalculate_everything()
	to_chat(xeno, SPAN_XENOHIGHDANGER("We tired to run"))
	button.icon_state = "template"
