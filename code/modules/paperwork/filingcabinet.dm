/* Filing cabinets!
 * Contains:
 *		Filing Cabinets
 *		Security Record Cabinets
 *		Medical Record Cabinets
 */


/*
 * Filing Cabinets
 */
/obj/structure/filingcabinet
	name = "filing cabinet"
	desc = "A large cabinet with drawers."
	icon = 'icons/obj/structures/props/misc.dmi'
	icon_state = "filingcabinet"
	density = 1
	anchored = 1
	wrenchable = TRUE
	var/list/allowed_types = list(/obj/item/paper, /obj/item/folder,/obj/item/clipboard, /obj/item/photo, /obj/item/paper_bundle, /obj/item/document_objective/paper, /obj/item/document_objective/report, /obj/item/document_objective/folder, /obj/item/pamphlet)

/obj/structure/filingcabinet/Dispose()
	for(var/obj/item/W in contents)
		if(W.unacidable)
			W.forceMove(loc)
	..()

/obj/structure/filingcabinet/chestdrawer
	name = "chest drawer"
	icon_state = "chestdrawer"


/obj/structure/filingcabinet/filingcabinet	//not changing the path to avoid unecessary map issues, but please don't name stuff like this in the future -Pete
	icon_state = "tallcabinet"


/obj/structure/filingcabinet/Initialize()
	. = ..()
	for(var/obj/item/I in loc)
		for(var/allowed_type in allowed_types)
			if(istype(I, allowed_type))
				I.forceMove(src)


/obj/structure/filingcabinet/attackby(obj/item/P as obj, mob/user as mob)
	if(iswrench(P))
		..()
	else
		for(var/allowed_type in allowed_types)
			if(istype(P, allowed_type))
				to_chat(user, SPAN_NOTICE("You put [P] in [src]."))
				if(user.drop_inv_item_to_loc(P, src))
					icon_state = "[initial(icon_state)]-open"
					sleep(5)
					icon_state = initial(icon_state)
					updateUsrDialog()
					break
			else
				to_chat(user, SPAN_NOTICE("You can't put [P] in [src]!"))

/obj/structure/filingcabinet/attack_hand(mob/user as mob)
	if(contents.len <= 0)
		to_chat(user, SPAN_NOTICE("\The [src] is empty."))
		return

	user.set_interaction(src)
	var/dat = "<center><table>"
	for(var/obj/item/P in src)
		dat += "<tr><td><a href='?src=\ref[src];retrieve=\ref[P]'>[P.name]</a></td></tr>"
	dat += "</table></center>"
	show_browser(user, dat, name, "filingcabinet", "size=350x300")

	return

/obj/structure/filingcabinet/Topic(href, href_list)
	if(href_list["retrieve"])
		close_browser(usr, "filingcabinet") // Close the menu

		//var/retrieveindex = text2num(href_list["retrieve"])
		var/obj/item/P = locate(href_list["retrieve"])//contents[retrieveindex]
		if(istype(P) && (P.loc == src) && src.Adjacent(usr))
			usr.put_in_hands(P)
			updateUsrDialog()
			icon_state = "[initial(icon_state)]-open"
			spawn(0)
				sleep(5)
				icon_state = initial(icon_state)


/*
 * Security Record Cabinets
 */
/obj/structure/filingcabinet/security
	var/virgin = 1


