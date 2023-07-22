#define VOWEL_CLASS_FRONT_CLOSE 1 //i and ü
#define VOWEL_CLASS_BACK_CLOSE 2 //u
#define VOWEL_CLASS_FRONT_MID 3 //e
#define VOWEL_CLASS_BACK_MID 4 //o
#define VOWEL_CLASS_OPEN 5 //a

#define FINAL_TYPE_OPEN 1 //no n or ng
#define FINAL_TYPE_DENTAL 2 //n
#define FINAL_TYPE_VELAR 3 //ng

#define INITIAL_TYPE_N 1
#define INITIAL_TYPE_G 2

///How likely the syllable is not to have a consonant at the start, needs to be kinda high
#define CHINESE_SOUND_ZERO_INITIAL_CHANCE 15

/proc/randomly_generate_chinese_word(syllables = pick(60;1, 35;2, 5;3))
	var/datum/chinese_syllable/C = new /datum/chinese_syllable
	if(syllables == 1) //only one syllable, no need for a loop
		C.randomly_generate_chinese_syllable()
		return C.syllable_sound //just return that as our word
	else
		var/word
		C.randomly_generate_chinese_syllable()
		word += C.syllable_sound //add this initial syllable to the word
		for(var/i = 1, i < syllables, i++) //now, repeat for the rest of the syllables in the word
			var/last_syllable_final_syllable_type = C.final_syllable_type //before we regenerate the syllable
			C.randomly_generate_chinese_syllable()
			if(C.zero_initial && !C.zero_initial_changing)
				word += "'" //add our apostrophe to the word
			if(last_syllable_final_syllable_type == FINAL_TYPE_DENTAL && C.initial_type == INITIAL_TYPE_G) //this isn't a strong rule but I'm doing it anyway
				word += "'" //add our apostrophe to the word
			word += C.syllable_sound //add our newly generated syllable to the word, *after* the apostrophe
		QDEL_NULL(C)
		return word //now we're done, return our word

/datum/chinese_syllable
	var/syllable_sound
	var/zero_initial = FALSE
	var/zero_initial_changing = FALSE
	var/final_syllable_type
	var/initial_type

