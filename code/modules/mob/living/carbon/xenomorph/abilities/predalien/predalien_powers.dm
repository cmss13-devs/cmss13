/datum/action/xeno_action/onclick/predalien_roar/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if(!check_and_use_plasma_owner())
		return

	playsound(xeno.loc, pick(predalien_roar), 75, 0, status = 0)
	xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] emits a guttural roar!"))
	xeno.create_shriekwave(color = "#FF0000")

	for(var/mob/living/carbon/carbon in view(7, xeno))
		if(ishuman(carbon))
			var/mob/living/carbon/human/human = carbon
			human.disable_special_items()

			var/obj/item/clothing/gloves/yautja/hunter/YG = locate(/obj/item/clothing/gloves/yautja/hunter) in human
			if(isyautja(human) && YG)
				if(YG.cloaked)
					YG.decloak(human)

				YG.cloak_timer = xeno_cooldown * 0.1
		else if(isxeno(carbon) && xeno.can_not_harm(carbon))
			var/datum/behavior_delegate/predalien_base/behavior = xeno.behavior_delegate
			if(!istype(behavior))
				continue
			new /datum/effects/xeno_buff(carbon, xeno, ttl = (0.25 SECONDS * behavior.kills + 3 SECONDS), bonus_damage = bonus_damage_scale * behavior.kills, bonus_speed = (bonus_speed_scale * behavior.kills))


	for(var/mob/M in view(xeno))
		if(M && M.client)
			shake_camera(M, 10, 1)

	apply_cooldown()

	. = ..()
	return

/datum/action/xeno_action/onclick/smash/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	var/datum/behavior_delegate/predalien_base/behavior = xeno.behavior_delegate
	if(!istype(behavior))
		return

	if(!check_plasma_owner())
		return

	if(!do_after(xeno, activation_delay, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		to_chat(xeno, "Keep still whilst trying to smash into the ground")

		var/real_cooldown = xeno_cooldown

		xeno_cooldown = 3 SECONDS
		apply_cooldown()
		xeno_cooldown = real_cooldown
		return

	if(!check_and_use_plasma_owner())
		return

	playsound(xeno.loc, pick(smash_sounds), 50, 0, status = 0)
	xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] smashes into the ground!"))

	xeno.create_stomp()

	for(var/mob/living/carbon/carbon in oview(round(behavior.kills * 0.5 + 2), xeno))
		if(!xeno.can_not_harm(carbon) && carbon.stat != DEAD)
			carbon.frozen = 1
			carbon.update_canmove()

			if (ishuman(carbon))
				var/mob/living/carbon/human/human = carbon
				human.update_xeno_hostile_hud()

			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(unroot_human), carbon), get_xeno_stun_duration(carbon, freeze_duration))


	for(var/mob/M in view(xeno))
		if(M && M.client)
			shake_camera(M, 0.2 SECONDS, 1)

	apply_cooldown()

	. = ..()
	return

/datum/action/xeno_action/activable/devastate/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if (!isxeno_human(target) || xeno.can_not_harm(target))
		to_chat(xeno, SPAN_XENOWARNING("You must target a hostile!"))
		return

	if (get_dist_sqrd(target, xeno) > 2)
		to_chat(xeno, SPAN_XENOWARNING("[target] is too far away!"))
		return

	var/mob/living/carbon/carbon = target

	if (carbon.stat == DEAD)
		to_chat(xeno, SPAN_XENOWARNING("[carbon] is dead, why would you want to touch them?"))
		return

	var/datum/behavior_delegate/predalien_base/behavior = xeno.behavior_delegate
	if(!istype(behavior))
		return

	if (!check_and_use_plasma_owner())
		return

	carbon.frozen = 1
	carbon.update_canmove()

	if (ishuman(carbon))
		var/mob/living/carbon/human/human = carbon
		human.update_xeno_hostile_hud()

	apply_cooldown()

	xeno.frozen = 1
	xeno.anchored = TRUE
	xeno.update_canmove()

	if (do_after(xeno, activation_delay, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		xeno.emote("roar")
		xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] rips open the guts of [carbon]!"), SPAN_XENOHIGHDANGER("You rip open the guts of [carbon]!"))
		carbon.spawn_gibs()
		playsound(get_turf(carbon), 'sound/effects/gibbed.ogg', 30, 1)
		carbon.apply_effect(get_xeno_stun_duration(carbon, 0.5), WEAKEN)
		carbon.apply_armoured_damage(get_xeno_damage_slash(carbon, base_damage + damage_scale * behavior.kills), ARMOR_MELEE, BRUTE, "chest", 20)

		xeno.animation_attack_on(carbon)
		xeno.spin_circle()
		xeno.flick_attack_overlay(carbon, "tail")

	xeno.frozen = 0
	xeno.anchored = FALSE
	xeno.update_canmove()

	unroot_human(carbon)

	xeno.visible_message(SPAN_XENODANGER("[xeno] rapidly slices into [carbon]!"))

	. = ..()
	return
