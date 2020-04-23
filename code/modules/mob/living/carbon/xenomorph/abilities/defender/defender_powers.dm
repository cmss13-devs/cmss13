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
		X.update_icons()
	else
		to_chat(src, SPAN_XENOWARNING("You raise your crest."))
		X.armor_deflection_buff -= armor_buff
		X.ability_speed_modifier -= speed_debuff
		X.update_icons()

	apply_cooldown()
	..()
	return


// Defender Fortify
/datum/action/xeno_action/activable/fortify/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return

	if(X.crest_defense && X.spiked)
		to_chat(src, SPAN_XENOWARNING("You cannot fortify while your crest is already down!"))
		return

	if(X.crest_defense)
		to_chat(src, SPAN_XENOWARNING("You cannot use abilities with your crest lowered."))
		return

	if(!X.check_state())
		return

	if (!action_cooldown_check())
		return

	playsound(get_turf(X), 'sound/effects/stonedoor_openclose.ogg', 30, 1)

	if(!X.fortify)
		to_chat(X, SPAN_XENOWARNING("You tuck yourself into a defensive stance."))
		X.armor_deflection_buff += 40
		X.armor_explosive_buff += 60
		if(!X.spiked)
			X.frozen = TRUE
			X.anchored = TRUE
			X.update_canmove()
		if(X.spiked)
			X.ability_speed_modifier += 2.5
		X.update_icons()
		X.fortify = TRUE
	else
		to_chat(X, SPAN_XENOWARNING("You resume your normal stance."))
		X.armor_deflection_buff -= 40
		X.armor_explosive_buff -= 60
		X.frozen = FALSE
		X.anchored = FALSE
		if(X.spiked)
			X.ability_speed_modifier -= 2.5
		
		X.update_canmove()
		X.update_icons()
		X.fortify = FALSE

	apply_cooldown()
	..()
	return


// Defender Headbutt
/datum/action/xeno_action/activable/headbutt/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return

	if(!A || !istype(A, /mob/living/carbon/human))
		return

	if(!X.check_state())
		return

	if (!action_cooldown_check())
		return

	if(!check_and_use_plasma_owner())
		return

	if(X.fortify)
		to_chat(X, SPAN_XENOWARNING("You cannot use abilities while fortified."))
		return

	if(X.crest_defense && !X.spiked)
		to_chat(X, SPAN_XENOWARNING("You cannot use abilities with your crest lowered."))
		return

	var/mob/living/carbon/human/H = A
	if(H.stat == DEAD)
		return

	var/distance = get_dist(X, H)

	var/max_distance = 2 + X.spiked

	if(distance > max_distance)
		return

	if(distance > 1)
		X.launch_towards(get_step_towards(H, X), 3, SPEED_SLOW, X)

	if(!X.Adjacent(H))
		return

	H.last_damage_mob = X
	H.last_damage_source = initial(X.caste_name)
	X.visible_message(SPAN_XENOWARNING("[X] rams [H] with its armored crest!"), \
	SPAN_XENOWARNING("You ram [H] with your armored crest!"))

	if(H.stat != DEAD && (!(H.status_flags & XENO_HOST) || !istype(H.buckled, /obj/structure/bed/nest)) )
		var/h_damage = 20 + (X.spiked * 5)
		H.apply_damage(h_damage)
		shake_camera(H, 2, 1)

	var/facing = get_dir(X, H)
	var/headbutt_distance = X.spiked + 3
	var/turf/T = get_turf(X)
	var/turf/temp = get_turf(X)

	for(var/x in 0 to headbutt_distance-1)
		temp = get_step(T, facing)
		if(!temp)
			break
		T = temp

	H.launch_towards(T, headbutt_distance, SPEED_SLOW, src)
	playsound(H,'sound/weapons/alien_claw_block.ogg', 50, 1)

	apply_cooldown()
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

	if(!check_and_use_plasma_owner())
		return

	if(X.fortify)
		to_chat(src, SPAN_XENOWARNING("You cannot use abilities while fortified."))
		return

	if(X.crest_defense)
		to_chat(src, SPAN_XENOWARNING("You cannot use abilities with your crest lowered."))
		return

	X.visible_message(SPAN_XENOWARNING("[X] sweeps its tail in a wide circle!"), \
	SPAN_XENOWARNING("You sweep your tail in a wide circle!"))

	X.spin_circle()

	var/sweep_range = 1
	for(var/mob/living/carbon/human/H in orange(sweep_range, get_turf(X)))
		if(H != H.handle_barriers(X)) continue
		if(H.stat == DEAD) continue
		if(istype(H.buckled, /obj/structure/bed/nest)) continue
		step_away(H, X, sweep_range, 2)
		H.last_damage_mob = X
		H.last_damage_source = initial(X.caste_name)
		H.apply_damage(10)
		shake_camera(H, 2, 1)

		H.KnockDown(2, 1)

		to_chat(H, SPAN_XENOWARNING("You are struck by [src]'s tail sweep!"))
		playsound(H,'sound/weapons/alien_claw_block.ogg', 50, 1)

	apply_cooldown()
	..()
	return
