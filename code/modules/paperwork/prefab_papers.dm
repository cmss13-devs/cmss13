GLOBAL_REFERENCE_LIST_INDEXED(prefab_papers, /obj/item/paper/prefab, document_title)
/obj/structure/filingcabinet/documentation
	name = "documents cabinet"
	/// The categories available from this cabinet. Manually populated.
	var/list/available_categories = list()
	/// The possible options that can be withdrawn. Automatically populated by get_possible_documents().
	var/list/available_documents = list()
	/// Number of prefab documents that can be withdrawn. Cap intended to prevent people spamming infinite copies.
	var/remaining_documents = 30

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
	var/choice = tgui_alert(user, "Do you wish to open the cabinet, or retrieve a document template?", "Action", list("Open", "Document"), 20 SECONDS)
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
			if(!remaining_documents)
				to_chat(user, SPAN_WARNING("[src] has no remaining official forms!"))
				return
			give_document(user)
			return

/obj/structure/filingcabinet/documentation/proc/give_document(mob/user as mob)
	if(!remaining_documents)
		to_chat(user, SPAN_WARNING("[src] has no remaining official forms!"))
		return FALSE
	for(var/paper in available_documents)
		log_debug("Document: [paper]")
	var/chosen = tgui_input_list(usr, "What document do you need?", "Choose Document", available_documents)
	var/selected = GLOB.prefab_papers[chosen].type
	var/obj/item/paper/prefab/document = new selected
	document.forceMove(user.loc)
	user.put_in_hands(document)
	to_chat(user, SPAN_NOTICE("You take [document] out of [src]."))
	remaining_documents--
	return TRUE

/obj/structure/filingcabinet/documentation/military_police
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

/obj/item/paper/prefab/carbon/military_police/appeal_form
	document_title = "PR301 - Appeals Form"
	doc_file_ref = "appeal_form"

/obj/item/paper/prefab/carbon/military_police/confiscation_receipt
	document_title = "PR356 - Confiscation Receipt"
	doc_file_ref = "confiscation_receipt"

/obj/item/paper/prefab/carbon/military_police/apology_notice
	document_title = "NJ910 - Apology Notice"
	doc_file_ref = "apology_notice"
