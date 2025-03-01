/atom/var/langchat_height = 32 // abovetile usually
/atom/var/langchat_color = "#FFFFFF"
/atom/var/langchat_styles = ""

/mob/living/carbon/xenomorph/langchat_color = "#b491c8"
/mob/living/carbon/xenomorph/carrier/langchat_height = 64
/mob/living/carbon/xenomorph/ravager/langchat_height = 64
/mob/living/carbon/xenomorph/queen/langchat_height = 64
/mob/living/carbon/xenomorph/praetorian/langchat_height = 64
/mob/living/carbon/xenomorph/hivelord/langchat_height = 64
/mob/living/carbon/xenomorph/defender/langchat_height = 48
/mob/living/carbon/xenomorph/warrior/langchat_height = 48
/mob/living/carbon/xenomorph/king/langchat_height = 64

#define LANGCHAT_LONGEST_TEXT 64
#define LANGCHAT_WIDTH 96
#define LANGCHAT_MAX_ALPHA 196

//pop defines
#define LANGCHAT_DEFAULT_POP 0 //normal message
#define LANGCHAT_PANIC_POP 1 //this causes shaking
#define LANGCHAT_FAST_POP 2 //this just makes it go away faster

// params for default pop
#define LANGCHAT_MESSAGE_POP_TIME 3
#define LANGCHAT_MESSAGE_POP_Y_SINK 8

// params for panic pop
#define LANGCHAT_MESSAGE_PANIC_POP_TIME 1
#define LANGCHAT_MESSAGE_PANIC_POP_Y_SINK 8
#define LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE 6
#define LANGCHAT_MESSAGE_PANIC_SHAKE_TIMES 6
#define LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN 1
// params for fast pop
#define LANGCHAT_MESSAGE_FAST_POP_TIME 1
#define LANGCHAT_MESSAGE_FAST_POP_Y_SINK 8

#define langchat_client_enabled(M) (M && M.client && M.client.prefs && !M.client.prefs.lang_chat_disabled)

/atom/var/image/langchat_image
/atom/var/list/mob/langchat_listeners

///Hides the image, if one exists. Do not null the langchat image; it is rotated when the mob is buckled or proned to maintain text orientation.
/atom/proc/langchat_drop_image()
	if(langchat_listeners)
		for(var/mob/M in langchat_listeners)
			if(M.client)
				M.client.images -= langchat_image
	langchat_listeners = null

/atom/proc/get_maxptext_x_offset(image/maptext_image)
	return (world.icon_size / 2) - (maptext_image.maptext_width / 2)
/atom/movable/get_maxptext_x_offset(image/maptext_image)
	return (bound_width / 2) - (maptext_image.maptext_width / 2)
/mob/get_maxptext_x_offset(image/maptext_image)
	return (icon_size / 2) - (maptext_image.maptext_width / 2)

///Creates the image if one does not exist, resets settings that are modified by speech procs.
/atom/proc/langchat_make_image(override_color = null)
	if(!langchat_image)
		langchat_image = image(null, src)
		langchat_image.layer = 20
		langchat_image.plane = RUNECHAT_PLANE
		langchat_image.appearance_flags = NO_CLIENT_COLOR|KEEP_APART|RESET_COLOR|RESET_TRANSFORM
		langchat_image.maptext_y = langchat_height
		langchat_image.maptext_height = 64
		langchat_image.maptext_y -= LANGCHAT_MESSAGE_POP_Y_SINK
		langchat_image.maptext_x = get_maxptext_x_offset(langchat_image)

	langchat_image.pixel_y = 0
	langchat_image.alpha = 0
	langchat_image.color = override_color ? override_color : langchat_color
	if(appearance_flags & PIXEL_SCALE)
		langchat_image.appearance_flags |= PIXEL_SCALE

/mob/langchat_make_image(override_color = null)
	var/new_image = FALSE
	if(!langchat_image)
		new_image = TRUE
	. = ..()
	// Recenter for icons more than 32 wide
	if(new_image)
		langchat_image.maptext_x += (icon_size - 32) / 2

/mob/dead/observer/langchat_make_image(override_color = null)
	if(!override_color)
		override_color = "#c51fb7"
	. = ..()
	langchat_image.appearance_flags |= RESET_ALPHA

