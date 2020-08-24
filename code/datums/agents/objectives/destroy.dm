/datum/agent_objective/destroy
	description = ""
	var/event_to_listen_on = EVENT_WALL_DESTROYED
	var/obj_to_destroy_type = /turf/closed/wall
	var/destroyed_so_far = 0
	var/amount_to_destroy = 0

/datum/agent_objective/destroy/New(datum/agent/A)
	amount_to_destroy = rand(2, 5)

	. = ..()

	registerListener(GLOBAL_EVENT, event_to_listen_on + "\ref[belonging_to_agent.source_human]", "\ref[src]_\ref[belonging_to_agent.source_human]", CALLBACK(src, .proc/count_destruction))

/datum/agent_objective/destroy/generate_objective_body_message()
	var/obj/thing = obj_to_destroy_type
	return "Weaken the structurals of [MAIN_SHIP_NAME] by [SPAN_BOLD("[SPAN_BLUE("destroying")]")] [SPAN_BOLD("[SPAN_RED("[amount_to_destroy] [initial(thing.name)]s")]")]."

/datum/agent_objective/destroy/generate_description()
	var/obj/thing = obj_to_destroy_type
	description = "Weaken the structurals of [MAIN_SHIP_NAME] by destroying [amount_to_destroy] [initial(thing.name)]s."

/datum/agent_objective/destroy/proc/count_destruction(var/type_path)
	if(!ispath(type_path, obj_to_destroy_type))
		return

	destroyed_so_far++

/datum/agent_objective/destroy/check_completion_round_end()
	. = ..()
	if(!.)
		return FALSE

	// Check that we destroyed enough
	if(amount_to_destroy <= destroyed_so_far)
		return TRUE

	return FALSE


/datum/agent_objective/destroy/wall
	event_to_listen_on = EVENT_WALL_DESTROYED
	obj_to_destroy_type = /turf/closed/wall

/datum/agent_objective/destroy/window_frame
	event_to_listen_on = EVENT_W_FRAME_DESTROYED
	obj_to_destroy_type = /obj/structure/window_frame

/datum/agent_objective/destroy/window
	event_to_listen_on = EVENT_WINDOW_DESTROYED
	obj_to_destroy_type = /obj/structure/window

/datum/agent_objective/destroy/airlock
	event_to_listen_on = EVENT_AIRLOCK_DESTROYED
	obj_to_destroy_type = /obj/structure/machinery/door/airlock