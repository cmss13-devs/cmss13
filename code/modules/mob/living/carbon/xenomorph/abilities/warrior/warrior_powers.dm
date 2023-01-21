/datum/action/xeno_action/activable/lunge/use_ability(atom/target)
	var/mob/living/carbon/Xenomorph/xeno_owner = owner

	if (!action_cooldown_check())
		if(twitch_message_cooldown < world.time )
			xeno_owner.visible_message(SPAN_XENOWARNING("\The [xeno_owner]'s claws twitch."), SPAN_XENOWARNING("Your claws twitch as you try to lunge but lack the strength. Wait target moment to try again."))
			twitch_message_cooldown = world.time + 5 SECONDS
		return //this gives target little feedback on why your lunge didn't hit other than the lunge button going grey. Plus, it might spook marines that almost got lunged if they know why the message appeared, and extra spookiness is always good.

	if (!target)
		return

	if (!isturf(xeno_owner.loc))
		to_chat(xeno_owner, SPAN_XENOWARNING("You can't lunge from here!"))
		return

	if (!xeno_owner.check_state() || xeno_owner.agility)
		return

	if(xeno_owner.can_not_harm(target) || !ismob(target))
		apply_cooldown_override(click_miss_cooldown)
		return

	var/mob/living/carbon/carbon_target = target
	if(carbon_target.stat == DEAD)
		return

	if (!check_and_use_plasma_owner())
		return

	apply_cooldown()
	..()

	xeno_owner.visible_message(SPAN_XENOWARNING("\The [xeno_owner] lunges towards [carbon_target]!"), SPAN_XENOWARNING("You lunge at [carbon_target]!"))

	xeno_owner.throw_atom(get_step_towards(target, xeno_owner), grab_range, SPEED_FAST, xeno_owner)

	if (xeno_owner.Adjacent(carbon_target))
		lunge_hit(carbon_target)
	else
		xeno_owner.visible_message(SPAN_XENOWARNING("\The [xeno_owner]'s claws twitch."), SPAN_XENOWARNING("Your claws twitch as you lunge but are unable to grab onto your target. Wait target moment to try again."))

	return TRUE

/**
 * The owner managed to be adjacent to the victim, doesn't necessarly mean anything else will happen
 */
/datum/action/xeno_action/activable/lunge/proc/lunge_hit(atom/movable/victim)
	var/mob/living/carbon/Xenomorph/xeno_owner = owner
	xeno_owner.start_pulling(victim)
	if (!xeno_owner.check_state() || xeno_owner.agility)
		return FALSE

	if(!isliving(victim))
		return FALSE

	var/mob/living/living_victim = victim
	var/should_neckgrab = !(xeno_owner.can_not_harm(living_victim))

	if(!QDELETED(living_victim) && !QDELETED(living_victim.pulledby) && living_victim != owner ) //override pull of other mobs
		xeno_owner.visible_message(SPAN_WARNING("[xeno_owner] has broken [living_victim.pulledby]'s grip on [living_victim]!"), null, null, 5)
		living_victim.pulledby.stop_pulling()

	if(!xeno_owner.start_pulling(victim, should_neckgrab))
		return

	if(isXeno(victim))
		var/mob/living/carbon/Xenomorph/xeno_victim = victim
		if(xeno_victim.tier >= 2) // Tier 2 castes or higher immune to warrior grab stuns
			return

	if(should_neckgrab && living_victim.mob_size < MOB_SIZE_BIG)
		living_victim.drop_held_items()
		living_victim.apply_effect(get_xeno_stun_duration(living_victim, 2), WEAKEN)
		living_victim.pulledby = owner
		xeno_owner.visible_message(SPAN_XENOWARNING("\The [xeno_owner] grabs [living_victim] by the throat!"), \
		SPAN_XENOWARNING("You grab [living_victim] by the throat!"))
		RegisterSignal(xeno_owner, COMSIG_MOB_STOPPED_PULLING, PROC_REF(broken_lunge))
		addtimer(CALLBACK(src, PROC_REF(stop_lunging)), get_xeno_stun_duration(living_victim, 2) SECONDS + 1 SECONDS)

/**
 * The lunge was broken early, either because the owner cancelled the grab or was stunned
 */
/datum/action/xeno_action/activable/lunge/proc/broken_lunge(owner, atom/movable/victim)
	SIGNAL_HANDLER
	if(!isliving(victim)) //If they somehow change type while neckgrabbed ?
		return
	var/mob/living/living_victim = victim
	//We cleanse them so they get up instantly
	living_victim.set_effect(0, STUN)
	living_victim.set_effect(0, WEAKEN)


/datum/action/xeno_action/activable/lunge/proc/stop_lunging()
	UnregisterSignal(owner, COMSIG_MOB_STOPPED_PULLING)

/datum/action/xeno_action/onclick/toggle_agility/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/xeno_owner = owner

	if (!action_cooldown_check())
		return

	if (!xeno_owner.check_state(TRUE))
		return

	xeno_owner.agility = !xeno_owner.agility
	if (xeno_owner.agility)
		to_chat(xeno_owner, SPAN_XENOWARNING("You lower yourself to all fours."))
	else
		to_chat(xeno_owner, SPAN_XENOWARNING("You raise yourself to stand on two feet."))
	xeno_owner.update_icons()

	apply_cooldown()
	..()


