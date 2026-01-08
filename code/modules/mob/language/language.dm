#define SCRAMBLE_CACHE_LEN 50 //maximum of 50 specific scrambled lines per language

/*
	Datum based languages. Easily editable and modular.
*/

/datum/language
	var/name = "an unknown language" // Fluff name of language if any.
	var/desc = "A language."  // Short description for 'Check Languages'.
	var/speech_verb = "says"  // 'says', 'hisses', 'farts'.
	var/ask_verb = "asks" // Used when sentence ends in a ?
	var/exclaim_verb = "exclaims" // Used when sentence ends in a !
	var/signlang_verb = list()    // list of emotes that might be displayed if this language has NONVERBAL or SIGNLANG flags
	var/color = "body"  // CSS style to use for strings in this language.
	var/key = "x" // Character used to speak in language eg. :o for Unathi.
	var/flags = 0 // Various language flags.
	var/native    // If set, non-native speakers will have trouble speaking.

	var/list/syllables // Used when scrambling text for a non-speaker.
	var/sentence_chance = 5   // Likelihood of making a new sentence after each syllable.
	var/space_chance = 55 // Likelihood of getting a space in the random scramble string
	var/list/scramble_cache = list()

/datum/language/proc/broadcast(mob/living/speaker, message, speaker_mask)

	log_say("[key_name(speaker)] : ([name]) [message] (AREA: [get_area_name(speaker)])")

	for(var/mob/player in GLOB.player_list)

		var/understood = 0

		if(istype(player,/mob/dead))
			understood = 1
		else if((src in player.languages) && check_special_condition(player))
			understood = 1

		if(understood)
			if(!speaker_mask)
				speaker_mask = speaker.name
			var/msg = "<i><span class='game say'>[name], <span class='name'>[speaker_mask]</span> <span class='message'>[speech_verb], \"<span class='[color]'>[message]</span><span class='message'>\"</span></span></span></i>"
			to_chat(player, "[msg]")

/datum/language/proc/check_special_condition(mob/other)
	return 1

/datum/language/proc/check_cache(input)
	var/lookup = scramble_cache[input]
	if(lookup)
		scramble_cache -= input
		scramble_cache[input] = lookup
	. = lookup

/datum/language/proc/add_to_cache(input, scrambled_text)
	// Add it to cache, cutting old entries if the list is too long
	scramble_cache[input] = scrambled_text
	if(length(scramble_cache) > SCRAMBLE_CACHE_LEN)
		scramble_cache.Cut(1, length(scramble_cache)-SCRAMBLE_CACHE_LEN-1)

/datum/language/proc/scramble(input)

	if(!LAZYLEN(syllables))
		return stars(input)

	// If the input is cached already, move it to the end of the cache and return it
	var/lookup = check_cache(input)
	if(lookup)
		return lookup

	var/input_size = length_char(input)
	var/scrambled_text = ""
	var/capitalize = TRUE

	while(length_char(scrambled_text) < input_size)
		var/next = pick(syllables)
		if(capitalize)
			next = capitalize(next)
			capitalize = FALSE
		scrambled_text += next
		var/chance = rand(100)
		if(chance <= sentence_chance)
			scrambled_text += ". "
			capitalize = TRUE
		else if(chance > sentence_chance && chance <= space_chance)
			scrambled_text += " "

	scrambled_text = trim(scrambled_text)
	var/ending = copytext_char(scrambled_text, -1)
	if(ending == ".")
		scrambled_text = copytext_char(scrambled_text, 1, -2)
	var/input_ending = copytext_char(input, -1)
	if(input_ending in list("!","?","."))
		scrambled_text += input_ending

	add_to_cache(input, scrambled_text)

	return scrambled_text

/datum/language/generated/scramble(input)
	// If the input is cached already, move it to the end of the cache and return it
	var/lookup = check_cache(input)
	if(lookup)
		return lookup

	var/input_size = length_char(input)
	var/scrambled_text = ""
	var/capitalize = TRUE

	while(length_char(scrambled_text) < input_size)
		var/next
		switch(name)
			if(LANGUAGE_JAPANESE)
				next = randomly_generate_japanese_word()
			if(LANGUAGE_CHINESE)
				next = randomly_generate_chinese_word()
		if(capitalize)
			next = capitalize(next)
			capitalize = FALSE
		scrambled_text += next
		var/chance = rand(100)
		if(chance <= sentence_chance)
			scrambled_text += ". "
			capitalize = TRUE
		else if(chance > sentence_chance && chance <= space_chance)
			scrambled_text += " "

	scrambled_text = trim(scrambled_text)
	var/ending = copytext_char(scrambled_text, -1)
	if(ending == ".")
		scrambled_text = copytext_char(scrambled_text, 1, -2)
	var/input_ending = copytext_char(input, -1)
	if(input_ending in list("!","?","."))
		scrambled_text += input_ending

	add_to_cache(input, scrambled_text)

	return scrambled_text

#undef SCRAMBLE_CACHE_LEN
