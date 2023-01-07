/datum/emote/living/carbon/human/yautja
	species_type_allowed_typecache = list(/datum/species/yautja)
	keybind_category = CATEGORY_YAUTJA_EMOTE

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
	sound = "male_scream"

/datum/emote/living/carbon/human/yautja/femalescream
	key = "femalescream"
	emote_type = EMOTE_AUDIBLE
	sound = "female_scream"

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
