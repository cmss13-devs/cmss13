/datum/faction/yautja
	name = NAME_FACTION_YAUTJA
	desc = "Unable to extract addition information."

	faction_name = FACTION_YAUTJA
	faction_tag = SIDE_FACTION_YAUTJA
	relations_pregen = RELATIONS_HOSTILE

	role_mappings = list(
		MODE_NAME_EXTENDED = list(),
		MODE_NAME_DISTRESS_SIGNAL = list(),
		MODE_NAME_FACTION_CLASH = list(),
		MODE_NAME_CRASH = list(),
		MODE_NAME_WISKEY_OUTPOST = list(),
		MODE_NAME_HUNTER_GAMES = list(),
		MODE_NAME_HIVE_WARS = list(),
		MODE_NAME_INFECTION = list()
	)
	roles_list = list(
		MODE_NAME_EXTENDED = ROLES_REGULAR_YAUT,
		MODE_NAME_DISTRESS_SIGNAL = ROLES_REGULAR_YAUT,
		MODE_NAME_FACTION_CLASH = ROLES_REGULAR_YAUT,
		MODE_NAME_CRASH = list(),
		MODE_NAME_WISKEY_OUTPOST = list(),
		MODE_NAME_HUNTER_GAMES = ROLES_REGULAR_YAUT,
		MODE_NAME_HIVE_WARS = list(),
		MODE_NAME_INFECTION = ROLES_REGULAR_YAUT
	)
	weight_act = list(
		MODE_NAME_EXTENDED = FALSE,
		MODE_NAME_DISTRESS_SIGNAL = FALSE,
		MODE_NAME_FACTION_CLASH = FALSE,
		MODE_NAME_CRASH = FALSE,
		MODE_NAME_WISKEY_OUTPOST = FALSE,
		MODE_NAME_HUNTER_GAMES = FALSE,
		MODE_NAME_HIVE_WARS = FALSE,
		MODE_NAME_INFECTION = FALSE
	)

/datum/faction/yautja/get_join_status(mob/new_player/user, dat)
	if(alert(user, user.client.auto_lang(LANGUAGE_LOBBY_JOIN_HUNT), user.client.auto_lang(LANGUAGE_CONFIRM), user.client.auto_lang(LANGUAGE_YES), user.client.auto_lang(LANGUAGE_NO)) == user.client.auto_lang(LANGUAGE_YES))
		if(SSticker.mode.check_predator_late_join(user, 0))
			user.close_spawn_windows()
			SSticker.mode.attempt_to_join_as_predator(user)
		else
			to_chat(user, SPAN_WARNING(user.client.auto_lang(LANGUAGE_LOBBY_NO_JOIN_HUNT)))
			user.new_player_panel()
