/datum/faction/yautja
	name = "Yautja Hanting Groop"
	desc = "Unable to extract addition information."
	code_identificator = FACTION_YAUTJA

	relations_pregen = RELATIONS_HOSTILE

/datum/faction/yautja/get_join_status(mob/new_player/user, dat)
	if(alert(user, user.client.auto_lang(LANGUAGE_LOBBY_JOIN_HUNT), user.client.auto_lang(LANGUAGE_CONFIRM), user.client.auto_lang(LANGUAGE_YES), user.client.auto_lang(LANGUAGE_NO)) == user.client.auto_lang(LANGUAGE_YES))
		if(SSticker.mode.check_predator_late_join(user, 0))
			user.close_spawn_windows()
			SSticker.mode.attempt_to_join_as_predator(user)
		else
			to_chat(user, SPAN_WARNING(user.client.auto_lang(LANGUAGE_LOBBY_NO_JOIN_HUNT)))
			user.new_player_panel()
