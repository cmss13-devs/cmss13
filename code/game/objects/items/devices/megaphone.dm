/obj/item/device/megaphone
	name = "megaphone"
	desc = "A device used to project your voice. Loudly."
	icon_state = "megaphone"
	item_state = "radio"
	w_class = SIZE_SMALL
	flags_atom = FPRINT|CONDUCT

	var/spam_cooldown_time = 2 SECONDS
	COOLDOWN_DECLARE(spam_cooldown)

/obj/item/device/megaphone/attack_self(mob/living/user)
	. = ..()
	if(user.client)
		if(user.client?.prefs?.muted & MUTE_IC)
			to_chat(src, SPAN_DANGER("You cannot speak in IC (muted)."))
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
	var/list/new_message = humanoid.handle_speech_problems(message)
	message = new_message[1]
	message = capitalize(message)
	log_admin("[key_name(user)] used a megaphone to say: >[message]<")

	if((src.loc == user && !user.is_mob_incapacitated()))
		// get mobs in the range of the user
		var/list/mob/listeners = viewers(user) // slow but we need it
		// mobs that pass the conditionals will be added here
		var/list/mob/langchat_long_listeners = list()
		for(var/mob/listener in listeners)
			if(!ishumansynth_strict(listener) && !isobserver(listener))
				listener.show_message("[user] says something on the microphone, but you can't understand it.")
				continue
			listener.show_message("<B>[user]</B> broadcasts, [FONT_SIZE_LARGE("\"[message]\"")]", SHOW_MESSAGE_AUDIBLE) // 2 stands for hearable message
			langchat_long_listeners += listener
		user.langchat_long_speech(message, langchat_long_listeners, user.get_default_language())

		COOLDOWN_START(src, spam_cooldown, spam_cooldown_time)
