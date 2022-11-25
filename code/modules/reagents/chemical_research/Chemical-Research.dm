var/global/datum/chemical_data/chemical_data = new /datum/chemical_data/

/datum/chemical_data
	var/rsc_credits = 0
	var/clearance_level = 1
	var/clearance_x_access = FALSE
	var/reached_x_access = FALSE
	var/has_new_properties = FALSE
	var/research_allocation_amount = 5
	var/list/research_documents = list()
	var/list/research_publications = list()
	var/list/research_property_data = list() //starter properties are stored here
	var/list/transmitted_data = list()
	var/list/chemical_networks = list()
	var/list/shared_item_storage = list()
	var/list/shared_item_quantity = list()
	
	var/list/chemical_objective_list = list()	//List of all objective reagents indexed by ID associated with the objective value
	var/list/chemical_not_completed_objective_list = list()	//List of not completed objective reagents indexed by ID associated with the objective value
	var/list/chemical_identified_list = list()	//List of all identified objective reagents indexed by ID associated with the objective value


/datum/chemical_data/proc/update_credits(var/change)
	rsc_credits = max(0, rsc_credits + change)

/datum/chemical_data/proc/update_income(var/change)
	research_allocation_amount = max(0, research_allocation_amount + change)

/datum/chemical_data/proc/save_document(var/obj/item/paper/research_report/R, var/document_type, var/title)
	if(!research_documents["[document_type]"])
		research_documents["[document_type]"] = list()
	var/list/new_document[0]
	new_document["[title]"] = R
	research_documents["[document_type]"] += new_document

/datum/chemical_data/proc/publish_document(var/obj/item/paper/research_report/R, var/document_type, var/title)
	if(!research_publications["[document_type]"])
		research_publications["[document_type]"] = list()
	var/list/new_document[0]
	new_document["[title]"] = R
	research_publications["[document_type]"] += new_document

/datum/chemical_data/proc/unpublish_document(var/document_type, var/title)
	if(research_publications["[document_type]"]["[title]"])
		research_publications["[document_type]"] -= title
		return TRUE

/datum/chemical_data/proc/save_new_properties(var/list/properties)
	var/list/property_names = list()
	for(var/datum/chem_property/P in properties) //just save the names
		if(P.category & PROPERTY_TYPE_UNADJUSTABLE || P.category & PROPERTY_TYPE_ANOMALOUS)
			continue
		property_names += P.name
	for(var/name in research_property_data)
		property_names -= name
	if(LAZYLEN(property_names))
		has_new_properties = TRUE
		for(var/name in property_names)
			var/datum/chem_property/ref = chemical_properties_list[name]
			var/datum/chem_property/P = new ref.type
			P.level = 0
			research_property_data += P

//Chem storage for various chem dispensers
/datum/chemical_data/proc/add_chem_storage(var/obj/structure/machinery/chem_storage/C)
	if(chemical_networks.Find(C.network))
		return FALSE
	else
		chemical_networks[C.network] = C

/datum/chemical_data/proc/connect_chem_storage(var/network)
	var/obj/structure/machinery/chem_storage/C = chemical_networks[network]
	if(!C)
		return FALSE
	//Make the chem storage scale with number of dispensers
	C.recharge_rate += 5
	C.max_energy += 50
	C.energy = C.max_energy
	return C


/datum/chemical_data/proc/complete_chemical(var/datum/reagent/S)
	update_credits(2)
	chemical_identified_list[S.id] = S.objective_value
	chemical_not_completed_objective_list -= S.id

	SSobjectives.statistics["chemicals_completed"]++
	SSobjectives.statistics["chemicals_total_points_earned"] += S.objective_value

	var/datum/techtree/tree = GET_TREE(TREE_MARINE)
	tree.add_points(S.objective_value)


/datum/chemical_data/proc/add_chemical_objective(var/datum/reagent/S)
	chemical_objective_list[S.id] = S.objective_value
	chemical_not_completed_objective_list[S.id] = S.objective_value

/datum/chemical_data/proc/get_tgui_data(var/chemid)
	var/datum/reagent/S = chemical_reagents_list[chemid]
	if(!S)
		error("Invalid chemid [chemid]")
		return
	var/list/clue = list()

	clue["text"] = S.name

	return clue

