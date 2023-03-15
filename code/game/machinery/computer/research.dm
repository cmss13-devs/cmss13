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

/obj/structure/machinery/computer/research/Destroy()
	QDEL_NULL(photocopier)
	. = ..()

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
			qdel(N)
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

/obj/structure/machinery/computer/research/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/computer/research/attack_hand(mob/user as mob)
	if(inoperable())
		return
	tgui_interact(user)

/obj/structure/machinery/computer/research/ui_static_data(mob/user)
	var/list/data = list(
		"base_purchase_cost" = base_purchase_cost,
		"main_terminal" = main_terminal,
		"terminal_view" = TRUE,
	)
	return data

/obj/structure/machinery/computer/research/ui_data(mob/user)
	var/list/data = list(
		"rsc_credits" = chemical_data.rsc_credits,
		"clearance_level" = chemical_data.clearance_level,
		"broker_cost" = max(RESEARCH_LEVEL_INCREASE_MULTIPLIER*(chemical_data.clearance_level + 1), 1),
		"research_documents" = chemical_data.research_documents,
		"published_documents" = chemical_data.research_publications,
		"clearance_x_access" = chemical_data.clearance_x_access,
		"photocopier_error" = !photocopier,
		"printer_toner" = photocopier?.toner
	)
	return data

/obj/structure/machinery/computer/research/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "ResearchTerminal", name)
		ui.open()

/obj/structure/machinery/computer/research/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(inoperable() || !ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	if(user.stat || user.is_mob_restrained() || !in_range(src, user))
		return
	switch(action)
		if ("read_document")
			var/print_type = params["print_type"]
			var/print_title = params["print_title"]
			var/obj/item/paper/research_report/report = chemical_data.get_report(print_type, print_title)
			if(report)
				report.read_paper(user)
			return
		if ("print")
			if(!photocopier)
				return
			if(photocopier.toner)
				var/print_type = params["print_type"]
				var/print_title = params["print_title"]
				photocopier.toner = max(0, photocopier.toner - 1)
				var/obj/item/paper/research_report/printing = new /obj/item/paper/research_report/(photocopier.loc)
				var/obj/item/paper/research_report/report = chemical_data.get_report(print_type, print_title)
				if(report)
					printing.name = report.name
					printing.info = report.info
					printing.data = report.data
					printing.completed = report.completed
		if("broker_clearance")
			if(!photocopier)
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
		if("purchase_document")
			if(!photocopier)
				return
			var/purchase_tier = FLOOR(text2num(params["purchase_document"]), 1)
			if(purchase_tier <= 0 || purchase_tier > 5)
				return
			if(purchase_tier > chemical_data.clearance_level)
				return
			var/purchase_cost = base_purchase_cost + purchase_tier * 2
			if(purchase_cost <= chemical_data.rsc_credits)
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
		if("publish_document")
			var/print_type = params["print_type"]
			var/print_title = params["print_title"]
			var/obj/item/paper/research_report/report = chemical_data.get_report(print_type, print_title)
			if(!report)
				to_chat(usr, SPAN_WARNING("Report data corrupted. Unable to transmit."))
				return
			chemical_data.publish_document(report, print_type, print_title)
		if("unpublish_document")
			var/print_title = params["print_title"]
			var/print_type = params["print_type"]
			chemical_data.unpublish_document(print_type, print_title)
		if("request_clearance_x_access")
			var/purchase_cost = 5
			if(purchase_cost <= chemical_data.rsc_credits)
				chemical_data.clearance_x_access = TRUE
				chemical_data.reached_x_access = TRUE
				chemical_data.update_credits(purchase_cost * -1)
				visible_message(SPAN_NOTICE("Clearance Level X Acquired."))
	playsound(loc, pick('sound/machines/computer_typing1.ogg','sound/machines/computer_typing2.ogg','sound/machines/computer_typing3.ogg'), 5, 1)

