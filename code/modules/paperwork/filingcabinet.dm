/* Filing cabinets!
 * Contains:
 * Filing Cabinets
 * Security Record Cabinets
 * Medical Record Cabinets
 */


/*
 * Filing Cabinets
 */
/obj/structure/filingcabinet
	name = "filing cabinet"
	desc = "A large cabinet with drawers."
	icon = 'icons/obj/structures/props/furniture/misc.dmi'
	icon_state = "filingcabinet"
	density = TRUE
	anchored = TRUE
	wrenchable = TRUE
	var/list/allowed_types = list(/obj/item/paper, /obj/item/folder, /obj/item/clipboard, /obj/item/photo, /obj/item/paper_bundle, /obj/item/pamphlet)

/obj/structure/filingcabinet/proc/dump_contents()
	for(var/obj/I in src)
		I.forceMove(loc)

/obj/structure/filingcabinet/Destroy()
	dump_contents()
	for(var/obj/item/W in contents)
		if(W.unacidable)
			W.forceMove(loc)
	return ..()

/obj/structure/filingcabinet/chestdrawer
	name = "chest drawer"
	icon_state = "chestdrawer"


/obj/structure/filingcabinet/filingcabinet //not changing the path to avoid unecessary map issues, but please don't name stuff like this in the future -Pete
	icon_state = "tallcabinet"


/obj/structure/filingcabinet/Initialize()
	. = ..()
	for(var/obj/item/I in loc)
		if(is_type_in_list(I, allowed_types))
			I.forceMove(src)


/obj/structure/filingcabinet/attackby(obj/item/P as obj, mob/user as mob)
	if(HAS_TRAIT(P, TRAIT_TOOL_WRENCH))
		return ..()
	if(is_type_in_list(P, allowed_types))
		to_chat(user, SPAN_NOTICE("You put [P] in [src]."))
		if(user.drop_inv_item_to_loc(P, src))
			icon_state = "[initial(icon_state)]-open"
			sleep(5)
			icon_state = initial(icon_state)
			updateUsrDialog()
		return
	to_chat(user, SPAN_NOTICE("You can't put [P] in [src]!"))

/obj/structure/filingcabinet/attack_hand(mob/user as mob)
	if(length(contents) <= 0)
		to_chat(user, SPAN_NOTICE("\The [src] is empty."))
		return

	user.set_interaction(src)
	var/dat = "<center><table>"
	for(var/obj/item/P in src)
		dat += "<tr><td><a href='byond://?src=\ref[src];retrieve=\ref[P]'>[P.name]</a></td></tr>"
	dat += "</table></center>"
	show_browser(user, dat, name, "filingcabinet", width = 350, height = 300)

/obj/structure/filingcabinet/Topic(href, href_list)
	if(..())
		return
	if(!usr.Adjacent(src))
		close_browser(usr, "filingcabinet")
		return
	if(href_list["retrieve"])
		var/obj/item/P = locate(href_list["retrieve"])
		if (!P || P.loc != src || !usr.can_use_hands() || !usr.Adjacent(src))
			if(usr.Adjacent(src))
				attack_hand(usr)
				to_chat(usr, SPAN_WARNING("The document you're looking for isn't in \the [src] anymore."))//refresh so removed files disappear
			return
		close_browser(usr, "filingcabinet") // Close the menu
		usr.put_in_hands(P)
		updateUsrDialog()
		icon_state = "[initial(icon_state)]-open"
		addtimer(CALLBACK(src, "reset_icon"),0.5 SECONDS)
/obj/structure/filingcabinet/proc/reset_icon()
	icon_state = initial(icon_state)

/* Automated Research Sorting Cabinet*/

/obj/structure/filingcabinet/research
	name = "automated sorting cabinet"
	desc = "Marvel of sorting technology. Automatically sorts any research document you place in it."
	icon_state = "chestdrawer"
	allowed_types = list(/obj/item/paper/research_report)
	///contains references to all papers in the cabinet, for ease of looping.
	var/list/paper_contents = list()

/obj/structure/filingcabinet/research/attack_hand(mob/user)
	tgui_interact(user)

/obj/structure/filingcabinet/research/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AutosortingCabinet", name)
		ui.open()

