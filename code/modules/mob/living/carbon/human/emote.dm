/datum/emote/living/carbon/human
	mob_type_allowed_typecache = list(/mob/living/carbon/human)
	keybind_category = CATEGORY_HUMAN_EMOTE

	/// Species that can use this emote.
	var/list/species_type_allowed_typecache = list(/datum/species/human, /datum/species/synthetic, /datum/species/yautja)
	/// Species that can't use this emote.
	var/list/species_type_blacklist_typecache = list(/datum/species/monkey)

/datum/emote/living/carbon/human/New()
	. = ..()

	species_type_allowed_typecache = typecacheof(species_type_allowed_typecache)
	species_type_blacklist_typecache = typecacheof(species_type_blacklist_typecache)

/datum/emote/living/carbon/human/can_run_emote(mob/living/carbon/human/user, status_check, intentional)
	. = ..()
	if(!.)
		return

	if(!is_type_in_typecache(user.species, species_type_allowed_typecache))
		. = FALSE
	if(is_type_in_typecache(user.species, species_type_blacklist_typecache))
		. = FALSE

/datum/emote/living/carbon/human/blink
	key = "blink"
	key_third_person = "blinks"
	message = "blinks."

/datum/emote/living/carbon/human/blink_rapid
	key = "rapidblink"
	message = "blinks rapidly."

/datum/emote/living/carbon/human/bow
	key = "bow"
	key_third_person = "bows"
	message = "bows."
	message_param = "bows to %t."

/datum/emote/living/carbon/human/chuckle
	key = "chuckle"
	key_third_person = "chuckles"
	message = "chuckles."
	emote_type = EMOTE_VISIBLE|EMOTE_AUDIBLE

/datum/emote/living/carbon/human/clap
	key = "clap"
	key_third_person = "claps"
	message = "claps."
	hands_use_check = TRUE
	audio_cooldown = 5 SECONDS
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	sound = 'sound/misc/clap.ogg'

/datum/emote/living/carbon/human/collapse
	key = "collapse"
	key_third_person = "collapses"
	message = "collapses!"

/datum/emote/living/carbon/human/collapse/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	user.apply_effect(2, PARALYZE)

/datum/emote/living/carbon/human/cough
	key = "cough"
	key_third_person = "coughs"
	message = "coughs!"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/cry
	key = "cry"
	key_third_person = "cries"
	message = "cries."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/eyebrow
	key = "eyebrow"
	message = "raises an eyebrow."

/datum/emote/living/carbon/human/facepalm
	key = "facepalm"
	key_third_person = "facepalms"
	message = "facepalms."

/datum/emote/living/carbon/human/faint
	key = "faint"
	key_third_person = "faints"
	message = "faints!"

/datum/emote/living/carbon/human/faint/run_emote(mob/living/carbon/human/user, params, type_override, intentional)
	. = ..()
	user.sleeping += 10

/datum/emote/living/carbon/human/frown
	key = "frown"
	key_third_person = "frowns"
	message = "frowns."

/datum/emote/living/carbon/human/gasp
	key = "gasp"
	key_third_person = "gasps"
	message = "gasps!"
	emote_type = EMOTE_AUDIBLE
	stat_allowed = CONSCIOUS|UNCONSCIOUS


/datum/emote/living/carbon/human/giggle
	key = "giggle"
	key_third_person = "giggles"
	message = "giggles."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/glare
	key = "glare"
	key_third_person = "glares"
	message = "glares."
	message_param = "glares at %t."

/datum/emote/living/carbon/human/golfclap
	key = "golfclap"
	key_third_person = "golfclaps"
	message = "claps, clearly unimpressed."
	alt_message = "claps"
	sound = 'sound/misc/golfclap.ogg'
	cooldown = 5 SECONDS
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/grin
	key = "grin"
	key_third_person = "grins"
	message = "grins."

/datum/emote/living/carbon/human/grumble
	key = "grumble"
	key_third_person = "grumbles"
	message = "grumbles."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/handshake
	key = "handshake"
	message_param = "shakes hands with %t."

