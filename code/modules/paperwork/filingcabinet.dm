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
		for(var/allowed_type in allowed_types)
			if(istype(I, allowed_type))
				I.forceMove(src)


/obj/structure/filingcabinet/attackby(obj/item/P as obj, mob/user as mob)
	if(HAS_TRAIT(P, TRAIT_TOOL_WRENCH))
		. = ..()
	else
		for(var/allowed_type in allowed_types)
			if(istype(P, allowed_type))
				to_chat(user, SPAN_NOTICE("You put [P] in [src]."))
				if(user.drop_inv_item_to_loc(P, src))
					icon_state = "[initial(icon_state)]-open"
					sleep(5)
					icon_state = initial(icon_state)
					updateUsrDialog()
					break
			else
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

	return

/obj/structure/filingcabinet/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(href_list["retrieve"])
		close_browser(usr, "filingcabinet") // Close the menu

		//var/retrieveindex = text2num(href_list["retrieve"])
		var/obj/item/P = locate(href_list["retrieve"])//contents[retrieveindex]
		if(istype(P) && (P.loc == src) && src.Adjacent(usr))
			usr.put_in_hands(P)
			updateUsrDialog()
			icon_state = "[initial(icon_state)]-open"
			spawn(0)
				sleep(5)
				icon_state = initial(icon_state)

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
		chemical_value += document_report.data.overdose / 5
		var/list/document_spliced = splittext(document_report.name," ")
		data["paper_data"] += list(list(
			"name" = document_report.data.name,
			"document_id" = document_report.data?.id,
			"completed" = document_report.completed,
			"overdose" = document_report.data.overdose,
			"overall_value" = chemical_value,
			"document_type" = (document_spliced[1] == "Contract" ? 1 : (document_spliced[1] == "Synthesis" ? 2 : 3)),
			"properties_list" = properties_codes_level,
		))
	if(!length(data["paper_data"]))
		data["paper_data"] = null
	return data
/obj/structure/filingcabinet/research/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("take_out_document")
			for(var/obj/item/paper/research_report/document_report as anything in paper_contents)
				if(document_report.data?.id != params["document_id"])
					continue
				ui.user.put_in_hands(document_report)
				LAZYREMOVE(paper_contents, document_report)
				update_static_data_for_all_viewers()
				return TRUE


/obj/structure/filingcabinet/research/attackby(obj/item/attacked_item, mob/user)
	if(HAS_TRAIT(attacked_item, TRAIT_TOOL_WRENCH))
		return ..()
	if(istype(attacked_item, /obj/item/paper/research_notes))
		var/obj/item/paper/research_notes/note = attacked_item
		if(note.note_type != "synthesis")
			return
		attacked_item = note.convert_to_chem_report()
	for(var/allowed_type in allowed_types)
		if(istype(attacked_item, allowed_type))
			var/obj/item/paper/research_report/document_report = attacked_item
			if(document_report.valid_report && !isnull(document_report.data))
				var/duplicate = FALSE
				for(var/obj/item/paper/research_report/document_inside in paper_contents)
					if(document_inside.data.id == document_report.data.id)
						duplicate = TRUE
						to_chat(user, SPAN_WARNING("You try to slot a document into a sorting tray, but there is identical document already in the array."))
						break
				if(duplicate)
					return
				to_chat(user, SPAN_NOTICE("You slot a document into a sorting tray, and [src] whirs to life."))
				user.drop_inv_item_to_loc(attacked_item, src)
				LAZYADD(paper_contents, attacked_item)
				icon_state = initial(icon_state)+"-open"
				addtimer(VARSET_CALLBACK(src, icon_state, initial(icon_state)), 0.5 SECONDS)
				update_static_data_for_all_viewers()
			else
				to_chat(user, SPAN_WARNING("You try to slot a document into a sorting tray, but is refused."))
				return

/*
 * Security Record Cabinets
 */
/obj/structure/filingcabinet/security
	var/virgin = 1


