SUBSYSTEM_DEF(objectives)
	name = "Objectives"
	init_order = SS_INIT_OBJECTIVES
	wait = 5.5 SECONDS
	var/list/objectives = list()
	var/list/active_objectives = list()
	// var/list/inactive_objectives = list()
	var/list/non_processing_objectives = list()
	// var/datum/cm_objective/communications/comms
	// var/datum/cm_objective/power/establish_power/power
	// var/datum/cm_objective/power/repair_apcs/repair_apcs
	// var/datum/cm_objective/power/destroy_apcs/destroy_apcs
	// var/datum/cm_objective/recover_corpses/corpsewar
	// var/datum/cm_objective/contain/contain
	// var/datum/cm_objective/analyze_chems/chems
	var/next_sitrep = SITREP_INTERVAL
	// var/corpses = 15

	// Controller runtime
	var/list/datum/cm_objective/current_active_run = list()

/datum/controller/subsystem/objectives/Initialize(start_timeofday)
	. = ..()

	// Setup some global objectives
	// power = new
	// repair_apcs = new
	// destroy_apcs = new
	// comms = new
	// corpsewar = new
	// contain = new
	// chems = new
	// active_objectives += power

	RegisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP, .proc/pre_round_start)
	RegisterSignal(SSdcs, COMSIG_GLOB_MODE_POSTSETUP, .proc/post_round_start)

/datum/controller/subsystem/objectives/fire(resumed = FALSE)
	if(!resumed)
		// current_inactive_run = inactive_objectives.Copy()
		current_active_run = active_objectives.Copy()

		if(world.time > next_sitrep)
			next_sitrep = world.time + SITREP_INTERVAL
			announce_stats()
			if(MC_TICK_CHECK)
				return

	while(length(current_active_run))
		var/datum/cm_objective/O = current_active_run[length(current_active_run)]
		current_active_run.len--
		O.process()
		O.check_completion()
		// O.award_points()
		if(O.complete)
			O.deactivate()
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/objectives/proc/announce_stats()
	var/scored_points
	var/total_points
	var/datum/techtree/tree

	total_points = get_total_points(TREE_MARINE)
	scored_points = get_scored_points(TREE_MARINE)
	tree = GET_TREE(TREE_MARINE)

	ai_silent_announcement("Tier [tree.tier.tier] assets active. [round(tree.points, 0.1)] tech points available.", ":v", TRUE)
	ai_silent_announcement("Estimating [scored_points] / [total_points] objective points achieved.", ":i", TRUE)
	message_staff("Marine objectives status: [scored_points] / [total_points] points, active tier [tree.tier.tier], [round(tree.points, 0.1)] tech points available.")
	to_chat(GLOB.observer_list, "<h2 class='alert'>Objectives report</h2>")
	to_chat(GLOB.observer_list, SPAN_WARNING("Marine objectives status: [scored_points] / [total_points] points, active tier [tree.tier.tier], [round(tree.points, 0.1)] tech points."))

	total_points = get_total_points(TREE_XENO)
	scored_points = get_scored_points(TREE_XENO)
	tree = GET_TREE(TREE_XENO)

	xeno_message(SPAN_XENOANNOUNCE("The hive recollects having achieved [scored_points] / [total_points] points of its current objectives."), 2)
	message_staff("Xeno objectives status: [scored_points] / [total_points] points, active tier [tree.tier.tier], [round(tree.points, 0.1)] tech points available.")
	to_chat(GLOB.observer_list, SPAN_WARNING("Xeno objectives status: [scored_points] / [total_points] points, active tier [tree.tier.tier], [round(tree.points, 0.1)] tech points."))

/// Allows to perform objective initialization later on in case of map changes
/datum/controller/subsystem/objectives/proc/initialize_objectives()
	SHOULD_NOT_SLEEP(TRUE)
	generate_objectives()
	connect_objectives()
	// generate_corpses(corpses)

