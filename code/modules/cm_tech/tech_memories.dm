/datum/objective_memory_interface
	var/datum/techtree/holder

/datum/objective_memory_interface/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TechMemories", "[holder.name] Objectives")
		ui.open()
		ui.set_autoupdate(TRUE)

/datum/objective_memory_interface/proc/get_clues(mob/user)
	var/datum/objective_memory_storage/memories = user.mind.objective_memory
	var/list/clue_categories = list()


	// Progress reports
	var/list/clue_category = list()
	clue_category["name"] = "Reports"
	clue_category["icon"] = "scroll"
	clue_category["clues"] = list()
	for (var/datum/cm_objective/document/progress_report/report in memories.progress_reports)
		if (report.state == OBJECTIVE_ACTIVE)
			clue_category["clues"] += list(report.get_tgui_data())
	clue_categories += list(clue_category)


	// Folders
	clue_category = list()
	clue_category["name"] = "Folders"
	clue_category["icon"] = "folder"
	clue_category["clues"] = list()
	for (var/datum/cm_objective/document/folder/folder in memories.folders)
		if (folder.state == OBJECTIVE_ACTIVE)
			clue_category["clues"] += list(folder.get_tgui_data())
	clue_categories += list(clue_category)


	// Technical manuals
	clue_category = list()
	clue_category["name"] = "Manuals"
	clue_category["icon"] = "book"
	clue_category["clues"] = list()
	for (var/datum/cm_objective/document/technical_manual/manual in memories.technical_manuals)
		if (manual.state == OBJECTIVE_ACTIVE)
			clue_category["clues"] += list(manual.get_tgui_data())
	clue_categories += list(clue_category)


	// Data (disks + terminals)
	clue_category = list()
	clue_category["name"] = "Data"
	clue_category["icon"] = "save"
	clue_category["clues"] = list()
	for (var/datum/cm_objective/retrieve_data/disk/disk in memories.disks)
		if (disk.state == OBJECTIVE_ACTIVE)
			clue_category["clues"] += list(disk.get_tgui_data())
	for (var/datum/cm_objective/retrieve_data/terminal/terminal in memories.terminals)
		if (terminal.state == OBJECTIVE_ACTIVE)
			clue_category["clues"] += list(terminal.get_tgui_data())
	clue_categories += list(clue_category)


	// Retrieve items (devices + documents)
	clue_category = list()
	clue_category["name"] = "Retrieve"
	clue_category["icon"] = "box"
	clue_category["compact"] = TRUE
	clue_category["clues"] = list()
	for (var/datum/cm_objective/retrieve_item/objective in memories.retrieve_items)
		if (objective.state == OBJECTIVE_ACTIVE)
			clue_category["clues"] += list(objective.get_tgui_data())
	clue_categories += list(clue_category)


	// Other (safes)
	clue_category = list()
	clue_category["name"] = "Other"
	clue_category["icon"] = "ellipsis-h"
	clue_category["clues"] = list()
	for (var/datum/cm_objective/objective in memories.other)

		// Safes
		if(istype(objective, /datum/cm_objective/crack_safe))
			var/datum/cm_objective/crack_safe/safe = objective
			if (safe.state == OBJECTIVE_ACTIVE)
				clue_category["clues"] += list(safe.get_tgui_data())
			continue

	clue_categories += list(clue_category)

	return clue_categories

/datum/objective_memory_interface/proc/get_objective(label, completed, instances, points_earned, custom_color = FALSE, custom_status = FALSE)
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
/datum/objective_memory_interface/proc/get_objectives()
	var/list/objectives = list()

	// Documents (papers + reports + folders + manuals)
	objectives += list(get_objective(
		"Documents",
		SSobjectives.statistics["documents_completed"],
		SSobjectives.statistics["documents_total_instances"],
		SSobjectives.statistics["documents_total_points_earned"]
	))

	// Data (disks + terminals)
	objectives += list(get_objective(
		"Upload data",
		SSobjectives.statistics["data_retrieval_completed"],
		SSobjectives.statistics["data_retrieval_total_instances"],
		SSobjectives.statistics["data_retrieval_total_points_earned"]
	))

	// Retrieve items (devices + documents + fultons)
	objectives += list(get_objective(
		"Retrieve items",
		SSobjectives.statistics["item_retrieval_completed"],
		SSobjectives.statistics["item_retrieval_total_instances"],
		SSobjectives.statistics["item_retrieval_total_points_earned"]
	))

	// Miscellaneous (safes)
	objectives += list(get_objective(
		"Miscellaneous",
		SSobjectives.statistics["miscellaneous_completed"],
		SSobjectives.statistics["miscellaneous_total_instances"],
		SSobjectives.statistics["miscellaneous_total_points_earned"]
	))

	// Chemicals
	objectives += list(get_objective(
		"Analyze chemicals",
		SSobjectives.statistics["chemicals_completed"],
		FALSE,
		SSobjectives.statistics["chemicals_total_points_earned"],
		"white"
	))

	// Rescue survivors
	objectives += list(get_objective(
		"Rescue survivors",
		SSobjectives.statistics["survivors_rescued"],
		FALSE,
		SSobjectives.statistics["survivors_rescued_total_points_earned"],
		"white"
	))

	// Corpses (human + xeno)
	objectives += list(get_objective(
		"Recover corpses",
		SSobjectives.statistics["corpses_recovered"],
		FALSE,
		SSobjectives.statistics["corpses_total_points_earned"],
		"white"
	))

	// Communications
	objectives += list(get_objective(
		"Colony communications",
		FALSE,
		FALSE,
		(SSobjectives.comms.state == OBJECTIVE_COMPLETE ? SSobjectives.comms.value : FALSE),
		(SSobjectives.comms.state == OBJECTIVE_COMPLETE ? "green" : "red"),
		(SSobjectives.comms.state == OBJECTIVE_COMPLETE ? "Online" : "Offline"),
	))

	// Power (smes)
	var/message
	var/color
	if (!SSobjectives.first_drop_complete)
		message = "Unable to remotely interface with powernet"
		color = "white"
	else if (SSobjectives.power.state == OBJECTIVE_COMPLETE)
		message = "Online"
		color = "green"
	else if (SSobjectives.power.last_power_output)
		message = "[SSobjectives.power.last_power_output]W, [SSobjectives.power.minimum_power_required]W required"
		color = "orange"
	else
		message = "Offline"
		color = "red"

	objectives += list(get_objective(
		"Colony power",
		FALSE,
		FALSE,
		(SSobjectives.power.state == OBJECTIVE_COMPLETE ? SSobjectives.power.value : FALSE),
		color,
		message,
	))

	return objectives

/datum/objective_memory_interface/ui_data(mob/user)
	. = list()

	var/datum/techtree/tree = GET_TREE(TREE_MARINE)

	.["tech_points"] = holder.points
	.["total_tech_points"] = tree.total_points
	.["objectives"] = get_objectives(user)
	.["clue_categories"] = get_clues(user)

/datum/objective_memory_interface/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	switch(action)
		if("enter_techtree")
			var/datum/techtree/tree = GET_TREE(TREE_MARINE)
			tree.enter_mob(usr, FALSE)

/datum/objective_memory_interface/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE
