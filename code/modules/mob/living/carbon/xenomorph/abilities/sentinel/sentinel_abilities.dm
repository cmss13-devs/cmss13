//Slowing spit
/datum/action/xeno_action/activable/slowing_spit
	name = "Slowing Spit"
	action_icon_state = "xeno_spit"
	macro_path = /datum/action/xeno_action/verb/verb_slowing_spit
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 1 SECONDS
	plasma_cost = 50
	ability_uses_acid_overlay = TRUE

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
	name = "Toxic Slash"
	action_icon_state = "lurker_inject_neuro"
	macro_path = /datum/action/xeno_action/verb/verb_paralyzing_slash
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 10 SECONDS
	plasma_cost = 100

	var/buff_duration = 50

/datum/action/xeno_action/activable/tail_stab/sentinel
	name = "Catalytic Shock Tailstab"
	damage_multiplier = 1

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
	target.apply_armoured_damage(stacks*1.2, ARMOR_MELEE, BURN, limb ? limb.name : "chest")

/datum/action/xeno_action/activable/draining_bite
	name = "Headbite"
	action_icon_state = "headbite"
	macro_path = /datum/action/xeno_action/verb/verb_headbite
	ability_primacy = XENO_PRIMARY_ACTION_4
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 12 SECONDS
	plasma_cost = 100
	var/minimal_stun = 0.1

