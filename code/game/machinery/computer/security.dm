//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/machinery/computer/secure_data//TODO:SANITY
	name = "Security Records"
	desc = "Used to view and edit personnel's security records"
	icon_state = "security"
	req_access = list(ACCESS_MARINE_BRIG)
	circuit = /obj/item/circuitboard/computer/secure_data
	var/obj/item/card/id/scan = null
	var/obj/item/device/clue_scanner/scanner = null
	var/rank = null
	var/screen = 1
	var/datum/data/record/selected_general = null
	var/datum/data/record/selected_security = null
	var/a_id = null
	var/temp = null
	var/printing = null
	var/can_change_id = 0
	var/list/Perp
	var/tempname = null
	//Sorting Variables
	var/sortBy = "name"
	var/order = 1 // -1 = Descending - 1 = Ascending

/obj/structure/machinery/computer/secure_data/attackby(obj/item/O as obj, user as mob)

	if(istype(O, /obj/item/device/clue_scanner) && !scanner)
		var/obj/item/device/clue_scanner/S = O
		if(!S.print_list)
			to_chat(user, SPAN_WARNING("There are no prints stored in \the [S]!"))
			return

		if(usr.drop_held_item())
			O.forceMove(src)
			scanner = O
			to_chat(user, "You insert [O].")

	. = ..()

/obj/structure/machinery/computer/secure_data/attack_remote(mob/user as mob)
	return attack_hand(user)

