GLOBAL_DATUM_INIT(chemical_data, /datum/chemical_data, new)

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
	var/list/chemical_objective_list = list() //List of all objective reagents indexed by ID associated with the objective value
	var/list/chemical_not_completed_objective_list = list() //List of not completed objective reagents indexed by ID associated with the objective value
	var/list/chemical_identified_list = list() //List of all identified objective reagents indexed by ID associated with the objective value

/datum/chemical_data/proc/update_credits(change)
	rsc_credits = max(0, rsc_credits + change)

/datum/chemical_data/proc/update_income(change)
	research_allocation_amount = max(0, research_allocation_amount + change)

/datum/chemical_data/proc/save_document(obj/item/paper/research_report/R, document_type, title)
	if(!research_documents["[document_type]"])
		research_documents["[document_type]"] = list()
	var/save_time = worldtime2text()

	var/list/new_document = list(
		"document_title"=title,
		"time"=save_time,
		"document"=R
	)
	research_documents["[document_type]"] += list(new_document)

/datum/chemical_data/proc/get_report(doc_type, doc_title)
	var/obj/item/paper/research_report/report = null
	for(var/document_data in GLOB.chemical_data.research_documents[doc_type])
		if(document_data["document_title"] == doc_title)
			report = document_data["document"]
			break
	return report

/datum/chemical_data/proc/publish_document(obj/item/paper/research_report/R, document_type, title)
	if(!research_publications["[document_type]"])
		research_publications["[document_type]"] = list()
	var/save_time = worldtime2text()

	var/list/new_document = list(
		"document_title"=title,
		"time"=save_time,
		"document"=R
	)
	research_publications["[document_type]"] += list(new_document)

/datum/chemical_data/proc/unpublish_document(document_type, title)
	if(!research_publications["[document_type]"])
		return TRUE
	var/list/published_to_remove = list()
	var/list/docs = research_documents["[document_type]"]
	// find the document, in all research documents
	// the user might unpublish a different version to the published one
	for(var/research_doc in docs)
		if(research_doc["document_title"] == title)
			published_to_remove += research_doc
			break
	// collect all documents which match the name of the doc to unpublish
	var/chem_name = published_to_remove["document"]
	var/list/all_published_references = list()
	var/list/published_docs = research_publications["[document_type]"]
	for(var/published_doc in published_docs)
		var/doc_name = published_doc["document"]
		if(cmptext(doc_name, chem_name) == 1)
			all_published_references += list(published_doc)

	// remove all published references
	for(var/published_doc in all_published_references)
		published_docs -= list(published_doc)
	return TRUE

/datum/chemical_data/proc/save_new_properties(list/properties)
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
			var/datum/chem_property/ref = GLOB.chemical_properties_list[name]
			var/datum/chem_property/P = new ref.type
			P.level = 0
			research_property_data += P

//Chem storage for various chem dispensers
/datum/chemical_data/proc/add_chem_storage(obj/structure/machinery/chem_storage/storage)
	if(chemical_networks.Find(storage.network))
		return FALSE
	else
		chemical_networks[storage.network] = storage

/datum/chemical_data/proc/remove_chem_storage(obj/structure/machinery/chem_storage/storage)
	if(!istype(storage))
		return FALSE
	return chemical_networks.Remove(storage.network)

/datum/chemical_data/proc/connect_chem_storage(network)
	var/obj/structure/machinery/chem_storage/storage = chemical_networks[network]
	if(!storage)
		return FALSE
	//Make the chem storage scale with number of dispensers
	storage.recharge_rate += 5
	storage.max_energy += 100
	storage.energy = storage.max_energy
	return storage

/datum/chemical_data/proc/disconnect_chem_storage(network)
	var/obj/structure/machinery/chem_storage/storage = chemical_networks[network]
	if(!storage)
		return FALSE
	//Make the chem storage scale with number of dispensers
	storage.recharge_rate -= 5
	storage.max_energy -= 100
	storage.energy = storage.max_energy
	return TRUE

/datum/chemical_data/proc/complete_chemical(datum/reagent/chem)
	update_credits(2)
	chemical_identified_list[chem.id] = chem.objective_value
	chemical_not_completed_objective_list -= chem.id

	SSobjectives.statistics["chemicals_completed"]++
	SSobjectives.statistics["chemicals_total_points_earned"] += chem.objective_value

	var/datum/techtree/tree = GET_TREE(TREE_MARINE)
	tree.add_points(chem.objective_value)


/datum/chemical_data/proc/add_chemical_objective(datum/reagent/chem)
	chemical_objective_list[chem.id] = chem.objective_value
	chemical_not_completed_objective_list[chem.id] = chem.objective_value

/datum/chemical_data/proc/get_tgui_data(chemid)
	var/datum/reagent/chem = GLOB.chemical_reagents_list[chemid]
	if(!chem)
		error("Invalid chemid [chemid]")
		return
	var/list/clue = list()

	clue["text"] = chem.name

	return clue

