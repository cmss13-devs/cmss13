///How likely the nucleus (vowel) is to geminate ie a -> aa
#define JAPANESE_SOUND_GEMINATION_CHANCE_NUCLEUS 10
///How likely the initial (consonant) is to geminate ie k -> kk
#define JAPANESE_SOUND_GEMINATION_CHANCE_INITIAL 7.5
///How likely the consonant is to palatalise ie r -> ry
#define JAPANESE_SOUND_PALATALISATION_CHANCE 10
///How likely the syllable is not to have a consonant at the start, needs to be kinda high for convincing diphthongs
#define JAPANESE_SOUND_NULL_INITIAL_CHANCE 20
///How likely the syllable is to end in an N
#define JAPANESE_SOUND_N_FINAL_CHANCE 20
///How likely it is to insert an apostrophe between two syllables (this can happen anywhere, mainly used for morpheme boundaries.)
#define JAPANESE_SOUND_APOSTROPHE_CHANCE 30
///how likely voiced sounds are to geminate, these mainly occur in foreign loans so quite unlikely
#define JAPANESE_SOUND_GEMINATION_CHANCE_VOICED 20

/*
Hello and welcome to the Japanese language. Or rather, a random generator for it.
Full of snowflake checks and maybe even hard dels (but hopefully not). You're sure to love this.
*/

///holds the syllable's sound itself and information such as if it has a null initial or final_syllable
/datum/japanese_syllable
	var/syllable_sound
	var/null_initial
	var/null_final_syllable

/datum/japanese_syllable/proc/randomly_generate_japanese_syllable(initial_geminable = TRUE, nucleus_geminable = TRUE, no_null_initial = FALSE)
	var/syllable
	var/IN = (pick(subtypesof(/datum/japanese_sound/initial/))) //assign a random consonant and vowel
	var/NU = (pick(subtypesof(/datum/japanese_sound/nucleus/)))
	var/datum/japanese_sound/initial/initial = new IN
	var/datum/japanese_sound/nucleus/nucleus = new NU
	//time to do compatibilty checks, nucleus comes first as it determines what we can and can't palatalise
	if(prob(JAPANESE_SOUND_GEMINATION_CHANCE_NUCLEUS) && nucleus_geminable)
		if(nucleus.geminate())
			initial_geminable = FALSE //we do not allow this in order to reduce clutter
	//now for checks on the initial
	if(initial.forbidden_nuclei) //check if the nucleus is a W or a Y and then if it's trying to make yi/wi/wu/we/ye
		if(NU in initial.forbidden_nuclei)
			var/list/blacklist = list(/datum/japanese_sound/initial/w, /datum/japanese_sound/initial/y)
			var/list/allsounds = subtypesof(/datum/japanese_sound/initial/)
			var/list/good_sounds = allsounds - blacklist
			var/new_IN = pick(good_sounds)
			initial = new new_IN //swap the initial to something that's not w or y - we've already done the nucleus. This might make w and y a bit too uncommon.
	//now that we know our initial doesn't form an inherently illegal combination, we apply sound change rules to it
	if(prob(JAPANESE_SOUND_GEMINATION_CHANCE_INITIAL) && initial_geminable)
		initial.geminate()
	if(prob(JAPANESE_SOUND_PALATALISATION_CHANCE) || (initial.forced_to_palatalise && nucleus.forces_palatalisation))
		initial.palatalise(nucleus)
	initial.affricate(nucleus) //this doesn't force it to affricate, rather checks if it has to then does it if so
	//now we construct our syllable, n.b. this is not a mora since we include the nasal final_syllable and soukon. For instance, ppyan is four morae - Q-p-a-N. This however is still just one syllable.
	if(!(prob(JAPANESE_SOUND_NULL_INITIAL_CHANCE)) || no_null_initial)
		syllable += "[initial.sound]"
		null_initial = FALSE
	else
		null_initial = TRUE
	syllable += "[nucleus.sound]"
	if(prob(JAPANESE_SOUND_N_FINAL_CHANCE))
		var/datum/japanese_sound/final_syllable/final_syllable = new /datum/japanese_sound/final_syllable/n //because we only have -n
		syllable += "[final_syllable.sound]"
		null_final_syllable = FALSE
		QDEL_NULL(final_syllable)
	else
		null_final_syllable = TRUE
	syllable_sound = syllable
	QDEL_NULL(initial)
	QDEL_NULL(nucleus)

