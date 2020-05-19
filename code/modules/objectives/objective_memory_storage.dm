//A datum for storing objective data in the mind in an organised fashion
datum/objective_memory_storage
	var/list/datum/cm_objective/folders = list()
	var/list/datum/cm_objective/progress_reports = list()
	var/list/datum/cm_objective/technical_manuals = list()
	var/list/datum/cm_objective/terminals = list()
	var/list/datum/cm_objective/disks = list()
	var/list/datum/cm_objective/retrieve_items = list()
	var/list/datum/cm_objective/other = list()

//this is an objective that the player has just completed
//and we want to store the objective clues generated based on it -spookydonut
/datum/objective_memory_storage/proc/store_objective(var/datum/cm_objective/O)
	for(var/datum/cm_objective/R in O.enables_objectives)
		if(istype(R, /datum/cm_objective/document/folder))
			if(!(R in folders))
				folders += R
		else if(istype(R, /datum/cm_objective/document/progress_report))
			if(!(R in progress_reports))
				progress_reports += R
		else if(istype(R, /datum/cm_objective/document/technical_manual))
			if(!(R in technical_manuals))
				technical_manuals += R
		else if(istype(R, /datum/cm_objective/retrieve_data/terminal))
			if(!(R in terminals))
				terminals += R
		else if(istype(R, /datum/cm_objective/retrieve_data/disk))
			if(!(R in disks))
				disks += R
		else if(istype(R, /datum/cm_objective/retrieve_item))
			if(!(R in retrieve_items))
				retrieve_items += R
		else if(!(R in other))
			other += R


/datum/objective_memory_storage/proc/view_objective_memories(mob/recipient, var/real_name)
	var/output
	
	// Do we have DEFCON?
	if(objectives_controller)
		output += "<b>DEFCON [defcon_controller.current_defcon_level]:</b> [defcon_controller.check_defcon_percentage()]%"
					
		output += format_objective_list(folders, "FOLDERS")
		output += format_objective_list(progress_reports, "PROGRESS REPORTS")
		output += format_objective_list(technical_manuals, "TECHNICAL MANUALS")
		output += format_objective_list(disks, "DISKS")
		output += format_objective_list(terminals, "TERMINALS")
		output += format_objective_list(retrieve_items, "RETRIEVE ITEMS")
		output += format_objective_list(other, "OTHER")

		output += "<br>"
		output += "<hr>"
		output += "<br>"

		// Item and body retrieval %, power, etc.
		output += objectives_controller.get_objectives_progress()
	var/window_name = "objective clues"
	if(real_name)
		window_name = "[real_name]'s objective clues"

	show_browser(recipient, output, window_name, "objectivesmemory")

/datum/objective_memory_storage/proc/format_objective_list(var/list/datum/cm_objective/os, var/category)
	var/output = ""
	if (!os || !os.len)
		return output

	var/something_to_display = FALSE
	for(var/datum/cm_objective/O in os)
		if(!O)
			continue
		if(!O.is_prerequisites_completed() || !O.is_active())
			continue
		if(O.display_flags & OBJ_DISPLAY_HIDDEN)
			continue
		if(O.is_complete())
			continue
		output += "<BR>[O.get_clue()]"
		something_to_display = TRUE

	if (something_to_display)
		output = "<br><hr><b>[category]</b>" + output
	return output