
#define SECURITY 1
#define GENERAL 0

/obj/structure/machinery/computer/secure_data//TODO:MIGRATE THIS SHIT TO TGUI.
	name = "Security Records"
	desc = "Used to view and edit personnel's security records"
	icon_state = "security"
	req_access = list(ACCESS_MARINE_BRIG)
	circuit = /obj/item/circuitboard/computer/secure_data

	// if the user currently logged into the system
	var/authenticated = FALSE

	// the mob we select to view security logs from.
	var/mob/living/carbon/human/target_mob

	// fugly list that we pass into tgui to display the data. Why fugly? see the retreieve_general_records proc.
	var/list/general_records = list()

	// ID of the user currently griefing the logs
	var/obj/item/card/id/user_id_card = null

	var/obj/item/device/clue_scanner/scanner = null

	// target's security record
	var/list/target_security_record = list()

/obj/structure/machinery/computer/secure_data/proc/authenticate(mob/user, obj/item/card/id/id_card)
	if(!id_card)
		visible_message("[SPAN_BOLD("[src]")] states, \"AUTH ERROR: Authority confirmation card is missing!\"")
		return FALSE

	if(check_access(id_card))
		authenticated = TRUE
		visible_message("[SPAN_BOLD("[src]")] states, \"AUTH LOGIN: Welcome, [id_card.registered_name]. Access granted.\"")
		update_static_data(user)
		return TRUE

	visible_message("[SPAN_BOLD("[src]")] states, \"AUTH ERROR: You have not enough authority! Access denied.\"")
	return FALSE

/obj/structure/machinery/computer/secure_data/attackby(obj/card, mob/user)
	if(!operable())
		to_chat(user, SPAN_NOTICE("You tried to inject \the [card] but \the [src] remains silent."))
		return

	if(istype(card, /obj/item/card/id))
		if(user_id_card)
			to_chat(user, "Remove the card first.")
			return

		var/obj/item/card/id/idcard = card
		if(!authenticate(user, card) && !is_not_allowed(user))
			return
		user_id_card = idcard
		if(user.drop_held_item())
			idcard.forceMove(src)
		update_static_data(user)
	else
		..()

/obj/structure/machinery/computer/secure_data/verb/eject_id()
	set category = "Object"
	set name = "Eject ID Card"
	set src in oview(1)

	if(!usr || usr.is_mob_incapacitated()) return

	if(user_id_card)
		user_id_card.loc = get_turf(src)
		if(!usr.get_active_hand() && istype(usr,/mob/living/carbon/human))
			usr.put_in_hands(user_id_card)
		if(operable())
			visible_message("[SPAN_BOLD("[src]")] states, \"AUTH LOGOUT: Session end confirmed.\"")
		else
			to_chat(usr, "You remove \the [user_id_card] from \the [src].")
		authenticated = FALSE
		user_id_card = null
	else
		to_chat(usr, "There is nothing to remove from the console.")
	return

// dump the general records, get all of them. Immutable data for now.
/obj/structure/machinery/computer/secure_data/proc/retrieve_general_records()
	var/list/full_general_record
	for(var/record as anything in GLOB.data_core.general)
		var/datum/data/record/new_record = GLOB.data_core.general[record]
		// TODO: PASS IN AN OBJECT INSTEAD
		full_general_record += list(
			list(new_record?.fields[MOB_NAME],"Name: "),
			list(new_record?.fields[MOB_AGE],"Age: "),
			list(new_record?.fields[MOB_SEX],"Sex: "),
			list(new_record?.fields[MOB_BLOOD_TYPE],"Blood Type: "),
		)

	return full_general_record

