//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/machinery/computer/skills//TODO:SANITY
	name = "Employment Records"
	desc = "Used to view personnel's employment records"
	icon_state = "medlaptop"
	req_one_access = list(ACCESS_MARINE_DATABASE)
	circuit = /obj/item/circuitboard/computer/skills
	var/obj/item/card/id/scan = null
	var/authenticated = null
	var/rank = null
	var/screen = null
	var/datum/data/record/selected_general = null
	var/a_id = null
	var/temp = null
	var/printing = null
	var/can_change_id = 0
	var/list/Perp
	var/tempname = null
	//Sorting Variables
	var/sortBy = "name"
	var/order = 1 // -1 = Descending - 1 = Ascending


/obj/structure/machinery/computer/skills/attackby(obj/item/O as obj, user as mob)
	if(istype(O, /obj/item/card/id) && !scan)
		if(usr.drop_held_item())
			O.forceMove(src)
			scan = O
			to_chat(user, "You insert [O].")
	. = ..()

/obj/structure/machinery/computer/skills/attack_remote(mob/user as mob)
	return attack_hand(user)

//Someone needs to break down the dat += into chunks instead of long ass lines.
/obj/structure/machinery/computer/skills/attack_hand(mob/user as mob)
	if(..())
		return
	if (src.z > 6)
		to_chat(user, SPAN_DANGER("<b>Unable to establish a connection</b>: \black You're too far away from the station!"))
		return
	var/dat

	if (temp)
		dat = "<TT>[temp]</TT><BR><BR><A href='byond://?src=\ref[src];choice=Clear Screen'>Clear Screen</A>"
	else
		dat = "Confirm Identity: <A href='byond://?src=\ref[src];choice=Confirm Identity'>[scan ? scan.name : "----------"]</A><HR>"
		if (authenticated)
			switch(screen)
				if(1.0)
					dat += {"
<p style='text-align:center;'>"}
					dat += "<A href='byond://?src=\ref[src];choice=Search Records'>Search Records</A><BR>"
					dat += "<A href='byond://?src=\ref[src];choice=New Record (General)'>New Record</A><BR>"
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
<th><A href='byond://?src=\ref[src];choice=Sorting;sort=fingerprint'>Fingerprints</A></th>
</tr>"}
					if(!isnull(GLOB.data_core.general))
						for(var/datum/data/record/R in sortRecord(GLOB.data_core.general, sortBy, order))
							for(var/datum/data/record/E in GLOB.data_core.security)
							dat += "<tr><td><A href='byond://?src=\ref[src];choice=Browse Record;d_rec=\ref[R]'>[R.fields["name"]]</a></td>"
							dat += "<td>[R.fields["id"]]</td>"
							dat += "<td>[R.fields["rank"]]</td>"
						dat += "</table><hr width='75%' />"
					dat += "<A href='byond://?src=\ref[src];choice=Record Maintenance'>Record Maintenance</A><br><br>"
					dat += "<A href='byond://?src=\ref[src];choice=Log Out'>{Log Out}</A>"
				if(2.0)
					dat += "<B>Records Maintenance</B><HR>"
					dat += "<BR><A href='byond://?src=\ref[src];choice=Delete All Records'>Delete All Records</A><BR><BR><A href='byond://?src=\ref[src];choice=Return'>Back</A>"
				if(3.0)
					dat += "<CENTER><B>Employment Record</B></CENTER><BR>"
					if ((istype(selected_general, /datum/data/record) && GLOB.data_core.general.Find(selected_general)))
						dat += "<table><tr><td> \
						Name: <A href='byond://?src=\ref[src];choice=Edit Field;field=name'>[selected_general.fields["name"]]</A><BR> \
						ID: <A href='byond://?src=\ref[src];choice=Edit Field;field=id'>[selected_general.fields["id"]]</A><BR>\n \
						Sex: <A href='byond://?src=\ref[src];choice=Edit Field;field=sex'>[selected_general.fields["sex"]]</A><BR>\n \
						Age: <A href='byond://?src=\ref[src];choice=Edit Field;field=age'>[selected_general.fields["age"]]</A><BR>\n \
						Rank: <A href='byond://?src=\ref[src];choice=Edit Field;field=rank'>[selected_general.fields["rank"]]</A><BR>\n \
						Physical Status: [selected_general.fields["p_stat"]]<BR>\n \
						Mental Status: [selected_general.fields["m_stat"]]<BR><BR>\n \
						Employment/skills summary:<BR> [decode(selected_general.fields["notes"])]<BR></td> \
						<td align = center valign = top>Photo:<br><img src=front.png height=80 width=80 border=4> \
						<img src=side.png height=80 width=80 border=4></td></tr></table>"
					else
						dat += "<B>General Record Lost!</B><BR>"
					dat += "\n<A href='byond://?src=\ref[src];choice=Delete Record (ALL)'>Delete Record (ALL)</A><BR><BR>\n<A href='byond://?src=\ref[src];choice=Print Record'>Print Record</A><BR>\n<A href='byond://?src=\ref[src];choice=Return'>Back</A><BR>"
				if(4.0)
					if(!length(Perp))
						dat += "ERROR.  String could not be located.<br><br><A href='byond://?src=\ref[src];choice=Return'>Back</A>"
					else
						dat += {"
<table style="text-align:center;" cellspacing="0" width="100%">
<tr> "}
						dat += "<th>Search Results for '[tempname]':</th>"
						dat += {"
</tr>
</table>
<table style="text-align:center;" border="1" cellspacing="0" width="100%">
<tr>
<th>Name</th>
<th>ID</th>
<th>Rank</th>
<th>Fingerprints</th>
</tr> "}
						for(var/i=1, i<=length(Perp), i += 2)
							var/crimstat = ""
							var/datum/data/record/R = Perp[i]
							if(istype(Perp[i+1],/datum/data/record/))
								var/datum/data/record/E = Perp[i+1]
								crimstat = E.fields["criminal"]
							dat += "<tr style=background-color:#00FF7F><td><A href='byond://?src=\ref[src];choice=Browse Record;d_rec=\ref[R]'>[R.fields["name"]]</a></td>"
							dat += "<td>[R.fields["id"]]</td>"
							dat += "<td>[R.fields["rank"]]</td>"
							dat += "<td>[crimstat]</td></tr>"
						dat += "</table><hr width='75%' />"
						dat += "<br><A href='byond://?src=\ref[src];choice=Return'>Return to index.</A>"
		else
			dat += "<A href='byond://?src=\ref[src];choice=Log In'>{Log In}</A>"
	show_browser(user, dat, "Employment Records", "secure_rec", "size=600x400")
	onclose(user, "secure_rec")
	return

/*Revised /N
I can't be bothered to look more of the actual code outside of switch but that probably needs revising too.
What a mess.*/
/obj/structure/machinery/computer/skills/Topic(href, href_list)
	if(..())
		return
	if (!( GLOB.data_core.general.Find(selected_general) ))
		selected_general = null
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(loc, /turf))) || (isRemoteControlling(usr)))
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

			if("Confirm Identity")
				if (scan)
					if(istype(usr,/mob/living/carbon/human) && !usr.get_active_hand())
						usr.put_in_hands(scan)
					else
						scan.forceMove(get_turf(src))
					scan = null
				else
					var/obj/item/I = usr.get_active_hand()
					if (istype(I, /obj/item/card/id))
						if(usr.drop_held_item())
							I.forceMove(src)
							scan = I

			if("Log Out")
				authenticated = null
				screen = null
				selected_general = null

			if("Log In")
				if (isRemoteControlling(usr))
					src.selected_general = null
					src.authenticated = usr.name
					src.rank = "AI"
					src.screen = 1
				else if (istype(scan, /obj/item/card/id))
					selected_general = null
					if(check_access(scan))
						authenticated = scan.registered_name
						rank = scan.paygrade
						screen = 1
