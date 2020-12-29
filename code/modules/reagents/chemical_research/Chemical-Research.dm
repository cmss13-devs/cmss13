var/global/datum/chemical_data/chemical_data = new /datum/chemical_data/

/datum/chemical_data
	var/rsc_credits = 2
	var/clearance_level = 1
	var/clearance_x_access = FALSE
	var/reached_x_access = FALSE
	var/has_new_properties = FALSE
	var/list/research_documents = list()
	var/list/research_publications = list()
	var/list/research_property_data = list() //starter properties are stored here
	var/list/transmitted_data = list()
	var/list/chemical_networks = list()
	var/list/shared_item_storage = list()
	var/list/shared_item_quantity = list()

/datum/chemical_data/proc/update_credits(var/change)
	rsc_credits = max(0, rsc_credits + change)

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


//For research sending DeLorean mail to the WY of next round
/datum/chemical_data/proc/transmit_chem_data(var/datum/reagent/R)
	if(!R || transmitted_data["[R.id]"])
		return

	var/datum/entity/chemical_information/CI = DB_ENTITY(/datum/entity/chemical_information)

	CI.assign_values(R.vars, list("properties_text", "spent_chemical"))
	CI.properties = R.properties_to_assoc()
	CI.spent_chemical = FALSE

	CI.save()

	transmitted_data["[R.id]"] = CI
	return TRUE

//Called after all the default chems have been initialized
/datum/chemical_data/proc/initialize_saved_chem_data()
	set waitfor = 0
	while(!SSentity_manager.ready)
		stoplag()
	DB_FILTER(/datum/entity/chemical_information, DB_COMP("spent_chemical", DB_EQUALS, 0), CALLBACK(GLOBAL_PROC, /proc/initialize_saved_chem_data_callback), TRUE)

/proc/initialize_saved_chem_data_callback(var/list/datum/entity/chemical_information/chemicals)
	var/i = 0
	for(var/datum/entity/chemical_information/data in chemicals)
		var/datum/reagent/generated/R = new /datum/reagent/generated

		//Make the reagent
		for(var/V in data.metadata.field_types)
			if(V != "properties_text" && V != "spent_chemical")
				R.vars[V] = data.vars[V]
		R.properties = data.properties
		R.properties = R.properties_to_datums()
		//I hate doing this, but until the DB converts stuff into proper types we have to do this ourselves
		for(var/datum/chem_property/P in R.properties)
			P.level = text2num(P.level)
		R.nutriment_factor = text2num(R.nutriment_factor) || initial(R.nutriment_factor)
		R.custom_metabolism = text2num(R.custom_metabolism) || initial(R.custom_metabolism)
		R.overdose = text2num(R.overdose) || initial(R.overdose)
		R.overdose_critical = text2num(R.overdose_critical) || initial(R.overdose_critical)
		R.explosive = text2num(R.explosive) || initial(R.explosive)
		R.power = text2num(R.power) || initial(R.power)
		R.falloff_modifier = text2num(R.falloff_modifier) || initial(R.falloff_modifier)
		R.chemfiresupp = text2num(R.chemfiresupp) || initial(R.chemfiresupp)
		R.intensitymod = text2num(R.intensitymod) || initial(R.intensitymod)
		R.durationmod = text2num(R.durationmod) || initial(R.durationmod)
		R.radiusmod = text2num(R.radiusmod) || initial(R.radiusmod)
		R.burncolormod = text2num(R.burncolormod) || initial(R.burncolormod)
		//And the final generation part
		R.generate_name()
		R.id = "omega-[i]"
		R.generate_description()
		R.calculate_gen_tier(R.calculate_value())
		R.save_chemclass()
		chemical_gen_classes_list["omega"] += R.id
		chemical_reagents_list[R.id] = R
		//Make a new recipe
		R.generate_assoc_recipe()

		data.spent_chemical = TRUE //so it doesn't appear next round
		data.save()
		i++