/obj/structure/filingcabinet/research/ui_static_data(mob/user)
	var/list/data = list()
	data["paper_data"] = list()
	for(var/document_obj in paper_contents)
		var/obj/item/paper/research_report/document_report = document_obj
		var/chemical_value = 0
		var/list/properties_codes_level = list()
		for(var/datum/chem_property/properties_document in document_report?.data?.properties)
			if(document_report.completed) //only evaluate completed documents.
				var/attitude = (isNegativeProperty(properties_document) ? -1.5 : (isNeutralProperty(properties_document) ? -1 : 1) )
				//this should give us the absolutely rough estimate of how good paper is, value var on properties are a mess, so nada.
				chemical_value += properties_document.level * attitude
				properties_codes_level += list(list(
					"code" = properties_document.code,
					"level" = properties_document.level))
		chemical_value += ((document_report.data?.overdose || 0) / 5)
		var/list/document_spliced = splittext(document_report.name," ")
		var/doc_type_string = length(document_spliced) ? document_spliced[1] : ""
		data["paper_data"] += list(list(
			"name" = document_report.data?.name,
			"document_id" = document_report.data?.id,
			"completed" = document_report.completed,
			"overdose" = document_report.data?.overdose,
			"overall_value" = chemical_value,
			"document_type" = (doc_type_string == "Contract" ? 1 : (doc_type_string == "Synthesis" ? 2 : 3)),
			"properties_list" = properties_codes_level,
		))
	if(!length(data["paper_data"]))
		data["paper_data"] = list()
	return data

/obj/structure/filingcabinet/research/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return
	switch(action)
		if("take_out_document")
			for(var/obj/item/paper/research_report/document_report as anything in paper_contents)
				if(document_report.data?.id != params["document_id"])
					continue
				ui.user.put_in_hands(document_report)
				LAZYREMOVE(paper_contents, document_report)
				update_static_data_for_all_viewers()
				return TRUE
	return FALSE

/obj/structure/filingcabinet/research/attackby(obj/item/attacked_item, mob/user)
	if(HAS_TRAIT(attacked_item, TRAIT_TOOL_WRENCH))
		return ..()
	if(istype(attacked_item, /obj/item/paper/research_notes))
		if(istype(attacked_item, /obj/item/paper/research_notes/unique))
			var/obj/item/paper/research_notes/unique/unique_note = attacked_item
			var/obj/item/paper/research_report/new_report = unique_note.convert_to_chem_report()
			if(!new_report)
				to_chat(user, SPAN_WARNING("The notes could not be converted into a valid report."))
				return
			if(!new_report.valid_report || isnull(new_report.data))
				to_chat(user, SPAN_WARNING("You try to slot the converted notes into a sorting tray, but they are refused."))
				qdel(new_report) //clean up failed instance
				return
			var/duplicate = FALSE
			for(var/obj/item/paper/research_report/document_inside in paper_contents)
				if(document_inside.data?.id == new_report.data?.id)
					duplicate = TRUE
					break
			if(duplicate)
				to_chat(user, SPAN_WARNING("You try to slot the document into a sorting tray, but there is an identical document already in the array."))
				qdel(new_report)
				return

			to_chat(user, SPAN_NOTICE("You slot a document into a sorting tray, and [src] whirs to life."))
			qdel(unique_note)
			new_report.forceMove(src)
			LAZYADD(paper_contents, new_report)
			icon_state = "[initial(icon_state)]-open"
			addtimer(CALLBACK(src, "reset_icon"), 0.5 SECONDS)
			update_static_data_for_all_viewers()
			return
		to_chat(user, SPAN_WARNING("You try to slot the note into a sorting tray, but it is refused."))
		return
	if(is_type_in_list(attacked_item, allowed_types))
		var/obj/item/paper/research_report/document_report = attacked_item
		if(!document_report.valid_report || isnull(document_report.data))
			to_chat (user, SPAN_WARNING("You try to slot a document into a sorting tray, but it is refused."))
			return
		var/duplicate = FALSE
		for(var/obj/item/paper/research_report/document_inside in paper_contents)
			if(document_inside.data?.id == document_report.data?.id)
				duplicate = TRUE
				break
		if(duplicate)
			to_chat(user, SPAN_WARNING("You try to slot a document into a sorting tray, but there is an identical document already in the array."))
			return
		to_chat(user, SPAN_NOTICE("You slot a document into a sorting tray, and [src] whirs to life."))
		if(attacked_item.loc == user)
			user.drop_inv_item_to_loc(attacked_item, src)
		else
			attacked_item.forceMove(src)
		LAZYADD(paper_contents, attacked_item)
		icon_state = "[initial(icon_state)]-open"
		addtimer(CALLBACK(src, "reset_icon"),0.5 SECONDS)
		update_static_data_for_all_viewers()
		return
	to_chat(user, SPAN_WARNING("You try to slot [attacked_item] into a sorting tray, but it is refused."))
	return

/*
 * Security Record Cabinets
 */
/obj/structure/filingcabinet/security
	var/is_unopened = TRUE


