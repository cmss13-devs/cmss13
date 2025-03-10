// --------------------------------------------
// *** Get communications up ***
// --------------------------------------------
/datum/cm_objective/communications
	name = "Restore Colony Communications"
	objective_flags = OBJECTIVE_DO_NOT_TREE
	value = OBJECTIVE_EXTREME_VALUE
	controller = TREE_MARINE

/datum/cm_objective/communications/complete()
	ai_silent_announcement("СИСТЕМНЫЙ ОТЧЁТ: Коммуникационная линия колонии, статус: ОНЛАЙН.", ":v")
	state = OBJECTIVE_COMPLETE
	award_points()
