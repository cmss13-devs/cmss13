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
		store_single_objective(R)

/datum/objective_memory_storage/proc/store_single_objective(var/datum/cm_objective/O)
	if(!istype(O))
		return
	if (O.is_finalised())
		//We don't need to store the objective, it is either completed or failed and won't be coming back
		return
	if(istype(O, /datum/cm_objective/document/folder))
		addToListNoDupe(folders, O)
	else if(istype(O, /datum/cm_objective/document/progress_report))
		addToListNoDupe(progress_reports, O)
	else if(istype(O, /datum/cm_objective/document/technical_manual))
		addToListNoDupe(technical_manuals, O)
	else if(istype(O, /datum/cm_objective/retrieve_data/terminal))
		addToListNoDupe(terminals, O)
	else if(istype(O, /datum/cm_objective/retrieve_data/disk))
		addToListNoDupe(disks, O)
	else if(istype(O, /datum/cm_objective/retrieve_item))
		addToListNoDupe(retrieve_items, O)
	else
		addToListNoDupe(other, O)

//returns TRUE if we have the objective already
/datum/objective_memory_storage/proc/has_objective(var/datum/cm_objective/O)
	if(O in folders)
		return TRUE
	if(O in progress_reports)
		return TRUE
	if(O in technical_manuals)
		return TRUE
	if(O in terminals)
		return TRUE
	if(O in disks)
		return TRUE
	if(O in retrieve_items)
		return TRUE
	if(O in other)
		return TRUE
	return FALSE

/datum/objective_memory_storage/proc/view_objective_memories(mob/recipient, var/real_name)
	synchronize_objectives()
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

/datum/objective_memory_storage/proc/clean_objectives()
	for(var/datum/cm_objective/O in folders)
		if(O.is_finalised())
			folders -= O
	for(var/datum/cm_objective/O in progress_reports)
		if(O.is_finalised())
			progress_reports -= O
	for(var/datum/cm_objective/O in technical_manuals)
		if(O.is_finalised())
			technical_manuals -= O
	for(var/datum/cm_objective/O in terminals)
		if(O.is_finalised())
			terminals -= O
	for(var/datum/cm_objective/O in disks)
		if(O.is_finalised())
			disks -= O
	for(var/datum/cm_objective/O in retrieve_items)
		if(O.is_finalised())
			retrieve_items -= O
	for(var/datum/cm_objective/O in other)
		if(O.is_finalised())
			other -= O

/datum/objective_memory_storage/proc/synchronize_objectives()
	clean_objectives()
	if(!intel_system || !intel_system.oms)
		return
	intel_system.oms.clean_objectives()

	for(var/datum/cm_objective/O in intel_system.oms.folders)
		addToListNoDupe(folders, O)
	for(var/datum/cm_objective/O in intel_system.oms.progress_reports)
		addToListNoDupe(progress_reports, O)
	for(var/datum/cm_objective/O in intel_system.oms.technical_manuals)
		addToListNoDupe(technical_manuals, O)
	for(var/datum/cm_objective/O in intel_system.oms.terminals)
		addToListNoDupe(terminals, O)
	for(var/datum/cm_objective/O in intel_system.oms.disks)
		addToListNoDupe(disks, O)
	for(var/datum/cm_objective/O in intel_system.oms.retrieve_items)
		addToListNoDupe(retrieve_items, O)
	for(var/datum/cm_objective/O in intel_system.oms.other)
		addToListNoDupe(other, O)

var/global/datum/intel_system/intel_system = new()

/datum/intel_system
	var/datum/objective_memory_storage/oms = new()

/datum/intel_system/proc/store_objective(var/datum/cm_objective/O)
	oms.store_objective(O)

/datum/intel_system/proc/store_single_objective(var/datum/cm_objective/O)
	oms.store_single_objective(O)


// --------------------------------------------
// *** Upload clues with the computer ***
// --------------------------------------------
/obj/structure/machinery/computer/intel
	name = "Intel Computer"
	var/label = ""
	desc = "An USCM Intel Computer for data cataloguing and distribution."
	icon_state = "terminal1_old"
	unslashable = TRUE
	unacidable = TRUE
	var/typing_time = 20


/obj/structure/machinery/computer/intel/attack_hand(mob/living/user)
	if(!user || !istype(user) || !user.mind || !user.mind.objective_memory)
		return 0
	if(!powered())
		to_chat(user, SPAN_WARNING("This computer has no power!"))
		return 0
	if(!intel_system)
		to_chat(user, SPAN_WARNING("The computer doesn't seem to be connected to anything..."))
		return 0
	if(user.action_busy)
		return 0

	to_chat(user, SPAN_NOTICE("You start typing in intel into the computer..."))

	var/total_transferred = 0
	var/outcome = 0 //outcome of an individual upload - if something interrupts us, we cancel the rest

	for(var/datum/cm_objective/O in user.mind.objective_memory.folders)
		outcome = transfer_intel(user, O)
		if(outcome < 0)
			return 0
		if(outcome > 0)
			total_transferred++

	for(var/datum/cm_objective/O in user.mind.objective_memory.progress_reports)
		outcome = transfer_intel(user, O)
		if(outcome < 0)
			return 0
		if(outcome > 0)
			total_transferred++

	for(var/datum/cm_objective/O in user.mind.objective_memory.technical_manuals)
		outcome = transfer_intel(user, O)
		if(outcome < 0)
			return 0
		if(outcome > 0)
			total_transferred++

	for(var/datum/cm_objective/O in user.mind.objective_memory.terminals)
		outcome = transfer_intel(user, O)
		if(outcome < 0)
			return 0
		if(outcome > 0)
			total_transferred++

	for(var/datum/cm_objective/O in user.mind.objective_memory.disks)
		outcome = transfer_intel(user, O)
		if(outcome < 0)
			return 0
		if(outcome > 0)
			total_transferred++

	for(var/datum/cm_objective/O in user.mind.objective_memory.retrieve_items)
		outcome = transfer_intel(user, O)
		if(outcome < 0)
			return 0
		if(outcome > 0)
			total_transferred++

	for(var/datum/cm_objective/O in user.mind.objective_memory.other)
		outcome = transfer_intel(user, O)
		if(outcome < 0)
			return 0
		if(outcome > 0)
			total_transferred++

	if(total_transferred > 0)
		to_chat(user, SPAN_NOTICE("...and done! You uploaded [total_transferred] entries!"))
	else
		to_chat(user, SPAN_NOTICE("...and you have nothing new to add..."))

	return 1

/obj/structure/machinery/computer/intel/proc/transfer_intel(mob/living/user, var/datum/cm_objective/O)
	if(!intel_system || !intel_system.oms)
		return 0
	if(intel_system.oms.has_objective(O))
		return 0
	if(user.action_busy)
		return 0

	playsound(user, pick('sound/machines/computer_typing4.ogg', 'sound/machines/computer_typing5.ogg', 'sound/machines/computer_typing6.ogg'), 5, 1)

	if(!do_after(user, typing_time, INTERRUPT_ALL, BUSY_ICON_GENERIC)) // Can't move from the spot
		to_chat(user, SPAN_WARNING("You get distracted and lose your train of thought, you'll have to start the typing over..."))
		return -1

	to_chat(user, SPAN_NOTICE("...something about \"[O.get_clue()]\"..."))
	intel_system.store_single_objective(O)
	return 1