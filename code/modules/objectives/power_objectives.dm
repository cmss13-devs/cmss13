#define MINIMUM_POWER_OUTPUT 300000

// Parent objective for power-related objectives, tracks APCs and such
// Tracks APCs/SMESes here so we don't have to check every APC/SMES every time we want to score an objective
/datum/cm_objective/power
	name = "Something power-related"
	objective_flags = OBJECTIVE_DO_NOT_TREE
	value = OBJECTIVE_NO_VALUE
	state = OBJECTIVE_ACTIVE
	var/list/power_objects
	var/uses_smes = FALSE

/datum/cm_objective/power/Destroy()
	power_objects = null
	..()

/datum/cm_objective/power/pre_round_start()
	if(uses_smes)
		for(var/obj/structure/machinery/power/smes/colony_smes in machines)
			if(!is_ground_level(colony_smes.loc.z))
				continue
			LAZYADD(power_objects, colony_smes)
			RegisterSignal(colony_smes, COMSIG_PARENT_QDELETING, PROC_REF(remove_machine))

/datum/cm_objective/power/proc/remove_machine(obj/structure/machinery/power/machine)
	SIGNAL_HANDLER
	LAZYREMOVE(power_objects, machine)
	UnregisterSignal(machine, COMSIG_PARENT_QDELETING)

// --------------------------------------------
// *** Basic power up the colony objective ***
// --------------------------------------------

/datum/cm_objective/power/establish_power
	var/minimum_power_required = MINIMUM_POWER_OUTPUT
	var/last_power_output = 0 // for displaying progress
	objective_flags = OBJECTIVE_DO_NOT_TREE
	value = OBJECTIVE_POWER_VALUE
	controller = TREE_MARINE
	uses_smes = TRUE

/datum/cm_objective/power/establish_power/post_round_start()
	activate()

/datum/cm_objective/power/establish_power/check_completion()
	if(!SSobjectives.first_drop_complete)
		return
	var/total_power_output = 0
	for(var/obj/structure/machinery/power/smes/colony_smes in power_objects)
		if(colony_smes.charge <= 0)
			continue
		if(!colony_smes.outputting)
			continue
		if(colony_smes.output_level <= 0)
			continue
		if(colony_smes.inputting == 2 && colony_smes.input_level >= colony_smes.output_level)
			total_power_output += colony_smes.output_level
	last_power_output = total_power_output
	if(total_power_output >= minimum_power_required)
		complete()

/datum/cm_objective/power/establish_power/complete()
	award_points()
	state = OBJECTIVE_COMPLETE
