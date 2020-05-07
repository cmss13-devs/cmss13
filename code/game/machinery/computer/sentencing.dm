#define IMPORT_INCIDENT "import_incident"
#define PERMABRIG_SENTENCE 60 // Measured in minutes
/obj/structure/machinery/computer/sentencing/
	name = "\improper Jurisdictional Automated System"
	desc = "A powerful machine produced by Weston-Yamada to streamline all punishment of prisoners. The best grade policing gear seen on this side of the galaxy."
	icon_state = "jas"
	req_one_access = list(ACCESS_MARINE_BRIG, ACCESS_MARINE_BRIDGE)

	var/datum/crime_incident/incident
	var/menu_screen = "main_menu"
	var/paper_counter = 0

/obj/structure/machinery/computer/sentencing/attack_hand(mob/user as mob)
	if(..() || !allowed(usr) || stat & (NOPOWER|BROKEN))
		return

	ui_interact(user)

/obj/structure/machinery/computer/sentencing/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/paper/incident) && menu_screen == IMPORT_INCIDENT)
		user.temp_drop_inv_item(O)
		O.forceMove(loc)

		if(import(O))
			ping("\The [src] pings, \"Successfully imported incident report!\"")
			menu_screen = "incident_report"
			updateUsrDialog()
		else
			to_chat(user, SPAN_ALERT("Could not import incident report."))

		qdel(O)
		return
		
	else if(istype(O, /obj/item/paper/) && menu_screen == IMPORT_INCIDENT)
		to_chat(user, SPAN_ALERT("This console only accepts authentic incident reports. Copies are invalid."))
		return

	else if(istype(O, /obj/item/grab))
		var/obj/item/grab/G = O
		if(ishuman(G.grabbed_thing))
			var/mob/living/carbon/human/H = G.grabbed_thing
			var/obj/item/card/id/C = H.get_idcard()
			if(istype(C))
				if(incident && C.registered_name)
					incident.criminal_name = C.registered_name
					ping("\The [src] pings, \"Criminal [C.registered_name] verified.\"")
		return
	..()

/obj/structure/machinery/computer/sentencing/proc/import(var/obj/item/paper/incident/I)
	incident = null

	if(istype(I) && I.incident)
		incident = I.incident

	return incident

/obj/structure/machinery/computer/sentencing/ui_interact(mob/user as mob)
	var/dat = ""
	switch(menu_screen)
		if("import_incident")
			dat += import_incident()
		if("incident_report")
			dat += incident_report()
		if("low_severity")
			dat += add_charges()
		if("med_severity")
			dat += add_charges()
		if("high_severity")
			dat += add_charges()
		if("extra_severity")
			dat += add_charges()
		else
			dat += main_menu()

	show_browser(user, dat, "Criminal Sentencing", "crim_sentence", "size=710x725")
	onclose(user, "crim_sentence")

/obj/structure/machinery/computer/sentencing/proc/main_menu()
	var/dat = "<center><h2>Welcome! Please select an option!</h2><br>"
	dat += "<a href='?src=\ref[src];button=import_incident'>Import Incident</a>   <a href='?src=\ref[src];button=new_incident'>New Report</a></center>"

	return dat

/obj/structure/machinery/computer/sentencing/proc/import_incident()
	var/dat = "<center><h2>Incident Import</h2><br>"
	dat += "Insert an existing Securty Incident Report paper."

	dat += "<br><hr>"
	dat += "<a href='?src=\ref[src];button=change_menu;choice=main_menu'>Cancel</a></center>"

	return dat

