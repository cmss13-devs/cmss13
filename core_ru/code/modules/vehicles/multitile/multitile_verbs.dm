//Megaphone gaming
/obj/vehicle/multitile/proc/use_megaphone()
	set name = "Use Megaphone"
	set desc = "Let's you shout a message to peoples around the vehicle."
	set category = "Vehicle"

	var/mob/living/user = usr
	if(user.client)
		if(user.client?.prefs?.muted & MUTE_IC)
			to_chat(src, SPAN_DANGER("You cannot speak in IC (muted)."))
			return
	if(!ishumansynth_strict(user))
		to_chat(user, SPAN_DANGER("You don't know how to use this!"))
		return
	if(user.silent)
		return

	var/obj/vehicle/multitile/V = user.interactee
	if(!istype(V))
		return

	var/seat
	for(var/vehicle_seat in V.seats)
		if(V.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break
	if(!seat)
		return

	if(world.time < V.next_shout)
		to_chat(user, SPAN_WARNING("You need to wait [(V.next_shout - world.time) / 10] seconds."))
		return

	var/message = tgui_input_text(user, "Shout a message?", "Megaphone", multiline = TRUE)
	if(!message)
		return
	// we know user is a human now, so adjust user for this check
	var/mob/living/carbon/human/humanoid = user
	var/list/new_message = humanoid.handle_speech_problems(message)
	message = new_message[1]
	message = capitalize(message)
	log_admin("[key_name(user)] used a vehicle megaphone to say: >[message]<")

	if(!user.is_mob_incapacitated())
		var/list/mob/listeners = get_mobs_in_view(9,V)
		var/list/mob/langchat_long_listeners = list()
		//RUCM START
		var/list/tts_heard_list = list(list(), list(), list())
		INVOKE_ASYNC(SStts, TYPE_PROC_REF(/datum/controller/subsystem/tts, queue_tts_message), src, html_decode(message), user.tts_voice, user.tts_voice_filter, tts_heard_list, FALSE, 50, user.tts_voice_pitch, "", user.speaking_noise)
		//RUCM END
		for(var/mob/listener in listeners)
			if(!ishumansynth_strict(listener) && !isobserver(listener))
				listener.show_message("[V] broadcasts something, but you can't understand it.")
				continue
			listener.show_message("<B>[V]</B> broadcasts, [FONT_SIZE_LARGE("\"[message]\"")]", SHOW_MESSAGE_AUDIBLE) // 2 stands for hearable message
			langchat_long_listeners += listener
		V.langchat_long_speech(message, langchat_long_listeners, user.get_default_language(), tts_heard_list)

		V.next_shout = world.time + 10 SECONDS
