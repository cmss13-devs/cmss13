//There has to be a better way to define this shit. ~ Z
//can't equip anything
/mob/living/carbon/Xenomorph/attack_ui(slot_id)
	return

/mob/living/carbon/Xenomorph/attack_animal(mob/living/M as mob)

	if(isanimal(M))
		var/mob/living/simple_animal/S = M
		if(!S.melee_damage_upper)
			S.emote("[S.friendly] [src]")
		else
			M.animation_attack_on(src)
			M.flick_attack_overlay(src, "punch")
			visible_message(SPAN_DANGER("[S] [S.attacktext] [src]!"), null, null, 5, CHAT_TYPE_MELEE_HIT)
			var/damage = rand(S.melee_damage_lower, S.melee_damage_upper)
			apply_damage(damage, BRUTE)
			last_damage_source = initial(M.name)
			last_damage_mob = M
			S.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name] ([src.ckey])</font>")
			attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [S.name] ([S.ckey])</font>")
			updatehealth()

/mob/living/carbon/Xenomorph/attack_hand(mob/living/carbon/human/M)

	..()
	M.next_move += 7 //Adds some lag to the 'attack'. This will add up to 10
	switch(M.a_intent)

		if("help")
			if(stat == DEAD)
				M.visible_message(SPAN_WARNING("\The [M] pokes \the [src], but nothing happens."), \
				SPAN_WARNING("You poke \the [src], but nothing happens."), null, 5, CHAT_TYPE_FLUFF_ACTION)
			else
				M.visible_message(SPAN_WARNING("\The [M] pokes \the [src]."), \
				SPAN_WARNING("You poke \the [src]."), null, 5, CHAT_TYPE_FLUFF_ACTION)

		if("grab")
			if(M == src || anchored)
				return 0

			M.start_pulling(src)

		else
			var/datum/unarmed_attack/attack = M.species.unarmed
			if(!attack.is_usable(M)) attack = M.species.secondary_unarmed
			if(!attack.is_usable(M))
				return 0

			M.animation_attack_on(src)
			M.flick_attack_overlay(src, "punch")

			var/damage = rand(1, 3)
			if(prob(85))
				damage += attack.damage > 5 ? attack.damage : 0

				playsound(loc, attack.attack_sound, 25, 1)
				visible_message(SPAN_DANGER("[M] [pick(attack.attack_verb)]ed [src]!"), null, null, 5, CHAT_TYPE_MELEE_HIT)
				apply_damage(damage, BRUTE)
				updatehealth()
			else
				playsound(loc, attack.miss_sound, 25, 1)
				visible_message(SPAN_DANGER("[M] tried to [pick(attack.attack_verb)] [src]!"), null, null, 5, CHAT_TYPE_MELEE_HIT)

	return