/datum/controller/subsystem/objectives/proc/generate_objectives()
	if(!length(GLOB.objective_landmarks_close) || !length(GLOB.objective_landmarks_medium) \
	|| !length(GLOB.objective_landmarks_far)   || !length(GLOB.objective_landmarks_science))
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
	switch(SSmapping.configs[GROUND_MAP])
		if(MAP_LV_624)
			paper_scraps = 35
			progress_reports = 12
			folders = 25
			disks = 25
		if(MAP_CORSAT)
			vial_boxes = 30
			research_papers = 30
			experimental_devices = 20

	//Calculating document ratios so we don't end up with filing cabinets holding 10 documents because there are few filing cabinets
	// TODO: use less dumb structuring than legacy one
	var/relative_document_ratio_close = 0
	for(var/key in GLOB.objective_landmarks_close)
		if(GLOB.objective_landmarks_close[key])
			relative_document_ratio_close++
	relative_document_ratio_close /= length(GLOB.objective_landmarks_close)

	var/relative_document_ratio_medium = 0
	for(var/key in GLOB.objective_landmarks_medium)
		if(GLOB.objective_landmarks_medium[key])
			relative_document_ratio_medium++
	relative_document_ratio_medium /= length(GLOB.objective_landmarks_medium)

	var/relative_document_ratio_far = 0
	for(var/key in GLOB.objective_landmarks_far)
		if(GLOB.objective_landmarks_far[key])
			relative_document_ratio_far++
	relative_document_ratio_far /= length(GLOB.objective_landmarks_far)

	var/relative_document_ratio_science = 0
	for(var/key in GLOB.objective_landmarks_science)
		if(GLOB.objective_landmarks_science[key])
			relative_document_ratio_science++
	relative_document_ratio_science /= length(GLOB.objective_landmarks_science)

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

/datum/controller/subsystem/objectives/proc/generate_corpses(corpses)
	var/list/obj/effect/landmark/corpsespawner/objective_spawn_corpse = GLOB.corpse_spawns.Copy()
	while(corpses--)
		if(!length(objective_spawn_corpse))
			break
		var/obj/effect/landmark/corpsespawner/spawner = pick(objective_spawn_corpse)
		var/turf/spawnpoint = get_turf(spawner)
		if(spawnpoint)
			var/mob/living/carbon/human/M = new /mob/living/carbon/human(spawnpoint)
			M.create_hud() //Need to generate hud before we can equip anything apparently...
			arm_equipment(M, "Corpse - [spawner.name]", TRUE, FALSE)
		objective_spawn_corpse.Remove(spawner)

/datum/controller/subsystem/objectives/proc/spawn_objective_at_landmark(var/dest, var/obj/item/it)
	var/picked_location
	switch(dest)
		if("close")
			picked_location = pick(GLOB.objective_landmarks_close)
		if("medium")
			picked_location = pick(GLOB.objective_landmarks_medium)
		if("far")
			picked_location = pick(GLOB.objective_landmarks_far)
		if("science")
			picked_location = pick(GLOB.objective_landmarks_science)

		if("close_documents")
			var/list/candidates = list()
			for(var/key in GLOB.objective_landmarks_close)
				if(GLOB.objective_landmarks_close[key])
					candidates += key
			picked_location = SAFEPICK(candidates)
			if(!picked_location)
				picked_location = pick(GLOB.objective_landmarks_close)

		if("medium_documents")
			var/list/candidates = list()
			for(var/key in GLOB.objective_landmarks_medium)
				if(GLOB.objective_landmarks_medium[key])
					candidates += key
			picked_location = SAFEPICK(candidates)
			if(!picked_location)
				picked_location = pick(GLOB.objective_landmarks_medium)

		if("far_documents")
			var/list/candidates = list()
			for(var/key in GLOB.objective_landmarks_far)
				if(GLOB.objective_landmarks_far[key])
					candidates += key
			picked_location = SAFEPICK(candidates)
			if(!picked_location)
				picked_location = pick(GLOB.objective_landmarks_far)

		if("science_documents")
			var/list/candidates = list()
			for(var/key in GLOB.objective_landmarks_science)
				if(GLOB.objective_landmarks_science[key])
					candidates += key
			picked_location = SAFEPICK(candidates)
			if(!picked_location)
				picked_location = pick(GLOB.objective_landmarks_science)

	picked_location = get_turf(picked_location)
	if(!picked_location)
		CRASH("Unable to pick a location at [dest] for [it]")

	var/generated = FALSE
	for(var/obj/O in picked_location)
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
		new it(picked_location)

/datum/controller/subsystem/objectives/proc/connect_objectives()
	for(var/datum/cm_objective/C in objectives)
		if(!(C in objectives))
			objectives += C
		if(C.objective_flags & OBJ_PROCESS_ON_DEMAND)
			non_processing_objectives += C
		else
			// inactive_objectives += C
	setup_tree()
	for(var/datum/cm_objective/N in non_processing_objectives)
		N.activate()

/datum/controller/subsystem/objectives/proc/pre_round_start()
	SIGNAL_HANDLER
	initialize_objectives()
	for(var/datum/cm_objective/O in objectives)
		O.pre_round_start()

/datum/controller/subsystem/objectives/proc/post_round_start()
	SIGNAL_HANDLER
	for(var/datum/cm_objective/O in objectives)
		O.post_round_start()

