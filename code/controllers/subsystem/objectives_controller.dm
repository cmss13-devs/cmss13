#define CORPSES_TO_SPAWN 100

SUBSYSTEM_DEF(objectives)
	name = "Objectives"
	init_order = SS_INIT_OBJECTIVES
	wait = 5.5 SECONDS
	var/list/objectives = list()
	var/list/processing_objectives = list()
	var/datum/cm_objective/communications/comms
	var/datum/cm_objective/power/establish_power/power
	var/datum/cm_objective/recover_corpses/corpsewar
	// var/datum/cm_objective/contain/contain
	var/next_sitrep = SITREP_INTERVAL
	var/first_drop_complete = FALSE // Some objectives don't process until first drop.

	var/statistics = list()


	// Keep track of the list of objectives to process, in case we need to defer to the next tick.
	var/list/datum/cm_objective/current_active_run = list()

/datum/controller/subsystem/objectives/Initialize(start_timeofday)
	. = ..()

	statistics["documents_completed"] = 0
	statistics["documents_total_instances"] = 0
	statistics["documents_total_points_earned"] = 0

	statistics["chemicals_completed"] = 0
	statistics["chemicals_total_instances"] = 0
	statistics["chemicals_total_points_earned"] = 0

	statistics["data_retrieval_completed"] = 0
	statistics["data_retrieval_total_instances"] = 0
	statistics["data_retrieval_total_points_earned"] = 0

	statistics["item_retrieval_completed"] = 0
	statistics["item_retrieval_total_instances"] = 0
	statistics["item_retrieval_total_points_earned"] = 0

	statistics["miscellaneous_completed"] = 0
	statistics["miscellaneous_total_instances"] = 0
	statistics["miscellaneous_total_points_earned"] = 0

	statistics["survivors_rescued"] = 0
	statistics["survivors_rescued_total_points_earned"] = 0

	statistics["corpses_recovered"] = 0
	statistics["corpses_total_points_earned"] = 0

	power = new
	comms = new
	corpsewar = new

	RegisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP, PROC_REF(pre_round_start))
	RegisterSignal(SSdcs, COMSIG_GLOB_MODE_POSTSETUP, PROC_REF(post_round_start))
	RegisterSignal(SSdcs, COMSIG_GLOB_DS_FIRST_LANDED, PROC_REF(on_marine_landing))

	return SS_INIT_SUCCESS

/datum/controller/subsystem/objectives/fire(resumed = FALSE)
	if(!resumed)
		current_active_run = processing_objectives.Copy()

		if(world.time > next_sitrep && SSobjectives.first_drop_complete)
			announce_stats()
			if(MC_TICK_CHECK)
				return

	while(length(current_active_run))
		var/datum/cm_objective/O = current_active_run[length(current_active_run)]

		current_active_run.len--
		O.process()
		O.check_completion()
		if(O.state == OBJECTIVE_COMPLETE)
			stop_processing_objective(O)

		if(MC_TICK_CHECK)
			return

// Called when marines first drop
/datum/controller/subsystem/objectives/proc/on_marine_landing()
	SIGNAL_HANDLER
	first_drop_complete = TRUE
	UnregisterSignal(SSdcs, COMSIG_GLOB_DS_FIRST_LANDED)

/datum/controller/subsystem/objectives/proc/announce_stats()
	var/datum/techtree/tree = GET_TREE(TREE_MARINE)

	var/message = "TECH REPORT: [round(tree.points, 0.1)] points available"
	var/earned = round(tree.total_points - tree.total_points_last_sitrep, 0.1)
	if (earned)
		message += " (+[earned])"
	message += "."

	ai_silent_announcement(message, ":v", TRUE)
	ai_silent_announcement(message, ":t", TRUE)
	log_ares_tech(MAIN_AI_SYSTEM, FALSE, "TECH REPORT", "[round(tree.points, 0.1)] points available.", 0)
	tree.total_points_last_sitrep = tree.total_points

	next_sitrep = world.time + SITREP_INTERVAL