/obj/structure/filingcabinet/security/proc/populate()
	if(virgin)
		for(var/datum/data/record/G in GLOB.data_core.general)
			var/datum/data/record/S
			for(var/datum/data/record/R in GLOB.data_core.security)
				if((R.fields["name"] == G.fields["name"] || R.fields["id"] == G.fields["id"]))
					S = R
					break
			if(S)
				var/obj/item/paper/P = new /obj/item/paper(src)
				P.info = "<CENTER><B>Security Record</B></CENTER><BR>"
				P.info += "Name: [G.fields["name"]] ID: [G.fields["id"]]<BR>\nSex: [G.fields["sex"]]<BR>\nAge: [G.fields["age"]]<BR>\nPhysical Status: [G.fields["p_stat"]]<BR>\nMental Status: [G.fields["m_stat"]]<BR>"
				P.info += "<BR>\n<CENTER><B>Security Data</B></CENTER><BR>\nCriminal Status: [S.fields["criminal"]]<BR>\n<BR>\nIncidents: [S.fields["incident"]]<BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>"
				var/counter = 1
				while(S.fields["com_[counter]"])
					P.info += "[S.fields["com_[counter]"]]<BR>"
					counter++
				P.info += "</TT>"
				P.name = "Security Record ([G.fields["name"]])"
			virgin = 0 //tabbing here is correct- it's possible for people to try and use it
						//before the records have been generated, so we do this inside the loop.

/obj/structure/filingcabinet/security/attack_hand()
	populate()
	..()

/*
 * Medical Record Cabinets
 */
/obj/structure/filingcabinet/medical
	var/virgin = 1

/obj/structure/filingcabinet/medical/proc/populate()
	if(virgin)
		for(var/datum/data/record/G in GLOB.data_core.general)
			var/datum/data/record/M
			for(var/datum/data/record/R as anything in GLOB.data_core.medical)
				if((R.fields["name"] == G.fields["name"] || R.fields["id"] == G.fields["id"]))
					M = R
					break
			if(M)
				var/obj/item/paper/P = new /obj/item/paper(src)
				P.info = "<CENTER><B>Medical Record</B></CENTER><BR>"
				P.info += "Name: [G.fields["name"]] ID: [G.fields["id"]]<BR>\nSex: [G.fields["sex"]]<BR>\nAge: [G.fields["age"]]<BR>\nPhysical Status: [G.fields["p_stat"]]<BR>\nMental Status: [G.fields["m_stat"]]<BR>"

				P.info += "<BR>\n<CENTER><B>Medical Data</B></CENTER><BR>\nBlood Type: [M.fields["b_type"]]<BR>\n<BR>\nMinor Disabilities: [M.fields["mi_dis"]]<BR>\nDetails: [M.fields["mi_dis_d"]]<BR>\n<BR>\nMajor Disabilities: [M.fields["ma_dis"]]<BR>\nDetails: [M.fields["ma_dis_d"]]<BR>\n<BR>\nAllergies: [M.fields["alg"]]<BR>\nDetails: [M.fields["alg_d"]]<BR>\n<BR>\nCurrent Diseases: [M.fields["cdi"]] (per disease info placed in log/comment section)<BR>\nDetails: [M.fields["cdi_d"]]<BR>\n<BR>\nImportant Notes:<BR>\n\t[M.fields["notes"]]<BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>"
				var/counter = 1
				while(M.fields["com_[counter]"])
					P.info += "[M.fields["com_[counter]"]]<BR>"
					counter++
				P.info += "</TT>"
				P.name = "Medical Record ([G.fields["name"]])"
			virgin = 0 //tabbing here is correct- it's possible for people to try and use it
						//before the records have been generated, so we do this inside the loop.

/obj/structure/filingcabinet/medical/attack_hand()
	populate()
	..()

/*
 * Hydroponics Cabinets
 */

/obj/structure/filingcabinet/seeds
	name = "seeds cabinet"
	desc = "A large cabinet with drawers. This one is meant for storing seed packets"
	allowed_types = list(/obj/item/seeds)

/obj/structure/filingcabinet/disk
	name = "disk cabinet"
	desc = "A large cabinet with drawers. This one is meant for storing floral data disks"
	allowed_types = list(/obj/item/disk)
