
var/global/datum/controller/objectives_controller/objectives_controller

/datum/controller/objectives_controller
	name = "Objectives controller"
	var/list/objectives = list()
	var/list/active_objectives = list()
	var/list/inactive_objectives = list()
	var/list/non_processing_objectives = list()
	var/datum/cm_objective/communications/comms
	var/datum/cm_objective/establish_power/power
	var/datum/cm_objective/recover_corpses/marines/marines
	var/datum/cm_objective/recover_corpses/xenos/xenos
	var/datum/cm_objective/contain/contain
	var/datum/cm_objective/analyze_chems/chems
	var/bonus_admin_points = 0 //bonus points given by admins, doesn't increase the point cap, but does increase points for easier rewards

	var/nextDChatAnnouncement = MINUTES_5 //5 minutes in

/datum/controller/objectives_controller/proc/generate_objectives()
	if(objective_spawn_close.len == 0 || objective_spawn_medium.len == 0 || objective_spawn_far.len == 0 || objective_spawn_science.len == 0)
		//The map doesn't have the correct landmarks, so we generate nothing, hoping the map has normal objectives
		return

	//roughly the numbers LV has:
	var/paper_scraps = 40
	var/progress_reports = 15
	var/folders = 30
	var/technical_manuals = 10
	var/disks = 30
	var/experimental_devices = 15

	var/research_papers = 15
	var/vial_boxes = 20

	//A stub of tweaking item spawns based on map
	switch(map_tag)
		if(MAP_CORSAT)
			vial_boxes = 30
			research_papers = 30
			experimental_devices = 20

	//Calculating document ratios so we don't end up with filing cabinets holding 10 documents because there are few filing cabinets
	var/relative_document_ratio_close = objective_spawn_close_documents.len / objective_spawn_close.len
	var/relative_document_ratio_medium = objective_spawn_medium_documents.len / objective_spawn_medium.len
	var/relative_document_ratio_far = objective_spawn_far_documents.len / objective_spawn_far.len
	var/relative_document_ratio_science = objective_spawn_science_documents.len / objective_spawn_science.len

	//Intel
	for(var/i=0;i<paper_scraps;i++)
		var/dest = pick(20;"close", 5;"medium", 2;"far", 10;"science", 40*relative_document_ratio_close;"close_documents", 10*relative_document_ratio_medium;"medium_documents", 3*relative_document_ratio_far;"far_documents", 10*relative_document_ratio_science;"science_documents")
		spawn_objective_at_landmark(dest, /obj/item/document_objective/paper)
	for(var/i=0;i<progress_reports;i++)
		var/dest = pick(10;"close", 55;"medium", 3;"far", 10;"science", 20*relative_document_ratio_close;"close_documents", 30*relative_document_ratio_medium;"medium_documents", 3*relative_document_ratio_far;"far_documents", 10*relative_document_ratio_science;"science_documents")
		spawn_objective_at_landmark(dest, /obj/item/document_objective/report)
	for(var/i=0;i<folders;i++)
		var/dest = pick(20;"close", 5;"medium", 2;"far", 10;"science", 40*relative_document_ratio_close;"close_documents", 10*relative_document_ratio_medium;"medium_documents", 3*relative_document_ratio_far;"far_documents", 10*relative_document_ratio_science;"science_documents")
		spawn_objective_at_landmark(dest, /obj/item/document_objective/folder)
	for(var/i=0;i<technical_manuals;i++)
		var/dest = pick(20;"close", 40;"medium", 20;"far", 20;"science")
		spawn_objective_at_landmark(dest, /obj/item/document_objective/technical_manual)
	for(var/i=0;i<disks;i++)
		var/dest = pick(20;"close", 40;"medium", 20;"far", 20;"science")
		spawn_objective_at_landmark(dest, /obj/item/disk/objective)
	for(var/i=0;i<experimental_devices;i++)
		var/dest = pick(10;"close", 20;"medium", 40;"far", 30;"science")
		var/ex_dev = pick(
			/obj/item/device/mass_spectrometer/adv/objective,
			/obj/item/device/reagent_scanner/adv/objective,
			/obj/item/device/healthanalyzer/objective,
			/obj/item/device/autopsy_scanner/objective,
		)
		spawn_objective_at_landmark(dest, ex_dev)

	//Research
	for(var/i=0;i<research_papers;i++)
		var/dest = pick(10;"close", 8;"medium", 2;"far", 20;"science", 15;"close_documents", 12;"medium_documents", 3;"far_documents", 30;"science_documents")
		spawn_objective_at_landmark(dest, /obj/item/paper/research_notes)
	for(var/i=0;i<vial_boxes;i++)
		var/dest = pick(15;"close", 30;"medium", 5;"far", 50;"science")
		spawn_objective_at_landmark(dest, /obj/item/storage/fancy/vials/random)
	clear_objective_landmarks()

