datum/cm_objective/analyze_chems
	name = "Analyze chems"
	objective_flags = OBJ_DO_NOT_TREE | OBJ_PROCESS_ON_DEMAND
	display_category = "Analyze chems"

/datum/cm_objective/analyze_chems/total_point_value()
	var/total_points = 0
	for(var/L in chemical_gen_classes_list["C5"])
		total_points += chemical_objective_list[L]

	for(var/L in chemical_gen_classes_list["C6"])
		total_points += chemical_objective_list[L]
	return total_points

/datum/cm_objective/analyze_chems/get_point_value()
	var/scored_points = 0
	for(var/L in chemical_gen_classes_list["C5"])
		if(chemical_identified_list[L])
			scored_points += chemical_identified_list[L]

	for(var/L in chemical_gen_classes_list["C6"])
		if(chemical_identified_list[L])
			scored_points += chemical_identified_list[L]
	return scored_points