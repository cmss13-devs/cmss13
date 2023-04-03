/datum/research_objective_memory_interface

/datum/research_objective_memory_interface/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ResearchMemories", "Research Objectives")
		ui.open()
		ui.set_autoupdate(TRUE)

/datum/research_objective_memory_interface/proc/get_clues(mob/user)
	var/list/clue_categories = list()

	var/list/clue_category = list()
	clue_category["name"] = "Analyze Chemicals"
	clue_category["icon"] = "scroll"
	clue_category["clues"] = list()
	for (var/chemid in chemical_data.chemical_not_completed_objective_list)
		clue_category["clues"] += list(chemical_data.get_tgui_data(chemid))
	clue_categories += list(clue_category)

	return clue_categories

/datum/research_objective_memory_interface/proc/get_objective(label, completed, instances, points_earned, custom_color = FALSE, custom_status = FALSE)
	var/list/objective = list()
	objective["label"] = label
	objective["content_credits"] = (points_earned ? "([points_earned])" : "")

	if (!custom_status)
		objective["content"] = "[completed] / [(instances ? instances : "∞")]"
	else
		objective["content"] = custom_status

	if (custom_color)
		objective["content_color"] = custom_color
	else
		if (!completed)
			objective["content_color"] = "red"
		else if (completed == instances)
			objective["content_color"] = "green"
		else
			objective["content_color"] = "orange"

	return objective

// Get our progression for each objective.
/datum/research_objective_memory_interface/proc/get_objectives()
	var/list/objectives = list()

	// Chemicals
	objectives += list(get_objective(
		"Analyze Chemicals",
		SSobjectives.statistics["chemicals_completed"],
		FALSE,
		chemical_data.rsc_credits,
		"white"
	))

	return objectives

/datum/research_objective_memory_interface/ui_data(mob/user)
	. = list()

	.["research_credits"] = chemical_data.rsc_credits
	var/clearance = "[chemical_data.clearance_level]"
	if(chemical_data.clearance_x_access)
		clearance +="X"
	.["clearance"] = clearance
	.["objectives"] = get_objectives(user)
	.["clue_categories"] = get_clues(user)

/datum/research_objective_memory_interface/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	switch(action)
		if("enter_techtree")
			var/datum/techtree/tree = GET_TREE(TREE_MARINE)
			tree.enter_mob(usr, FALSE)

/datum/research_objective_memory_interface/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE
