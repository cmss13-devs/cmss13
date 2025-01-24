/datum/faction/yautja
	name = "Yautja Hunting Groop"
	desc = "Unable to extract addition information."
	code_identificator = FACTION_YAUTJA

	relations_pregen = RELATIONS_HOSTILE

	minimap_flag = MINIMAP_FLAG_YAUTJA

	role_mappings = list(
		MODE_NAME_EXTENDED = list(),
		MODE_NAME_DISTRESS_SIGNAL = list(),
		MODE_NAME_FACTION_CLASH = list(),
		MODE_NAME_WISKEY_OUTPOST = list(),
		MODE_NAME_HUNTER_GAMES = list(),
		MODE_NAME_HIVE_WARS = list(),
		MODE_NAME_INFECTION = list(),
	)
	roles_list = list(
		MODE_NAME_EXTENDED = JOB_PREDATOR,
		MODE_NAME_DISTRESS_SIGNAL = JOB_PREDATOR,
		MODE_NAME_FACTION_CLASH = JOB_PREDATOR,
		MODE_NAME_WISKEY_OUTPOST = list(),
		MODE_NAME_HUNTER_GAMES = JOB_PREDATOR,
		MODE_NAME_HIVE_WARS = list(),
		MODE_NAME_INFECTION = JOB_PREDATOR,
	)
	weight_act = list(
		MODE_NAME_EXTENDED = FALSE,
		MODE_NAME_DISTRESS_SIGNAL = FALSE,
		MODE_NAME_FACTION_CLASH = FALSE,
		MODE_NAME_WISKEY_OUTPOST = FALSE,
		MODE_NAME_HUNTER_GAMES = FALSE,
		MODE_NAME_HIVE_WARS = FALSE,
		MODE_NAME_INFECTION = FALSE,
	)

/datum/faction/yautja/get_join_status(mob/new_player/user)
	if(SSticker.mode.check_predator_late_join(user, 0))
		user.close_spawn_windows()
		SSticker.mode.attempt_to_join_as_predator(user)
