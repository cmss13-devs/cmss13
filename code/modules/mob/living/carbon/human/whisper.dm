//Lallander was here
/mob/living/carbon/human/whisper(message as text)
	var/alt_name = ""

	log_whisper("[src.name]/[src.key] : [message]")

	if (src.client)
		if (src.client.prefs.muted & MUTE_IC)
			to_chat(src, SPAN_DANGER("You cannot whisper (muted)."))
			return

		if (src.client.handle_spam_prevention(message,MUTE_IC))
			return

	if (src.stat == 2)
		return src.say_dead(message)

	if (src.stat)
		return

	message =  trim(strip_html(message))	//made consistent with say

	if(name != GetVoice())
		alt_name = "(as [get_id_name("Unknown")])"

	//parse the language code and consume it
	var/datum/language/speaking = parse_language(message)
	if (speaking)
		message = copytext(message,3)

	whisper_say(message, speaking, alt_name)


//This is used by both the whisper verb and human/say() to handle whispering
/mob/living/carbon/human/proc/whisper_say(var/message, var/datum/language/speaking = null, var/alt_name="", var/verb="whispers")
	var/message_range = 1
	var/eavesdropping_range = 2
	var/watching_range = 5
	var/italics = 1

	if (speaking)
		verb = speaking.speech_verb + pick(" quietly", " softly")

	message = capitalize(trim(message))

	//TODO: handle_speech_problems for silent
	if (!message || silent)
		return

	// Mute disability
	//TODO: handle_speech_problems
	if (src.sdisabilities & MUTE)
		return

	//TODO: handle_speech_problems
	if (istype(src.wear_mask, /obj/item/clothing/mask/muzzle))
		return

	//TODO: handle_speech_problems
	if (src.stuttering)
		message = stutter(message)

	var/list/listening = hearers(message_range, src)
	listening |= src

	//ghosts
	for (var/mob/M in dead_mob_list)	//does this include players who joined as observers as well?
		if (!(M.client))
			continue
		if((M.stat == DEAD || isobserver(M)) && M.client && (M.client.prefs.toggles_chat & CHAT_GHOSTEARS))
			listening |= M

	//Pass whispers on to anything inside the immediate listeners.
	for(var/mob/L in listening)
		for(var/mob/C in L.contents)
			if(istype(C,/mob/living))
				listening += C

	//pass on the message to objects that can hear us.
	for (var/obj/O in view(message_range, src))
		spawn (0)
			if (O)
				O.hear_talk(src, message)	//O.hear_talk(src, message, verb, speaking)

	var/list/eavesdropping = hearers(eavesdropping_range, src)
	eavesdropping -= src
	eavesdropping -= listening

	var/list/watching  = hearers(watching_range, src)
	watching  -= src
	watching  -= listening
	watching  -= eavesdropping

	//now mobs
	var/speech_bubble_test = say_test(message)
	var/image/speech_bubble = image('icons/mob/hud/talk.dmi',src,"h[speech_bubble_test]")

	var/not_dead_speaker = (stat != DEAD)
	for(var/mob/M in listening)
		if(not_dead_speaker)
			M << speech_bubble
		M.hear_say(message, verb, speaking, alt_name, italics, src)

	if (eavesdropping.len)
		var/new_message = stars(message)	//hopefully passing the message twice through stars() won't hurt... I guess if you already don't understand the language, when they speak it too quietly to hear normally you would be able to catch even less.
		for(var/mob/M in eavesdropping)
			if(not_dead_speaker)
				M << speech_bubble
			M.hear_say(new_message, verb, speaking, alt_name, italics, src)

	spawn(30)
		if(client) client.images -= speech_bubble
		if(not_dead_speaker)
			log_say("[name] \[Whisper\]: [message] (CKEY: [key]) (JOB: [job])")
			for(var/mob/M in listening)
				if(M.client) M.client.images -= speech_bubble
			for(var/mob/M in eavesdropping)
				if(M.client) M.client.images -= speech_bubble
		qdel(speech_bubble)


	if (watching.len)
		var/rendered = "<span class='game say'><span class='name'>[src.name]</span> whispers something.</span>"
		for (var/mob/M in watching)
			M.show_message(rendered, 2)