/datum/controller/subsystem/objectives/proc/get_objectives_progress(tree = TREE_NONE)
	var/point_total = 0
	var/complete = 0

	var/list/categories = list()
	var/list/notable_objectives = list()

	for(var/datum/cm_objective/C as anything in objectives)
		if(!C.observable_by_faction(tree))
			continue
		if(C.display_category)
			if(!(C.display_category in categories))
				categories += C.display_category
				categories[C.display_category] = list("count" = 0, "total" = 0, "complete" = 0)
			categories[C.display_category]["count"]++
			// categories[C.display_category]["total"] += C.total_point_value(tree)
			// categories[C.display_category]["complete"] += C.get_point_value(tree)

		if(C.display_flags & OBJ_DISPLAY_AT_END)
			notable_objectives += C

		// point_total += C.total_point_value(tree)
		// complete += C.get_point_value(tree)

	var/dat = ""
	if(LAZYLEN(objectives)) // protect against divide by zero
		dat = "<b>Total Objectives:</b> [complete]pts achieved<br>"
		if(LAZYLEN(categories))
			var/total = 1 //To avoid divide by zero errors, just in case...
			var/compl
			for(var/cat in categories)
				total = categories[cat]["total"]
				compl = categories[cat]["complete"]
				if(total == 0)
					total = 1 //To avoid divide by zero errors, just in case...
				dat += "<b>[cat]: </b> [compl]pts achieved<br>"

		for(var/datum/cm_objective/O as anything in notable_objectives)
			if(!O.observable_by_faction(tree))
				continue
			dat += O.get_readable_progress(tree)

	return dat

// Gets the total/scored amount of document points, and scores them for techpoints
// /datum/cm_objective/document/complete() already handles checking for completion, so we don't need to check that here.
// /datum/controller/subsystem/objectives/proc/score_documents(datum/cm_objective/document/D)
// 	document_score["points"] += D.value
// 	var/tp_equiv = round(document_score["points"] * OBJ_VALUE_TO_TECH_POINTS)
// 	var/diff = tp_equiv - document_score["awarded_points"]
// 	if(diff > 0)
// 		var/datum/techtree/TT = GET_TREE(TREE_MARINE)
// 		TT.add_points(diff)
// 		document_score["awarded_points"] = tp_equiv