// to make accessing the records more performant we only retrieve the security logs when a new target is selected in tgui or the record itself is updated.
/obj/structure/machinery/computer/secure_data/proc/retrieve_target_security_record(mob/living/carbon/human/user)
	if(!user)
		return

	var/list/target_record
	var/datum/data/record/target_sec_record = GLOB.data_core.security[user.record_id_ref]
	target_record = list(
		// TODO: PASS IN AN OBJECT INSTEAD
		list(MOB_CRIMINAL_STATUS, target_sec_record?.fields[MOB_CRIMINAL_STATUS],"Criminal Status: "),
		list(MOB_INCIDENTS, target_sec_record?.fields[MOB_INCIDENTS],"Incidents: "),
		list(MOB_SECURITY_COMMENT_LOG, target_sec_record?.fields[MOB_SECURITY_COMMENT_LOG], "Security Entry: "),
		list(MOB_SECURITY_NOTES, target_sec_record?.fields[MOB_SECURITY_NOTES], "Security Notes: ")
	)

	return target_record


/obj/structure/machinery/computer/secure_data/attack_hand(mob/user as mob)
	if(..() || inoperable())
		return

	general_records = retrieve_general_records()
	if(!general_records)
		visible_message("[SPAN_BOLD("[src]")] states, \"DATACORE FAILURE: Unable to retrieve database logs.\"")
		return
	user.set_interaction(src)
	tgui_interact(user)

/obj/structure/machinery/computer/secure_data/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/secure_data/bullet_act()
	return FALSE

// //Someone needs to break down the dat += into chunks instead of long ass lines.
// /obj/structure/machinery/computer/secure_data/attack_hand(mob/user as mob)
// 	if(..() || inoperable())
// 		to_chat(user, SPAN_INFO("It does not appear to be working."))
// 		return

// 	if(!allowed(usr))
// 		to_chat(user, SPAN_WARNING("Access denied."))
// 		return

// 	if(!is_mainship_level(z))
// 		to_chat(user, SPAN_DANGER("<b>Unable to establish a connection</b>: \black You're too far away from the station!"))
// 		return
// 	var/dat

