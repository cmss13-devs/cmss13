/*
/atom/var/langchat_height = 32 // abovetile usually
/atom/var/langchat_color = "#FFFFFF"
/atom/var/langchat_styles = ""
*/

// /mob/living/carbon/xenomorph/langchat_color = "#b491c8"

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




/*

/atom/var/image/langchat_image
/// text scrambled due to mismatching of language, handled in language.dm
/atom/var/image/langchat_scrambled_image
/atom/var/list/mob/langchat_listeners

*/


/*
/mob/langchat_make_image(override_color = null)
	var/new_image = FALSE
	if(!langchat_image)
		new_image = TRUE
	. = ..()
	// Recenter for icons more than 32 wide
	if(new_image)
		langchat_image.maptext_x += (icon_size - 32) / 2
		langchat_scrambled_image.maptext_x += (icon_size - 32) / 2

/mob/dead/observer/langchat_make_image(override_color = null)
	if(!override_color)
		override_color = "#c51fb7"
	. = ..()
	langchat_image.appearance_flags |= RESET_ALPHA
	langchat_scrambled_image.appearance_flags |= RESET_ALPHA
*/

/*
/atom/proc/langchat_speech(message, list/listeners, datum/language/language, override_color, skip_language_check = FALSE, animation_style = LANGCHAT_DEFAULT_POP, list/additional_styles = list("langchat"), scramble_message = TRUE, split_long_messages = FALSE)
	langchat_drop_image()
	langchat_make_image(override_color)
	var/image/r_icon
	var/use_mob_style = TRUE
	var/text_left = null
	var/text_to_display = message
	var/is_emote = additional_styles && additional_styles.Find("emote")
	var/icon_x_size = get_icon_x_size()

	if(split_long_messages)
		if(length(message) > LANGCHAT_LONGEST_TEXT)
			text_to_display = copytext_char(message, 1, LANGCHAT_LONGEST_TEXT - 5) + "..."
			text_left = "..." + copytext_char(message, LANGCHAT_LONGEST_TEXT - 5)
	else if(length(text_to_display) > LANGCHAT_LONGEST_TEXT)
		text_to_display = copytext_char(text_to_display, 1, LANGCHAT_LONGEST_TEXT + 1) + "..."

	var/timer
	if(split_long_messages)
		timer = 6 SECONDS
		if(text_left)
			timer = 4 SECONDS
	else
		timer = (length(text_to_display) / LANGCHAT_LONGEST_TEXT) * 4 SECONDS + 2 SECONDS

	if(additional_styles.Find("emote"))
		additional_styles.Remove("emote")
		use_mob_style = FALSE
		r_icon = image('icons/mob/hud/chat_icons.dmi', icon_state = "emote")
	else if(additional_styles.Find("virtual-speaker"))
		additional_styles.Remove("virtual-speaker")
		r_icon = image('icons/mob/hud/chat_icons.dmi', icon_state = "radio")
	if(r_icon)
		text_to_display = "\icon[r_icon]&zwsp;[text_to_display]"
	text_to_display = "<span class='center [additional_styles ? additional_styles.Join(" ") : ""] [use_mob_style ? langchat_styles : ""] langchat'>[text_to_display]</span>"

	var/width = split_long_messages ? LANGCHAT_WIDTH * 2 : LANGCHAT_WIDTH // i guess

	langchat_image.maptext = text_to_display
	langchat_image.maptext_width = width
	langchat_image.maptext_x = (icon_x_size / 2) - (langchat_image.maptext_width / 2)

	/*
	!islist language checked to avoid runtimes involving glob.all_languages,
	ideally calls with glob.all_languages as its argument should have scramble_message = FALSE
	but i cba to go through every proc for it
	at the same time, skip_language_check is semi redundant if the proc is called with glob.all_languages as well
	but there might be some niche usage for that, so its not removed either
	but generally you do not need to call skip_language check if you are calling with glob.all_languages anyway
	with that said, just in case mostly, skip_language_check does prevent the generation of scrambled_text to be slightly performant
	- nihi
	*/

	if(!skip_language_check && scramble_message && language && !islist(language))
		var/scrambled_text = language.scramble(message)
		if(split_long_messages)
			if(length(scrambled_text) > LANGCHAT_LONGEST_TEXT)
				scrambled_text = copytext_char(scrambled_text, 1, LANGCHAT_LONGEST_TEXT - 5) + "..."
		else if(length(scrambled_text) > LANGCHAT_LONGEST_TEXT)
			scrambled_text = copytext_char(scrambled_text, 1, LANGCHAT_LONGEST_TEXT + 1) + "..."
		if(r_icon)
			scrambled_text = "\icon[r_icon]&zwsp;[scrambled_text]"
		scrambled_text = "<span class='center [additional_styles != null ? additional_styles.Join(" ") : ""] [use_mob_style ? langchat_styles : ""] langchat'>[scrambled_text]</span>"
		langchat_scrambled_image.maptext = scrambled_text
		langchat_scrambled_image.maptext_width = width
		langchat_scrambled_image.maptext_x = (icon_x_size / 2) - (langchat_scrambled_image.maptext_width / 2)

	langchat_listeners = listeners
	for(var/mob/player in langchat_listeners)
		if(langchat_client_enabled(player) && (is_emote || !player.ear_deaf))
			if(skip_language_check || player.say_understands(src, language))
				player.client.images += langchat_image
			else if(scramble_message && language && !islist(language))
				player.client.images += langchat_scrambled_image

	if(z)
		langchat_image.loc = src
		langchat_scrambled_image.loc = src
	else
		langchat_image.loc = recursive_holder_check(src)
		langchat_scrambled_image.loc = langchat_image.loc

	switch(animation_style)
		if(LANGCHAT_DEFAULT_POP)
			langchat_image.alpha = 0
			animate(langchat_image, pixel_y = langchat_image.pixel_y + LANGCHAT_MESSAGE_POP_Y_SINK, alpha = LANGCHAT_MAX_ALPHA, time = LANGCHAT_MESSAGE_POP_TIME)

			langchat_scrambled_image.alpha = 0
			animate(langchat_scrambled_image, pixel_y = langchat_scrambled_image.pixel_y + LANGCHAT_MESSAGE_POP_Y_SINK, alpha = LANGCHAT_MAX_ALPHA, time = LANGCHAT_MESSAGE_POP_TIME)

		if(LANGCHAT_PANIC_POP)
			langchat_image.alpha = LANGCHAT_MAX_ALPHA
			animate(langchat_image, pixel_y = langchat_image.pixel_y + LANGCHAT_MESSAGE_PANIC_POP_Y_SINK, time = LANGCHAT_MESSAGE_PANIC_POP_TIME)
			animate(pixel_x = langchat_image.pixel_x - LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE, time = LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN, easing = CUBIC_EASING)
			for(var/i = 1 to LANGCHAT_MESSAGE_PANIC_SHAKE_TIMES)
				animate(pixel_x = langchat_image.pixel_x + 2*LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE, time = 2*LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN, easing = CUBIC_EASING)
				animate(pixel_x = langchat_image.pixel_x - 2*LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE, time = LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN, easing = CUBIC_EASING)
			animate(pixel_x = langchat_image.pixel_x + LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE, time = LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN, easing = CUBIC_EASING)

			langchat_scrambled_image.alpha = LANGCHAT_MAX_ALPHA
			animate(langchat_scrambled_image, pixel_y = langchat_scrambled_image.pixel_y + LANGCHAT_MESSAGE_PANIC_POP_Y_SINK, time = LANGCHAT_MESSAGE_PANIC_POP_TIME)
			animate(pixel_x = langchat_scrambled_image.pixel_x - LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE, time = LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN, easing = CUBIC_EASING)
			for(var/i = 1 to LANGCHAT_MESSAGE_PANIC_SHAKE_TIMES)
				animate(pixel_x = langchat_scrambled_image.pixel_x + 2*LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE, time = 2*LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN, easing = CUBIC_EASING)
				animate(pixel_x = langchat_scrambled_image.pixel_x - 2*LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE, time = LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN, easing = CUBIC_EASING)
			animate(pixel_x = langchat_scrambled_image.pixel_x + LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE, time = LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN, easing = CUBIC_EASING)

		if(LANGCHAT_FAST_POP)
			langchat_image.alpha = 0
			animate(langchat_image, pixel_y = langchat_image.pixel_y + LANGCHAT_MESSAGE_FAST_POP_Y_SINK, alpha = LANGCHAT_MAX_ALPHA, time = LANGCHAT_MESSAGE_FAST_POP_TIME)

			langchat_scrambled_image.alpha = 0
			animate(langchat_scrambled_image, pixel_y = langchat_scrambled_image.pixel_y + LANGCHAT_MESSAGE_FAST_POP_Y_SINK, alpha = LANGCHAT_MAX_ALPHA, time = LANGCHAT_MESSAGE_FAST_POP_TIME)

	if(text_left)
		addtimer(CALLBACK(src, PROC_REF(langchat_speech), text_left, listeners, language, override_color, skip_language_check, animation_style, additional_styles, scramble_message, split_long_messages), timer, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_NO_HASH_WAIT)
	else
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, langchat_drop_image), language), timer, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)

/** Displays image to a single listener after it was built above eg. for chaining different game logic than speech code
This does just that, doesn't check deafness or language! Do what you will in that regard **/
/atom/proc/langchat_display_image(mob/player)
	if(langchat_image)
		if(!langchat_client_enabled(player))
			return
		if(!langchat_listeners) // shouldn't happen
			langchat_listeners = list()
		langchat_listeners |= player
		player.client.images += langchat_image
*/

/atom/proc/langchat_display_image(mob/player)
	SEND_SIGNAL(src, COMSIG_ATOM_LANGCHAT_SEEN_BY_MOB, player)
