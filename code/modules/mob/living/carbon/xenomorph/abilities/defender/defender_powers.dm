/datum/action/xeno_action/onclick/toggle_crest/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if(xeno.fortify)
		to_chat(xeno, SPAN_XENOWARNING("You cannot use abilities while fortified."))
		return

	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	xeno.crest_defense = !xeno.crest_defense

	if(xeno.crest_defense)
		to_chat(xeno, SPAN_XENOWARNING("You lower your crest."))
		xeno.ability_speed_modifier += speed_debuff
		xeno.armor_deflection_buff += armor_buff
		xeno.mob_size = MOB_SIZE_BIG //knockback immune
		button.icon_state = "template_active"
		xeno.update_icons()
	else
		to_chat(xeno, SPAN_XENOWARNING("You raise your crest."))
		xeno.ability_speed_modifier -= speed_debuff
		xeno.armor_deflection_buff -= armor_buff
		xeno.mob_size = MOB_SIZE_XENO //no longer knockback immune
		button.icon_state = "template"
		xeno.update_icons()

	apply_cooldown()
	..()
	return

// Defender Headbutt
/datum/action/xeno_action/activable/headbutt/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/fendy = owner
	if (!istype(fendy))
		return

	if(!isxeno_human(target_atom) || fendy.can_not_harm(target_atom))
		return

	if(!fendy.check_state())
		return

	if (!action_cooldown_check())
		return

	if(!check_and_use_plasma_owner())
		return

	if(fendy.fortify && !fendy.steelcrest)
		to_chat(fendy, SPAN_XENOWARNING("You cannot use headbutt while fortified."))
		return

	var/mob/living/carbon/carbone = target_atom
	if(carbone.stat == DEAD)
		return

	var/distance = get_dist(fendy, carbone)

	var/max_distance = 3 - (fendy.crest_defense * 2)

	if(distance > max_distance)
		return

	if(!fendy.crest_defense)
		apply_cooldown()
		fendy.throw_atom(get_step_towards(carbone, fendy), 3, SPEED_SLOW, fendy)
	if(!fendy.Adjacent(carbone))
		on_cooldown_end()
		return

	carbone.last_damage_data = create_cause_data(fendy.caste_type, fendy)
	fendy.visible_message(SPAN_XENOWARNING("[fendy] rams [carbone] with its armored crest!"), \
	SPAN_XENOWARNING("You ram [carbone] with your armored crest!"))

	if(carbone.stat != DEAD && (!(carbone.status_flags & XENO_HOST) || !HAS_TRAIT(carbone, TRAIT_NESTED)) )
		var/h_damage = 30 - (fendy.crest_defense * 10) + (fendy.steelcrest * 7.5) //30 if crest up, 20 if down, plus 7.5
		carbone.apply_armoured_damage(get_xeno_damage_slash(carbone, h_damage), ARMOR_MELEE, BRUTE, "chest", 5)

	var/facing = get_dir(fendy, carbone)
	var/headbutt_distance = 1 + (fendy.crest_defense * 2) + (fendy.fortify * 2)
	var/turf/thrown_turf = get_turf(fendy)
	var/turf/temp = get_turf(fendy)

	for(var/x in 0 to headbutt_distance)
		temp = get_step(thrown_turf, facing)
		if(!temp)
			break
		thrown_turf = temp

	// Hmm today I will kill a marine while looking away from them
	fendy.face_atom(carbone)
	fendy.animation_attack_on(carbone)
	fendy.flick_attack_overlay(carbone, "punch")
	carbone.throw_atom(thrown_turf, headbutt_distance, SPEED_SLOW, src)
	playsound(carbone,'sound/weapons/alien_claw_block.ogg', 50, 1)
	apply_cooldown()
	..()
	return

// Defender Tail Sweep
/datum/action/xeno_action/onclick/tail_sweep/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if(!xeno.check_state())
		return

	if (!action_cooldown_check())
		return

	if(xeno.fortify)
		to_chat(src, SPAN_XENOWARNING("You cannot use tail swipe while fortified."))
		return

	if(xeno.crest_defense)
		to_chat(src, SPAN_XENOWARNING("You cannot use tail swipe with your crest lowered."))
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] sweeps its tail in a wide circle!"), \
	SPAN_XENOWARNING("You sweep your tail in a wide circle!"))

	if(!check_and_use_plasma_owner())
		return

	xeno.spin_circle()
	xeno.emote("tail")

	var/sweep_range = 1
	for(var/mob/living/carbon/human in orange(sweep_range, get_turf(xeno)))
		if (!isxeno_human(human) || xeno.can_not_harm(human))
			continue
		if(human.stat == DEAD)
			continue
		if(HAS_TRAIT(human, TRAIT_NESTED))
			continue
		step_away(human, xeno, sweep_range, 2)
		xeno.flick_attack_overlay(human, "punch")
		human.last_damage_data = create_cause_data(xeno.caste_type, xeno)
		human.apply_armoured_damage(get_xeno_damage_slash(xeno, 15), ARMOR_MELEE, BRUTE)
		shake_camera(human, 2, 1)

		if(human.mob_size < MOB_SIZE_BIG)
			human.apply_effect(get_xeno_stun_duration(human, 1), WEAKEN)

		to_chat(human, SPAN_XENOWARNING("You are struck by [xeno]'s tail sweep!"))
		playsound(human,'sound/weapons/alien_claw_block.ogg', 50, 1)

	apply_cooldown()
	..()
	return

