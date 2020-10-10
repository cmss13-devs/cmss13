/datum/agent_objective/destroy
	description = ""
	var/max_amount = 5
	var/min_amount = 2
	var/event_to_listen_on = list(COMSIG_MOB_DESTROY_WALL, COMSIG_MOB_EXPLODED_WALL)
	var/obj_to_destroy_type = /turf/closed/wall
	var/destroyed_so_far = 0
	var/amount_to_destroy = 0
	var/areas_to_destroy_in = list(/area/almayer/medical/upper_medical, /area/almayer/shipboard/brig, /area/almayer/command/cic)

/datum/agent_objective/destroy/New(datum/agent/A)
	amount_to_destroy = rand(min_amount, max_amount)

	. = ..()

	RegisterSignal(A.source_human, event_to_listen_on, .proc/count_destruction)

/datum/agent_objective/destroy/generate_objective_body_message()
	var/text_string = ""
	for(var/i = 1 to (length(areas_to_destroy_in) - 1))
		var/obj/thing = areas_to_destroy_in[i]
		var/name = "[initial(thing.name)]"
		text_string += ", [SPAN_BOLD("[SPAN_RED("[name]")]")]"

	var/obj/thingy = areas_to_destroy_in[length(areas_to_destroy_in)]
	var/namey = "[initial(thingy.name)]"
	text_string += " or [SPAN_BOLD("[SPAN_RED("[namey]")]")]"

	var/obj/thing = obj_to_destroy_type
	return "Weaken the structurals of [MAIN_SHIP_NAME] by [SPAN_BOLD("[SPAN_BLUE("destroying")]")] [SPAN_BOLD("[SPAN_RED("[amount_to_destroy] [initial(thing.name)]s")]")] at[text_string]."

/datum/agent_objective/destroy/generate_description()
	var/text_string = ""
	for(var/i = 1 to (length(areas_to_destroy_in) - 1))
		var/obj/thing = areas_to_destroy_in[i]
		var/name = "[initial(thing.name)]"
		text_string += ", [name]"

	var/obj/thingy = areas_to_destroy_in[length(areas_to_destroy_in)]
	var/namey = "[initial(thingy.name)]"
	text_string += " or [namey]"

	var/obj/thing = obj_to_destroy_type
	description = "Weaken the structurals of [MAIN_SHIP_NAME] by destroying [amount_to_destroy] [initial(thing.name)]s at[text_string]."

/datum/agent_objective/destroy/proc/count_destruction(mob/agent, atom/source)
	SIGNAL_HANDLER
	if(!istype(source, obj_to_destroy_type))
		return

	var/area/A = get_area(source)
	if(A.type in areas_to_destroy_in)
		destroyed_so_far++


/datum/agent_objective/destroy/check_completion_round_end()
	. = ..()
	if(!.)
		return FALSE

	// Check that we destroyed enough
	if(amount_to_destroy <= destroyed_so_far)
		return TRUE

	return FALSE

/datum/agent_objective/destroy/window
	event_to_listen_on = COMSIG_MOB_DESTROY_W_FRAME
	obj_to_destroy_type = /obj/structure/window

/datum/agent_objective/destroy/airlock
	max_amount = 1
	min_amount = 1
	event_to_listen_on = list(COMSIG_MOB_DESTROY_AIRLOCK, COMSIG_MOB_DISASSEMBLE_AIRLOCK)
	obj_to_destroy_type = /obj/structure/machinery/door/airlock
