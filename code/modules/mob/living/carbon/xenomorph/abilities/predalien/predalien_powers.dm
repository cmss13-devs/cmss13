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
				if(HAS_TRAIT(human, TRAIT_CLOAKED))
					YG.decloak(human, TRUE, DECLOAK_PREDALIEN)

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
	return ..()

/datum/action/xeno_action/activable/feralfrenzy/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!action_cooldown_check() || xeno.action_busy)
		return
	if(!xeno.check_state())
		return

	var/aoe_damage = base_damage_aoe
	var/aoe_scale = damage_scale_aoe
	var/range = 2
	var/targetting_type = targetting

	if(targetting_type == AOETARGETGUT)
		var/datum/behavior_delegate/predalien_base/behavior = xeno.behavior_delegate
		if(!istype(behavior))
			return
		if (range > 1)
			xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] begins digging in for a massive strike!"), SPAN_XENOHIGHDANGER("We begin digging in for a massive strike!"))
		else
			xeno.visible_message(SPAN_XENODANGER("[xeno] begins digging in for a strike!"), SPAN_XENOHIGHDANGER("We begin digging in for a strike!"))

		ADD_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Eviscerate"))
		xeno.anchored = TRUE
		if (do_after(xeno, (activation_delay_aoe), INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
			xeno.emote("roar")
			xeno.spin_circle()

			for (var/mob/living/carbon/human in orange(xeno, range))
				if(!isxeno_human(human) || xeno.can_not_harm(human))
					continue

				if (human.stat == DEAD)
					continue

				if(!check_clear_path_to_target(xeno, human))
					continue

				if (range > 1)
					xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] rips open the guts of [human]!"), SPAN_XENOHIGHDANGER("We rip open the guts of [human]!"))
					human.spawn_gibs()
					playsound(get_turf(human), 'sound/effects/gibbed.ogg', 30, 1)
					human.apply_effect(get_xeno_stun_duration(human, 1), WEAKEN)
				else
					xeno.visible_message(SPAN_XENODANGER("[xeno] claws [human]!"), SPAN_XENODANGER("We claw [human]!"))
					playsound(get_turf(human), "alien_claw_flesh", 30, 1)

				human.apply_armoured_damage(get_xeno_damage_slash(human, aoe_damage + aoe_scale * behavior.kills), ARMOR_MELEE, BRUTE, "chest", 20)

		var/list/mobs_in_range = oviewers(xeno)
		for(var/mob/mob as anything in mobs_in_range)
			if(mob.stat == DEAD || HAS_TRAIT(mob, TRAIT_NESTED))
				continue


		REMOVE_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Eviscerate"))
		xeno.anchored = FALSE
		apply_cooldown()
		return

	var/mob/living/carbon/xenomorph/x = owner

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if (!isxeno_human(target) || x.can_not_harm(target))
		to_chat(xeno, SPAN_XENOWARNING("We must target a hostile!"))
		return

	if (get_dist_sqrd(target, xeno) > 2)
		to_chat(xeno, SPAN_XENOWARNING("[target] is too far away!"))
		return

	var/mob/living/carbon/carbon = target

	if (carbon.stat == DEAD)
		to_chat(xeno, SPAN_XENOWARNING("[carbon] is dead, why would we want to touch them?"))
		return

	if(targetting_type == SINGLETARGETGUT)
		var/datum/behavior_delegate/predalien_base/predalienbehavior = xeno.behavior_delegate
		if(!istype(predalienbehavior))
			return

		if (!check_and_use_plasma_owner())
			return

		ADD_TRAIT(carbon, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Devastate"))

		if (ishuman(carbon))
			var/mob/living/carbon/human/human = carbon
			human.update_xeno_hostile_hud()

		apply_cooldown()

		ADD_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Devastate"))
		xeno.anchored = TRUE

		if (do_after(xeno, activation_delay, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
			xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] rips open the guts of [carbon]!"), SPAN_XENOHIGHDANGER("We rip open the guts of [carbon]!"))
			carbon.spawn_gibs()
			playsound(get_turf(carbon), 'sound/effects/gibbed.ogg', 75, 1)
			carbon.apply_effect(get_xeno_stun_duration(carbon, 0.5), WEAKEN)
			carbon.apply_armoured_damage(get_xeno_damage_slash(carbon, base_damage + damage_scale * predalienbehavior.kills), ARMOR_MELEE, BRUTE, "chest", 20)

			xeno.animation_attack_on(carbon)
			xeno.spin_circle()
			xeno.flick_attack_overlay(carbon, "tail")

		playsound(owner, 'sound/voice/predalien_growl.ogg', 75, 0, status = 0)

		REMOVE_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Devastate"))
		xeno.anchored = FALSE
		unroot_human(carbon, TRAIT_SOURCE_ABILITY("Devastate"))

		xeno.visible_message(SPAN_XENODANGER("[xeno] rapidly slices into [carbon]!"))

		return ..()


/datum/action/xeno_action/onclick/feralrush/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/predatoralien = owner

	if (!action_cooldown_check())
		return

	if (!istype(predatoralien) || !predatoralien.check_state())
		return

	if (buffs_active)
		to_chat(predatoralien, SPAN_XENOHIGHDANGER("We cannot stack this!"))
		return

	if (!check_and_use_plasma_owner())
		return


	RegisterSignal(predatoralien, COMSIG_XENO_POST_TOUGHEN, PROC_REF(disable_feralrush))
	addtimer(CALLBACK(src, PROC_REF(remove_effects)), duration)

	predatoralien.add_filter("predalien_toughen", 1, list("type" = "outline", "color" = "#421313", "size" = 1))
	predatoralien.balloon_alert(predatoralien, "we feel our muscles tense, making us faster and more durable for a time.", text_color = "#522020ff")
	buffs_active = TRUE
	predatoralien.speed_modifier -= speed_buff_amount
	predatoralien.armor_modifier += armor_buff_amount
	predatoralien.recalculate_speed()
	predatoralien.recalculate_armor()
	apply_cooldown()


/datum/action/xeno_action/onclick/feralrush/proc/disable_feralrush()
	SIGNAL_HANDLER
	var/mob/living/carbon/xenomorph/predatoralien = owner
	if (buffs_active == TRUE)
		predatoralien.balloon_alert(predatoralien, "our muscles relax, we no longer feel as armored.", text_color = "#522020ff")
		predatoralien.remove_filter("predalien_toughen")
	UnregisterSignal(predatoralien, COMSIG_XENO_POST_TOUGHEN)


/datum/action/xeno_action/onclick/feralrush/proc/remove_effects()
	var/mob/living/carbon/xenomorph/predatoralien = owner

	if (!istype(predatoralien))
		return

	predatoralien.speed_modifier += speed_buff_amount
	predatoralien.armor_modifier -= armor_buff_amount
	predatoralien.recalculate_speed()
	predatoralien.recalculate_armor()
	disable_feralrush()
	buffs_active = FALSE