/datum/controller/objectives_controller/proc/clear_objective_landmarks()
	//Don't need them anymore, so we remove them
	objective_spawn_close = null
	objective_spawn_medium = null
	objective_spawn_far = null
	objective_spawn_science = null
	objective_spawn_close_documents = null
	objective_spawn_medium_documents = null
	objective_spawn_far_documents = null
	objective_spawn_science_documents = null

/datum/controller/objectives_controller/proc/spawn_objective_at_landmark(var/dest, var/obj/item/it)
	var/picked_locaton
	switch(dest)
		if("close")
			picked_locaton = pick(objective_spawn_close)
		if("medium")
			picked_locaton = pick(objective_spawn_medium)
		if("far")
			picked_locaton = pick(objective_spawn_far)
		if("science")
			picked_locaton = pick(objective_spawn_science)

		if("close_documents")
			if(objective_spawn_close_documents.len)
				picked_locaton = pick(objective_spawn_close_documents)
			if(!picked_locaton)
				picked_locaton = pick(objective_spawn_close)
		if("medium_documents")
			if(objective_spawn_medium_documents.len)
				picked_locaton = pick(objective_spawn_medium_documents)
			if(!picked_locaton)
				picked_locaton = pick(objective_spawn_medium)
		if("far_documents")
			if(objective_spawn_far_documents.len)
				picked_locaton = pick(objective_spawn_far_documents)
			if(!picked_locaton)
				picked_locaton = pick(objective_spawn_far)
		if("science_documents")
			if(objective_spawn_science_documents.len)
				picked_locaton = pick(objective_spawn_science_documents)
			if(!picked_locaton)
				picked_locaton = pick(objective_spawn_science)

	if(!picked_locaton)
		CRASH("Unable to pick a location at [dest] for [it]")

	var/generated = FALSE
	for(var/obj/O in picked_locaton)
		if(istype(O, /obj/structure/closet) || istype(O, /obj/structure/safe) || istype(O, /obj/structure/filingcabinet))
			if(istype(O, /obj/structure/closet))
				var/obj/structure/closet/c = O
				if(c.opened)
					continue //container is open, don't put stuff into it
			var/obj/item/IT = new it(O)
			O.contents += IT
			generated = TRUE
			break

	if(!generated)
		new it(picked_locaton)


/datum/controller/objectives_controller/proc/connect_objectives()
	for(var/datum/cm_objective/C in cm_objectives)
		if(!(C in objectives))
			objectives += C
		if(C.objective_flags & OBJ_PROCESS_ON_DEMAND)
			non_processing_objectives += C
		else
			inactive_objectives += C
	setup_tree()
	for(var/datum/cm_objective/N in non_processing_objectives)
		N.activate()

/hook/roundstart/proc/setup_objectives()
	if(objectives_controller)
		objectives_controller.pre_round_start()
		objectives_controller.post_round_start()
	return 1

/datum/controller/objectives_controller/proc/pre_round_start()
	for(var/datum/cm_objective/O in objectives)
		O.pre_round_start()

/datum/controller/objectives_controller/proc/post_round_start()
	for(var/datum/cm_objective/O in objectives)
		O.post_round_start()

/datum/controller/objectives_controller/proc/get_objectives_progress()
	var/point_total = 0
	var/complete = 0

	var/list/categories = list()
	var/list/notable_objectives = list()

	for(var/datum/cm_objective/C in objectives)
		if(C.display_category)
			if(!(C.display_category in categories))
				categories += C.display_category
				categories[C.display_category] = list("count" = 0, "total" = 0, "complete" = 0)
			categories[C.display_category]["count"]++
			categories[C.display_category]["total"] += C.total_point_value()
			categories[C.display_category]["complete"] += C.get_point_value()

		if(C.display_flags & OBJ_DISPLAY_AT_END)
			notable_objectives += C

		point_total += C.total_point_value()
		complete += C.get_point_value()

	var/dat = ""
	if(objectives.len) // protect against divide by zero
		dat = "<b>Total Objectives:</b> [complete]pts completed ([round(100.0*complete/point_total)]%)<br>"
		if(categories.len)
			var/total = 1 //To avoid divide by zero errors, just in case...
			var/compl
			for(var/cat in categories)
				total = categories[cat]["total"]
				compl = categories[cat]["complete"]
				if(total == 0)
					total = 1 //To avoid divide by zero errors, just in case...
				dat += "<b>[cat]: </b> [compl]pts completed ([round(100.0*compl/total)]%)<br>"

		for(var/datum/cm_objective/O in notable_objectives)
			dat += O.get_readable_progress()

	return dat

