/datum/action/xeno_action/activable/lunge/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return
	
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

	if (!isXenoOrHuman(A) || X.match_hivemind(X))
		return

	if (!X.check_state() || X.agility)
		return

	if (!X.Adjacent(A))
		return

	var/mob/living/carbon/H = A
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
		else
			if(L.body_part == BODY_FLAG_HEAD)
				var/knockdown_chance = 14
				if(prob(knockdown_chance))
					H.KnockDown(1)
	
	H.apply_armoured_damage(get_xeno_damage_slash(H, damage), ARMOR_MELEE, BRUTE, L? L.name : "chest")

	shake_camera(H, 3, 1)

	if(H.lying)
		step_away(H, X, 3)
		if(H.mob_size < MOB_SIZE_BIG)
			H.KnockDown(get_xeno_stun_duration(H, 1))
	else
		step_away(H, X, 2)

/datum/action/xeno_action/activable/jab/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!isXenoOrHuman(A) || X.match_hivemind(A))
		return

	if (!action_cooldown_check())
		return

	if (!X.check_state())
		return

	var/distance = get_dist(X, A)

	if (distance > 2)
		return

	var/mob/living/carbon/H = A
	if(H.stat == DEAD) return
	if(istype(H.buckled, /obj/structure/bed/nest)) return

	if (!check_and_use_plasma_owner())
		return

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

	if(!isYautja(H))
		H.KnockDown(get_xeno_stun_duration(H, 0.1))

	// Check actions list for a warrior punch and reset it's cooldown if it's there
	var/datum/action/xeno_action/activable/warrior_punch/punch_action = null
	for (var/datum/action/xeno_action/activable/warrior_punch/P in X.actions)
		punch_action = P
		break 
	
	if (punch_action && !punch_action.action_cooldown_check())
		punch_action.end_cooldown()

	shake_camera(H, 3, 1)
	step_away(H, X, 2)

	apply_cooldown()
	..()