//Someone needs to break down the dat += into chunks instead of long ass lines.
/obj/structure/machinery/computer/secure_data/attack_hand(mob/user as mob)
	if(..() || inoperable())
		to_chat(user, SPAN_INFO("It does not appear to be working."))
		return

	if(!allowed(usr))
		to_chat(user, SPAN_WARNING("Access denied."))
		return

	if(!is_mainship_level(z))
		to_chat(user, SPAN_DANGER("<b>Unable to establish a connection</b>: \black You're too far away from the station!"))
		return
	var/dat

	if (temp)
		dat = text("<TT>[]</TT><BR><BR><A href='byond://?src=\ref[];choice=Clear Screen'>Clear Screen</A>", temp, src)
	else
		switch(screen)
			if(1.0)
				dat += {"
<p style='text-align:center;'>"}
				dat += text("<A href='byond://?src=\ref[];choice=Search Records'>Search Records</A><BR>", src)
				dat += text("<A href='byond://?src=\ref[];choice=New Record (General)'>New Record</A><BR>", src)
				if(scanner)
					dat += text("<A href='byond://?src=\ref[];choice=read_fingerprint'>Read Fingerprint</A><BR>", src)
				dat += {"
</p>
<table style="text-align:center;" cellspacing="0" width="100%">
<tr>
<th>Records:</th>
</tr>
</table>
<table style="text-align:center;" border="1" cellspacing="0" width="100%">
<tr>
<th><A href='byond://?src=\ref[src];choice=Sorting;sort=name'>Name</A></th>
<th><A href='byond://?src=\ref[src];choice=Sorting;sort=id'>ID</A></th>
<th><A href='byond://?src=\ref[src];choice=Sorting;sort=rank'>Rank</A></th>
<th>Criminal Status</th>
</tr>"}
				if(!isnull(GLOB.data_core.general))
					for(var/datum/data/record/R in sortRecord(GLOB.data_core.general, sortBy, order))
						var/crimstat = ""
						for(var/datum/data/record/E in GLOB.data_core.security)
							if ((E.fields["name"] == R.fields["name"] && E.fields["id"] == R.fields["id"]))
								crimstat = E.fields["criminal"]
						var/background
						switch(crimstat)
							if("*Arrest*")
								background = "'background-color:#990c28;'"
							if("Incarcerated")
								background = "'background-color:#a16832;'"
							if("Released")
								background = "'background-color:#2981b3;'"
							if("Suspect")
								background = "'background-color:#686A6C;'"
							if("NJP")
								background = "'background-color:#faa20a;'"
							if("None")
								background = "'background-color:#008743;'"
							if("")
								background = "'background-color:#FFFFFF;'"
								crimstat = "No Record."
						dat += text("<tr style=[]><td><A href='byond://?src=\ref[];choice=Browse Record;d_rec=\ref[]'>[]</a></td>", background, src, R, R.fields["name"])
						dat += text("<td>[]</td>", R.fields["id"])
						dat += text("<td>[]</td>", R.fields["rank"])
						dat += text("<td>[]</td></tr>", crimstat)
					dat += "</table><hr width='75%' />"
				dat += text("<A href='byond://?src=\ref[];choice=Record Maintenance'>Record Maintenance</A><br><br>", src)
			if(2.0)
				dat += "<B>Records Maintenance</B><HR>"
				dat += "<BR><A href='byond://?src=\ref[src];choice=Delete All Records'>Delete All Records</A><BR><BR><A href='byond://?src=\ref[src];choice=Return'>Back</A>"
			if(3.0)
				dat += "<CENTER><B>Security Record</B></CENTER><BR>"
				if ((istype(selected_general, /datum/data/record) && GLOB.data_core.general.Find(selected_general)))
					dat += text("<table><tr><td> \
					Name: <A href='byond://?src=\ref[src];choice=Edit Field;field=name'>[selected_general.fields["name"]]</A><BR> \
					ID: [selected_general.fields["id"]]<BR>\n \
					Sex: <A href='byond://?src=\ref[src];choice=Edit Field;field=sex'>[selected_general.fields["sex"]]</A><BR>\n \
					Age: <A href='byond://?src=\ref[src];choice=Edit Field;field=age'>[selected_general.fields["age"]]</A><BR>\n \
					Rank: <A href='byond://?src=\ref[src];choice=Edit Field;field=rank'>[selected_general.fields["rank"]]</A><BR>\n \
					Physical Status: [selected_general.fields["p_stat"]]<BR>\n \
					Mental Status: [selected_general.fields["m_stat"]]<BR></td> \
					<td align = center valign = top>Photo:<br> \
					<table><td align = center><img src=front.png height=80 width=80 border=4><BR><A href='byond://?src=\ref[src];choice=Edit Field;field=photo front'>Update front photo</A></td> \
					<td align = center><img src=side.png height=80 width=80 border=4><BR><A href='byond://?src=\ref[src];choice=Edit Field;field=photo side'>Update side photo</A></td></table> \
					</td></tr></table>")
				else
					dat += "<B>General Record Lost!</B><BR>"
				if ((istype(selected_security, /datum/data/record) && GLOB.data_core.security.Find(selected_security)))
					dat += text("<BR>\n<CENTER><B>Security Data</B></CENTER><BR>\n \
								Criminal Status: <A href='byond://?src=\ref[];choice=Edit Field;field=criminal'>[]</A><BR> \n \
								Incidents: [selected_security.fields["incident"]]<BR>\n \
								\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>", \
								src, selected_security.fields["criminal"])
					if(islist(selected_security.fields["comments"]))
						var/counter = 1
						for(var/com_i in selected_security.fields["comments"])
							var/comment = selected_security.fields["comments"][com_i]
							var/comment_markup = text("<b>[] / [] ([])</b>\n", comment["created_at"], comment["created_by"]["name"], comment["created_by"]["rank"])
							if (isnull(comment["deleted_by"]))
								comment_markup += text("<a href='byond://?src=\ref[];choice=Delete Entry;del_c=[]'>Delete comment</a>", src, counter)
								comment_markup += text("<br />[]", comment["entry"])
							else
								comment_markup += text("<br /><i>Comment deleted by [] at []</i>", comment["deleted_by"], comment["deleted_at"])
							counter++
							dat += "[comment_markup]<br /><br />"
					else
						dat += "No comments<br><br>"
					dat += text("<a href='byond://?src=\ref[];choice=Add Entry'>Add comment</a><br /><br />", src)
				else
					dat += "<B>Security Record Lost!</B><BR>"
					dat += text("<A href='byond://?src=\ref[];choice=New Record (Security)'>New Security Record</A><BR><BR>", src)
				dat += text("\n<A href='byond://?src=\ref[];choice=Print Record'>Print Record</A><BR>\n<A href='byond://?src=\ref[];choice=Return'>Back</A><BR>", src, src)
			if(4.0)
				if(!length(Perp))
					dat += text("ERROR.  String could not be located.<br><br><A href='byond://?src=\ref[];choice=Return'>Back</A>", src)
				else
					dat += {"
<table style="text-align:center;" cellspacing="0" width="100%">
<tr> "}
					dat += text("<th>Search Results for '[]':</th>", tempname)
					dat += {"
</tr>
</table>
<table style="text-align:center;" border="1" cellspacing="0" width="100%">
<tr>
<th>Name</th>
<th>ID</th>
<th>Rank</th>
<th>Criminal Status</th>
</tr> "}
					for(var/i=1, i<=length(Perp), i += 2)
						var/crimstat = ""
						var/datum/data/record/R = Perp[i]
						if(istype(Perp[i+1],/datum/data/record/))
							var/datum/data/record/E = Perp[i+1]
							crimstat = E.fields["criminal"]
						var/background
						switch(crimstat)
							if("*Arrest*")
								background = "'background-color:#BB1133;'"
							if("Incarcerated")
								background = "'background-color:#B6732F;'"
							if("Released")
								background = "'background-color:#3BB9FF;'"
							if("Suspect")
								background = "'background-color:#686A6C;'"
							if("NJP")
								background = "'background-color:#faa20a;'"
							if("None")
								background = "'background-color:#1AAFFF;'"
							if("")
								background = ""
								crimstat = "No Record."
						dat += text("<tr style=[]><td><A href='byond://?src=\ref[];choice=Browse Record;d_rec=\ref[]'>[]</a></td>", background, src, R, R.fields["name"])
						dat += text("<td>[]</td>", R.fields["id"])
						dat += text("<td>[]</td>", R.fields["rank"])
						dat += text("<td>[]</td></tr>", crimstat)
					dat += "</table><hr width='75%' />"
					dat += text("<br><A href='byond://?src=\ref[];choice=Return'>Return to index.</A>", src)
			if(5)
				dat += generate_fingerprint_menu()

	show_browser(user, dat, "Security Records", "secure_rec", "size=600x400")
	return

/*Revised /N
I can't be bothered to look more of the actual code outside of switch but that probably needs revising too.
What a mess.*/
/obj/structure/machinery/computer/secure_data/Topic(href, href_list)
	if(..())
		return
	if (!( GLOB.data_core.general.Find(selected_general) ))
		selected_general = null
	if (!( GLOB.data_core.security.Find(selected_security) ))
		selected_security = null
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(loc, /turf))) || (isSilicon(usr)))
		usr.set_interaction(src)
		switch(href_list["choice"])
// SORTING!
			if("Sorting")
				// Reverse the order if clicked twice
				if(sortBy == href_list["sort"])
					if(order == 1)
						order = -1
					else
						order = 1
				else
				// New sorting order!
					sortBy = href_list["sort"]
					order = initial(order)
//BASIC FUNCTIONS
			if("Clear Screen")
				temp = null

			if ("Return")
				screen = 1
				selected_general = null
				selected_security = null

			if("read_fingerprint")
				screen = 5

			if("print_report")
				var/obj/item/paper/fingerprint/P = new /obj/item/paper/fingerprint(src, scanner.print_list)
				P.forceMove(loc)
				var/refkey = ""
				for(var/obj/effect/decal/prints/print in scanner.print_list)
					refkey += print.criminal_name
				P.name = "fingerprint report ([md5(refkey)])"
				playsound(loc, 'sound/machines/twobeep.ogg', 15, 1)

			if("return_menu")
				screen = 1

			if("return_clear")
				QDEL_NULL_LIST(scanner.print_list)
				scanner.update_icon()
				scanner.forceMove(get_turf(src))
				scanner = null
				screen = 1

//RECORD FUNCTIONS
			if("Search Records")
				var/t1 = input("Search String: (Partial Name or ID or Rank)", "Secure. records", null, null)  as text
				if ((!t1 || usr.stat || usr.is_mob_restrained() || !in_range(src, usr)))
					return
				Perp = new/list()
				t1 = lowertext(t1)
				var/list/components = splittext(t1, " ")
				if(length(components) > 5)
					return //Lets not let them search too greedily.
				for(var/datum/data/record/R in GLOB.data_core.general)
					var/temptext = R.fields["name"] + " " + R.fields["id"] + " " + R.fields["rank"]
					for(var/i = 1, i<=length(components), i++)
						if(findtext(temptext,components[i]))
							var/prelist = new/list(2)
							prelist[1] = R
							Perp += prelist
				for(var/i = 1, i<=length(Perp), i+=2)
					for(var/datum/data/record/E in GLOB.data_core.security)
						var/datum/data/record/R = Perp[i]
						if ((E.fields["name"] == R.fields["name"] && E.fields["id"] == R.fields["id"]))
							Perp[i+1] = E
				tempname = t1
				screen = 4

			if("Record Maintenance")
				screen = 2
				selected_general = null
				selected_security = null

			if ("Browse Record")
				var/datum/data/record/R = locate(href_list["d_rec"])
				var/S = locate(href_list["d_rec"])
				if (!( GLOB.data_core.general.Find(R) ))
					temp = "Record Not Found!"
				else
					for(var/datum/data/record/E in GLOB.data_core.security)
						if ((E.fields["name"] == R.fields["name"] || E.fields["id"] == R.fields["id"]))
							S = E
					selected_general = R
					selected_security = S
					screen = 3


			if ("Print Record")
				if (!( printing ))
					printing = 1
					var/datum/data/record/record1 = null
					var/datum/data/record/record2 = null
					if ((istype(selected_general, /datum/data/record) && GLOB.data_core.general.Find(selected_general)))
						record1 = selected_general
					if ((istype(selected_security, /datum/data/record) && GLOB.data_core.security.Find(selected_security)))
						record2 = selected_security
					sleep(50)
					var/obj/item/paper/P = new /obj/item/paper( loc )
					P.info = "<CENTER><B>Security Record</B></CENTER><BR>"
					if (record1)
						P.info += text("Name: []<br />\nID: []<br />\nSex: []<br />\nAge: []<br />\nRank: []<br />\nPhysical Status: []<br />\nMental Status: []<br />Criminal Status: []<br />", record1.fields["name"], record1.fields["id"], record1.fields["sex"], record1.fields["age"], record1.fields["rank"], record1.fields["p_stat"], record1.fields["m_stat"], record2.fields["criminal"])
						P.name = text("Security Record ([])", record1.fields["name"])
					else
						P.info += "<b>General Record Lost!</b><br />"
						P.name = "Security Record"
					if (record2)
						P.info += text("<BR>\n<CENTER><B>Security Data</B></CENTER><BR>\nIncidents: [record2.fields["incident"]]<BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>")
						if(islist(record2.fields["comments"]) || length(record2.fields["comments"]) > 0)
							for(var/com_i in record2.fields["comments"])
								var/comment = record2.fields["comments"][com_i]
								var/comment_markup = text("<b>[] / [] ([])</b><br />", comment["created_at"], comment["created_by"]["name"], comment["created_by"]["rank"])
								if (isnull(comment["deleted_by"]))
									comment_markup += comment["entry"]
								else
									comment_markup += text("<i>Comment deleted by [] at []</i>", comment["deleted_by"], comment["deleted_at"])
								P.info += "[comment_markup]<br /><br />"
						else
							P.info += text("<b>No comments</b><br />")
					else
						P.info += "<B>Security Record Lost!</B><BR>"
					P.info += "</TT>"
					printing = null
					updateUsrDialog()
//RECORD DELETE
			if ("Delete All Records")
				temp = ""
				temp += "Are you sure you wish to delete all Security records?<br>"
				temp += "<a href='byond://?src=\ref[src];choice=Purge All Records'>Yes</a><br>"
				temp += "<a href='byond://?src=\ref[src];choice=Clear Screen'>No</a>"

			if ("Purge All Records")
				GLOB.data_core.manifest_delete_all_security()
				temp = "All Security records deleted."

			if ("Add Entry")
				if (!(istype(selected_security, /datum/data/record)))
					return
				var/a2 = selected_security
				var/new_value = copytext(trim(strip_html(input("Your name and time will be added to this new comment.", "Add a comment", null, null)  as message)),1,MAX_MESSAGE_LEN)
				if((!new_value || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isSilicon(usr))) || selected_security != a2))
					return
				var/created_at = text("[]&nbsp;&nbsp;[]&nbsp;&nbsp;[]", time2text(world.realtime, "MMM DD"), time2text(world.time, "[worldtime2text()]:ss"), GLOB.game_year)
				var/new_comment = list("entry" = new_value, "created_by" = list("name" = "", "rank" = ""), "deleted_by" = null, "deleted_at" = null, "created_at" = created_at)
				if(istype(usr,/mob/living/carbon/human))
					var/mob/living/carbon/human/U = usr
					new_comment["created_by"] = list("name" = U.get_authentification_name(), "rank" = U.get_assignment())
				if(!islist(selected_security.fields["comments"]))
					selected_security.fields["comments"] = list("1" = new_comment)
				else
					var/new_com_i = length(selected_security.fields["comments"]) + 1
					selected_security.fields["comments"]["[new_com_i]"] = new_comment
				to_chat(usr, text("You have added a new comment to the Security Record of [].", selected_security.fields["name"]))
				msg_admin_niche("[key_name_admin(usr)] added a security comment for [selected_general.fields["name"]] ([selected_general.fields["id"]]): [new_value].")

			if ("Delete Entry")
				if(!islist(selected_security.fields["comments"]))
					return
				if(selected_security.fields["comments"][href_list["del_c"]])
					var/updated_comments = selected_security.fields["comments"]
					var/deleter = ""
					if(istype(usr,/mob/living/carbon/human))
						var/mob/living/carbon/human/U = usr
						deleter = "[U.get_authentification_name()] ([U.get_assignment()])"
					updated_comments[href_list["del_c"]]["deleted_by"] = deleter
					updated_comments[href_list["del_c"]]["deleted_at"] = text("[]&nbsp;&nbsp;[]&nbsp;&nbsp;[]", time2text(world.realtime, "MMM DD"), time2text(world.time, "[worldtime2text()]:ss"), GLOB.game_year)
					selected_security.fields["comments"] = updated_comments
					to_chat(usr, text("You have deleted a comment from the Security Record of [].", selected_security.fields["name"]))