/datum/chinese_syllable/proc/randomly_generate_chinese_syllable()
	//set these two back to FALSE, this is because we are possibly regenerating shit off the same datum!
	zero_initial = FALSE
	zero_initial_changing = FALSE
	//le funnyvar
	var/syllable
	//select intial
	var/IN = (pick(subtypesof(/datum/chinese_sound/initial/))) //assign a random consonant
	var/list/possible_final_syllables = subtypesof(/datum/chinese_sound/final_syllable)
	var/datum/chinese_sound/initial/initial = new IN
	if(prob(CHINESE_SOUND_ZERO_INITIAL_CHANCE))
		qdel(initial)
		initial = new /datum/chinese_sound/initial/zero
	//add intial to sound
	else if(!(initial.initial_sound_flags & ZERO_INITIAL))
		syllable += "[initial.sound]"
		//narrow down final_syllable list (for NON zero initials)

		//remove complex/simple -u- glide final_syllables
		if(initial.initial_sound_flags & SIMPLE_U_ONLY)
			for(var/datum/chinese_sound/final_syllable/final_syllable as anything in possible_final_syllables)
				if(initial(initial(final_syllable.vowel_class)) == VOWEL_CLASS_BACK_CLOSE)
					possible_final_syllables -= final_syllable
			possible_final_syllables += /datum/chinese_sound/final_syllable/u
		else if(initial.initial_sound_flags & HALF_U)
			for(var/datum/chinese_sound/final_syllable/final_syllable as anything in possible_final_syllables)
				if(initial(initial(final_syllable.vowel_class)) == VOWEL_CLASS_BACK_CLOSE && initial(final_syllable.final_syllable_sound_flags) & U_GROUP_FULL)
					possible_final_syllables -= final_syllable

		//check for if the sound is alveolo-palatal or sibilant/retroflex - then remove or keep front close vowels accordingly
		if(initial.initial_sound_flags & NO_FRONT_CLOSE)
			for(var/datum/chinese_sound/final_syllable/final_syllable as anything in possible_final_syllables)
				if(initial(final_syllable.vowel_class) == VOWEL_CLASS_FRONT_CLOSE)
					possible_final_syllables -= final_syllable
			//little bit of istype final_syllable snowflakery...
			if(istype(initial, /datum/chinese_sound/initial/k))
				possible_final_syllables -= /datum/chinese_sound/final_syllable/ei
			else if(!(initial.initial_sound_flags & NO_SYLLABIC_I))
				possible_final_syllables += /datum/chinese_sound/final_syllable/i //they keep syllabic z/r

		else if(initial.initial_sound_flags & FRONT_CLOSE_ONLY)
			for(var/datum/chinese_sound/final_syllable/final_syllable as anything in possible_final_syllables)
				if(initial(final_syllable.vowel_class) != VOWEL_CLASS_FRONT_CLOSE)
					possible_final_syllables -= final_syllable

		else if(initial(initial.sound))
			possible_final_syllables -= /datum/chinese_sound/final_syllable/ia //nothing other than jqx has ia
			possible_final_syllables -= /datum/chinese_sound/final_syllable/iang
			possible_final_syllables -= /datum/chinese_sound/final_syllable/iong

		//remove ü sounds if unneeded
		if(!(initial.initial_sound_flags & FRONT_CLOSE_ONLY) && !(initial.initial_sound_flags & NONDENTAL_ALV))
			for(var/datum/chinese_sound/final_syllable/final_syllable as anything in possible_final_syllables)
				if(initial(final_syllable.jqx_sound)) //all ü sounds
					possible_final_syllables -= final_syllable
					continue

		else if(initial.initial_sound_flags & NONDENTAL_ALV)
			for(var/datum/chinese_sound/final_syllable/final_syllable as anything in possible_final_syllables)
				if(initial(final_syllable.final_syllable_sound_flags) & U_UMLAUT_RARE)
					possible_final_syllables -= final_syllable

		//checks for predictable patterns
		if(initial.initial_sound_flags & NO_E_ONG)
			possible_final_syllables -= /datum/chinese_sound/final_syllable/e
			possible_final_syllables -= /datum/chinese_sound/final_syllable/ong

		if(initial.initial_sound_flags & DENTAL_ALV) //d and t
			possible_final_syllables -= /datum/chinese_sound/final_syllable/en
			possible_final_syllables -= /datum/chinese_sound/final_syllable/uang
			possible_final_syllables -= /datum/chinese_sound/final_syllable/yin

		else if(initial.initial_sound_flags & NONDENTAL_ALV) // n and l
			possible_final_syllables += /datum/chinese_sound/final_syllable/iang
			possible_final_syllables -= /datum/chinese_sound/final_syllable/ui


		//snowflake istype checks...
		if(istype(initial, /datum/chinese_sound/initial/t))
			possible_final_syllables -= /datum/chinese_sound/final_syllable/iu

		else if(istype(initial, /datum/chinese_sound/initial/r))
			possible_final_syllables -= /datum/chinese_sound/final_syllable/a
			possible_final_syllables -= /datum/chinese_sound/final_syllable/ai
			possible_final_syllables -= /datum/chinese_sound/final_syllable/ei

		else if(istype(initial, /datum/chinese_sound/initial/sh))
			possible_final_syllables -= /datum/chinese_sound/final_syllable/ong

		else if(istype(initial, /datum/chinese_sound/initial/ch))
			possible_final_syllables -= /datum/chinese_sound/final_syllable/ei

		else if(istype(initial, /datum/chinese_sound/initial/l))
			possible_final_syllables -= /datum/chinese_sound/final_syllable/en

		else if(istype(initial, /datum/chinese_sound/initial/b))
			possible_final_syllables -= /datum/chinese_sound/final_syllable/ou

		else if(istype(initial, /datum/chinese_sound/initial/f))
			possible_final_syllables -= /datum/chinese_sound/final_syllable/ao
			possible_final_syllables -= /datum/chinese_sound/final_syllable/ai

		else if(istype(initial, /datum/chinese_sound/initial/n))
			initial_type = INITIAL_TYPE_N

		else if(istype(initial, /datum/chinese_sound/initial/g))
			initial_type = INITIAL_TYPE_G

	//select final_syllable
	var/FN = pick(possible_final_syllables)
	var/datum/chinese_sound/final_syllable/final_syllable = new FN
	//mutate final_syllable sound
	if(istype(final_syllable, /datum/chinese_sound/final_syllable/o))
		if(initial.initial_sound_flags & SIMPLIFY_UO)
			final_syllable.sound = "o"

	if(initial.initial_sound_flags & ZERO_INITIAL)
		zero_initial = TRUE
		if(final_syllable.zero_initial_sound)
			final_syllable.sound = final_syllable.zero_initial_sound
			zero_initial_changing = TRUE

	if(initial(final_syllable.jqx_sound))
		if(initial.initial_sound_flags & FRONT_CLOSE_ONLY)
			final_syllable.sound = final_syllable.jqx_sound

	//add final_syllable to sound
	syllable += "[final_syllable.sound]"
	syllable_sound = syllable
	final_syllable_type = final_syllable.final_syllable_class
	QDEL_NULL(initial)
	QDEL_NULL(final_syllable)

