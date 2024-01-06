/datum/action/xeno_action/activable/lunge/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		if(twitch_message_cooldown < world.time )
			xeno.visible_message(SPAN_XENOWARNING("[xeno]'s claws twitch."), SPAN_XENOWARNING("Our claws twitch as we try to lunge but lack the strength. Wait a moment to try again."))
			twitch_message_cooldown = world.time + 5 SECONDS
		return //this gives a little feedback on why your lunge didn't hit other than the lunge button going grey. Plus, it might spook marines that almost got lunged if they know why the message appeared, and extra spookiness is always good.

	if (!affected_atom)
		return

	if (!isturf(xeno.loc))
		to_chat(xeno, SPAN_XENOWARNING("We can't lunge from here!"))
		return

	if (!xeno.check_state() || xeno.agility)
		return

	if(xeno.can_not_harm(affected_atom) || !ismob(affected_atom))
		apply_cooldown_override(click_miss_cooldown)
		return

	var/mob/living/carbon/carbon = affected_atom
	if(carbon.stat == DEAD)
		return

	if (!check_and_use_plasma_owner())
		return

	apply_cooldown()
	..()

	xeno.visible_message(SPAN_XENOWARNING("[xeno] lunges towards [carbon]!"), SPAN_XENOWARNING("We lunge at [carbon]!"))

	xeno.throw_atom(get_step_towards(affected_atom, xeno), grab_range, SPEED_FAST, xeno)

	if (xeno.Adjacent(carbon))
		xeno.start_pulling(carbon,1)
		if(ishuman(carbon))
			INVOKE_ASYNC(carbon, TYPE_PROC_REF(/mob, emote), "scream")
	else
		xeno.visible_message(SPAN_XENOWARNING("[xeno]'s claws twitch."), SPAN_XENOWARNING("Our claws twitch as we lunge but are unable to grab onto our target. Wait a moment to try again."))

	return TRUE

/datum/action/xeno_action/activable/fling/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!isxeno_human(affected_atom) || xeno.can_not_harm(affected_atom))
		return

	if (!xeno.check_state() || xeno.agility)
		return

	if (!xeno.Adjacent(affected_atom))
		return

	var/mob/living/carbon/carbon = affected_atom
	if(carbon.stat == DEAD)
		return

	if(HAS_TRAIT(carbon, TRAIT_NESTED))
		return

	if(carbon == xeno.pulling)
		xeno.stop_pulling()

	if(carbon.mob_size >= MOB_SIZE_BIG)
		to_chat(xeno, SPAN_XENOWARNING("[carbon] is too big for us to fling!"))
		return

	if (!check_and_use_plasma_owner())
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] effortlessly flings [carbon] to the side!"), SPAN_XENOWARNING("We effortlessly fling [carbon] to the side!"))
	playsound(carbon,'sound/weapons/alien_claw_block.ogg', 75, 1)
	if(stun_power)
		carbon.Stun(get_xeno_stun_duration(carbon, stun_power))
	if(weaken_power)
		carbon.KnockDown(get_xeno_stun_duration(carbon, weaken_power))
	if(slowdown)
		if(carbon.slowed < slowdown)
			carbon.apply_effect(slowdown, SLOW)
	carbon.last_damage_data = create_cause_data(initial(xeno.caste_type), xeno)

	var/facing = get_dir(xeno, carbon)

	// Hmm today I will kill a marine while looking away from them
	xeno.face_atom(carbon)
	xeno.animation_attack_on(carbon)
	xeno.flick_attack_overlay(carbon, "disarm")
	xeno.throw_carbon(carbon, facing, fling_distance, SPEED_VERY_FAST, shake_camera = TRUE, immobilize = TRUE)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/warrior_punch/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!isxeno_human(affected_atom) || xeno.can_not_harm(affected_atom))
		return

	if (!xeno.check_state() || xeno.agility)
		return

	var/distance = get_dist(xeno, affected_atom)

	if (distance > 2)
		return

	var/mob/living/carbon/carbon = affected_atom

	if (!xeno.Adjacent(carbon))
		return

	if(carbon.stat == DEAD)
		return
	if(HAS_TRAIT(carbon, TRAIT_NESTED))
		return

	var/obj/limb/target_limb = carbon.get_limb(check_zone(xeno.zone_selected))

	if (ishuman(carbon) && (!target_limb || (target_limb.status & LIMB_DESTROYED)))
		target_limb = carbon.get_limb("chest")

	if (!check_and_use_plasma_owner())
		return

	carbon.last_damage_data = create_cause_data(initial(xeno.caste_type), xeno)

	xeno.visible_message(SPAN_XENOWARNING("[xeno] hits [carbon] in the [target_limb ? target_limb.display_name : "chest"] with a devastatingly powerful punch!"), \
	SPAN_XENOWARNING("We hit [carbon] in the [target_limb ? target_limb.display_name : "chest"] with a devastatingly powerful punch!"))
	var/sound = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(carbon, sound, 50, 1)
	do_base_warrior_punch(carbon, target_limb)
	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/warrior_punch/proc/do_base_warrior_punch(mob/living/carbon/carbon, obj/limb/target_limb)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/damage = rand(base_damage, base_damage + damage_variance)

	if(ishuman(carbon))
		if((target_limb.status & LIMB_SPLINTED) && !(target_limb.status & LIMB_SPLINTED_INDESTRUCTIBLE)) //If they have it splinted, the splint won't hold.
			target_limb.status &= ~LIMB_SPLINTED
			playsound(get_turf(carbon), 'sound/items/splintbreaks.ogg', 20)
			to_chat(carbon, SPAN_DANGER("The splint on your [target_limb.display_name] comes apart!"))
			carbon.pain.apply_pain(PAIN_BONE_BREAK_SPLINTED)

		if(ishuman_strict(carbon))
			carbon.apply_effect(3, SLOW)

		if(isyautja(carbon))
			damage = rand(base_punch_damage_pred, base_punch_damage_pred + damage_variance)
		else if(target_limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
			damage = rand(base_punch_damage_synth, base_punch_damage_synth + damage_variance)


	carbon.apply_armoured_damage(get_xeno_damage_slash(carbon, damage), ARMOR_MELEE, BRUTE, target_limb ? target_limb.name : "chest")

	// Hmm today I will kill a marine while looking away from them
	xeno.face_atom(carbon)
	xeno.animation_attack_on(carbon)
	xeno.flick_attack_overlay(carbon, "punch")
	shake_camera(carbon, 2, 1)
	step_away(carbon, xeno, 2)
