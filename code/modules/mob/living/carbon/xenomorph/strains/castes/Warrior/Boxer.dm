/datum/xeno_strain/boxer

	name = WARRIOR_BOXER
	description = "In exchange for your ability to fling and shield yourself with slashes, you gain KO meter and the ability to resist stuns. Your punches will reset the cooldown of your Jab. Jab lets you close in and confuse your opponents while resetting Punch cooldown. Your slashes and abilities build up KO meter that later lets you deal damage, knockback, heal, and restore your stun resistance depending on how much KO meter you gained with a titanic Uppercut strike."
	icon_state_prefix = "Boxer"
	actions_to_remove = list(
				/datum/action/xeno_action/activable/lunge,
				/datum/action/xeno_action/activable/fling,
				/datum/action/xeno_action/activable/warrior_punch,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/boxer_punch,
		/datum/action/xeno_action/activable/jab,
		/datum/action/xeno_action/activable/uppercut
	)


	behavior_delegate_type = /datum/behavior_delegate/boxer


/datum/xeno_strain/boxer/apply_strain(mob/living/carbon/xenomorph/warrior/warrior)

	warrior.recalculate_everything()

/datum/behavior_delegate/boxer

	name = "Boxer Warrior Behavior Delegate"

	var/ko_delay = 5 SECONDS
	var/max_clear_head = 3
	var/clear_head_delay = 15 SECONDS
	var/clear_head = 3
	var/next_clear_head_regen
	var/clear_head_tickcancel

	var/mob/punching_bag
	var/ko_counter = 0
	var/ko_reset_timer
	var/max_ko_counter = 15

	var/image/ko_icon
	var/image/big_ko_icon

/datum/behavior_delegate/boxer/New()
	. = ..()
	if(SSticker.mode && (SSticker.mode.flags_round_type & MODE_XVX))
		clear_head = 0
		max_clear_head = 0


/datum/behavior_delegate/boxer/append_to_stat()
	. = list()
	if(punching_bag)
		. +=  "Beating [punching_bag] - [ko_counter] hits"

	. += "Clarity [clear_head] hits"



/datum/behavior_delegate/boxer/on_life()
	var/world_time = world.time
	if(world_time > next_clear_head_regen && clear_head < max_clear_head)
		clear_head++
		next_clear_head_regen = world_time+ clear_head_delay



/datum/behavior_delegate/boxer/melee_attack_additional_effects_target(mob/living/carbon/target_carbon, ko_boost = 0.5)

	if(!ismob(target_carbon))
		return

	if(punching_bag != target_carbon)
		remove_ko()
		punching_bag = target_carbon
		ko_icon = image(null, target_carbon)
		ko_icon.alpha = 196
		ko_icon.maptext_width = 16
		ko_icon.maptext_x = 16
		big_ko_icon.maptext_x = -32
		ko_icon.maptext_y = 16
		ko_icon.layer = 20
		bound_xeno.client.images += ko_icon

	ko_counter += ko_boost
	if(ko_counter > max_ko_counter)
		ko_counter = max_ko_counter
	var/to_display = round(ko_counter)
	ko_icon.maptext = "<span class='center langchat'>[to_display]</span>"

	ko_reset_timer = addtimer(CALLBACK(src, .proc/remove_ko), ko_delay, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT | TIMER_STOPPABLE)


/datum/behavior_delegate/boxer/proc/remove_ko()
	punching_bag = null
	ko_counter = 0
	if(bound_xeno.client && ko_icon)
		bound_xeno.client.images -= ko_icon
	ko_icon = null

/datum/behavior_delegate/boxer/proc/display_ko_message(mob/target_carbon)

	big_ko_icon = image(null, target_carbon)
	big_ko_icon.alpha = 196
	big_ko_icon.maptext_y = target_carbon.langchat_height
	big_ko_icon.maptext_width = LANGCHAT_WIDTH
	big_ko_icon.maptext_height = 64
	big_ko_icon.color = "#FF0000"
	big_ko_icon.maptext_x = -32
	big_ko_icon.maptext = "<span class='center langchat langchat_bolditalicbig'>KO!</span>"
	bound_xeno.client.images += big_ko_icon
	addtimer(CALLBACK(src, PROC_REF(remove_big_ko), 2 SECONDS))

/datum/behavior_delegate/boxer/proc/remove_big_ko()
	if(bound_xeno.client && big_ko_icon)
		bound_xeno.client.images -= big_ko_icon
	big_ko_icon = null