/obj/structure/machinery/computer/sentencing/proc/incident_report()
	var/dat = ""
	if(!istype(incident))
		dat += "There was an error loading the incident, please <a href='?src=\ref[src];button=change_menu;choice=main_menu'>Try Again</a>"
		return dat

	dat += "<table class='border'>"
	dat += "<tr>"
	dat += "<th>Criminal:</th>"
	dat += "<td><a href='?src=\ref[src];button=change_criminal;'>"
	if(incident.criminal_name)
		dat += "[incident.criminal_name]"
	else
		dat += "None"
	dat += "</a></td>"
	dat += "</tr>"

	dat += "<tr>"
	dat += "<th>Brig Sentence:</th>"
	dat += "<td>"
	if(incident.brig_sentence)
		if(incident.brig_sentence < PERMABRIG_SENTENCE)
			dat += "[incident.brig_sentence] MINUTES"
		else
			dat += "Perma Brig"
	else
		dat += "None"
	dat += "</a></td>"
	dat += "</tr>"

	dat += "</table>"

	dat += "<br>"
	dat += list_notes()

	dat += "<br>"
	dat += list_charges(TRUE)

	dat += "<br>"
	dat += list_witnesses()

	dat += "<br>"
	dat += list_evidence()

	dat += "<br><hr>"
	dat += "<center>"
	dat += " <a href='?src=\ref[src];button=print_encoded_form'>Export Incident</a> "
	dat += "<a href='?src=\ref[src];button=change_menu;choice=main_menu'>Cancel</a></center>"
	return dat

/obj/structure/machinery/computer/sentencing/proc/list_charges(var/buttons = FALSE)
	var/dat = ""
	dat += "<table class='border'>"
	dat += "<tr>"
	
	if(buttons)
		dat += "<th colspan='3'>Charges <a href='?src=\ref[src];button=change_menu;choice=low_severity'>Add</a></th>"
	else
		dat += "<th colspan='2'>Charges</th>"
	dat += "</tr>"

	for(var/datum/law/L in incident.charges)
		dat += "<tr>"
		dat += "<td><b>[L.name]</b></td>"
		dat += "<td><i>[L.desc]</i></td>"
		if(buttons)
			dat += "<td><a href='?src=\ref[src];button=remove_charge;law=\ref[L]'>Remove</a></td>"
		dat += "</tr>"

	dat += "</table>"
	return dat

/obj/structure/machinery/computer/sentencing/proc/list_sentence()
	var/dat = ""
	dat += "<table class='border'>"

	dat += "<tr><th colspan='2'>Criminal</th></tr>"
	dat += "<tr><td colspan='2'><center>"
	if(incident.criminal_name)
		dat += "[incident.criminal_name]"
	else
		dat += "None"
	dat += "</center></td></tr>"

	dat += "<tr>"
	dat += "<th colspan='2'>Sentence</th>"
	dat += "</tr><tr>"
	dat += "<td>Brig</td>"
	dat += "<td>"
	if(incident.brig_sentence)
		if(incident.brig_sentence < PERMABRIG_SENTENCE)
			dat += "[incident.brig_sentence] MINUTES"
		else
			dat += "PERMA BRIGGED"
	else
		dat += "None"
	dat += "</td>"

	dat += "</tr><tr>"

	dat += "<td>"
	dat += "</td>"
	dat += "</tr>"

	dat += "</table>"
	return dat

/obj/structure/machinery/computer/sentencing/proc/list_witnesses()
	var/dat = ""
	dat += "<table class='border'>"
	dat += "<th colspan='3'>Witnesses <a href='?src=\ref[src];button=add_witness;title=Witness'>Add</a></th>"
	for(var/witness in incident.witnesses)
		dat += "<tr>"

		if(incident.witnesses[witness])
			dat += "<td>"
			dat += "</b>[witness]</b>"
			dat += "</td><td>"
			dat += "<i>[incident.witnesses[witness]]</i>"
		else
			dat += "<td colspan='2'>"
			dat += "<b>[witness]</b>"

		dat += "</td><td>"
		dat += "<a href='?src=\ref[src];button=add_witness_notes;choice=\ref[witness]'>Notes</a><br>"
		dat += "<a href='?src=\ref[src];button=remove_witness;choice=\ref[witness]'>Remove</a>"
		dat += "</td></tr>"

	dat += "</table>"
	return dat

