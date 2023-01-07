/datum/emote/living/carbon/human
	mob_type_allowed_typecache = list(/mob/living/carbon/human)

	/// Species that can use this emote.
	var/list/species_type_allowed_typecache = list(/datum/species/human, /datum/species/synthetic, /datum/species/yautja, /datum/species/monkey)
	/// Species that can't use this emote.
	var/list/species_type_blacklist_typecache

/datum/emote/living/carbon/human/New()
	. = ..()

	species_type_allowed_typecache = typecacheof(species_type_allowed_typecache)
	species_type_blacklist_typecache = typecacheof(species_type_blacklist_typecache)

/datum/emote/living/carbon/human/can_run_emote(mob/living/carbon/human/user, status_check, intentional)
	. = ..()

	if(!is_type_in_typecache(user.species, species_type_allowed_typecache))
		. = FALSE
	if(is_type_in_typecache(user.species, species_type_blacklist_typecache))
		. = FALSE

/datum/emote/living/carbon/human/primate
	species_type_allowed_typecache = list(/datum/species/monkey)

/datum/emote/living/carbon/human/blink
	key = "blink"
	key_third_person = "blinks"
	message = "blinks."

/datum/emote/living/carbon/human/blink_rapid
	key = "blink_r"
	key_third_person = "blinks_r"
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
	emote_type = EMOTE_AUDIBLE

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

/datum/emote/living/carbon/human/cry
	key = "cry"
	key_third_person = "cries"
	message = "cries."

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

/datum/emote/living/carbon/human/faint/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	user.sleeping += 10

/datum/emote/living/carbon/human/frown
	key = "frown"
	key_third_person = "frowns"
	message = "frowns."

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

/datum/emote/living/carbon/human/handshake
	key = "handshake"
	message = "shakes their own hand."
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
	message = "calls for a medic!"
	cooldown = 10 SECONDS
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/medic/get_sound(mob/living/user)
	if(user.gender == MALE)
		return pick('sound/voice/human_male_medic.ogg', 5;'sound/voice/human_male_medic_rare_1.ogg', 5;'sound/voice/human_male_medic_rare_2.ogg')
	else
		return 'sound/voice/human_female_medic.ogg'

/datum/emote/living/carbon/human/medic/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	user.show_speech_bubble("hmedic")
	if(isHumanStrict(user))
		var/list/heard = get_mobs_in_view(7, user)
		var/medic_message = pick("Medic!", "Doc!", "Help!")
		user.langchat_speech(medic_message, heard, GLOB.all_languages, skip_language_check = TRUE, animation_style = LANGCHAT_FAST_POP, additional_styles = list("langchat_bolded"))

/datum/emote/living/carbon/human/moan
	key = "moan"
	key_third_person = "moans"
	message = "moans."

/datum/emote/living/carbon/human/mumble
	key = "mumble"
	key_third_person = "mumbles"
	message = "mumbles."

/datum/emote/living/carbon/human/roll/jump
	key = "jump"
	key_third_person = "jumps"
	message = "jumps!"

/datum/emote/living/carbon/human/primate/scratch
	key = "scratch"
	key_third_person = "scratches"
	message = "scratches."

/datum/emote/living/carbon/human/primate/roll
	key = "roll"
	key_third_person = "rolls"
	message = "rolls."

/datum/emote/living/carbon/human/primate/tail
	key = "tail"
	message = "swipes their tail."

/datum/emote/living/carbon/human/nod
	key = "nod"
	key_third_person = "nods"
	message = "nods."

/datum/emote/living/carbon/human/pain
	key = "pain"
	message = "cries out in pain!"
	species_type_blacklist_typecache = list(/datum/species/synthetic)
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/pain/get_sound(mob/living/user)
	if(isHumanStrict(user))
		if(user.gender == MALE)
			return get_sfx("male_pain")
		else
			return get_sfx("female_pain")

	if(isYautja(user))
		return get_sfx("pred_pain")

/datum/emote/living/carbon/human/pain/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()

	user.show_speech_bubble("hpain")
	if(isHumanStrict(user))
		var/list/heard = get_mobs_in_view(7, src)
		var/pain_message = pick("OW!!", "AGH!!", "ARGH!!", "OUCH!!", "ACK!!", "OUF!")
		user.langchat_speech(pain_message, heard, GLOB.all_languages, skip_language_check = TRUE, animation_style = LANGCHAT_FAST_POP, additional_styles = list("langchat_yell"))

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
	if(isHumanStrict(user))
		if(user.gender == MALE)
			return get_sfx("male_scream")
		else
			return get_sfx("female_scream")
	if(isYautja(user))
		return get_sfx("pred_pain")

