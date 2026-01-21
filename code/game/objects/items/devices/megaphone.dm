/obj/item/device/megaphone
	name = "megaphone"
	desc = "A device used to project your voice. Loudly. Pressing unique action will toggle voice amplification on and off. While active on your active hand, speaking will project your message to a much larger area."
	icon_state = "megaphone"
	item_state = "megaphone"
	icon = 'icons/obj/items/tools.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/tools_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/tools_righthand.dmi',
	)
	w_class = SIZE_SMALL
	flags_atom = FPRINT|CONDUCT

	var/spam_cooldown_time = 1.5 SECONDS
	var/amplifying = FALSE
	COOLDOWN_DECLARE(spam_cooldown)

/obj/item/device/megaphone/get_examine_text(mob/user)
	. = ..()
	if(amplifying)
		. += SPAN_HELPFUL("It is currently toggled on and amplifying your voice.")
	else
		. += SPAN_WARNING("It is currently toggled off.")


/obj/item/device/megaphone/unique_action(mob/living/user)
	amplifying = !amplifying
	if(amplifying)
		to_chat(user, SPAN_HELPFUL("You toggle the [src] on, amplifying your voice so long as it is on your active hand."))
	else
		to_chat(user, SPAN_NOTICE("You toggle the [src] off."))

	playsound(loc, 'sound/weapons/handling/safety_toggle.ogg', 25, 1, 6)

/obj/item/device/megaphone/attack_self(mob/living/user)
	. = ..()
	if(user.client)
		if(user.client?.prefs?.muted & MUTE_IC)
			to_chat(user, SPAN_DANGER("You cannot speak in IC (muted)."))
			return
	if(!ishumansynth_strict(user))
		to_chat(user, SPAN_DANGER("You don't know how to use this!"))
		return
	if(user.silent)
		return

	if(!COOLDOWN_FINISHED(src, spam_cooldown))
		to_chat(user, SPAN_DANGER("\The [src] needs to recharge! Wait [COOLDOWN_SECONDSLEFT(src, spam_cooldown)] second(s)."))
		return

	var/message = tgui_input_text(user, "Shout a message?", "Megaphone", multiline = TRUE)
	if(!message)
		return
	// we know user is a human now, so adjust user for this check
	var/mob/living/carbon/human/humanoid = user
	var/datum/language/speaking = humanoid.parse_language(message)
	if(speaking)
		message = copytext(message, 3)
	else
		speaking = user.get_default_language()

	var/list/speech_problems = humanoid.handle_speech_problems(message)
	message = speech_problems[1]
	message = capitalize(message)

	if(user.client?.prefs?.toggle_prefs & TOGGLE_AUTOMATIC_PUNCTUATION)
		if(!(copytext(message, -1) in ENDING_PUNCT))
			message += "."

	log_admin("[key_name(user)] used a megaphone to announce: >[message]<")

	if(user.get_active_hand() == src && !user.is_mob_incapacitated())
		// get mobs in the range of the user
		var/list/mob/listeners = viewers(user) // slow but we need it
		// mobs that pass the conditionals will be added here
		var/list/mob/langchat_long_listeners = list()
		var/paygrade = user.get_paygrade()

		for(var/mob/listener in listeners)
			if(!ishumansynth_strict(listener) && !isobserver(listener))
				listener.show_message("[user] says something to the megaphone, but you can't understand it.")
				continue
			var/broadcast = message

			if(speaking)
				if(!listener.say_understands(user, speaking))
					broadcast = speaking.scramble(message)
				broadcast = "<span class='[speaking.color]'>\"[broadcast]\"</span>"

			listener.show_message("<B>[paygrade][user]</B> broadcasts, [FONT_SIZE_LARGE(broadcast)]", SHOW_MESSAGE_AUDIBLE) // 2 stands for hearable message

			if(isliving(listener))
				var/mob/living/audience = listener
				if(skillcheck(user, SKILL_LEADERSHIP, SKILL_LEAD_TRAINED) && !HAS_TRAIT(audience, TRAIT_LEADERSHIP) && !skillcheck(audience, SKILL_LEADERSHIP, SKILL_LEAD_TRAINED))
					if(user.faction == audience.faction && !(audience.mob_flags & MUTINY_MUTINEER))
						audience.set_effect(3 SECONDS, HUSHED)
						to_chat(audience, SPAN_WARNING("You hush yourself as [user] broadcasts authoritatively through the [src]!"))
					else
						to_chat(audience, SPAN_WARNING("You hear [user] broadcast authoritatively... but you don't particularly care for it."))
			langchat_long_listeners += listener

		playsound(loc, 'sound/items/megaphone.ogg', 100, FALSE, TRUE)
		user.langchat_speech(message, langchat_long_listeners, speaking, additional_styles = list("langchat_announce"), split_long_messages = TRUE)

		COOLDOWN_START(src, spam_cooldown, spam_cooldown_time)

	// not on active hand
	else
		to_chat(user, SPAN_DANGER("You can only broadcast with the [name] when it is on your active hand!"))
