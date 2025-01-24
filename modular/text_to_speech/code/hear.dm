/*
Тут нету комбинировки, но потенциально нужно будет использовать
/mob/combine_message(list/message_pieces, verb, mob/speaker, always_stars)
	. = ..()
	return replace_characters(., list("+"))
*/

/mob/hear_say(message, verb = "says", datum/language/language = null, alt_name = "", italics = 0, mob/speaker = null, sound/speech_sound, sound_vol)
	. = ..()
	if(!speaker)
		return
	if(!say_understands(speaker, language))
		return
	speaker.cast_tts(src, message, src, FALSE, null, null)

/mob/hear_radio(
	message, verb="says",
	datum/language/language=null,
	part_a, part_b,
	mob/speaker = null,
	hard_to_hear = 0, vname ="",
	command = 0, no_paygrade = FALSE)
	. = ..()
	if(hard_to_hear || !speaker)
		return
	if(!say_understands(speaker, language))
		return
	speaker.cast_tts(src, message, src, FALSE, SOUND_EFFECT_RADIO, postSFX = 'modular/text_to_speech/code/sound/radio_chatter.ogg')

/*
/atom/atom_say(message)
	. = ..()
	if(!message)
		return
	for(var/mob/M in get_mobs_in_view(7, src))
		cast_tts(M, message)

	По идее нам не нужно, тот же телефон и прочие структуры используют
/obj/item/phone/proc/handle_hear(message, datum/language/L, mob/speaking)
	что внутри уже использует hear_radio
	TODO: нужно в целом проверить нормально ли "слышится" ТТС по телефону.
*/
