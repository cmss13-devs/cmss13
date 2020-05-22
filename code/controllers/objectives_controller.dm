
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
	var/bonus_admin_points = 0 //bonus points given by admins, doesn't increase the point cap, but does increase points for easier rewards

	var/nextDChatAnnouncement = MINUTES_5 //5 minutes in

/datum/controller/objectives_controller/New()
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
	// Setup some global objectives
	objectives_controller.power = new /datum/cm_objective/establish_power
	objectives_controller.comms = new /datum/cm_objective/communications
	objectives_controller.marines = new /datum/cm_objective/recover_corpses/marines
	objectives_controller.xenos = new /datum/cm_objective/recover_corpses/xenos
	//objectives_controller.add_objective(new /datum/cm_objective/minimise_losses/squad_marines)
	objectives_controller.add_objective(new /datum/cm_objective/recover_corpses/colonists)
	objectives_controller.active_objectives += objectives_controller.power
	objectives_controller.active_objectives += objectives_controller.comms
	return 1

/datum/controller/objectives_controller/proc/get_total_points()
	var/total_points = 0

	for(var/datum/cm_objective/L in objectives)
		total_points += L.total_point_value()

	for(var/L in chemical_gen_classes_list["C5"])
		total_points += chemical_objective_list[L]

	for(var/L in chemical_gen_classes_list["C6"])
		total_points += chemical_objective_list[L]

	return total_points

/datum/controller/objectives_controller/proc/get_scored_points()
	var/scored_points = 0 + bonus_admin_points//bonus points only apply to scored points, not to total, to make admin lives easier

	for(var/datum/cm_objective/L in objectives)
		scored_points += L.get_point_value()

	for(var/L in chemical_gen_classes_list["C5"])
		if(chemical_identified_list[L])
			scored_points += chemical_identified_list[L]

	for(var/L in chemical_gen_classes_list["C6"])
		if(chemical_identified_list[L])
			scored_points += chemical_identified_list[L]

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