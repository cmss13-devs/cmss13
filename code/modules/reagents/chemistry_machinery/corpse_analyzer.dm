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
	for(var/i = 1; i <= length(damage_type_map); i++) //Initalize phase and amplitude modifiers for the 8 graphs
		graph_phase_modifiers["[i]"] = 0.0      // Default phase: 0
		graph_amplitude_modifiers["[i]"] = 1.0  // Default amplitude: 1.0
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
	return graph_amplitude_modifiers[graph_key] || 1.0

// Set current graph's phase modifier
/obj/structure/machinery/corpse_analyzer/proc/set_current_phase(new_phase)
	var/graph_key = "[current_graph_index]"
	graph_phase_modifiers[graph_key] = clamp(new_phase, 0, 1)

// Set current graph's amplitude modifier
/obj/structure/machinery/corpse_analyzer/proc/set_current_amplitude(new_amplitude)
	var/graph_key = "[current_graph_index]"
	graph_amplitude_modifiers[graph_key] = clamp(new_amplitude, 0.1, 3.0)

/obj/structure/machinery/corpse_analyzer/proc/calculate_sinusoidal_value(amplitude, frequency, phase, time)
	return amplitude * sin(frequency * time + phase)

/obj/structure/machinery/corpse_analyzer/proc/get_selected_damage_type()
	if(current_graph_index < 0 || current_graph_index >= length(damage_type_map))
		return "brute" // Fallback to brute if index is out of bounds
	return damage_type_map[current_graph_index + 1] // DM lists are 1-indexed


/obj/structure/machinery/corpse_analyzer/ui_data(mob/user)
	. = list()
	.["current_graph_index"] = current_graph_index
	.["current_damage_type"] = get_selected_damage_type()
	.["phase"] = get_current_phase()
	.["amplitude"] = get_current_amplitude()
	.["analysis_duration"] = analysis_duration
	.["resolution"] = resolution

	// Generate plot data for top graph (total analysis)
	.["plotData"] = generate_plot_data()

	// Generate separate data for bottom graph (component analysis)
	.["componentData"] = generate_component_data()

// New proc to generate component-specific data
/obj/structure/machinery/corpse_analyzer/proc/generate_component_data()
	return generate_plot_data() // For now, uses same data - you can modify this later


/obj/structure/machinery/corpse_analyzer/proc/generate_plot_data()
    if(!GLOB.research_sinusoids || !length(GLOB.research_sinusoids))
        return null

    // Get current damage type based on graph index
    var/selected_damage_type = get_selected_damage_type()
    var/list/wave_list = GLOB.research_sinusoids[selected_damage_type]

    if(!wave_list || !length(wave_list))
        return null

    // Get current graph's specific modifiers
    var/current_phase = get_current_phase()
    var/current_amplitude = get_current_amplitude()
    var/list/graph_points = list()

    // Process the wave in the selected damage type
    for(var/list/wave_data in wave_list)
        var/time_step = analysis_duration / resolution

        var/wave_amplitude = wave_data["amplitude"] * current_amplitude
        var/wave_frequency = wave_data["frequency"]
        var/wave_phase = (wave_data["phase"] * 3.14159 + (current_phase * 3.14159))

        for(var/i = 0; i <= resolution; i++)
            var	time = i * time_step
            var	value = calculate_sinusoidal_value(wave_amplitude, wave_frequency, wave_phase, time)
            graph_points += list(list(time, value))

    // Simplified return structure - no xRange/yRange
    var/list/plot_data = list()
    var/list/datasets = list()

    var/capitalized_damage_type = uppertext(copytext(selected_damage_type, 1, 2)) + copytext(selected_damage_type, 2)

    datasets += list(list(
        "points" = graph_points,
        "color" = "#ff0000",
        "name" = "[capitalized_damage_type] Analysis"
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
