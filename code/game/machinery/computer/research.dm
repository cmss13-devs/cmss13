/obj/structure/machinery/computer/research
	name = "research data terminal"
	desc = "A terminal for accessing research data."
	icon_state = "research"
	req_access = list(ACCESS_MARINE_RESEARCH)
	var/base_purchase_cost = 5
	var/main_terminal = FALSE
	var/obj/structure/machinery/photocopier/photocopier

/obj/structure/machinery/computer/research/main_terminal
	name = "research main terminal"
	main_terminal = TRUE
	req_access = list(ACCESS_MARINE_CMO)

/obj/structure/machinery/computer/research/Initialize()
	. = ..()
	photocopier = locate(/obj/structure/machinery/photocopier,get_step(src, NORTH))

/obj/structure/machinery/computer/research/attackby(obj/item/B, mob/living/user)
	//Collecting grants
	if(istype(B, /obj/item/paper/research_notes))
		var/obj/item/paper/research_notes/N = B
		if(N.note_type == "grant")
			if(!N.grant)
				return
			chemical_data.update_credits(N.grant)
			visible_message(SPAN_NOTICE("[user] scans the [N.name] on the [src], collecting the [N.grant] research credits."))
			N.grant = 0
			return
	//Saving to database
	if(istype(B, /obj/item/paper))
		var/obj/item/paper/P = B
		var/response = alert(usr,"Do you want to save [P.name] to the research database?","[src]","Yes","No")
		if(response != "Yes")
			return
		response = alert(usr,"Use existing or new category?","[src]","Existing","New")
		if(response == "Existing")
			var/list/pool = list()
			for(var/category in chemical_data.research_documents)
				pool += category
			pool = sortAssoc(pool)
			response = tgui_input_list(usr,"Select a category:", "Categories", pool)
		else if(response == "New")
			response = input(usr,"Please enter the category of the paper:")
		if(!response)
			response = "Misc."
		var/obj/item/paper/research_report/CR = P.convert_to_chem_report()
		chemical_data.save_document(CR, response, CR.name)
		return
	//Clearance Updating
	if(!istype(B, /obj/item/card/id))
		return
	var/obj/item/card/id/card = B
	var/clearance_bypass = istype(B, /obj/item/card/id/silver/clearance_badge)
	if(!(ACCESS_WY_CORPORATE in card.access) && !clearance_bypass)
		visible_message(SPAN_NOTICE("[user] swipes their ID card on \the [src], but it is refused."))
		return

	var/list/options = list("Increase","Set to maximum","Set to minimum")

	var/datum/techtree/T = GET_TREE(TREE_MARINE)
	// Tier 1 allows for CL2, Tier 2 allows for CL4 and Tier 3 allows for CL5
	var/clearance_allowance = min(T.tier?.tier*2, 5)

	var/can_give_x = FALSE
	if(clearance_bypass)
		var/obj/item/card/id/silver/clearance_badge/C = B
		if(!C.clearance_access)
			visible_message(SPAN_NOTICE("[user] swipes the clearance card on the [src], but nothing happens."))
		if(clearance_bypass && user.real_name != C.registered_name)
			visible_message(SPAN_WARNING("WARNING: ILLEGAL CLEARANCE USER DETECTED. CARD DATA HAS BEEN WIPED."))
			C.clearance_access = 0
			return

		if(C.clearance_access == 6)
			clearance_allowance = 5
			can_give_x = TRUE

			if(chemical_data.clearance_level == 5)
				options.Add("Give clearance X")
		else
			clearance_allowance = C.clearance_access


	var/setting = tgui_input_list(usr,"How do you want to change the clearance settings?","[src]", options)
	if(!setting)
		return

	switch(setting)
		if("Increase")
			if(chemical_data.clearance_level < clearance_allowance)
				chemical_data.clearance_level = min(5,chemical_data.clearance_level + 1)
		if("Set to maximum")
			chemical_data.clearance_level = max(clearance_allowance, chemical_data.clearance_level)
		if("Set to minimum")
			chemical_data.clearance_level = 1
		if("Give clearance X")
			if(!can_give_x)
				to_chat(usr, SPAN_WARNING("Access denied."))
				return

			chemical_data.clearance_x_access = TRUE
			chemical_data.reached_x_access = TRUE

			visible_message(SPAN_NOTICE("[user] swipes their ID card on \the [src], granting X clearance access to the terminal."))
			return

	if(chemical_data.clearance_level == 5 && chemical_data.reached_x_access)
		chemical_data.clearance_x_access = TRUE
	else
		chemical_data.clearance_x_access = FALSE

	visible_message(SPAN_NOTICE("[user] swipes their ID card on \the [src], updating the clearance to level [chemical_data.clearance_level]."))
	msg_admin_niche("[key_name(user)] has updated the research clearance to level [chemical_data.clearance_level].")
	return

