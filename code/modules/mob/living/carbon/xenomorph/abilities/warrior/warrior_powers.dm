/datum/action/xeno_action/activable/lunge/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		if(twitch_message_cooldown < world.time )
			X.visible_message(SPAN_XENOWARNING("\The [X]'s claws twitch."), SPAN_XENOWARNING("Your claws twitch as you try to lunge but lack the strength. Wait a moment to try again."))
			twitch_message_cooldown = world.time + 5 SECONDS
		return //this gives a little feedback on why your lunge didn't hit other than the lunge button going grey. Plus, it might spook marines that almost got lunged if they know why the message appeared, and extra spookiness is always good.

	if (!A)
		return

	if (!isturf(X.loc))
		to_chat(X, SPAN_XENOWARNING("You can't lunge from here!"))
		return

	if (!X.check_state() || X.agility)
		return

	if(X.can_not_harm(A) || !ismob(A))
		apply_cooldown_override(click_miss_cooldown)
		return

	var/mob/living/carbon/H = A
	if(H.stat == DEAD)
		return

	if (!check_and_use_plasma_owner())
		return

	apply_cooldown()
	..()

	X.visible_message(SPAN_XENOWARNING("\The [X] lunges towards [H]!"), SPAN_XENOWARNING("You lunge at [H]!"))

	X.throw_atom(get_step_towards(A, X), grab_range, SPEED_FAST, X)

	if (X.Adjacent(H))
		X.start_pulling(H,1)
	else
		X.visible_message(SPAN_XENOWARNING("\The [X]'s claws twitch."), SPAN_XENOWARNING("Your claws twitch as you lunge but are unable to grab onto your target. Wait a moment to try again."))

	return TRUE

/datum/action/xeno_action/onclick/toggle_agility/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return

	if (!X.check_state(1))
		return

	X.agility = !X.agility
	if (X.agility)
		to_chat(X, SPAN_XENOWARNING("You lower yourself to all fours."))
	else
		to_chat(X, SPAN_XENOWARNING("You raise yourself to stand on two feet."))
	X.update_icons()

	apply_cooldown()
	..()


/datum/action/xeno_action/activable/fling/use_ability(atom/A)
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
		to_chat(X, SPAN_XENOWARNING("[H] is too big for you to fling!"))
		return

	if (!check_and_use_plasma_owner())
		return

	X.visible_message(SPAN_XENOWARNING("\The [X] effortlessly flings [H] to the side!"), SPAN_XENOWARNING("You effortlessly fling [H] to the side!"))
	playsound(H,'sound/weapons/alien_claw_block.ogg', 75, 1)
	if(stun_power)
		H.apply_effect(get_xeno_stun_duration(H, stun_power), STUN)
	if(weaken_power)
		H.apply_effect(weaken_power, WEAKEN)
	if(slowdown)
		if(H.slowed < slowdown)
			H.Slow(slowdown)
	H.last_damage_data = create_cause_data(initial(X.caste_type), X)
	shake_camera(H, 2, 1)

	var/facing = get_dir(X, H)
	var/turf/T = X.loc
	var/turf/temp = X.loc

	for (var/x in 0 to fling_distance-1)
		temp = get_step(T, facing)
		if (!temp)
			break
		T = temp

	H.throw_atom(T, fling_distance, SPEED_VERY_FAST, X, TRUE)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/warrior_punch/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return

	if (!isXenoOrHuman(A) || X.can_not_harm(A))
		return

	if (!X.check_state() || X.agility)
		return

	var/distance = get_dist(X, A)

	if (distance > 2)
		return

	var/mob/living/carbon/H = A

	if (!X.Adjacent(H))
		return

	if(H.stat == DEAD) return
	if(HAS_TRAIT(H, TRAIT_NESTED)) return

	var/obj/limb/L = H.get_limb(check_zone(X.zone_selected))

	if (ishuman(H) && (!L || (L.status & LIMB_DESTROYED)))
		return


	if (!check_and_use_plasma_owner())
		return

	H.last_damage_data = create_cause_data(initial(X.caste_type), X)

	X.visible_message(SPAN_XENOWARNING("\The [X] hits [H] in the [L? L.display_name : "chest"] with a devastatingly powerful punch!"), \
	SPAN_XENOWARNING("You hit [H] in the [L? L.display_name : "chest"] with a devastatingly powerful punch!"))
	var/S = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(H,S, 50, 1)
	do_base_warrior_punch(H, L)
	apply_cooldown()
	..()

/datum/action/xeno_action/activable/warrior_punch/proc/do_base_warrior_punch(mob/living/carbon/H, obj/limb/L)
	var/mob/living/carbon/Xenomorph/X = owner
	var/damage = rand(base_damage, base_damage + damage_variance)

	if(ishuman(H))
		if((L.status & LIMB_SPLINTED) && !(L.status & LIMB_SPLINTED_INDESTRUCTIBLE)) //If they have it splinted, the splint won't hold.
			L.status &= ~LIMB_SPLINTED
			playsound(get_turf(H), 'sound/items/splintbreaks.ogg')
			to_chat(H, SPAN_DANGER("The splint on your [L.display_name] comes apart!"))
			H.pain.apply_pain(PAIN_BONE_BREAK_SPLINTED)

		if(isHumanStrict(H))
			H.Slow(3)
		if(isYautja(H))
			damage = rand(base_punch_damage_pred, base_punch_damage_pred + damage_variance)
		else if(L.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
			damage = rand(base_punch_damage_synth, base_punch_damage_synth + damage_variance)


	H.apply_armoured_damage(get_xeno_damage_slash(H, damage), ARMOR_MELEE, BRUTE, L? L.name : "chest")

	shake_camera(H, 2, 1)
	step_away(H, X, 2)
