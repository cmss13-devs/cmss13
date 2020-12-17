/datum/action/xeno_action/onclick/toggle_crest_defense/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return

	if(X.fortify)
		to_chat(X, SPAN_XENOWARNING("You cannot use abilities while fortified."))
		return

	if(!X.check_state())
		return

	if(!action_cooldown_check())
		return

	X.crest_defense = !X.crest_defense

	if(X.crest_defense)
		to_chat(X, SPAN_XENOWARNING("You lower your crest."))
		X.armor_deflection_buff += armor_buff
		X.ability_speed_modifier += speed_debuff
		X.mob_size = MOB_SIZE_BIG //knockback immune
		X.update_icons()
	else
		to_chat(X, SPAN_XENOWARNING("You raise your crest."))
		X.armor_deflection_buff -= armor_buff
		X.ability_speed_modifier -= speed_debuff
		X.mob_size = MOB_SIZE_XENO //no longer knockback immune
		X.update_icons()

	apply_cooldown()
	..()
	return

// Defender Headbutt
/datum/action/xeno_action/activable/headbutt/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return

	if(!isXenoOrHuman(A) || X.match_hivemind(A))
		return

	if(!X.check_state())
		return

	if (!action_cooldown_check())
		return

	if(!check_and_use_plasma_owner())
		return

	if(X.fortify && !X.steelcrest)
		to_chat(X, SPAN_XENOWARNING("You cannot use headbutt while fortified."))
		return

	var/mob/living/carbon/H = A
	if(H.stat == DEAD)
		return

	var/distance = get_dist(X, H)

	var/max_distance = 1 + (X.crest_defense * 2)

	if(distance > max_distance)
		return

	if(X.crest_defense || X.steelcrest && !X.fortify)
		X.throw_atom(get_step_towards(H, X), 3, SPEED_SLOW, X)

	if(!X.Adjacent(H))
		return

	apply_cooldown()

	H.last_damage_mob = X
	H.last_damage_source = initial(X.caste_name)
	X.visible_message(SPAN_XENOWARNING("[X] rams [H] with its armored crest!"), \
	SPAN_XENOWARNING("You ram [H] with your armored crest!"))

	if(H.stat != DEAD && (!(H.status_flags & XENO_HOST) || !istype(H.buckled, /obj/structure/bed/nest)) )
		var/h_damage = 20 + (X.crest_defense * 10) + (X.steelcrest * 5) //20 or 30, plus 5
		H.apply_armoured_damage(get_xeno_damage_slash(H, h_damage), ARMOR_MELEE, BRUTE, "chest", 5)
		shake_camera(H, 2, 1)

	var/facing = get_dir(X, H)
	var/headbutt_distance = 3 - (X.crest_defense * 2) + (X.steelcrest) - (X.fortify * 2)
	var/turf/T = get_turf(X)
	var/turf/temp = get_turf(X)

	for(var/x in 0 to headbutt_distance)
		temp = get_step(T, facing)
		if(!temp)
			break
		T = temp

	H.throw_atom(T, headbutt_distance, SPEED_SLOW, src)
	playsound(H,'sound/weapons/alien_claw_block.ogg', 50, 1)

	..()
	return

// Defender Tail Sweep
/datum/action/xeno_action/onclick/tail_sweep/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return

	if(!X.check_state())
		return

	if (!action_cooldown_check())
		return

	if(X.fortify)
		to_chat(src, SPAN_XENOWARNING("You cannot use tail swipe while fortified."))
		return

	if(X.crest_defense)
		to_chat(src, SPAN_XENOWARNING("You cannot use tail swipe with your crest lowered."))
		return

	X.visible_message(SPAN_XENOWARNING("[X] sweeps its tail in a wide circle!"), \
	SPAN_XENOWARNING("You sweep your tail in a wide circle!"))

	if(!check_and_use_plasma_owner())
		return

	X.spin_circle()
	X.emote("tail")

	var/sweep_range = 1
	for(var/mob/living/carbon/H in orange(sweep_range, get_turf(X)))
		if (!isXenoOrHuman(H) || X.match_hivemind(H)) continue
		if(H.stat == DEAD) continue
		if(istype(H.buckled, /obj/structure/bed/nest)) continue
		step_away(H, X, sweep_range, 2)
		H.last_damage_mob = X
		H.last_damage_source = initial(X.caste_name)
		H.apply_armoured_damage(get_xeno_damage_slash(H, 15), ARMOR_MELEE, BRUTE)
		shake_camera(H, 2, 1)

		if(H.mob_size < MOB_SIZE_BIG)
			H.KnockDown(get_xeno_stun_duration(H, 1), 1)

		to_chat(H, SPAN_XENOWARNING("You are struck by [src]'s tail sweep!"))
		playsound(H,'sound/weapons/alien_claw_block.ogg', 50, 1)

	apply_cooldown()
	..()
	return

// Defender Fortify
/datum/action/xeno_action/activable/fortify/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return

	if(X.crest_defense && X.steelcrest)
		to_chat(src, SPAN_XENOWARNING("You cannot fortify while your crest is already down!"))
		return

	if(X.crest_defense)
		to_chat(src, SPAN_XENOWARNING("You cannot use fortify with your crest lowered."))
		return

	if(!X.check_state())
		return

	if (!action_cooldown_check())
		return

	playsound(get_turf(X), 'sound/effects/stonedoor_openclose.ogg', 30, 1)

	if(!X.fortify)
		to_chat(X, SPAN_XENOWARNING("You tuck yourself into a defensive stance."))
		if(X.steelcrest)
			X.armor_deflection_buff += 30
			X.armor_explosive_buff += 60
			X.ability_speed_modifier += 1
			X.damage_modifier -= XENO_DAMAGE_MOD_VERYSMALL
		else
			X.armor_deflection_buff += 35
			X.armor_explosive_buff += 60
			X.frozen = TRUE
			X.anchored = TRUE
			X.small_explosives_stun = FALSE
			X.update_canmove()
		X.mob_size = MOB_SIZE_BIG //knockback immune
		X.update_icons()
		X.fortify = TRUE
	else
		to_chat(X, SPAN_XENOWARNING("You resume your normal stance."))
		X.frozen = FALSE
		X.anchored = FALSE
		if(X.steelcrest)
			X.armor_deflection_buff -= 30
			X.armor_explosive_buff -= 60
			X.ability_speed_modifier -= 1
			X.damage_modifier += XENO_DAMAGE_MOD_VERYSMALL
		else
			X.armor_deflection_buff -= 35
			X.armor_explosive_buff -= 60
			X.small_explosives_stun = TRUE
		X.mob_size = MOB_SIZE_XENO //no longer knockback immune
		X.update_canmove()
		X.update_icons()
		X.fortify = FALSE

	apply_cooldown()
	..()
	return