/obj/structure/machinery/computer/research/attack_hand(mob/user as mob)
	if(inoperable())
		return
	ui_interact(user)

/obj/structure/machinery/computer/research/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null, var/force_open = 0)
	var/list/data = list(
		"rsc_credits" = chemical_data.rsc_credits,
		"clearance_level" = chemical_data.clearance_level,
		"broker_cost" = max(3*(chemical_data.clearance_level + 1), 1),
		"base_purchase_cost" = base_purchase_cost,
		"research_documents" = chemical_data.research_documents,
		"published_documents" = chemical_data.research_publications,
		"main_terminal" = main_terminal,
		"terminal_view" = TRUE,
		"clearance_x_access" = chemical_data.clearance_x_access
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "research_data.tmpl", "Research Data Terminal", 400, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/structure/machinery/computer/research/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(inoperable() || !ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	if(user.stat || user.is_mob_restrained() || !in_range(src, user))
		return
	if(href_list["read_document"])
		var/obj/item/paper/research_report/report = chemical_data.research_documents[href_list["print_type"]][href_list["print_title"]]
		if(report)
			report.read_paper(user)
	else if(href_list["print"])
		if(photocopier.toner)
			photocopier.toner = max(0, photocopier.toner - 1)
			var/obj/item/paper/research_report/printing = new /obj/item/paper/research_report/(photocopier.loc)
			var/obj/item/paper/research_report/report = chemical_data.research_documents[href_list["print_type"]][href_list["print_title"]]
			if(report)
				printing.name = report.name
				printing.info = report.info
				printing.data = report.data
				printing.completed = report.completed
		else
			to_chat(usr, SPAN_WARNING("Printer toner is empty."))
	else if(href_list["transmit"])
		var/obj/item/paper/research_report/report = chemical_data.research_documents[href_list["print_type"]][href_list["print_title"]]
		if(!report)
			to_chat(usr, SPAN_WARNING("Report data corrupted. Unable to transmit."))
			return
		var/datum/reagent/R = report.data
		if(!R || !R.properties)
			to_chat(usr, SPAN_WARNING("Report contains no chemical data or chemical contains no known properties. Transmission cancelled."))
			return
		if(R.chemclass == CHEM_CLASS_SPECIAL || R.chemclass == CHEM_CLASS_NONE)
			to_chat(usr, SPAN_WARNING("Chemical complexity above transmission data threshold. Transmission cancelled."))
			return
		var/transmission_cost = R.calculate_value()
		if(alert(usr,"This will transmit the data regarding [R.name] to the WY central database, so that other research labs can continue the research. The complexity of this chemical will cost [transmission_cost] credits to transmit. Confirm transmission?","Confirm Data Transmission","Confirm","No") != "Confirm")
			return
		if(transmission_cost > chemical_data.rsc_credits)
			to_chat(usr, SPAN_WARNING("Insufficient funds."))
			return
		if(chemical_data.transmit_chem_data(R))
			chemical_data.update_credits(transmission_cost * -1)
			to_chat(usr, SPAN_NOTICE("Data for [R.name] has been transmitted."))
		else
			to_chat(usr, SPAN_WARNING("Error during transmission."))
	else if(href_list["broker_clearance"])
		if(alert(usr,"The CL can swipe their ID card on the console to increase clearance for free, given enough DEFCON. Are you sure you want to spend research credits to increase the clearance immediately?","Warning","Yes","No") != "Yes")
			return
		if(chemical_data.clearance_level < 5)
			var/cost = max(3*(chemical_data.clearance_level + 1), 1)
			if(cost <= chemical_data.rsc_credits)
				chemical_data.update_credits(cost * -1)
				chemical_data.clearance_level++
				visible_message(SPAN_NOTICE("Clearance access increased to level [chemical_data.clearance_level] for [cost] credits."))
				msg_admin_niche("[key_name(user)] traded research credits to upgrade the clearance to level [chemical_data.clearance_level].")
			else
				to_chat(usr, SPAN_WARNING("Insufficient funds."))
		else
			to_chat(usr, SPAN_WARNING("Higher authorization is required to increase the clearance level further."))
	else if(href_list["purchase_document"])
		var/purchase_tier = text2num(href_list["purchase_document"])
		if(purchase_tier < 0 || purchase_tier > 5)
			return
		var/purchase_cost = base_purchase_cost + purchase_tier * purchase_tier
		if(purchase_cost <= chemical_data.rsc_credits)
			if(alert(usr,"Are you sure you wish to purchase a new level [purchase_tier] chemical report for [purchase_cost] credits?","Warning","Yes","No") != "Yes")
				return
			chemical_data.update_credits(purchase_cost * -1)
			var/obj/item/paper/research_notes/unique/N
			switch(purchase_tier)
				if(1)
					N = new /obj/item/paper/research_notes/unique/tier_one/(photocopier.loc)
				if(2)
					N = new /obj/item/paper/research_notes/unique/tier_two/(photocopier.loc)
				if(3)
					N = new /obj/item/paper/research_notes/unique/tier_three/(photocopier.loc)
				if(4)
					N = new /obj/item/paper/research_notes/unique/tier_four/(photocopier.loc)
				else
					N = new /obj/item/paper/research_notes/unique/tier_five/(photocopier.loc)
			visible_message(SPAN_NOTICE("Research report for [N.data.name] has been purchased."))
		else
			to_chat(usr, SPAN_WARNING("Insufficient funds."))
	else if(href_list["publish_document"])
		var/obj/item/paper/research_report/report = chemical_data.research_documents[href_list["print_type"]][href_list["print_title"]]
		if(!report)
			to_chat(usr, SPAN_WARNING("Report data corrupted. Unable to transmit."))
			return
		chemical_data.publish_document(report, href_list["print_type"], href_list["print_title"])
		to_chat(usr, SPAN_NOTICE("Published [report.name]."))
	else if(href_list["unpublish_document"])
		var/title = href_list["print_title"]
		if(chemical_data.unpublish_document(href_list["print_type"], title))
			to_chat(usr, SPAN_NOTICE("Removed the publication for [title]."))
	else if(href_list["request_clearance_x_access"])
		var/purchase_cost = 5
		if(alert(usr,"Are you sure you wish request clearance level X access for [purchase_cost] credits?","Warning","Yes","No") != "Yes")
			return
		if(purchase_cost <= chemical_data.rsc_credits)
			chemical_data.clearance_x_access = TRUE
			chemical_data.reached_x_access = TRUE
			chemical_data.update_credits(purchase_cost * -1)
			visible_message(SPAN_NOTICE("Clearance Level X Acquired."))
		else
			to_chat(usr, SPAN_WARNING("Insufficient funds."))
	playsound(loc, pick('sound/machines/computer_typing1.ogg','sound/machines/computer_typing2.ogg','sound/machines/computer_typing3.ogg'), 5, 1)
	nanomanager.update_uis(src)
