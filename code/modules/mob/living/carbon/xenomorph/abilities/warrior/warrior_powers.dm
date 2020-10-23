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

	if(!isHumanStrict(A) && !ismonkey(A) && (!isXeno(A) || X.match_hivemind(A))) // Can't do isXenoOrHuman because it checks for whether it is strictly human
		apply_cooldown_override(click_miss_cooldown)
		return

	var/mob/living/carbon/H = A
	if(H.stat == DEAD)
		return

	if (!check_and_use_plasma_owner())
		return

	X.visible_message(SPAN_XENOWARNING("\The [X] lunges towards [H]!"), SPAN_XENOWARNING("You lunge at [H]!"))

	X.throw_atom(get_step_towards(A, X), grab_range, SPEED_FAST, X)

	if (X.Adjacent(H))
		X.start_pulling(H,1)
	else
		X.visible_message(SPAN_XENOWARNING("\The [X]'s claws twitch."), SPAN_XENOWARNING("Your claws twitch as you lunge but are unable to grab onto your target. Wait a moment to try again."))

	apply_cooldown()
	..()

	return 1

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

	if (!isXenoOrHuman(A) || X.match_hivemind(A))
		return

	if (!X.check_state() || X.agility)
		return

	if (!X.Adjacent(A))
		return

	var/mob/living/carbon/H = A
	if(H.stat == DEAD) return
	if(istype(H.buckled, /obj/structure/bed/nest))
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
	H.apply_effect(get_xeno_stun_duration(H, stun_power), STUN)
	H.apply_effect(weaken_power, WEAKEN)
	H.last_damage_mob = X
	H.last_damage_source = initial(X.caste_name)
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

	if (!isXenoOrHuman(A) || X.match_hivemind(A))
		return

	if (!X.check_state() || X.agility)
		return

	var/distance = get_dist(X, A)

	if (distance > 2)
		return

	var/mob/living/carbon/H = A

	if (distance > 1 && X.mutation_type == WARRIOR_BOXER)
		step_towards(X, H, 1)

	if (!X.Adjacent(H))
		return

	if(H.stat == DEAD) return
	if(istype(H.buckled, /obj/structure/bed/nest)) return

	var/obj/limb/L = H.get_limb(check_zone(X.zone_selected))

	if (ishuman(H) && (!L || (L.status & LIMB_DESTROYED)))
		return

	
	if (!check_and_use_plasma_owner())
		return

	H.last_damage_mob = X
	H.last_damage_source = initial(X.caste_name)

	X.visible_message(SPAN_XENOWARNING("\The [X] hits [H] in the [L? L.display_name : "chest"] with a devastatingly powerful punch!"), \
	SPAN_XENOWARNING("You hit [H] in the [L? L.display_name : "chest"] with a devastatingly powerful punch!"))
	var/S = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(H,S, 50, 1)

	if (X.mutation_type != WARRIOR_BOXER)
		do_base_warrior_punch(H, L)
	else
		do_boxer_punch(H,L)		

	apply_cooldown()
	..()

/datum/action/xeno_action/activable/warrior_punch/proc/do_base_warrior_punch(mob/living/carbon/H, obj/limb/L)
	var/mob/living/carbon/Xenomorph/X = owner
	var/damage = rand(base_damage, base_damage + damage_variance)

	if(ishuman(H))
		if(L.status & LIMB_SPLINTED) //If they have it splinted, the splint won't hold.
			L.status &= ~LIMB_SPLINTED
			to_chat(H, SPAN_DANGER("The splint on your [L.display_name] comes apart!"))
			H.pain.apply_pain(PAIN_BONE_BREAK_SPLINTED)

		if(isYautja(H))
			damage = rand(base_punch_damage_pred, base_punch_damage_pred + damage_variance)
		else if(L.status & LIMB_ROBOT)
			damage = rand(base_punch_damage_synth, base_punch_damage_synth + damage_variance)
		else
			var/fracture_chance = 100
			switch(L.body_part)
				if(BODY_FLAG_HEAD)
					fracture_chance = 20
				if(BODY_FLAG_CHEST)
					fracture_chance = 30
				if(BODY_FLAG_GROIN)
					fracture_chance = 40
			
			if(prob(fracture_chance))
				L.fracture()

			
	H.apply_armoured_damage(get_xeno_damage_slash(H, damage), ARMOR_MELEE, BRUTE, L? L.name : "chest")
	
	shake_camera(H, 2, 1)
	step_away(H, X, 2)