// 	if (temp)
// 		dat = text("<TT>[]</TT><BR><BR><A href='?src=\ref[];choice=Clear Screen'>Clear Screen</A>", temp, src)
// 	else
// 		switch(screen)
// 			if(1.0)
// 				dat += {"
// <p style='text-align:center;'>"}
// 				dat += text("<A href='?src=\ref[];choice=Search Records'>Search Records</A><BR>", src)
// 				if(scanner)
// 					dat += text("<A href='?src=\ref[];choice=read_fingerprint'>Read Fingerprint</A><BR>", src)
// 				dat += {"
// </p>
// <table style="text-align:center;" cellspacing="0" width="100%">
// <tr>
// <th>Records:</th>
// </tr>
// </table>
// <table style="text-align:center;" border="1" cellspacing="0" width="100%">
// <tr>
// <th><A href='?src=\ref[src];choice=Sorting;sort=name'>Name</A></th>
// <th><A href='?src=\ref[src];choice=Sorting;sort=id'>ID</A></th>
// <th><A href='?src=\ref[src];choice=Sorting;sort=rank'>Rank</A></th>
// <th>Criminal Status</th>
// </tr>"}
// 				if(!isnull(GLOB.data_core.general))
// 					for(var/datum/data/record/R in sortRecord(GLOB.data_core.general, sortBy, order))
// 						var/crimstat = ""
// 						for(var/datum/data/record/E in GLOB.data_core.security)
// 							if ((E.fields["name"] == R.fields["name"] && E.fields["id"] == R.fields["id"]))
// 								crimstat = E.fields["criminal"]
// 						var/background
// 						switch(crimstat)
// 							if("*Arrest*")
// 								background = "'background-color:#990c28;'"
// 							if("Incarcerated")
// 								background = "'background-color:#a16832;'"
// 							if("Released")
// 								background = "'background-color:#2981b3;'"
// 							if("Suspect")
// 								background = "'background-color:#686A6C;'"
// 							if("NJP")
// 								background = "'background-color:#faa20a;'"
// 							if("None")
// 								background = "'background-color:#008743;'"
// 							if("")
// 								background = "'background-color:#FFFFFF;'"
// 								crimstat = "No Record."
// 						dat += text("<tr style=[]><td><A href='?src=\ref[];choice=Browse Record;d_rec=\ref[]'>[]</a></td>", background, src, R, R.fields["name"])
// 						dat += text("<td>[]</td>", R.fields["id"])
// 						dat += text("<td>[]</td>", R.fields["rank"])
// 						dat += text("<td>[]</td></tr>", crimstat)
// 					dat += "</table><hr width='75%' />"
// 				dat += text("<A href='?src=\ref[];choice=Record Maintenance'>Record Maintenance</A><br><br>", src)
// 			if(2.0)
// 				dat += "<B>Records Maintenance</B><HR>"
// 				dat += "<BR><A href='?src=\ref[src];choice=Delete All Records'>Delete All Records</A><BR><BR><A href='?src=\ref[src];choice=Return'>Back</A>"
// 			if(3.0)
// 				dat += "<CENTER><B>Security Record</B></CENTER><BR>"
// 				if ((istype(active1, /datum/data/record) && GLOB.data_core.general.Find(active1)))
// 					dat += text("<table><tr><td> \
// 					Name: <A href='?src=\ref[src];choice=Edit Field;field=name'>[active1.fields["name"]]</A><BR> \
// 					ID: [active1.fields["id"]]<BR>\n \
// 					Sex: <A href='?src=\ref[src];choice=Edit Field;field=sex'>[active1.fields["sex"]]</A><BR>\n \
// 					Age: <A href='?src=\ref[src];choice=Edit Field;field=age'>[active1.fields["age"]]</A><BR>\n \
// 					Rank: <A href='?src=\ref[src];choice=Edit Field;field=rank'>[active1.fields["rank"]]</A><BR>\n \
// 					Physical Status: [active1.fields["p_stat"]]<BR>\n \
// 					Mental Status: [active1.fields["m_stat"]]<BR></td> \
// 					<td align = center valign = top>Photo:<br> \
// 					<table><td align = center><img src=front.png height=80 width=80 border=4><BR><A href='?src=\ref[src];choice=Edit Field;field=photo front'>Update front photo</A></td> \
// 					<td align = center><img src=side.png height=80 width=80 border=4><BR><A href='?src=\ref[src];choice=Edit Field;field=photo side'>Update side photo</A></td></table> \
// 					</td></tr></table>")
// 				else
// 					dat += "<B>General Record Lost!</B><BR>"
// 				if ((istype(active2, /datum/data/record) && GLOB.data_core.security.Find(active2)))
// 					dat += text("<BR>\n<CENTER><B>Security Data</B></CENTER><BR>\n \
// 								Criminal Status: <A href='?src=\ref[];choice=Edit Field;field=criminal'>[]</A><BR> \n \
// 								Incidents: [active2.fields["incident"]]<BR>\n \
// 								\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>", \
// 								src, active2.fields["criminal"])
// 					if(islist(active2.fields["comments"]))
// 						var/counter = 1
// 						for(var/com_i in active2.fields["comments"])
// 							var/comment = active2.fields["comments"][com_i]
// 							var/comment_markup = text("<b>[] / [] ([])</b>\n", comment["created_at"], comment["created_by"]["name"], comment["created_by"]["rank"])
// 							if (isnull(comment["deleted_by"]))
// 								comment_markup += text("<a href='?src=\ref[];choice=Delete Entry;del_c=[]'>Delete comment</a>", src, counter)
// 								comment_markup += text("<br />[]", comment["entry"])
// 							else
// 								comment_markup += text("<br /><i>Comment deleted by [] at []</i>", comment["deleted_by"], comment["deleted_at"])
// 							counter++
// 							dat += "[comment_markup]<br /><br />"
// 					else
// 						dat += "No comments<br><br>"
// 					dat += text("<a href='?src=\ref[];choice=Add Entry'>Add comment</a><br /><br />", src)
// 				else
// 					dat += "<B>Security Record Lost!</B><BR>"
// 				dat += text("\n<A href='?src=\ref[];choice=Print Record'>Print Record</A><BR>\n<A href='?src=\ref[];choice=Return'>Back</A><BR>", src, src)
// 			if(4.0)
// 				if(!Perp.len)
// 					dat += text("ERROR.  String could not be located.<br><br><A href='?src=\ref[];choice=Return'>Back</A>", src)
// 				else
// 					dat += {"
// <table style="text-align:center;" cellspacing="0" width="100%">
// <tr> "}
// 					dat += text("<th>Search Results for '[]':</th>", tempname)
// 					dat += {"
// </tr>
// </table>
// <table style="text-align:center;" border="1" cellspacing="0" width="100%">
// <tr>
// <th>Name</th>
// <th>ID</th>
// <th>Rank</th>
// <th>Criminal Status</th>
// </tr> "}
// 					for(var/i=1, i<=Perp.len, i += 2)
// 						var/crimstat = ""
// 						var/datum/data/record/R = Perp[i]
// 						if(istype(Perp[i+1],/datum/data/record/))
// 							var/datum/data/record/E = Perp[i+1]
// 							crimstat = E.fields["criminal"]
// 						var/background
// 						switch(crimstat)
// 							if("*Arrest*")
// 								background = "'background-color:#BB1133;'"
// 							if("Incarcerated")
// 								background = "'background-color:#B6732F;'"
// 							if("Released")
// 								background = "'background-color:#3BB9FF;'"
// 							if("Suspect")
// 								background = "'background-color:#686A6C;'"
// 							if("NJP")
// 								background = "'background-color:#faa20a;'"
// 							if("None")
// 								background = "'background-color:#1AAFFF;'"
// 							if("")
// 								background = ""
// 								crimstat = "No Record."
// 						dat += text("<tr style=[]><td><A href='?src=\ref[];choice=Browse Record;d_rec=\ref[]'>[]</a></td>", background, src, R, R.fields["name"])
// 						dat += text("<td>[]</td>", R.fields["id"])
// 						dat += text("<td>[]</td>", R.fields["rank"])
// 						dat += text("<td>[]</td></tr>", crimstat)
// 					dat += "</table><hr width='75%' />"
// 					dat += text("<br><A href='?src=\ref[];choice=Return'>Return to index.</A>", src)
// 			if(5)
// 				dat += generate_fingerprint_menu()