/datum/controller/subsystem/objectives/proc/setup_tree()
	//Sets up the objective interdependence tree
	//Every objective that is not a dead end enables an objective of a higher tier
	//Every objective that needs prerequisites gets them from objectives of lower tier
	//If an objective doesn't need prerequisites, it can't be picked by lower tiers
	//If an objective is a dead end, it can't be picked by higher tiers

	var/list/no_value
	var/list/low_value
	var/list/low_value_with_prerequisites
	var/list/med_value
	var/list/med_value_with_prerequisites
	var/list/high_value
	var/list/high_value_with_prerequisites
	var/list/extreme_value
	var/list/extreme_value_with_prerequisites
	var/list/absolute_value
	var/list/absolute_value_with_prerequisites

	for(var/datum/cm_objective/O in objectives)
		if(O.objective_flags & OBJ_DO_NOT_TREE)
			continue // exempt from the tree
		switch(O.value)
			if(OBJECTIVE_NO_VALUE)
				LAZYADD(no_value, O)
			if(OBJECTIVE_LOW_VALUE)
				LAZYADD(low_value, O)
				if(O.prerequisites_required != PREREQUISITES_NONE)
					LAZYADD(low_value_with_prerequisites, O)
			if(OBJECTIVE_MEDIUM_VALUE)
				LAZYADD(med_value, O)
				if(O.prerequisites_required != PREREQUISITES_NONE)
					LAZYADD(med_value_with_prerequisites, O)
			if(OBJECTIVE_HIGH_VALUE)
				LAZYADD(high_value, O)
				if(O.prerequisites_required != PREREQUISITES_NONE)
					LAZYADD(high_value_with_prerequisites, O)
			if(OBJECTIVE_EXTREME_VALUE)
				LAZYADD(extreme_value, O)
				if(O.prerequisites_required != PREREQUISITES_NONE)
					LAZYADD(extreme_value_with_prerequisites, O)
			if(OBJECTIVE_ABSOLUTE_VALUE)
				LAZYADD(absolute_value, O)
				if(O.prerequisites_required != PREREQUISITES_NONE)
					LAZYADD(absolute_value_with_prerequisites, O)

	var/datum/cm_objective/enables
	for(var/datum/cm_objective/N in no_value)
		if(!LAZYLEN(low_value_with_prerequisites))
			break
		if(N.objective_flags & OBJ_DEAD_END)
			LAZYREMOVE(no_value, N) // stop it being picked
			continue
		enables = pick(low_value_with_prerequisites)
		if(!enables)
			break
		link_objectives(N, enables)
	for(var/datum/cm_objective/L in low_value)
		while(LAZYLEN(L.required_objectives) < L.number_of_clues_to_generate && LAZYLEN(no_value))
			var/datum/cm_objective/req = pick(no_value)
			if(req in L.required_objectives)
				continue //don't want to pick the same thing twice
			link_objectives(req, L)
		if(!LAZYLEN(med_value_with_prerequisites))
			break
		if(L.objective_flags & OBJ_DEAD_END)
			LAZYREMOVE(low_value, L)
			continue
		enables = pick(med_value_with_prerequisites)
		if(!enables)
			break
		link_objectives(L, enables)
	for(var/datum/cm_objective/M in med_value)
		while(LAZYLEN(M.required_objectives) < M.number_of_clues_to_generate && LAZYLEN(low_value))
			var/datum/cm_objective/req = pick(low_value)
			if(req in M.required_objectives)
				continue //don't want to pick the same thing twice
			link_objectives(req, M)
		if(!LAZYLEN(high_value_with_prerequisites))
			break
		if(M.objective_flags & OBJ_DEAD_END)
			LAZYREMOVE(med_value, M)
			continue
		enables = pick(high_value_with_prerequisites)
		if(!enables)
			break
		link_objectives(M, enables)
	for(var/datum/cm_objective/H in high_value)
		while(LAZYLEN(H.required_objectives) < H.number_of_clues_to_generate && LAZYLEN(med_value))
			var/datum/cm_objective/req = pick(med_value)
			if(req in H.required_objectives)
				continue //don't want to pick the same thing twice
			link_objectives(req, H)
		if(!LAZYLEN(extreme_value_with_prerequisites))
			break
		if(H.objective_flags & OBJ_DEAD_END)
			LAZYREMOVE(high_value, H)
			continue
		enables = pick(extreme_value_with_prerequisites)
		if(!enables)
			break
		link_objectives(H, enables)
	for(var/datum/cm_objective/E in extreme_value)
		while(LAZYLEN(E.required_objectives) < E.number_of_clues_to_generate && LAZYLEN(high_value))
			var/datum/cm_objective/req = pick(high_value)
			if(req in E.required_objectives)
				continue //don't want to pick the same thing twice
			link_objectives(req, E)
		if(!LAZYLEN(absolute_value_with_prerequisites))
			break
		if(E.objective_flags & OBJ_DEAD_END)
			LAZYREMOVE(extreme_value, E)
			continue
		enables = pick(absolute_value_with_prerequisites)
		if(!enables)
			break
		link_objectives(E, enables)
	for(var/datum/cm_objective/A in absolute_value)
		while(LAZYLEN(A.required_objectives) < A.number_of_clues_to_generate && LAZYLEN(extreme_value))
			var/datum/cm_objective/req = pick(extreme_value)
			if(req in A.required_objectives)
				continue //don't want to pick the same thing twice
			link_objectives(req, A)

// For linking 2 objectives together in the objective tree
/datum/controller/subsystem/objectives/proc/link_objectives(var/datum/cm_objective/required_objective, var/datum/cm_objective/enabled_objective)
	LAZYADD(enabled_objective.required_objectives, required_objective)
	LAZYADD(required_objective.enables_objectives, enabled_objective)

/datum/controller/subsystem/objectives/proc/add_objective(var/datum/cm_objective/O)
	if(!(O in objectives))
		objectives += O
	if((O.objective_flags & OBJ_PROCESS_ON_DEMAND) && !(O in non_processing_objectives))
		non_processing_objectives += O
	// else if(!(O in inactive_objectives))
	// 	inactive_objectives += O
	// 	O.activate()

/datum/controller/subsystem/objectives/proc/remove_objective(var/datum/cm_objective/O)
	objectives -= O
	non_processing_objectives -= O
	// inactive_objectives -= O
	active_objectives -= O

/datum/controller/subsystem/objectives/proc/get_total_points(tree = TREE_NONE)
	var/total_points = 0

	for(var/datum/cm_objective/L as anything in objectives)
		if(!L.observable_by_faction(tree))
			continue
		// total_points += L.total_point_value(tree)

	return total_points

/datum/controller/subsystem/objectives/proc/get_scored_points(tree = TREE_NONE)
	var/scored_points = 0

	for(var/datum/cm_objective/L in objectives)
		if(!L.observable_by_faction(tree))
			continue
		// scored_points += L.get_point_value(tree)

	return scored_points