/mob/living/carbon/xenomorph/warrior/boxer/Daze(amount)
	var/datum/behavior_delegate/boxer/boxer_delegate = behavior_delegate
	if(boxer_delegate.clear_head <= 0)
		..(amount)
		return
	if(boxer_delegate.clear_head_tickcancel == world.time)
		return
	boxer_delegate.clear_head_tickcancel = world.time
	boxer_delegate.clear_head--
	if(boxer_delegate.clear_head <= 0)
		boxer_delegate.clear_head = 0


/mob/living/carbon/xenomorph/warrior/boxer/SetDaze(amount)
	var/datum/behavior_delegate/boxer/boxer_delegate = behavior_delegate
	if(boxer_delegate.clear_head <= 0)
		..(amount)
		return
	if(boxer_delegate.clear_head_tickcancel == world.time)
		return

	boxer_delegate.clear_head_tickcancel = world.time
	boxer_delegate.clear_head--
	if(boxer_delegate.clear_head <= 0)
		boxer_delegate.clear_head = 0

/mob/living/carbon/xenomorph/warrior/boxer/AdjustDaze(amount)
	var/datum/behavior_delegate/boxer/boxer_delegate = behavior_delegate
	if(boxer_delegate.clear_head <= 0)
		..(amount)
		return
	if(boxer_delegate.clear_head_tickcancel == world.time)
		return

	boxer_delegate.clear_head_tickcancel = world.time
	boxer_delegate.clear_head--
	if(boxer_delegate.clear_head <= 0)
		boxer_delegate.clear_head = 0



/mob/living/carbon/xenomorph/warrior/boxer/KnockDown(amount, forced)
	var/datum/behavior_delegate/boxer/boxer_delegate = behavior_delegate
	if(boxer_delegate.clear_head <= 0)
		..(amount)
		return
	if(boxer_delegate.clear_head_tickcancel == world.time)
		return

	boxer_delegate.clear_head_tickcancel = world.time
	boxer_delegate.clear_head--
	if(boxer_delegate.clear_head <= 0)
		boxer_delegate.clear_head = 0


/mob/living/carbon/xenomorph/warrior/boxer/SetKnockDown(amount)
	var/datum/behavior_delegate/boxer/boxer_delegate = behavior_delegate
	if(boxer_delegate.clear_head <= 0)
		..(amount)
		return
	if(boxer_delegate.clear_head_tickcancel == world.time)
		return

	boxer_delegate.clear_head_tickcancel = world.time
	boxer_delegate.clear_head--
	if(boxer_delegate.clear_head <= 0)
		boxer_delegate.clear_head = 0


/mob/living/carbon/xenomorph/warrior/boxer/AdjustKnockDown(amount)
	var/datum/behavior_delegate/boxer/boxer_delegate = behavior_delegate
	if(boxer_delegate.clear_head <= 0)
		..(amount)
		return
	if(boxer_delegate.clear_head_tickcancel == world.time)
		return

	boxer_delegate.clear_head_tickcancel = world.time
	boxer_delegate.clear_head--
	if(boxer_delegate.clear_head <= 0)
		boxer_delegate.clear_head = 0

/mob/living/carbon/xenomorph/warrior/boxer/Stun(amount)
	var/datum/behavior_delegate/boxer/boxer_delegate = behavior_delegate
	if(boxer_delegate.clear_head <= 0)
		..(amount)
		return
	if(boxer_delegate.clear_head_tickcancel == world.time)
		return

	boxer_delegate.clear_head_tickcancel = world.time
	boxer_delegate.clear_head--
	if(boxer_delegate.clear_head <= 0)
		boxer_delegate.clear_head = 0


/mob/living/carbon/xenomorph/warrior/boxer/SetStun(amount)
	var/datum/behavior_delegate/boxer/boxer_delegate = behavior_delegate
	if(boxer_delegate.clear_head <= 0)
		..(amount)
		return
	if(boxer_delegate.clear_head_tickcancel == world.time)
		return

	boxer_delegate.clear_head_tickcancel = world.time
	boxer_delegate.clear_head--
	if(boxer_delegate.clear_head <= 0)
		boxer_delegate.clear_head = 0


/mob/living/carbon/xenomorph/warrior/boxer/AdjustStun(amount)
	var/datum/behavior_delegate/boxer/boxer_delegate = behavior_delegate
	if(boxer_delegate.clear_head <= 0)
		..(amount)
		return
	if(boxer_delegate.clear_head_tickcancel == world.time)
		return

	boxer_delegate.clear_head_tickcancel = world.time
	boxer_delegate.clear_head--
	if(boxer_delegate.clear_head <= 0)
		boxer_delegate.clear_head = 0



