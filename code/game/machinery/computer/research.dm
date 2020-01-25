/obj/structure/machinery/computer/research
	name = "research data terminal"
	desc = "A terminal for accessing research data."
	icon_state = "research"
	req_access = list(ACCESS_MARINE_RESEARCH)
	var/obj/structure/machinery/photocopier/photocopier

/obj/structure/machinery/computer/research/Initialize()
	spawn(7)
		photocopier = locate(/obj/structure/machinery/photocopier,get_step(src, NORTH))

/obj/structure/machinery/computer/research/attackby(obj/item/B, mob/living/user)
	if(!istype(B, /obj/item/card/id))
		return
	var/obj/item/card/id/card = B
	var/clearance_bypass = istype(B, /obj/item/card/id/silver/clearance_badge)
	if(!(ACCESS_WY_CORPORATE in card.access) && !clearance_bypass)
		visible_message(SPAN_NOTICE("[user] swipes their ID card on the [src], but it refused."))
		return
	
	var/setting = alert(usr,"How do you want to change the clearance settings?","[src]","Increase","Set to maximum","Set to minimum")
	if(!setting)
		return

	var/clearance_allowance = 6 - defcon_controller.current_defcon_level
	if(clearance_bypass)
		var/obj/item/card/id/silver/clearance_badge/C = B
		if(!C.clearance_access)
			visible_message(SPAN_NOTICE("[user] swipes the clearance card on the [src], but nothing happens."))
		if(clearance_bypass && user.real_name != C.registered_name)
			visible_message(SPAN_WARNING("WARNING: ILLEGAL CLEARANCE USER DETECTED. CARD DATA HAS BEEN WIPED."))
			C.clearance_access = 0
			return
		clearance_allowance = C.clearance_access

	switch(setting)
		if("Increase")
			if(chemical_research_data.clearance_level < clearance_allowance)
				chemical_research_data.clearance_level = min(5,chemical_research_data.clearance_level + 1)
		if("Set to maximum")
			chemical_research_data.clearance_level = clearance_allowance
		if("Set to minimum")
			chemical_research_data.clearance_level = 1

	visible_message(SPAN_NOTICE("[user] swipes their ID card on the [src], updating the clearance to level [chemical_research_data.clearance_level]."))
	msg_admin_niche("[user]/([user.ckey]) has updated the research clearance to level [chemical_research_data.clearance_level].")
	return

/obj/structure/machinery/computer/research/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return
	ui_interact(user)

/obj/structure/machinery/computer/research/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null, var/force_open = 0)
	var/list/data = list(
		"rsc_credits" = chemical_research_data.rsc_credits,
		"clearance_level" = chemical_research_data.clearance_level,
		"broker_cost" = max(3*(chemical_research_data.clearance_level + 1) - 2*(5 - defcon_controller.current_defcon_level), 1),
		"research_documents" = chemical_research_data.research_documents
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "research_data.tmpl", "Research Data Terminal", 400, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/structure/machinery/computer/research/Topic(href, href_list)
	if(stat & (BROKEN|NOPOWER) || !ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	if(user.stat || user.is_mob_restrained() || !in_range(src, user))
		return

	if(href_list["print_type"])
		if(photocopier.toner)
			photocopier.toner = max(0, photocopier.toner - 1)
			var/obj/item/paper/chem_report/printing = new /obj/item/paper/chem_report/(photocopier.loc)
			var/obj/item/paper/chem_report/report = chemical_research_data.research_documents[href_list["print_type"]][href_list["print_title"]]
			if(report)
				printing.name = report.name
				printing.info = report.info
				printing.data = report.data
				printing.completed = report.completed
		else
			to_chat(usr, SPAN_WARNING("Printer toner is empty."))
	else if(href_list["broker_clearance"])
		if(chemical_research_data.clearance_level < 5)
			var/cost = max(3*(chemical_research_data.clearance_level + 1) - 2*(5 - defcon_controller.current_defcon_level), 1)
			if(cost <= chemical_research_data.rsc_credits)
				chemical_research_data.update_credits(cost * -1)
				chemical_research_data.clearance_level++
				visible_message(SPAN_NOTICE("Clearance access increased to level [chemical_research_data.clearance_level] for [cost] credits."))
				msg_admin_niche("[user]/([user.ckey]) traded research credits to upgrade the clearance to level [chemical_research_data.clearance_level].")
			else
				to_chat(usr, SPAN_WARNING("Insufficient funds."))
		else
			to_chat(usr, SPAN_WARNING("Higher authorization is required to increase the clearance level further."))
	playsound(loc, pick('sound/machines/computer_typing1.ogg','sound/machines/computer_typing2.ogg','sound/machines/computer_typing3.ogg'), 5, 1)
	nanomanager.update_uis(src)