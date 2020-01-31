var/global/datum/chemical_research_data/chemical_research_data = new /datum/chemical_research_data/

/datum/chemical_research_data/
	var/rsc_credits = 1
	var/clearance_level = 1
	var/list/research_documents = list()

/datum/chemical_research_data/proc/update_credits(var/change)
	rsc_credits = max(0, rsc_credits + change)

/datum/chemical_research_data/proc/save_document(var/obj/item/paper/chem_report/R, var/document_type, var/title)
	if(!research_documents["[document_type]"])
		research_documents["[document_type]"] = list()
	var/list/new_document[0]
	new_document["[title]"] = R
	research_documents["[document_type]"] += new_document
