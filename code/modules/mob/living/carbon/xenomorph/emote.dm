/datum/emote/living/carbon/xeno
	mob_type_allowed_typecache = list(/mob/living/carbon/Xenomorph)
	var/predalien_sound

/datum/emote/living/carbon/xeno/get_sound(mob/living/user)
	. = ..()

	if(isXenoPredalien(user))
		. = predalien_sound

/datum/emote/living/carbon/xeno/growl
	key = "growl"
	message = "growls."
	sound = "alien_growl"
	predalien_sound = 'sound/voice/predalien_growl.ogg'

/datum/emote/living/carbon/xeno/hiss
	key = "hiss"
	message = "hisses."
	sound = "alien_hiss"
	predalien_sound = 'sound/voice/predalien_hiss.ogg'

/datum/emote/living/carbon/xeno/needshelp
	key = "needshelp"
	message = "needs help!"

/datum/emote/living/carbon/xeno/roar
	key = "roar"
	message = "roars!"
	sound = "alien_roar"
	predalien_sound = 'sound/voice/predalien_roar.ogg'

/datum/emote/living/carbon/xeno/tail
	key = "tail"
	message = "swipes its tail."
	sound = "alien_tail_swipe"
