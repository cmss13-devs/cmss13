/datum/keybinding/custom
	description = "Custom keybinding, used for say/me/picksay keybindings."

	var/keybind_type = KEYBIND_TYPE_SAY
	var/stored_message = ""

/datum/keybinding/custom/down(client/user)
	. = ..()

	switch(keybind_type)
		if(KEYBIND_TYPE_SAY)
			user?.mob?.say_verb(stored_message)
		if(KEYBIND_TYPE_ME)
			user?.mob?.me_verb(stored_message)
		if(KEYBIND_TYPE_PICKSAY)
			user?.mob?.say_verb(pick(stored_message))
