/datum/agent_objective/propaganda
	description = ""
	var/posters_to_place = 0
	var/currently_placed = 0
	var/area_paths_to_place_at = list(/area/almayer/hallways)
	completed = FALSE

/datum/agent_objective/propaganda/New(datum/agent/A)

	posters_to_place = rand(2, 5)

	. = ..()

	var/mob/living/carbon/human/H = belonging_to_agent.source_human

	var/obj/item/poster/propaganda/P
	for(var/i = 0 to posters_to_place)
		P = new(H)
		if(!H.equip_to_slot_if_possible(P, WEAR_IN_BACK))
			if(!H.equip_to_slot_if_possible(P, WEAR_L_HAND))
				if(!H.equip_to_slot_if_possible(P, WEAR_R_HAND))
					P.loc = H.loc
		RegisterSignal(P, COMSIG_POSTER_PLACED, .proc/placed_propaganda)

/datum/agent_objective/propaganda/generate_objective_body_message()
	return "Spread the message! [SPAN_BOLD("[SPAN_BLUE("Place")]")] [SPAN_BOLD("[SPAN_RED("[posters_to_place]")]")] [SPAN_BOLD("[SPAN_RED("propaganda posters")]")] around [MAIN_SHIP_NAME] hallways."

/datum/agent_objective/propaganda/generate_description()
	description = "Spread the message! Place [posters_to_place] propaganda posters around [MAIN_SHIP_NAME] hallways."

/datum/agent_objective/propaganda/proc/placed_propaganda(turf/closed/wall/loc, mob/user)
	SIGNAL_HANDLER
	var/area/placed_area = get_area(user)
	for(var/A in area_paths_to_place_at)
		if(istype(placed_area, A))
			currently_placed++
			break

/datum/agent_objective/propaganda/check_completion_round_end()
	. = ..()
	if(!.)
		return FALSE

	// Check that we placed enough posters
	if(posters_to_place <= currently_placed)
		return TRUE

	return FALSE


/obj/item/poster/propaganda
	name = "suspicious looking poster"

/obj/item/poster/propaganda/Initialize(mapload, ...)
	. = ..()
	
	serial_number = 19
	name = initial(name)