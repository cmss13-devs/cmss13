/datum/faction/xenomorph/normal
	name = NAME_FACTION_XENOMORPH_NORMAL
	faction_name = FACTION_XENOMORPH_NORMAL

	evolution_without_ovipositor = FALSE
	color = null
	ui_color = null

	role_mappings = list(
		MODE_NAME_EXTENDED = list(),
		MODE_NAME_DISTRESS_SIGNAL = list(),
		MODE_NAME_FACTION_CLASH = list(),
		MODE_NAME_WISKEY_OUTPOST = list(),
		MODE_NAME_HUNTER_GAMES = list(),
		MODE_NAME_HIVE_WARS = list(),
		MODE_NAME_INFECTION = list()
	)
	roles_list = list(
		MODE_NAME_EXTENDED = ROLES_REGULAR_XENO,
		MODE_NAME_DISTRESS_SIGNAL = ROLES_REGULAR_XENO,
		MODE_NAME_FACTION_CLASH = list(),
		MODE_NAME_WISKEY_OUTPOST = list(
			JOB_XENOMORPH
		),
		MODE_NAME_HUNTER_GAMES = list(),
		MODE_NAME_HIVE_WARS = list(
			JOB_XENOMORPH
		),
		MODE_NAME_INFECTION = list(
			JOB_XENOMORPH
		)
	)
