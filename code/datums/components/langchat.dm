/// Component applied to an atom to handle displaying a Langchat image
/// How this works:
///  * Code AddComponent this to an atom with relevant information
///  * We don't do anything. We schedule to SSlangchat. Generating the image is expensive!
///  * SSlangchat quickly picks it up and we can generate the image on SS time.
///  * We keep displaying the rest of the message on SS time.
/datum/component/langchat_image
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/state = LANGCHAT_IMAGE_STATE_INIT

	// === GENERAL CONFIGURATION BELOW
	var/list/default_styles = list("langchat")
	var/default_color = "#FFFFFF"
	var/langchat_height = 32

	// === MESSAGE CONFIGURATION BELOW

	/// Listeners we're currently sending the message to
	/// Note that we don't hook cleanup to this.
	/// Instead we enforce GC simply by deleting everything after a while
	var/list/mob/langchat_listeners

	/// MessageS to be sent, as a list
	var/list/messages

	var/message_flags = NO_FLAGS
	var/list/additional_styles
	var/animation_style = LANGCHAT_DEFAULT_POP
	var/override_color
	var/datum/language/language

	// === RUNTIME DATA BELOW

	var/image/langchat_image
	var/image/langchat_scrambled_image
	var/reset_in = 0 //! How long before we force reset
	var/next_in = 0 //! How long before we display next message


/datum/component/langchat_image/Initialize()
	. = ..()
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	var/list/arguments = args.Copy()
	arguments.Insert(1, src, TRUE)
	InheritComponent(arglist(arguments))
	state = LANGCHAT_IMAGE_STATE_READY

/datum/component/langchat_image/Destroy()
	. = ..()
	reset()
	messages = null
	langchat_listeners = null
	langchat_image?.loc = null
	langchat_image = null
	langchat_scrambled_image?.loc = null
	langchat_scrambled_image = null
	STOP_PROCESSING(SSlangchat, src)

/datum/component/langchat_image/InheritComponent(datum/component/C, i_am_original, langchat_height, default_color, list/default_styles)
	. = ..()
	if(langchat_height)
		src.langchat_height = langchat_height
	if(default_color)
		src.default_color = default_color
	if(!isnull(default_styles))
		src.default_styles = default_styles.Copy()

/datum/component/langchat_image/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_LANGCHAT_SEND_MESSAGE, PROC_REF(send_message))
	RegisterSignal(parent, COMSIG_ATOM_LANGCHAT_SEEN_BY_MOB, PROC_REF(display_image))

/datum/component/langchat_image/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_ATOM_LANGCHAT_SEND_MESSAGE)
	UnregisterSignal(parent, COMSIG_ATOM_LANGCHAT_SEEN_BY_MOB)

/datum/component/langchat_image/process(delta_time)
	if((reset_in > 0) && (reset_in -= (delta_time * 10)) <= 0)
		reset() // This is a safety net, not the intended reset method
		return

	while(TRUE) // It's that or a full blown subsystem for proper pausing
		if(TICK_CHECK) // We have subsystems at home, see? Just as MSO intended.
			return
		switch(state) // We segment the workload so we can pause between each bit. It turns out to be very expensive and cause overtime otherwise.
			if(LANGCHAT_IMAGE_STATE_CONFIGURED)
				langchat_make_image()
				prepare()
				// State changes are here on purpose. If the proc crashes this will cause further crashes, but it's guaranteed not to infinite-loop us.
				state = LANGCHAT_IMAGE_STATE_INSTANTIATED

			if(LANGCHAT_IMAGE_STATE_INSTANTIATED)
				start()
				state = LANGCHAT_IMAGE_STATE_DISPLAYING

			if(LANGCHAT_IMAGE_STATE_DISPLAYING)
				if(next_in)
					next_in -= (delta_time * 10)
				if(next_in <= 0)
					if(length(messages))
						state = LANGCHAT_IMAGE_STATE_CONFIGURED // rerun this with next message on next tick!
						message_flags |= LANGCHAT_IMAGE_CONTINUING
						next_in = 4 SECONDS
					else
						reset()
				return // Return enough time and reset at start of proc will happen

			else // We shouldn't be here
				STOP_PROCESSING(SSlangchat, src)
				return



