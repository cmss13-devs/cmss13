/datum/faction/xenomorph/normal
	name = NAME_FACTION_XENOMORPH_NORMAL
	faction_name = FACTION_XENOMORPH_NORMAL
	organ_faction_iff_tag_type = /obj/item/faction_tag/organ/xenomorph/normal

	evolution_without_ovipositor = FALSE
	color = null
	ui_color = null

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
		MODE_NAME_EXTENDED = ROLES_REGULAR_XENO,
		MODE_NAME_DISTRESS_SIGNAL = ROLES_REGULAR_XENO,
		MODE_NAME_FACTION_CLASH = list(),
		MODE_NAME_CRASH = list(
			JOB_XENOMORPH
		),
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
	coefficient_per_role = list(
		JOB_XENOMORPH = 8,
		JOB_XENOMORPH_QUEEN = 16
	)
	weight_act = list(
		MODE_NAME_EXTENDED = FALSE,
		MODE_NAME_DISTRESS_SIGNAL = TRUE,
		MODE_NAME_FACTION_CLASH = FALSE,
		MODE_NAME_CRASH = TRUE,
		MODE_NAME_WISKEY_OUTPOST = FALSE,
		MODE_NAME_HUNTER_GAMES = FALSE,
		MODE_NAME_HIVE_WARS = TRUE,
		MODE_NAME_INFECTION = FALSE
	)