/// Allows to perform objective initialization later on in case of map changes
/datum/controller/subsystem/objectives/proc/initialize_objectives()
	SHOULD_NOT_SLEEP(TRUE)
	generate_objectives()
	connect_objectives()
	corpsewar.generate_corpses(CORPSES_TO_SPAWN)

/datum/controller/subsystem/objectives/proc/generate_objectives()
	if(!length(GLOB.objective_landmarks_close) || !length(GLOB.objective_landmarks_medium) \
	|| !length(GLOB.objective_landmarks_far)   || !length(GLOB.objective_landmarks_science))
		//The map doesn't have the correct landmarks, so we generate nothing, hoping the map has normal objectives
		return

	var/paper_scraps = 40
	var/progress_reports = 15
	var/folders = 30
	var/technical_manuals = 10
	var/disks = 30
	var/experimental_devices = 15
	var/research_papers = 15
	var/vial_boxes = 20
	var/research_legendary_hints = 8

	//A stub of tweaking item spawns based on map
	switch(SSmapping.configs[GROUND_MAP])
		if(MAP_LV_624)
			paper_scraps = 35
			progress_reports = 12
			folders = 25
			disks = 25
		if(MAP_CORSAT)
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
		var/dest = pick_weight(list("close" = 3,"medium" = 1, "far" = 5, "science" = 4,"close_documents" = 5, "medium_documents" = 4, "far_documents" = 3, "science_documents" = 4))
		spawn_objective_at_landmark(dest, /obj/item/paper/research_notes)
	for(var/i=0;i<research_legendary_hints;i++)//;-;
		var/dest = pick_weight(list("close" = 1,"medium" = 2, "far" = 2, "science" = 3,"close_documents" = 5, "medium_documents" = 4, "far_documents" = 3, "science_documents" = 4))
		spawn_objective_at_landmark(dest, pick_weight(list(/obj/item/paper/research_notes/leg_hint = 5, /obj/item/paper/research_notes/ciph_hint/complete = 3)))
	for(var/i=0;i<vial_boxes;i++)
		var/dest = pick_weight(list("medium" = 1, "far" = 5, "science" = 4))
		spawn_objective_at_landmark(dest, /obj/item/storage/fancy/vials/random)



// Populate the map with objective items.

/datum/controller/subsystem/objectives/proc/spawn_objective_at_landmark(dest, obj/item/it)
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

/datum/controller/subsystem/objectives/proc/pre_round_start()
	SIGNAL_HANDLER
	initialize_objectives()
	for(var/datum/cm_objective/O in objectives)
		O.pre_round_start()

/datum/controller/subsystem/objectives/proc/post_round_start()
	SIGNAL_HANDLER
	for(var/datum/cm_objective/O in objectives)
		O.post_round_start()

