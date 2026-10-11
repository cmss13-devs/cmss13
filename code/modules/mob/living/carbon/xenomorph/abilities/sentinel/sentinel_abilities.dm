//Slowing spit
/datum/action/xeno_action/activable/slowing_spit
	name = "Slowing Spit"
	action_icon_state = "neurotoxin_spit"
	macro_path = /datum/action/xeno_action/verb/verb_slowing_spit
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 1 SECONDS
	plasma_cost = 30
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
	action_icon_state = "para_slash"
	macro_path = /datum/action/xeno_action/verb/verb_paralyzing_slash
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 10 SECONDS
	plasma_cost = 100

	var/buff_duration = 50

/datum/action/xeno_action/activable/tail_stab/sentinel
	name = "Catalytic Shock Tailstab"
	damage_multiplier = 1
	var/duration = 40
	var/minimal_speed_buff_amount = 0.2 // Goes from despoiler and becomes faster than lurker / slower than acid runner
	var/minimal_armor_buff_amount = 15 //spitter level
	var/plasma_gain = 100

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
	var/speed_buff_amount = max(minimal_speed_buff_amount, (stacks/5)/10) //[0.2; 0.6]
	var/armor_buff_amount = max(minimal_armor_buff_amount, (stacks/6)*5) //[15; 25]
	target.apply_armoured_damage(stacks, ARMOR_MELEE, BURN, limb ? limb.name : "chest") //not more than basic tail stab
	stabbing_xeno.gain_plasma(stacks/sns.max_stacks * plasma_gain)
	sns.increment_stack_count(-stacks/2)

	stabbing_xeno.speed_modifier -= speed_buff_amount
	stabbing_xeno.armor_modifier += armor_buff_amount
	stabbing_xeno.recalculate_speed()
	stabbing_xeno.recalculate_armor()
	addtimer(CALLBACK(src, PROC_REF(remove_effects), speed_buff_amount, armor_buff_amount), duration)
	to_chat(stabbing_xeno, SPAN_XENOWARNING("We are slightly faster and more armored for a small amount of time."))

/datum/action/xeno_action/activable/tail_stab/sentinel/proc/remove_effects(speed_buff_amount, armor_buff_amount)
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	xeno.speed_modifier += speed_buff_amount
	xeno.armor_modifier -= armor_buff_amount
	xeno.recalculate_speed()
	xeno.recalculate_armor()
	to_chat(xeno, SPAN_XENOHIGHDANGER("We feel our movement speed slow down and chitin grow weaker!"))

/datum/action/xeno_action/activable/draining_bite
	name = "Draining bite"
	action_icon_state = "draining_bite"
	macro_path = /datum/action/xeno_action/verb/verb_headbite
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 12 SECONDS
	plasma_cost = 0
	var/minimal_stun = 0.1

