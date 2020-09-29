/obj/item/device/megaphone
	name = "megaphone"
	desc = "A device used to project your voice. Loudly."
	icon_state = "megaphone"
	item_state = "radio"
	w_class = SIZE_SMALL
	flags_atom = FPRINT|CONDUCT

	var/spamcheck = 0
	var/insults = 0
	var/list/insultmsg = list("FUCK EVERYONE!", "I'M A TATER!", "ALL SECURITY TO SHOOT ME ON SIGHT!", "I HAVE A BOMB!", "CAPTAIN IS A COMDOM!", "FOR THE SYNDICATE!")

/obj/item/device/megaphone/attack_self(mob/living/user)
	if (user.client)
		if(user.client.prefs.muted & MUTE_IC)
			to_chat(src, SPAN_DANGER("You cannot speak in IC (muted)."))
			return
	if(!ishuman(user))
		to_chat(user, SPAN_DANGER("You don't know how to use this!"))
		return
	if(user.silent)
		return

	var/mob/living/carbon/human/H = user
	if(H.species && H.species == "Yautja")
		to_chat(user, "Some soft-meat toy. It's useless to you.")
		return

	if(spamcheck)
		to_chat(user, SPAN_DANGER("\The [src] needs to recharge!"))
		return

	var/message = strip_html(input(user, "Shout a message?", "Megaphone", null)  as text)
	if(!message)
		return
	message = capitalize(message)
	log_admin("[key_name(user)] used a megaphone to say: >[message]<")
	if ((src.loc == user && usr.stat == 0))
		var/list/mob/living/carbon/human/vw = viewers(user) // slow but we need it
		for(var/mob/living/carbon/human/O in vw)
			if(O.species && O.species.name == "Yautja") //NOPE
				O.show_message("[user] says something on the microphone, but you can't understand it.")
				continue
			O.show_message("<B>[user]</B> broadcasts, [FONT_SIZE_LARGE("\"[message]\"")]",2) // 2 stands for hearable message


		user.langchat_long_speech(message, vw, user.get_default_language())

		spamcheck = 1
		addtimer(VARSET_CALLBACK(src, spamcheck, 0), 2 SECONDS)