/datum/action/xeno_action/activable/warrior_punch/proc/do_boxer_punch(mob/living/carbon/H, obj/limb/L)
	var/mob/living/carbon/Xenomorph/X = owner

	var/damage = rand(boxer_punch_damage, boxer_punch_damage + damage_variance)

	if(ishuman(H))
		if(isYautja(H))
			damage = rand(boxer_punch_damage_pred, boxer_punch_damage_pred + damage_variance)
		else if(L.status & LIMB_ROBOT)
			damage = rand(boxer_punch_damage_synth, boxer_punch_damage_synth + damage_variance)

	H.apply_armoured_damage(get_xeno_damage_slash(H, damage), ARMOR_MELEE, BRUTE, L? L.name : "chest")

	step_away(H, X)
	if(prob(25)) // 25% chance to fly 2 tiles
		step_away(H, X)
	var/datum/behavior_delegate/boxer/BD = X.behavior_delegate
	if(istype(BD))
		BD.melee_attack_additional_effects_target(H, 1)

	var/datum/action/xeno_action/activable/jab/JA = get_xeno_action_by_type(X, /datum/action/xeno_action/activable/jab)
	if (istype(JA) && !JA.action_cooldown_check())
		JA.end_cooldown()

/datum/action/xeno_action/activable/jab/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!isXenoOrHuman(A) || X.match_hivemind(A))
		return

	if (!action_cooldown_check())
		return

	if (!X.check_state())
		return

	var/distance = get_dist(X, A)

	if (distance > 3)
		return

	var/mob/living/carbon/H = A
	if(H.stat == DEAD) return
	if(istype(H.buckled, /obj/structure/bed/nest)) return

	if (!check_and_use_plasma_owner())
		return

	if (distance > 2)
		step_towards(X, H, 1)

	if (distance > 1)
		step_towards(X, H, 1)

	if (!X.Adjacent(H))
		return

	H.last_damage_mob = X
	H.last_damage_source = initial(X.caste_name)
	X.visible_message(SPAN_XENOWARNING("\The [X] hits [H] with a powerful jab!"), \
	SPAN_XENOWARNING("You hit [H] with a powerful jab!"))
	var/S = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(H,S, 50, 1)

	// Check actions list for a warrior punch and reset it's cooldown if it's there
	var/datum/action/xeno_action/activable/warrior_punch/punch_action = null
	for (var/datum/action/xeno_action/activable/warrior_punch/P in X.actions)
		punch_action = P
		break 
	
	if (punch_action && !punch_action.action_cooldown_check())
		punch_action.end_cooldown()

	H.Daze(3)
	H.Slow(5)
	var/datum/behavior_delegate/boxer/BD = X.behavior_delegate
	if(istype(BD))
		BD.melee_attack_additional_effects_target(H, 1)
	apply_cooldown()
	..()


/datum/action/xeno_action/activable/uppercut/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!isXenoOrHuman(A) || X.match_hivemind(A))
		return

	if (!action_cooldown_check())
		return

	if (!X.check_state())
		return
	
	var/datum/behavior_delegate/boxer/BD = X.behavior_delegate
	if(!istype(BD))
		return

	if(!BD.punching_bag)
		return

	if(BD.punching_bag != A)
		return

	var/mob/living/carbon/H = BD.punching_bag
	if(H.stat == DEAD) 
		return
	if(istype(H.buckled, /obj/structure/bed/nest))
		return

	if (!check_and_use_plasma_owner())
		return

	if (!X.Adjacent(H))
		return

	var/datum/action/xeno_action/activable/jab/JA = get_xeno_action_by_type(X, /datum/action/xeno_action/activable/jab)
	if (istype(JA))
		JA.apply_cooldown_override(JA.xeno_cooldown)

	var/datum/action/xeno_action/activable/warrior_punch/WP = get_xeno_action_by_type(X, /datum/action/xeno_action/activable/warrior_punch)
	if (istype(WP))
		WP.apply_cooldown_override(WP.xeno_cooldown)

	H.last_damage_mob = X
	H.last_damage_source = initial(X.caste_name)

	var/ko_counter = BD.ko_counter

	var/damage = ko_counter >= 1
	var/knockback = ko_counter >= 3
	var/knockdown = ko_counter >= 6
	var/knockout = ko_counter >= 9

	var/message = (!damage) ? "weak" : (!knockback) ? "good" : (!knockdown) ? "powerful" : (!knockout) ? "gigantic" : "titanic"

	X.visible_message(SPAN_XENOWARNING("\The [X] hits [H] with a [message] uppercut!"), \
	SPAN_XENOWARNING("You hit [H] with a [message] uppercut!"))
	var/S = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(H,S, 50, 1)

	deltimer(BD.ko_reset_timer)
	BD.remove_ko()

	var/obj/limb/L = H.get_limb(check_zone(X.zone_selected))

	if(damage)
		H.apply_armoured_damage(get_xeno_damage_slash(H, base_damage * ko_counter), ARMOR_MELEE, BRUTE, L? L.name : "chest")
	
	if(knockout)
		H.KnockOut(knockout_power)
		BD.display_ko_message(H)
		playsound(H,'sound/effects/dingding.ogg', 75, 1)

	if(knockback)
		H.explosion_throw(base_knockback * ko_counter, get_dir(X, H))

	if(knockdown)
		H.KnockDown(base_knockdown * ko_counter)

	if(ko_counter > 0)
		X.gain_health(ko_counter * base_healthgain * X.maxHealth / 100)

	apply_cooldown()
	..()