//Hot hot Aliens on Aliens action.
//Actually just used for eating people.
/mob/living/carbon/Xenomorph/attack_alien(mob/living/carbon/Xenomorph/M)
	if (M.fortify || M.burrow)
		return 0

	if(src != M)
		if(isXenoLarva(M)) //Larvas can't eat people
			M.visible_message(SPAN_DANGER("[M] nudges its head against \the [src]."), \
			SPAN_DANGER("You nudge your head against \the [src]."), null, null, CHAT_TYPE_XENO_FLUFF)
			return 0

		switch(M.a_intent)
			if("help")
				if(on_fire)
					extinguish_mob(M)
				else if(M.zone_selected == "head")
					M.attempt_headbutt(src)
				else if(M.zone_selected == "groin")
					M.attempt_tailswipe(src)
				else
					M.visible_message(SPAN_NOTICE("\The [M] caresses \the [src] with its scythe-like arm."), \
					SPAN_NOTICE("You caress \the [src] with your scythe-like arm."), null, 5, CHAT_TYPE_XENO_FLUFF)

			if("grab")
				if(M == src || anchored)
					return 0

				if(Adjacent(M)) //Logic!
					M.start_pulling(src)

					M.visible_message(SPAN_WARNING("[M] grabs \the [src]!"), \
					SPAN_WARNING("You grab \the [src]!"), null, 5, CHAT_TYPE_XENO_FLUFF)
					playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)

			if("hurt")
				M.animation_attack_on(src)
				if(hivenumber == M.hivenumber && !banished)
					M.visible_message(SPAN_WARNING("\The [M] nibbles \the [src]."), \
					SPAN_WARNING("You nibble \the [src]."), null, 5, CHAT_TYPE_XENO_FLUFF)
					return 1
				else
					// copypasted from attack_alien.dm
					//From this point, we are certain a full attack will go out. Calculate damage and modifiers
					var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)

					//Frenzy auras stack in a way, then the raw value is multipled by two to get the additive modifier
					if(M.frenzy_aura > 0)
						damage += (M.frenzy_aura * 2)

					//Somehow we will deal no damage on this attack
					if(!damage)
						playsound(M.loc, 'sound/weapons/alien_claw_swipe.ogg', 25, 1)
						M.visible_message(SPAN_DANGER("\The [M] lunges at [src]!"), \
						SPAN_DANGER("You lunge at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
						return 0

					M.visible_message(SPAN_DANGER("\The [M] slashes [src]!"), \
					SPAN_DANGER("You slash [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
					last_damage_source = initial(M.name)
					last_damage_mob = M
					src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was slashed by [M.name] ([M.ckey])</font>")
					M.attack_log += text("\[[time_stamp()]\] <font color='red'>slashed [src.name] ([src.ckey])</font>")
					log_attack("[M.name] ([M.ckey]) slashed [src.name] ([src.ckey])")

					M.flick_attack_overlay(src, "slash")
					playsound(loc, "alien_claw_flesh", 25, 1)
					apply_damage(damage, BRUTE)

			if("disarm")
				M.animation_attack_on(src)
				M.flick_attack_overlay(src, "disarm")
				if(!(isXenoQueen(M)) || M.hivenumber != src.hivenumber)
					playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1)
					M.visible_message(SPAN_WARNING("\The [M] shoves \the [src]!"), \
					SPAN_WARNING("You shove \the [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
					if(ismonkey(src))
						KnockDown(8)
				else
					playsound(loc, 'sound/weapons/alien_knockdown.ogg', 25, 1)
					M.visible_message(SPAN_WARNING("\The [M] shoves \the [src] out of her way!"), \
					SPAN_WARNING("You shove \the [src] out of your way!"), null, 5, CHAT_TYPE_XENO_COMBAT)
					src.KnockDown(1)
		return 1

/mob/living/carbon/Xenomorph/proc/attempt_headbutt(var/mob/living/carbon/Xenomorph/target)
	//Responding to a raised head
	if(target.flags_emote & EMOTING_HEADBUTT && do_after(src, 5, INTERRUPT_MOVED, EMOTE_ICON_HEADBUTT))
		if(!(target.flags_emote & EMOTING_HEADBUTT)) //Additional check for if the target moved or was already headbutted.
			to_chat(src, SPAN_NOTICE("Too slow!"))
			return
		target.flags_emote &= ~EMOTING_HEADBUTT
		visible_message(SPAN_NOTICE("[src] slams their head into [target]!"), \
			SPAN_NOTICE("You slam your head into [target]!"), null, 4)
		playsound(src, pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg'), 50, 1)
		animation_attack_on(target)
		target.animation_attack_on(src)
		start_audio_emote_cooldown()
		target.start_audio_emote_cooldown()
		return
	
	//Initiate headbutt
	if(recent_audio_emote)
		to_chat(src, "You just did an audible emote. Wait a while.")
		return

	visible_message(SPAN_NOTICE("[src] raises their head for a headbutt from [target]."), \
		SPAN_NOTICE("You raise your head for a headbutt from [target]."), null, 4)
	flags_emote |= EMOTING_HEADBUTT
	if(do_after(src, 50, INTERRUPT_ALL|INTERRUPT_EMOTE, EMOTE_ICON_HEADBUTT) && flags_emote & EMOTING_HEADBUTT)
		to_chat(src, SPAN_NOTICE("You were left hanging!"))
	flags_emote &= ~EMOTING_HEADBUTT

/mob/living/carbon/Xenomorph/proc/attempt_tailswipe(var/mob/living/carbon/Xenomorph/target)
	//Responding to a raised tail
	if(target.flags_emote & EMOTING_TAIL_SWIPE && do_after(src, 5, INTERRUPT_MOVED, EMOTE_ICON_TAILSWIPE))
		if(!(target.flags_emote & EMOTING_TAIL_SWIPE)) //Additional check for if the target moved or was already tail swiped.
			to_chat(src, SPAN_NOTICE("Too slow!"))
			return
		target.flags_emote &= ~EMOTING_TAIL_SWIPE
		visible_message(SPAN_NOTICE("[src] clashes their tail with [target]!"), \
			SPAN_NOTICE("You clash your tail with [target]!"), null, 4)
		playsound(src, 'sound/weapons/alien_claw_block.ogg', 50, 1)
		spin_circle()
		target.spin_circle()
		start_audio_emote_cooldown()
		target.start_audio_emote_cooldown()
		return
	
	//Initiate tail swipe
	if(recent_audio_emote)
		to_chat(src, "You just did an audible emote. Wait a while.")
		return

	visible_message(SPAN_NOTICE("[src] raises their tail out for a swipe from [target]."), \
		SPAN_NOTICE("You raise your tail out for a tail swipe from [target]."), null, 4)
	flags_emote |= EMOTING_TAIL_SWIPE
	if(do_after(src, 50, INTERRUPT_ALL|INTERRUPT_EMOTE, EMOTE_ICON_TAILSWIPE) && flags_emote & EMOTING_TAIL_SWIPE)
		to_chat(src, SPAN_NOTICE("You were left hanging!"))
	flags_emote &= ~EMOTING_TAIL_SWIPE
