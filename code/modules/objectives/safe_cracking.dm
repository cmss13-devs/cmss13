//An objective to open a safe
/datum/cm_objective/crack_safe
	name = "Crack Safe"
	var/obj/structure/safe/target
	var/area/initial_area
	value = OBJECTIVE_HIGH_VALUE
	objective_flags = OBJECTIVE_DEAD_END
	controller = TREE_MARINE
	number_of_clues_to_generate = 2

/datum/cm_objective/crack_safe/New(var/obj/structure/safe/safe)
	target = safe
	initial_area = get_area(target)


	RegisterSignal(safe, COMSIG_SAFE_OPENED, .proc/on_safe_open)
	RegisterSignal(safe, COMSIG_PARENT_QDELETING, .proc/on_safe_open)
	safe.objective = src
	. = ..()

/datum/cm_objective/crack_safe/pre_round_start()
	SSobjectives.statistics["miscellaneous_total_instances"]++

/datum/cm_objective/crack_safe/Destroy()
	target = null
	initial_area = null
	return ..()

/datum/cm_objective/crack_safe/get_clue()
	return SPAN_DANGER("Crack open a safe in <u>[initial_area]</u>, the combination lock is <b>[target.tumbler_1_open]|[target.tumbler_2_open]</b>")

/datum/cm_objective/crack_safe/get_related_label()
	return "Safe"

/datum/cm_objective/crack_safe/get_tgui_data()
	var/list/clue = list()

	clue["text"] = "Crack open the safe"
	clue["key_text"] = ", combination lock is "
	clue["key"] = "[target.tumbler_1_open]|[target.tumbler_2_open]"
	clue["location"] = initial_area.name

	return clue

/datum/cm_objective/crack_safe/complete()
	state = OBJECTIVE_COMPLETE
	SSobjectives.statistics["miscellaneous_completed"]++
	SSobjectives.statistics["miscellaneous_total_points_earned"] += value
	award_points()

/datum/cm_objective/crack_safe/proc/on_safe_open(var/obj/structure/safe)
	SIGNAL_HANDLER

	if (state != OBJECTIVE_COMPLETE)
		UnregisterSignal(safe, COMSIG_SAFE_OPENED)
		complete()
