/proc/ru_emote_name(emote_name)
	return GLOB.ru_emote_names[lowertext(UNLINT(emote_name))] || emote_name

/proc/ru_emote_message(emote_message)
	return GLOB.ru_emote_messages[emote_message] || emote_message

/datum/emote
	var/name

/datum/emote/proc/update_to_ru()
	name = ru_emote_name(name || key)
	message = ru_emote_message(message)

/datum/keybinding/emote
	var/datum/emote/faketype

/datum/keybinding/emote/link_to_emote(datum/emote/faketype)
	. = ..()
	src.faketype = faketype

/datum/keybinding/emote/proc/update_to_ru()
	full_name = capitalize(ru_emote_name(faketype::name || faketype::key))