/datum/action/xeno_action/activable/fling/use_ability(atom/target_atom)
	var/mob/living/carbon/Xenomorph/xeno_owner = owner

	if (!action_cooldown_check())
		return

	if (!isXenoOrHuman(target_atom) || xeno_owner.can_not_harm(target_atom))
		return

	if (!xeno_owner.check_state() || xeno_owner.agility)
		return

	if (!xeno_owner.Adjacent(target_atom))
		return

	var/mob/living/carbon/carbone = target_atom
	if(carbone.stat == DEAD) return
	if(HAS_TRAIT(carbone, TRAIT_NESTED))
		return

	if(carbone == xeno_owner.pulling)
		xeno_owner.stop_pulling()

	if(carbone.mob_size >= MOB_SIZE_BIG)
		to_chat(xeno_owner, SPAN_XENOWARNING("[carbone] is too big for you to fling!"))
		return

	if (!check_and_use_plasma_owner())
		return

	xeno_owner.visible_message(SPAN_XENOWARNING("\The [xeno_owner] effortlessly flings [carbone] to the side!"), SPAN_XENOWARNING("You effortlessly fling [carbone] to the side!"))
	playsound(carbone,'sound/weapons/alien_claw_block.ogg', 75, 1)
	if(stun_power)
		carbone.apply_effect(get_xeno_stun_duration(carbone, stun_power), STUN)
	if(weaken_power)
		carbone.apply_effect(weaken_power, WEAKEN)
	if(slowdown)
		if(carbone.slowed < slowdown)
			carbone.apply_effect(slowdown, SLOW)
	carbone.last_damage_data = create_cause_data(initial(xeno_owner.caste_type), xeno_owner)
	shake_camera(carbone, 2, 1)

	var/facing = get_dir(xeno_owner, carbone)
	var/turf/throw_turf = xeno_owner.loc
	var/turf/temp = xeno_owner.loc

	for (var/x in 0 to fling_distance-1)
		temp = get_step(throw_turf, facing)
		if (!temp)
			break
		throw_turf = temp

	// Hmm today I will kill a marine while looking away from them
	xeno_owner.face_atom(carbone)
	xeno_owner.animation_attack_on(carbone)
	xeno_owner.flick_attack_overlay(carbone, "disarm")
	carbone.throw_atom(throw_turf, fling_distance, SPEED_VERY_FAST, xeno_owner, TRUE)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/warrior_punch/use_ability(atom/target_atom)
	var/mob/living/carbon/Xenomorph/xeno_owner = owner

	if (!action_cooldown_check())
		return

	if (!isXenoOrHuman(target_atom) || xeno_owner.can_not_harm(target_atom))
		return

	if (!xeno_owner.check_state() || xeno_owner.agility)
		return

	var/distance = get_dist(xeno_owner, target_atom)

	if (distance > 2)
		return

	var/mob/living/carbon/carbone = target_atom

	if (!xeno_owner.Adjacent(carbone))
		return

	if(carbone.stat == DEAD) return
	if(HAS_TRAIT(carbone, TRAIT_NESTED)) return

	var/obj/limb/target_limb = carbone.get_limb(check_zone(xeno_owner.zone_selected))

	if (ishuman(carbone) && (!target_limb || (target_limb.status & LIMB_DESTROYED)))
		return


	if (!check_and_use_plasma_owner())
		return

	carbone.last_damage_data = create_cause_data(initial(xeno_owner.caste_type), xeno_owner)

	xeno_owner.visible_message(SPAN_XENOWARNING("\The [xeno_owner] hits [carbone] in the [target_limb ? target_limb.display_name : "chest"] with a devastatingly powerful punch!"), \
	SPAN_XENOWARNING("You hit [carbone] in the [target_limb ? target_limb.display_name : "chest"] with a devastatingly powerful punch!"))
	var/sound = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(carbone, sound, 50, 1)
	do_base_warrior_punch(carbone, target_limb)
	apply_cooldown()
	..()

/datum/action/xeno_action/activable/warrior_punch/proc/do_base_warrior_punch(mob/living/carbon/carbone, obj/limb/target_limb)
	var/mob/living/carbon/Xenomorph/xeno_owner = owner
	var/damage = rand(base_damage, base_damage + damage_variance)

	if(ishuman(carbone))
		if((target_limb.status & LIMB_SPLINTED) && !(target_limb.status & LIMB_SPLINTED_INDESTRUCTIBLE)) //If they have it splinted, the splint won't hold.
			target_limb.status &= ~LIMB_SPLINTED
			playsound(get_turf(carbone), 'sound/items/splintbreaks.ogg', 20)
			to_chat(carbone, SPAN_DANGER("The splint on your [target_limb.display_name] comes apart!"))
			carbone.pain.apply_pain(PAIN_BONE_BREAK_SPLINTED)

		if(isHumanStrict(carbone))
			carbone.apply_effect(3, SLOW)
		if(isYautja(carbone))
			damage = rand(base_punch_damage_pred, base_punch_damage_pred + damage_variance)
		else if(target_limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
			damage = rand(base_punch_damage_synth, base_punch_damage_synth + damage_variance)


	carbone.apply_armoured_damage(get_xeno_damage_slash(carbone, damage), ARMOR_MELEE, BRUTE, target_limb? target_limb.name : "chest")

	// Hmm today I will kill a marine while looking away from them
	xeno_owner.face_atom(carbone)
	xeno_owner.animation_attack_on(carbone)
	xeno_owner.flick_attack_overlay(carbone, "punch")
	shake_camera(carbone, 2, 1)
	step_away(carbone, xeno_owner, 2)
