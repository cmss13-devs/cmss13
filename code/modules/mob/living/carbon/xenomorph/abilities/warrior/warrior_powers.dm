/datum/action/xeno_action/activable/lunge/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner

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
	var/mob/living/carbon/xenomorph/X = owner

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


/datum/action/xeno_action/activable/fling/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/woyer = owner

	if (!action_cooldown_check())
		return

	if (!isxeno_human(target_atom) || woyer.can_not_harm(target_atom))
		return

	if (!woyer.check_state() || woyer.agility)
		return

	if (!woyer.Adjacent(target_atom))
		return

	var/mob/living/carbon/carbone = target_atom
	if(carbone.stat == DEAD) return
	if(HAS_TRAIT(carbone, TRAIT_NESTED))
		return

	if(carbone == woyer.pulling)
		woyer.stop_pulling()

	if(carbone.mob_size >= MOB_SIZE_BIG)
		to_chat(woyer, SPAN_XENOWARNING("[carbone] is too big for you to fling!"))
		return

	if (!check_and_use_plasma_owner())
		return

	woyer.visible_message(SPAN_XENOWARNING("\The [woyer] effortlessly flings [carbone] to the side!"), SPAN_XENOWARNING("You effortlessly fling [carbone] to the side!"))
	playsound(carbone,'sound/weapons/alien_claw_block.ogg', 75, 1)
	if(stun_power)
		carbone.apply_effect(get_xeno_stun_duration(carbone, stun_power), STUN)
	if(weaken_power)
		carbone.apply_effect(weaken_power, WEAKEN)
	if(slowdown)
		if(carbone.slowed < slowdown)
			carbone.apply_effect(slowdown, SLOW)
	carbone.last_damage_data = create_cause_data(initial(woyer.caste_type), woyer)
	shake_camera(carbone, 2, 1)

	var/facing = get_dir(woyer, carbone)
	var/turf/throw_turf = woyer.loc
	var/turf/temp = woyer.loc

	for (var/x in 0 to fling_distance-1)
		temp = get_step(throw_turf, facing)
		if (!temp)
			break
		throw_turf = temp

	// Hmm today I will kill a marine while looking away from them
	woyer.face_atom(carbone)
	woyer.animation_attack_on(carbone)
	woyer.flick_attack_overlay(carbone, "disarm")
	carbone.throw_atom(throw_turf, fling_distance, SPEED_VERY_FAST, woyer, TRUE)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/warrior_punch/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/woyer = owner

	if (!action_cooldown_check())
		return

	if (!isxeno_human(target_atom) || woyer.can_not_harm(target_atom))
		return

	if (!woyer.check_state() || woyer.agility)
		return

	var/distance = get_dist(woyer, target_atom)

	if (distance > 2)
		return

	var/mob/living/carbon/carbone = target_atom

	if (!woyer.Adjacent(carbone))
		return

	if(carbone.stat == DEAD) return
	if(HAS_TRAIT(carbone, TRAIT_NESTED)) return

	var/obj/limb/target_limb = carbone.get_limb(check_zone(woyer.zone_selected))

	if (ishuman(carbone) && (!target_limb || (target_limb.status & LIMB_DESTROYED)))
		target_limb = carbone.get_limb("chest")


	if (!check_and_use_plasma_owner())
		return

	carbone.last_damage_data = create_cause_data(initial(woyer.caste_type), woyer)

	woyer.visible_message(SPAN_XENOWARNING("\The [woyer] hits [carbone] in the [target_limb? target_limb.display_name : "chest"] with a devastatingly powerful punch!"), \
	SPAN_XENOWARNING("You hit [carbone] in the [target_limb? target_limb.display_name : "chest"] with a devastatingly powerful punch!"))
	var/S = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(carbone,S, 50, 1)
	do_base_warrior_punch(carbone, target_limb)
	apply_cooldown()
	..()

/datum/action/xeno_action/activable/warrior_punch/proc/do_base_warrior_punch(mob/living/carbon/carbone, obj/limb/target_limb)
	var/mob/living/carbon/xenomorph/woyer = owner
	var/damage = rand(base_damage, base_damage + damage_variance)

	if(ishuman(carbone))
		if((target_limb.status & LIMB_SPLINTED) && !(target_limb.status & LIMB_SPLINTED_INDESTRUCTIBLE)) //If they have it splinted, the splint won't hold.
			target_limb.status &= ~LIMB_SPLINTED
			playsound(get_turf(carbone), 'sound/items/splintbreaks.ogg', 20)
			to_chat(carbone, SPAN_DANGER("The splint on your [target_limb.display_name] comes apart!"))
			carbone.pain.apply_pain(PAIN_BONE_BREAK_SPLINTED)

		if(ishuman_strict(carbone))
			carbone.apply_effect(3, SLOW)
		if(isyautja(carbone))
			damage = rand(base_punch_damage_pred, base_punch_damage_pred + damage_variance)
		else if(target_limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
			damage = rand(base_punch_damage_synth, base_punch_damage_synth + damage_variance)


	carbone.apply_armoured_damage(get_xeno_damage_slash(carbone, damage), ARMOR_MELEE, BRUTE, target_limb? target_limb.name : "chest")

	// Hmm today I will kill a marine while looking away from them
	woyer.face_atom(carbone)
	woyer.animation_attack_on(carbone)
	woyer.flick_attack_overlay(carbone, "punch")
	shake_camera(carbone, 2, 1)
	step_away(carbone, woyer, 2)
