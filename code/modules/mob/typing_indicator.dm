#define TYPING_INDICATOR_LIFETIME 30 * 10 //grace period after which typing indicator disappears regardless of text in chatbar

/mob/var/hud_typing = 0 //set when typing in an input window instead of chatline
/mob/var/last_typed
/mob/var/last_typed_time

var/global/image/typing_indicator
var/global/list/image/typed_typing_indicators

/mob/proc/set_typing_indicator(var/state, var/type)
	SHOULD_NOT_SLEEP(TRUE)

	if(!typing_indicator)
		typing_indicator = image('icons/mob/hud/talk.dmi', null, "typing")
		typing_indicator.appearance_flags = NO_CLIENT_COLOR|KEEP_APART|RESET_COLOR
	if(type && !LAZYISIN(typed_typing_indicators, type))
		LAZYINITLIST(typed_typing_indicators)
		var/image/I = image('icons/mob/hud/talk.dmi', null, type)
		I.appearance_flags = NO_CLIENT_COLOR|KEEP_APART|RESET_COLOR
		typed_typing_indicators[type] = I

	var/image/indicator = type ? typed_typing_indicators[type] : typing_indicator

	if(client)
		if(client.prefs.toggles_chat & SHOW_TYPING)
			overlays -= indicator
		else
			if(state)
				if(stat == CONSCIOUS && alpha == 255)
					overlays += indicator
			else
				overlays -= indicator
			return state

/mob/verb/say_wrapper()
	set name = ".Say"
	set hidden = 1

	set_typing_indicator(TRUE)
	hud_typing = -1
	var/message = input("","say (text)") as text
	hud_typing = NONE
	set_typing_indicator(FALSE)
	if(message)
		say_verb(message)

/mob/verb/me_wrapper()
	set name = ".Me"
	set hidden = 1

	set_typing_indicator(TRUE)
	hud_typing = -1
	var/message = input("","me (text)") as text
	hud_typing = NONE
	set_typing_indicator(FALSE)
	if(message)
		me_verb(message)

/// Sets typing indicator for a couple seconds, for use with client-side comm verbs
/mob/verb/timed_typing()
	set name = ".typing"
	set hidden = TRUE
	set instant = TRUE

	// Don't override wrapper's indicators
	if(hud_typing == -1)
		return
	set_typing_indicator(TRUE)
	hud_typing = addtimer(CALLBACK(src, PROC_REF(timed_typing_clear)), 5 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)

/// Clears timed typing indicators
/mob/proc/timed_typing_clear()
	// Check it's one of ours
	if(hud_typing == -1)
		return
	hud_typing = NONE
	set_typing_indicator(FALSE)

/client/verb/typing_indicator()
	set name = "Show/Hide Typing Indicator"
	set category = "Preferences.Chat"
	set desc = "Toggles showing an indicator when you are typing emote or say message."
	prefs.toggles_chat ^= SHOW_TYPING
	prefs.save_preferences()
	to_chat(src, "You will [(prefs.toggles_chat & SHOW_TYPING) ? "no longer" : "now"] display a typing indicator.")

	// Clear out any existing typing indicator.
	if(prefs.toggles_chat & SHOW_TYPING)
		if(istype(mob)) mob.set_typing_indicator(0)

