/datum/action/xeno_action/onclick/toggle_crest/use_ability(atom/target)
	var/mob/living/carbon/Xenomorph/xeno = owner
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
/datum/action/xeno_action/activable/headbutt/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return

	if(!isXenoOrHuman(A) || X.can_not_harm(A))
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

	var/max_distance = 3 - (X.crest_defense * 2)

	if(distance > max_distance)
		return

	if(!X.crest_defense)
		apply_cooldown()
		X.throw_atom(get_step_towards(H, X), 3, SPEED_SLOW, X)
	if(!X.Adjacent(H))
		on_cooldown_end()
		return

	H.last_damage_data = create_cause_data(X.caste_type, X)
	X.visible_message(SPAN_XENOWARNING("[X] rams [H] with its armored crest!"), \
	SPAN_XENOWARNING("You ram [H] with your armored crest!"))

	if(H.stat != DEAD && (!(H.status_flags & XENO_HOST) || !HAS_TRAIT(H, TRAIT_NESTED)) )
		var/h_damage = 30 - (X.crest_defense * 10) + (X.steelcrest * 7.5) //30 if crest up, 20 if down, plus 7.5
		H.apply_armoured_damage(get_xeno_damage_slash(H, h_damage), ARMOR_MELEE, BRUTE, "chest", 5)

	var/facing = get_dir(X, H)
	var/headbutt_distance = 1 + (X.crest_defense * 2) + (X.fortify * 2)
	var/turf/T = get_turf(X)
	var/turf/temp = get_turf(X)

	for(var/x in 0 to headbutt_distance)
		temp = get_step(T, facing)
		if(!temp)
			break
		T = temp

	H.throw_atom(T, headbutt_distance, SPEED_SLOW, src)
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
		if (!isXenoOrHuman(H) || X.can_not_harm(H)) continue
		if(H.stat == DEAD) continue
		if(HAS_TRAIT(H, TRAIT_NESTED)) continue
		step_away(H, X, sweep_range, 2)
		H.last_damage_data = create_cause_data(X.caste_type, X)
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
/datum/action/xeno_action/activable/fortify/use_ability(atom/target)
	var/mob/living/carbon/Xenomorph/xeno = owner
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
		RegisterSignal(owner, COMSIG_MOB_DEATH, .proc/death_check)
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
	if(xeno.fortify && xeno.selected_ability != src)
		button.icon_state = "template_active"

/datum/action/xeno_action/activable/fortify/action_deselect()
	..()
	var/mob/living/carbon/Xenomorph/xeno = owner
	if(xeno.fortify)
		button.icon_state = "template_active"

/datum/action/xeno_action/activable/fortify/proc/fortify_switch(var/mob/living/carbon/Xenomorph/X, var/fortify_state)
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
		X.mob_size = MOB_SIZE_XENO //no longer knockback immune
		X.mob_flags |= SQUEEZE_UNDER_VEHICLES
		X.update_canmove()
		X.update_icons()
		X.fortify = FALSE

/datum/action/xeno_action/activable/fortify/proc/death_check()
	SIGNAL_HANDLER

	UnregisterSignal(owner, COMSIG_MOB_DEATH)
	fortify_switch(owner, FALSE)


// Steel Tail Strain

/datum/action/xeno_action/activable/tail_slam/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return

	if(!isXenoOrHuman(A) || X.can_not_harm(A))
		return

	if(!X.check_state())
		return

	if (!action_cooldown_check())
		return

	if(!check_and_use_plasma_owner())
		return


	var/mob/living/carbon/H = A
	if(H.stat == DEAD)
		return

	var/distance = get_dist(X, H)

	var/slow_duration = 30

	var/max_distance = 1

	if(distance > max_distance)
		return

	if(!X.Adjacent(H))
		on_cooldown_end()
		return

	H.last_damage_data = create_cause_data(X.caste_type, X)
	X.visible_message(SPAN_XENOWARNING("[X] spins, then loudly slams [H] with its tail!"), \
	SPAN_XENOWARNING("You slam [H] with your tail!"))

	if (H.knocked_down)
		to_chat(H, SPAN_XENOWARNING("You are struck harder by [src]'s tail!"))
		new /datum/effects/xeno_slow(H, X, null, null, get_xeno_stun_duration(H, slow_duration))

	if(H.stat != DEAD && (!(H.status_flags & XENO_HOST) || !HAS_TRAIT(H, TRAIT_NESTED)) )
		var/h_damage = 25
		X.spin_circle()
		X.emote("tail")
		H.apply_armoured_damage(get_xeno_damage_slash(H, h_damage), ARMOR_MELEE, BRUTE, "chest", 10)
		H.Daze(tail_slam)
		shake_camera(H, 2, 1)

	playsound(H, 'sound/effects/bang.ogg', 30, 1)
	apply_cooldown()
	..()
	return


