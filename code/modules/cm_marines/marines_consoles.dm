//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/machinery/computer/marine_card
	name = "Identification Computer"
	desc = "You can use this to change ID's."
	icon_state = "id"
	req_access = list(ACCESS_MARINE_LOGISTICS)
	circuit = "/obj/item/circuitboard/computer/card"
	var/obj/item/card/id/scan = null
	var/obj/item/card/id/ID_to_modify = null
	var/authenticated = 0.0
	var/mode = 0.0
	var/printing = null


/obj/structure/machinery/computer/marine_card/attackby(O as obj, user as mob)//TODO:SANITY
	if(istype(O, /obj/item/card/id))
		var/obj/item/card/id/idcard = O
		if(ACCESS_MARINE_LOGISTICS in idcard.access)
			if(!scan)
				usr.drop_held_item()
				idcard.loc = src
				scan = idcard
			else if(!ID_to_modify)
				usr.drop_held_item()
				idcard.loc = src
				ID_to_modify = idcard
			else
				to_chat(user, "Both slots are full already. Remove a card first.")
		else
			if(!ID_to_modify)
				usr.drop_held_item()
				idcard.loc = src
				ID_to_modify = idcard
			else
				to_chat(user, "Both slots are full already. Remove a card first.")
	else
		..()


/obj/structure/machinery/computer/marine_card/attack_ai(var/mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/marine_card/bullet_act()
	return 0

/obj/structure/machinery/computer/marine_card/attack_hand(var/mob/user as mob)
	if(..())
		return

	user.set_interaction(src)
	var/dat
	var/title
	if (!( ticker ))
		return
	if (mode) // accessing crew manifest

		title = "Crew Manifest"
		dat += "Entries cannot be modified from this terminal.<br><br>"
		if(data_core)
			dat += data_core.get_manifest(0) // make it monochrome
		dat += "<br>"
		dat += "<a href='?src=\ref[src];choice=print'>Print</a><br>"
		dat += "<br>"
		dat += "<a href='?src=\ref[src];choice=mode;mode_target=0'>Access ID modification console.</a><br>"

		/*var/crew = ""
		var/list/L = list()
		for (var/datum/data/record/t in data_core.general)
			var/R = t.fields["name"] + " - " + t.fields["rank"]
			L += R
		for(var/R in sortList(L))
			crew += "[R]<br>"*/
		//dat = "<tt><b>Crew Manifest:</b><br>Please use security record computer to modify entries.<br><br>[crew]<a href='?src=\ref[src];choice=print'>Print</a><br><br><a href='?src=\ref[src];choice=mode;mode_target=0'>Access ID modification console.</a><br></tt>"
	else
		title = "Identification Card Modifier"
		var/header

		var/target_name
		var/target_owner
		var/target_rank
		if(ID_to_modify)
			target_name = ID_to_modify.name
		else
			target_name = "--------"
		if(ID_to_modify && ID_to_modify.registered_name)
			target_owner = ID_to_modify.registered_name
		else
			target_owner = "--------"
		if(ID_to_modify && ID_to_modify.assignment)
			target_rank = ID_to_modify.assignment
		else
			target_rank = "Unassigned"

		var/scan_name
		if(scan)
			scan_name = scan.name
		else
			scan_name = "--------"

		if(!authenticated)
			header += "<i>Please insert the cards into the slots</i><br>"
			header += "Target: <a href='?src=\ref[src];choice=modify'>[target_name]</a><br>"
			header += "Confirm Identity: <a href='?src=\ref[src];choice=scan'>[scan_name]</a><br>"
		else
			header += "<div align='center'>"
			header += "<a href='?src=\ref[src];choice=modify'>Remove [target_name]</a> || "
			header += "<a href='?src=\ref[src];choice=scan'>Remove [scan_name]</a> <br> "
			header += "<a href='?src=\ref[src];choice=mode;mode_target=1'>Access Crew Manifest</a> || "
			header += "<a href='?src=\ref[src];choice=logout'>Log Out</a></div>"

		header += "<hr>"

		var/jobs_all = ""
		var/list/alljobs = (get_marine_jobs()) + "Custom"
		for(var/job in alljobs)
			jobs_all += "<a href='?src=\ref[src];choice=assign;assign_target=[job]'>[replacetext(job, " ", "&nbsp")]</a> " //make sure there isn't a line break in the middle of a job


		var/body
		if (authenticated && ID_to_modify)
			var/carddesc = {"<script type="text/javascript">
								function markRed(){
									var nameField = document.getElementById('namefield');
									nameField.style.backgroundColor = "#FFDDDD";
								}
								function markGreen(){
									var nameField = document.getElementById('namefield');
									nameField.style.backgroundColor = "#DDFFDD";
								}
								function markAccountGreen(){
									var nameField = document.getElementById('accountfield');
									nameField.style.backgroundColor = "#DDFFDD";
								}
								function markAccountRed(){
									var nameField = document.getElementById('accountfield');
									nameField.style.backgroundColor = "#FFDDDD";
								}
								function showAll(){
									var allJobsSlot = document.getElementById('alljobsslot');
									allJobsSlot.innerHTML = "<a href='#' onclick='hideAll()'>hide</a><br>"+ "[jobs_all]";
								}
								function hideAll(){
									var allJobsSlot = document.getElementById('alljobsslot');
									allJobsSlot.innerHTML = "<a href='#' onclick='showAll()'>show</a>";
								}
							</script>"}
			carddesc += "<form name='cardcomp' action='?src=\ref[src]' method='get'>"
			carddesc += "<input type='hidden' name='src' value='\ref[src]'>"
			carddesc += "<input type='hidden' name='choice' value='reg'>"
			carddesc += "<b>Registered Name:</b> <input type='text' id='namefield' name='reg' value='[target_owner]' style='width:250px; background-color:white;' onchange='markRed()'>"
			carddesc += "<input type='submit' value='Rename' onclick='markGreen()'>"
			carddesc += "</form>"

			carddesc += "<form name='accountnum' action='?src=\ref[src]' method='get'>"
			carddesc += "<input type='hidden' name='src' value='\ref[src]'>"
			carddesc += "<input type='hidden' name='choice' value='account'>"
			carddesc += "<b>Stored account number:</b> <input type='text' id='accountfield' name='account' value='[ID_to_modify.associated_account_number]' style='width:250px; background-color:white;' onchange='markAccountRed()'>"
			carddesc += "<input type='submit' value='Rename' onclick='markAccountGreen()'>"
			carddesc += "</form>"

			carddesc += "<b>Assignment:</b> "
			var/jobs = "<span id='alljobsslot'><a href='#' onclick='showAll()'>[target_rank]</a></span><br>" //CHECK THIS
			var/paygrade = ""
			if(!(ID_to_modify.paygrade in PAYGRADES_MARINE))
				paygrade += "<b>Paygrade:<b> [get_paygrades(ID_to_modify.paygrade)] -- UNABLE TO MODIFY"
			else
				paygrade += "<form name='paygrade' action='?src=\ref[src]' method='get'>"
				paygrade += "<input type='hidden' name='src' value='\ref[src]'>"
				paygrade += "<input type='hidden' name='choice' value='paygrade'>"
				paygrade += "<b>Paygrade:</b> <select name='paygrade'>"
				var/i
				for(i in PAYGRADES_ENLISTED)
					if(i == ID_to_modify.paygrade) paygrade += "<option value='[i]' selected=selected>[get_paygrades(i)]</option>"
					else paygrade += "<option value='[i]'>[get_paygrades(i)]</option>"
				if(copytext(scan.paygrade,1,2) == "O")
					var/r = text2num(copytext(scan.paygrade,2))
					r = r > 4 ? 4 : r
					while(--r > 0)
						i = "O[r]"
						if(i == ID_to_modify.paygrade) paygrade += "<option value='[i]' selected=selected>[get_paygrades(i)]</option>"
						else paygrade += "<option value='[i]'>[get_paygrades(i)]</option>"
				paygrade += "</select>"
				paygrade += "<input type='submit' value='Modify'>"
				paygrade += "</form>"
			var/accesses = "<div align='center'><b>Access</b></div>"
			accesses += "<table style='width:100%'>"
			accesses += "<tr>"
			for(var/i = 1; i <= 6; i++)
				accesses += "<td style='width:14%'><b>[get_region_accesses_name(i)]:</b></td>"
			accesses += "</tr><tr>"
			for(var/i = 1; i <= 6; i++)
				accesses += "<td style='width:14%' valign='top'>"
				for(var/A in get_region_accesses(i))
					if(A in ID_to_modify.access)
						accesses += "<a href='?src=\ref[src];choice=access;access_target=[A];allowed=0'><font color=\"red\">[replacetext(get_access_desc(A), " ", "&nbsp")]</font></a> "
					else
						accesses += "<a href='?src=\ref[src];choice=access;access_target=[A];allowed=1'>[replacetext(get_access_desc(A), " ", "&nbsp")]</a> "
					accesses += "<br>"
				accesses += "</td>"
			accesses += "</tr></table>"
			body = "[carddesc]<br>[jobs]<br>[paygrade]<br><br>[accesses]" //CHECK THIS
		else
			body = "<a href='?src=\ref[src];choice=auth'>{Log in}</a> <br><hr>"
			body += "<a href='?src=\ref[src];choice=mode;mode_target=1'>Access Crew Manifest</a>"
		dat = "<tt>[header][body]<hr><br></tt>"
	show_browser(user, dat, title, "id_com", "size=625x500")
	return

/obj/structure/machinery/computer/marine_card/Topic(href, href_list)
	if(..())
		return
	usr.set_interaction(src)
	switch(href_list["choice"])
		if ("modify")
			if (ID_to_modify)
				data_core.manifest_modify(ID_to_modify.registered_name, ID_to_modify.assignment)
				ID_to_modify.name = text("[ID_to_modify.registered_name]'s ID Card ([ID_to_modify.assignment])")
				if(ishuman(usr))
					ID_to_modify.loc = usr.loc
					if(!usr.get_active_hand())
						usr.put_in_hands(ID_to_modify)
					ID_to_modify = null
				else
					ID_to_modify.loc = loc
					ID_to_modify = null
			else
				var/obj/item/I = usr.get_active_hand()
				if (istype(I, /obj/item/card/id))
					usr.drop_held_item()
					I.loc = src
					ID_to_modify = I
			authenticated = 0
		if ("scan")
			if (scan)
				if(ishuman(usr))
					scan.loc = usr.loc
					if(!usr.get_active_hand())
						usr.put_in_hands(scan)
					scan = null
				else
					scan.loc = src.loc
					scan = null
			else
				var/obj/item/I = usr.get_active_hand()
				if (istype(I, /obj/item/card/id))
					usr.drop_held_item()
					I.loc = src
					scan = I
			authenticated = 0
		if ("auth")
			if ((!( authenticated ) && (scan || (ishighersilicon(usr))) && (ID_to_modify || mode)))
				if (check_access(scan))
					authenticated = 1
			else if ((!( authenticated ) && (ishighersilicon(usr))) && (!ID_to_modify))
				to_chat(usr, "You can't modify an ID without an ID inserted to modify. Once one is in the modify slot on the computer, you can log in.")
		if ("logout")
			authenticated = 0
		if("access")
			if(href_list["allowed"])
				if(authenticated)
					var/access_type = text2num(href_list["access_target"])
					var/access_allowed = text2num(href_list["allowed"])
					if(access_type in get_all_marine_access())
						ID_to_modify.access -= access_type
						if(access_allowed == 1)
							ID_to_modify.access += access_type
		if ("assign")
			if (authenticated)
				var/t1 = href_list["assign_target"]
				if(t1 == "Custom")
					var/temp_t = strip_html(input("Enter a custom job assignment.","Assignment"))
					//let custom jobs function as an impromptu alt title, mainly for sechuds
					if(temp_t && ID_to_modify)
						ID_to_modify.assignment = temp_t
				else
					var/datum/job/jobdatum
					for(var/jobtype in typesof(/datum/job))
						var/datum/job/J = new jobtype
						if(ckey(J.title) == ckey(t1))
							jobdatum = J
							break

					if(!jobdatum)
						to_chat(usr, SPAN_DANGER("No log exists for this job."))
						return

					if(!ID_to_modify)
						to_chat(usr, SPAN_DANGER("No card to modify!"))
						return

					ID_to_modify.access = jobdatum.get_access()
					ID_to_modify.paygrade = jobdatum.get_paygrade()
					ID_to_modify.assignment = t1
					ID_to_modify.rank = t1
		if ("reg")
			if (authenticated)
				var/t2 = ID_to_modify
				//var/t1 = input(usr, "What name?", "ID computer", null)  as text
				if ((authenticated && ID_to_modify == t2 && (in_range(src, usr) || (ishighersilicon(usr))) && istype(loc, /turf)))
					var/temp_name = reject_bad_name(href_list["reg"])
					if(temp_name)
						ID_to_modify.registered_name = temp_name
					else
						src.visible_message(SPAN_NOTICE("[src] buzzes rudely."))
		if ("account")
			if (authenticated)
				var/t2 = ID_to_modify
				//var/t1 = input(usr, "What name?", "ID computer", null)  as text
				if ((authenticated && ID_to_modify == t2 && (in_range(src, usr) || (ishighersilicon(usr))) && istype(loc, /turf)))
					var/account_num = text2num(href_list["account"])
					ID_to_modify.associated_account_number = account_num
		if ("paygrade")
			if(authenticated)
				var/t2 = ID_to_modify
				if ((authenticated && ID_to_modify == t2 && (in_range(src, usr) || (ishighersilicon(usr))) && istype(loc, /turf)))
					ID_to_modify.paygrade = href_list["paygrade"]
		if ("mode")
			mode = text2num(href_list["mode_target"])
		if ("print")
			if (!( printing ))
				printing = 1
				sleep(50)
				var/obj/item/paper/P = new /obj/item/paper( loc )

				var/t1 = "<h4>Crew Manifest</h4>"
				t1 += "<br>"
				if(data_core)
					t1 += data_core.get_manifest(0) // make it monochrome

				P.info = t1
				P.name = "paper- 'Crew Manifest'"
				printing = null
	if (ID_to_modify)
		ID_to_modify.name = text("[ID_to_modify.registered_name]'s ID Card ([ID_to_modify.assignment])")
	updateUsrDialog()
	return


//This console changes a marine's squad. It's very simple.
//It also does not: change or increment the squad count (used in the login randomizer), nor does it check for jobs.
//Which means you could get sillyiness like "Alpha Sulaco Chief Medical Officer" or "Delta Logistics Officer".
//But in the long run it's not really a big deal.

/obj/structure/machinery/computer/squad_changer
	name = "Squad Distribution Computer"
	desc = "You can use this to change someone's squad."
	icon_state = "guest"
	req_access = list(ACCESS_MARINE_LOGISTICS)
	var/obj/item/card/id/ID_to_modify = null
	var/mob/living/carbon/human/person_to_modify = null
	var/screen = 0 //0: main, 1: squad menu

/obj/structure/machinery/computer/squad_changer/attackby(obj/O as obj, mob/user as mob)
	if(user)
		add_fingerprint(user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(istype(O, /obj/item/card/id))
			var/obj/item/card/id/idcard = O
			if(!ID_to_modify)
				H.drop_held_item()
				idcard.loc = src
				ID_to_modify = idcard
				to_chat(usr, SPAN_NOTICE("You insert the ID card into [src]"))
			else
				to_chat(H, SPAN_NOTICE("Remove the inserted card first."))
		else if(istype(O, /obj/item/grab))
			var/obj/item/grab/G = O
			if(ismob(G.grabbed_thing))
				person_to_modify = G.grabbed_thing
				H.visible_message(SPAN_NOTICE("You hear a beep as [person_to_modify]'s hand is scanned to \the [name]."))
				playsound(H.loc, 'sound/machines/screen_output1.ogg', 25, 1)
	else
		..()


/obj/structure/machinery/computer/squad_changer/attack_ai(var/mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/squad_changer/bullet_act()
	return 0

/obj/structure/machinery/computer/squad_changer/attack_hand(var/mob/user as mob)
	if(..())
		return
	if(user) 
		add_fingerprint(user)

	usr.set_interaction(src)

	var/dat

	var/target_name

	if(ID_to_modify)
		target_name = ID_to_modify.name
	else
		target_name = "--------"

	dat += "<CENTER>"

	if(!ID_to_modify)
		dat += "<br><i>Please insert the card into the slot:</i><br>"
		dat += "Target: <a href='?src=\ref[src];card=1'>[target_name]</a><br>"
	else
		dat += "<br>"
		dat += "<a href='?src=\ref[src];card=1'>Remove [target_name]</a>"

	dat += "<hr>"

	dat += "<BR><A href='?src=\ref[src];squad=1'>Modify Squad</A><BR>"

	show_browser(user, dat, "Squad Distribution Console", "computer", "size=400x300")


/obj/structure/machinery/computer/squad_changer/Topic(href, href_list)
	if(..())
		return

	if (get_dist(src, usr) <= 1 && istype(src.loc, /turf))
		usr.set_interaction(src)
		if(href_list["card"])
			if(ID_to_modify)
				ID_to_modify.loc = src.loc
				if(!usr.get_active_hand() && istype(usr,/mob/living/carbon/human))
					usr.put_in_hands(ID_to_modify)
				ID_to_modify = null
				to_chat(usr, SPAN_NOTICE("You remove the ID card from \the [src]"))
			else
				var/obj/item/I = usr.get_active_hand()
				if (istype(I, /obj/item/card/id))
					usr.drop_held_item()
					I.loc = src
					ID_to_modify = I
					to_chat(usr, SPAN_NOTICE("You insert the ID card into \the [src]"))
		else if(href_list["squad"])
			if(allowed(usr))
				// Second check is to make sure civilians aren't assigned into squads
				if(
					istype(ID_to_modify) && istype(person_to_modify) && \
					person_to_modify.skills.get_skill_level(SKILL_FIREARMS) && \
					person_to_modify.real_name == ID_to_modify.registered_name && \
					person_to_modify.Adjacent(src)
				)
					var/list/squad_list = list()
					for(var/datum/squad/S in RoleAuthority.squads)
						if(S.usable)
							squad_list += S.name

					var/name_sel = input("Which squad would you like to put the person in?") as null|anything in squad_list
					if(!name_sel)
						return

					var/datum/squad/selected = get_squad_by_name(name_sel)
					if(!selected)
						return

					//First, remove any existing squad access and clear the card.
					for(var/datum/squad/Q in RoleAuthority.squads)
						if(findtext(ID_to_modify.assignment, Q.name)) //Found one!
							ID_to_modify.access -= Q.access //Remove any access found.
							person_to_modify.assigned_squad = null
					if(selected.put_marine_in_squad(person_to_modify, ID_to_modify))
						to_chat(usr, SPAN_NOTICE("[person_to_modify] was assigned to [selected] Squad."))
					else
						to_chat(usr, SPAN_WARNING("There was an error assigning [person_to_modify] to [selected] Squad."))
				else if(!istype(ID_to_modify))
					to_chat(usr, SPAN_WARNING("You need to insert a card to modify."))
				else if(!istype(person_to_modify) || !person_to_modify.Adjacent(src))
					to_chat(usr, SPAN_WARNING("You need to keep the hand of the person to be assigned to \the [src] Squad."))
				else if(!person_to_modify.skills.get_skill_level(SKILL_FIREARMS))
					to_chat(usr, SPAN_WARNING("You cannot assign untrained civilians to squads."))
				else
					to_chat(usr, SPAN_WARNING("The ID in the machine is not owned by the person whose hand is scanned."))
			else
				to_chat(usr, SPAN_WARNING("You don't have sufficient access to use this console."))
		updateUsrDialog()
		src.add_fingerprint(usr)
	return


/obj/structure/machinery/computer/crew
	name = "Crew monitoring computer"
	desc = "Used to monitor active health sensors built into marine jumpsuits."
	icon_state = "crew"
	use_power = 1
	idle_power_usage = 250
	active_power_usage = 500
//	circuit = "/obj/item/circuitboard/computer/crew"
	var/list/tracked = list(  )


/obj/structure/machinery/computer/crew/New()
	tracked = list()
	..()

/obj/structure/machinery/computer/crew/attack_ai(mob/living/user)
	attack_hand(user)
	ui_interact(user)


/obj/structure/machinery/computer/crew/attack_hand(mob/living/user)
	add_fingerprint(user)
	if(inoperable())
		return
	ui_interact(user)


/obj/structure/machinery/computer/crew/update_icon()

	if(stat & BROKEN)
		icon_state = "crewb"
	else
		if(stat & NOPOWER)
			icon_state = "crew0"
			stat |= NOPOWER
		else
			icon_state = initial(icon_state)
			stat &= ~NOPOWER


/obj/structure/machinery/computer/crew/Topic(href, href_list)
	if(..()) return
	if( href_list["close"] )
		var/mob/user = usr
		var/datum/nanoui/ui = nanomanager.get_open_ui(user, src, "main")
		user.unset_interaction()
		ui.close()
		return 0
	if(href_list["update"])
		updateDialog()
		return 1

/obj/structure/machinery/computer/crew/interact(mob/living/user)
	ui_interact(user)

/obj/structure/machinery/computer/crew/ui_interact(mob/living/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(inoperable())
		return
	user.set_interaction(src)
	scan()

	var/data[0]
	var/list/crewmembers = list()

	for(var/obj/item/clothing/under/C in tracked)

		var/turf/pos = get_turf(C)

		if(C && pos)
			if(istype(C.loc, /mob/living/carbon/human))

				var/mob/living/carbon/human/H = C.loc
				if(H && H.faction == FACTION_SURVIVOR && H.loc.z == 1) 
					continue // survivors
				if(H.w_uniform != C)
					continue

				var/list/crewmemberData = list()

				crewmemberData["sensor_type"] = C.sensor_mode
				crewmemberData["dead"] = H.stat > 1
				crewmemberData["oxy"] = round(H.getOxyLoss(), 1)
				crewmemberData["tox"] = round(H.getToxLoss(), 1)
				crewmemberData["fire"] = round(H.getFireLoss(), 1)
				crewmemberData["brute"] = round(H.getBruteLoss(), 1)

				crewmemberData["name"] = "Unknown"
				crewmemberData["rank"] = "Unknown"
				if(H.wear_id && istype(H.wear_id, /obj/item/card/id) )
					var/obj/item/card/id/I = H.wear_id
					crewmemberData["name"] = I.name
					crewmemberData["rank"] = I.rank

				var/area/A = get_area(H)
				crewmemberData["area"] = sanitize(A.name)
//				crewmemberData["x"] = pos.x
//				crewmemberData["y"] = pos.y

				// Works around list += list2 merging lists; it's not pretty but it works
				crewmembers += "temporary item"
				crewmembers[crewmembers.len] = crewmemberData

	crewmembers = sortByKey(crewmembers, "name")

	data["crewmembers"] = crewmembers

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "crew_monitor.tmpl", "Crew Monitoring Computer", 900, 800)

		// adding a template with the key "mapContent" enables the map ui functionality
//		ui.add_template("mapContent", "crew_monitor_map_content.tmpl")
		// adding a template with the key "mapHeader" replaces the map header content
//		ui.add_template("mapHeader", "crew_monitor_map_header.tmpl")

		ui.set_initial_data(data)
		ui.open()

		// should make the UI auto-update; doesn't seem to?
		ui.set_auto_update(1)


/obj/structure/machinery/computer/crew/proc/scan()
	for(var/mob/living/carbon/human/H in mob_list)
		if(!H || !istype(H)) continue
		if(isYautja(H)) continue
		var/obj/item/clothing/under/C = H.w_uniform
		if(!C || !istype(C)) continue
		if(C.has_sensor && H.mind)
			tracked |= C
	return 1