/proc/randomly_generate_japanese_word(syllables = pick(30;1, 35;2, 20;3, 10;4, 5;5)) //default has args which don't make obnoxiously massive words
	var/datum/japanese_syllable/J = new /datum/japanese_syllable
	if(syllables == 1) //only one syllable, no need for a loop
		J.randomly_generate_japanese_syllable(FALSE) //word-initial syllables cannot be geminated
		return J.syllable_sound //just return that as our word
	else
		var/word
		J.randomly_generate_japanese_syllable(FALSE) //you can't have a geminate sound at the start of a word
		word += J.syllable_sound //add this initial syllable (no geminate) to the word
		for(var/i = 1, i < syllables, i++) //now, repeat for the rest of the syllables in the word
			J.randomly_generate_japanese_syllable() //regenerate the syllable
			if(J.null_initial) //did our new syllable get a null initial?
				if(prob(JAPANESE_SOUND_APOSTROPHE_CHANCE)) //check for chance
					word += "'" //add our apostrophe to the word
			word += J.syllable_sound //add our newly generated syllable to the word, *after* the apostrophe
		QDEL_NULL(J)
		return word //now we're done, return our word

///a generic sound
/datum/japanese_sound
	var/sound = "sound" // the sound it makes, duh
	var/gemination_forbidden = FALSE //if it can geminate or not
	var/geminated_form = "soundsound" //sound when geminated
	var/low_chance_geminate = FALSE //just some basic phonetic information
	var/geminated = FALSE //has the sound been geminated or not?

///handle gemination, and make sure that if the sound is voiced the chance is lower
/datum/japanese_sound/proc/geminate()
	if(gemination_forbidden)
		return FALSE
	if(low_chance_geminate)
		if(!(prob(JAPANESE_SOUND_GEMINATION_CHANCE_VOICED)))
			return FALSE
	sound = geminated_form
	geminated = TRUE
	return TRUE

///an initial sound aka a consonant, contains a lot of data about stuff that only consonants can be
/datum/japanese_sound/initial
	sound = "intial"
	var/palatalised_forbidden = FALSE //if it can palatalise or not
	var/palatalised_form = "inyitial" //sound when palatalised
	var/palatalised_geminated_form = "ininyitial" //sound when geminated AND palatalised
	var/list/forbidden_nuclei //vowels it can't go before
	var/affricated_form //special form it takes on before a u. Applies to t, d, and h.
	var/geminated_affricated_form //self explanatory
	var/forced_to_palatalise = FALSE //if it HAS to palatalise before an I. Applies to t, d, s and z. This lets it bypass anti-palatalise rules on I but not e.

/datum/japanese_sound/initial/proc/palatalise(datum/japanese_sound/nucleus/nucleus)
	if(forced_to_palatalise && nucleus.forces_palatalisation) //is the sound forced to palatalise and is the nucleus i? then palatalise
		if(geminated) //we have to have the check above so that we get "chi" but not "che"
			sound = palatalised_geminated_form
			return
		else
			sound = palatalised_form
			return

	else if(nucleus.anti_palatalise || palatalised_forbidden) //if the nucleus is e or i and the sound is NOT forced to palatalise, return a nope
		return //or if the sound is forbidden from palatalising then return

	if(geminated) //now actually palatalise
		sound = palatalised_geminated_form
		return
	else
		sound = palatalised_form
		return

/datum/japanese_sound/initial/proc/affricate(datum/japanese_sound/nucleus/nucleus)
	if(affricated_form && nucleus.causes_affrication)
		if(geminated)
			sound = geminated_affricated_form
		else
			sound = affricated_form

/datum/japanese_sound/initial/n
	sound = "n"
	palatalised_form = "ny"
	geminated_form = "nn"
	palatalised_geminated_form = "nny"

/datum/japanese_sound/initial/m
	sound = "m"
	palatalised_form = "my"
	geminated_form = "mm"
	palatalised_geminated_form = "mmy"

/datum/japanese_sound/initial/b
	sound = "b"
	palatalised_form = "by"
	geminated_form = "bb"
	palatalised_geminated_form = "bby"
	low_chance_geminate = TRUE

/datum/japanese_sound/initial/p
	sound = "p"
	palatalised_form = "py"
	geminated_form = "pp"
	palatalised_geminated_form = "ppy"

