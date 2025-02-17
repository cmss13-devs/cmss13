//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/machinery/computer/med_data//TODO:SANITY
	name = "Medical Records"
	desc = "This can be used to check medical records."
	icon_state = "medcomp"
	density = TRUE
	req_one_access = list(ACCESS_MARINE_MEDBAY, ACCESS_WY_MEDICAL)
	circuit = /obj/item/circuitboard/computer/med_data
	var/obj/item/card/id/scan = null
	var/last_user_name = ""
	var/last_user_rank = ""
	var/authenticated = null
	var/rank = null
	var/screen = null
	var/datum/data/record/active1 = null
	var/datum/data/record/active2 = null
	var/a_id = null
	var/temp = null
	var/printing = null

/obj/structure/machinery/computer/med_data/verb/eject_id()
	set category = "Object"
	set name = "Eject ID Card"
	set src in oview(1)

	if(!usr || usr.is_mob_incapacitated())
		return

	if(scan)
		to_chat(usr, "You remove \the [scan] from \the [src].")
		scan.forceMove(get_turf(src))
		if(!usr.get_active_hand() && istype(usr,/mob/living/carbon/human))
			usr.put_in_hands(scan)
		scan = null
	else
		to_chat(usr, "There is nothing to remove from the console.")
	return

/obj/structure/machinery/computer/med_data/attackby(obj/item/O as obj, user as mob)
	if(istype(O, /obj/item/card/id) && !scan)
		if(usr.drop_held_item())
			O.forceMove(src)
			scan = O
			last_user_name = scan.registered_name
			last_user_rank = scan.rank
			to_chat(user, "You insert [O].")
	. = ..()

