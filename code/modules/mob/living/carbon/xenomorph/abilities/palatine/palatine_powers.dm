/datum/action/xeno_action/onclick/palatine_roar/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if(!check_and_use_plasma_owner())
		return

	if(roar_type == "piercing")
		var/datum/behavior_delegate/palatine_base/behavior = xeno.behavior_delegate
		if(!istype(behavior))
			to_chat(xeno, SPAN_ALERTWARNING("Something went wrong with your behavior delegate! Inform forest2001 or a coder!"))
			return FALSE
		if(behavior.thirst < 3)
			to_chat(xeno, SPAN_WARNING("You have not slain enough in the name of the Queen Mother to unleash this power!"))
			return FALSE
		xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] emits a piercing screech!"))
		xeno.create_shriekwave(color = "#9600d1")

		for(var/mob/living/carbon/carbon in view(7, xeno))
			if(isxeno(carbon) && xeno.can_not_harm(carbon))
				new /datum/effects/xeno_buff(carbon, xeno, ttl = (0.5 SECONDS * behavior.thirst + 3 SECONDS), bonus_damage = bonus_damage_scale * behavior.thirst, bonus_speed = (bonus_speed_scale * behavior.thirst))

			for(var/mob/M in view(xeno))
				if(M && M.client)
					shake_camera(M, 10, 1)
		behavior.thirst = max(0, behavior.thirst - 3)
		to_chat(xeno, SPAN_XENOMINORWARNING("Your bloodlust cools as you unleash your rage."))

	else
		xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] emits a thundering roar!"))
		xeno.create_shriekwave(color = "#925608")

		for(var/mob/living/carbon/carbon in view(7, xeno))
			if(ishuman(carbon))
				var/mob/living/carbon/human/human = carbon
				human.disable_special_items()

				var/obj/item/clothing/gloves/yautja/hunter/YG = locate(/obj/item/clothing/gloves/yautja/hunter) in human
				if(isyautja(human) && YG)
					if(YG.cloaked)
						YG.decloak(human)

					YG.cloak_timer = xeno_cooldown * 0.1
	playsound(xeno.loc, screech_sound_effect, 75, 0, status = 0)
	apply_cooldown()

	. = ..()
	return
