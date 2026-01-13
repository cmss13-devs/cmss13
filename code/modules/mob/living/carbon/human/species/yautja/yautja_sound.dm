/datum/emote/living/carbon/human/yautja/species_sound
	category = YAUTJA_EMOTE_CATEGORY_SPECIES

/datum/emote/living/carbon/human/yautja/species_sound/click
	key = "click"

/datum/emote/living/carbon/human/yautja/species_sound/click/get_sound(mob/living/user)
	if(rand(0,100) < 50)
		return 'sound/voice/pred_click1.ogg'
	else
		return 'sound/voice/pred_click2.ogg'

/datum/emote/living/carbon/human/yautja/species_sound/click2
	key = "click2"

/datum/emote/living/carbon/human/yautja/species_sound/click2/get_sound(mob/living/user)
	return pick('sound/voice/pred_click3.ogg', 'sound/voice/pred_click4.ogg')

/datum/emote/living/carbon/human/yautja/species_sound/predgrowl
	key = "growl"
	sound = 'sound/voice/predgrowl.ogg'
	message = "growls!"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

// Laughing Emotes
/datum/emote/living/carbon/human/yautja/species_sound/laugh1
	key = "laugh1"
	message = "laughs!"
	sound = 'sound/voice/pred_laugh1.ogg'
	volume = 25

/datum/emote/living/carbon/human/yautja/species_sound/laugh2
	key = "laugh2"
	message = "laughs!"
	sound = 'sound/voice/pred_laugh2.ogg'
	volume = 25

/datum/emote/living/carbon/human/yautja/species_sound/laugh3
	key = "laugh3"
	message = "laughs!"
	sound = 'sound/voice/pred_laugh3.ogg'
	volume = 25

/datum/emote/living/carbon/human/yautja/species_sound/laugh4
	key = "laugh4"
	message = "laughs!"
	sound = 'sound/voice/pred_laugh4.ogg'
	volume = 25

/datum/emote/living/carbon/human/yautja/species_sound/laugh5
	key = "laugh5"
	message = "laughs!"
	sound = 'sound/voice/pred_laugh5.ogg'
	volume = 25

/datum/emote/living/carbon/human/yautja/species_sound/laugh6
	key = "laugh6"
	message = "laughs!"
	sound = 'sound/voice/pred_laugh6.ogg'
	volume = 25

// Roar Emotes
/datum/emote/living/carbon/human/yautja/species_sound/roar
	key = "roar"
	message = "roars!"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/yautja/species_sound/roar/get_sound(mob/living/user)
	return pick('sound/voice/pred_roar1.ogg', 'sound/voice/pred_roar2.ogg')

/datum/emote/living/carbon/human/yautja/species_sound/roar2
	key = "roar2"
	sound = 'sound/voice/pred_roar3.ogg'
	message = "roars!"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/yautja/species_sound/loudroar
	key = "loudroar"
	message = "roars loudly!"
	volume = 60
	cooldown = 120 SECONDS
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	no_panel = TRUE

/datum/emote/living/carbon/human/yautja/species_sound/loudroar/get_sound(mob/living/user)
	return pick('sound/voice/pred_roar4.ogg', 'sound/voice/pred_roar5.ogg', 'sound/voice/pred_roar6.ogg')

/datum/emote/living/carbon/human/yautja/species_sound/loudroar/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return

	for(var/mob/current_mob as anything in get_mobs_in_z_level_range(get_turf(user), 18) - user)
		var/relative_dir = Get_Compass_Dir(current_mob, user)
		var/final_dir = dir2text(relative_dir)
		to_chat(current_mob, SPAN_HIGHDANGER("You hear a loud roar coming from [final_dir ? "the [final_dir]" : "nearby"]!"))