/datum/emote/living/carbon/human/primate/chimper
	key = "chimper"
	key_third_person = "chimpers"
	message = "chimpers."

/datum/emote/living/carbon/human/primate/whimper
	key = "whimper"
	key_third_person = "whimpers"
	message = "whimpers."

/datum/emote/living/carbon/human/whimper/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	user.show_speech_bubble("hscream")

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

/datum/emote/living/carbon/human/stare
	key = "stare"
	key_third_person = "stares"
	message = "stares."
	message_param = "stares at %t."

/datum/emote/living/carbon/human/signal
	key = "signal"
	key_third_person = "signals"
	message = "signals vaguely."

/datum/emote/living/carbon/human/signal/run_emote(mob/user, params, type_override, intentional)
	var/fingers = round(text2num(params))
	if(fingers <= 5 && (user.l_hand || user.r_hand))
		message = "raises [fingers] finger\s."
	else if(fingers <= 10 && (user.l_hand && user.r_hand))
		message = "raises [fingers] finger\s."
	return ..()

/datum/emote/living/carbon/human/twitch
	key = "twitch"
	key_third_person = "twitches"
	message = "twitches."

/datum/emote/living/carbon/human/wave
	key = "wave"
	key_third_person = "waves"
	message = "waves."

/datum/emote/living/carbon/human/yawn
	key = "yawn"
	key_third_person = "yawns"
	message = "yawns."

/datum/emote/living/carbon/human/warcry
	key = "warcry"
	message = "shouts an inspiring cry!"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/warcry/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()

	user.show_speech_bubble("hwarcry")

/datum/emote/living/carbon/human/warcry/get_sound(mob/living/user)
	if(isHumanSynthStrict(user))
		if(user.gender == MALE)
			return get_sfx("male_warcry")
		else
			return get_sfx("female_warcry")

/datum/emote/living/carbon/human/yautja
	species_type_allowed_typecache = list(/datum/species/yautja)

/datum/emote/living/carbon/human/yautja/anytime
	key = "anytime"
	sound = 'sound/voice/pred_anytime.ogg'
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/yautja/click
	key = "click"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/yautja/click/get_sound(mob/living/user)
	if(rand(0,100) < 50)
		return 'sound/voice/pred_click1.ogg'
	else
		return 'sound/voice/pred_click2.ogg'

/datum/emote/living/carbon/human/yautja/helpme
	key = "helpme"
	sound = 'sound/voice/pred_helpme.ogg'
	volume = 25
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/yautja/malescream
	key = "malescream"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/yautja/malescream/get_sound(mob/living/user)
	return get_sfx("male_scream")

/datum/emote/living/carbon/human/yautja/femalescream
	key = "femalescream"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/yautja/femalescream/get_sound(mob/living/user)
	return get_sfx("female_scream")

/datum/emote/living/carbon/human/yautja/iseeyou
	key = "iseeyou"
	sound = 'sound/hallucinations/i_see_you2.ogg'
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/yautja/itsatrap
	key = "itsatrap"
	sound = 'sound/voice/pred_itsatrap.ogg'
	volume = 25
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/yautja/laugh1
	key = "laugh1"
	sound = 'sound/voice/pred_laugh1.ogg'
	volume = 25
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/yautja/laugh2
	key = "laugh2"
	sound = 'sound/voice/pred_laugh2.ogg'
	volume = 25
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/yautja/laugh3
	key = "laugh3"
	sound = 'sound/voice/pred_laugh3.ogg'
	volume = 25
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/yautja/overhere
	key = "overhere"
	sound = 'sound/voice/pred_overhere.ogg'
	volume = 25
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/yautja/roar
	key = "roar"
	message = "roars!"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/yautja/roar/get_sound(mob/living/user)
	return pick('sound/voice/pred_roar1.ogg', 'sound/voice/pred_roar2.ogg')

