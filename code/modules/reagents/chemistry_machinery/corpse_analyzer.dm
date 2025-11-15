#define MATH_PI 3.14159265359
/obj/structure/machinery/corpse_analyzer
	name = "corpse analyzer"
	desc = "A machine designed to analyze and process recently deceased humans."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/structures/machinery/science_machines.dmi'
	icon_state = "dispenser"
	use_power = USE_POWER_NONE
	wrenchable = FALSE
	idle_power_usage = 40
	layer = BELOW_OBJ_LAYER //So corpses reliably appear above it

	// Corpse inventory variables
	var/mob/living/carbon/human/loaded_corpse = null  // Currently loaded corpse
	var/max_corpse_capacity = 1			// How many corpses can be stored
	var/corpse_load_time = 3 SECONDS			   // Time to load/unload corpses

	var/req_skill = SKILL_MEDICAL
	var/req_skill_level = SKILL_MEDICAL_DOCTOR
	var/ui_title = "Corpse Analyzer"
	var/ui_check = 0
	var/current_graph_index = 0 // Index of the currently displayed graph
	var/list/graph_phase_modifiers = list()	 // Index-based phase storage
	var/list/graph_amplitude_modifiers = list()  // Index-based amplitude storage
	var/list/corpse_amplitude_modifiers = list() // Amplitude modifiers based on corpse data
	var/list/corpse_phase_modifiers = list()
	var/list/damage_type_map = list(
		CORPSE_BRUTE_DAMAGE,	  // Index 0
		CORPSE_BURN_DAMAGE,	   // Index 1
		CORPSE_TOXIN_DAMAGE,	 // Index 2
		CORPSE_OXYGEN_DAMAGE,	// Index 3
		CORPSE_BROKEN_BONES,	 // Index 4
		CORPSE_PAIN_DAMAGE,	   // Index 5
		CORPSE_PARASITIZATION   // Index 6
	)
	var/analysis_duration = 10.0 // Duration of analysis in seconds
	var/resolution = 200		 // Number of data points in the analysis

	// Analysis state tracking
	var/analysis_active = FALSE  // Whether analysis is currently running
	var/analysis_time_remaining = 0  // Time remaining in seconds
	var/analysis_max_time = 120  // Total time allowed for analysis (2 minutes)
	var/analysis_start_time = 0  // When analysis started


// Universal Mathematical Function Base
/datum/mathematical_function
	var/type_id
	var/list/parameters = list()
	var/name = ""
	var/color = "#ffffff"



/obj/structure/machinery/corpse_analyzer/Initialize()
	. = ..()
	for(var/i = 0; i < length(damage_type_map); i++) // ← Fixed indexing to start at 0
		graph_phase_modifiers["[i]"] = 0.0	  // Default phase: 0
		graph_amplitude_modifiers["[i]"] = 0.0  // ← Changed from 1.0 to 0.0
	start_processing()


/obj/structure/machinery/corpse_analyzer/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE



/obj/structure/machinery/corpse_analyzer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CorpseAnalyzer", name)
		ui.open()

