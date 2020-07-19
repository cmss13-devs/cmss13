//this machine does nothing
/obj/structure/machinery/disease2/diseaseanalyser
	name = "Disease Analyser"
	icon = 'icons/obj/structures/machinery/virology.dmi'
	icon_state = "analyser"
	anchored = 1
	density = 1


/obj/structure/machinery/computer/pandemic
	name = "PanD.E.M.I.C 2200"
	density = 1
	anchored = 1
	icon = 'icons/obj/structures/machinery/science_machines.dmi'
	icon_state = "mixer0"
	layer = BELOW_OBJ_LAYER
	circuit = /obj/item/circuitboard/computer/pandemic
	var/temphtml = ""
	var/wait = null
	var/obj/item/reagent_container/glass/beaker = null
	var/list/discovered_diseases = list()


/obj/structure/machinery/computer/pandemic/update_icon()
	if(stat & BROKEN)
		icon_state = (beaker?"mixer1_b":"mixer0_b")
	else if(stat & NOPOWER)
		icon_state = (beaker?"mixer1_nopower":"mixer0_nopower")
	else
		icon_state = (beaker?"mixer1":"mixer0")


/obj/structure/machinery/computer/pandemic/Topic(href, href_list)
	if(inoperable())
		return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	if(user.stat || user.is_mob_restrained())
		return
	if(!in_range(src, user))
		return

	user.set_interaction(src)
	if(!beaker)
		return

	if (href_list["create_vaccine"])
		if(!wait)
			var/path = href_list["create_vaccine"]
			var/vaccine_type = text2path(path)
			if(!(vaccine_type in discovered_diseases))
				return
			var/obj/item/reagent_container/glass/bottle/B = new/obj/item/reagent_container/glass/bottle(loc)
			if(B)
				var/datum/disease/D = null
				if(!vaccine_type)
					D = archive_diseases[path]
					vaccine_type = path
				else
					if(vaccine_type in diseases)
						D = new vaccine_type(0, null)

				if(D)
					B.name = "[D.name] vaccine bottle"
					B.reagents.add_reagent("vaccine",15,vaccine_type)
					wait = 1
					var/datum/reagent/blood/Blood = null
					for(var/datum/reagent/blood/L in beaker.reagents.reagent_list)
						if(L)
							Blood = L
							break
					var/list/res = Blood.data_properties["resistances"]
					spawn(res.len*200)
						wait = null
		else
			temphtml = "The replicator is not ready yet."
		updateUsrDialog()
		return
	else if(href_list["create_virus_culture"])
		if(!wait)
			var/virus_type = text2path(href_list["create_virus_culture"])//the path is received as string - converting
			if(!(virus_type in discovered_diseases))
				return
			var/obj/item/reagent_container/glass/bottle/B = new/obj/item/reagent_container/glass/bottle(src.loc)
			B.icon_state = "bottle3"
			var/datum/disease/D = null
			if(!virus_type)
				var/datum/disease/advance/A = archive_diseases[href_list["create_virus_culture"]]
				if(A)
					D = new A.type(0, A)
			else
				if(virus_type in diseases) // Make sure this is a disease
					D = new virus_type(0, null)
			var/list/data = list("viruses"=list(D))
			var/name = strip_html(input(user,"Name:","Name the culture",D.name))
			if(!name || name == " ") name = D.name
			B.name = "[name] culture bottle"
			B.desc = "A small bottle. Contains [D.agent] culture in synthblood medium."
			B.reagents.add_reagent("blood",20,data)
			updateUsrDialog()
			wait = 1
			spawn(1000)
				wait = null
		else
			temphtml = "The replicator is not ready yet."
		updateUsrDialog()
		return
	else if(href_list["empty_beaker"])
		beaker.reagents.clear_reagents()
		updateUsrDialog()
		return
	else if(href_list["eject"])
		beaker.forceMove(loc)
		beaker = null
		update_icon()
		updateUsrDialog()
		return
	else if(href_list["clear"])
		temphtml = ""
		updateUsrDialog()
		return
	else if(href_list["name_disease"])
		var/new_name = stripped_input(user, "Name the Disease", "New Name", "", MAX_NAME_LEN)
		if(inoperable()) return
		if(user.stat || user.is_mob_restrained()) return
		if(!in_range(src, user)) return
		var/id = href_list["name_disease"]
		if(archive_diseases[id])
			var/datum/disease/advance/A = archive_diseases[id]
			A.AssignName(new_name)
			for(var/datum/disease/advance/AD in active_diseases)
				AD.Refresh()
		updateUsrDialog()


	else
		close_browser(user, "pandemic")
		updateUsrDialog()
		return

	add_fingerprint(user)
	return