/obj/structure/machinery/computer/sentencing/proc/list_evidence()
	var/dat = ""
	var/list/evidence = incident.evidence

	dat += "<table class='border'>"
	dat += "<th colspan='3'>Evidence <a href='?src=\ref[src];button=add_evidence'>Add</a></th>"
	for(var/item in evidence)
		dat += "<tr>"

		if(evidence[item])
			dat += "<td>"
			dat += "<b>[item]</b>"
			dat += "</td><td>"
			dat += "<i>[evidence[item]]</i>"
		else
			dat += "<td colspan='2'>"
			dat += "<b>[item]</b>"

		dat += "</td><td>"
		dat += "<a href='?src=\ref[src];button=add_evidence_notes;choice=\ref[item]'>Notes</a><br>"
		dat += "<a href='?src=\ref[src];button=remove_evidence;choice=\ref[item]'>Remove</a>"
		dat += "</td></tr>"

	dat += "</table>"
	return dat

/obj/structure/machinery/computer/sentencing/proc/list_notes()
	var/dat = ""
	dat += "<table class='border'>"
	dat += "<tr>"
	dat += "<th>Incident Summary <a href='?src=\ref[src];button=add_notes'>Change</a></th>"
	dat += "</tr>"
	if(incident.notes)
		dat += "<tr>"
		dat += "<td><i>[incident.notes]</i></td>"
		dat += "</tr>"
	dat += "</table>"
	return dat

/obj/structure/machinery/computer/sentencing/proc/add_charges()
	var/dat = ""
	if(!istype(incident))
		dat += "There was an error loading the incident, please <a href='?src=\ref[src];button=change_menu;choice=main_menu'>Try Again</a>"
		return dat

	dat += charges_header()
	dat += "<hr>"
	switch(menu_screen)
		if("low_severity")
			dat += create_crimes_layout("Misdemeanors", SSlaw_init.minor_law)
		if("med_severity")
			dat += create_crimes_layout("Indictable Offences", SSlaw_init.major_law)
		if("high_severity")
			dat += create_crimes_layout("Capital Offences", SSlaw_init.capital_law)
		if("extra_severity")
			dat += create_crimes_layout("Addable Offences", SSlaw_init.optional_law)

	dat += "<br><hr>"
	dat += "<center><a href='?src=\ref[src];button=change_menu;choice=incident_report'>Return</a></center>"
	return dat

/obj/structure/machinery/computer/sentencing/proc/charges_header()
	var/dat = ""
	dat += "<center>"
	if(menu_screen == "low_severity")
		dat += "Minor Crimes"
	else
		dat += "<a href='?src=\ref[src];button=change_menu;choice=low_severity'>Minor Crimes</a>"
	dat += " - "

	if(menu_screen == "med_severity")
		dat += "Major Crimes"
	else
		dat += "<a href='?src=\ref[src];button=change_menu;choice=med_severity'>Major Crimes</a>"
	dat += " - "

	if(menu_screen == "high_severity")
		dat += "Capital Crimes"
	else
		dat += "<a href='?src=\ref[src];button=change_menu;choice=high_severity'>Capital Crimes</a>"
	dat += " - "

	if(menu_screen == "extra_severity")
		dat += "Additional Crimes"
	else
		dat += "<a href='?src=\ref[src];button=change_menu;choice=extra_severity'>Additional Crimes</a>"

	dat += "</center>"
	return dat

/obj/structure/machinery/computer/sentencing/proc/create_crimes_layout(var/title, var/list/laws)
	var/dat = ""
	dat += "<table class='border'>"
	dat += "<tr>"
	dat += "<th colspan='5'>[title]</th>"
	dat += "</tr>"

	dat += "<tr>"
	dat += "<th>Name</th>"
	dat += "<th>Description</th>"
	dat += "<th>Brig Sentence</th>"
	dat += "<th>Button</th>"
	dat += "</tr>"

	for(var/datum/law/L in laws)
		dat += "<tr>"
		dat += "<td><b>[L.name]</b></td>"
		dat += "<td><i>[L.desc]</i></td>"
		dat += "<td>[L.brig_time] minutes</td>"
		dat += "<td><a href='?src=\ref[src];button=add_charge;law=\ref[L]'>Charge</a></td>"
		dat += "</tr>"

		dat += "<tr>"
		dat += "</tr>"

	dat += "</table>"
	return dat