//RECORD FUNCTIONS
			if("Search Records")
				var/t1 = input("Search String: (Partial Name or ID or Fingerprints or Rank)", "Secure. records", null, null)  as text
				if ((!( t1 ) || usr.stat || !( authenticated ) || usr.is_mob_restrained() || !in_range(src, usr)))
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

			if ("Browse Record")
				var/datum/data/record/R = locate(href_list["d_rec"])
				if (!( GLOB.data_core.general.Find(R) ))
					temp = "Record Not Found!"
				else
					for(var/datum/data/record/E in GLOB.data_core.security)
					selected_general = R
					screen = 3

			if ("Print Record")
				if (!( printing ))
					printing = 1
					sleep(50)
					var/obj/item/paper/P = new /obj/item/paper( loc )
					P.info = "<CENTER><B>Employment Record</B></CENTER><BR>"
					if ((istype(selected_general, /datum/data/record) && GLOB.data_core.general.Find(selected_general)))
						P.info += "Name: [selected_general.fields["name"]] ID: [selected_general.fields["id"]]<BR>\nSex: [selected_general.fields["sex"]]<BR>\nAge: [selected_general.fields["age"]]<BR>\nPhysical Status: [selected_general.fields["p_stat"]]<BR>\nMental Status: [selected_general.fields["m_stat"]]<BR>\nEmployment/Skills Summary:<BR>\n[decode(selected_general.fields["notes"])]<BR>"
						P.name = "Employment Record ([selected_general.fields["name"]])"
					else
						P.info += "<B>General Record Lost!</B><BR>"
						P.name = "Employment Record (???)"
					P.info += "</TT>"

					printing = null