/datum/component/langchat_image/proc/send_message(datum/self, message, flags = NO_FLAGS, list/listeners, animation_style = LANGCHAT_DEFAULT_POP, list/additional_styles = list("langchat"), datum/language/language, override_color)
	SIGNAL_HANDLER
	if(length(langchat_listeners))
		reset() // In case we already had something running

	src.animation_style = animation_style
	src.additional_styles = additional_styles
	src.language = language
	src.override_color = override_color
	message_flags = flags

	if(message)
		messages = list() // Or don't and update reset_in/next_in, and you can queue messages! Neat, no? No, nobody cares.
		var/lifetime = cut_text(message)
		if(!lifetime)
			return
		reset_in = lifetime * 2 // Safety net
		if(length(messages) > 1)
			next_in = 6 SECONDS

	langchat_listeners = listeners // We're scheduled now due to changing state, so refs won't stay around
	START_PROCESSING(SSlangchat, src)
	state = LANGCHAT_IMAGE_STATE_CONFIGURED


///Creates the image if one does not exist, resets settings that are modified by speech procs.
/datum/component/langchat_image/proc/langchat_make_image(override_color)
	var/atom/parent_atom = parent
	var/icon_x_size = parent_atom.get_icon_x_size()

	if(!langchat_image)
		langchat_image = image(null, parent_atom)
		langchat_image.layer = 20
		langchat_image.plane = RUNECHAT_PLANE
		langchat_image.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
		langchat_image.maptext_y = langchat_height - LANGCHAT_MESSAGE_POP_Y_SINK
		langchat_image.maptext_height = 64
		langchat_image.maptext_x = (icon_x_size / 2) - (langchat_image.maptext_width / 2)

	if(!langchat_scrambled_image)
		langchat_scrambled_image = image(null, parent_atom)
		langchat_scrambled_image.layer = 20
		langchat_scrambled_image.plane = RUNECHAT_PLANE
		langchat_scrambled_image.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
		langchat_scrambled_image.maptext_y = langchat_height - LANGCHAT_MESSAGE_POP_Y_SINK
		langchat_scrambled_image.maptext_height = 64
		langchat_scrambled_image.maptext_x = (icon_x_size / 2) - (langchat_scrambled_image.maptext_width / 2)

	langchat_image.pixel_x = 0
	langchat_image.pixel_y = 0
	langchat_image.alpha = 0
	langchat_image.color = override_color ? override_color : default_color

	langchat_scrambled_image.pixel_x = 0
	langchat_scrambled_image.pixel_y = 0
	langchat_scrambled_image.alpha = 0
	langchat_scrambled_image.color = override_color ? override_color : default_color

	if(parent_atom.appearance_flags & PIXEL_SCALE)
		langchat_image.appearance_flags |= PIXEL_SCALE
		langchat_scrambled_image.appearance_flags |= PIXEL_SCALE