/obj/structure/machinery/computer/med_data/attack_remote(user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/computer/med_data/attack_hand(mob/user as mob)
	if(..())
		return
	var/dat
	if (src.temp)
		dat = text("<TT>[src.temp]</TT><BR><BR><A href='byond://?src=\ref[src];temp=1'>Clear Screen</A>")
	else
		dat = text("Confirm Identity: <A href='byond://?src=\ref[];scan=1'>[]</A><HR>", src, (src.scan ? text("[]", src.scan.name) : "----------"))
		if (src.authenticated)
			switch(src.screen)
				if(1.0)
					dat += {"
<A href='byond://?src=\ref[src];search=1'>Search Records</A>
<BR><A href='byond://?src=\ref[src];screen=2'>List Records</A>
<BR>
<BR><A href='byond://?src=\ref[src];screen=5'>Medbot Tracking</A>
<BR>
<BR><A href='byond://?src=\ref[src];screen=3'>Record Maintenance</A>
<BR><A href='byond://?src=\ref[src];logout=1'>{Log Out}</A><BR>
"}
				if(2.0)
					dat += "<B>Record List</B>:<HR>"
					if(!isnull(GLOB.data_core.general))
						for(var/datum/data/record/R in sortRecord(GLOB.data_core.general))
							dat += text("<A href='byond://?src=\ref[];d_rec=\ref[]'>[]: []<BR>", src, R, R.fields["id"], R.fields["name"])
							//Foreach goto(132)
					dat += text("<HR><A href='byond://?src=\ref[];screen=1'>Back</A>", src)
				if(3.0)
					dat += text("<B>Records Maintenance</B><HR>\n<A href='byond://?src=\ref[];back=1'>Backup To Disk</A><BR>\n<A href='byond://?src=\ref[];u_load=1'>Upload From disk</A><BR>\n<A href='byond://?src=\ref[];del_all=1'>Delete All Records</A><BR>\n<BR>\n<A href='byond://?src=\ref[];screen=1'>Back</A>", src, src, src, src)
				if(4.0)
					if ((istype(active1, /datum/data/record) && GLOB.data_core.general.Find(active1)))
						dat += "<CENTER><B>Medical Record</B></CENTER><BR>"
						dat += "<table><tr><td>Name: [active1.fields["name"]] \
								ID: [active1.fields["id"]]<BR>\n \
								Sex: <A href='byond://?src=\ref[src];field=sex'>[active1.fields["sex"]]</A><BR>\n \
								Age: <A href='byond://?src=\ref[src];field=age'>[active1.fields["age"]]</A><BR>\n \
								Physical Status: <A href='byond://?src=\ref[src];field=p_stat'>[active1.fields["p_stat"]]</A><BR>\n \
								Mental Status: <A href='byond://?src=\ref[src];field=m_stat'>[active1.fields["m_stat"]]</A><BR></td><td align = center valign = top> \
								Photo:<br><img src=front.png height=64 width=64 border=5><img src=side.png height=64 width=64 border=5></td></tr></table>"
					else
						dat += "<B>General Record Lost!</B><BR>"
					if ((istype(src.active2, /datum/data/record) && GLOB.data_core.medical.Find(src.active2)))
						dat += "<BR>\n<CENTER><B>Medical Data</B></CENTER><BR>\nBlood Type: <A href='byond://?src=\ref[src];field=b_type'>[active2.fields["b_type"]]</A><BR>\n<BR>\nMinor Disabilities: <A href='byond://?src=\ref[src];field=mi_dis'>[active2.fields["mi_dis"]]</A><BR>\nDetails: <A href='byond://?src=\ref[src];field=mi_dis_d'>[active2.fields["mi_dis_d"]]</A><BR>\n<BR>\nMajor Disabilities: <A href='byond://?src=\ref[src];field=ma_dis'>[active2.fields["ma_dis"]]</A><BR>\nDetails: <A href='byond://?src=\ref[src];field=ma_dis_d'>[active2.fields["ma_dis_d"]]</A><BR>\n<BR>\nAllergies: <A href='byond://?src=\ref[src];field=alg'>[active2.fields["alg"]]</A><BR>\nDetails: <A href='byond://?src=\ref[src];field=alg_d'>[active2.fields["alg_d"]]</A><BR>\n<BR>\nCurrent Diseases: <A href='byond://?src=\ref[src];field=cdi'>[active2.fields["cdi"]]</A> (per disease info placed in log/comment section)<BR>\nDetails: <A href='byond://?src=\ref[src];field=cdi_d'>[active2.fields["cdi_d"]]</A><BR>\n<BR>\nImportant Notes:<BR>\n\t<A href='byond://?src=\ref[src];field=notes'>[decode(src.active2.fields["notes"])]</A><BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>"
						var/counter = 1
						while(active2.fields[text("com_[]", counter)])
							var/current_index = text("com_[]", counter)
							if(findtext(active2.fields[current_index], "<BR>"))
								dat += text("[]<BR><A href='byond://?src=\ref[];del_c=[]'>Delete Entry</A><BR><BR>", active2.fields[current_index], src, counter)
							else
								dat += text("[]<BR><BR>", active2.fields[current_index])
							counter++
						dat += text("<A href='byond://?src=\ref[];add_c=1'>Add Entry</A><BR><BR>", src)
						dat += text("<A href='byond://?src=\ref[];del_r=1'>Delete Record (Medical Only)</A><BR><BR>", src)
					else
						dat += "<B>Medical Record Lost!</B><BR>"
						dat += text("<A href='byond://?src=\ref[src];new=1'>New Record</A><BR><BR>")
					dat += text("\n<A href='byond://?src=\ref[];print_p=1'>Print Record</A><BR>\n", src)
					dat += text("\n<A href='byond://?src=\ref[];print_bs=1'>Print Latest Bodyscan</A><BR><BR>\n<A href='byond://?src=\ref[];screen=2'>Back</A><BR>", src, src)
				if(5)
					dat += "<center><b>Medical Robot Monitor</b></center>"
					dat += "<a href='byond://?src=\ref[src];screen=1'>Back</a>"
					dat += "<br><b>Medical Robots:</b>"
					var/bdat = null
					for(var/obj/structure/machinery/bot/medbot/M in GLOB.machines)

						if(M.z != src.z)
							continue //only find medibots on the same z-level as the computer
						var/turf/bl = get_turf(M)
						if(bl) //if it can't find a turf for the medibot, then it probably shouldn't be showing up
							bdat += "[M.name] - <b>\[[bl.x],[bl.y]\]</b> - [M.on ? "Online" : "Offline"]<br>"
							if((!isnull(M.reagent_glass)) && M.use_beaker)
								bdat += "Reservoir: \[[M.reagent_glass.reagents.total_volume]/[M.reagent_glass.reagents.maximum_volume]\]<br>"
							else
								bdat += "Using Internal Synthesizer.<br>"
					if(!bdat)
						dat += "<br><center>None detected</center>"
					else
						dat += "<br>[bdat]"

		else
			dat += text("<A href='byond://?src=\ref[];login=1'>{Log In}</A>", src)
	show_browser(user, dat, "Medical Records", "med_rec")
	onclose(user, "med_rec")
	return

/obj/structure/machinery/computer/med_data/Topic(href, href_list)
	if(..())
		return

	if (!( GLOB.data_core.general.Find(src.active1) ))
		src.active1 = null

	if (!( GLOB.data_core.medical.Find(src.active2) ))
		src.active2 = null

	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (isRemoteControlling(usr)))
		usr.set_interaction(src)

		if (href_list["temp"])
			src.temp = null

		if (href_list["scan"])
			if (src.scan)

				if(ishuman(usr))
					scan.forceMove(usr.loc)

					if(!usr.get_active_hand())
						usr.put_in_hands(scan)

					scan = null

				else
					src.scan.forceMove(src.loc)
					src.scan = null

			else
				var/obj/item/I = usr.get_active_hand()
				if (istype(I, /obj/item/card/id))
					if(usr.drop_held_item())
						I.forceMove(src)
						src.scan = I

		else if (href_list["logout"])
			src.authenticated = null
			src.screen = null
			src.active1 = null
			src.active2 = null

		else if (href_list["login"])

			if (isRemoteControlling(usr))
				src.active1 = null
				src.active2 = null
				src.authenticated = usr.name
				src.rank = "AI"
				src.screen = 1

			else if (istype(src.scan, /obj/item/card/id))
				src.active1 = null
				src.active2 = null

				if (src.check_access(src.scan))
					src.authenticated = src.scan.registered_name
					src.rank = src.scan.assignment
					src.screen = 1

		if (src.authenticated)

			if(href_list["screen"])
				src.screen = text2num(href_list["screen"])
				if(src.screen < 1)
					src.screen = 1

				src.active1 = null
				src.active2 = null

			if (href_list["del_all"])
				src.temp = text("Are you sure you wish to delete all records?<br>\n\t<A href='byond://?src=\ref[];temp=1;del_all2=1'>Yes</A><br>\n\t<A href='byond://?src=\ref[];temp=1'>No</A><br>", src, src)

			if (href_list["del_all2"])
				for(var/datum/data/record/R as anything in GLOB.data_core.medical)
					GLOB.data_core.medical -= R
					qdel(R)
					//Foreach goto(494)
				temp = "All records deleted."
				msg_admin_niche("[key_name_admin(usr)] deleted all medical records.")

			if (href_list["field"])
				var/a1 = active1
				var/a2 = active2
				switch(href_list["field"])
					if("sex")
						if (istype(active1, /datum/data/record))
							var/new_value = "Male"
							if (active1.fields["sex"] == "Male")
								new_value = "Female"
							active1.fields["sex"] = new_value
							msg_admin_niche("[key_name_admin(usr)] set the medical record sex for [active1.fields["name"]] ([active1.fields["id"]]) to [new_value].")
					if("age")
						if (istype(active1, /datum/data/record))
							var/new_value = input("Please input age:", "Med. records", active1.fields["age"], null)  as num
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || active1 != a1))
								return
							active1.fields["age"] = new_value
							msg_admin_niche("[key_name_admin(usr)] set the medical record age for [active1.fields["name"]] ([active1.fields["id"]]) to [new_value].")
					if("mi_dis")
						if (istype(active2, /datum/data/record))
							var/new_value = copytext(trim(strip_html(input("Please input minor disabilities list:", "Med. records", active2.fields["mi_dis"], null)  as text)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || active2 != a2))
								return
							active2.fields["mi_dis"] = new_value
							msg_admin_niche("[key_name_admin(usr)] set the medical record minor disabilities list for [active1.fields["name"]] ([active1.fields["id"]]) to [new_value].")
					if("mi_dis_d")
						if (istype(active2, /datum/data/record))
							var/new_value = copytext(trim(strip_html(input("Please summarize minor dis.:", "Med. records", active2.fields["mi_dis_d"], null)  as message)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || active2 != a2))
								return
							active2.fields["mi_dis_d"] = new_value
							msg_admin_niche("[key_name_admin(usr)] set the medical record minor disabilities desc for [active1.fields["name"]] ([active1.fields["id"]]) to [new_value].")
					if("ma_dis")
						if (istype(active2, /datum/data/record))
							var/new_value = copytext(trim(strip_html(input("Please input major diabilities list:", "Med. records", active2.fields["ma_dis"], null)  as text)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || active2 != a2))
								return
							active2.fields["ma_dis"] = new_value
							msg_admin_niche("[key_name_admin(usr)] set the medical record major disabilities list for [active1.fields["name"]] ([active1.fields["id"]]) to [new_value].")
					if("ma_dis_d")
						if (istype(active2, /datum/data/record))
							var/new_value = copytext(trim(strip_html(input("Please summarize major dis.:", "Med. records", active2.fields["ma_dis_d"], null)  as message)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || active2 != a2))
								return
							active2.fields["ma_dis_d"] = new_value
							msg_admin_niche("[key_name_admin(usr)] set the medical record major disabilities desc for [active1.fields["name"]] ([active1.fields["id"]]) to [new_value].")
					if("alg")
						if (istype(active2, /datum/data/record))
							var/new_value = copytext(trim(strip_html(input("Please state allergies:", "Med. records", active2.fields["alg"], null)  as text)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || active2 != a2))
								return
							active2.fields["alg"] = new_value
							msg_admin_niche("[key_name_admin(usr)] set the medical record allergies list for [active1.fields["name"]] ([active1.fields["id"]]) to [new_value].")
					if("alg_d")
						if (istype(active2, /datum/data/record))
							var/new_value = copytext(trim(strip_html(input("Please summarize allergies:", "Med. records", active2.fields["alg_d"], null)  as message)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || active2 != a2))
								return
							active2.fields["alg_d"] = new_value
							msg_admin_niche("[key_name_admin(usr)] set the medical record allergies desc for [active1.fields["name"]] ([active1.fields["id"]]) to [new_value].")
					if("cdi")
						if (istype(active2, /datum/data/record))
							var/new_value = copytext(trim(strip_html(input("Please state diseases:", "Med. records", active2.fields["cdi"], null)  as text)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || active2 != a2))
								return
							active2.fields["cdi"] = new_value
							msg_admin_niche("[key_name_admin(usr)] set the medical record disabilities list for [active1.fields["name"]] ([active1.fields["id"]]) to [new_value].")
					if("cdi_d")
						if (istype(active2, /datum/data/record))
							var/new_value = copytext(trim(strip_html(input("Please summarize diseases:", "Med. records", active2.fields["cdi_d"], null)  as message)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || active2 != a2))
								return
							active2.fields["cdi_d"] = new_value
							msg_admin_niche("[key_name_admin(usr)] set the medical record disabilities desc for [active1.fields["name"]] ([active1.fields["id"]]) to [new_value].")
					if("notes")
						if (istype(active2, /datum/data/record))
							var/new_value = copytext(html_encode(trim(input("Please summarize notes:", "Med. records", html_decode(active2.fields["notes"]), null)  as message)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || active2 != a2))
								return
							active2.fields["notes"] = new_value
							msg_admin_niche("[key_name_admin(usr)] set the medical record notes for [active1.fields["name"]] ([active1.fields["id"]]) to [new_value].")
					if("p_stat")
						if (istype(active1, /datum/data/record))
							temp = text("<B>Physical Condition:</B><BR>\n\t<A href='byond://?src=\ref[];temp=1;p_stat=deceased'>*Deceased*</A><BR>\n\t<A href='byond://?src=\ref[];temp=1;p_stat=ssd'>*SSD*</A><BR>\n\t<A href='byond://?src=\ref[];temp=1;p_stat=active'>Active</A><BR>\n\t<A href='byond://?src=\ref[];temp=1;p_stat=unfit'>Physically Unfit</A><BR>\n\t<A href='byond://?src=\ref[];temp=1;p_stat=disabled'>Disabled</A><BR>", src, src, src, src, src)
					if("m_stat")
						if (istype(active1, /datum/data/record))
							temp = text("<B>Mental Condition:</B><BR>\n\t<A href='byond://?src=\ref[];temp=1;m_stat=insane'>*Insane*</A><BR>\n\t<A href='byond://?src=\ref[];temp=1;m_stat=unstable'>*Unstable*</A><BR>\n\t<A href='byond://?src=\ref[];temp=1;m_stat=watch'>*Watch*</A><BR>\n\t<A href='byond://?src=\ref[];temp=1;m_stat=stable'>Stable</A><BR>", src, src, src, src)
					if("b_type")
						if (istype(active2, /datum/data/record))
							temp = text("<B>Blood Type:</B><BR>\n\t<A href='byond://?src=\ref[];temp=1;b_type=an'>A-</A> <A href='byond://?src=\ref[];temp=1;b_type=ap'>A+</A><BR>\n\t<A href='byond://?src=\ref[];temp=1;b_type=bn'>B-</A> <A href='byond://?src=\ref[];temp=1;b_type=bp'>B+</A><BR>\n\t<A href='byond://?src=\ref[];temp=1;b_type=abn'>AB-</A> <A href='byond://?src=\ref[];temp=1;b_type=abp'>AB+</A><BR>\n\t<A href='byond://?src=\ref[];temp=1;b_type=on'>O-</A> <A href='byond://?src=\ref[];temp=1;b_type=op'>O+</A><BR>", src, src, src, src, src, src, src, src)


			if (href_list["p_stat"])
				if(istype(active1, /datum/data/record))
					switch(href_list["p_stat"])
						if("deceased")
							active1.fields["p_stat"] = "*Deceased*"
						if("ssd")
							active1.fields["p_stat"] = "*SSD*"
						if("active")
							active1.fields["p_stat"] = "Active"
						if("unfit")
							active1.fields["p_stat"] = "Physically Unfit"
						if("disabled")
							active1.fields["p_stat"] = "Disabled"
					msg_admin_niche("[key_name_admin(usr)] set the medical record physical state for [active1.fields["name"]] ([active1.fields["id"]]) to [href_list["p_stat"]].")

			if (href_list["m_stat"])
				if(istype(active1, /datum/data/record))
					switch(href_list["m_stat"])
						if("insane")
							active1.fields["m_stat"] = "*Insane*"
						if("unstable")
							active1.fields["m_stat"] = "*Unstable*"
						if("watch")
							active1.fields["m_stat"] = "*Watch*"
						if("stable")
							active1.fields["m_stat"] = "Stable"
					msg_admin_niche("[key_name_admin(usr)] set the medical record mental state for [active1.fields["name"]] ([active1.fields["id"]]) to [href_list["m_stat"]].")

			if (href_list["b_type"])
				if(istype(active2, /datum/data/record))
					switch(href_list["b_type"])
						if("an")
							active2.fields["b_type"] = "A-"
						if("bn")
							active2.fields["b_type"] = "B-"
						if("abn")
							active2.fields["b_type"] = "AB-"
						if("on")
							active2.fields["b_type"] = "O-"
						if("ap")
							active2.fields["b_type"] = "A+"
						if("bp")
							active2.fields["b_type"] = "B+"
						if("abp")
							active2.fields["b_type"] = "AB+"
						if("op")
							active2.fields["b_type"] = "O+"
					msg_admin_niche("[key_name_admin(usr)] set the medical record blood type for [active1.fields["name"]] ([active1.fields["id"]]) to [active2.fields["b_type"]].")

			if (href_list["del_r"])
				if(istype(active2, /datum/data/record))
					temp = text("Are you sure you wish to delete the record (Medical Portion Only)?<br>\n\t<A href='byond://?src=\ref[];temp=1;del_r2=1'>Yes</A><br>\n\t<A href='byond://?src=\ref[];temp=1'>No</A><br>", src, src)

			if (href_list["del_r2"])
				msg_admin_niche("[key_name_admin(usr)] deleted the medical record for [active1.fields["name"]] ([active1.fields["id"]]).")
				QDEL_NULL(active2)

			if (href_list["d_rec"])
				var/datum/data/record/R = locate(href_list["d_rec"])
				var/datum/data/record/M = locate(href_list["d_rec"])
				if (!( GLOB.data_core.general.Find(R) ))
					src.temp = "Record Not Found!"
					return
				for(var/datum/data/record/E in GLOB.data_core.medical)
					if ((E.fields["ref"] == R.fields["ref"] || E.fields["id"] == R.fields["id"]))
						M = E
				src.active1 = R
				src.active2 = M
				src.screen = 4

			if (href_list["new"])
				if ((istype(src.active1, /datum/data/record) && !( istype(src.active2, /datum/data/record) )))
					var/datum/data/record/R = new /datum/data/record(  )
					R.fields["name"] = src.active1.fields["name"]
					R.fields["id"] = src.active1.fields["id"]
					R.name = text("Medical Record #[]", R.fields["id"])
					R.fields["b_type"] = "Unknown"
					R.fields["mi_dis"] = "None"
					R.fields["mi_dis_d"] = "No minor disabilities have been declared."
					R.fields["ma_dis"] = "None"
					R.fields["ma_dis_d"] = "No major disabilities have been diagnosed."
					R.fields["alg"] = "None"
					R.fields["alg_d"] = "No allergies have been detected in this patient."
					R.fields["cdi"] = "None"
					R.fields["cdi_d"] = "No diseases have been diagnosed at the moment."
					R.fields["notes"] = "No notes."
					GLOB.data_core.medical += R
					src.active2 = R
					src.screen = 4

			if (href_list["add_c"])
				if (!( istype(active2, /datum/data/record) ))
					return
				var/a2 = active2
				var/new_value = copytext(trim(strip_html(input("Add Comment:", "Med. records", null, null)  as message)),1,MAX_MESSAGE_LEN)
				if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || active2 != a2))
					return
				var/counter = 1
				while(active2.fields[text("com_[]", counter)])
					counter++
				active2.fields[text("com_[counter]")] = text("Made by [authenticated] ([rank]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [GLOB.game_year]<BR>[new_value]")
				msg_admin_niche("[key_name_admin(usr)] added a medical comment for [active1.fields["name"]] ([active1.fields["id"]]): [new_value].")

			if (href_list["del_c"])
				if ((istype(active2, /datum/data/record) && active2.fields[text("com_[]", href_list["del_c"])]))
					msg_admin_niche("[key_name_admin(usr)] deleted a medical comment for [active1.fields["name"]] ([active1.fields["id"]]): [active2.fields[text("com_[]", href_list["del_c"])]].")
					active2.fields[text("com_[]", href_list["del_c"])] = text("Deleted entry by [authenticated] ([rank]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [GLOB.game_year]")

			if (href_list["search"])
				var/t1 = stripped_input(usr, "Search String: (Name, DNA, or ID)", "Med. records")
				if ((!( t1 ) || usr.stat || !( src.authenticated ) || usr.is_mob_restrained() || ((!in_range(src, usr)) && (!isRemoteControlling(usr)))))
					return
				src.active1 = null
				src.active2 = null
				t1 = lowertext(t1)
				for(var/datum/data/record/R as anything in GLOB.data_core.medical)
					if ((lowertext(R.fields["name"]) == t1 || t1 == lowertext(R.fields["id"])))
						src.active2 = R
				if (!active2)
					temp = "Could not locate record [t1]."
				else
					for(var/datum/data/record/E in GLOB.data_core.general)
						if ((E.fields["name"] == src.active2.fields["name"] || E.fields["id"] == src.active2.fields["id"]))
							src.active1 = E
					src.screen = 4

			if (href_list["print_p"])
				if (!( src.printing ))
					src.printing = 1
					var/datum/data/record/record1 = null
					var/datum/data/record/record2 = null
					if ((istype(src.active1, /datum/data/record) && GLOB.data_core.general.Find(src.active1)))
						record1 = active1
					if ((istype(src.active2, /datum/data/record) && GLOB.data_core.medical.Find(src.active2)))
						record2 = active2
					playsound(src.loc, 'sound/machines/fax.ogg', 15, 1)
					sleep(40)
					var/obj/item/paper/P = new /obj/item/paper( src.loc )
					P.info = "<CENTER><B>Medical Record</B></CENTER><BR>"
					if (record1)
						P.info += text("Name: [] <BR>\nID: []<BR>\nSex: []<BR>\nAge: []<BR>\nPhysical Status: []<BR>\nMental Status: []<BR>", record1.fields["name"], record1.fields["id"], record1.fields["sex"], record1.fields["age"], record1.fields["p_stat"], record1.fields["m_stat"])
						P.name = text("Medical Record ([])", record1.fields["name"])
					else
						P.info += "<B>General Record Lost!</B><BR>"
						P.name = "Medical Record"
					if (record2)
						P.info += "<BR>\n<CENTER><B>Medical Data</B></CENTER><BR>\nBlood Type: [record2.fields["b_type"]]<BR>\n<BR>\nMinor Disabilities: [record2.fields["mi_dis"]]<BR>\nDetails: [record2.fields["mi_dis_d"]]<BR>\n<BR>\nMajor Disabilities: [record2.fields["ma_dis"]]<BR>\nDetails: [record2.fields["ma_dis_d"]]<BR>\n<BR>\nAllergies: [record2.fields["alg"]]<BR>\nDetails: [record2.fields["alg_d"]]<BR>\n<BR>\nCurrent Diseases: [record2.fields["cdi"]] (per disease info placed in log/comment section)<BR>\nDetails: [record2.fields["cdi_d"]]<BR>\n<BR>\nImportant Notes:<BR>\n\t[decode(record2.fields["notes"])]<BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>"
						var/counter = 1
						while(record2.fields[text("com_[]", counter)])
							P.info += text("[]<BR>", record2.fields[text("com_[]", counter)])
							counter++
					else
						P.info += "<B>Medical Record Lost!</B><BR>"
					P.info += "</TT>"
					P.info += text("<BR><HR><font size = \"1\"><I>This report was printed by [] [].<BR>The [MAIN_SHIP_NAME],[]/[], []</I></font><BR>\n<span class=\"paper_field\"></span>",rank,authenticated,time2text(world.timeofday, "MM/DD"),GLOB.game_year,worldtime2text())
					src.printing = null

			if(href_list["print_bs"])//Prints latest body scan
				if(!(src.printing))
					src.printing = 1
					var/datum/data/record/record
					if ((istype(src.active1, /datum/data/record) && GLOB.data_core.general.Find(src.active1)))
						record = active1
					if(!record)
						return
					playsound(src.loc, 'sound/machines/fax.ogg', 15, 1)
					sleep(40)
					var/datum/asset/asset = get_asset_datum(/datum/asset/simple/paper)
					var/obj/item/paper/P = new /obj/item/paper( src.loc )
					P.name = text("Scan: [], []",record.fields["name"],worldtime2text())
					P.info += text("<center><img src = [asset.get_url_mappings()["logo_wy.png"]]><HR><I><B>Official Weyland-Yutani Document</B><BR>Scan Record</I><HR><H2>[]</H2>\n</center>",record.fields["name"])
					for(var/datum/data/record/R as anything in GLOB.data_core.medical)
						if (R.fields["name"] ==  record.fields["name"])
							if(R.fields["last_scan_time"] && R.fields["last_scan_result"])
								P.info += R.fields["last_scan_result"]
								break
							else
								P.info += "No scan on record."
					P.info += text("<BR><HR><font size = \"1\"><I>This report was printed by [] [].<BR>The [MAIN_SHIP_NAME],  []/[], []</I></font><BR>\n<span class=\"paper_field\"></span>",rank,authenticated,time2text(world.timeofday, "MM/DD"),GLOB.game_year,worldtime2text())
					src.printing = null



	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

