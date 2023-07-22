// --------------------------------------------
// *** The core objective interface to allow generic handling of objectives ***
// --------------------------------------------
/datum/cm_objective
	var/name = "An objective to complete"
	var/state = OBJECTIVE_INACTIVE // Whether the objective is inactive, active or complete.
	var/value = OBJECTIVE_NO_VALUE // The tech-point value of this objective.
	var/list/required_objectives //List of objectives that are required to complete this objectives.
	var/list/enables_objectives //List of objectives that require this objective to complete.
	var/objective_flags = NO_FLAGS // functionality related flags.
	var/number_of_clues_to_generate = 1 // miminum number of clues we generate for the objective(aka how many things will point to this objective).
	var/controller = TREE_NONE // Controlling tree - this is the tree-faction we consider in control of the objective for purpose of awarding points.

/datum/cm_objective/New()
	SSobjectives.add_objective(src)

/datum/cm_objective/Destroy()
	SSobjectives.stop_processing_objective(src)
	SSobjectives.remove_objective(src)
	for(var/datum/cm_objective/R as anything in required_objectives)
		LAZYREMOVE(R.enables_objectives, src)
	for(var/datum/cm_objective/E as anything in enables_objectives)
		LAZYREMOVE(E.required_objectives, src)
	required_objectives = null
	enables_objectives = null
	return ..()

// initial setup after the map has loaded
/datum/cm_objective/proc/Initialize()

// called by game mode just before the round starts
/datum/cm_objective/proc/pre_round_start()

// called by game mode on a short delay after round starts
/datum/cm_objective/proc/post_round_start()

// Get the objective data to display on the TGUI interface.
/datum/cm_objective/proc/get_tgui_data()

/// Add points to the techtree of whoever owns the objective.
/datum/cm_objective/proc/award_points(override_points = -1)
	var/datum/techtree/controlling_tree = GET_TREE(controller)
	if (!controlling_tree)
		return

	if (override_points != -1)
		controlling_tree.add_points(override_points)
	else
		controlling_tree.add_points(value)

/datum/cm_objective/proc/get_clue()

//For returning labels of related items (folders, discs, etc.)
/datum/cm_objective/proc/get_related_label()

// Set this objective to complete.
/datum/cm_objective/proc/complete()

// Check if the objective's aim are met.
/datum/cm_objective/proc/check_completion()

// Make this objective call process() and check_completion() every SS tick.
/datum/cm_objective/proc/activate()
	SSobjectives.start_processing_objective(src)

// Stops the Objective from processing
/datum/cm_objective/proc/deactivate()
	SSobjectives.stop_processing_objective(src)