// 	show_browser(user, dat, "Security Records", "secure_rec", "size=600x400")
// 	return

// /*Revised /N
// I can't be bothered to look more of the actual code outside of switch but that probably needs revising too.
// What a mess.*/
// /obj/structure/machinery/computer/secure_data/Topic(href, href_list)
// 	if(..())
// 		return
// 	if (!( GLOB.data_core.general.Find(active1) ))
// 		active1 = null
// 	if (!( GLOB.data_core.security.Find(active2) ))
// 		active2 = null
// 	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(loc, /turf))) || (isSilicon(usr)))
// 		usr.set_interaction(src)
// 		switch(href_list["choice"])
// // SORTING!
// 			if("Sorting")
// 				// Reverse the order if clicked twice
// 				if(sortBy == href_list["sort"])
// 					if(order == 1)
// 						order = -1
// 					else
// 						order = 1
// 				else
// 				// New sorting order!
// 					sortBy = href_list["sort"]
// 					order = initial(order)
// //BASIC FUNCTIONS
// 			if("Clear Screen")
// 				temp = null

// 			if ("Return")
// 				screen = 1
// 				active1 = null
// 				active2 = null

// 			if("read_fingerprint")
// 				screen = 5

// 			if("print_report")
// 				var/obj/item/paper/fingerprint/P = new /obj/item/paper/fingerprint(src, scanner.print_list)
// 				P.forceMove(loc)
// 				var/refkey = ""
// 				for(var/obj/effect/decal/prints/print in scanner.print_list)
// 					refkey += print.criminal_name
// 				P.name = "fingerprint report ([md5(refkey)])"
// 				playsound(loc, 'sound/machines/twobeep.ogg', 15, 1)

// 			if("return_menu")
// 				screen = 1

// 			if("return_clear")
// 				QDEL_NULL_LIST(scanner.print_list)
// 				scanner.update_icon()
// 				scanner.forceMove(get_turf(src))
// 				scanner = null
// 				screen = 1