/datum/action/xeno_action/activable/tail_swing/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!istype(X) || !X.check_state() || !action_cooldown_check())
		return

	if(!A || A.layer >= FLY_LAYER || !isturf(X.loc))
		return

	if (!check_plasma_owner())
		return

	// Transient turf list
	var/list/target_turfs = list()
	var/list/temp_turfs = list()
	var/list/telegraph_atom_list = list()

	// Code to get a 2x3 area of turfs
	var/turf/root = get_turf(X)
	var/facing = Get_Compass_Dir(X, A)
	var/turf/infront = get_step(root, facing)
	var/turf/left = get_step(root, turn(facing, 90))
	var/turf/right = get_step(root, turn(facing, -90))
	var/turf/infront_left = get_step(root, turn(facing, 45))
	var/turf/infront_right = get_step(root, turn(facing, -45))
	temp_turfs += infront
	if(!(!infront || infront.density) && !(!left || left.density))
		temp_turfs += infront_left
	if(!(!infront || infront.density) && !(!right || right.density))
		temp_turfs += infront_right

	for(var/turf/T in temp_turfs)
		if (!istype(T))
			continue

		if (T.density)
			continue

		target_turfs += T
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/tail_swing(T, windup)

		var/turf/next_turf = get_step(T, facing)
		if (!istype(next_turf) || next_turf.density)
			continue

		target_turfs += next_turf
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/tail_swing(next_turf, windup)

	if(!length(target_turfs))
		to_chat(X, SPAN_XENOWARNING("You don't have any room to do your tail swing!"))
		return

	if(!do_after(X, windup, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		to_chat(X, SPAN_XENOWARNING("You cancel your tail swing."))

		for(var/obj/effect/xenomorph/xeno_telegraph/XT in telegraph_atom_list)
			telegraph_atom_list -= XT
			qdel(XT)
		return

	if(!action_cooldown_check() || !check_and_use_plasma_owner())
		return

	apply_cooldown()

	X.visible_message(SPAN_XENODANGER("[X] swings its tail forward, hitting everything in front of it!"), SPAN_XENODANGER("You swing your tail forward, hitting everything in front of you!"))
	X.spin_circle()
	X.emote("tail")

	for (var/turf/T in target_turfs)
		for (var/mob/living/carbon/H in T)
			if (H.stat == DEAD)
				continue

			if(!isXenoOrHuman(H) || X.can_not_harm(H))
				continue

			if(H.mob_size >= MOB_SIZE_BIG)
				continue

			H.KnockDown(get_xeno_stun_duration(H, 1))

	..()
	return

/datum/action/xeno_action/activable/tail_fling/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return

	if (!isXenoOrHuman(A) || X.can_not_harm(A))
		return

	if (!X.check_state() || X.agility)
		return

	if (!X.Adjacent(A))
		return

	var/mob/living/carbon/H = A
	if(H.stat == DEAD) return
	if(HAS_TRAIT(H, TRAIT_NESTED))
		return

	if(H == X.pulling)
		X.stop_pulling()

	if(H.mob_size >= MOB_SIZE_BIG)
		to_chat(X, SPAN_XENOWARNING("Your fling proves ineffective due to [H]'s size!"))
		return

	if (!check_and_use_plasma_owner())
		return


	var/facing = get_dir(X, H)
	var/turf/temp = X.loc
	var/turf/T = X.loc

	var/datum/launch_metadata/LM = new()
	LM.target = T
	LM.speed = SPEED_FAST
	LM.thrower = X
	LM.spin = FALSE
	LM.pass_flags = PASS_OVER_THROW_MOB|PASS_MOB_THRU_XENO|PASS_MOB_IS_HUMAN


	if(X.a_intent == INTENT_HARM) //If we use the ability on hurt intent, we throw them in front; otherwise we throw them behind.
		LM.range = 2
		for (var/x in 0 to fling_distance-1)
			temp = get_step(T, facing)
			if (!temp)
				break
			T = temp
		X.visible_message(SPAN_XENOWARNING("\The [X] flings [H] away with its tail!"), SPAN_XENOWARNING("You fling [H] away with your tail!"))

	else
		LM.range = 4
		facing = get_dir(H, X)

		for (var/x in 0 to fling_distance-1)
			temp = get_step(T, facing)
			if (!temp)
				break
			T = temp
		X.visible_message(SPAN_XENOWARNING("\The [X] flings [H] behind with its tail!"), SPAN_XENOWARNING("You fling [H] behind you with your tail!"))


	playsound(H,'sound/weapons/alien_claw_block.ogg', 75, 1)
	H.last_damage_data = create_cause_data(initial(X.caste_type), X)
	shake_camera(H, 2, 1)

	X.spin_circle()
	X.emote("tail")
	LM.target = T
	H.launch_towards(LM)
	H.KnockDown(get_xeno_stun_duration(H, 0.2))

	apply_cooldown()
	..()
	return
