/datum/keybinding/custom
	description = "Custom keybinding, used for say/me/picksay keybindings."

	/// If this is a say, me, or picksay keybind
	var/keybind_type = KEYBIND_TYPE_SAY

	/// What should be said or me'd, or picked from if a picksay emote
	var/contents = ""

	/// If this emote should fire when xenomorph
	var/when_xeno = TRUE

	/// If this emote should fire when human
	var/when_human = TRUE

/datum/keybinding/custom/can_use(client/user)
	. = ..()

	if(isxeno(user?.mob))
		return when_xeno

	return when_human

/datum/keybinding/custom/down(client/user)
	. = ..()

	switch(keybind_type)
		if(KEYBIND_TYPE_SAY)
			user?.mob?.say_verb(contents)
		if(KEYBIND_TYPE_ME)
			user?.mob?.me_verb(contents)
		if(KEYBIND_TYPE_PICKSAY)
			user?.mob?.say_verb(pick(contents))
