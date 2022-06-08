/datum/xeno_mutator/striker
	name = "STRAIN: Boiler - Striker"
	description = "You trade your globs and some health for a long ranged high damage shot, long ranged fragmentation acid, and the spit in quick succession if you manage to hit three hosts in a row. You will also be granted the ability to spray slime."
	flavor_description = "We can do it, yes we can!."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_BOILER) //Only boiler.
	mutator_actions_to_remove = list( ////// todo: remove actions
		/datum/action/xeno_action/activable/bombard,
		/datum/action/xeno_action/activable/acid_lance,
		/datum/action/xeno_action/onclick/dump_acid,
	) /////////////// todo: put the actions you want here
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/onclick/toggle_long_range/trapper
	)
	keystone = TRUE

	behavior_delegate_type = /datum/behavior_delegate/boiler_striker

/datum/xeno_mutator/striker/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if(. == 0)
		return

	var/mob/living/carbon/Xenomorph/Boiler/B = MS.xeno
	if(B.is_zoomed)
		B.zoom_out()

	B.mutation_type = BOILER_STRIKER
	B.plasma_types -= PLASMA_NEUROTOXIN
	B.spit_types = list(/datum/ammo/xeno/acid/praetorian)
	B.spit_delay = 5 SECONDS
	B.spit_windup = 3 SECONDS

	//B.speed_modifier += XENO_SPEED_SLOWMOD_TIER_1
	B.recalculate_everything()

	apply_behavior_holder(B)

	mutator_update_actions(B)
	MS.recalculate_actions(description, flavor_description)


/datum/behavior_delegate/boiler_striker
	name = "Boiler striker Behavior Delegate"

	// Config
	var/temp_movespeed_amount = 1.25
	var/temp_movespeed_duration = 50
	var/temp_movespeed_cooldown = 200
	var/bonus_damage_shotgun_trapped = 7.5

	// State
	var/temp_movespeed_time_used = 0
	var/temp_movespeed_usable = FALSE
	var/temp_movespeed_messaged = FALSE