/obj/structure/filingcabinet/security/proc/populate()
	if(!is_unopened)
		return
	is_unopened = FALSE
	if(!GLOB.data_core?.general)
		return
	for(var/datum/data/record/general_record in GLOB.data_core.general)
		var/datum/data/record/security_record
		for(var/datum/data/record/security_cabinet_record in GLOB.data_core.security)
			if((security_cabinet_record.fields["name"] == general_record.fields["name"] || security_cabinet_record.fields["id"] == general_record.fields["id"]))
				security_record = security_cabinet_record
				break
		if(security_record)
			var/obj/item/paper/security_record_paper = new /obj/item/paper(src)
			security_record_paper.info = "<CENTER><B>Security Record</B></CENTER><BR>"
			security_record_paper.info += "Name: [general_record.fields["name"]] ID: [general_record.fields["id"]]<BR>\nSex: [general_record.fields["sex"]]<BR>\nAge: [general_record.fields["age"]]<BR>\nPhysical Status: [general_record.fields["p_stat"]]<BR>\nMental Status: [general_record.fields["m_stat"]]<BR>"
			security_record_paper.info += "<BR>\n<CENTER><B>Security Data</B></CENTER><BR>\nCriminal Status: [security_record.fields["criminal"]]<BR>\n<BR>\nIncidents: [security_record.fields["incident"]]<BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>"
			var/counter = 1
			while(!isnull(security_record.fields["com_[counter]"])) //prevent infin looping
				security_record_paper.info += "[security_record.fields["com_[counter]"]]<BR>"
				counter++
			security_record_paper.info += "</TT>"
			security_record_paper.name = "Security Record ([general_record.fields["name"]])"

/obj/structure/filingcabinet/security/attack_hand(mob/user)
	populate()
	return ..()

/*
 * Medical Record Cabinets
 */
/obj/structure/filingcabinet/medical
	var/is_unopened = TRUE

/obj/structure/filingcabinet/medical/proc/populate()
	if(!is_unopened)
		return
	is_unopened = FALSE
	if(!GLOB.data_core?.general)
		return
	for(var/datum/data/record/general_record in GLOB.data_core.general)
		var/datum/data/record/medical_record
		for(var/datum/data/record/medical_cabinet_record as anything in GLOB.data_core.medical)
			if((medical_cabinet_record.fields["name"] == general_record.fields["name"] || medical_cabinet_record.fields["id"] == general_record.fields["id"]))
				medical_record = medical_cabinet_record
				break
		if(medical_record)
			var/obj/item/paper/medical_record_paper = new /obj/item/paper(src)
			medical_record_paper.info = "<CENTER><B>Medical Record</B></CENTER><BR>"
			medical_record_paper.info += "Name: [general_record.fields["name"]] ID: [general_record.fields["id"]]<BR>\nSex: [general_record.fields["sex"]]<BR>\nAge: [general_record.fields["age"]]<BR>\nPhysical Status: [general_record.fields["p_stat"]]<BR>\nMental Status: [general_record.fields["m_stat"]]<BR>"
			medical_record_paper.info += "<BR>\n<CENTER><B>Medical Data</B></CENTER><BR>\nBlood Type: [medical_record.fields["blood_type"]]<BR>\n<BR>\nMinor Disabilities: [medical_record.fields["minor_disability"]]<BR>\nDetails: [medical_record.fields["minor_disability_details"]]<BR>\n<BR>\nMajor Disabilities: [medical_record.fields["major_disability"]]<BR>\nDetails: [medical_record.fields["major_disability_details"]]<BR>\n<BR>\nAllergies: [medical_record.fields["allergies"]]<BR>\nDetails: [medical_record.fields["allergies_details"]]<BR>\n<BR>\nCurrent Diseases: [medical_record.fields["diseases"]] (per disease info placed in log/comment section)<BR>\nDetails: [medical_record.fields["diseases_details"]]<BR>\n<BR>\nImportant Notes:<BR>\n\t[medical_record.fields["notes"]]<BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>"
			var/counter = 1
			while (!isnull(medical_record.fields["com_[counter]"])) //prevent infin looping
				medical_record_paper.info += "[medical_record.fields["com_[counter]"]]<BR>"
				counter++
			medical_record_paper.info += "</TT>"
			medical_record_paper.name = "Medical Record ([general_record.fields["name"]])"

/obj/structure/filingcabinet/medical/attack_hand(mob/user)
	populate()
	return ..()

/*
 * Hydroponics Cabinets
 */

/obj/structure/filingcabinet/seeds
	name = "seeds cabinet"
	desc = "A large cabinet with drawers. This one is meant for storing seed packets."
	allowed_types = list(/obj/item/seeds)

/obj/structure/filingcabinet/disk
	name = "disk cabinet"
	desc = "A large cabinet with drawers. This one is meant for storing floral data disks."
	allowed_types = list(/obj/item/disk)