/datum/controller/subsystem/objectives/proc/connect_objectives()
	// Sets up the objective interdependence tree
	// Every objective (which isn't a dead end) gets one guaranteed objective it unlocks.
	// Every objective gets x random objectives that unlock it based on variable 'number_of_clues_to_generate'

	var/list/low_value
	var/list/medium_value
	var/list/high_value
	var/list/extreme_value
	var/list/absolute_value

	// Sort objectives into categories
	for(var/datum/cm_objective/O in objectives)
		if(O.objective_flags & OBJECTIVE_DO_NOT_TREE)
			continue // exempt from the tree
		switch(O.value)
			if(OBJECTIVE_LOW_VALUE)
				LAZYADD(low_value, O)
			if(OBJECTIVE_MEDIUM_VALUE)
				LAZYADD(medium_value, O)
			if(OBJECTIVE_HIGH_VALUE)
				LAZYADD(high_value, O)
			if(OBJECTIVE_EXTREME_VALUE)
				LAZYADD(extreme_value, O)
			if(OBJECTIVE_ABSOLUTE_VALUE)
				LAZYADD(absolute_value, O)

	// Set up preqrequisites:
	// Low
	for(var/datum/cm_objective/objective in low_value)
		// Add at least one guaranteed clue for this objective to unlock.
		if (!(objective.objective_flags & OBJECTIVE_DEAD_END) && LAZYLEN(medium_value))
			var/datum/cm_objective/enables = pick(medium_value)
			link_objectives(objective, enables)

	// Medium
	for(var/datum/cm_objective/objective in medium_value)
		while(LAZYLEN(objective.required_objectives) < objective.number_of_clues_to_generate && LAZYLEN(low_value))
			var/datum/cm_objective/req = pick(low_value)
			if((req in objective.required_objectives) || (req.objective_flags & OBJECTIVE_DEAD_END))
				continue //don't want to pick the same thing twice OR use a dead-end objective.
			link_objectives(req, objective)

		// Add at least one guaranteed clue for this objective to unlock.
		if (!(objective.objective_flags & OBJECTIVE_DEAD_END) && LAZYLEN(high_value))
			var/datum/cm_objective/enables = pick(high_value)
			link_objectives(objective, enables)

	// High
	for(var/datum/cm_objective/objective in high_value)
		while(LAZYLEN(objective.required_objectives) < objective.number_of_clues_to_generate && LAZYLEN(medium_value))
			var/datum/cm_objective/req = pick(medium_value)
			if((req in objective.required_objectives) || (req.objective_flags & OBJECTIVE_DEAD_END))
				continue //don't want to pick the same thing twice OR use a dead-end objective.
			link_objectives(req, objective)

		// Add at least one guaranteed clue for this objective to unlock.
		if (!(objective.objective_flags & OBJECTIVE_DEAD_END) && LAZYLEN(extreme_value))
			var/datum/cm_objective/enables = pick(extreme_value)
			link_objectives(objective, enables)

	// Extreme
	for(var/datum/cm_objective/objective in extreme_value)
		while(LAZYLEN(objective.required_objectives) < objective.number_of_clues_to_generate && LAZYLEN(high_value))
			var/datum/cm_objective/req = pick(high_value)
			if((req in objective.required_objectives) || (req.objective_flags & OBJECTIVE_DEAD_END))
				continue //don't want to pick the same thing twice OR use a dead-end objective.
			link_objectives(req, objective)

		// Add at least one guaranteed clue for this objective to unlock.
		if (!(objective.objective_flags & OBJECTIVE_DEAD_END) && LAZYLEN(absolute_value))
			var/datum/cm_objective/enables = pick(absolute_value)
			link_objectives(objective, enables)

	// Absolute
	for(var/datum/cm_objective/objective in absolute_value)
		while(LAZYLEN(objective.required_objectives) < objective.number_of_clues_to_generate && LAZYLEN(extreme_value))
			var/datum/cm_objective/req = pick(extreme_value)
			if((req in objective.required_objectives) || (req.objective_flags & OBJECTIVE_DEAD_END))
				continue //don't want to pick the same thing twice OR use a dead-end objective.
			link_objectives(req, objective)

// For linking 2 objectives together in the objective tree
/datum/controller/subsystem/objectives/proc/link_objectives(datum/cm_objective/required_objective, datum/cm_objective/enabled_objective)
	LAZYADD(enabled_objective.required_objectives, required_objective)
	LAZYADD(required_objective.enables_objectives, enabled_objective)

/datum/controller/subsystem/objectives/proc/add_objective(datum/cm_objective/O)
	LAZYADD(objectives, O)

/datum/controller/subsystem/objectives/proc/remove_objective(datum/cm_objective/O)
	LAZYREMOVE(objectives, O)

/datum/controller/subsystem/objectives/proc/start_processing_objective(datum/cm_objective/O)
	processing_objectives += O

/datum/controller/subsystem/objectives/proc/stop_processing_objective(datum/cm_objective/O)
	processing_objectives -= O
