/datum/faction/xenomorph/normal
	name = "Mutated Xenomorph Hive"
	code_identificator = FACTION_XENOMORPH_NORMAL

	organ_faction_iff_tag_type = /obj/item/faction_tag/organ/xenomorph/normal

	color = null
	ui_color = "#8200FF"

	roles_list = list(
		MODE_NAME_EXTENDED = list(JOB_XENOMORPH_QUEEN, JOB_XENOMORPH),
		MODE_NAME_DISTRESS_SIGNAL = list(JOB_XENOMORPH_QUEEN, JOB_XENOMORPH),
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
		),
	)
	coefficient_per_role = list(
		JOB_XENOMORPH = 8,
		JOB_XENOMORPH_QUEEN = 16,
	)
	weight_act = list(
		MODE_NAME_EXTENDED = FALSE,
		MODE_NAME_DISTRESS_SIGNAL = TRUE,
		MODE_NAME_FACTION_CLASH = FALSE,
		MODE_NAME_WISKEY_OUTPOST = FALSE,
		MODE_NAME_HUNTER_GAMES = FALSE,
		MODE_NAME_HIVE_WARS = TRUE,
		MODE_NAME_INFECTION = FALSE,
	)

	minimap_flag = MINIMAP_FLAG_XENO
