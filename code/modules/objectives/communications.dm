// --------------------------------------------
// *** Get communications up ***
// --------------------------------------------
/datum/cm_objective/communications
	name = "Restore Colony Communications"
	objective_flags = OBJECTIVE_DO_NOT_TREE
	controller = TREE_MARINE

/datum/cm_objective/communications/complete()
	ai_silent_announcement("SYSTEMS REPORT: Colony communications link online.", ":v")
	state = OBJECTIVE_COMPLETE

/datum/cm_objective/communications/proc/score_new_points(points)
	value += points
