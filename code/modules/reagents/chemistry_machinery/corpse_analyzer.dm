// Chemical function types
#define MATH_FUNC_EXPONENTIAL_DECAY 1 // Not used yet
#define MATH_FUNC_SINE_WAVE 2
#define MATH_FUNC_LOGISTIC_GROWTH 3
#define MATH_FUNC_DOUBLE_EXPONENTIAL 4
#define MATH_FUNC_ABSORPTION_CURVE 5
/obj/structure/machinery/corpse_analyzer
	name = "corpse analyzer"
	desc = "A machine designed to analyze and process recently deceased corpses."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/structures/machinery/science_machines.dmi'
	icon_state = "dispenser"
	use_power = USE_POWER_NONE
	wrenchable = FALSE
	idle_power_usage = 40
	layer = BELOW_OBJ_LAYER //So corpses reliably appear above it
	var/req_skill = SKILL_MEDICAL
	var/req_skill_level = SKILL_MEDICAL_DOCTOR
	var/ui_title = "Corpse Analyzer"
	var/ui_check = 0
	var/current_graph_index = 0 // Index of the currently displayed graph
	var/list/graph_phase_modifiers = list()     // Index-based phase storage
	var/list/graph_amplitude_modifiers = list()  // Index-based amplitude storage
	var/list/damage_type_map = list(
		"brute",      // Index 0
		"burn",       // Index 1
	)
	var/analysis_duration = 10.0 // Duration of analysis in seconds
	var/resolution = 200         // Number of data points in the analysis


// Universal Mathematical Function Base
/datum/mathematical_function
	var/type_id
	var/list/parameters = list()
	var/name = ""
	var/color = "#ffffff"



/obj/structure/machinery/corpse_analyzer/Initialize()
	. = ..()
	for(var/i = 0; i < length(damage_type_map); i++) // ← Fixed indexing to start at 0
		graph_phase_modifiers["[i]"] = 0.0      // Default phase: 0
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
	graph_phase_modifiers[graph_key] = clamp(new_phase, 0, 1)

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
	else
		// Fallback values
		.["base_frequency"] = 1.0
		.["base_amplitude"] = 0.0
		.["base_phase"] = 0.0
		.["wave_color"] = "#ffffff"

	.["plotData"] = generate_sum_data()      // ← Top graph: sum of all waves
	.["componentData"] = generate_all_components()  // ← Bottom graph: all individual waves

// Generate SUM of all waves for top graph
/obj/structure/machinery/corpse_analyzer/proc/generate_sum_data()
    if(!GLOB.research_sinusoids || !length(GLOB.research_sinusoids))
        return null

    var/list/plot_data = list()
    var/list/datasets = list()
    var/list/sum_points = list()
    var/time_step = analysis_duration / resolution

    // Calculate sum at each time point
    for(var/i = 0; i <= resolution; i++)
        var/time = i * time_step
        var/sum_value = 0

        // Add contribution from each damage type
        for(var/j = 0; j < length(damage_type_map); j++)
            var/damage_type = damage_type_map[j + 1]
            var/list/wave_info = GLOB.research_sinusoids[damage_type]

            if(!wave_info || !length(wave_info))
                continue

            var/list/wave_data = wave_info[1]
            var/graph_key = "[j]"
            var/graph_phase = graph_phase_modifiers[graph_key] || 0.0
            var/graph_amplitude = graph_amplitude_modifiers[graph_key] || 0.0

            var/wave_amplitude = wave_data["amplitude"] * graph_amplitude
            var/wave_frequency = wave_data["frequency"]
            // Convert BOTH wave_data phase and graph_phase to radians
            var/wave_phase = (wave_data["phase"] * 3.14159) + (graph_phase * 3.14159)

            var/angle_degrees = (wave_frequency * time + wave_phase) * (180 / MATH_PI)
            var/wave_value = wave_amplitude * sin(angle_degrees)

            sum_value += wave_value

        sum_points[++sum_points.len] = list(time, sum_value)

    // Create single dataset for the sum
    datasets += list(list(
        "points" = sum_points,
        "color" = "#ffffff",  // White for the sum
        "name" = "Combined Signal"
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

        // Generate points for this damage type
        for(var/j = 0; j <= resolution; j++)
            var	time = j * time_step
            var/angle_degrees = (wave_frequency * time + wave_phase) * (180 / MATH_PI)
            var/value = wave_amplitude * sin(angle_degrees)
            graph_points[++graph_points.len] = list(time, value)

        // Add this damage type's dataset
        var/capitalized_damage_type = uppertext(copytext(damage_type, 1, 2)) + copytext(damage_type, 2)
        var/name_suffix = ""

        // Highlight the currently selected graph
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