// Defender Fortify
/datum/action/xeno_action/activable/fortify/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if(xeno.crest_defense && xeno.steelcrest)
		to_chat(src, SPAN_XENOWARNING("You cannot fortify while your crest is already down!"))
		return

	if(xeno.crest_defense)
		to_chat(src, SPAN_XENOWARNING("You cannot use fortify with your crest lowered."))
		return

	if(!xeno.check_state())
		return

	if (!action_cooldown_check())
		return

	playsound(get_turf(xeno), 'sound/effects/stonedoor_openclose.ogg', 30, 1)

	if(!xeno.fortify)
		RegisterSignal(owner, COMSIG_MOB_DEATH, PROC_REF(death_check))
		fortify_switch(xeno, TRUE)
		if(xeno.selected_ability != src)
			button.icon_state = "template_active"
	else
		UnregisterSignal(owner, COMSIG_MOB_DEATH)
		fortify_switch(xeno, FALSE)
		if(xeno.selected_ability != src)
			button.icon_state = "template"

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/fortify/action_activate()
	..()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(xeno.fortify && xeno.selected_ability != src)
		button.icon_state = "template_active"

/datum/action/xeno_action/activable/fortify/action_deselect()
	..()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(xeno.fortify)
		button.icon_state = "template_active"

/datum/action/xeno_action/activable/fortify/proc/fortify_switch(mob/living/carbon/xenomorph/X, fortify_state)
	if(X.fortify == fortify_state)
		return

	if(fortify_state)
		to_chat(X, SPAN_XENOWARNING("You tuck yourself into a defensive stance."))
		if(X.steelcrest)
			X.armor_deflection_buff += 10
			X.armor_explosive_buff += 60
			X.ability_speed_modifier += 3
			X.damage_modifier -= XENO_DAMAGE_MOD_SMALL
		else
			X.armor_deflection_buff += 30
			X.armor_explosive_buff += 60
			X.frozen = TRUE
			X.anchored = TRUE
			X.small_explosives_stun = FALSE
			X.update_canmove()
		RegisterSignal(owner, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, PROC_REF(check_directional_armor))
		X.mob_size = MOB_SIZE_IMMOBILE //knockback immune
		X.mob_flags &= ~SQUEEZE_UNDER_VEHICLES
		X.update_icons()
		X.fortify = TRUE
	else
		to_chat(X, SPAN_XENOWARNING("You resume your normal stance."))
		X.frozen = FALSE
		X.anchored = FALSE
		if(X.steelcrest)
			X.armor_deflection_buff -= 10
			X.armor_explosive_buff -= 60
			X.ability_speed_modifier -= 3
			X.damage_modifier += XENO_DAMAGE_MOD_SMALL
		else
			X.armor_deflection_buff -= 30
			X.armor_explosive_buff -= 60
			X.small_explosives_stun = TRUE
		UnregisterSignal(owner, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE)
		X.mob_size = MOB_SIZE_XENO //no longer knockback immune
		X.mob_flags |= SQUEEZE_UNDER_VEHICLES
		X.update_canmove()
		X.update_icons()
		X.fortify = FALSE

/datum/action/xeno_action/activable/fortify/proc/check_directional_armor(mob/living/carbon/xenomorph/defendy, list/damagedata)
	SIGNAL_HANDLER
	var/projectile_direction = damagedata["direction"]
	if(defendy.dir & REVERSE_DIR(projectile_direction))
		if(defendy.mutation_type == DEFENDER_STEELCREST)
			damagedata["armor"] += steelcrest_frontal_armor
		else
			damagedata["armor"] += frontal_armor

/datum/action/xeno_action/activable/fortify/proc/death_check()
	SIGNAL_HANDLER

	UnregisterSignal(owner, COMSIG_MOB_DEATH)
	fortify_switch(owner, FALSE)
