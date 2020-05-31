var/global/datum/chemical_research_data/chemical_research_data = new /datum/chemical_research_data/

/datum/chemical_research_data/
	var/rsc_credits = 2
	var/clearance_level = 1
	var/list/research_documents = list()
	var/list/research_publications = list()
	var/list/transmitted_data = list()

/datum/chemical_research_data/proc/update_credits(var/change)
	rsc_credits = max(0, rsc_credits + change)

/datum/chemical_research_data/proc/save_document(var/obj/item/paper/research_report/R, var/document_type, var/title)
	if(!research_documents["[document_type]"])
		research_documents["[document_type]"] = list()
	var/list/new_document[0]
	new_document["[title]"] = R
	research_documents["[document_type]"] += new_document

/datum/chemical_research_data/proc/publish_document(var/obj/item/paper/research_report/R, var/document_type, var/title)
	if(!research_publications["[document_type]"])
		research_publications["[document_type]"] = list()
	var/list/new_document[0]
	new_document["[title]"] = R
	research_publications["[document_type]"] += new_document

/datum/chemical_research_data/proc/unpublish_document(var/document_type, var/title)
	if(research_publications["[document_type]"]["[title]"])
		research_publications["[document_type]"] -= research_publications["[document_type]"]["[title]"]
		return TRUE

//For research sending DeLorean mail to the WY of next round
/datum/chemical_research_data/proc/transmit_chem_data(var/datum/reagent/R)
	if(!R || transmitted_data["[R.id]"])
		return
	
	var/datum/entity/chemical_information/CI = DB_ENTITY(/datum/entity/chemical_information)

	CI.assign_values(R.vars)
	CI.properties = R.properties

	CI.save()

	transmitted_data["[R.id]"] = CI
	return TRUE

//Called after all the default chems have been initialized
/datum/chemical_research_data/proc/initialize_saved_chem_data()
	set waitfor = 0
	while(!SSentity_manager.ready)
		stoplag()
	SSentity_manager.filter_then(/datum/entity/chemical_information, null, CALLBACK(GLOBAL_PROC, /proc/initialize_saved_chem_data_callback), TRUE)

/proc/initialize_saved_chem_data_callback(var/list/datum/entity/chemical_information/chemicals)
	var/i = 0
	for(var/datum/entity/chemical_information/data in chemicals)
		var/datum/reagent/generated/R = new /datum/reagent/generated
        
		//Make the reagent
		for(var/V in data.metadata.field_types)
			if(V != "properties_text")
				R.vars[V] = data.vars[V]
		R.properties = data.properties
		R.generate_name()
		R.id = "omega-[i]"
		R.generate_description()
		R.calculate_gen_tier(R.calculate_value())
		R.save_chemclass()
		chemical_gen_classes_list["omega"] += R.id
		chemical_reagents_list[R.id] = R
		//Make a new recipe
		R.generate_assoc_recipe()

		data.delete() // and delete it so it doesn't appear next round
		i++