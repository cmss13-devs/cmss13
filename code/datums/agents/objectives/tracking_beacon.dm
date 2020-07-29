/datum/agent_objective/tracking_beacon
	description = ""
	var/area_to_plant_type
	var/obj/item/device/agents/tracking_device/tracker
	var/areas_to_pick_from = list(/area/almayer/command/cichallway, /area/almayer/living/captain_mess, /area/almayer/command/securestorage, /area/almayer/command/self_destruct, /area/almayer/command/telecomms, /area/almayer/medical/morgue, /area/almayer/shipboard/navigation)
	completed = FALSE

	var/messages
	var/picked_message = "Feed us information, by"

/datum/agent_objective/tracking_beacon/New(datum/agent/A)
	messages = list("Track [MAIN_SHIP_NAME]'s vital area by", "Feed us information by")

	area_to_plant_type = pick(areas_to_pick_from)

	. = ..()

	var/mob/living/carbon/human/H = belonging_to_agent.source_human

	tracker = new(H)
	if(!H.equip_to_slot_if_possible(tracker, WEAR_IN_BACK))
		if(!H.equip_to_slot_if_possible(tracker, WEAR_L_HAND))
			if(!H.equip_to_slot_if_possible(tracker, WEAR_R_HAND))
				tracker.loc = H.loc

	registerListener(GLOBAL_EVENT, EVENT_TRACKING_PLANTED + "\ref[tracker]", "\ref[src]_\ref[tracker]", CALLBACK(src, .proc/placed_tracker))

/datum/agent_objective/tracking_beacon/generate_objective_body_message()
	picked_message = pick(messages)
	var/area/place = area_to_plant_type
	return "[picked_message] [SPAN_BOLD("[SPAN_BLUE("placing")]")] the [SPAN_BOLD("[SPAN_RED("tracking device")]")] in [SPAN_BOLD("[SPAN_RED("[initial(place.name)]")]")]. Make sure it doesn't get found."

/datum/agent_objective/tracking_beacon/generate_description()
	var/area/place = area_to_plant_type
	description = "[picked_message] placing the tracking device in [initial(place.name)]. Make sure it doesn't get found."

/datum/agent_objective/tracking_beacon/proc/placed_tracker()
	if(tracker.planted && istypestrict(get_area(tracker), area_to_plant_type))
		completed = TRUE
	else
		completed = FALSE

/datum/agent_objective/tracking_beacon/check_completion_round_end()
	. = ..()
	if(!.)
		return FALSE

	// Check that it was planted right
	return completed