/datum/emote/living/carbon/human/laugh
	key = "laugh"
	key_third_person = "laughs"
	message = "laughs!"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/look
	key = "look"
	key_third_person = "looks"
	message = "looks."
	message_param = "looks at %t."

/datum/emote/living/carbon/human/medic
	key = "medic"
	message = "calls for a Corpsman!"
	alt_message = "shouts something"
	cooldown = 10 SECONDS
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/medic/get_sound(mob/living/user)
	if(user.gender == MALE)
		return pick('sound/voice/corpsman.ogg', 'sound/voice/corpsman_up.ogg', 'sound/voice/corpsman_over_here.ogg', 'sound/voice/i_need_a_corpsman_1.ogg', 'sound/voice/i_need_a_corpsman_2.ogg', 'sound/voice/im_hit_get_doc_up_here.ogg', 'sound/voice/get_doc_up_here_im_hit.ogg', 20;'sound/voice/i_cant_feel_my_legs_corpsman.ogg', 0.5;'sound/voice/human_male_medic_rare_1.ogg', 0.5;'sound/voice/human_male_medic.ogg', 1;'sound/voice/human_male_medic_rare_2.ogg')
	else
		return 'sound/voice/human_female_medic.ogg'

/datum/emote/living/carbon/human/medic/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return FALSE

	user.show_speech_bubble("medic")

/datum/emote/living/carbon/human/medic/run_langchat(mob/user, group)
	if(!ishuman_strict(user))
		return

	var/medic_message = pick("Corpsman!", "Doc!", "Help!")
	user.langchat_speech(medic_message, group, GLOB.all_languages, skip_language_check = TRUE, animation_style = LANGCHAT_FAST_POP, additional_styles = list("langchat_bolded"))

/datum/emote/living/carbon/human/groan
	key = "groan"
	message = "groans."
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	emote_type = EMOTE_AUDIBLE


/datum/emote/living/carbon/human/mumble
	key = "mumble"
	key_third_person = "mumbles"
	message = "mumbles."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/nod
	key = "nod"
	key_third_person = "nods"
	message = "nods."

/datum/emote/living/carbon/human/pain
	key = "pain"
	message = "cries out in pain!"
	alt_message = "cries out"
	species_type_blacklist_typecache = list(/datum/species/synthetic)
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/pain/get_sound(mob/living/user)
	if(ishuman_strict(user))
		if(user.gender == MALE)
			return get_sfx("male_pain")
		else
			return get_sfx("female_pain")

	if(isyautja(user))
		return get_sfx("pred_pain")

/datum/emote/living/carbon/human/pain/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return FALSE

	user.show_speech_bubble("pain")

/datum/emote/living/carbon/human/pain/run_langchat(mob/user, group)
	if(!ishuman_strict(user))
		return

	var/pain_message = pick("OW!!", "AGH!!", "ARGH!!", "OUCH!!", "ACK!!", "OUF!")
	user.langchat_speech(pain_message, group, GLOB.all_languages, skip_language_check = TRUE, animation_style = LANGCHAT_FAST_POP, additional_styles = list("langchat_yell"))

/datum/emote/living/carbon/human/eyerub
	key = "eyerub"
	key_third_person = "rubeyes"
	message = "rubs their eyes."

/datum/emote/living/carbon/human/salute
	key = "salute"
	key_third_person = "salutes"
	message = "salutes."
	message_param = "salutes to %t."
	sound = 'sound/misc/salute.ogg'
	audio_cooldown = 10 SECONDS
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/scream
	key = "scream"
	key_third_person = "screams"
	message = "screams!"
	audio_cooldown = 10 SECONDS
	species_type_blacklist_typecache = list(/datum/species/synthetic)
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/scream/get_sound(mob/living/user)
	if(ishuman_strict(user))
		if(user.gender == MALE)
			return get_sfx("male_scream")
		else
			return get_sfx("female_scream")
	if(isyautja(user))
		return get_sfx("pred_pain")

