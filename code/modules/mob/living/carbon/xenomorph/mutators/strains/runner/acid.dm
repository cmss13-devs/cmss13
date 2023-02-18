/datum/xeno_mutator/acider
	name = "STRAIN: Runner - Acider"
	description = "You exchange all your abilities for a new organ that is filled with volatile and explosive acid. Your slashes apply acid to living lifeforms that slowly burns them, and you gain powerful acid to melt items and defenses. You can force your body to explode, covering everything with acid, but that process takes 20 seconds and is noticable to people around you."
	flavor_description = "Burn their walls, maim their face!"
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_RUNNER)
	keystone = TRUE
	behavior_delegate_type = /datum/behavior_delegate/runner_acider
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/pounce/runner,
		/datum/action/xeno_action/activable/runner_skillshot,
		/datum/action/xeno_action/onclick/toggle_long_range/runner,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/acider_acid,
		/datum/action/xeno_action/activable/acider_for_the_hive,
	)

/datum/xeno_mutator/acider/apply_mutator(datum/mutator_set/individual_mutators/mutator_set)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/xenomorph/runner/runner = mutator_set.xeno
	runner.mutation_icon_state = RUNNER_ACIDER
	runner.mutation_type = RUNNER_ACIDER
	runner.speed_modifier += XENO_SPEED_SLOWMOD_TIER_5
	runner.armor_modifier += XENO_ARMOR_MOD_MED
	runner.health_modifier += XENO_HEALTH_MOD_ACIDER
	mutator_update_actions(runner)
	apply_behavior_holder(runner)
	runner.recalculate_everything()
	mutator_set.recalculate_actions(description, flavor_description)

/datum/behavior_delegate/runner_acider
	var/acid_amount = 0
	var/max_acid = 1000
	var/acid_slash_regen_lying = 8
	var/acid_slash_regen_standing = 14
	var/acid_passive_regen = 1

/datum/behavior_delegate/runner_acider/append_to_stat()
	. = list()
	. += "Acid: [acid_amount]"

	var/datum/action/xeno_action/activable/acider_for_the_hive/suicide_action = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/activable/acider_for_the_hive)
	if(suicide_action && suicide_action.caboom_trigger)
		. += "FOR THE HIVE!: in [suicide_action.caboom_left] seconds"

/datum/behavior_delegate/runner_acider/melee_attack_additional_effects_target(mob/living/carbon/target_mob)
	if (ishuman(target_mob))
		var/mob/living/carbon/human/target_human = target_mob
		if (target_human.stat == DEAD)
			return
	for(var/datum/effects/acid/AA in target_mob.effects_list)
		qdel(AA)
		break
	if(isxeno_human(target_mob))
		if(target_mob.lying)
			modify_acid(acid_slash_regen_lying)
		else
			modify_acid(acid_slash_regen_standing)
	new /datum/effects/acid(target_mob, bound_xeno, initial(bound_xeno.caste_type))

/datum/behavior_delegate/runner_acider/on_life()
	modify_acid(acid_passive_regen)
	if(!bound_xeno)
		return
	if(bound_xeno.stat == DEAD)
		return
	var/datum/action/xeno_action/activable/acider_for_the_hive/suicide_action = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/activable/acider_for_the_hive)
	if(suicide_action && suicide_action.caboom_trigger)
		var/wt = world.time
		if(suicide_action.caboom_last_proc)
			suicide_action.caboom_left -= (wt - suicide_action.caboom_last_proc)/10
		suicide_action.caboom_last_proc = wt
		var/amplitude = 50 + 50 * (suicide_action.caboom_timer - suicide_action.caboom_left) / suicide_action.caboom_timer
		playsound(bound_xeno, suicide_action.caboom_sound[suicide_action.caboom_loop], amplitude, FALSE, 10)
		suicide_action.caboom_loop++
		if(suicide_action.caboom_loop > suicide_action.caboom_sound.len)
			suicide_action.caboom_loop = 1
	if(suicide_action && suicide_action.caboom_left <= 0)
		suicide_action.caboom_trigger = FALSE
		suicide_action.do_caboom()
		return

	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()
	var/percentage_acid = round((acid_amount / max_acid) * 100, 10)
	if(percentage_acid)
		holder.overlays += image('icons/mob/hud/hud.dmi', "xenoenergy[percentage_acid]")

/datum/behavior_delegate/runner_acider/post_ability_cast(datum/action/xeno_action/ability, result)
	. = ..()
	switch(ability.type)
		if(/datum/action/xeno_action/activable/acider_acid)
			if(result)
				// result means we succesfully acided something
				var/datum/action/xeno_action/activable/acider_acid/corrod_action = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/activable/acider_acid)
				modify_acid(-corrod_action.acid_cost)
		if(/datum/action/xeno_action/activable/acider_for_the_hive)
			if(result == "cancelled")
				modify_acid(-(acid_amount * 0.25))

/datum/behavior_delegate/runner_acider/handle_death(mob/M)
	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

/datum/behavior_delegate/runner_acider/proc/modify_acid(amount)
	acid_amount = min(max(0, acid_amount + amount), max_acid)

	//We update the acider abilities with the current special ressource count
	var/datum/action/xeno_action/activable/acider_acid/corrod_action = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/activable/acider_acid)
	if(corrod_action)
		corrod_action.acid_stored = acid_amount
	var/datum/action/xeno_action/activable/acider_for_the_hive/suicide_action = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/activable/acider_for_the_hive)
	if(suicide_action)
		suicide_action.acid_stored = acid_amount
