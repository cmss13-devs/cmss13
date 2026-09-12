/**
 * ### tgui_priority_input
 * Opens a window with a list of items and returns a list of selected choices in order of priority.
 *
 * * Arguments:
 * * user - The mob to display the window to
 * * message - The message inside the window
 * * title - The title of the window
 * * list/items - The list of items to display
 * * timeout - The timeout for the input (optional)
 * * theme - The ui theme to use for the TGUI window (optional).
 * * ui_state - The TGUI UI state that will be returned in ui_state(). Default: always_state
 */
/proc/tgui_priority_input(mob/user, message, title = "Select", list/items, timeout = 0, theme = null, ui_state = GLOB.always_state)
	if (!user)
		user = usr
	if(!length(items))
		return null
	if (!istype(user))
		if (istype(user, /client))
			var/client/client = user
			user = client.mob
		else
			return null

	if(isnull(user.client))
		return null

	var/datum/tgui_priority_input/input = new(user, message, title, items, timeout, theme, ui_state)
	if(input.invalid)
		qdel(input)
		return
	input.tgui_interact(user)
	input.wait()
	if (input)
		. = input.choices
		qdel(input)

/**
 * ### tgui_priority_input
 * Opens a window with a list of items and returns a list of selected choices in order of priority.
 *
 * * Arguments:
 * * user - The mob to display the window to
 * * message - The message inside the window
 * * title - The title of the window
 * * list/items - The list of items to display
 * * timeout - The timeout for the input (optional)
 * * theme - The ui theme to use for the TGUI window (optional).
 * * ui_state - The TGUI UI state that will be returned in ui_state(). Default: always_state
 */
/proc/tgui_priority_input_async(mob/user, message, title = "Select", list/items, datum/callback/callback, timeout = 0, theme = null, ui_state = GLOB.always_state)
	if (!user)
		user = usr
	if(!length(items))
		return null
	if (!istype(user))
		if (istype(user, /client))
			var/client/client = user
			user = client.mob
		else
			return null

	if(isnull(user.client))
		return null

	var/datum/tgui_priority_input/async/input = new(user, message, title, items, callback, timeout, theme, ui_state)
	if(input.invalid)
		qdel(input)
		return
	input.tgui_interact(user)

/// Window for tgui_priority_input
/datum/tgui_priority_input
	/// Title of the window
	var/title
	/// Message to display
	var/message
	/// List of items to display
	var/list/items
	/// List of selected items
	var/list/choices
	/// Time when the input was created
	var/start_time
	/// Timeout for the input
	var/timeout
	/// Whether the input was closed
	var/closed
	/// The TGUI UI state that will be returned in ui_state(). Default: always_state
	var/datum/ui_state/state
	/// String field for the theme to use
	var/ui_theme
	/// Whether the tgui list input is invalid or not (i.e. due to all list entries being null)
	var/invalid = FALSE

/datum/tgui_priority_input/New(mob/user, message, title, list/items, timeout, theme = null, ui_state)
	src.title = title
	src.message = message
	src.items = list()
	src.state = ui_state
	src.ui_theme = theme

	//var/list/repeat_items = list()
	// Gets rid of illegal characters
	var/static/regex/whitelistedWords = regex(@{"([^\u0020-\u8000]+)"})

	for(var/i in items)
		if(!i)
			continue
		var/string_key = whitelistedWords.Replace("[i]", "")
		//avoids duplicated keys E.g: when areas have the same name
		//string_key = avoid_assoc_duplicate_keys(string_key, repeat_items)
		src.items += string_key

	if(!length(src.items))
		invalid = TRUE

	if (timeout)
		src.timeout = timeout
		start_time = world.time
		QDEL_IN(src, timeout)

/datum/tgui_priority_input/Destroy(force)
	SStgui.close_uis(src)
	state = null
	items?.Cut()
	return ..()

/**
 * Waits for a user's response to the tgui_priority_input's prompt before returning. Returns early if
 * the window was closed by the user.
 */
/datum/tgui_priority_input/proc/wait()
	while (!closed && !QDELETED(src))
		stoplag(0.2 SECONDS)

/datum/tgui_priority_input/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PriorityInput")
		ui.open()

/datum/tgui_priority_input/ui_close(mob/user)
	. = ..()
	closed = TRUE

/datum/tgui_priority_input/ui_state(mob/user)
	return state

/datum/tgui_priority_input/ui_data(mob/user)
	var/list/data = list()

	if(timeout)
		data["timeout"] = CLAMP01((timeout - (world.time - start_time) - 1 SECONDS) / (timeout - 1 SECONDS))

	return data

/datum/tgui_priority_input/ui_static_data(mob/user)
	var/list/data = list()

	data["items"] = items
	data["large_buttons"] = TRUE // Pref?
	data["message"] = message
	data["swapped_buttons"] = FALSE // Pref?
	data["title"] = title
	data["theme"] = ui_theme

	return data

/datum/tgui_priority_input/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return

	switch(action)
		if("submit")
			var/list/selections = params["entry"]
			var/list/valid_selections = list()
			for(var/raw_entry in selections)
				if(raw_entry in items)
					valid_selections += raw_entry
			set_choices(valid_selections)
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE

		if("cancel")
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE

	return FALSE

/datum/tgui_priority_input/proc/set_choices(list/selections)
	src.choices = selections.Copy()

/**
 * # async tgui_priority_input
 *
 * An asynchronous version of tgui_priority_input to be used with callbacks instead of waiting on user responses.
 */
/datum/tgui_priority_input/async
	/// The callback to be invoked by the tgui_modal upon having a choice made.
	var/datum/callback/callback

/datum/tgui_priority_input/async/New(mob/user, message, title, list/items, callback, timeout, theme = null, ui_state)
	..(user, message, title, items, callback, timeout, theme, ui_state)
	src.callback = callback

/datum/tgui_priority_input/async/Destroy(force, ...)
	QDEL_NULL(callback)
	. = ..()

/datum/tgui_priority_input/async/ui_close(mob/user)
	. = ..()
	qdel(src)

/datum/tgui_priority_input/async/set_choices(list/selections)
	. = ..()
	if(length(choices))
		callback?.InvokeAsync(choices)

/datum/tgui_priority_input/async/wait()
	return
