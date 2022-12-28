/datum/xeno_mutator/praetorian_dancer
	// My name is Cuban Pete, I'm the King of the Rumba Beat
	name = "STRAIN: Praetorian - Dancer"
	description = "You are now a paragon of agility. You lose the ability to spit and lose some armor. You gain an ability that lets you dodge through tallhosts (cancelled on slash) and two powerful tail abilities each enhanced by a tag placed on your opponents via slashing."
	flavor_description = "You are the Queen's scalpel. Don't think you are. Know you are."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_PRAETORIAN) // Only bae
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/prae_impale,
		/datum/action/xeno_action/onclick/prae_dodge,
		/datum/action/xeno_action/activable/prae_tail_trip,
	)
	behavior_delegate_type = /datum/behavior_delegate/praetorian_dancer
	keystone = TRUE

/datum/xeno_mutator/praetorian_dancer/apply_mutator(datum/mutator_set/individual_mutators/mutator_set)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Praetorian/praetorian = mutator_set.xeno
	praetorian.armor_modifier -= XENO_ARMOR_MOD_VERYSMALL
	praetorian.speed_modifier += XENO_SPEED_FASTMOD_TIER_5
	praetorian.plasma_types = list(PLASMA_CATECHOLAMINE)
	praetorian.claw_type = CLAW_TYPE_SHARP

	mutator_update_actions(praetorian)
	mutator_set.recalculate_actions(description, flavor_description)

	praetorian.recalculate_everything()

	apply_behavior_holder(praetorian)
	praetorian.mutation_icon_state = PRAETORIAN_DANCER
	praetorian.mutation_type = PRAETORIAN_DANCER

/datum/behavior_delegate/praetorian_dancer
	name = "Praetorian Dancer Behavior Delegate"

	var/evasion_buff_amount = 40
	var/evasion_buff_ttl = 25  // 2.5 seconds seems reasonable

	// State
	var/next_slash_buffed = FALSE
	var/slash_evasion_buffed = FALSE
	var/slash_evasion_timer = TIMER_ID_NULL
	var/dodge_activated = FALSE

/datum/behavior_delegate/praetorian_dancer/melee_attack_additional_effects_self()
	..()

	if (!istype(bound_xeno, /mob/living/carbon/Xenomorph))
		return

	var/mob/living/carbon/Xenomorph/praetorian = bound_xeno

	if (!slash_evasion_buffed)
		slash_evasion_buffed = TRUE
		slash_evasion_timer = addtimer(CALLBACK(src, PROC_REF(remove_evasion_buff)), evasion_buff_ttl, TIMER_STOPPABLE | TIMER_UNIQUE)
		praetorian.evasion_modifier += evasion_buff_amount
		praetorian.recalculate_evasion()
		to_chat(praetorian, SPAN_XENODANGER("You feel your slash make you more evasive!"))

	else
		slash_evasion_timer = addtimer(CALLBACK(src, PROC_REF(remove_evasion_buff)), evasion_buff_ttl, TIMER_STOPPABLE | TIMER_OVERRIDE|TIMER_UNIQUE)

	if (dodge_activated)
		dodge_activated = FALSE
		praetorian.remove_temp_pass_flags(PASS_MOB_THRU)
		praetorian.speed_modifier += 0.5
		praetorian.recalculate_speed()
		to_chat(praetorian, SPAN_XENOHIGHDANGER("You can no longer move through creatures!"))


/datum/behavior_delegate/praetorian_dancer/melee_attack_additional_effects_target(mob/living/carbon/target_carbon)
	if (!isXenoOrHuman(target_carbon))
		return

	if (target_carbon.stat)
		return

	// Clean up all tags to 'refresh' our TTL
	for (var/datum/effects/dancer_tag/target_tag in target_carbon.effects_list)
		qdel(target_tag)

	new /datum/effects/dancer_tag(target_carbon, bound_xeno, , , 35)

	if(ishuman(target_carbon))
		var/mob/living/carbon/human/target_human = target_carbon
		target_human.update_xeno_hostile_hud()

/datum/behavior_delegate/praetorian_dancer/proc/remove_evasion_buff()
	if (slash_evasion_timer == TIMER_ID_NULL || !slash_evasion_buffed)
		return
	if (!istype(bound_xeno, /mob/living/carbon/Xenomorph))
		return

	slash_evasion_timer = TIMER_ID_NULL
	slash_evasion_buffed = FALSE

	var/mob/living/carbon/Xenomorph/praetorian = bound_xeno
	praetorian.evasion_modifier -= evasion_buff_amount
	praetorian.recalculate_evasion()
	to_chat(praetorian, SPAN_XENODANGER("You feel your increased evasion from slashing end!"))
