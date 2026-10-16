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
	sound = SOUND_ALIEN_GROWL
	predalien_sound = 'sound/voice/predalien_growl.ogg'
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/xeno/hiss
	mob_type_blacklist_typecache = list(/mob/living/carbon/xenomorph/hellhound)

	key = "hiss"
	message = "hisses."
	sound = SOUND_ALIEN_HISS
	predalien_sound = 'sound/voice/predalien_hiss.ogg'
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/xeno/needshelp
	mob_type_blacklist_typecache = list(/mob/living/carbon/xenomorph/hellhound)

	key = "needshelp"
	message = "needs help!"
	sound = SOUND_ALIEN_HELP
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/xeno/roar
	mob_type_blacklist_typecache = list(/mob/living/carbon/xenomorph/hellhound)

	key = "roar"
	message = "roars!"
	sound = SOUND_ALIEN_ROAR
	predalien_sound = 'sound/voice/predalien_roar.ogg'
	larva_sound = SOUND_ALIEN_ROAR_LARVA
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/xeno/tail
	key = "tail"
	message = "swipes its tail."
	sound = SOUND_ALIEN_TAIL_SWIPE

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
	sound = SOUND_GIANT_LIZARD_GROWL
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/xeno/hellhound/hiss
	key = "hiss"
	message = "hisses."
	sound = SOUND_GIANT_LIZARD_HISS
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