/datum/controller/objectives_controller/proc/setup_tree()
	//Sets up the objective interdependance tree
	//Every objective that is not a dead end enables an objective of a higher tier
	//Every objective that needs prerequisites gets them from objectives of lower tier
	//If an objective doesn't need prerequisites, it can't be picked by lower tiers
	//If an objective is a dead end, it can't be picked by higher tiers

	var/list/no_value = list()
	var/list/low_value = list()
	var/list/low_value_with_prerequisites = list()
	var/list/med_value = list()
	var/list/med_value_with_prerequisites = list()
	var/list/high_value = list()
	var/list/high_value_with_prerequisites = list()
	var/list/extreme_value = list()
	var/list/extreme_value_with_prerequisites = list()
	var/list/absolute_value = list()
	var/list/absolute_value_with_prerequisites = list()

	for(var/datum/cm_objective/O in objectives)
		if(O.objective_flags & OBJ_DO_NOT_TREE)
			continue // exempt from the tree
		switch(O.priority)
			if(OBJECTIVE_NO_VALUE)
				no_value += O
			if(OBJECTIVE_LOW_VALUE)
				low_value += O
				if(O.prerequisites_required != PREREQUISITES_NONE)
					low_value_with_prerequisites += O
			if(OBJECTIVE_MEDIUM_VALUE)
				med_value += O
				if(O.prerequisites_required != PREREQUISITES_NONE)
					med_value_with_prerequisites += O
			if(OBJECTIVE_HIGH_VALUE)
				high_value += O
				if(O.prerequisites_required != PREREQUISITES_NONE)
					high_value_with_prerequisites += O
			if(OBJECTIVE_EXTREME_VALUE)
				extreme_value += O
				if(O.prerequisites_required != PREREQUISITES_NONE)
					extreme_value_with_prerequisites += O
			if(OBJECTIVE_ABSOLUTE_VALUE)
				absolute_value += O
				if(O.prerequisites_required != PREREQUISITES_NONE)
					absolute_value_with_prerequisites += O

	var/datum/cm_objective/enables
	for(var/datum/cm_objective/N in no_value)
		if(!low_value_with_prerequisites || !low_value_with_prerequisites.len)
			break
		if(N.objective_flags & OBJ_DEAD_END)
			no_value -= N // stop it being picked
			continue
		enables = pick(low_value_with_prerequisites)
		if(!enables)
			break
		N.enables_objectives += enables
		enables.required_objectives += N
	for(var/datum/cm_objective/L in low_value)
		while(L.required_objectives.len < L.number_of_clues_to_generate && no_value.len)
			var/datum/cm_objective/req = pick(no_value)
			if(req in L.required_objectives)
				continue //don't want to pick the same thing twice
			L.required_objectives += req
			req.enables_objectives += L
		if(!med_value_with_prerequisites || !med_value_with_prerequisites.len)
			break
		if(L.objective_flags & OBJ_DEAD_END)
			low_value -= L
			continue
		enables = pick(med_value_with_prerequisites)
		if(!enables)
			break
		L.enables_objectives += enables
		enables.required_objectives += L
	for(var/datum/cm_objective/M in med_value)
		while(M.required_objectives.len < M.number_of_clues_to_generate && low_value.len)
			var/datum/cm_objective/req = pick(low_value)
			if(req in M.required_objectives)
				continue //don't want to pick the same thing twice
			M.required_objectives += req
			req.enables_objectives += M
		if(!high_value_with_prerequisites || !high_value_with_prerequisites.len)
			break
		if(M.objective_flags & OBJ_DEAD_END)
			med_value -= M
			continue
		enables = pick(high_value_with_prerequisites)
		if(!enables)
			break
		M.enables_objectives += enables
		enables.required_objectives += M
	for(var/datum/cm_objective/H in high_value)
		while(H.required_objectives.len < H.number_of_clues_to_generate && med_value.len)
			var/datum/cm_objective/req = pick(med_value)
			if(req in H.required_objectives)
				continue //don't want to pick the same thing twice
			H.required_objectives += req
			req.enables_objectives += H
		if(!extreme_value_with_prerequisites || !extreme_value_with_prerequisites.len)
			break
		if(H.objective_flags & OBJ_DEAD_END)
			high_value -= H
			continue
		enables = pick(extreme_value_with_prerequisites)
		if(!enables)
			break
		H.enables_objectives += enables
		enables.required_objectives += H
	for(var/datum/cm_objective/E in extreme_value)
		while(E.required_objectives.len < E.number_of_clues_to_generate && high_value.len)
			var/datum/cm_objective/req = pick(high_value)
			if(req in E.required_objectives)
				continue //don't want to pick the same thing twice
			E.required_objectives += req
			req.enables_objectives += E
		if(!absolute_value_with_prerequisites || !absolute_value_with_prerequisites.len)
			break
		if(E.objective_flags & OBJ_DEAD_END)
			extreme_value -= E
			continue
		enables = pick(absolute_value_with_prerequisites)
		if(!enables)
			break
		E.enables_objectives += enables
		enables.required_objectives += E
	for(var/datum/cm_objective/A in absolute_value)
		while(A.required_objectives.len < A.number_of_clues_to_generate && extreme_value.len)
			var/datum/cm_objective/req = pick(extreme_value)
			if(req in A.required_objectives)
				continue //don't want to pick the same thing twice
			A.required_objectives += req
			req.enables_objectives += A

