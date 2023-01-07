/datum/emote/living/carbon/human
	mob_type_allowed_typecache = list(/mob/living/carbon/human)

/datum/emote/living/carbon/human/blink
	key = "blink"
	key_third_person = "blinks"
	message = "blinks."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/blink_rapid
	key = "blink_r"
	key_third_person = "blinks_r"
	message = "blinks rapidly."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/bow
	key = "bow"
	key_third_person = "bows"
	message = "bows."
	message_param = "bows to %t."

/datum/emote/living/carbon/human/chuckle
	key = "chuckle"
	key_third_person = "chuckles"
	message = "chuckles."

/datum/emote/living/carbon/human/clap
	key = "clap"
	key_third_person = "claps"
	message = "claps."
	hands_use_check = TRUE
	audio_cooldown = 5 SECONDS
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
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

/datum/emote/living/carbon/human/look
	key = "look"
	key_third_person = "looks"
	message = "looks."
	message_param = "looks at %t."

/datum/emote/living/carbon/human/medic
	key = "medic"
	message = "calls for a medic!"
	cooldown = 10 SECONDS

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

/datum/emote/living/carbon/human/jump
	key = "jump"
	key_third_person = "jumps"
	message = "jumps!"

/datum/emote/living/carbon/human/scratch
	key = "scratch"
	key_third_person = "scratches"
	message = "scratches."

/datum/emote/living/carbon/human/roll
	key = "roll"
	key_third_person = "rolls"
	message = "rolls."

/datum/emote/living/carbon/human/nod
	key = "nod"
	key_third_person = "nods"
	message = "nods."

/datum/emote/living/carbon/human/pain
	key = "pain"
	message = "cries out in pain!"

/datum/emote/living/carbon/human/pain/get_sound(mob/living/user)
	if(isHumanStrict(user))
		if(user.gender == MALE)
			return "male_pain"
		else
			return "female_pain"

	if(isYautja(user))
		return "pred_pain"

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

/datum/emote/living/carbon/human/scream
	key = "scream"
	key_third_person = "screams"
	message = "screams!"
	audio_cooldown = 10 SECONDS

/datum/emote/living/carbon/human/scream/get_sound(mob/living/user)
	if(isHumanStrict(user))
		if(user.gender == MALE)
			return "male_scream"
		else
			return "female_scream"
	if(isYautja(user))
		return "pred_pain"

/datum/emote/living/carbon/human/chimper
	key = "chimper"
	key_third_person = "chimpers"
	message = "chimpers."

/datum/emote/living/carbon/human/whimper
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

/datum/emote/living/carbon/human/smile
	key = "smile"
	key_third_person = "smiles"
	message = "smiles."

/datum/emote/living/carbon/human/sneeze
	key = "sneeze"
	key_third_person = "sneezes"
	message = "sneezes!"

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

/datum/emote/living/carbon/human/warcry/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()

	user.show_speech_bubble("hwarcry")

/datum/emote/living/carbon/human/warcry/get_sound(mob/living/user)
	if(isHumanSynthStrict(user))
		if(user.gender == MALE)
			return "male_warcry"
		else
			return "female_warcry"

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