/datum/emote/living/carbon/human/scream/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return FALSE

	user.show_speech_bubble("scream")

/datum/emote/living/carbon/human/scream/run_langchat(mob/user, group)
	if(!ishuman_strict(user))
		return

	var/scream_message = pick("FUCK!!!", "AGH!!!", "ARGH!!!", "AAAA!!!", "HGH!!!", "NGHHH!!!", "NNHH!!!", "SHIT!!!")
	user.langchat_speech(scream_message, group, GLOB.all_languages, skip_language_check = TRUE, animation_style = LANGCHAT_PANIC_POP, additional_styles = list("langchat_yell"))

/datum/emote/living/carbon/human/shakehead
	key = "shakehead"
	message = "shakes their head."

/datum/emote/living/carbon/human/shiver
	key = "shiver"
	key_third_person = "shivers"
	message = "shivers."

/datum/emote/living/carbon/human/shrug
	key = "shrug"
	key_third_person = "shrugs"
	message = "shrugs."

/datum/emote/living/carbon/human/sigh
	key = "sigh"
	key_third_person = "sighs"
	message = "sighs."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/smile
	key = "smile"
	key_third_person = "smiles"
	message = "smiles."

/datum/emote/living/carbon/human/sneeze
	key = "sneeze"
	key_third_person = "sneezes"
	message = "sneezes!"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/snore
	key = "snore"
	key_third_person = "snores"
	message = "snores."
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/stare
	key = "stare"
	key_third_person = "stares"
	message = "stares."
	message_param = "stares at %t."

/datum/emote/living/carbon/human/signal
	key = "signal"
	key_third_person = "signals"
	message_param = "raises %t fingers."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/signal/run_emote(mob/user, params, type_override, intentional)
	params = text2num(params)
	if(params == 1 || !isnum(params))
		return "raises one finger."
	params = num2text(clamp(params, 2, 10))
	return ..()

/datum/emote/living/carbon/human/stop
	key = "stop"
	message = "holds out an open palm, gesturing to stop."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/squint
	key = "squint"
	key_third_person = "squints"
	message = "squints their eyes."

/datum/emote/living/carbon/human/thumbsup
	key = "thumbsup"
	message = "gives a thumbs up."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/thumbsdown
	key = "thumbsdown"
	message = "gives a thumbs down."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/twitch
	key = "twitch"
	key_third_person = "twitches"
	message = "twitches."

/datum/emote/living/carbon/human/wave
	key = "wave"
	key_third_person = "waves"
	message = "waves."

/datum/emote/living/carbon/human/wince
	key = "wince"
	key_third_person = "winces"
	message = "winces."

/datum/emote/living/carbon/human/writhe
	key = "writhe"
	key_third_person = "writhes"
	message = "writhes in pain!"
	stat_allowed = CONSCIOUS|UNCONSCIOUS

/datum/emote/living/carbon/human/yawn
	key = "yawn"
	key_third_person = "yawns"
	message = "yawns."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/warcry
	key = "warcry"
	message = "shouts an inspiring cry!"
	alt_message = "shouts something"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/warcry/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return FALSE

	user.show_speech_bubble("warcry")

/datum/emote/living/carbon/human/warcry/get_sound(mob/living/user)
	if(ishumansynth_strict(user))
		if(user.gender == MALE)
			if(user.faction == FACTION_UPP)
				return get_sfx("male_upp_warcry")
			else
				return get_sfx("male_warcry")
		else
			if(user.faction == FACTION_UPP)
				return get_sfx("female_upp_warcry")
			else
				return get_sfx("female_warcry")

/datum/emote/living/carbon/human/whimper
	key = "whimper"
	key_third_person = "whimpers"
	message = "whimpers."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/whimper/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return

	user.show_speech_bubble("scream")

//list of emotes that can't be called by players but only by code

/datum/emote/living/carbon/human/bloodcough
	key = "bloodcough"
	message = "coughs up blood."
	alt_message = "is coughing up something."
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	emote_type = EMOTE_VISIBLE|EMOTE_AUDIBLE
	only_forced = TRUE

