/datum/keybinding/emote
	category = CATEGORY_EMOTE
	weight = WEIGHT_EMOTE
	keybind_signal = COMSIG_KB_EMOTE
	var/emote_key

/datum/keybinding/emote/proc/link_to_emote(datum/emote/faketype)
	hotkey_keys = list()
	classic_keys = list("F4")
	emote_key = initial(faketype.key)
	name = initial(faketype.key)
	full_name = capitalize(initial(faketype.key))
	description = "Do the emote '*[emote_key]'"

/datum/keybinding/emote/down(client/user)
	. = ..()
	if(.)
		return
	return user.mob.emote(emote_key, intentional=TRUE)