/obj/structure/machinery/computer/pandemic/attack_hand(mob/living/user)
	if(..())
		return
	user.set_interaction(src)
	var/dat = ""
	if(temphtml)
		dat = "[temphtml]<BR><BR><A href='?src=\ref[src];clear=1'>Main Menu</A>"
	else if(!beaker)
		dat += "Please insert beaker.<BR>"
		dat += "<A href='?src=\ref[user];mach_close=pandemic'>Close</A>"
	else
		var/datum/reagent/blood/Blood = null
		for(var/datum/reagent/blood/B in beaker.reagents.reagent_list)
			if(B)
				Blood = B
				break
		if(!beaker.reagents.total_volume||!beaker.reagents.reagent_list.len)
			dat += "The beaker is empty<BR>"
		else if(!Blood)
			dat += "No blood sample found in beaker"
		else if(!Blood.data_properties)
			dat += "No blood data found in beaker."
		else
			dat += "<h3>Blood sample data:</h3>"
			dat += "<b>Blood Type:</b> [(Blood.data_properties["blood_type"]||"none")]<BR>"

			if(Blood.data_properties["viruses"])
				var/list/vir = Blood.data_properties["viruses"]
				if(vir.len)
					for(var/datum/disease/D in Blood.data_properties["viruses"])
						if(!D.hidden[PANDEMIC])

							if(!(D.type in discovered_diseases))
								discovered_diseases += D.type

							var/disease_creation = D.type
							if(istype(D, /datum/disease/advance))

								var/datum/disease/advance/A = D
								D = archive_diseases[A.GetDiseaseID()]
								disease_creation = A.GetDiseaseID()
								if(D.name == "Unknown")
									dat += "<b><a href='?src=\ref[src];name_disease=[A.GetDiseaseID()]'>Name Disease</a></b><BR>"

							if(!D)
								CRASH("We weren't able to get the advance disease from the archive.")

							dat += "<b>Disease Agent:</b> [D?"[D.agent] - <A href='?src=\ref[src];create_virus_culture=[disease_creation]'>Create virus culture bottle</A>":"none"]<BR>"
							dat += "<b>Common name:</b> [(D.name||"none")]<BR>"
							dat += "<b>Description: </b> [(D.desc||"none")]<BR>"
							dat += "<b>Spread:</b> [(D.spread||"none")]<BR>"
							dat += "<b>Possible cure:</b> [(D.cure||"none")]<BR><BR>"

							if(istype(D, /datum/disease/advance))
								var/datum/disease/advance/A = D
								dat += "<b>Symptoms:</b> "
								var/english_symptoms = list()
								for(var/datum/symptom/S in A.symptoms)
									english_symptoms += S.name
								dat += english_list(english_symptoms)


			dat += "<BR><b>Contains antibodies to:</b> "
			if(Blood.data_properties["resistances"])
				var/list/res = Blood.data_properties["resistances"]
				if(res.len)
					dat += "<ul>"
					for(var/type in Blood.data_properties["resistances"])
						var/disease_name = "Unknown"

						if(!ispath(type))
							var/datum/disease/advance/A = archive_diseases[type]
							if(A)
								disease_name = A.name
						else
							if(!(type in discovered_diseases))
								discovered_diseases += type
							var/datum/disease/D = new type(0, null)
							disease_name = D.name

						dat += "<li>[disease_name] - <A href='?src=\ref[src];create_vaccine=[type]'>Create vaccine bottle</A></li>"
					dat += "</ul><BR>"
				else
					dat += "nothing<BR>"
			else
				dat += "nothing<BR>"
		dat += "<BR><A href='?src=\ref[src];eject=1'>Eject beaker</A>[((beaker.reagents.total_volume && beaker.reagents.reagent_list.len) ? "-- <A href='?src=\ref[src];empty_beaker=1'>Empty beaker</A>":"")]<BR>"
		dat += "<A href='?src=\ref[user];mach_close=pandemic'>Close</A>"

	show_browser(user, "<TITLE>[name]</TITLE><BR>[dat]", name, "pandemic")
	return


/obj/structure/machinery/computer/pandemic/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/reagent_container/glass))
		if(inoperable())
			return
		if(beaker)
			to_chat(user, SPAN_WARNING("A beaker is already loaded into the machine."))
			return

		beaker =  I
		user.drop_inv_item_to_loc(I, src)
		to_chat(user, SPAN_NOTICE("You add the beaker to the machine!"))
		updateUsrDialog()
		update_icon()

	else
		..()
	return