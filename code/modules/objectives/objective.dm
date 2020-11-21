// --------------------------------------------
// *** The core objective interface to allow generic handling of objectives ***
// --------------------------------------------
/datum/cm_objective
	var/name = "An objective to complete"
	var/complete = FALSE
	var/failed = FALSE
	var/active = FALSE
	var/priority = OBJECTIVE_NO_VALUE
	var/list/required_objectives = list() //List of objectives that are required to complete this objectives
	var/list/enables_objectives = list() //List of objectives that require this objective to complete
	var/prerequisites_required = PREREQUISITES_ONE
	var/objective_flags = 0 // functionality related flags
	var/display_flags = 0 // display related flags
	var/display_category // group objectives for round end display
	var/number_of_clues_to_generate = 1 //how many clues we generate for the objective(aka how many things will point to this objective)

/datum/cm_objective/New()
	cm_objectives += src
	SSobjectives.add_objective(src)

/datum/cm_objective/Destroy()
	cm_objectives -= src
	SSobjectives.remove_objective(src)
	for(var/datum/cm_objective/R in required_objectives)
		R.enables_objectives -= src
	for(var/datum/cm_objective/E in enables_objectives)
		E.required_objectives -= src
	return ..()

/datum/cm_objective/proc/Initialize() // initial setup after the map has loaded

/datum/cm_objective/proc/pre_round_start() // called by game mode just before the round starts

/datum/cm_objective/proc/post_round_start() // called by game mode on a short delay after round starts

/datum/cm_objective/proc/on_round_end() // called by game mode when round ends

/datum/cm_objective/proc/on_ground_evac() // called when queen launches dropship

/datum/cm_objective/proc/on_ship_boarding() // called when dropship crashes into almayer

/datum/cm_objective/proc/get_completion_status()
	if(is_complete())
		return "<span class='objectivesuccess'>Succeeded!</span>"
	if(is_failed())
		return "<span class='objectivefail'>Failed!</span>"
	return "<span class='objectivebig'>In Progress!</span>"

/datum/cm_objective/proc/get_readable_progress()
	var/dat = "<b>[name]:</b> "
	return dat + get_completion_status() + "<br>"

/datum/cm_objective/proc/get_clue() //TODO: change this to an formatted list like above -spookydonut
	return

/datum/cm_objective/proc/get_related_label()
	//For returning labels of related items (folders, discs, etc.)
	return

/datum/cm_objective/process()
	if(!is_prerequisites_completed())
		deactivate()
		return FALSE
	check_completion()
	return TRUE

/datum/cm_objective/proc/is_complete()
	return complete

/datum/cm_objective/proc/complete()
	if(is_complete())
		return FALSE
	complete = TRUE
	if(can_be_deactivated() && !(objective_flags & OBJ_PROCESS_ON_DEMAND))
		deactivate()
	for(var/datum/cm_objective/O in enables_objectives)
		O.activate()
	return TRUE

/datum/cm_objective/proc/uncomplete()
	if(!(objective_flags & OBJ_CAN_BE_UNCOMPLETED) || !complete)
		return
	complete = FALSE
	if(can_be_activated())
		activate()

/datum/cm_objective/proc/check_completion()
	if(is_failed())
		return FALSE
	if(complete && !(objective_flags & OBJ_CAN_BE_UNCOMPLETED))
		return TRUE
	return complete

/datum/cm_objective/proc/is_in_progress()
	return active

/datum/cm_objective/proc/fail()
	if(!(objective_flags & OBJ_FAILABLE))
		return
	if(complete && !(objective_flags & OBJ_CAN_BE_UNCOMPLETED))
		return
	failed = TRUE
	uncomplete()
	deactivate()
	for(var/datum/cm_objective/O in enables_objectives)
		if(O.objective_flags & OBJ_PREREQS_CANT_FAIL)
			O.fail()

/datum/cm_objective/proc/is_failed()
	if(!(objective_flags & OBJ_FAILABLE))
		return FALSE
	if(complete && !(objective_flags & OBJ_CAN_BE_UNCOMPLETED))
		return FALSE
	return failed

/datum/cm_objective/proc/activate(var/force = 0)
	if(force)
		prerequisites_required = PREREQUISITES_NONE // somehow we got the terminal password etc force us active
	if(can_be_activated())
		active = TRUE
		if(!(objective_flags & OBJ_PROCESS_ON_DEMAND))
			if(!(src in SSobjectives.active_objectives))
				SSobjectives.active_objectives += src
			SSobjectives.inactive_objectives -= src

/datum/cm_objective/proc/deactivate()
	if(can_be_deactivated())
		active = FALSE
		if(!(objective_flags & OBJ_PROCESS_ON_DEMAND))
			SSobjectives.active_objectives -= src
			if(!(src in SSobjectives.inactive_objectives))
				SSobjectives.inactive_objectives += src

/datum/cm_objective/proc/can_be_activated()
	if(is_active())
		return FALSE //Objective is already active!
	if(is_failed())
		return FALSE //Objective is failed, can't re-activate!
	if(!is_prerequisites_completed())
		return FALSE //Prerequisites are not complete yet!
	if(is_complete() && !(objective_flags & OBJ_CAN_BE_UNCOMPLETED))
		return FALSE //Objective is already complete and can't be uncompleted!
	return TRUE

/datum/cm_objective/proc/can_be_deactivated()
	if (is_failed())
		return TRUE
	if(objective_flags & OBJ_CAN_BE_UNCOMPLETED)
		return FALSE
	return TRUE

/datum/cm_objective/proc/is_prerequisites_completed()
	var/prereq_complete = 0
	for(var/datum/cm_objective/O in required_objectives)
		if(O.is_complete())
			prereq_complete++
	switch(prerequisites_required)
		if(PREREQUISITES_NONE)
			return TRUE
		if(PREREQUISITES_ONE)
			if(prereq_complete || (required_objectives.len == 0))
				return TRUE
		if(PREREQUISITES_QUARTER)
			if(prereq_complete >= (required_objectives.len/4)) // quarter or more
				return TRUE
		if(PREREQUISITES_MAJORITY)
			if(prereq_complete >= (required_objectives.len/2)) // half or more
				return TRUE
		if(PREREQUISITES_ALL)
			if(prereq_complete >= required_objectives.len)
				return TRUE
	return FALSE

/datum/cm_objective/proc/is_active()
	if(complete && !(objective_flags & OBJ_CAN_BE_UNCOMPLETED))
		return FALSE
	return active

/datum/cm_objective/proc/get_point_value()
	if(is_failed())
		return FALSE
	if(is_complete())
		return priority
	return FALSE

/datum/cm_objective/proc/total_point_value()
	return priority

//Returns true if an objective will never be active again
/datum/cm_objective/proc/is_finalised()
	if(complete && objective_flags & OBJ_CAN_BE_UNCOMPLETED)
		return TRUE
	if(failed)
		return TRUE
	return FALSE