/obj/structure/filingcabinet/security/proc/populate()
	if(virgin)
		for(var/datum/data/record/G in data_core.general)
			var/datum/data/record/S
			for(var/datum/data/record/R in data_core.security)
				if((R.fields["name"] == G.fields["name"] || R.fields["id"] == G.fields["id"]))
					S = R
					break
			if(S)
				var/obj/item/paper/P = new /obj/item/paper(src)
				P.info = "<CENTER><B>Security Record</B></CENTER><BR>"
				P.info += "Name: [G.fields["name"]] ID: [G.fields["id"]]<BR>\nSex: [G.fields["sex"]]<BR>\nAge: [G.fields["age"]]<BR>\nPhysical Status: [G.fields["p_stat"]]<BR>\nMental Status: [G.fields["m_stat"]]<BR>"
				P.info += "<BR>\n<CENTER><B>Security Data</B></CENTER><BR>\nCriminal Status: [S.fields["criminal"]]<BR>\n<BR>\nMinor Crimes: [S.fields["mi_crim"]]<BR>\nDetails: [S.fields["mi_crim_d"]]<BR>\n<BR>\nMajor Crimes: [S.fields["ma_crim"]]<BR>\nDetails: [S.fields["ma_crim_d"]]<BR>\n<BR>\nImportant Notes:<BR>\n\t[S.fields["notes"]]<BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>"
				var/counter = 1
				while(S.fields["com_[counter]"])
					P.info += "[S.fields["com_[counter]"]]<BR>"
					counter++
				P.info += "</TT>"
				P.name = "Security Record ([G.fields["name"]])"
			virgin = 0	//tabbing here is correct- it's possible for people to try and use it
						//before the records have been generated, so we do this inside the loop.
	..()

/obj/structure/filingcabinet/security/attack_hand()
	populate()
	..()

/*
 * Medical Record Cabinets
 */
/obj/structure/filingcabinet/medical
	var/virgin = 1

/obj/structure/filingcabinet/medical/proc/populate()
	if(virgin)
		for(var/datum/data/record/G in data_core.general)
			var/datum/data/record/M
			for(var/datum/data/record/R in data_core.medical)
				if((R.fields["name"] == G.fields["name"] || R.fields["id"] == G.fields["id"]))
					M = R
					break
			if(M)
				var/obj/item/paper/P = new /obj/item/paper(src)
				P.info = "<CENTER><B>Medical Record</B></CENTER><BR>"
				P.info += "Name: [G.fields["name"]] ID: [G.fields["id"]]<BR>\nSex: [G.fields["sex"]]<BR>\nAge: [G.fields["age"]]<BR>\nPhysical Status: [G.fields["p_stat"]]<BR>\nMental Status: [G.fields["m_stat"]]<BR>"

				P.info += "<BR>\n<CENTER><B>Medical Data</B></CENTER><BR>\nBlood Type: [M.fields["b_type"]]<BR>\n<BR>\nMinor Disabilities: [M.fields["mi_dis"]]<BR>\nDetails: [M.fields["mi_dis_d"]]<BR>\n<BR>\nMajor Disabilities: [M.fields["ma_dis"]]<BR>\nDetails: [M.fields["ma_dis_d"]]<BR>\n<BR>\nAllergies: [M.fields["alg"]]<BR>\nDetails: [M.fields["alg_d"]]<BR>\n<BR>\nCurrent Diseases: [M.fields["cdi"]] (per disease info placed in log/comment section)<BR>\nDetails: [M.fields["cdi_d"]]<BR>\n<BR>\nImportant Notes:<BR>\n\t[M.fields["notes"]]<BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>"
				var/counter = 1
				while(M.fields["com_[counter]"])
					P.info += "[M.fields["com_[counter]"]]<BR>"
					counter++
				P.info += "</TT>"
				P.name = "Medical Record ([G.fields["name"]])"
			virgin = 0	//tabbing here is correct- it's possible for people to try and use it
						//before the records have been generated, so we do this inside the loop.
	..()

/obj/structure/filingcabinet/medical/attack_hand()
	populate()
	..()

/*
 * Hydroponics Cabinets
 */

/obj/structure/filingcabinet/seeds
	name = "seeds cabinet"
	desc = "A large cabinet with drawers. This one is meant for storing seed packets"
	allowed_types = list(/obj/item/seeds)

/obj/structure/filingcabinet/disk
	name = "disk cabinet"
	desc = "A large cabinet with drawers. This one is meant for storing floral data disks"
	allowed_types = list(/obj/item/disk)