/atom/proc/langchat_speech(message, list/listeners, language, override_color, skip_language_check = FALSE, animation_style = LANGCHAT_DEFAULT_POP, list/additional_styles = list("langchat"))
	langchat_drop_image()
	langchat_make_image(override_color)
	var/image/r_icon
	var/use_mob_style = TRUE
	var/text_to_display = message
	if(length(text_to_display) > LANGCHAT_LONGEST_TEXT)
		text_to_display = copytext_char(text_to_display, 1, LANGCHAT_LONGEST_TEXT + 1) + "..."
	var/timer = (length(text_to_display) / LANGCHAT_LONGEST_TEXT) * 4 SECONDS + 2 SECONDS
	if(additional_styles.Find("emote"))
		additional_styles.Remove("emote")
		use_mob_style = FALSE
		r_icon = image('icons/mob/hud/chat_icons.dmi', icon_state = "emote")
	else if(additional_styles.Find("virtual-speaker"))
		additional_styles.Remove("virtual-speaker")
		r_icon = image('icons/mob/hud/chat_icons.dmi', icon_state = "radio")
	if(r_icon)
		text_to_display = "\icon[r_icon]&zwsp;[text_to_display]"
	text_to_display = "<span class='center [additional_styles != null ? additional_styles.Join(" ") : ""] [use_mob_style ? langchat_styles : ""] langchat'>[text_to_display]</span>"

	langchat_image.maptext = text_to_display
	langchat_image.maptext_width = LANGCHAT_WIDTH
	langchat_image.maptext_x = get_maxptext_x_offset(langchat_image)

	langchat_listeners = listeners
	for(var/mob/M in langchat_listeners)
		if(langchat_client_enabled(M) && !M.ear_deaf && (skip_language_check || M.say_understands(src, language)))
			M.client.images += langchat_image

	if(isturf(loc))
		langchat_image.loc = src
	else
		langchat_image.loc = recursive_holder_check(src)

	switch(animation_style)
		if(LANGCHAT_DEFAULT_POP)
			langchat_image.alpha = 0
			animate(langchat_image, pixel_y = langchat_image.pixel_y + LANGCHAT_MESSAGE_POP_Y_SINK, alpha = LANGCHAT_MAX_ALPHA, time = LANGCHAT_MESSAGE_POP_TIME)
		if(LANGCHAT_PANIC_POP)
			langchat_image.alpha = LANGCHAT_MAX_ALPHA
			animate(langchat_image, pixel_y = langchat_image.pixel_y + LANGCHAT_MESSAGE_PANIC_POP_Y_SINK, time = LANGCHAT_MESSAGE_PANIC_POP_TIME)
			animate(pixel_x = langchat_image.pixel_x - LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE, time = LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN, easing = CUBIC_EASING)
			for(var/i = 1 to LANGCHAT_MESSAGE_PANIC_SHAKE_TIMES)
				animate(pixel_x = langchat_image.pixel_x + 2*LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE, time = 2*LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN, easing = CUBIC_EASING)
				animate(pixel_x = langchat_image.pixel_x - 2*LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE, time = LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN, easing = CUBIC_EASING)
			animate(pixel_x = langchat_image.pixel_x + LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE, time = LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN, easing = CUBIC_EASING)
		if(LANGCHAT_FAST_POP)
			langchat_image.alpha = 0
			animate(langchat_image, pixel_y = langchat_image.pixel_y + LANGCHAT_MESSAGE_FAST_POP_Y_SINK, alpha = LANGCHAT_MAX_ALPHA, time = LANGCHAT_MESSAGE_FAST_POP_TIME)

	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, langchat_drop_image), language), timer, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)

/atom/proc/langchat_long_speech(message, list/listeners, language)
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
	langchat_image.maptext_x = get_maxptext_x_offset(langchat_image)

	langchat_listeners = listeners
	for(var/mob/M in langchat_listeners)
		if(langchat_client_enabled(M) && !M.ear_deaf && M.say_understands(src, language))
			M.client.images += langchat_image

	if(isturf(loc))
		langchat_image.loc = src
	else
		langchat_image.loc = recursive_holder_check(src)

	animate(langchat_image, pixel_y = langchat_image.pixel_y + LANGCHAT_MESSAGE_POP_Y_SINK, alpha = LANGCHAT_MAX_ALPHA, time = LANGCHAT_MESSAGE_POP_TIME)
	if(text_left)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, langchat_long_speech), text_left, listeners, language), timer, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_NO_HASH_WAIT)
	else
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, langchat_drop_image), language), timer, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_NO_HASH_WAIT)

/** Displays image to a single listener after it was built above eg. for chaining different game logic than speech code
This does just that, doesn't check deafness or language! Do what you will in that regard **/
/atom/proc/langchat_display_image(mob/M)
	if(langchat_image)
		if(!langchat_client_enabled(M))
			return
		if(!langchat_listeners) // shouldn't happen
			langchat_listeners = list()
		langchat_listeners |= M
		M.client.images += langchat_image
