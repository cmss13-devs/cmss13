/datum/agent_objective/build
	description = ""
	var/list_events_to_listen_on = list(EVENT_WALL_BUILT)
	var/list_obj_types = list(/turf/closed/wall)

	// These are automatically setup in New
	var/list_obj_types_to_required_amount
	var/list_obj_types_to_built_amount

/datum/agent_objective/build/New(datum/agent/A)
	list_obj_types_to_required_amount = list()
	list_obj_types_to_built_amount = list()
	for(var/i in list_obj_types)
		list_obj_types_to_required_amount[i] = rand(1, 4)
		list_obj_types_to_built_amount[i] = 0

	. = ..()

	var/mob/living/carbon/human/H = belonging_to_agent.source_human
	H.skills.set_skill(SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_ENGI)

	for(var/event in list_events_to_listen_on)
		registerListener(GLOBAL_EVENT, event + "\ref[belonging_to_agent.source_human]", "\ref[src]_\ref[belonging_to_agent.source_human]", CALLBACK(src, .proc/count_built))

/datum/agent_objective/build/generate_objective_body_message()
	var/text_string = ""
	for(var/i = 1 to (length(list_obj_types) - 1))
		var/obj/thing = list_obj_types[i]
		var/amount = "[list_obj_types_to_required_amount[thing]]"
		var/name = "[initial(thing.name)]s"
		text_string += ", [SPAN_BOLD("[SPAN_RED("[amount] [name]")]")]"

	var/obj/thingy = list_obj_types[length(list_obj_types)]
	var/amounty = "[list_obj_types_to_required_amount[thingy]]"
	var/namey = "[initial(thingy.name)]s"
	text_string += " and [SPAN_BOLD("[SPAN_RED("[amounty] [namey]")]")]"

	return "Prepare a hideout by [SPAN_BOLD("[SPAN_BLUE("building")]")][text_string]."

/datum/agent_objective/build/generate_description()
	var/text_string = ""
	for(var/i = 1 to (length(list_obj_types) - 1))
		var/obj/thing = list_obj_types[i]
		text_string += ", [list_obj_types_to_required_amount[list_obj_types[i]]] [initial(thing.name)]s"

	var/obj/thingy = list_obj_types[length(list_obj_types)]
	text_string += " and [list_obj_types_to_required_amount[list_obj_types[length(list_obj_types)]]] [initial(thingy.name)]s"

	description = "Prepare a hideout by building[text_string]."

/datum/agent_objective/build/proc/count_built(var/type_path)
	var/path_found = null
	for(var/i in list_obj_types)
		if(ispath(type_path, i))
			path_found = i
			break

	if(!path_found)
		return

	list_obj_types_to_built_amount[path_found]++

/datum/agent_objective/build/check_completion_round_end()
	. = ..()
	if(!.)
		return FALSE

	// Check that we built all
	for(var/i in list_obj_types)
		if(list_obj_types_to_required_amount[i] > list_obj_types_to_built_amount[i])
			return FALSE

	return TRUE


/datum/agent_objective/build/simple_base
	list_events_to_listen_on = list(EVENT_WALL_BUILT, EVENT_WINDOW_BUILT)
	list_obj_types = list(/turf/closed/wall, /obj/structure/window)