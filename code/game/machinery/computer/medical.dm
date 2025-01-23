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
	var/datum/data/record/selected_general = null
	var/datum/data/record/selected_medical = null
	var/a_id = null
	var/temp = null
	var/printing = null

/obj/structure/machinery/computer/med_data/verb/eject_id()
	set category = "Object"
	set name = "Eject ID Card"
	set src in oview(1)

	if(!usr || usr.is_mob_incapacitated()) return

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
					if ((istype(selected_general, /datum/data/record) && GLOB.data_core.general.Find(selected_general)))
						dat += "<CENTER><B>Medical Record</B></CENTER><BR>"
						dat += "<table><tr><td>Name: [selected_general.fields["name"]] \
								ID: [selected_general.fields["id"]]<BR>\n \
								Sex: <A href='byond://?src=\ref[src];field=sex'>[selected_general.fields["sex"]]</A><BR>\n \
								Age: <A href='byond://?src=\ref[src];field=age'>[selected_general.fields["age"]]</A><BR>\n \
								Physical Status: <A href='byond://?src=\ref[src];field=p_stat'>[selected_general.fields["p_stat"]]</A><BR>\n \
								Mental Status: <A href='byond://?src=\ref[src];field=m_stat'>[selected_general.fields["m_stat"]]</A><BR></td><td align = center valign = top> \
								Photo:<br><img src=front.png height=64 width=64 border=5><img src=side.png height=64 width=64 border=5></td></tr></table>"
					else
						dat += "<B>General Record Lost!</B><BR>"
					if ((istype(src.selected_medical, /datum/data/record) && GLOB.data_core.medical.Find(src.selected_medical)))
						dat += "<BR>\n<CENTER><B>Medical Data</B></CENTER><BR>\nBlood Type: <A href='byond://?src=\ref[src];field=b_type'>[selected_medical.fields["b_type"]]</A><BR>\n<BR>\nMinor Disabilities: <A href='byond://?src=\ref[src];field=mi_dis'>[selected_medical.fields["mi_dis"]]</A><BR>\nDetails: <A href='byond://?src=\ref[src];field=mi_dis_d'>[selected_medical.fields["mi_dis_d"]]</A><BR>\n<BR>\nMajor Disabilities: <A href='byond://?src=\ref[src];field=ma_dis'>[selected_medical.fields["ma_dis"]]</A><BR>\nDetails: <A href='byond://?src=\ref[src];field=ma_dis_d'>[selected_medical.fields["ma_dis_d"]]</A><BR>\n<BR>\nAllergies: <A href='byond://?src=\ref[src];field=alg'>[selected_medical.fields["alg"]]</A><BR>\nDetails: <A href='byond://?src=\ref[src];field=alg_d'>[selected_medical.fields["alg_d"]]</A><BR>\n<BR>\nCurrent Diseases: <A href='byond://?src=\ref[src];field=cdi'>[selected_medical.fields["cdi"]]</A> (per disease info placed in log/comment section)<BR>\nDetails: <A href='byond://?src=\ref[src];field=cdi_d'>[selected_medical.fields["cdi_d"]]</A><BR>\n<BR>\nImportant Notes:<BR>\n\t<A href='byond://?src=\ref[src];field=notes'>[decode(src.selected_medical.fields["notes"])]</A><BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>"
						var/counter = 1
						while(selected_medical.fields[text("com_[]", counter)])
							var/current_index = text("com_[]", counter)
							if(findtext(selected_medical.fields[current_index], "<BR>"))
								dat += text("[]<BR><A href='byond://?src=\ref[];del_c=[]'>Delete Entry</A><BR><BR>", selected_medical.fields[current_index], src, counter)
							else
								dat += text("[]<BR><BR>", selected_medical.fields[current_index])
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

						if(M.z != src.z) continue //only find medibots on the same z-level as the computer
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

	if (!( GLOB.data_core.general.Find(src.selected_general) ))
		src.selected_general = null

	if (!( GLOB.data_core.medical.Find(src.selected_medical) ))
		src.selected_medical = null

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
			src.selected_general = null
			src.selected_medical = null

		else if (href_list["login"])

			if (isRemoteControlling(usr))
				src.selected_general = null
				src.selected_medical = null
				src.authenticated = usr.name
				src.rank = "AI"
				src.screen = 1

			else if (istype(src.scan, /obj/item/card/id))
				src.selected_general = null
				src.selected_medical = null

				if (src.check_access(src.scan))
					src.authenticated = src.scan.registered_name
					src.rank = src.scan.assignment
					src.screen = 1

		if (src.authenticated)

			if(href_list["screen"])
				src.screen = text2num(href_list["screen"])
				if(src.screen < 1)
					src.screen = 1

				src.selected_general = null
				src.selected_medical = null

			if (href_list["del_all"])
				src.temp = text("Are you sure you wish to delete all records?<br>\n\t<A href='byond://?src=\ref[];temp=1;del_all2=1'>Yes</A><br>\n\t<A href='byond://?src=\ref[];temp=1'>No</A><br>", src, src)

			if (href_list["del_all2"])
				GLOB.data_core.manifest_delete_all_medical()
				temp = "All records deleted."

			if (href_list["field"])
				var/a1 = selected_general
				var/a2 = selected_medical
				switch(href_list["field"])
					if("sex")
						if (istype(selected_general, /datum/data/record))
							var/new_value = "Male"
							if (selected_general.fields["sex"] == "Male")
								new_value = "Female"
							selected_general.fields["sex"] = new_value
							GLOB.data_core.manifest_updated_general_record(selected_general)
							msg_admin_niche("[key_name_admin(usr)] set the medical record sex for [selected_general.fields["name"]] ([selected_general.fields["id"]]) to [new_value].")
					if("age")
						if (istype(selected_general, /datum/data/record))
							var/new_value = input("Please input age:", "Med. records", selected_general.fields["age"], null)  as num
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || selected_general != a1))
								return
							selected_general.fields["age"] = new_value
							GLOB.data_core.manifest_updated_general_record(selected_general)
							msg_admin_niche("[key_name_admin(usr)] set the medical record age for [selected_general.fields["name"]] ([selected_general.fields["id"]]) to [new_value].")
					if("mi_dis")
						if (istype(selected_medical, /datum/data/record))
							var/new_value = copytext(trim(strip_html(input("Please input minor disabilities list:", "Med. records", selected_medical.fields["mi_dis"], null)  as text)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || selected_medical != a2))
								return
							selected_medical.fields["mi_dis"] = new_value
							GLOB.data_core.manifest_updated_medical_record(selected_medical)
							msg_admin_niche("[key_name_admin(usr)] set the medical record minor disabilities list for [selected_general.fields["name"]] ([selected_general.fields["id"]]) to [new_value].")
					if("mi_dis_d")
						if (istype(selected_medical, /datum/data/record))
							var/new_value = copytext(trim(strip_html(input("Please summarize minor dis.:", "Med. records", selected_medical.fields["mi_dis_d"], null)  as message)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || selected_medical != a2))
								return
							selected_medical.fields["mi_dis_d"] = new_value
							GLOB.data_core.manifest_updated_medical_record(selected_medical)
							msg_admin_niche("[key_name_admin(usr)] set the medical record minor disabilities desc for [selected_general.fields["name"]] ([selected_general.fields["id"]]) to [new_value].")
					if("ma_dis")
						if (istype(selected_medical, /datum/data/record))
							var/new_value = copytext(trim(strip_html(input("Please input major diabilities list:", "Med. records", selected_medical.fields["ma_dis"], null)  as text)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || selected_medical != a2))
								return
							selected_medical.fields["ma_dis"] = new_value
							GLOB.data_core.manifest_updated_medical_record(selected_medical)
							msg_admin_niche("[key_name_admin(usr)] set the medical record major disabilities list for [selected_general.fields["name"]] ([selected_general.fields["id"]]) to [new_value].")
					if("ma_dis_d")
						if (istype(selected_medical, /datum/data/record))
							var/new_value = copytext(trim(strip_html(input("Please summarize major dis.:", "Med. records", selected_medical.fields["ma_dis_d"], null)  as message)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || selected_medical != a2))
								return
							selected_medical.fields["ma_dis_d"] = new_value
							GLOB.data_core.manifest_updated_medical_record(selected_medical)
							msg_admin_niche("[key_name_admin(usr)] set the medical record major disabilities desc for [selected_general.fields["name"]] ([selected_general.fields["id"]]) to [new_value].")
					if("alg")
						if (istype(selected_medical, /datum/data/record))
							var/new_value = copytext(trim(strip_html(input("Please state allergies:", "Med. records", selected_medical.fields["alg"], null)  as text)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || selected_medical != a2))
								return
							selected_medical.fields["alg"] = new_value
							GLOB.data_core.manifest_updated_medical_record(selected_medical)
							msg_admin_niche("[key_name_admin(usr)] set the medical record allergies list for [selected_general.fields["name"]] ([selected_general.fields["id"]]) to [new_value].")
					if("alg_d")
						if (istype(selected_medical, /datum/data/record))
							var/new_value = copytext(trim(strip_html(input("Please summarize allergies:", "Med. records", selected_medical.fields["alg_d"], null)  as message)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || selected_medical != a2))
								return
							selected_medical.fields["alg_d"] = new_value
							GLOB.data_core.manifest_updated_medical_record(selected_medical)
							msg_admin_niche("[key_name_admin(usr)] set the medical record allergies desc for [selected_general.fields["name"]] ([selected_general.fields["id"]]) to [new_value].")
					if("cdi")
						if (istype(selected_medical, /datum/data/record))
							var/new_value = copytext(trim(strip_html(input("Please state diseases:", "Med. records", selected_medical.fields["cdi"], null)  as text)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || selected_medical != a2))
								return
							selected_medical.fields["cdi"] = new_value
							GLOB.data_core.manifest_updated_medical_record(selected_medical)
							msg_admin_niche("[key_name_admin(usr)] set the medical record disabilities list for [selected_general.fields["name"]] ([selected_general.fields["id"]]) to [new_value].")
					if("cdi_d")
						if (istype(selected_medical, /datum/data/record))
							var/new_value = copytext(trim(strip_html(input("Please summarize diseases:", "Med. records", selected_medical.fields["cdi_d"], null)  as message)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || selected_medical != a2))
								return
							selected_medical.fields["cdi_d"] = new_value
							GLOB.data_core.manifest_updated_medical_record(selected_medical)
							msg_admin_niche("[key_name_admin(usr)] set the medical record disabilities desc for [selected_general.fields["name"]] ([selected_general.fields["id"]]) to [new_value].")
					if("notes")
						if (istype(selected_medical, /datum/data/record))
							var/new_value = copytext(html_encode(trim(input("Please summarize notes:", "Med. records", html_decode(selected_medical.fields["notes"]), null)  as message)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || selected_medical != a2))
								return
							selected_medical.fields["notes"] = new_value
							GLOB.data_core.manifest_updated_medical_record(selected_medical)
							msg_admin_niche("[key_name_admin(usr)] set the medical record notes for [selected_general.fields["name"]] ([selected_general.fields["id"]]) to [new_value].")
					if("p_stat")
						if (istype(selected_general, /datum/data/record))
							temp = text("<B>Physical Condition:</B><BR>\n\t<A href='byond://?src=\ref[];temp=1;p_stat=deceased'>*Deceased*</A><BR>\n\t<A href='byond://?src=\ref[];temp=1;p_stat=ssd'>*SSD*</A><BR>\n\t<A href='byond://?src=\ref[];temp=1;p_stat=active'>Active</A><BR>\n\t<A href='byond://?src=\ref[];temp=1;p_stat=unfit'>Physically Unfit</A><BR>\n\t<A href='byond://?src=\ref[];temp=1;p_stat=disabled'>Disabled</A><BR>", src, src, src, src, src)
					if("m_stat")
						if (istype(selected_general, /datum/data/record))
							temp = text("<B>Mental Condition:</B><BR>\n\t<A href='byond://?src=\ref[];temp=1;m_stat=insane'>*Insane*</A><BR>\n\t<A href='byond://?src=\ref[];temp=1;m_stat=unstable'>*Unstable*</A><BR>\n\t<A href='byond://?src=\ref[];temp=1;m_stat=watch'>*Watch*</A><BR>\n\t<A href='byond://?src=\ref[];temp=1;m_stat=stable'>Stable</A><BR>", src, src, src, src)
					if("b_type")
						if (istype(selected_medical, /datum/data/record))
							temp = text("<B>Blood Type:</B><BR>\n\t<A href='byond://?src=\ref[];temp=1;b_type=an'>A-</A> <A href='byond://?src=\ref[];temp=1;b_type=ap'>A+</A><BR>\n\t<A href='byond://?src=\ref[];temp=1;b_type=bn'>B-</A> <A href='byond://?src=\ref[];temp=1;b_type=bp'>B+</A><BR>\n\t<A href='byond://?src=\ref[];temp=1;b_type=abn'>AB-</A> <A href='byond://?src=\ref[];temp=1;b_type=abp'>AB+</A><BR>\n\t<A href='byond://?src=\ref[];temp=1;b_type=on'>O-</A> <A href='byond://?src=\ref[];temp=1;b_type=op'>O+</A><BR>", src, src, src, src, src, src, src, src)


			if (href_list["p_stat"])
				if(istype(selected_general, /datum/data/record))
					switch(href_list["p_stat"])
						if("deceased")
							selected_general.fields["p_stat"] = "*Deceased*"
						if("ssd")
							selected_general.fields["p_stat"] = "*SSD*"
						if("active")
							selected_general.fields["p_stat"] = "Active"
						if("unfit")
							selected_general.fields["p_stat"] = "Physically Unfit"
						if("disabled")
							selected_general.fields["p_stat"] = "Disabled"
					GLOB.data_core.manifest_updated_general_record(selected_general)
					msg_admin_niche("[key_name_admin(usr)] set the medical record physical state for [selected_general.fields["name"]] ([selected_general.fields["id"]]) to [href_list["p_stat"]].")

			if (href_list["m_stat"])
				if(istype(selected_general, /datum/data/record))
					switch(href_list["m_stat"])
						if("insane")
							selected_general.fields["m_stat"] = "*Insane*"
						if("unstable")
							selected_general.fields["m_stat"] = "*Unstable*"
						if("watch")
							selected_general.fields["m_stat"] = "*Watch*"
						if("stable")
							selected_general.fields["m_stat"] = "Stable"
					GLOB.data_core.manifest_updated_general_record(selected_general)
					msg_admin_niche("[key_name_admin(usr)] set the medical record mental state for [selected_general.fields["name"]] ([selected_general.fields["id"]]) to [href_list["m_stat"]].")

			if (href_list["b_type"])
				if(istype(selected_medical, /datum/data/record))
					switch(href_list["b_type"])
						if("an")
							selected_medical.fields["b_type"] = "A-"
						if("bn")
							selected_medical.fields["b_type"] = "B-"
						if("abn")
							selected_medical.fields["b_type"] = "AB-"
						if("on")
							selected_medical.fields["b_type"] = "O-"
						if("ap")
							selected_medical.fields["b_type"] = "A+"
						if("bp")
							selected_medical.fields["b_type"] = "B+"
						if("abp")
							selected_medical.fields["b_type"] = "AB+"
						if("op")
							selected_medical.fields["b_type"] = "O+"
					GLOB.data_core.manifest_updated_medical_record(selected_medical)
					msg_admin_niche("[key_name_admin(usr)] set the medical record blood type for [selected_general.fields["name"]] ([selected_general.fields["id"]]) to [selected_medical.fields["b_type"]].")

			if (href_list["del_r"])
				if(istype(selected_medical, /datum/data/record))
					temp = text("Are you sure you wish to delete the record (Medical Portion Only)?<br>\n\t<A href='byond://?src=\ref[];temp=1;del_r2=1'>Yes</A><br>\n\t<A href='byond://?src=\ref[];temp=1'>No</A><br>", src, src)

			if (href_list["del_r2"])
				msg_admin_niche("[key_name_admin(usr)] deleted the medical record for [selected_general.fields["name"]] ([selected_general.fields["id"]]).")
				QDEL_NULL(selected_medical)

			if (href_list["d_rec"])
				var/datum/data/record/R = locate(href_list["d_rec"])
				var/datum/data/record/M = locate(href_list["d_rec"])
				if (!( GLOB.data_core.general.Find(R) ))
					src.temp = "Record Not Found!"
					return
				for(var/datum/data/record/E in GLOB.data_core.medical)
					if ((E.fields["ref"] == R.fields["ref"] || E.fields["id"] == R.fields["id"]))
						M = E
				src.selected_general = R
				src.selected_medical = M
				src.screen = 4

			if (href_list["new"])
				if ((istype(src.selected_general, /datum/data/record) && !( istype(src.selected_medical, /datum/data/record) )))
					var/datum/data/record/R = new /datum/data/record(  )
					R.fields["name"] = src.selected_general.fields["name"]
					R.fields["id"] = src.selected_general.fields["id"]
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
					GLOB.data_core.manifest_inject_medical_record(R)
					src.selected_medical = R
					src.screen = 4

			if (href_list["add_c"])
				if (!( istype(selected_medical, /datum/data/record) ))
					return
				var/a2 = selected_medical
				var/new_value = copytext(trim(strip_html(input("Add Comment:", "Med. records", null, null)  as message)),1,MAX_MESSAGE_LEN)
				if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || selected_medical != a2))
					return
				var/counter = 1
				while(selected_medical.fields[text("com_[]", counter)])
					counter++
				selected_medical.fields[text("com_[counter]")] = text("Made by [authenticated] ([rank]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [GLOB.game_year]<BR>[new_value]")
				GLOB.data_core.manifest_updated_medical_record(selected_medical)
				msg_admin_niche("[key_name_admin(usr)] added a medical comment for [selected_general.fields["name"]] ([selected_general.fields["id"]]): [new_value].")

			if (href_list["del_c"])
				if ((istype(selected_medical, /datum/data/record) && selected_medical.fields[text("com_[]", href_list["del_c"])]))
					selected_medical.fields[text("com_[]", href_list["del_c"])] = text("Deleted entry by [authenticated] ([rank]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [GLOB.game_year]")
					GLOB.data_core.manifest_updated_medical_record(selected_medical)
					msg_admin_niche("[key_name_admin(usr)] deleted a medical comment for [selected_general.fields["name"]] ([selected_general.fields["id"]]): [selected_medical.fields[text("com_[]", href_list["del_c"])]].")

			if (href_list["search"])
				var/t1 = stripped_input(usr, "Search String: (Name, DNA, or ID)", "Med. records")
				if ((!( t1 ) || usr.stat || !( src.authenticated ) || usr.is_mob_restrained() || ((!in_range(src, usr)) && (!isRemoteControlling(usr)))))
					return
				src.selected_general = null
				src.selected_medical = null
				t1 = lowertext(t1)
				for(var/datum/data/record/R as anything in GLOB.data_core.medical)
					if ((lowertext(R.fields["name"]) == t1 || t1 == lowertext(R.fields["id"])))
						src.selected_medical = R
				if (!selected_medical)
					temp = "Could not locate record [t1]."
				else
					for(var/datum/data/record/E in GLOB.data_core.general)
						if ((E.fields["name"] == src.selected_medical.fields["name"] || E.fields["id"] == src.selected_medical.fields["id"]))
							src.selected_general = E
					src.screen = 4

			if (href_list["print_p"])
				if (!( src.printing ))
					src.printing = 1
					var/datum/data/record/record1 = null
					var/datum/data/record/record2 = null
					if ((istype(src.selected_general, /datum/data/record) && GLOB.data_core.general.Find(src.selected_general)))
						record1 = selected_general
					if ((istype(src.selected_medical, /datum/data/record) && GLOB.data_core.medical.Find(src.selected_medical)))
						record2 = selected_medical
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
					if ((istype(src.selected_general, /datum/data/record) && GLOB.data_core.general.Find(src.selected_general)))
						record = selected_general
					if(!record) return
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

	GLOB.data_core.manifest_medical_emp_act(severity)


/obj/structure/machinery/computer/med_data/laptop
	name = "Medical Laptop"
	desc = "Cheap Weyland-Yutani Laptop."
	icon_state = "medlaptop"
	density = FALSE
