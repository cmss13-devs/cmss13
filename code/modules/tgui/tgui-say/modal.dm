/** Assigned say modal of the client */
/client/var/datum/tgui_say/tgui_say

// SS220 START TGUI CHAT EADDICTION
#define LIVING_TYPE_HUMAN "human"
#define LIVING_TYPE_XENO "xeno"
#define LIVING_TYPE_SYNTH "synth"
#define LIVING_TYPE_YAUTJA "yautja"
// SS220 END TGUI CHAT EADDICTION

/**
 * Creates a JSON encoded message to open TGUI say modals properly.
 *
 * Arguments:
 * channel - The channel to open the modal in.
 * Returns:
 * string - A JSON encoded message to open the modal.
 */
/client/proc/tgui_say_create_open_command(channel)
	// SS220 START TGUI CHAT EADDICTION
	// var/message = TGUI_CREATE_OPEN_MESSAGE(channel)
	var/message = TGUI_CREATE_MESSAGE("open", list(
		"channel" = channel,
	))
	// SS220 END TGUI CHAT EADDICTION

	return "\".output tgui_say.browser:update [message]\""

/**
 * The tgui say modal. This initializes an input window which hides until
 * the user presses one of the speech hotkeys. Once something is entered, it will
 * delegate the speech to the proper channel.
 */
/datum/tgui_say
	/// The user who opened the window
	var/client/client
	/// Injury phrases to blurt out
	var/list/hurt_phrases = list("ГХА!", "ГРХ!", "УГХ!", "АРГХ!", "АУ!", "МГХ!", "АХХ!") // SS220 TGUI CHAT EADDICTION
	/// Max message length
	var/max_length = MAX_MESSAGE_LEN
	/// The modal window
	var/datum/tgui_window/window
	/// Boolean for whether the tgui_say was opened by the user.
	var/window_open
	// SS220 START TGUI CHAT EADDICTION
	var/list/availableChannels = list()
	var/livingType
	var/last_channels_update = 0
	var/channels_update_cooldown = 120 SECONDS
	// SS220 END TGUI CHAT EADDICTION

/** Creates the new input window to exist in the background. */
/datum/tgui_say/New(client/client, id)
	src.client = client
	window = new(client, id)
	winset(client, "tgui_say", "size=1,1;is-visible=0;")
	window.subscribe(src, PROC_REF(on_message))
	window.is_browser = TRUE

/**
 * After a brief period, injects the scripts into
 * the window to listen for open commands.
 */
/datum/tgui_say/proc/initialize()
	set waitfor = FALSE
	// Sleep to defer initialization to after client constructor
	sleep(3 SECONDS)
	window.initialize(
			strict_mode = TRUE,
			fancy = TRUE,
			inline_css = file("tgui/public/tgui-say.bundle.css"),
			inline_js = file("tgui/public/tgui-say.bundle.js"),
	);

/**
 * Ensures nothing funny is going on window load.
 * Minimizes the window, sets max length, closes all
 * typing and thinking indicators. This is triggered
 * as soon as the window sends the "ready" message.
 */
/datum/tgui_say/proc/load()
	window_open = FALSE

	winset(client, "tgui_say", "pos=700,500;is-visible=0;")

	// SS220 START TGUI CHAT EADDICTION
	// var/list/languages = list()
	// for(var/datum/language/language as anything in client.mob?.languages)
	//	languages += lowertext(language.name)
	// SS220 END TGUI CHAT EADDICTION

	window.send_message("props", list(
		"lightMode" = client.prefs?.tgui_say_light_mode,
		"scale" = client.prefs?.window_scale,
		"maxLength" = max_length,
		"extraChannels" = client.admin_holder?.get_tgui_say_extra_channels(),
		// "languages" = languages, // SS220 TGUI CHAT EADDICTION
	))

	stop_thinking()
	return TRUE

/**
 * Sets the window as "opened" server side, though it is already
 * visible to the user. We do this to set local vars &
 * start typing (if enabled and in an IC channel). Logs the event.
 *
 * Arguments:
 * payload - A list containing the channel the window was opened in.
 */
/datum/tgui_say/proc/open(payload)
	if(!payload?["channel"])
		CRASH("No channel provided to an open TGUI-Say")
	window_open = TRUE
	if(payload["channel"] != OOC_CHANNEL && payload["channel"] != LOOC_CHANNEL && payload["channel"] != ADMIN_CHANNEL && payload["channel"] != MENTOR_CHANNEL)
		start_thinking()
	update_available_channels() // SS220 TGUI CHAT EADDICTION
	return TRUE

// SS220 START TGUI CHAT EADDICTION
/datum/tgui_say/proc/update_available_channels()
	if(last_channels_update != 0 && world.time < (last_channels_update + channels_update_cooldown))
		return

	availableChannels.Cut()

	var/mob/user = client.mob
	if(isxeno(user))
		livingType = LIVING_TYPE_XENO
		var/mob/living/carbon/xenomorph/X = user
		for(var/channelKey in X.languages)
			availableChannels[channelKey] = 1
	if(ishuman(user))
		livingType = LIVING_TYPE_HUMAN
		var/mob/living/carbon/human/H = user
		var/obj/item/device/radio/headset/headset = H.get_type_in_ears(/obj/item/device/radio/headset)
		if(headset)
			for(var/obj/item/device/encryptionkey/key in headset.keys)
				availableChannels |= key.channels
	if(isyautja(user))
		livingType = LIVING_TYPE_YAUTJA

	window.send_message("update_channels", list(
		"availableChannels" = availableChannels,
		"livingType" = livingType
	))
	last_channels_update = world.time
// SS220 END TGUI CHAT EADDICTION

/**
 * Closes the window serverside. Closes any open chat bubbles
 * regardless of preference. Logs the event.
 */
/datum/tgui_say/proc/close()
	window_open = FALSE
	stop_thinking()

/**
 * The equivalent of ui_act, this waits on messages from the window
 * and delegates actions.
 */
/datum/tgui_say/proc/on_message(type, payload)
	if(type == "ready")
		load()
		return TRUE
	if (type == "open")
		open(payload)
		return TRUE
	if (type == "close")
		close()
		return TRUE
	if (type == "thinking")
		if(payload["visible"] == TRUE)
			start_thinking()
			return TRUE
		if(payload["visible"] == FALSE)
			stop_thinking()
			return TRUE
		return FALSE
	if (type == "typing")
		start_typing()
		return TRUE
	if (type == "entry" || type == "force")
		handle_entry(type, payload)
		return TRUE
	return FALSE
