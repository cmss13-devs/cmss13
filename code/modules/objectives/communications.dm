// --------------------------------------------
// *** Get communications up ***
// --------------------------------------------
/datum/cm_objective/communications
	name = "Restore Colony Communications"
	objective_flags = OBJECTIVE_DO_NOT_TREE
	controller = TREE_MARINE

/datum/cm_objective/communications/complete()
	ai_silent_announcement("СИСТЕМНЫЙ ОТЧЕТ: Связь с колонией активна.", ":v")
	state = OBJECTIVE_COMPLETE

/datum/cm_objective/communications/proc/score_new_points(points)
	value += points
	value = round(value, 0.1)