/obj/structure/machinery/corpse_analyzer/attack_remote(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/corpse_analyzer/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		to_chat(user, SPAN_WARNING("[src] is inoperative."))
		return
	if(req_skill && !skillcheck(user, req_skill, req_skill_level))
		to_chat(user, SPAN_WARNING("You don't have the training to use [src]."))
		return
	tgui_interact(user)

// Get current graph's phase modifier
/obj/structure/machinery/corpse_analyzer/proc/get_current_phase()
	var/graph_key = "[current_graph_index]"
	return graph_phase_modifiers[graph_key] || 0.0

// Get current graph's amplitude modifier
/obj/structure/machinery/corpse_analyzer/proc/get_current_amplitude()
	var/graph_key = "[current_graph_index]"
	return graph_amplitude_modifiers[graph_key] || 0.0  // ← Changed from 1.0 to 0.0

// Set current graph's phase modifier
/obj/structure/machinery/corpse_analyzer/proc/set_current_phase(new_phase)
	var/graph_key = "[current_graph_index]"
	graph_phase_modifiers[graph_key] = clamp(new_phase, 0, 2)

// Set current graph's amplitude modifier
/obj/structure/machinery/corpse_analyzer/proc/set_current_amplitude(new_amplitude)
	var/graph_key = "[current_graph_index]"
	graph_amplitude_modifiers[graph_key] = clamp(new_amplitude, 0.0, 1.0)

/obj/structure/machinery/corpse_analyzer/proc/calculate_sinusoidal_value(amplitude, frequency, phase, time)
	return amplitude * sin(frequency * time + phase)

/obj/structure/machinery/corpse_analyzer/proc/get_selected_damage_type()
	if(current_graph_index < 0 || current_graph_index >= length(damage_type_map))
		return "brute" // Fallback to brute if index is out of bounds
	return damage_type_map[current_graph_index + 1] // DM lists are 1-indexed


/obj/structure/machinery/corpse_analyzer/ui_data(mob/user)
	. = list()
	.["current_graph_index"] = current_graph_index
	.["phase"] = get_current_phase()
	.["amplitude"] = get_current_amplitude()
	.["analysis_duration"] = analysis_duration
	.["resolution"] = resolution
	.["filter_mode"] = 1
	.["sensitivity"] = 50

	// Analysis state
	.["analysis_active"] = analysis_active
	.["analysis_time_remaining"] = analysis_time_remaining
	.["analysis_max_time"] = analysis_max_time

	// Add corpse information
	if(loaded_corpse)
		.["loaded_corpse"] = TRUE
		.["corpse_name"] = loaded_corpse.real_name || "Unknown"

		// Only show target data if analysis is active
		if(analysis_active && length(corpse_amplitude_modifiers))
			.["has_target"] = TRUE
			.["match_percentage"] = calculate_match_percentage()
		else
			.["has_target"] = FALSE
			.["match_percentage"] = 0
	else
		.["loaded_corpse"] = FALSE
		.["has_target"] = FALSE
		.["match_percentage"] = 0

	// Add current wave stats
	var/selected_damage_type = get_selected_damage_type()
	.["current_damage_type"] = uppertext(copytext(selected_damage_type, 1, 2)) + copytext(selected_damage_type, 2)

	// Get base wave properties from GLOB.research_sinusoids
	if(GLOB.research_sinusoids && GLOB.research_sinusoids[selected_damage_type] && length(GLOB.research_sinusoids[selected_damage_type]))
		var/list/wave_data = GLOB.research_sinusoids[selected_damage_type][1]
		.["base_frequency"] = wave_data["frequency"] || 1.0
		.["base_amplitude"] = wave_data["amplitude"] || 0.0
		.["base_phase"] = wave_data["phase"] || 0.0
		.["wave_color"] = wave_data["color"] || "#ffffff"
		.["wave_name"] = wave_data["name"] || "Unknown Wave"
	else
		// Fallback values
		.["base_frequency"] = 1.0
		.["base_amplitude"] = 0.0
		.["base_phase"] = 0.0
		.["wave_color"] = "#ffffff"
		.["wave_name"] = "Unknown Wave"

	.["plotData"] = generate_sum_data()	  // Top graph: player vs target
	.["componentData"] = generate_all_components()  // Bottom graph: all individual waves

// Calculate how close the player's settings are to the target using R²
/obj/structure/machinery/corpse_analyzer/proc/calculate_match_percentage()
	if(!length(corpse_amplitude_modifiers))
		return 0

	var/list/player_values = list()
	var/list/target_values = list()

	// Collect ALL values (both amplitude and phase) as one dataset
	for(var/i = 0; i < length(damage_type_map); i++)
		var/graph_key = "[i]"

		// Add amplitude values to the dataset
		var/player_amplitude = graph_amplitude_modifiers[graph_key] || 0.0
		var/target_amplitude = corpse_amplitude_modifiers[graph_key] || 0.0
		player_values += player_amplitude
		target_values += target_amplitude

		// Only add phase values if the corpse has non-zero amplitude for this damage type
		if(length(corpse_phase_modifiers) && target_amplitude > 0.0)
			var/player_phase = graph_phase_modifiers[graph_key] || 0.0
			var/target_phase = corpse_phase_modifiers[graph_key] || 0.0
			player_values += player_phase
			target_values += target_phase

	// Calculate mean of target values
	var/target_mean = 0
	for(var/i = 1; i <= length(target_values); i++)
		target_mean += target_values[i]
	target_mean /= length(target_values)

	// Calculate R² components
	var/ss_tot = 0  // Total sum of squares
	var/ss_res = 0  // Residual sum of squares

	for(var/i = 1; i <= length(target_values); i++)
		var/target_val = target_values[i]
		var/player_val = player_values[i]  // ← Fixed the tab character here

		ss_tot += (target_val - target_mean) ** 2
		ss_res += (target_val - player_val) ** 2

	// Calculate R²
	var/r_squared = 0
	if(ss_tot > 0)
		r_squared = 1 - (ss_res / ss_tot)
	else
		// Perfect match if no variance in target (all zeros)
		r_squared = (ss_res == 0) ? 1 : 0

	// Clamp to 0-1 range and convert to percentage
	r_squared = clamp(r_squared, 0.0, 1.0)
	return round(r_squared * 100, 1)


// Generate SUM of all waves for top graph WITH target line
/obj/structure/machinery/corpse_analyzer/proc/generate_sum_data()
	if(!GLOB.research_sinusoids || !length(GLOB.research_sinusoids))
		return null

	var/list/plot_data = list()
	var/list/datasets = list()
	var/time_step = analysis_duration / resolution

	// Generate PLAYER's current sum (their attempt)
	var/list/player_sum_points = list()
	for(var/i = 0; i <= resolution; i++)
		var/time = i * time_step
		var/sum_value = 0

		// Add contribution from each damage type using PLAYER's amplitude settings
		for(var/j = 0; j < length(damage_type_map); j++)
			var/damage_type = damage_type_map[j + 1]
			var/list/wave_info = GLOB.research_sinusoids[damage_type]
			if(!wave_info || !length(wave_info))
				continue
			var/list/wave_data = wave_info[1]
			var/graph_key = "[j]"
			var/graph_phase = graph_phase_modifiers[graph_key]|| 0.0
			var/graph_amplitude = graph_amplitude_modifiers[graph_key] || 0.0  // Player's settings
			var/wave_amplitude = wave_data["amplitude"] * graph_amplitude
			var/wave_frequency = wave_data["frequency"]
			var/wave_phase = (wave_data["phase"] * MATH_PI) + (graph_phase * MATH_PI)
			var/angle_degrees = (wave_frequency * time + wave_phase) * (180 / MATH_PI)
			var/wave_value = wave_amplitude * sin(angle_degrees)
			sum_value += wave_value
		player_sum_points[++player_sum_points.len] = list(time, sum_value)
	// Add player's current attempt
	datasets += list(list(
		"points" = player_sum_points,
		"color" = "#00ff00",  // Green for player's attempt
		"name" = "Your Signal"
	))
	// Generate TARGET line from corpse data (if corpse is loaded AND analysis is active)
	if(loaded_corpse && analysis_active && length(corpse_amplitude_modifiers))
		var/list/target_sum_points = list()
		for(var/i = 0; i <= resolution; i++)
			var/time = i * time_step
			var/target_sum_value = 0
			// Add contribution from each damage type using CORPSE's actual data
			for(var/j = 0; j < length(damage_type_map); j++)
				var/damage_type = damage_type_map[j + 1]
				var/list/wave_info = GLOB.research_sinusoids[damage_type]
				if(!wave_info || !length(wave_info))
					continue
				var/list/wave_data = wave_info[1]
				var/graph_key = "[j]"
				var/corpse_amplitude = corpse_amplitude_modifiers[graph_key] || 0.0
				var/corpse_phase = corpse_phase_modifiers[graph_key] || 0.0  // ← Use CORPSE phase, not player phase
				var/wave_amplitude = wave_data["amplitude"] * corpse_amplitude
				var/wave_frequency = wave_data["frequency"]
				var/wave_phase = (wave_data["phase"] * MATH_PI) + (corpse_phase * MATH_PI)  // ← Use corpse_phase with 2π range
				var/angle_degrees = (wave_frequency * time + wave_phase) * (180 / MATH_PI)
				var/wave_value = wave_amplitude * sin(angle_degrees)
				target_sum_value += wave_value
			target_sum_points[++target_sum_points.len] = list(time, target_sum_value)
		// Add the target line (what they need to match)
		datasets += list(list(
			"points" = target_sum_points,
			"color" = "#ff4444",  // Red for the target
			"name" = "Target Signal"
		))
	plot_data["datasets"] = datasets
	return plot_data

// Generate ALL individual component waves for bottom graph
/obj/structure/machinery/corpse_analyzer/proc/generate_all_components()
	if(!GLOB.research_sinusoids || !length(GLOB.research_sinusoids))
		return null

	var/list/plot_data = list()
	var/list/datasets = list()

	// Generate data for ALL damage types
	for(var/i = 0; i < length(damage_type_map); i++)
		var/damage_type = damage_type_map[i + 1]
		var/list/wave_info = GLOB.research_sinusoids[damage_type]

		if(!wave_info || !length(wave_info))
			continue

		var/list/wave_data = wave_info[1]
		var/graph_key = "[i]"
		var/graph_phase = graph_phase_modifiers[graph_key] || 0.0
		var/graph_amplitude = graph_amplitude_modifiers[graph_key] || 0.0

		var/list/graph_points = list()
		var	time_step = analysis_duration / resolution

		var/wave_amplitude = wave_data["amplitude"] * graph_amplitude
		var/wave_frequency = wave_data["frequency"]
		// Convert BOTH wave_data phase and graph_phase to radians
		var/wave_phase = (wave_data["phase"] * 3.14159) + (graph_phase * 3.14159)
		var/wave_color = wave_data["color"] || "#ffffff"


		for(var/j = 0; j <= resolution; j++)
			var	time = j * time_step
			var/angle_degrees = (wave_frequency * time + wave_phase) * (180 / MATH_PI)
			var/value = wave_amplitude * sin(angle_degrees)
			graph_points[++graph_points.len] = list(time, value)


		var/capitalized_damage_type = uppertext(copytext(damage_type, 1, 2)) + copytext(damage_type, 2)
		var/name_suffix = ""

		if(i == current_graph_index)
			name_suffix = " (Editing)"

		datasets += list(list(
			"points" = graph_points,
			"color" = wave_color,
			"name" = "[capitalized_damage_type][name_suffix]"
		))

	plot_data["datasets"] = datasets
	return plot_data

/obj/structure/machinery/corpse_analyzer/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	if(inoperable())
		return

	switch(action)
		if("next_graph")
			current_graph_index = (current_graph_index + 1) % length(damage_type_map)
			. = TRUE

		if("previous_graph")
			current_graph_index = (current_graph_index - 1 + length(damage_type_map)) % length(damage_type_map)
			. = TRUE

		if("set_phase")
			set_current_phase(params["value"])
			. = TRUE

		if("set_amplitude")
			set_current_amplitude(params["value"])
			. = TRUE

		if("unload_corpse")
			unload_corpse(usr)
			. = TRUE

		if("start_analysis")
			start_analysis(usr)
			. = TRUE

		if("stop_analysis")
			stop_analysis(usr)
			. = TRUE

// Load a corpse into the analyzer
/obj/structure/machinery/corpse_analyzer/proc/load_corpse(mob/living/carbon/human/corpse, mob/user)
	if(loaded_corpse)
		to_chat(user, SPAN_WARNING("[src] already has a corpse loaded."))
		return FALSE

	if(!ishuman(corpse))
		to_chat(user, SPAN_WARNING("This is not a human corpse."))
		return FALSE

	if(corpse.stat != DEAD)
		to_chat(user, SPAN_WARNING("[corpse] is still alive! The analyzer only works on corpses."))
		return FALSE

	// Check if the corpse is permanently dead (REQUIRED)
	//if((corpse.check_tod()))
		//to_chat(user, SPAN_WARNING("[corpse] has not been declared permanently dead. The analyzer requires finalized death data."))
		//return FALSE

	to_chat(user, SPAN_NOTICE("You begin loading [corpse]'s corpse into [src]..."))

	if(do_after(user, corpse_load_time, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		corpse.forceMove(src)
		loaded_corpse = corpse
		if(process_corpse_data())
			to_chat(user, SPAN_NOTICE("Death signature detected. Adjust wave parameters to match the target signal."))
		else
			to_chat(user, SPAN_WARNING("No death data found. Cannot generate target signal."))
		to_chat(user, SPAN_NOTICE("You load [corpse]'s corpse into [src]."))
		return TRUE
	return FALSE
// Unload the current corpse
/obj/structure/machinery/corpse_analyzer/proc/unload_corpse(mob/user)
	if(!loaded_corpse)
		to_chat(user, SPAN_WARNING("[src] doesn't have a corpse loaded."))
		return FALSE
	if(analysis_active)
		to_chat(user, SPAN_WARNING("Stop the analysis before unloading the corpse."))
		return FALSE
	if(!isturf(user.loc))
		to_chat(user, SPAN_WARNING("You need to be standing on the floor to unload the corpse."))
		return FALSE
	var/corpse_name = loaded_corpse.name
	to_chat(user, SPAN_NOTICE("You begin unloading [loaded_corpse]'s corpse from [src]..."))
	if(!do_after(user, corpse_load_time, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		return FALSE
	loaded_corpse.forceMove(user.loc)
	loaded_corpse = null
	to_chat(user, SPAN_NOTICE("You unload [corpse_name]'s corpse from [src]."))
	return TRUE

// Start analysis
/obj/structure/machinery/corpse_analyzer/proc/start_analysis(mob/user)
	if(!loaded_corpse)
		to_chat(user, SPAN_WARNING("No corpse loaded to analyze."))
		return FALSE

	if(analysis_active)
		to_chat(user, SPAN_WARNING("Analysis is already running."))
		return FALSE

	if(!length(corpse_amplitude_modifiers))
		to_chat(user, SPAN_WARNING("No death data available for analysis."))
		return FALSE

	analysis_active = TRUE
	analysis_time_remaining = analysis_max_time
	analysis_start_time = world.time
	to_chat(user, SPAN_NOTICE("Analysis started. You have [analysis_max_time] seconds to match the target signal."))
	playsound(loc, 'sound/machines/terminal_processing.ogg', 25, FALSE)
	return TRUE

// Stop analysis
/obj/structure/machinery/corpse_analyzer/proc/stop_analysis(mob/user)
	if(!analysis_active)
		to_chat(user, SPAN_WARNING("No analysis is running."))
		return FALSE

	var/match_percent = calculate_match_percentage()
	analysis_active = FALSE
	analysis_time_remaining = 0

	to_chat(user, SPAN_NOTICE("Analysis stopped. Final match: [match_percent]%"))

	if(match_percent >= 90)
		to_chat(user, SPAN_BOLDNOTICE("Excellent match! Death signature successfully analyzed."))
		playsound(loc, 'sound/machines/terminal_success.ogg', 25, FALSE)
	else if(match_percent >= 70)
		to_chat(user, SPAN_NOTICE("Good match. Death signature partially analyzed."))
		playsound(loc, 'sound/machines/terminal_success.ogg', 25, FALSE)
	else
		to_chat(user, SPAN_WARNING("Poor match. Analysis incomplete."))
		playsound(loc, 'sound/machines/terminal_error.ogg', 25, FALSE)

	return TRUE
// Get the human mob from the loaded corpse
/obj/structure/machinery/corpse_analyzer/proc/get_loaded_human()
	if(!loaded_corpse)
		return null
	return loaded_corpse
// For loading corpses via dragging (like bodyscanner)
/obj/structure/machinery/corpse_analyzer/MouseDrop_T(mob/living/carbon/human/corpse, mob/living/user)
	if(!ishuman(corpse) || !ishuman(user))
		to_chat(user, SPAN_WARNING("Only humans can be analyzed."))
		return FALSE
	if(!Adjacent(user) || !user.Adjacent(corpse))
		to_chat(user, SPAN_WARNING("You need to be closer to load the corpse."))
		return FALSE
	if(user.is_mob_incapacitated())
		to_chat(user, SPAN_WARNING("You can't load corpses while incapacitated."))
		return FALSE
	load_corpse(corpse, user)
	return TRUE
// Add this proc to convert death variables to wave amplitudes
/obj/structure/machinery/corpse_analyzer/proc/process_corpse_data()
	if(!loaded_corpse || !loaded_corpse.death_variables)
		return FALSE

	var/list/death_data = loaded_corpse.death_variables

	// Get the main damage values
	var/brute = death_data[CORPSE_BRUTE_DAMAGE] || 0
	var/burn = death_data[CORPSE_BURN_DAMAGE] || 0
	var/toxin = death_data[CORPSE_TOXIN_DAMAGE] || 0
	var/oxygen = death_data[CORPSE_OXYGEN_DAMAGE] || 0

	// Calculate total damage for normalization
	var/total_damage = brute + burn + toxin + oxygen

	if(total_damage <= 0)
		corpse_amplitude_modifiers["0"] = 0.0
		corpse_amplitude_modifiers["1"] = 0.0
		corpse_amplitude_modifiers["2"] = 0.0
		corpse_amplitude_modifiers["3"] = 0.0
	else
		// Round to nearest 0.1 (1 decimal place)
		corpse_amplitude_modifiers["0"] = round((brute / total_damage) * 10) / 10
		corpse_amplitude_modifiers["1"] = round((burn / total_damage) * 10) / 10
		corpse_amplitude_modifiers["2"] = round((toxin / total_damage) * 10) / 10
		corpse_amplitude_modifiers["3"] = round((oxygen / total_damage) * 10) / 10
	process_bone_amplitude(death_data)
	process_pain_amplitude(death_data)
	corpse_amplitude_modifiers["6"] = round((death_data[CORPSE_PARASITIZATION] ? 1.0 : 0.0)/10)/10 //round to the nearest whole number, then get to 0.1 scale
	// Check for phase data and generate if missing
	if(!length(loaded_corpse.death_phase_waves))
		SEND_SIGNAL(loaded_corpse, COMSIG_DEATH_DATA_PHASE_GENERATION)

	// Process phase data if it exists
	if(length(loaded_corpse.death_phase_waves))
		corpse_phase_modifiers["0"] = loaded_corpse.death_phase_waves[CORPSE_BRUTE_DAMAGE] || 0.0
		corpse_phase_modifiers["1"] = loaded_corpse.death_phase_waves[CORPSE_BURN_DAMAGE] || 0.0
		corpse_phase_modifiers["2"] = loaded_corpse.death_phase_waves[CORPSE_TOXIN_DAMAGE] || 0.0
		corpse_phase_modifiers["3"] = loaded_corpse.death_phase_waves[CORPSE_OXYGEN_DAMAGE] || 0.0
		corpse_phase_modifiers["4"] = loaded_corpse.death_phase_waves[CORPSE_BROKEN_BONES] || 0.0
		corpse_phase_modifiers["5"] = loaded_corpse.death_phase_waves[CORPSE_PAIN_DAMAGE] || 0.0
		corpse_phase_modifiers["6"] = loaded_corpse.death_phase_waves[CORPSE_PARASITIZATION] || 0.0
	return TRUE

// Process broken bones amplitude (scale by severity)
/obj/structure/machinery/corpse_analyzer/proc/process_bone_amplitude(list/death_data)
	var/broken_bones = death_data[CORPSE_BROKEN_BONES] || 0

	// Assuming max of 10 limbs (head, chest, arms, legs)
	var/max_possible_breaks = 10
	var/bone_amplitude = clamp(broken_bones / max_possible_breaks, 0.0, 1.0)

	// Round to nearest 0.1 (1 decimal place)
	corpse_amplitude_modifiers["4"] = round(bone_amplitude * 10) / 10

// Process pain amplitude (scale by pain percentage)
/obj/structure/machinery/corpse_analyzer/proc/process_pain_amplitude(list/death_data)
	var/pain_percentage = death_data[CORPSE_PAIN_DAMAGE] || 0
	// Pain percentage should already be 0-100, convert to 0-1
	var/pain_amplitude = clamp(pain_percentage / 100.0, 0.0, 1.0)

	// Round to nearest 0.1 (1 decimal place)
	corpse_amplitude_modifiers["5"] = round(pain_amplitude * 10) / 10

// Process tick - countdown analysis timer
/obj/structure/machinery/corpse_analyzer/process(delta_time)
	if(!analysis_active)
		return

	// Decrease time remaining
	analysis_time_remaining -= delta_time

	// Check if time ran out
	if(analysis_time_remaining <= 0)
		analysis_time_remaining = 0
		analysis_active = FALSE
		visible_message(SPAN_WARNING("[src] beeps loudly as the analysis timer expires!"))
		playsound(loc, 'sound/machines/terminal_error.ogg', 50, FALSE)
