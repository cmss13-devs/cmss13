/datum/xeno_mutator/praetorian_dancer
	// My name is Cuban Pete, I'm the King of the Rumba Beat
	name = "STRAIN: Praetorian - Dancer"
	description = "You are now a paragon of agility. You lose the ability to spit and lose some armor. You gain an ability that lets you dodge through tallhosts (cancelled on slash) and a two powerful tail abilities each enhanced by a tag placed on your opponents via slashing."
	flavor_description = "You are the Queen's scalpel. Don't think you are. Know you are."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Praetorian")  	// Only bae
	mutator_actions_to_remove = list("Xeno Spit","Dash", "Acid Ball", "Spray Acid")
	mutator_actions_to_add = list(/datum/action/xeno_action/activable/prae_impale, /datum/action/xeno_action/activable/prae_dodge, /datum/action/xeno_action/activable/prae_tail_trip)
	behavior_delegate_type = /datum/behavior_delegate/praetorian_dancer
	keystone = TRUE

/datum/xeno_mutator/praetorian_dancer/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Praetorian/P = MS.xeno
	P.speed_modifier += XENO_SPEED_MODIFIER_FASTER
	P.evasion_modifier += XENO_EVASION_MOD_VERYLARGE // Best in game evasion.
	P.plasma_types = list(PLASMA_CATECHOLAMINE)
	P.claw_type = CLAW_TYPE_VERY_SHARP

	mutator_update_actions(P)
	MS.recalculate_actions(description, flavor_description)

	P.recalculate_everything()

	apply_behavior_holder(P)
	P.mutation_type = PRAETORIAN_DANCER

/datum/behavior_delegate/praetorian_dancer
	name = "Praetorian Dancer Behavior Delegate"

	var/evasion_buff_amount = 40
	var/evasion_buff_ttl = 25     // 2.5 seconds seems reasonable

	// State
	var/next_slash_buffed = FALSE
	var/slash_evasion_buffed = FALSE
	var/slash_evasion_timer = TIMER_ID_NULL

/datum/behavior_delegate/praetorian_dancer/melee_attack_additional_effects_self()
	if (!istype(bound_xeno, /mob/living/carbon/Xenomorph))
		return

	var/mob/living/carbon/Xenomorph/X = bound_xeno

	if (!slash_evasion_buffed)
		slash_evasion_buffed = TRUE
		slash_evasion_timer = addtimer(CALLBACK(src, .proc/remove_evasion_buff), evasion_buff_ttl, TIMER_STOPPABLE | TIMER_UNIQUE)
		X.evasion_modifier += evasion_buff_amount
		X.recalculate_evasion()
		to_chat(X, SPAN_XENODANGER("You feel your slash make you more evasive!"))

	else
		slash_evasion_timer = addtimer(CALLBACK(src, .proc/remove_evasion_buff), evasion_buff_ttl, TIMER_STOPPABLE | TIMER_OVERRIDE|TIMER_UNIQUE)

	if (X.flags_pass_temp & PASS_MOB_THRU)
		X.flags_pass_temp &= ~PASS_MOB_THRU
		X.speed_modifier += 0.5
		X.recalculate_speed()
		to_chat(X, SPAN_XENOHIGHDANGER("You can no longer move through creatures!"))


/datum/behavior_delegate/praetorian_dancer/melee_attack_additional_effects_target(atom/A)
	if (!isXenoOrHuman(A))
		return

	var/mob/living/carbon/H = A
	if (H.stat)
		return

	// Clean up all tags to 'refresh' our TTL
	for (var/datum/effects/dancer_tag/DT in H.effects_list)
		qdel(DT)

	new /datum/effects/dancer_tag(H, bound_xeno, , , 35)

	if(ishuman(H))
		var/mob/living/carbon/human/Hu = H
		Hu.update_xeno_hostile_hud()

/datum/behavior_delegate/praetorian_dancer/proc/remove_evasion_buff()
	if (slash_evasion_timer == TIMER_ID_NULL || !slash_evasion_buffed)
		return
	if (!istype(bound_xeno, /mob/living/carbon/Xenomorph))
		return

	slash_evasion_timer = TIMER_ID_NULL
	slash_evasion_buffed = FALSE

	var/mob/living/carbon/Xenomorph/X = bound_xeno
	X.evasion_modifier -= evasion_buff_amount
	X.recalculate_evasion()
	to_chat(X, SPAN_XENODANGER("You feel your increased evasion from slashing end!"))
