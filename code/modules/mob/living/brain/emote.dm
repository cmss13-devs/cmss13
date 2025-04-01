/datum/emote/living/brain
	mob_type_allowed_typecache = list(/mob/living/brain)
	keybind = FALSE

/datum/emote/brain/can_run_emote(mob/user, status_check = TRUE, intentional = FALSE)
	. = ..()
	var/mob/living/brain/brain_user = user
	if(!istype(brain_user) || (!(brain_user.container && istype(brain_user.container, /obj/item/device/mmi))))
		return FALSE

/datum/emote/living/brain/alarm
	key = "alarm"
	message = "sounds an alarm."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/brain/alert
	key = "alert"
	message = "lets out a distressed noise."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/brain/notice
	key = "notice"
	message = "plays a loud tone."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/brain/flash
	key = "flash"
	message = "light's flash quickly!"

/datum/emote/living/brain/blink
	key = "blink"
	message = "blinks."

/datum/emote/living/brain/whistle
	key = "whistle"
	message = "whistles."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/brain/beep
	key = "beep"
	message = "beeps."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/brain/boop
	key = "boop"
	message = "boops."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