/datum/action/xeno_action/activable/boxer_punch

	name = "Punch"
	action_icon_state = "punch"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 4.5 SECONDS


	var/boxer_punch_damage = 20
	var/boxer_punch_damage_synth = 30
	var/boxer_punch_damage_pred = 25
	var/base_damage = 25
	var/damage_variance = 5

/datum/action/xeno_action/activable/uppercut

	name = "Uppercut"
	action_icon_state = "rav_clothesline"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 10 SECONDS
	var/base_damage = 15
	var/base_knockback = 40
	var/base_knockdown = 0.25
	var/knockout_power = 11 // 11 seconds
	var/base_healthgain = 5 // in percents of health per ko point

/datum/action/xeno_action/activable/jab
	name = "Jab"
	action_icon_state = "pounce"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 4 SECONDS

/datum/action/xeno_action/activable/boxer_punch/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/boxer_punch = owner
	var/mob/living/carbon/carbon = affected_atom

	if (!action_cooldown_check())
		return

	if (!isxeno_human(carbon) || boxer_punch.can_not_harm(carbon))
		return

	if (!boxer_punch.check_state() || boxer_punch.agility)
		return

	var/distance = get_dist(boxer_punch, carbon)

	if (distance > 1)
		step_towards(boxer_punch, carbon, 1)

	if (!boxer_punch.Adjacent(carbon))
		return

	if (!boxer_punch.Adjacent(carbon))
		return

	if(carbon.stat == DEAD)
		return

	if(HAS_TRAIT(carbon, TRAIT_NESTED))
		return

	var/obj/limb/target_limb = carbon.get_limb(check_zone(boxer_punch.zone_selected))

	if (ishuman(carbon) && (!target_limb || (target_limb.status & LIMB_DESTROYED)))
		target_limb = carbon.get_limb("chest")

	if (!check_and_use_plasma_owner())
		return

	carbon.last_damage_data = create_cause_data(initial(boxer_punch.caste_type), boxer_punch)

	boxer_punch.visible_message(SPAN_XENOWARNING("[boxer_punch] hits [carbon] in the [target_limb ? target_limb.display_name : "chest"] with a devastatingly powerful punch!"),
	SPAN_XENOWARNING("We hit [carbon] in the [target_limb ? target_limb.display_name : "chest"] with a devastatingly powerful punch!"))
	var/sound = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(carbon, sound, 50, 1)
	do_boxer_punch(carbon, target_limb)
	apply_cooldown()
	return ..()


/datum/action/xeno_action/activable/boxer_punch/proc/do_boxer_punch(mob/living/carbon/carbon, obj/limb/target_limb)
	var/mob/living/carbon/xenomorph/boxer = owner

	var/damage = rand(boxer_punch_damage, boxer_punch_damage + damage_variance)

	if(ishuman(carbon))
		if(isyautja(carbon))
			damage = rand(boxer_punch_damage_pred, boxer_punch_damage_pred + damage_variance)
		else if(target_limb.status & (LIMB_ROBOT | LIMB_SYNTHSKIN))
			damage = rand(boxer_punch_damage_synth, boxer_punch_damage_synth + damage_variance)


	carbon.apply_armoured_damage(get_xeno_damage_slash(carbon, damage), ARMOR_MELEE, BRUTE, target_limb? target_limb.name : "chest")

	step_away(carbon, boxer)
	if(prob(25)) // 25% chance to fly 2 tiles
		step_away(carbon, boxer)
	var/datum/behavior_delegate/boxer/boxer_delegate = boxer.behavior_delegate
	if(istype(boxer_delegate))
		boxer_delegate.melee_attack_additional_effects_target(carbon, 1)

	var/datum/action/xeno_action/activable/jab/jab_action = get_action(boxer, /datum/action/xeno_action/activable/jab)
	if(istype(jab_action) && !jab_action.action_cooldown_check())
		if(isxeno(carbon))
			jab_action.reduce_cooldown(jab_action.xeno_cooldown / 2)
		else
			jab_action.end_cooldown()