/datum/component/langchat_image/proc/prepare()
	var/atom/parent_atom = parent

	var/message = popleft(messages)
	var/text_to_display = message
	if(message_flags & LANGCHAT_IMAGE_CONTINUING)
		text_to_display = "...[text_to_display]"
	if((message_flags & LANGCHAT_IMAGE_MULTIPART) && length(messages))
		text_to_display = "[text_to_display]..."

	var/use_mob_style = TRUE
	var/image/r_icon
	if(message_flags & LANGCHAT_IMAGE_IS_EMOTE)
		use_mob_style = FALSE
		r_icon = image('icons/mob/hud/chat_icons.dmi', icon_state = "emote")
	else if(message_flags & LANGCHAT_IMAGE_IS_RADIO)
		r_icon = image('icons/mob/hud/chat_icons.dmi', icon_state = "radio")
	if(r_icon)
		text_to_display = "\icon[r_icon]&zwsp;[text_to_display]"
	text_to_display = "<span class='center [additional_styles ? additional_styles.Join(" ") : ""] [use_mob_style ? default_styles?.Join(" ") : ""] langchat'>[text_to_display]</span>"

	var/icon_x_size = parent_atom.get_icon_x_size()
	var/width = (message_flags & LANGCHAT_IMAGE_MULTIPART) ? LANGCHAT_WIDTH * 2 : LANGCHAT_WIDTH
	langchat_image.maptext = text_to_display
	langchat_image.maptext_width = width
	langchat_image.maptext_x = (icon_x_size / 2) - (langchat_image.maptext_width / 2)

	if(!(message_flags & LANGCHAT_IMAGE_IGNORE_LANG) && !(message_flags & LANGCHAT_IMAGE_NO_SCRAMBLE) && language && !islist(language))
		var/scrambled_text = language.scramble(text_to_display)
		if(r_icon)
			scrambled_text = "\icon[r_icon]&zwsp;[scrambled_text]"
		scrambled_text = "<span class='center [additional_styles ? additional_styles.Join(" ") : ""] [use_mob_style ? default_styles?.Join(" ") : ""] langchat'>[scrambled_text]</span>"
		langchat_scrambled_image.maptext = scrambled_text
		langchat_scrambled_image.maptext_width = width
		langchat_scrambled_image.maptext_x = (icon_x_size / 2) - (langchat_scrambled_image.maptext_width / 2)

	// Put it on the map
	if(parent_atom.z)
		langchat_image.loc = parent_atom
		langchat_scrambled_image.loc = parent_atom
	else
		langchat_image.loc = recursive_holder_check(parent_atom)
		langchat_scrambled_image.loc = langchat_image.loc

	// Display to everyone involved
	for(var/mob/player as anything in langchat_listeners)
		if(langchat_client_enabled(player) && ((message_flags & LANGCHAT_IMAGE_IS_EMOTE) || !player.ear_deaf))
			if((message_flags & LANGCHAT_IMAGE_IGNORE_LANG) || player.say_understands(parent_atom, language))
				player.client.images += langchat_image
			else if(!(message_flags & LANGCHAT_IMAGE_NO_SCRAMBLE) && language && !islist(language))
				player.client.images += langchat_scrambled_image

/datum/component/langchat_image/proc/start()
	var/atom/parent_atom = parent

	// Now ANIMATE
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

	// reset_in should already be set so we have nothing more to do!

/datum/component/langchat_image/proc/reset()
	log_debug("\ref[src] called reset")
	if(langchat_listeners)
		for(var/mob/player as anything in langchat_listeners)
			player.client?.images -= langchat_image
			player.client?.images -= langchat_scrambled_image
		langchat_listeners.Cut()
	message_flags = NO_FLAGS
	STOP_PROCESSING(SSlangchat, src)
	state = LANGCHAT_IMAGE_STATE_READY

/datum/component/langchat_image/proc/cut_text(message)
	var/lifetime = 2 SECONDS
	if(message_flags & LANGCHAT_IMAGE_MULTIPART)
		var/chunk_size = LANGCHAT_LONGEST_TEXT - 5
		var/chunks = round(length(message) / chunk_size, 1)
		if(chunks <= 1)
			messages += message
			lifetime += (length(message) / LANGCHAT_LONGEST_TEXT) * 4 SECONDS
		else
			for(var/i in 1 to chunks)
				messages += copytext_char(message, (i-1)*chunk_size+1, i*chunk_size+1)
				lifetime += 4 SECONDS
	else
		message = copytext_char(message, 1, LANGCHAT_LONGEST_TEXT)
		lifetime += (length(message) / LANGCHAT_LONGEST_TEXT) * 4 SECONDS
		messages += message
	return lifetime

/** Displays image to a single listener after it was built above eg. for chaining different game logic than speech code
This does just that, doesn't check deafness or language! Do what you will in that regard **/
/datum/component/langchat_image/proc/display_image(datum/self, mob/player)
	SIGNAL_HANDLER
	if(langchat_image)
		if(!langchat_client_enabled(player))
			return
		if(!langchat_listeners) // shouldn't happen
			langchat_listeners = list()
		langchat_listeners |= player
		player.client.images += langchat_image


// ==========

/atom/proc/get_icon_x_size(image/maptext_image)
	return world.icon_size
/atom/movable/get_icon_x_size(image/maptext_image)
	return bound_width
/mob/get_icon_x_size(image/maptext_image)
	return icon_size
