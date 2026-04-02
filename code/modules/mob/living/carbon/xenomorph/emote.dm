/datum/emote/living/carbon/xeno
	mob_type_allowed_typecache = list(/mob/living/carbon/xenomorph)
	mob_type_blacklist_typecache = list(/mob/living/carbon/xenomorph/facehugger, /mob/living/carbon/xenomorph/larva)
	keybind_category = CATEGORY_XENO_EMOTE
	var/predalien_sound
	var/larva_sound

/datum/emote/living/carbon/xeno/get_sound(mob/living/user)
	. = ..()

	if(ispredalien(user) && predalien_sound)
		. = predalien_sound

	if(islarva(user) && larva_sound)
		. = larva_sound

/datum/emote/living/carbon/xeno/growl
	mob_type_blacklist_typecache = list(/mob/living/carbon/xenomorph/hellhound)

	key = "growl"
	message = "growls."
	sound = "alien_growl"
	predalien_sound = 'sound/voice/predalien_growl.ogg'
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/xeno/hiss
	mob_type_blacklist_typecache = list(/mob/living/carbon/xenomorph/hellhound)

	key = "hiss"
	message = "hisses."
	sound = "alien_hiss"
	predalien_sound = 'sound/voice/predalien_hiss.ogg'
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/xeno/needshelp
	mob_type_blacklist_typecache = list(/mob/living/carbon/xenomorph/hellhound)

	key = "needshelp"
	message = "needs help!"
	sound = "alien_help"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/xeno/roar
	mob_type_blacklist_typecache = list(/mob/living/carbon/xenomorph/hellhound)

	key = "roar"
	message = "roars!"
	sound = "alien_roar"
	predalien_sound = 'sound/voice/predalien_roar.ogg'
	larva_sound = "alien_roar_larva"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/xeno/tail
	key = "tail"
	message = "swipes its tail."
	sound = "alien_tail_swipe"

/datum/emote/living/carbon/xeno/hellhound
	mob_type_allowed_typecache = list(/mob/living/carbon/xenomorph/hellhound)
	keybind = FALSE

/datum/emote/living/carbon/xeno/hellhound/roar
	key = "roar"
	message = "roars!"
	sound = 'sound/voice/ed209_20sec.ogg'
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/xeno/hellhound/growl
	key = "growl"
	message = "emits a strange, menacing growl."
	sound = "giant_lizard_growl"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/xeno/hellhound/hiss
	key = "hiss"
	message = "hisses."
	sound = "giant_lizard_hiss"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/xeno/queen/twerk
	key = "tk"
	message = "moves the trunk."
	sound = "alien_roar"
	mob_type_allowed_typecache = list(/mob/living/carbon/xenomorph/queen)
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/xeno/queen/twerk/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	var/mob/living/carbon/xenomorph/queenie = user
	queenie.Stun(3)
	queenie.setDir(NORTH)
	shake_it_up(queenie)

/datum/emote/living/carbon/xeno/queen/twerk/proc/shake_it_up(mob/living/carbon/xenomorph/queenie)
	queenie.icon_state = "twerky"
	queenie.icon_override = TRUE
	sleep(3 SECONDS)
	release_me(queenie)

/datum/emote/living/carbon/xeno/queen/twerk/proc/release_me(mob/living/carbon/xenomorph/queenie)
	queenie.icon_override = FALSE
	queenie.update_icons()
	queenie.setDir(SOUTH)