/datum/chinese_sound
	var/sound = "sound" // the sound it makes, duh

/datum/chinese_sound/initial
	var/initial_sound_flags

/datum/chinese_sound/initial/zero
	sound = null
	initial_sound_flags = ZERO_INITIAL

/datum/chinese_sound/initial/p
	sound = "p"
	initial_sound_flags = SIMPLE_U_ONLY|NO_E_ONG

/datum/chinese_sound/initial/b
	sound = "b"
	initial_sound_flags = SIMPLE_U_ONLY|NO_E_ONG

/datum/chinese_sound/initial/t
	sound = "t"
	initial_sound_flags = HALF_U|DENTAL_ALV

/datum/chinese_sound/initial/d
	sound = "d"
	initial_sound_flags = HALF_U|DENTAL_ALV

/datum/chinese_sound/initial/k
	sound = "k"
	initial_sound_flags = NO_FRONT_CLOSE|NO_SYLLABIC_I

/datum/chinese_sound/initial/g
	sound = "g"
	initial_sound_flags = NO_FRONT_CLOSE|NO_SYLLABIC_I

/datum/chinese_sound/initial/f
	sound = "f"
	initial_sound_flags = SIMPLE_U_ONLY|NO_FRONT_CLOSE|NO_E_ONG|NO_SYLLABIC_I

/datum/chinese_sound/initial/s
	sound = "s"
	initial_sound_flags = HALF_U|NO_FRONT_CLOSE

/datum/chinese_sound/initial/c
	sound = "c"
	initial_sound_flags = HALF_U|NO_FRONT_CLOSE

/datum/chinese_sound/initial/z
	sound = "z"
	initial_sound_flags = HALF_U|NO_FRONT_CLOSE

/datum/chinese_sound/initial/h
	sound = "h"
	initial_sound_flags = NO_FRONT_CLOSE|NO_SYLLABIC_I

/datum/chinese_sound/initial/sh
	sound = "sh"
	initial_sound_flags = NO_FRONT_CLOSE

/datum/chinese_sound/initial/ch
	sound = "ch"
	initial_sound_flags = NO_FRONT_CLOSE

/datum/chinese_sound/initial/zh
	sound = "zh"
	initial_sound_flags = NO_FRONT_CLOSE

/datum/chinese_sound/initial/x
	sound = "x"
	initial_sound_flags = FRONT_CLOSE_ONLY

/datum/chinese_sound/initial/q
	sound = "q"
	initial_sound_flags = FRONT_CLOSE_ONLY

/datum/chinese_sound/initial/j
	sound = "j"
	initial_sound_flags = FRONT_CLOSE_ONLY

/datum/chinese_sound/initial/l
	sound = "l"
	initial_sound_flags = HALF_U|NONDENTAL_ALV

/datum/chinese_sound/initial/r
	sound = "r"
	initial_sound_flags = HALF_U|NO_FRONT_CLOSE

/datum/chinese_sound/initial/n
	sound = "n"
	initial_sound_flags = HALF_U|NONDENTAL_ALV

/datum/chinese_sound/initial/m
	sound = "m"
	initial_sound_flags = SIMPLE_U_ONLY|NO_E_ONG

/datum/chinese_sound/final_syllable
	sound = "final_syllable"
	var/zero_initial_sound //sound it makes with a zero initial. If null it's the same as the regular sound
	var/vowel_class
	var/final_syllable_sound_flags
	var/final_syllable_class
	var/jqx_sound //for ü syllables