/obj/structure/machinery/computer/sentencing/proc/print_incident_report(var/sentence = TRUE)
	if(!incident || !incident.criminal_name || !incident.brig_sentence)
		return "Report is lacking information."

	var/obj/item/paper/incident/I = new /obj/item/paper/incident(loc)
	I.incident = incident
	I.sentence = sentence
	I.name = "Encoded Incident Report [paper_counter++] ([incident.criminal_name])"
	playsound(loc, 'sound/machines/twobeep.ogg', 15, 1)

/obj/structure/machinery/computer/sentencing/Topic(href, href_list)
	if(..())
		return

	if(stat & (NOPOWER|BROKEN))
		return FALSE

	usr.set_interaction(src)

	switch(href_list["button"])
		if("import_incident")
			menu_screen = "import_incident"
		if("new_incident")
			incident = new()
			menu_screen = "incident_report"
		if("change_menu")
			menu_screen = href_list["choice"]
		if("change_criminal")
			var/obj/item/card/id/C = usr.get_active_hand()
			if(istype(C))
				if(incident && C.registered_name)
					incident.criminal_name = C.registered_name
					ping("\The [src] pings, \"Criminal [C.registered_name] verified.\"")
			else if(incident.criminal_name)
				ping("\The [src] pings, \"Criminal cleared.\"")
				incident.criminal_name = null
		if("print_encoded_form")
			var/error = print_incident_report(0)

			if(error)
				to_chat(usr, SPAN_ALERT(error))
			else
				incident = null
				menu_screen = "main_menu"
		if("add_witness")
			var/obj/item/card/id/C = usr.get_active_hand()
			if(istype(C))
				if(incident && C.registered_name)
					incident.witnesses += list(C.registered_name)
					ping("\The [src] pings, \"Witness [C.registered_name] verified.\"")
			else if(incident.witnesses)
				ping("\The [src] pings, \"Witness cleared.\"")
				incident.witnesses = null
		if("add_evidence")
			var/obj/O = usr.get_active_hand()

			if(istype(O))
				var/list/L = incident.evidence
				L += O
				incident.evidence = L
		if("add_charge")
			var/datum/law/L = locate(href_list["law"])
			if(alert(usr, "Are you sure you want to add [L.name]?", "Confirmation", "Yes", "No") == "No")
				return

			incident.charges += L
			incident.refresh_sentences()
			menu_screen = "incident_report"
		if("remove_charge")
			incident.charges -= locate(href_list["law"])
			incident.refresh_sentences()
		if("remove_witness")
			var/list/L = incident.witnesses
			L -= locate(href_list["choice"])
			incident.witnesses = L
		if("remove_evidence")
			var/list/L = incident.evidence
			L -= locate(href_list["choice"])
			incident.evidence = L
		if("add_witness_notes")
			var/list/L = incident.witnesses
			var/W = locate(href_list["choice"])

			var/notes = strip_html((input(usr, "Summarize what the witness said:","Witness Report", html_decode(L[W])) as message), MAX_PAPER_MESSAGE_LEN)
			if(notes != null)
				L[W] = notes

			incident.witnesses = L
		if("add_evidence_notes")
			var/list/L = incident.evidence
			var/E = locate(href_list["choice"])

			var/notes = strip_html((input(usr, "Describe the relevance of this evidence:","Evidence Report", html_decode(L[E])) as message), MAX_PAPER_MESSAGE_LEN)
			if(notes != null)
				L[E] = notes

			incident.evidence = L
		if("add_notes")
			if(!incident)
				return

			var/incident_notes = strip_html(input(usr, "Describe the incident here:","Incident Report", html_decode(incident.notes)) as message, 1, MAX_PAPER_MESSAGE_LEN)
			if(incident_notes != null && incident)
				incident.notes = incident_notes

	updateUsrDialog()
