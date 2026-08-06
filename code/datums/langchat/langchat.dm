/mob/living/carbon/xenomorph/var/langchat_height = 32
/mob/living/carbon/xenomorph/carrier/langchat_height = 64
/mob/living/carbon/xenomorph/ravager/langchat_height = 64
/mob/living/carbon/xenomorph/queen/langchat_height = 64
/mob/living/carbon/xenomorph/praetorian/langchat_height = 64
/mob/living/carbon/xenomorph/hivelord/langchat_height = 64
/mob/living/carbon/xenomorph/defender/langchat_height = 48
/mob/living/carbon/xenomorph/warrior/langchat_height = 48
/mob/living/carbon/xenomorph/king/langchat_height = 64
/mob/living/carbon/xenomorph/despoiler/langchat_height = 64

/atom/proc/langchat_send_message(message, flags = NO_FLAGS, list/listeners, animation_style = LANGCHAT_DEFAULT_POP, list/additional_styles = list("langchat"), datum/language/language, override_color)
	AddComponent(/datum/component/langchat_image) // In case it wasn't done yet
	SEND_SIGNAL(src, COMSIG_ATOM_LANGCHAT_SEND_MESSAGE, message, flags, listeners, animation_style, additional_styles, language, override_color)

/atom/proc/langchat_display_image(mob/player)
	SEND_SIGNAL(src, COMSIG_ATOM_LANGCHAT_SEEN_BY_MOB, player)