/obj/structure/machinery/computer/med_data/emp_act(severity)
	. = ..()
	if(inoperable())
		return

	for(var/datum/data/record/R as anything in GLOB.data_core.medical)
		if(prob(10/severity))
			switch(rand(1,6))
				if(1)
					msg_admin_niche("The medical record name of [R.fields["name"]] was scrambled!")
					R.fields["name"] = "[pick(pick(GLOB.first_names_male), pick(GLOB.first_names_female))] [pick(GLOB.last_names)]"
				if(2)
					R.fields["sex"] = pick("Male", "Female")
					msg_admin_niche("The medical record sex of [R.fields["name"]] was scrambled!")
				if(3)
					R.fields["age"] = rand(5, 85)
					msg_admin_niche("The medical record age of [R.fields["name"]] was scrambled!")
				if(4)
					R.fields["b_type"] = pick("A-", "B-", "AB-", "O-", "A+", "B+", "AB+", "O+")
					msg_admin_niche("The medical record blood type of [R.fields["name"]] was scrambled!")
				if(5)
					R.fields["p_stat"] = pick("*SSD*", "Active", "Physically Unfit", "Disabled")
					msg_admin_niche("The medical record physical state of [R.fields["name"]] was scrambled!")
				if(6)
					R.fields["m_stat"] = pick("*Insane*", "*Unstable*", "*Watch*", "Stable")
					msg_admin_niche("The medical record mental state of [R.fields["name"]] was scrambled!")
			continue

		else if(prob(1))
			msg_admin_niche("The medical record of [R.fields["name"]] was lost!")
			GLOB.data_core.medical -= R
			qdel(R)
			continue


/obj/structure/machinery/computer/med_data/laptop
	name = "Medical Laptop"
	desc = "Cheap Weyland-Yutani Laptop."
	icon_state = "medlaptop"
	density = FALSE