// //RECORD FUNCTIONS
// 			if("Search Records")
// 				var/t1 = input("Search String: (Partial Name or ID or Rank)", "Secure. records", null, null)  as text
// 				if ((!t1 || usr.stat || usr.is_mob_restrained() || !in_range(src, usr)))
// 					return
// 				Perp = new/list()
// 				t1 = lowertext(t1)
// 				var/list/components = splittext(t1, " ")
// 				if(components.len > 5)
// 					return //Lets not let them search too greedily.
// 				for(var/datum/data/record/R in GLOB.data_core.general)
// 					var/temptext = R.fields["name"] + " " + R.fields["id"] + " " + R.fields["rank"]
// 					for(var/i = 1, i<=components.len, i++)
// 						if(findtext(temptext,components[i]))
// 							var/prelist = new/list(2)
// 							prelist[1] = R
// 							Perp += prelist
// 				for(var/i = 1, i<=Perp.len, i+=2)
// 					for(var/datum/data/record/E in GLOB.data_core.security)
// 						var/datum/data/record/R = Perp[i]
// 						if ((E.fields["name"] == R.fields["name"] && E.fields["id"] == R.fields["id"]))
// 							Perp[i+1] = E
// 				tempname = t1
// 				screen = 4

// 			if("Record Maintenance")
// 				screen = 2
// 				active1 = null
// 				active2 = null

// 			if ("Browse Record")
// 				var/datum/data/record/R = locate(href_list["d_rec"])
// 				var/S = locate(href_list["d_rec"])
// 				if (!( GLOB.data_core.general.Find(R) ))
// 					temp = "Record Not Found!"
// 				else
// 					for(var/datum/data/record/E in GLOB.data_core.security)
// 						if ((E.fields["name"] == R.fields["name"] || E.fields["id"] == R.fields["id"]))
// 							S = E
// 					active1 = R
// 					active2 = S
// 					screen = 3


// 			if ("Print Record")
// 				if (!( printing ))
// 					printing = 1
// 					var/datum/data/record/record1 = null
// 					var/datum/data/record/record2 = null
// 					if ((istype(active1, /datum/data/record) && GLOB.data_core.general.Find(active1)))
// 						record1 = active1
// 					if ((istype(active2, /datum/data/record) && GLOB.data_core.security.Find(active2)))
// 						record2 = active2
// 					sleep(50)
// 					var/obj/item/paper/P = new /obj/item/paper( loc )
// 					P.info = "<CENTER><B>Security Record</B></CENTER><BR>"
// 					if (record1)
// 						P.info += text("Name: []<br />\nID: []<br />\nSex: []<br />\nAge: []<br />\nRank: []<br />\nPhysical Status: []<br />\nMental Status: []<br />Criminal Status: []<br />", record1.fields["name"], record1.fields["id"], record1.fields["sex"], record1.fields["age"], record1.fields["rank"], record1.fields["p_stat"], record1.fields["m_stat"], record2.fields["criminal"])
// 						P.name = text("Security Record ([])", record1.fields["name"])
// 					else
// 						P.info += "<b>General Record Lost!</b><br />"
// 						P.name = "Security Record"
// 					if (record2)
// 						P.info += text("<BR>\n<CENTER><B>Security Data</B></CENTER><BR>\nIncidents: [record2.fields["incident"]]<BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>")
// 						if(islist(record2.fields["comments"]) || length(record2.fields["comments"]) > 0)
// 							for(var/com_i in record2.fields["comments"])
// 								var/comment = record2.fields["comments"][com_i]
// 								var/comment_markup = text("<b>[] / [] ([])</b><br />", comment["created_at"], comment["created_by"]["name"], comment["created_by"]["rank"])
// 								if (isnull(comment["deleted_by"]))
// 									comment_markup += comment["entry"]
// 								else
// 									comment_markup += text("<i>Comment deleted by [] at []</i>", comment["deleted_by"], comment["deleted_at"])
// 								P.info += "[comment_markup]<br /><br />"
// 						else
// 							P.info += text("<b>No comments</b><br />")
// 					else
// 						P.info += "<B>Security Record Lost!</B><BR>"
// 					P.info += "</TT>"
// 					printing = null
// 					updateUsrDialog()