//RECORD DELETE
			if ("Delete All Records")
				temp = ""
				temp += "Are you sure you wish to delete all Employment records?<br>"
				temp += "<a href='byond://?src=\ref[src];choice=Purge All Records'>Yes</a><br>"
				temp += "<a href='byond://?src=\ref[src];choice=Clear Screen'>No</a>"

			if ("Purge All Records")
				GLOB.data_core.manifest_delete_all_security()
				temp = "All Employment records deleted."

			if ("Delete Record (ALL)")
				if(istype(selected_general, /datum/data/record))
					temp = "<h5>Are you sure you wish to delete the record (ALL)?</h5>"
					temp += "<a href='byond://?src=\ref[src];choice=Delete Record (ALL) Execute'>Yes</a><br>"
					temp += "<a href='byond://?src=\ref[src];choice=Clear Screen'>No</a>"
//RECORD CREATE
			if ("New Record (General)")
				selected_general = CreateGeneralRecord()

//FIELD FUNCTIONS
			if ("Edit Field")
				var/a1 = selected_general
				switch(href_list["field"])
					if("name")
						if (istype(selected_general, /datum/data/record))
							var/new_value = reject_bad_name(input("Please input name:", "Secure. records", selected_general.fields["name"], null)  as text)
							if ((!( new_value ) || !length(trim(new_value)) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr)))) || selected_general != a1)
								return
							selected_general.fields["name"] = new_value
							GLOB.data_core.manifest_updated_general_record(selected_general)
							message_admins("[key_name(usr)] changed the employment record name of [selected_general.fields["name"]] to [new_value]")

					if("id")
						if (istype(selected_general, /datum/data/record))
							var/new_value = copytext(trim(sanitize(input("Please input id:", "Secure. records", selected_general.fields["id"], null)  as text)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || selected_general != a1))
								return
							selected_general.fields["id"] = new_value
							GLOB.data_core.manifest_updated_general_record(selected_general)
							msg_admin_niche("[key_name_admin(usr)] changed the employment record id for [selected_general.fields["name"]] ([selected_general.fields["id"]]) to [new_value].")

					if("sex")
						if (istype(selected_general, /datum/data/record))
							var/new_value = "Male"
							if (selected_general.fields["sex"] == "Male")
								new_value = "Female"
							selected_general.fields["sex"] = new_value
							GLOB.data_core.manifest_updated_general_record(selected_general)
							msg_admin_niche("[key_name_admin(usr)] changed the employment record sex for [selected_general.fields["name"]] ([selected_general.fields["id"]]) to [new_value].")

					if("age")
						if (istype(selected_general, /datum/data/record))
							var/new_value = input("Please input age:", "Secure. records", selected_general.fields["age"], null)  as num
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || selected_general != a1))
								return
							selected_general.fields["age"] = new_value
							GLOB.data_core.manifest_updated_general_record(selected_general)
							msg_admin_niche("[key_name_admin(usr)] changed the employment record age for [selected_general.fields["name"]] ([selected_general.fields["id"]]) to [new_value].")

					if("rank")
						if(istype(selected_general, /datum/data/record))
						//This was so silly before the change. Now it actually works without beating your head against the keyboard. /N
							if(GLOB.uscm_highcom_paygrades.Find(rank))
								temp = "<h5>Occupation:</h5>"
								temp += "<ul>"
								for(var/rank in GLOB.joblist)
									temp += "<li><a href='byond://?src=\ref[src];choice=Change Rank;rank=[rank]'>[rank]</a></li>"
								temp += "</ul>"
							else
								alert(usr, "You do not have the required rank to do this!")

					if("species")
						if (istype(selected_general, /datum/data/record))
							var/new_value = copytext(trim(sanitize(input("Please enter race:", "General records", selected_general.fields["species"], null)  as message)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || selected_general != a1))
								return
							selected_general.fields["species"] = new_value
							GLOB.data_core.manifest_updated_general_record(selected_general)
							msg_admin_niche("[key_name_admin(usr)] changed the employment record species for [selected_general.fields["name"]] ([selected_general.fields["id"]]) to [new_value].")

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
							message_admins("[key_name_admin(usr)] changed the employment record rank for [selected_general.fields["name"]] ([selected_general.fields["id"]]) to [new_value].")

					if ("Delete Record (ALL) Execute")
						GLOB.data_core.manifest_delete_medical_record(selected_general)
						selected_general = null
					else
						temp = "This function does not appear to be working at the moment. Our apologies."

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/structure/machinery/computer/skills/emp_act(severity)
	. = ..()
	if(inoperable())
		return

	GLOB.data_core.manifest_security_emp_act(severity)

