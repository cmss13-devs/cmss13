/datum/action/xeno_action/onclick/toggle_crest/use_ability(atom/target)
	var/mob/living/carbon/Xenomorph/xeno = owner
	var/datum/behavior_delegate/defender_base/defender_delegate = xeno.behavior_delegate
	if (!istype(xeno))
		return

	if(defender_delegate.fortified)
		to_chat(xeno, SPAN_XENOWARNING("You cannot use abilities while fortified."))
		return

	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	if(defender_delegate.crest_lowered == FALSE)
		to_chat(xeno, SPAN_XENOWARNING("You lower your crest."))
		defender_delegate.crest_lowered = TRUE
		xeno.ability_speed_modifier += speed_debuff
		xeno.armor_deflection_buff += armor_buff
		xeno.mob_size = MOB_SIZE_BIG //knockback immune
		button.icon_state = "template_active"
		xeno.update_icons()
	else
		to_chat(xeno, SPAN_XENOWARNING("You raise your crest."))
		defender_delegate.crest_lowered = FALSE
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
	var/mob/living/carbon/Xenomorph/fendy = owner
	var/datum/behavior_delegate/defender_base/defender_delegate = fendy.behavior_delegate
	if (!istype(fendy))
		return

	if(!isXenoOrHuman(target_atom) || fendy.can_not_harm(target_atom))
		return

	if(!fendy.check_state())
		return

	if (!action_cooldown_check())
		return

	if(!check_and_use_plasma_owner())
		return

	if(defender_delegate.fortified && !defender_delegate.steelcrest_strain)
		to_chat(fendy, SPAN_XENOWARNING("You cannot use headbutt while fortified."))
		return

	var/mob/living/carbon/carbone = target_atom
	if(carbone.stat == DEAD)
		return

	var/distance = get_dist(fendy, carbone)

	var/max_distance = 3
	if(defender_delegate.crest_lowered)
		max_distance = 1

	if(distance > max_distance)
		return

	if(defender_delegate.crest_lowered == FALSE)
		apply_cooldown()
		fendy.throw_atom(get_step_towards(carbone, fendy), 3, SPEED_SLOW, fendy)
	if(!fendy.Adjacent(carbone))
		on_cooldown_end()
		return

	carbone.last_damage_data = create_cause_data(fendy.caste_type, fendy)
	fendy.visible_message(SPAN_XENOWARNING("[fendy] rams [carbone] with its armored crest!"), \
	SPAN_XENOWARNING("You ram [carbone] with your armored crest!"))

	var/strain_damage = defender_delegate.steelcrest_strain ? 7.5 : 0

	var/crest_damage = defender_delegate.crest_lowered ? -10 : 0

	if(carbone.stat != DEAD && (!(carbone.status_flags & XENO_HOST) || !HAS_TRAIT(carbone, TRAIT_NESTED)) )
		var/h_damage = fendy.caste.melee_damage_upper + crest_damage + strain_damage
		carbone.apply_armoured_damage(get_xeno_damage_slash(carbone, h_damage), ARMOR_MELEE, BRUTE, "chest", 5)

	var/facing = get_dir(fendy, carbone)
	var/headbutt_distance = 1
	if(defender_delegate.crest_lowered || defender_delegate.fortified)
		headbutt_distance += 2
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
	var/mob/living/carbon/Xenomorph/fender = owner
	var/datum/behavior_delegate/defender_base/defender_delegate = fender.behavior_delegate
	if (!istype(fender))
		return

	if(!fender.check_state())
		return

	if (!action_cooldown_check())
		return

	if(defender_delegate.fortified)
		to_chat(src, SPAN_XENOWARNING("You cannot use tail swipe while fortified."))
		return

	if(defender_delegate.crest_lowered)
		to_chat(src, SPAN_XENOWARNING("You cannot use tail swipe with your crest lowered."))
		return

	fender.visible_message(SPAN_XENOWARNING("[fender] sweeps its tail in a wide circle!"), \
	SPAN_XENOWARNING("You sweep your tail in a wide circle!"))

	if(!check_and_use_plasma_owner())
		return

	fender.spin_circle()
	fender.emote("tail")

	var/sweep_range = 1
	for(var/mob/living/carbon/H in orange(sweep_range, get_turf(fender)))
		if (!isXenoOrHuman(H) || fender.can_not_harm(H)) continue
		if(H.stat == DEAD) continue
		if(HAS_TRAIT(H, TRAIT_NESTED)) continue
		step_away(H, fender, sweep_range, 2)
		fender.flick_attack_overlay(H, "punch")
		H.last_damage_data = create_cause_data(fender.caste_type, fender)
		H.apply_armoured_damage(get_xeno_damage_slash(H, 15), ARMOR_MELEE, BRUTE)
		shake_camera(H, 2, 1)

		if(H.mob_size < MOB_SIZE_BIG)
			H.apply_effect(get_xeno_stun_duration(H, 1), WEAKEN)

		to_chat(H, SPAN_XENOWARNING("You are struck by [src]'s tail sweep!"))
		playsound(H,'sound/weapons/alien_claw_block.ogg', 50, 1)

	apply_cooldown()
	..()
	return