// 			if ("Add Entry")
// 				if (!(istype(active2, /datum/data/record)))
// 					return
// 				var/a2 = active2
// 				var/t1 = copytext(trim(strip_html(input("Your name and time will be added to this new comment.", "Add a comment", null, null)  as message)),1,MAX_MESSAGE_LEN)
// 				if((!t1 || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isSilicon(usr))) || active2 != a2))
// 					return
// 				var/created_at = text("[]&nbsp;&nbsp;[]&nbsp;&nbsp;[]", time2text(world.realtime, "MMM DD"), time2text(world.time, "[worldtime2text()]:ss"), GLOB.game_year)
// 				var/new_comment = list("entry" = t1, "created_by" = list("name" = "", "rank" = ""), "deleted_by" = null, "deleted_at" = null, "created_at" = created_at)
// 				if(istype(usr,/mob/living/carbon/human))
// 					var/mob/living/carbon/human/U = usr
// 					new_comment["created_by"] = list("name" = U.get_authentification_name(), "rank" = U.get_assignment())
// 				if(!islist(active2.fields["comments"]))
// 					active2.fields["comments"] = list("1" = new_comment)
// 				else
// 					var/new_com_i = length(active2.fields["comments"]) + 1
// 					active2.fields["comments"]["[new_com_i]"] = new_comment
// 				to_chat(usr, text("You have added a new comment to the Security Record of [].", active2.fields["name"]))

// 			if ("Delete Entry")
// 				if(!islist(active2.fields["comments"]))
// 					return
// 				if(active2.fields["comments"][href_list["del_c"]])
// 					var/updated_comments = active2.fields["comments"]
// 					var/deleter = ""
// 					if(istype(usr,/mob/living/carbon/human))
// 						var/mob/living/carbon/human/U = usr
// 						deleter = "[U.get_authentification_name()] ([U.get_assignment()])"
// 					updated_comments[href_list["del_c"]]["deleted_by"] = deleter
// 					updated_comments[href_list["del_c"]]["deleted_at"] = text("[]&nbsp;&nbsp;[]&nbsp;&nbsp;[]", time2text(world.realtime, "MMM DD"), time2text(world.time, "[worldtime2text()]:ss"), GLOB.game_year)
// 					active2.fields["comments"] = updated_comments
// 					to_chat(usr, text("You have deleted a comment from the Security Record of [].", active2.fields["name"]))

// //FIELD FUNCTIONS
// 			if ("Edit Field")
// 				if (is_not_allowed(usr))
// 					return
// 				var/a1 = active1
// 				switch(href_list["field"])
// 					if("name")
// 						if (istype(active1, /datum/data/record))
// 							var/t1 = reject_bad_name(input(usr, "Please input name:", "Secure. records", active1.fields["name"]) as text|null)
// 							if (!t1 || active1 != a1)
// 								return
// 							message_admins("[key_name(usr)] has changed the record name of [active1.fields["name"]] to [t1]")
// 							active1.fields["name"] = t1
// 					if("sex")
// 						if (istype(active1, /datum/data/record))
// 							if (active1.fields["sex"] == "Male")
// 								active1.fields["sex"] = "Female"
// 							else
// 								active1.fields["sex"] = "Male"
// 					if("age")
// 						if (istype(active1, /datum/data/record))
// 							var/t1 = input("Please input age:", "Secure. records", active1.fields["age"], null)  as num
// 							if (!t1 || active1 != a1)
// 								return
// 							active1.fields["age"] = t1
// 					if("criminal")
// 						if (istype(active2, /datum/data/record))
// 							temp = "<h5>Criminal Status:</h5>"
// 							temp += "<ul>"
// 							temp += "<li><a href='?src=\ref[src];choice=Change Criminal Status;criminal2=none'>None</a></li>"
// 							temp += "<li><a href='?src=\ref[src];choice=Change Criminal Status;criminal2=arrest'>*Arrest*</a></li>"
// 							temp += "<li><a href='?src=\ref[src];choice=Change Criminal Status;criminal2=incarcerated'>Incarcerated</a></li>"
// 							temp += "<li><a href='?src=\ref[src];choice=Change Criminal Status;criminal2=released'>Released</a></li>"
// 							temp += "<li><a href='?src=\ref[src];choice=Change Criminal Status;criminal2=suspect'>Suspect</a></li>"
// 							temp += "<li><a href='?src=\ref[src];choice=Change Criminal Status;criminal2=njp'>NJP</a></li>"
// 							temp += "</ul>"
// 					if("rank")
// 						//This was so silly before the change. Now it actually works without beating your head against the keyboard. /N
// 						if (istype(active1, /datum/data/record) && GLOB.uscm_highcom_paygrades.Find(rank))
// 							temp = "<h5>Occupation:</h5>"
// 							temp += "<ul>"
// 							for(var/rank in GLOB.joblist)
// 								temp += "<li><a href='?src=\ref[src];choice=Change Occupation;rank=[rank]'>[rank]</a></li>"
// 							temp += "</ul>"
// 						else
// 							alert(usr, "You do not have the required rank to do this!")
// 					if("species")
// 						if (istype(active1, /datum/data/record))
// 							var/t1 = copytext(trim(strip_html(input("Please enter race:", "General records", active1.fields["species"], null)  as message)),1,MAX_MESSAGE_LEN)
// 							if (!t1 || active1 != a1)
// 								return
// 							active1.fields["species"] = t1