/datum/chinese_sound/final_syllable/a
	vowel_class = VOWEL_CLASS_OPEN
	sound = "a"
	final_syllable_class = FINAL_TYPE_OPEN

/datum/chinese_sound/final_syllable/an
	vowel_class = VOWEL_CLASS_OPEN
	sound = "an"
	final_syllable_class = FINAL_TYPE_DENTAL

/datum/chinese_sound/final_syllable/ai
	vowel_class = VOWEL_CLASS_OPEN
	sound = "ai"
	final_syllable_class = FINAL_TYPE_OPEN

/datum/chinese_sound/final_syllable/ao
	vowel_class = VOWEL_CLASS_OPEN
	sound = "ao"
	final_syllable_class = FINAL_TYPE_OPEN

/datum/chinese_sound/final_syllable/ia
	vowel_class = VOWEL_CLASS_FRONT_CLOSE
	sound = "ia"
	zero_initial_sound = "ya"
	final_syllable_class = FINAL_TYPE_OPEN

/datum/chinese_sound/final_syllable/ua
	vowel_class = VOWEL_CLASS_BACK_CLOSE
	sound = "ua"
	zero_initial_sound = "wa"
	final_syllable_sound_flags = U_GROUP_FULL
	final_syllable_class = FINAL_TYPE_OPEN

/datum/chinese_sound/final_syllable/ang
	vowel_class = VOWEL_CLASS_OPEN
	sound = "ang"
	final_syllable_class = FINAL_TYPE_VELAR

/datum/chinese_sound/final_syllable/ian
	vowel_class = VOWEL_CLASS_FRONT_CLOSE
	sound = "ian"
	zero_initial_sound = "yan"
	final_syllable_class = FINAL_TYPE_DENTAL

/datum/chinese_sound/final_syllable/uan
	vowel_class = VOWEL_CLASS_BACK_CLOSE
	sound = "uan"
	zero_initial_sound = "wan"
	final_syllable_class = FINAL_TYPE_DENTAL

/datum/chinese_sound/final_syllable/uai
	vowel_class = VOWEL_CLASS_BACK_CLOSE
	sound = "uai"
	zero_initial_sound = "wai"
	final_syllable_sound_flags = U_GROUP_FULL
	final_syllable_class = FINAL_TYPE_OPEN

/datum/chinese_sound/final_syllable/iao
	vowel_class = VOWEL_CLASS_FRONT_CLOSE
	sound = "iao"
	zero_initial_sound = "yao"
	final_syllable_class = FINAL_TYPE_OPEN

/datum/chinese_sound/final_syllable/iang
	vowel_class = VOWEL_CLASS_FRONT_CLOSE
	sound = "iang"
	zero_initial_sound = "yang"
	final_syllable_class = FINAL_TYPE_VELAR


/datum/chinese_sound/final_syllable/uang
	vowel_class = VOWEL_CLASS_BACK_CLOSE
	sound = "uang"
	zero_initial_sound = "wang"
	final_syllable_sound_flags = U_GROUP_FULL
	final_syllable_class = FINAL_TYPE_VELAR

/datum/chinese_sound/final_syllable/e
	vowel_class = VOWEL_CLASS_FRONT_MID
	sound = "e"
	final_syllable_class = FINAL_TYPE_OPEN

/datum/chinese_sound/final_syllable/en
	vowel_class = VOWEL_CLASS_FRONT_MID
	sound = "en"
	final_syllable_class = FINAL_TYPE_DENTAL

/datum/chinese_sound/final_syllable/ei
	vowel_class = VOWEL_CLASS_FRONT_MID
	sound = "ei"
	final_syllable_class = FINAL_TYPE_OPEN

/datum/chinese_sound/final_syllable/ui //short ver of uei
	vowel_class = VOWEL_CLASS_BACK_CLOSE
	sound = "ui"
	zero_initial_sound = "wei"
	final_syllable_class = FINAL_TYPE_OPEN

/datum/chinese_sound/final_syllable/ie
	vowel_class = VOWEL_CLASS_FRONT_CLOSE
	sound = "ie"
	zero_initial_sound = "ye"
	final_syllable_class = FINAL_TYPE_OPEN

/datum/chinese_sound/final_syllable/eng
	vowel_class = VOWEL_CLASS_FRONT_MID
	sound = "eng"
	final_syllable_class = FINAL_TYPE_VELAR

