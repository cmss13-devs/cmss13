//An objective to open a safe
/datum/cm_objective/crack_safe
	var/obj/structure/safe/target
	var/area/initial_location
	priority = OBJECTIVE_MEDIUM_VALUE
	prerequisites_required = PREREQUISITES_NONE
	objective_flags = OBJ_DEAD_END
	number_of_clues_to_generate = 4
	
/datum/cm_objective/crack_safe/New(var/obj/structure/safe/safe)
	if(!istype(safe))
		CRASH("Object is not of type safe - [safe]")
	target = safe
	initial_location = get_area(target)
	. = ..()

/datum/cm_objective/crack_safe/check_completion()
	if(!target)
		complete() //Safe got blown up probably
		. = ..()
		return
	if(target.open)
		complete()
	else if(objective_flags & OBJ_CAN_BE_UNCOMPLETED)
		complete = 0
	. = ..()
	return

/datum/cm_objective/crack_safe/get_clue()
	return SPAN_DANGER("Crack open a safe in <u>[initial_location]</u>, the combination lock is <b>[target.tumbler_1_open]|[target.tumbler_2_open]</b>")

/datum/cm_objective/crack_safe/get_related_label()
	return "Safe"