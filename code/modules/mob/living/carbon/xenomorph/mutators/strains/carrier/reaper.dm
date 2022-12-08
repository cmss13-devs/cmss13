/datum/xeno_mutator/reaper
	name = "STRAIN: Carrier - Reaper"
	description = "In exchange for your ability to store eggs and huggers, you gain the ability to infect marines with egg plasma via slashing them."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_CARRIER)
	behavior_delegate_type = /datum/behavior_delegate/reaper_carrier
	mutator_actions_to_add = list(
		/datum/action/xeno_action/onclick/plasma_strike
	)
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/throw_hugger,
		/datum/action/xeno_action/onclick/place_trap,
		/datum/action/xeno_action/activable/retrieve_egg // readding it so it gets at the end of the ability list
	)
	keystone = TRUE

/datum/xeno_mutator/reaper/apply_mutator(datum/mutator_set/individual_mutators/mutator_set)
	. = ..()
	if (!.)
		return
	var/mob/living/carbon/Xenomorph/Carrier/carrier = mutator_set.xeno
	if(!istype(carrier))
		return FALSE
	carrier.mutation_type = CARRIER_REAPER
	carrier.plasma_types = list(PLASMA_EGG)
	mutator_update_actions(carrier)
	apply_behavior_holder(carrier)
	mutator_set.recalculate_actions(description, flavor_description)
	if(carrier.huggers_cur > 0)
		playsound(carrier.loc, 'sound/voice/alien_facehugger_dies.ogg', 25, 1)
	carrier.huggers_cur = 0
	carrier.huggers_max = 0
	return TRUE

/datum/behavior_delegate/reaper_carrier
	name = "Reaper Carrier Behavior Delegate"

	// State
	var/next_slash_buffed = FALSE
	var/image/slash_overlay

/datum/behavior_delegate/reaper_carrier/New()
	..()
	slash_overlay = image('icons/effects/effects.dmi', null, "anger", layer = FLY_LAYER, "pixel_x" = 16)

/datum/behavior_delegate/reaper_carrier/Destroy(force, ...)
	QDEL_NULL(slash_overlay)
	return ..()

/datum/behavior_delegate/reaper_carrier/melee_attack_modify_damage(original_damage, mob/living/carbon/target_carbon)
	if(!isXenoOrHuman(target_carbon))
		return original_damage

	if (next_slash_buffed)
		to_chat(bound_xeno, SPAN_XENOHIGHDANGER("You stab into \the [target_carbon], releasing egg plasma directly into their bloodstream!"))
		to_chat(target_carbon, SPAN_XENOHIGHDANGER("You feel a cold liquid coursing through your veins as [bound_xeno] stabs you!"))
		target_carbon.reagents.add_reagent(PLASMA_EGG, 15)
		target_carbon.reagents.add_reagent(PLASMA_HEMOCATALENE, 20)
		next_slash_buffed = FALSE
		var/datum/action/xeno_action/onclick/plasma_strike/ability = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/onclick/plasma_strike)
		if(istype(ability))
			ability.button.icon_state = "template"
		remove_slash_overlay()

	return original_damage

/datum/behavior_delegate/reaper_carrier/proc/add_slash_overlay()
	bound_xeno.xeno_jitter(1 SECONDS)
	bound_xeno.emote("roar")
	bound_xeno.add_filter("reaper_stab", 1, list("type" = "outline", "color" = "#d6331d49", "size" = 1))
	bound_xeno.overlays.Add(slash_overlay)

/datum/behavior_delegate/reaper_carrier/proc/remove_slash_overlay()
	bound_xeno.remove_filter("reaper_stab")
	bound_xeno.overlays.Remove(slash_overlay)
