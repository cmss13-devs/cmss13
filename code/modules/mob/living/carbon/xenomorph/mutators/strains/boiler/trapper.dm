
/datum/xeno_mutator/trapper
	name = "STRAIN: Boiler - Trapper"
	description = "You trade your resilient vision increase and ability to bombard for longer range vision, traps that immobilize your opponents, and unblockable acid mines."
	flavor_description = "I love the smell of burnin' tallhost flesh in the Mornin'."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Boiler") //Only boiler.
	mutator_actions_to_remove = list("Toggle Long Range Sight", "Bombard", "Acid Lance", "Dump Acid")
	mutator_actions_to_add = list(/datum/action/xeno_action/onclick/toggle_long_range/trapper, /datum/action/xeno_action/activable/boiler_trap, /datum/action/xeno_action/activable/acid_mine, /datum/action/xeno_action/activable/acid_shotgun)
	keystone = TRUE

	behavior_delegate_type = /datum/behavior_delegate/boiler_trapper

/datum/xeno_mutator/trapper/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if(. == 0)
		return
	
	var/mob/living/carbon/Xenomorph/Boiler/B = MS.xeno
	if(B.is_zoomed)
		B.zoom_out()

	B.viewsize = 10

	B.mutation_type = BOILER_TRAPPER
	B.plasma_types -= PLASMA_NEUROTOXIN

	B.speed_modifier += XENO_SPEED_MODIFIER_FAST
	B.recalculate_everything()

	apply_behavior_holder(B)

	mutator_update_actions(B)
	MS.recalculate_actions(description, flavor_description)


/datum/behavior_delegate/boiler_trapper
	name = "Boiler Trapper Behavior Delegate"

	// Config
	var/temp_movespeed_amount = 1.25
	var/temp_movespeed_duration = 50
	var/temp_movespeed_cooldown = 200
	var/bonus_damage_shotgun_trapped = 7.5

	// State
	var/temp_movespeed_time_used = 0
	var/temp_movespeed_usable = FALSE
	var/temp_movespeed_messaged = FALSE

/datum/behavior_delegate/boiler_trapper/on_hitby_projectile(ammo)
	if (temp_movespeed_usable)
		temp_movespeed_time_used = world.time
		temp_movespeed_usable = FALSE

		if (isXeno(bound_xeno))
			var/mob/living/carbon/Xenomorph/X = bound_xeno
			X.speed_modifier -= temp_movespeed_amount
			X.recalculate_speed()
			add_timer(CALLBACK(src, .proc/remove_speed_buff), temp_movespeed_duration)

/datum/behavior_delegate/boiler_trapper/ranged_attack_additional_effects_target(atom/A)
	if (!ishuman(A))
		return
	if (!istype(bound_xeno))
		return

	var/mob/living/carbon/human/H = A
	var/datum/effects/xeno_freeze/found = null 
	for (var/datum/effects/xeno_freeze/F in H.effects_list)
		if (F.source_mob == bound_xeno)
			found = F
			break

	if (found)
		H.apply_armoured_damage(bonus_damage_shotgun_trapped, ARMOR_BIO, BURN)
	else
		H.AdjustSlowed(2)


/datum/behavior_delegate/boiler_trapper/on_life()
	if ((temp_movespeed_time_used + temp_movespeed_cooldown) < world.time)
		if (!temp_movespeed_messaged)
			to_chat(bound_xeno, SPAN_XENODANGER("You feel your adrenaline glands refill! Your speedboost will activate again."))
			temp_movespeed_messaged = TRUE
		temp_movespeed_usable = TRUE
		return

/datum/behavior_delegate/boiler_trapper/proc/remove_speed_buff()
	if (isXeno(bound_xeno))
		var/mob/living/carbon/Xenomorph/X = bound_xeno
		X.speed_modifier += temp_movespeed_amount
		X.recalculate_speed()
		temp_movespeed_messaged = FALSE