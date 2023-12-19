GLOBAL_REFERENCE_LIST_INDEXED(prefab_papers, /obj/item/paper/prefab, document_title)
/obj/structure/filingcabinet/documentation
	name = "filing cabinet (documents)"
	var/list/available_categories = list()
	var/list/available_documents = list()

/obj/structure/filingcabinet/documentation/Initialize()
	. = ..()
	get_possible_documents()

/obj/structure/filingcabinet/documentation/proc/get_possible_documents()
	available_documents.Cut()
	for(var/docname in GLOB.prefab_papers)
		var/obj/item/paper/prefab/document = GLOB.prefab_papers[docname]
		if(!istype(document))
			continue
		log_debug("DOCUMENT: Checking [document]")
		if(!document.is_prefab || !document.doc_file_ref || (document.name == "paper"))
			log_debug("DOCUMENT: Prefab, Name or Ref fail.")
			continue
		if(!document.document_category || !(document.document_category in available_categories))
			log_debug("DOCUMENT: Category fail.")
			continue
		available_documents += docname
	return


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
			return

/obj/structure/filingcabinet/documentation/proc/give_document(mob/user as mob)
	for(var/paper in available_documents)
		log_debug("Document: [paper]")
	var/chosen = tgui_input_list(usr, "What document do you need?", "Choose Document", available_documents)
	var/selected = GLOB.prefab_papers[chosen].type
	var/obj/item/paper/prefab/document = new selected
	document.forceMove(user.loc)
	user.put_in_hands(document)
	to_chat(user, SPAN_NOTICE("You take [document] out of [src]."))
	return

/obj/structure/filingcabinet/documentation/military_police
	name = "filing cabinet (documents)"
	available_categories = list(PAPER_CATEGORY_MP)
//########################################
//########################################
//########################################
/obj/item/paper/prefab
	is_prefab = TRUE
	document_title = "BLANK"

/obj/item/paper/prefab/Initialize()
	. = ..()
	name = document_title

/obj/item/paper/prefab/html_checking
	document_category = PAPER_CATEGORY_PROVOST
	doc_file_ref = "undercover_provost"

/obj/item/paper/prefab/carbon/military_police
	name = "Blank MP Document"
	document_category = PAPER_CATEGORY_MP

/obj/item/paper/prefab/carbon/military_police/confiscation_receipt
	document_title = "C356R - Confiscation Receipt"
	doc_file_ref = "confiscation_receipt"