/datum/japanese_sound/initial/t
	sound = "t"
	palatalised_form = "ch"
	geminated_form = "tt"
	palatalised_geminated_form = "tch" //nihon-shiki sucks, hepburn for life
	affricated_form = "ts"
	geminated_affricated_form = "tts"
	forced_to_palatalise = TRUE

/datum/japanese_sound/initial/d
	sound = "d"
	palatalised_form = "j"
	geminated_form = "dd"
	palatalised_geminated_form = "jj"
	affricated_form = "z" //no dialectal dz weirdness
	geminated_affricated_form =  "zz"
	forced_to_palatalise = TRUE
	low_chance_geminate = TRUE

/datum/japanese_sound/initial/s
	sound = "s"
	palatalised_form = "sh"
	geminated_form = "ss"
	palatalised_geminated_form = "ssh"
	forced_to_palatalise = TRUE

/datum/japanese_sound/initial/z
	sound = "z"
	palatalised_form = "j"
	geminated_form = "zz"
	palatalised_geminated_form = "jj"
	forced_to_palatalise = TRUE
	low_chance_geminate = TRUE

/datum/japanese_sound/initial/k
	sound = "k"
	palatalised_form = "ky"
	geminated_form = "kk"
	palatalised_geminated_form = "kky"

/datum/japanese_sound/initial/g
	sound = "g"
	palatalised_form = "gy"
	geminated_form = "gg"
	palatalised_geminated_form = "ggy"
	low_chance_geminate = TRUE

/datum/japanese_sound/initial/h
	sound = "h"
	palatalised_form = "hy"
	affricated_form = "f" //no need for geminated forms as h cannot geminate
	gemination_forbidden = TRUE

/datum/japanese_sound/initial/r
	sound = "r"
	palatalised_form = "ry"
	gemination_forbidden = TRUE

/datum/japanese_sound/initial/w
	sound = "w"
	palatalised_forbidden = TRUE
	gemination_forbidden = TRUE
	forbidden_nuclei = list(/datum/japanese_sound/nucleus/e, /datum/japanese_sound/nucleus/i, /datum/japanese_sound/nucleus/u)

/datum/japanese_sound/initial/y
	sound = "y"
	palatalised_forbidden = TRUE
	gemination_forbidden = TRUE
	forbidden_nuclei = list(/datum/japanese_sound/nucleus/e, /datum/japanese_sound/nucleus/i)

///a nucleus, aka a vowel sound
/datum/japanese_sound/nucleus
	sound = "nucleus"
	var/anti_palatalise = FALSE //if you can't palatalise sounds before it, applies to E and I.
	var/causes_affrication //if it's a U
	var/forces_palatalisation //if it's an I - this forces T, D, S, and Z to palatalise but prevents all others from palatalising

/datum/japanese_sound/nucleus/a
	sound = "a"
	geminated_form = "aa" //no diacritics, they fuck with capitalisation a ton, don't want to use combining diacritics since they can lead to even weirder problems

/datum/japanese_sound/nucleus/e
	sound = "e"
	geminated_form = "ei" //yeah, we use hepburn because it's AWESOME
	anti_palatalise = TRUE

/datum/japanese_sound/nucleus/i
	sound = "i"
	geminated_form = "ii"
	forces_palatalisation = TRUE
	anti_palatalise = TRUE

/datum/japanese_sound/nucleus/o
	sound = "o"
	geminated_form = "ou"

/datum/japanese_sound/nucleus/u
	sound = "u"
	geminated_form = "uu"
	causes_affrication = TRUE

///a final_syllable sound, not used for much since the only one possible is N.
/datum/japanese_sound/final_syllable
	sound = "final_syllable"
	gemination_forbidden = TRUE

/datum/japanese_sound/final_syllable/n
	sound = "n"
	gemination_forbidden = TRUE

#undef JAPANESE_SOUND_GEMINATION_CHANCE_INITIAL
#undef JAPANESE_SOUND_GEMINATION_CHANCE_NUCLEUS
#undef JAPANESE_SOUND_PALATALISATION_CHANCE
#undef JAPANESE_SOUND_NULL_INITIAL_CHANCE
#undef JAPANESE_SOUND_N_FINAL_CHANCE
#undef JAPANESE_SOUND_APOSTROPHE_CHANCE
#undef JAPANESE_SOUND_GEMINATION_CHANCE_VOICED
