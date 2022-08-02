// --------------------------------------------
// *** Basic power up the colony objective ***
// --------------------------------------------
#define MINIMUM_POWER_OUTPUT 30000

/datum/cm_objective/establish_power
	name = "Restore Colony Power"
	var/minimum_power_required = MINIMUM_POWER_OUTPUT
	var/last_power_output = 0 // for displaying progress
	objective_flags = OBJ_DO_NOT_TREE | OBJ_CAN_BE_UNCOMPLETED
	display_flags = OBJ_DISPLAY_AT_END | OBJ_DISPLAY_WHEN_COMPLETE
	priority = OBJECTIVE_ABSOLUTE_VALUE

/datum/cm_objective/establish_power/get_completion_status()
	return "[last_power_output]W, [minimum_power_required]W required."

/datum/cm_objective/establish_power/check_completion()
	var/total_power_output = 0
	for(var/obj/structure/machinery/power/smes/colony_smes in machines)
		if(!is_ground_level(colony_smes.loc.z))
			continue
		if(colony_smes.charge <= 0)
			continue
		if(!colony_smes.online)
			continue
		if(colony_smes.output <= 0)
			continue
		if(colony_smes.charging == 2 && colony_smes.chargelevel >= colony_smes.output)
			total_power_output += colony_smes.output
	last_power_output = total_power_output
	if(total_power_output >= minimum_power_required)
		complete()
		return TRUE
	uncomplete()
	return FALSE

/datum/cm_objective/establish_power/get_point_value()
	check_completion()
	if (last_power_output >= minimum_power_required)
		return priority
	return priority * last_power_output / minimum_power_required

/datum/cm_objective/establish_power/total_point_value()
	return priority

// --------------------------------------------
// *** Restore the apcs to working order ***
// --------------------------------------------
/datum/cm_objective/repair_apcs
	name = "Repair APCs to fully restore power"
	objective_flags = OBJ_DO_NOT_TREE | OBJ_CAN_BE_UNCOMPLETED
	display_flags = OBJ_DISPLAY_AT_END | OBJ_DISPLAY_WHEN_COMPLETE
	var/total_apcs = 0
	var/last_functioning = 0
	var/points_per_apc = 5
	priority = OBJECTIVE_LOW_VALUE

/datum/cm_objective/repair_apcs/pre_round_start()
	for(var/obj/structure/machinery/power/apc/colony_apc in machines)
		if(!is_ground_level(colony_apc.z))
			continue
		total_apcs++

/datum/cm_objective/repair_apcs/check_completion()
	var/total_functioning = 0
	for(var/obj/structure/machinery/power/apc/colony_apc in machines)
		if(!is_ground_level(colony_apc.z))
			continue
		if(colony_apc.stat & (BROKEN|MAINT))
			continue
		if(colony_apc.equipment < 2)
			continue
		total_functioning++
	last_functioning = total_functioning

/datum/cm_objective/repair_apcs/get_point_value()
	return points_per_apc * last_functioning

/datum/cm_objective/repair_apcs/total_point_value()
	return points_per_apc * total_apcs