/datum/action/xeno_action/activable/jab/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/boxer_jab = owner
	var/mob/living/carbon/carbon_target = A

	if(!action_cooldown_check())
		return

	if(boxer_jab.can_not_harm(carbon_target))
		return

	if (!isxeno_human(carbon_target))
		return

	var/distance = get_dist(boxer_jab, carbon_target)

	if(distance > 3)
		return

	if(carbon_target.stat == DEAD)
		return

	if(HAS_TRAIT(carbon_target, TRAIT_NESTED))
		return

	if(!check_and_use_plasma_owner())
		return

	if(distance > 1 & 2)
		step_towards(boxer_jab, carbon_target, 1)


	if(!boxer_jab.Adjacent(carbon_target))
		return

	carbon_target.last_damage_data = create_cause_data(initial(boxer_jab.caste_type), boxer_jab)
	boxer_jab.visible_message(SPAN_XENOWARNING("[boxer_jab] hits [carbon_target] with a powerful jab!"),
	SPAN_XENOWARNING("You hit [carbon_target] with a powerful jab!"))
	var/sound_pick = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(carbon_target, sound_pick, 45, 1)

	var/datum/action/xeno_action/activable/boxer_punch/punch_action = get_action(boxer_jab, /datum/action/xeno_action/activable/boxer_punch)
	if(punch_action && !punch_action.action_cooldown_check())
		if(isxeno(carbon_target))
			punch_action.reduce_cooldown(punch_action.xeno_cooldown / 2)
		else
			punch_action.end_cooldown()

	carbon_target.Daze(3)
	carbon_target.Slow(5)

	var/datum/behavior_delegate/boxer/behavior_delegate = boxer_jab.behavior_delegate
	if(istype(behavior_delegate))
		behavior_delegate.melee_attack_additional_effects_target(carbon_target, 1)
	apply_cooldown()
	..()


/datum/action/xeno_action/activable/uppercut/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/upper_cut = owner

	if(upper_cut.can_not_harm(A))
		return

	if(!upper_cut.check_state())
		return

	var/datum/behavior_delegate/boxer/behavior_delegate = upper_cut.behavior_delegate

	if(!istype(behavior_delegate))
		return

	if(!behavior_delegate.punching_bag)
		return

	var/mob/living/carbon/carbon_target = behavior_delegate.punching_bag
	if(carbon_target.stat == DEAD)
		return

	if(HAS_TRAIT(carbon_target, TRAIT_NESTED))
		return

	if(!check_and_use_plasma_owner())
		return

	if(!upper_cut.Adjacent(carbon_target))
		return

	if(carbon_target.mob_size >= MOB_SIZE_BIG)
		to_chat(upper_cut, SPAN_XENOWARNING("[carbon_target] is too big for you to uppercut!"))
		return

	var/datum/action/xeno_action/activable/jab/jab_action = get_action(upper_cut, /datum/action/xeno_action/activable/jab)
	if(istype(jab_action))
		jab_action.apply_cooldown(jab_action.xeno_cooldown)

	var/datum/action/xeno_action/activable/boxer_punch/punch_action = get_action(upper_cut, /datum/action/xeno_action/activable/boxer_punch)
	if(istype(punch_action))
		punch_action.apply_cooldown(punch_action.xeno_cooldown)

	carbon_target.last_damage_data = create_cause_data(initial(upper_cut.caste_type), upper_cut)

	var/ko_counter = behavior_delegate.ko_counter

	var/damage = ko_counter >= 1
	var/knockback = ko_counter >= 3
	var/knockdown = ko_counter >= 6
	var/knockout = ko_counter >= 9

	var/message = (!damage) ? "weak" : (!knockback) ? "good" : (!knockdown) ? "powerful" : (!knockout) ? "gigantic" : "titanic"

	upper_cut.visible_message(SPAN_XENOWARNING("[upper_cut] hits [carbon_target] with a [message] uppercut!"),
	SPAN_XENOWARNING("We hit [carbon_target] with a [message] uppercut!"))
	var/sound_pick = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(carbon_target, sound_pick, 50, 1)

	if(behavior_delegate.ko_reset_timer != TIMER_ID_NULL)
		deltimer(behavior_delegate.ko_reset_timer)
	behavior_delegate.remove_ko()

	var/obj/limb/target_limb = carbon_target.get_limb(check_zone(upper_cut.zone_selected))

	if(damage)
		carbon_target.apply_armoured_damage(get_xeno_damage_slash(carbon_target, base_damage * ko_counter), ARMOR_MELEE, BRUTE, target_limb? target_limb.name : "chest")

	if(knockout)
		carbon_target.KnockOut(knockout_power)
		behavior_delegate.display_ko_message(carbon_target)
		playsound(carbon_target, 'sound/effects/dingding.ogg', 75, 1)

	if(knockback)
		carbon_target.explosion_throw(base_knockback * ko_counter, get_dir(upper_cut, carbon_target))

	if(knockdown)
		carbon_target.KnockDown(base_knockdown** ko_counter)

	var/mob_multiplier = 1
	if(isxeno(carbon_target))
		mob_multiplier = XVX_WARRIOR_HEALMULT

	if(ko_counter > 0)
		upper_cut.gain_health(mob_multiplier * ko_counter * base_healthgain * upper_cut.maxHealth / 100)

	apply_cooldown()
	..()
