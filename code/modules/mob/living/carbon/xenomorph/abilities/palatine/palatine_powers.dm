/datum/action/xeno_action/onclick/palatine_roar/use_ability(atom/target)
	var/mob/living/carbon/Xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if(!check_and_use_plasma_owner())
		return

	playsound(xeno.loc, screech_sound_effect, 75, 0, status = 0)
	if(roar_type == "piercing")
		xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] emits a piercing roar!"))
		xeno.create_shriekwave(color = "#9600d1")

		for(var/mob/living/carbon/carbon in view(7, xeno))
			if(isXeno(carbon) && xeno.can_not_harm(carbon))
				var/datum/behavior_delegate/palatine_base/behavior = xeno.behavior_delegate
				if(!istype(behavior))
					continue
				new /datum/effects/xeno_buff(carbon, xeno, ttl = (0.25 SECONDS * behavior.thirst + 3 SECONDS), bonus_damage = bonus_damage_scale * behavior.thirst, bonus_speed = (bonus_speed_scale * behavior.thirst))


			for(var/mob/M in view(xeno))
				if(M && M.client)
					shake_camera(M, 10, 1)

	else
		xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] emits a thundering roar!"))
		xeno.create_shriekwave(color = "#925608")

		for(var/mob/living/carbon/carbon in view(7, xeno))
			if(ishuman(carbon))
				var/mob/living/carbon/human/human = carbon
				human.disable_special_items()

				var/obj/item/clothing/gloves/yautja/hunter/YG = locate(/obj/item/clothing/gloves/yautja/hunter) in human
				if(isYautja(human) && YG)
					if(YG.cloaked)
						YG.decloak(human)

					YG.cloak_timer = xeno_cooldown * 0.1
	apply_cooldown()

	. = ..()
	return
