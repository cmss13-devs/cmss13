/datum/agent_objective/disable_apc
	description = ""
	var/area_paths_to_disable_at = list(/area/almayer/hallways/aft_hallway, /area/almayer/hallways/starboard_hallway, /area/almayer/hallways/port_hallway, /area/almayer/hallways/hangar, /area/almayer/command/cichallway, /area/almayer/medical/upper_medical, /area/almayer/living/briefing)
	var/picked_area_path
	completed = FALSE

/datum/agent_objective/disable_apc/New(datum/agent/A)

	picked_area_path = pick(area_paths_to_disable_at)

	. = ..()

	var/mob/living/carbon/human/H = belonging_to_agent.source_human

	RegisterSignal(H, list(
		COMSIG_MOB_APC_REMOVE_BOARD,
		COMSIG_MOB_APC_REMOVE_CELL,
		COMSIG_MOB_APC_CUT_WIRE,
		COMSIG_MOB_APC_POWER_PULSE,
	), .proc/disabled_apc)

/datum/agent_objective/disable_apc/generate_objective_body_message()
	var/obj/O = picked_area_path
	var/area_name = initial(O.name)
	return "Cause a blackout. [SPAN_BOLD("[SPAN_BLUE("Disable")]")] an [SPAN_BOLD("[SPAN_RED("APC")]")] in [SPAN_BOLD("[SPAN_RED("[area_name]")]")]."

/datum/agent_objective/disable_apc/generate_description()
	var/obj/O = picked_area_path
	var/area_name = initial(O.name)
	description = "Cause a blackout. Disable an APC in [area_name]."

/datum/agent_objective/disable_apc/proc/disabled_apc(mob/agent, obj/structure/machinery/power/apc/source)
	SIGNAL_HANDLER
	if(completed)
		return

	if(istype(get_area(source), picked_area_path))
		completed = TRUE

/datum/agent_objective/disable_apc/check_completion_round_end()
	. = ..()
	if(. && completed)
		return TRUE

	return FALSE
