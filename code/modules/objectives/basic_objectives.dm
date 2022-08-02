// --------------------------------------------
// *** Basic retrieve item and get it to an area ***
// --------------------------------------------
/datum/cm_objective/retrieve_item
	var/obj/target_item
	var/list/area/target_areas
	var/area/initial_location
	objective_flags = OBJ_CAN_BE_UNCOMPLETED | OBJ_FAILABLE
	display_category = "Item Retrieval"

/datum/cm_objective/retrieve_item/New(var/T)
	..()
	if(T)
		target_item = T
		initial_location = get_area(target_item)
	RegisterSignal(target_item, COMSIG_PARENT_PREQDELETED, .proc/clean_up_ref)

/datum/cm_objective/retrieve_item/Destroy()
	target_item = null
	target_areas = null
	initial_location = null
	return ..()

/datum/cm_objective/retrieve_item/proc/clean_up_ref()
	SIGNAL_HANDLER
	target_item = null
	fail()

/datum/cm_objective/retrieve_item/get_clue()
	return SPAN_DANGER("[target_item] in <u>[initial_location]</u>")

/datum/cm_objective/retrieve_item/check_completion()
	. = ..()
	if(!target_item)
		fail()
		return FALSE
	for(var/T in target_areas)
		var/area/target_area = T //not sure why the cast is necessary (rather than casting in the loop), but it doesn't work without it... ~ThePiachu
		if(istype(get_area(target_item.loc), target_area))
			complete()
			return TRUE

/datum/cm_objective/retrieve_item/almayer
	target_areas = list(
		/area/almayer/command/securestorage,
		/area/almayer/command/computerlab,
		/area/almayer/medical/medical_science
	)
	priority = OBJECTIVE_EXTREME_VALUE

// --------------------------------------------
// *** Get communications up ***
// --------------------------------------------
/datum/cm_objective/communications
	name = "Restore Colony Communications"
	objective_flags = OBJ_DO_NOT_TREE | OBJ_CAN_BE_UNCOMPLETED
	display_flags = OBJ_DISPLAY_AT_END
	priority = OBJECTIVE_ABSOLUTE_VALUE
	var/last_contact_time = NONE // Time of last loss of comms to notify of

/datum/cm_objective/communications/get_completion_status()
	if(is_complete())
		return "<span class='objectivegreen'>Comms are up!</span>"
	return "<span class='objectivered'>Comms are down!</span>"

/datum/cm_objective/communications/check_completion()
	. = ..()
	for(var/obj/structure/machinery/telecomms/relay/T in machines)
		if(is_ground_level(T.loc.z) && T.operable() && T.on)
			complete()
			return TRUE
	uncomplete()
	return FALSE

/datum/cm_objective/communications/complete()
	. = ..()
	if(. && !last_contact_time)
		last_contact_time = world.time
		ai_silent_announcement("SYSTEMS REPORT: Colony communications link online.", ":v")

/datum/cm_objective/communications/uncomplete()
	if(complete)
		last_contact_time = world.time
		addtimer(CALLBACK(src, .proc/blackout_warning, last_contact_time), 45 SECONDS + rand(0, 45 SECONDS))
	. = ..()

/datum/cm_objective/communications/proc/blackout_warning(blackout_start)
	if(!complete && !check_completion() && blackout_start == last_contact_time)
		var/timediff = world.time - blackout_start
		var/timeformat = "[round(timediff / (1 SECONDS))].[round(timediff % (1 SECONDS))]"
		ai_silent_announcement("SYSTEMS WARNING: Colony communications link unresponsive for [timeformat] seconds.", ":v")
		last_contact_time = NONE

/datum/cm_objective/establish_power/get_point_value()
	return complete * priority

/datum/cm_objective/establish_power/total_point_value()
	return priority


/datum/cm_objective/retrieve_item/fulton
	name = "Restore Colony Communications"
	priority = OBJECTIVE_NO_VALUE
	target_areas = list(
		/area/almayer,
	)

/datum/cm_objective/retrieve_item/fulton/get_clue()
	return SPAN_DANGER("Retrieve lost fulton of [target_item] in [initial_location]")


/datum/cm_objective/retrieve_item/fulton/fail()
	. = ..()
	//Objective is failed, doesn't need to be here anymore
	qdel(src)

/datum/cm_objective/retrieve_item/fulton/complete()
	. = ..()
	//Objective is complete, doesn't need to be here anymore
	qdel(src)
