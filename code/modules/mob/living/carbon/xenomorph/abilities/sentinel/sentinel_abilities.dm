//Slowing spit
/datum/action/xeno_action/activable/slowing_spit
	ability_stats_type = /datum/xeno_ability_stats/slowing_spit
	ability_description = "Spit neurotoxin at prey to slow it down."
	name = "Slowing Spit"
	action_icon_state = "neurotoxin_spit"
	macro_path = /datum/action/xeno_action/verb/verb_slowing_spit
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 1 SECONDS
	plasma_cost = 30
	ability_uses_acid_overlay = TRUE

XENO_ABILITY_STATS(slowing_spit, datum/action/xeno_action/activable/slowing_spit)
	var/maximum = /datum/effects/sentinel_neuro_stacks::max_stacks
	var/oxygen = /datum/effects/sentinel_neuro_stacks::max_oxyloss_upper_bound
	return list(
		XENO_STAT_VALUE("Maximum neurotoxin stacks", maximum, null, "."),
		XENO_STAT_VALUE("Maximum oxygen damage from stacks", oxygen, "oxygen", "."),
	)

// Scatterspit
/datum/action/xeno_action/activable/scattered_spit
	name = "Scattered Spit"
	action_icon_state = "acid_shotgun"
	macro_path = /datum/action/xeno_action/verb/verb_scattered_spit
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 7 SECONDS
	plasma_cost = 30
	ability_uses_acid_overlay = TRUE
// Toxic slash
/datum/action/xeno_action/onclick/paralyzing_slash
	ability_description = "Coat your claws in neurotoxin. Your next slashes add neurotoxin stacks to susceptible prey."
	ability_stats_type = /datum/xeno_ability_stats/paralyzing_slash
	name = "Toxic Slash"
	action_icon_state = "para_slash"
	macro_path = /datum/action/xeno_action/verb/verb_paralyzing_slash
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 10 SECONDS
	plasma_cost = 100
	cooldown_message = "Our claws feel soaked with acid again!"

	var/buff_duration = 5 SECONDS

XENO_ABILITY_STATS(paralyzing_slash, datum/action/xeno_action/onclick/paralyzing_slash)
	var/slashes = /datum/behavior_delegate/sentinel_base::max_buffed_slashes
	var/stacks = /datum/behavior_delegate/sentinel_base::increment_amount
	return list(
		XENO_STAT_DURATION(buff_duration, "Buff duration"),
		XENO_STAT_VALUE("Buffed slashes", slashes, null, "."),
		XENO_STAT_VALUE("Neurotoxin stacks per slash", stacks, null, "."),
	)

/datum/action/xeno_action/activable/tail_stab/sentinel
	ability_stats_type = /datum/xeno_ability_stats/activable_tail_stab_sentinel
	ability_description = "Consume neurotoxin stacks to burn your target. Enough stacks also grant you speed and armor."
	name = "Catalytic Shock Tailstab"
	damage_multiplier = 1
	var/duration = 3.5 SECONDS
	var/speed_buff_amount = 0.8 // Go from shit slow to kindafast
	var/armor_buff_amount = 25 // hopefully-minor buff so they can close the distance
	var/burn_damage_per_stack = 1.2
	var/stacks_for_buff = 10

XENO_ABILITY_STATS(activable_tail_stab_sentinel, datum/action/xeno_action/activable/tail_stab/sentinel)
	return list(
		XENO_STAT_NUMBER(armor_buff_amount, "Armor gained"),
		XENO_STAT_DURATION(duration, "Buff duration"),
		XENO_STAT_BURN(burn_damage_per_stack, "Bonus burn damage per neurotoxin stack"),
		XENO_STAT_NUMBER(stacks_for_buff, "Stacks required for buff"),
	)

/datum/action/xeno_action/activable/tail_stab/sentinel/ability_act(mob/living/carbon/xenomorph/stabbing_xeno, mob/living/carbon/target, obj/limb/limb)
	. = ..()
	if(!istype(target,/mob/living/carbon/human))
		return
	var/mob/living/carbon/human/human = target
	var/datum/effects/sentinel_neuro_stacks/sns = null
	for (var/datum/effects/sentinel_neuro_stacks/sentinel_neuro_stacks in human.effects_list)
		sns = sentinel_neuro_stacks
		break
	if(!sns)
		return
	var/stacks = sns.stack_count
	sns.increment_stack_count(-stacks/2)
	target.apply_armoured_damage(stacks * burn_damage_per_stack, ARMOR_MELEE, BURN, limb ? limb.name : "chest")
	if(stacks < stacks_for_buff)
		return
	stabbing_xeno.speed_modifier -= speed_buff_amount
	stabbing_xeno.armor_modifier += armor_buff_amount
	stabbing_xeno.recalculate_speed()
	stabbing_xeno.recalculate_armor()
	addtimer(CALLBACK(src, PROC_REF(remove_effects)), duration)
	to_chat(stabbing_xeno, SPAN_XENOWARNING("We are slightly faster and more armored for a small amount of time."))

/datum/action/xeno_action/activable/tail_stab/sentinel/proc/remove_effects()
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	xeno.speed_modifier += speed_buff_amount
	xeno.armor_modifier -= armor_buff_amount
	xeno.recalculate_speed()
	xeno.recalculate_armor()
	to_chat(xeno, SPAN_XENOHIGHDANGER("We feel our movement speed slow down!"))

/datum/action/xeno_action/activable/draining_bite
	ability_stats_type = /datum/xeno_ability_stats/draining_bite
	ability_description = "Bite adjacent prey to stun it. Built up neurotoxin strengthens the stun."
	name = "Draining bite"
	action_icon_state = "draining_bite"
	macro_path = /datum/action/xeno_action/verb/verb_headbite
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 12 SECONDS
	plasma_cost = 0
	var/minimal_stun = 0.1
	cooldown_message = "Both of our mouths crave blood!"

XENO_ABILITY_STATS(draining_bite, datum/action/xeno_action/activable/draining_bite)
	return list(
		XENO_STAT_CONTROL_LEGACY(minimal_stun, "Minimum knockdown"),
	)