// Defender Fortify
/datum/action/xeno_action/activable/fortify/use_ability(atom/target)
	var/mob/living/carbon/Xenomorph/xeno = owner
	var/datum/behavior_delegate/defender_base/defender_delegate = xeno.behavior_delegate
	if (!istype(xeno))
		return

	if(defender_delegate.crest_lowered)
		to_chat(src, SPAN_XENOWARNING("You cannot use fortify with your crest lowered."))
		return

	if(!xeno.check_state())
		return

	if (!action_cooldown_check())
		return

	playsound(get_turf(xeno), 'sound/effects/stonedoor_openclose.ogg', 30, 1)

	if(defender_delegate.fortified == FALSE)
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
	var/mob/living/carbon/Xenomorph/xeno = owner
	var/datum/behavior_delegate/defender_base/defender_delegate = xeno.behavior_delegate
	if(defender_delegate.fortified && xeno.selected_ability != src)
		button.icon_state = "template_active"

/datum/action/xeno_action/activable/fortify/action_deselect()
	..()
	var/mob/living/carbon/Xenomorph/xeno = owner
	var/datum/behavior_delegate/defender_base/defender_delegate = xeno.behavior_delegate
	if(defender_delegate.fortified)
		button.icon_state = "template_active"

/datum/action/xeno_action/activable/fortify/proc/fortify_switch(var/mob/living/carbon/Xenomorph/fender, var/fortify_state)
	var/datum/behavior_delegate/defender_base/defender_delegate = fender.behavior_delegate
	if(defender_delegate.fortified == fortify_state)
		return

	if(fortify_state)
		to_chat(fender, SPAN_XENOWARNING("You tuck yourself into a defensive stance."))
		if(defender_delegate.steelcrest_strain)
			fender.armor_deflection_buff += 10
			fender.armor_explosive_buff += 60
			fender.ability_speed_modifier += 3
			fender.damage_modifier -= XENO_DAMAGE_MOD_SMALL
		else
			fender.armor_deflection_buff += 30
			fender.armor_explosive_buff += 60
			fender.frozen = TRUE
			fender.anchored = TRUE
			fender.small_explosives_stun = FALSE
			fender.update_canmove()
		RegisterSignal(owner, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, PROC_REF(check_directional_armor))
		fender.mob_size = MOB_SIZE_IMMOBILE //knockback immune
		fender.mob_flags &= ~SQUEEZE_UNDER_VEHICLES
		fender.update_icons()
		defender_delegate.fortified = TRUE
	else
		to_chat(fender, SPAN_XENOWARNING("You resume your normal stance."))
		fender.frozen = FALSE
		fender.anchored = FALSE
		if(defender_delegate.steelcrest_strain)
			fender.armor_deflection_buff -= 10
			fender.armor_explosive_buff -= 60
			fender.ability_speed_modifier -= 3
			fender.damage_modifier += XENO_DAMAGE_MOD_SMALL
		else
			fender.armor_deflection_buff -= 30
			fender.armor_explosive_buff -= 60
			fender.small_explosives_stun = TRUE
		UnregisterSignal(owner, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE)
		fender.mob_size = MOB_SIZE_XENO //no longer knockback immune
		fender.mob_flags |= SQUEEZE_UNDER_VEHICLES
		fender.update_canmove()
		fender.update_icons()
		defender_delegate.fortified = FALSE

/datum/action/xeno_action/activable/fortify/proc/check_directional_armor(var/mob/living/carbon/Xenomorph/defendy, list/damagedata)
	SIGNAL_HANDLER
	var/datum/behavior_delegate/defender_base/defender_delegate = defendy.behavior_delegate
	var/projectile_direction = damagedata["direction"]
	if(defendy.dir & REVERSE_DIR(projectile_direction))
		if(defender_delegate.steelcrest_strain)
			damagedata["armor"] += steelcrest_frontal_armor
		else
			damagedata["armor"] += frontal_armor

/datum/action/xeno_action/activable/fortify/proc/death_check()
	SIGNAL_HANDLER

	UnregisterSignal(owner, COMSIG_MOB_DEATH)
	fortify_switch(owner, FALSE)
