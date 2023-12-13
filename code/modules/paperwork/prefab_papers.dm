/obj/structure/filingcabinet/documentation
	name = "filing cabinet (documents)"
	var/list/available_categories = list()
	var/list/available_documents = list()

/obj/structure/filingcabinet/documentation/Initialize()
	. = ..()
	refresh_documents()

/obj/structure/filingcabinet/documentation/proc/refresh_documents()
	for(var/obj/item/paper/prefab/prefab in subtypesof(/obj/item/paper/prefab))
		if(!prefab.paper_prefab)
			log_debug("Document: Not prefab")
			continue
		if(!prefab.document_category)
			log_debug("Document: No category")
			continue
		if(!(prefab.document_category in available_categories))
			log_debug("Document: Not in available categories")
			continue
		var/doc_name = prefab.name
		if(doc_name == "paper")
			log_debug("Document: Bad name")
			continue
		available_documents += doc_name[prefab]

/obj/structure/filingcabinet/documentation/attack_hand(mob/user as mob)
	var/choice = tgui_alert(user, "Do you wish to Open the cabinet, or retrieve a document template?", "Action", list("Open", "Document"), 20 SECONDS)
	switch(choice)
		if("Open")
			if(contents.len <= 0)
				to_chat(user, SPAN_NOTICE("\The [src] is empty."))
				return

			user.set_interaction(src)
			var/dat = "<center><table>"
			for(var/obj/item/P in src)
				dat += "<tr><td><a href='?src=\ref[src];retrieve=\ref[P]'>[P.name]</a></td></tr>"
			dat += "</table></center>"
			show_browser(user, dat, name, "filingcabinet", "size=350x300")
			return
		if("Document")
			give_document(user)

/obj/structure/filingcabinet/documentation/proc/give_document(mob/user as mob)
	for(var/paper in available_documents)
		log_debug("Document: [paper]")
	return

/obj/structure/filingcabinet/documentation/military_police
	name = "filing cabinet (documents)"
	available_categories = list(PAPER_CATEGORY_MP)
//########################################
//########################################
//########################################
/obj/item/paper/prefab
	paper_prefab = TRUE

/obj/item/paper/prefab/html_checking
	document_category = PAPER_CATEGORY_PROVOST
	document_title = "undercover_provost"

/obj/item/paper/prefab/carbon/military_police
	name = "MP Document"
	document_category = PAPER_CATEGORY_MP

/obj/item/paper/prefab/carbon/military_police/confiscation_receipt
	name = "C356R - Confiscation Receipt"
	document_title = "confiscation_receipt"