//RECORD CREATE
			if ("New Record (Security)")
				if ((istype(selected_general, /datum/data/record) && !( istype(selected_security, /datum/data/record) )))
					selected_security = CreateSecurityRecord(selected_general.fields["name"], selected_general.fields["id"])
					screen = 3

			if ("New Record (General)")
				selected_general = CreateGeneralRecord()
				selected_security = null

//FIELD FUNCTIONS
			if ("Edit Field")
				if (is_not_allowed(usr))
					return
				var/a1 = selected_general
				switch(href_list["field"])
					if("name")
						if (istype(selected_general, /datum/data/record))
							var/new_value = reject_bad_name(input(usr, "Please input name:", "Secure. records", selected_general.fields["name"]) as text|null)
							if (!new_value || selected_general != a1)
								return
							selected_general.fields["name"] = new_value
							GLOB.data_core.manifest_updated_general_record(selected_general)
							message_admins("[key_name(usr)] changed the security record name of [selected_general.fields["name"]] to [new_value]")

					if("sex")
						if (istype(selected_general, /datum/data/record))
							var/new_value = "Male"
							if (selected_general.fields["sex"] == "Male")
								new_value = "Female"
							selected_general.fields["sex"] = new_value
							GLOB.data_core.manifest_updated_general_record(selected_general)
							msg_admin_niche("[key_name(usr)] changed the security record sex of [selected_general.fields["name"]] to [new_value]")

					if("age")
						if (istype(selected_general, /datum/data/record))
							var/new_value = input("Please input age:", "Secure. records", selected_general.fields["age"], null)  as num
							if (!new_value || selected_general != a1)
								return
							selected_general.fields["age"] = new_value
							GLOB.data_core.manifest_updated_general_record(selected_general)
							msg_admin_niche("[key_name(usr)] changed the security record age of [selected_general.fields["name"]] to [new_value]")

					if("criminal")
						if (istype(selected_security, /datum/data/record))
							temp = "<h5>Criminal Status:</h5>"
							temp += "<ul>"
							temp += "<li><a href='byond://?src=\ref[src];choice=Change Criminal Status;criminal2=none'>None</a></li>"
							temp += "<li><a href='byond://?src=\ref[src];choice=Change Criminal Status;criminal2=arrest'>*Arrest*</a></li>"
							temp += "<li><a href='byond://?src=\ref[src];choice=Change Criminal Status;criminal2=incarcerated'>Incarcerated</a></li>"
							temp += "<li><a href='byond://?src=\ref[src];choice=Change Criminal Status;criminal2=released'>Released</a></li>"
							temp += "<li><a href='byond://?src=\ref[src];choice=Change Criminal Status;criminal2=suspect'>Suspect</a></li>"
							temp += "<li><a href='byond://?src=\ref[src];choice=Change Criminal Status;criminal2=njp'>NJP</a></li>"
							temp += "</ul>"

					if("rank")
						//This was so silly before the change. Now it actually works without beating your head against the keyboard. /N
						if (istype(selected_general, /datum/data/record) && GLOB.uscm_highcom_paygrades.Find(rank))
							temp = "<h5>Occupation:</h5>"
							temp += "<ul>"
							for(var/rank in GLOB.joblist)
								temp += "<li><a href='byond://?src=\ref[src];choice=Change Rank;rank=[rank]'>[rank]</a></li>"
							temp += "</ul>"
						else
							alert(usr, "You do not have the required rank to do this!")

					if("species")
						if (istype(selected_general, /datum/data/record))
							var/new_value = copytext(trim(strip_html(input("Please enter race:", "General records", selected_general.fields["species"], null)  as message)),1,MAX_MESSAGE_LEN)
							if (!new_value || selected_general != a1)
								return
							selected_general.fields["species"] = new_value
							GLOB.data_core.manifest_updated_general_record(selected_general)
							msg_admin_niche("[key_name(usr)] changed the security record species of [selected_general.fields["name"]] to [new_value]")


