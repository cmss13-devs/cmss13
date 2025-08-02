CLIENT_VERB(edit_characters)
	set category = "Preferences"
	set name = "Edit Characters"
	set desc = "Edit your characters in your preferences."

	to_chat(usr, SPAN_WARNING("Note that changes may not take place until respawn."))
	prefs.ShowChoices(mob)
