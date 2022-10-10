/obj/structure/machinery/computer/research
	name = "research data terminal"
	desc = "A terminal for accessing research data."
	icon_state = "research"
	req_access = list(ACCESS_MARINE_RESEARCH)
	var/base_purchase_cost = 5
	var/max_clearance = 1 // max clearance level reached by research
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
	var/obj/item/card/id/silver/clearance_badge/card = B
	if(!istype(card))
		visible_message(SPAN_NOTICE("[user] swipes their ID card on \the [src], but it is refused."))
		return
	if(card.clearance_access <= chemical_data.clearance_level || (card.clearance_access == 6 && chemical_data.clearance_level >= 5 && chemical_data.clearance_x_access))
		visible_message(SPAN_NOTICE("[user] swipes the clearance card on the [src], but nothing happens."))
		return
	if(user.real_name != card.registered_name)
		visible_message(SPAN_WARNING("WARNING: ILLEGAL CLEARANCE USER DETECTED. CARD DATA HAS BEEN WIPED."))
		card.clearance_access = 0
		return

	var/give_level
	var/give_x = FALSE
	if(card.clearance_access == 6)
		give_level = 5
		give_x = TRUE
	else
		give_level = card.clearance_access

	chemical_data.clearance_level = give_level
	if(give_x)
		chemical_data.clearance_x_access = TRUE
		chemical_data.reached_x_access = TRUE

	visible_message(SPAN_NOTICE("[user] swipes their ID card on \the [src], updating the clearance to level [give_level][give_x ? "X" : ""]."))
	msg_admin_niche("[key_name(user)] has updated the research clearance to level [give_level][give_x ? "X" : ""].")
	return

/obj/structure/machinery/computer/research/attack_hand(mob/user as mob)
	if(inoperable())
		return
	ui_interact(user)

/obj/structure/machinery/computer/research/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null, var/force_open = 0)
	var/list/data = list(
		"rsc_credits" = chemical_data.rsc_credits,
		"clearance_level" = chemical_data.clearance_level,
		"broker_cost" = max(RESEARCH_LEVEL_INCREASE_MULTIPLIER*(chemical_data.clearance_level + 1), 1),
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
		if(!photocopier)
			to_chat(user, SPAN_WARNING("ERROR: no linked printer found."))
			return
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
	else if(href_list["broker_clearance"])
		if(!photocopier)
			to_chat(user, SPAN_WARNING("ERROR: no linked printer found."))
			return
		if(alert(usr,"The CL can swipe their ID card on the console to increase clearance for free, given enough DEFCON. Are you sure you want to spend research credits to increase the clearance immediately?","Warning","Yes","No") != "Yes")
			return
		if(chemical_data.clearance_level < 5)
			var/cost = max(RESEARCH_LEVEL_INCREASE_MULTIPLIER*(chemical_data.clearance_level + 1), 1)
			if(cost <= chemical_data.rsc_credits)
				chemical_data.update_credits(cost * -1)
				chemical_data.clearance_level++
				visible_message(SPAN_NOTICE("Clearance access increased to level [chemical_data.clearance_level] for [cost] credits."))
				msg_admin_niche("[key_name(user)] traded research credits to upgrade the clearance to level [chemical_data.clearance_level].")
				if(max_clearance < chemical_data.clearance_level)
					chemical_data.update_income(1) //Bonus income and a paper for buying clearance instead of swiping it up
					switch(chemical_data.clearance_level)
						if(2)
							new /obj/item/paper/research_notes/unique/tier_two/(photocopier.loc)
							max_clearance = 2
						if(3)
							new /obj/item/paper/research_notes/unique/tier_three/(photocopier.loc)
							max_clearance = 3
						if(4)
							new /obj/item/paper/research_notes/unique/tier_four/(photocopier.loc)
							max_clearance = 4
						if(5)
							new /obj/item/paper/research_notes/unique/tier_five/(photocopier.loc)
							max_clearance = 5
			else
				to_chat(usr, SPAN_WARNING("Insufficient funds."))
		else
			to_chat(usr, SPAN_WARNING("Higher authorization is required to increase the clearance level further."))
	else if(href_list["purchase_document"])
		if(!photocopier)
			to_chat(user, SPAN_WARNING("ERROR: no linked printer found."))
			return
		var/purchase_tier = text2num(href_list["purchase_document"])
		if(purchase_tier < 0 || purchase_tier > 5)
			return
		var/purchase_cost = base_purchase_cost + purchase_tier * 2
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
