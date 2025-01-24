#define TTS_SEED_DEFAULT_ANNOUNCE /datum/tts_seed/silero/kalechos_echo
#define TTS_SEED_ARES_ANNOUNCE /datum/tts_seed/silero/neltharion_echo
#define TTS_SEED_YAUTJA_ANNOUNCE /datum/tts_seed/silero/wrathion_echo
#define TTS_SEED_QUEEN_MOTHER_ANNOUNCE /datum/tts_seed/silero/alextraza_echo

/datum/announcer
	var/tts_seed = TTS_SEED_DEFAULT_ANNOUNCE
	var/sound_effect = SOUND_EFFECT_NONE
	var/mob/ammouncer

/datum/announcer/proc/Message(message, garbled_message, receivers, garbled_receivers)
	if(!tts_seed)
		return
	var/message_tts = message
	var/garbled_message_tts = garbled_message
	//message = message.Join("+")
	//garbled_message = garbled_message.Join("+")

	if(ammouncer)
		for(var/mob/M in receivers)
			ammouncer.cast_tts(M, message_tts, M, FALSE)
		for(var/mob/M in garbled_receivers)
			ammouncer.cast_tts(M, garbled_message_tts, M, FALSE)
		return

	for(var/mob/M in receivers)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(tts_cast), null, M, message_tts, tts_seed, FALSE, sound_effect, TTS_TRAIT_RATE_MEDIUM)
	for(var/mob/M in garbled_receivers)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(tts_cast), null, M, garbled_message_tts, tts_seed, FALSE, sound_effect, TTS_TRAIT_RATE_MEDIUM)


// Announcers

/datum/announcer/ares
	tts_seed = TTS_SEED_ARES_ANNOUNCE
	sound_effect = SOUND_EFFECT_RADIO_ROBOT

/datum/announcer/queen_mother
	tts_seed = TTS_SEED_QUEEN_MOTHER_ANNOUNCE

/datum/announcer/yautja
	tts_seed = TTS_SEED_YAUTJA_ANNOUNCE
	sound_effect = SOUND_EFFECT_ROBOT