// //TEMPORARY MENU FUNCTIONS
// 			else//To properly clear as per clear screen.
// 				temp=null
// 				switch(href_list["choice"])
// 					if ("Change Rank")
// 						if (active1)
// 							active1.fields["rank"] = href_list["rank"]
// 							if(href_list["rank"] in GLOB.joblist)
// 								active1.fields["real_rank"] = href_list["real_rank"]

// 					if ("Change Criminal Status")
// 						if (active2)
// 							switch(href_list["criminal2"])
// 								if("none")
// 									active2.fields[MOB_CRIMINAL_STATUS] = MOB_STAT_CRIME_NONE
// 								if("arrest")
// 									active2.fields[MOB_CRIMINAL_STATUS] =  MOB_STAT_CRIME_ARREST
// 								if("incarcerated")
// 									active2.fields[MOB_CRIMINAL_STATUS] =  MOB_STAT_CRIME_INCARCERATED
// 									active2.fields[MOB_CRIMINAL_STATUS] =  MOB_STAT_CRIME_RELEASED
// 								if("suspect")
// 									active2.fields[MOB_CRIMINAL_STATUS] = MOB_STAT_CRIME_SUSPECT
// 								if("njp")
// 									active2.fields[MOB_CRIMINAL_STATUS] = MOB_STAT_CRIME_NJP

// 							for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
// 								H.sec_hud_set_security_status()

// 	add_fingerprint(usr)
// 	updateUsrDialog()
// 	return

/obj/structure/machinery/computer/secure_data/proc/generate_fingerprint_menu()
	var/dat = ""

	for(var/obj/effect/decal/prints/prints in scanner.print_list)
		dat += "<table><tr><td>"
		dat += "Name: [prints.criminal_name]<BR>"
		if(prints.criminal_squad)
			dat += "Squad: [prints.criminal_squad]<BR>"
		if(prints.criminal_rank)
			dat += "Rank: [prints.criminal_rank]<BR>"
		dat += "Description: [prints.description]<BR><hr><BR>"
		dat += "</td></tr></table>"

	dat += "<a href='?src=\ref[src];choice=print_report'>Print Evidence</a><BR>"
	dat += "<a href='?src=\ref[src];choice=return_menu'>Return</a><BR>"
	dat += "<a href='?src=\ref[src];choice=return_clear'>Clear Print and Return</a>"

	return dat

/obj/structure/machinery/computer/secure_data/proc/is_not_allowed(mob/user)
	return user.stat || user.is_mob_restrained() || (!in_range(src, user) && (!isSilicon(user)))

