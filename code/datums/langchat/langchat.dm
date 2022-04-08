/mob/var/langchat_height = 32 // abovetile usually
/mob/var/langchat_color = "#FFFFFF"
/mob/var/langchat_styles = ""

/mob/living/carbon/Xenomorph/langchat_color = "#b491c8"
/mob/living/carbon/Xenomorph/Carrier/langchat_height = 64
/mob/living/carbon/Xenomorph/Ravager/langchat_height = 64
/mob/living/carbon/Xenomorph/Queen/langchat_height = 64
/mob/living/carbon/Xenomorph/Praetorian/langchat_height = 64
/mob/living/carbon/Xenomorph/Hivelord/langchat_height = 64
/mob/living/carbon/Xenomorph/Defender/langchat_height = 48
/mob/living/carbon/Xenomorph/Warrior/langchat_height = 48

#define LANGCHAT_LONGEST_TEXT 64
#define LANGCHAT_WIDTH 96
#define LANGCHAT_X_OFFSET -32
#define LANGCHAT_MAX_ALPHA 196

// params for default pop
#define LANGCHAT_MESSAGE_POP_TIME 3
#define LANGCHAT_MESSAGE_POP_Y_SINK 8

#define langchat_client_enabled(M) (M && M.client && M.client.prefs && !M.client.prefs.lang_chat_disabled)

/mob/var/image/langchat_image
/mob/var/list/mob/langchat_listeners

///Hides the image, if one exists. Do not null the langchat image; it is rotated when the mob is buckled or proned to maintain text orientation.
/mob/proc/langchat_drop_image()
	if(langchat_listeners)
		for(var/mob/M in langchat_listeners)
			if(M.client)
				M.client.images -= langchat_image
	langchat_listeners = null

///Creates the image if one does not exist, resets settings that are modified by speech procs.
/mob/proc/langchat_make_image(var/override_color = null)
	if(!langchat_image)
		langchat_image = image(null, src)
		langchat_image.layer = 20
		langchat_image.plane = RUNECHAT_PLANE
		langchat_image.appearance_flags = NO_CLIENT_COLOR|KEEP_APART|RESET_COLOR
		langchat_image.maptext_y = langchat_height
		langchat_image.maptext_height = 64
		langchat_image.maptext_x = LANGCHAT_X_OFFSET
		langchat_image.maptext_y -= LANGCHAT_MESSAGE_POP_Y_SINK

	langchat_image.pixel_y = 0
	langchat_image.alpha = 0
	langchat_image.color = override_color ? override_color : langchat_color
	if(appearance_flags & PIXEL_SCALE)
		langchat_image.appearance_flags |= PIXEL_SCALE

/mob/proc/langchat_speech(message, var/list/listeners, language, var/override_color, var/skip_language_check = FALSE)
	langchat_drop_image()
	langchat_make_image(override_color)

	var/text_to_display = message
	if(length(text_to_display) > LANGCHAT_LONGEST_TEXT)
		text_to_display = copytext_char(text_to_display, 1, LANGCHAT_LONGEST_TEXT + 1) + "..."
	var/timer = (length(text_to_display) / LANGCHAT_LONGEST_TEXT) * 4 SECONDS + 2 SECONDS
	text_to_display = "<span class='center [langchat_styles] langchat'>[text_to_display]</span>"

	langchat_image.maptext = text_to_display
	langchat_image.maptext_width = LANGCHAT_WIDTH

	langchat_listeners = listeners
	for(var/mob/M in langchat_listeners)
		if(langchat_client_enabled(M) && !M.ear_deaf && (skip_language_check || M.say_understands(src, language)))
			M.client.images += langchat_image

	animate(langchat_image, pixel_y = langchat_image.pixel_y + LANGCHAT_MESSAGE_POP_Y_SINK, alpha = LANGCHAT_MAX_ALPHA, time = LANGCHAT_MESSAGE_POP_TIME)
	addtimer(CALLBACK(src, /mob.proc/langchat_drop_image, language), timer, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)

/mob/proc/langchat_long_speech(message, var/list/listeners, language)
	langchat_drop_image()
	langchat_make_image()

	var/text_left = null
	var/text_to_display = message

	if(length(message) > LANGCHAT_LONGEST_TEXT)
		text_to_display = copytext_char(message, 1, LANGCHAT_LONGEST_TEXT - 5) + "..."
		text_left = "..." + copytext_char(message, LANGCHAT_LONGEST_TEXT - 5)
	var/timer = 6 SECONDS
	if(text_left)
		timer = 4 SECONDS
	text_to_display = "<span class='center [langchat_styles] langchat_announce langchat'>[text_to_display]</span>"

	langchat_image.maptext = text_to_display
	langchat_image.maptext_width = LANGCHAT_WIDTH * 2

	langchat_listeners = listeners
	for(var/mob/M in langchat_listeners)
		if(langchat_client_enabled(M) && !M.ear_deaf && M.say_understands(src, language))
			M.client.images += langchat_image

	animate(langchat_image, pixel_y = langchat_image.pixel_y + LANGCHAT_MESSAGE_POP_Y_SINK, alpha = LANGCHAT_MAX_ALPHA, time = LANGCHAT_MESSAGE_POP_TIME)
	if(text_left)
		addtimer(CALLBACK(src, /mob.proc/langchat_long_speech, text_left, listeners, language), timer, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_NO_HASH_WAIT)
	else
		addtimer(CALLBACK(src, /mob.proc/langchat_drop_image, language), timer, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_NO_HASH_WAIT)

/** Displays image to a single listener after it was built above eg. for chaining different game logic than speech code
This does just that, doesn't check deafness or language! Do what you will in that regard **/
/mob/proc/langchat_display_image(var/mob/M)
	if(langchat_image)
		if(!langchat_client_enabled(M))
			return
		if(!langchat_listeners) // shouldn't happen
			langchat_listeners = list()
		langchat_listeners |= M
		M.client.images += langchat_image