//TEMPORARY MENU FUNCTIONS
			else//To properly clear as per clear screen.
				temp=null
				switch(href_list["choice"])
					if ("Change Rank")
						if(istype(selected_general, /datum/data/record) && GLOB.uscm_highcom_paygrades.Find(rank))
							var/new_value = href_list["rank"]
							selected_general.fields["rank"] = new_value
							if(new_value in GLOB.joblist)
								selected_general.fields["real_rank"] = new_value
							GLOB.data_core.manifest_updated_general_record(selected_general)
							message_admins("[key_name(usr)] changed the security record sex of [selected_general.fields["name"]] to [new_value]")

					if ("Change Criminal Status")
						if(istype(selected_security, /datum/data/record))
							var/new_value = href_list["criminal2"]
							switch(new_value)
								if("none")
									selected_security.fields["criminal"] = "None"
								if("arrest")
									selected_security.fields["criminal"] = "*Arrest*"
								if("incarcerated")
									selected_security.fields["criminal"] = "Incarcerated"
								if("released")
									selected_security.fields["criminal"] = "Released"
								if("suspect")
									selected_security.fields["criminal"] = "Suspect"
								if("njp")
									selected_security.fields["criminal"] = "NJP"

							// try and avoid looping over every single human mob just for a sec status update
							var/datum/weakref/criminal_ref = selected_security["ref"]
							var/mob/living/carbon/human/criminal = criminal_ref.resolve()
							if(criminal)
								criminal.sec_hud_set_security_status()
							else // safety fallback
								for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
									H.sec_hud_set_security_status()
							GLOB.data_core.manifest_updated_security_record(selected_security)
							message_admins("[key_name(usr)] changed the security record criminal status of [selected_general.fields["name"]] to [new_value]")

	add_fingerprint(usr)
	updateUsrDialog()
	return

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

	dat += "<a href='byond://?src=\ref[src];choice=print_report'>Print Evidence</a><BR>"
	dat += "<a href='byond://?src=\ref[src];choice=return_menu'>Return</a><BR>"
	dat += "<a href='byond://?src=\ref[src];choice=return_clear'>Clear Print and Return</a>"

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

	GLOB.data_core.manifest_security_emp_act(severity)

/obj/structure/machinery/computer/secure_data/detective_computer
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "messyfiles"