/datum/chinese_sound/final_syllable/i
	vowel_class = VOWEL_CLASS_FRONT_CLOSE
	sound = "i"
	zero_initial_sound = "yi"
	final_syllable_class = FINAL_TYPE_OPEN

/datum/chinese_sound/final_syllable/yin //can't have in as a type
	vowel_class = VOWEL_CLASS_FRONT_CLOSE
	sound = "in"
	zero_initial_sound = "yin"
	final_syllable_class = FINAL_TYPE_DENTAL

/datum/chinese_sound/final_syllable/ing
	vowel_class = VOWEL_CLASS_FRONT_CLOSE
	sound = "ing"
	zero_initial_sound = "ying"
	final_syllable_class = FINAL_TYPE_VELAR

/datum/chinese_sound/final_syllable/o //more like "uo"
	vowel_class = VOWEL_CLASS_BACK_MID
	sound = "uo"
	zero_initial_sound = "wo"
	final_syllable_class = FINAL_TYPE_OPEN

/datum/chinese_sound/final_syllable/ou
	vowel_class = VOWEL_CLASS_BACK_MID
	sound = "ou"
	final_syllable_class = FINAL_TYPE_OPEN

/datum/chinese_sound/final_syllable/iu //short version of "iou"
	vowel_class = VOWEL_CLASS_FRONT_CLOSE
	sound = "iu"
	zero_initial_sound = "you"
	final_syllable_class = FINAL_TYPE_OPEN

/datum/chinese_sound/final_syllable/ong
	vowel_class = VOWEL_CLASS_BACK_MID
	sound = "ong"
	final_syllable_class = FINAL_TYPE_VELAR

/datum/chinese_sound/final_syllable/iong
	vowel_class = VOWEL_CLASS_FRONT_CLOSE
	sound = "iong"
	zero_initial_sound = "yong"
	final_syllable_class = FINAL_TYPE_VELAR

/datum/chinese_sound/final_syllable/u
	vowel_class = VOWEL_CLASS_BACK_CLOSE
	sound = "u"
	zero_initial_sound = "wu"
	final_syllable_class = FINAL_TYPE_OPEN

/datum/chinese_sound/final_syllable/un //this is actually uen
	vowel_class = VOWEL_CLASS_BACK_CLOSE
	sound = "un"
	zero_initial_sound = "wen"
	final_syllable_class = FINAL_TYPE_DENTAL

/datum/chinese_sound/final_syllable/yu
	vowel_class = VOWEL_CLASS_FRONT_CLOSE
	sound = "ü"
	zero_initial_sound = "yu"
	jqx_sound = "u"
	final_syllable_sound_flags = U_UMLAUT
	final_syllable_class = FINAL_TYPE_OPEN

/datum/chinese_sound/final_syllable/yun
	vowel_class = VOWEL_CLASS_FRONT_CLOSE
	sound = "ün"
	zero_initial_sound = "yun"
	jqx_sound = "un"
	final_syllable_sound_flags = U_UMLAUT_RARE
	final_syllable_class = FINAL_TYPE_DENTAL

/datum/chinese_sound/final_syllable/yue
	vowel_class = VOWEL_CLASS_FRONT_CLOSE
	sound = "üe"
	zero_initial_sound = "yue"
	jqx_sound = "ue"
	final_syllable_sound_flags = U_UMLAUT
	final_syllable_class = FINAL_TYPE_OPEN

/datum/chinese_sound/final_syllable/yuan
	vowel_class = VOWEL_CLASS_FRONT_CLOSE
	sound = "üan"
	zero_initial_sound = "yuan"
	jqx_sound = "uan"
	final_syllable_sound_flags = U_UMLAUT_RARE
	final_syllable_class = FINAL_TYPE_DENTAL

#undef VOWEL_CLASS_FRONT_CLOSE
#undef VOWEL_CLASS_BACK_CLOSE
#undef VOWEL_CLASS_FRONT_MID
#undef VOWEL_CLASS_BACK_MID
#undef VOWEL_CLASS_OPEN
#undef FINAL_TYPE_OPEN
#undef FINAL_TYPE_DENTAL
#undef FINAL_TYPE_VELAR
#undef CHINESE_SOUND_ZERO_INITIAL_CHANCE