/obj/structure/machinery/computer/secure_data/proc/get_photo(mob/user)
	if(istype(user.get_active_hand(), /obj/item/photo))
		var/obj/item/photo/photo = user.get_active_hand()
		return photo.img

/obj/structure/machinery/computer/secure_data/emp_act(severity)
	. = ..()
	if(inoperable())
		return

	for(var/datum/data/record/R in GLOB.data_core.security)
		if(prob(10/severity))
			switch(rand(1,6))
				if(1)
					R.fields[MOB_NAME] = "[pick(pick(GLOB.first_names_male), pick(GLOB.first_names_female))] [pick(GLOB.last_names)]"
				if(2)
					R.fields[MOB_SEX] = pick(MOB_STAT_SEX_MALE, MOB_STAT_SEX_FEMALE)
				if(3)
					R.fields[MOB_AGE] = rand(5, 85)
				if(4)
					R.fields[MOB_CRIMINAL_STATUS] = pick(MOB_STAT_CRIME_NONE, MOB_STAT_CRIME_ARREST, MOB_STAT_CRIME_INCARCERATED)
				if(5)
					R.fields[MOB_HEALTH_STATUS] = pick(MOB_STAT_HEALTH_DECEASED, MOB_STAT_HEALTH_ACTIVE, MOB_STAT_HEALTH_UNFIT)
				if(6)
					R.fields[MOB_MENTAL_STATUS] = pick(MOB_STAT_MENTAL_STATUS_UNSTABLE, MOB_STAT_MENTAL_STATUS_ON_WATCH, MOB_STAT_MENTAL_STATUS_STABLE)
			continue

/obj/structure/machinery/computer/secure_data/detective_computer
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "messyfiles"

// TGUI SEC
// ------------------------------------------------------------------------------------------------------ //
/obj/structure/machinery/computer/secure_data/tgui_interact(mob/user, datum/tgui/ui)

	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "SecMod", name)
		ui.open()

/obj/structure/machinery/computer/secure_data/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	playsound(src, pick('sound/machines/computer_typing4.ogg', 'sound/machines/computer_typing5.ogg', 'sound/machines/computer_typing6.ogg'), 5, 1)
	switch(action)
		if("authenticate")
			var/obj/item/id_card = user.get_active_hand()
			if (istype(id_card, /obj/item/card/id))
				if(user.drop_held_item())
					id_card.forceMove(src)
					user_id_card = id_card
			if(authenticate(user, user_id_card))
				return TRUE
			else
				if(!user_id_card)
					return
				if(ishuman(user))
					user_id_card.forceMove(user.loc)
					if(!user.get_active_hand())
						user.put_in_hands(user_id_card)
				else
					user_id_card.forceMove(loc)
				user_id_card = null
		if("logout")
			visible_message("[SPAN_BOLD("[src]")] states, \"AUTH LOGOUT: Session end confirmed.\"")
			authenticated = FALSE
			if(ishuman(user))
				user_id_card.forceMove(user.loc)
				if(!user.get_active_hand())
					user.put_in_hands(user_id_card)
			else
				user_id_card.forceMove(loc)
			user_id_card = null
			return TRUE
		if("selectTarget")
			var/name = params["new_user"]
			if(name == target_mob.name)
				return
			for(var/mob/living/carbon/human/selected_human in GLOB.human_mob_list)
				if(selected_human.name == name)
					target_mob = selected_human
			target_security_record = retrieve_target_security_record(target_mob)
			return TRUE
		if("updateStatRecord")
			GLOB.data_core.security[target_mob.record_id_ref].fields[params["stat"]] = params["new_value"]
			return TRUE

/obj/structure/machinery/computer/secure_data/ui_static_data(mob/user)
	var/list/data = list()
	data["general_record"] = general_records
	return data

/obj/structure/machinery/computer/secure_data/ui_data(mob/user)
	var/list/data = list()

	data["selecteded_target_name"] = target_mob ?  target_mob.name : "None"// is there a selected target.
	data["security_record"] = target_security_record
	data["has_id"] = !!user_id_card
	data["id_name"] = user_id_card ? user_id_card?.name : "-----"
	data["authenticated"] = authenticated

	return data