/datum/emote/living/carbon/human/bloodcough/run_emote(mob/living/carbon/user, params, type_override, intentional)
	user.drip(10)
	return ..()

/datum/emote/living/carbon/human/eyebleed
	key = "eyebleed"
	message = "bleeds profusley from their eyes."
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	only_forced = TRUE

/datum/emote/living/carbon/human/eyebleed/run_emote(mob/living/carbon/user, params, type_override, intentional)
	user.drip(10)
	return ..()

/datum/emote/living/carbon/human/stumble
	key = "stumble"
	message = "stumbles around in confusion."
	only_forced = TRUE

/datum/emote/living/carbon/human/seize
	key = "seize"
	message = "violently convulses."
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	only_forced = TRUE

/datum/emote/living/carbon/human/foam
	key = "foam"
	message = "foams at the mouth."
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	only_forced = TRUE

/datum/emote/living/carbon/human/foamfall
	key = "foamfall"
	message = "falls to the ground and begins foaming at the mouth."
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	only_forced = TRUE

/datum/emote/living/carbon/human/paralyzed
	key = "paralyzed"
	message = "falls to the ground paralyzed."
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	only_forced = TRUE

/datum/emote/living/carbon/human/eyescratch
	key = "eyescratch"
	message = "scratches at their eyes."
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	only_forced = TRUE

/datum/emote/living/carbon/human/drool
	key = "drool"
	message = "drools."
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	only_forced = TRUE

/datum/emote/living/carbon/human/foamchoke
	key = "foamchoke"
	message = "spasms as they suffocate from the foam."
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	only_forced = TRUE


/datum/emote/living/carbon/human/wheeze
	key = "wheeze"
	message = "raspily wheezes."
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	emote_type = EMOTE_AUDIBLE
	only_forced = TRUE

/datum/emote/living/carbon/human/thrash
	key = "trash"
	message = "thrashes about wildly."
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	only_forced = TRUE

/datum/emote/living/carbon/human/acidglob
	key = "acidglob"
	message = "falls to the ground coated in acid."
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	only_forced = TRUE

/datum/emote/living/carbon/human/neuroglob
	key = "neuroglob"
	message = "falls to the ground coasted in the neurotoxic liquid."
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	only_forced = TRUE

/datum/emote/living/carbon/human/electrocuted
	key = "electrocuted"
	message = "convulses as the electricity enters their body."
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	only_forced = TRUE

/datum/emote/living/carbon/human/shake
	key = "shake"
	message = "shakes uncontrollably!"
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	only_forced = TRUE

/datum/emote/living/carbon/human/vomit
	key = "vomit"
	message = "vomits profusely!"
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	only_forced = TRUE

/datum/emote/living/carbon/human/badlung
	key = "badlung"
	message = "breathes with an awful rattling noise."
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	only_forced = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/pale
	key = "pale"
	message = "goes pale."
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	only_forced = TRUE

/datum/emote/living/carbon/human/clutchstomach
	key = "stomachclutch"
	message = "clutches at their stomach!"
	only_forced = TRUE

/datum/emote/living/carbon/human/clutchchest
	key = "chestclutch"
	message = "clutches at their chest!"
	only_forced = TRUE

/datum/emote/living/carbon/human/tremors
	key = "tremors"
	message = "tremors."
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	only_forced = TRUE

/datum/emote/living/carbon/human/clutchhead
	key = "headclutch"
	message = "clutches at their head!"
	only_forced = TRUE

/datum/emote/living/carbon/human/pain/legcollapse
	key = "legcollapse"
	message = "yells out in pain and collapses as their legs buckle."
	only_forced = TRUE

/datum/emote/living/carbon/human/paincollapse
	key = "paincollapse"
	message = "writhes in pain, unable to go on."
	stat_allowed = CONSCIOUS|UNCONSCIOUS
	only_forced = TRUE


/*

/datum/emote/living/carbon/human/
	key = "
	message = "
	only_forced = TRUE

*/