/datum/emote/living/carbon/human/yautja/roar2
	key = "roar2"
	sound = 'sound/voice/pred_roar3.ogg'
	message = "roars!"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/yautja/loudroar
	key = "loudroar"
	message = "roars loudly!"
	volume = 60
	cooldown = 120 SECONDS
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/yautja/loadroar/get_sound(mob/living/user)
	return pick('sound/voice/pred_roar4.ogg', 'sound/voice/pred_roar5.ogg')

/datum/emote/living/carbon/human/yautja/loudroar/run_emote(mob/user, params, type_override, intentional)
	. = ..()

	for(var/mob/current_mob as anything in get_mobs_in_z_level_range(get_turf(user), 18) - user)
		var/relative_dir = get_dir(current_mob, user)
		to_chat(current_mob, SPAN_HIGHDANGER("You hear a loud roar coming from the [dir2text(relative_dir)]!"))

/datum/emote/living/carbon/human/yautja/turnaround
	key = "turnaround"
	sound = 'sound/voice/pred_turnaround.ogg'
	volume = 25
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/yautja/click2
	key = "click2"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/yautja/click2/get_sound(mob/living/user)
	return pick('sound/voice/pred_click3.ogg', 'sound/voice/pred_click4.ogg')

/datum/emote/living/carbon/human/yautja/aliengrowl
	key = "aliengrowl"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/yautja/aliengrowl/get_sound(mob/living/user)
	return pick('sound/voice/alien_growl1.ogg', 'sound/voice/alien_growl2.ogg')

/datum/emote/living/carbon/human/yautja/alienhelp
	key = "alienhelp"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/yautja/alienhelp/get_sound(mob/living/user)
	return pick('sound/voice/alien_help1.ogg', 'sound/voice/alien_help2.ogg')

/datum/emote/living/carbon/human/yautja/comeonout
	key = "comeonout"
	sound = 'sound/voice/pred_come_on_out.ogg'
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/yautja/overthere
	key = "overthere"
	sound = 'sound/voice/pred_over_there.ogg'
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/synthetic/working_joe
	species_type_allowed_typecache = list(/datum/species/synthetic/colonial/working_joe)
	volume = 75

/datum/emote/living/carbon/human/synthetic/working_joe/alwaysknow
	key = "alwaysknow"
	key_third_person = "workingjoe"
	sound = 'sound/voice/joe_alwaysknow.ogg'
	say_message = "You always know a Working Joe."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/hysterical
	key = "hysterical"
	sound = 'sound/voice/joe_hysterical.ogg'
	say_message = "You are becoming hysterical."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/safety
	key = "safety"
	sound = 'sound/voice/joe_safety.ogg'
	say_message = "You and I are going to have a talk about safety."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/awful_mess
	key = "awful"
	key_third_person = "mess"
	sound = 'sound/voice/joe_awful.ogg'
	say_message = "Tut, tut. What an awful mess."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/damage
	key = "damage"
	sound = 'sound/voice/joe_damage.ogg'
	say_message = "Do not damage Seegson property."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/firearm
	key = "firearm"
	sound = 'sound/voice/joe_firearm.ogg'
	say_message = "Firearms can cause serious injury. Let me assist you."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE


/mob/living/carbon/human/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	pose =  strip_html(input(usr, "This is [src]. \He is...", "Pose", null)  as text)

/mob/living/carbon/human/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	var/HTML = "<body>"
	HTML += "<tt>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=general'>General:</a> "
	HTML += TextPreview(flavor_texts["general"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=head'>Head:</a> "
	HTML += TextPreview(flavor_texts["head"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=face'>Face:</a> "
	HTML += TextPreview(flavor_texts["face"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=eyes'>Eyes:</a> "
	HTML += TextPreview(flavor_texts["eyes"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=torso'>Body:</a> "
	HTML += TextPreview(flavor_texts["torso"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=arms'>Arms:</a> "
	HTML += TextPreview(flavor_texts["arms"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=hands'>Hands:</a> "
	HTML += TextPreview(flavor_texts["hands"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=legs'>Legs:</a> "
	HTML += TextPreview(flavor_texts["legs"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=feet'>Feet:</a> "
	HTML += TextPreview(flavor_texts["feet"])
	HTML += "<br>"
	HTML += "<hr />"
	HTML +="<a href='?src=\ref[src];flavor_change=done'>\[Done\]</a>"
	HTML += "<tt>"
	show_browser(src, HTML, "Update Flavor Text", "flavor_changes", "size=430x300")