/datum/controller/objectives_controller/proc/add_objective(var/datum/cm_objective/O)
	if(!(O in objectives))
		objectives += O
	if((O.objective_flags & OBJ_PROCESS_ON_DEMAND) && !(O in non_processing_objectives))
		non_processing_objectives += O
	else if(!(O in inactive_objectives))
		inactive_objectives += O
		O.activate()

/datum/controller/objectives_controller/proc/remove_objective(var/datum/cm_objective/O)
	objectives -= O
	non_processing_objectives -= O
	inactive_objectives -= O
	active_objectives -= O

/hook/startup/proc/create_objectives_controller()
	objectives_controller = new /datum/controller/objectives_controller
	objectives_controller.generate_objectives()
	objectives_controller.connect_objectives()
	// Setup some global objectives
	objectives_controller.power = new /datum/cm_objective/establish_power
	objectives_controller.comms = new /datum/cm_objective/communications
	objectives_controller.marines = new /datum/cm_objective/recover_corpses/marines
	objectives_controller.xenos = new /datum/cm_objective/recover_corpses/xenos
	objectives_controller.contain = new /datum/cm_objective/contain
	objectives_controller.chems = new /datum/cm_objective/analyze_chems
	//objectives_controller.add_objective(new /datum/cm_objective/minimise_losses/squad_marines)
	objectives_controller.add_objective(new /datum/cm_objective/recover_corpses/colonists)
	objectives_controller.active_objectives += objectives_controller.power
	objectives_controller.active_objectives += objectives_controller.comms
	return 1

/datum/controller/objectives_controller/proc/get_total_points()
	var/total_points = 0

	for(var/datum/cm_objective/L in objectives)
		total_points += L.total_point_value()

	return total_points

/datum/controller/objectives_controller/proc/get_scored_points()
	var/scored_points = 0 + bonus_admin_points//bonus points only apply to scored points, not to total, to make admin lives easier

	for(var/datum/cm_objective/L in objectives)
		scored_points += L.get_point_value()

	return scored_points

/datum/controller/objectives_controller/proc/get_objective_completion_stats()
	var/total_points = get_total_points()
	var/scored_points = get_scored_points()

	var/list/answer = list()
	answer["scored_points"] = scored_points
	answer["total_points"] = total_points

	if(world.time > nextDChatAnnouncement)
		nextDChatAnnouncement += MINUTES_5 //5 minutes

		for(var/mob/M in player_list)
			//Announce the numbers to deadchat
			if (isobserver(M))
				to_chat(M, "<h2 class='alert'>DEFCON Level [defcon_controller.current_defcon_level]</h2>")
				to_chat(M, SPAN_WARNING("Objectives status: [scored_points] / [total_points] ([scored_points/total_points*100]%)."))

		message_staff("Objectives status: [scored_points] / [total_points] ([scored_points/total_points*100]%). DEFCON Level [defcon_controller.current_defcon_level].", 1)

	return answer

/datum/controller/objectives_controller/proc/add_admin_points(var/amount)
	bonus_admin_points += amount
	defcon_controller.check_defcon_level()