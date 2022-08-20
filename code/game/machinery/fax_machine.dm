var/list/obj/structure/machinery/faxmachine/allfaxes = list()
var/list/alldepartments = list()

//This fax machine will become a colonial one after I have mapped it onto the Almayer.
/obj/structure/machinery/faxmachine
	name = "General Purpose Fax Machine"
	icon = 'icons/obj/structures/machinery/library.dmi'
	icon_state = "fax"
	anchored = TRUE
	density = TRUE
	use_power = 1
	idle_power_usage = 30
	active_power_usage = 200
	power_channel = POWER_CHANNEL_EQUIP

	var/obj/item/card/id/scan = null // identification
	var/authenticated = 0

	var/obj/item/paper/tofax = null // what we're sending
	var/sendcooldown = 0 // to avoid spamming fax messages

	///Our department
	var/department = "General Public"

	///Target department
	var/dpt = "Weyland-Yutani"

	///Fluff network shown by fax machine when logged in
	var/network = "Weyland-Yutani Public Network"

/obj/structure/machinery/faxmachine/Initialize(mapload, ...)
	. = ..()
	allfaxes += src

	if( !("[department]" in alldepartments) ) //Initialize departments. This will work with multiple fax machines.
		alldepartments += department
	if(!("Weyland-Yutani" in alldepartments))
		alldepartments += "Weyland-Yutani"
	if(!("USCM High Command" in alldepartments))
		alldepartments += "USCM High Command"
	if(!("USCM Provost Office" in alldepartments))
		alldepartments += "USCM Provost Office"

/obj/structure/machinery/faxmachine/Destroy()
	allfaxes -= src
	. = ..()

/obj/structure/machinery/faxmachine/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM


/obj/structure/machinery/faxmachine/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/faxmachine/attack_hand(mob/user as mob)
	user.set_interaction(src)

	var/dat

	var/scan_name
	if(scan)
		scan_name = scan.name
	else
		scan_name = "--------"

	dat += "Confirm Identity: <a href='byond://?src=\ref[src];scan=1'>[scan_name]</a><br>"

	if(authenticated)
		dat += "<a href='byond://?src=\ref[src];logout=1'>Log Out</a>"
	else
		dat += "<a href='byond://?src=\ref[src];auth=1'>Log In</a>"

	dat += "<hr>"

	if(authenticated)
		dat += "<b>Logged in to:</b> [network]<br><br>"

		if(tofax)
			dat += "<a href='byond://?src=\ref[src];remove=1'>Remove Paper</a><br><br>"

			if(sendcooldown)
				dat += "<b>Transmitter arrays realigning. Please stand by.</b><br>"

			else
				dat += "<a href='byond://?src=\ref[src];send=1'>Send</a><br>"
				dat += "<b>Currently sending:</b> [tofax.name]<br>"
				dat += "<b>Sending to:</b> <a href='byond://?src=\ref[src];dept=1'>[dpt]</a><br>"

		else
			if(sendcooldown)
				dat += "Please insert paper to send via secure connection.<br><br>"
				dat += "<b>Transmitter arrays realigning. Please stand by.</b><br>"
			else
				dat += "Please insert paper to send via secure connection.<br><br>"

	else
		dat += "Proper authentication is required to use this device.<br><br>"

		if(tofax)
			dat += "<a href ='byond://?src=\ref[src];remove=1'>Remove Paper</a><br>"

	show_browser(user, dat, "Fax Machine", "fax")
	return

/obj/structure/machinery/faxmachine/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(href_list["send"])
		if(tofax)

			if(dpt == "USCM High Command")
				highcom_fax(src, tofax.info, tofax.name, usr)
				sendcooldown = 600

			else if(dpt == "USCM Provost Office")
				provost_fax(src, tofax.info, tofax.name, usr)
				sendcooldown = 600

			else if(dpt == "Weyland-Yutani")
				company_fax(src, tofax.info, tofax.name, usr)
				sendcooldown = 600
			else
				general_fax(src, tofax.info, tofax.name, usr)
				sendcooldown = 300

			SendFax(tofax.info, tofax.name, usr, dpt, network, src)
			to_chat(usr, "Message transmitted successfully.")

			spawn(sendcooldown) // cooldown time
				sendcooldown = 0

	if(href_list["remove"])
		if(tofax)
			if(!ishuman(usr))
				to_chat(usr, SPAN_WARNING("You can't do it."))
			else
				tofax.forceMove(usr.loc)
				usr.put_in_hands(tofax)
				to_chat(usr, SPAN_NOTICE("You take the paper out of \the [src]."))
				tofax = null

	if(href_list["scan"])
		if (scan)
			if(ishuman(usr))
				scan.forceMove(usr.loc)
				if(!usr.get_active_hand())
					usr.put_in_hands(scan)
				scan = null
			else
				scan.forceMove(src.loc)
				scan = null
		else
			var/obj/item/I = usr.get_active_hand()
			if (istype(I, /obj/item/card/id))
				usr.drop_inv_item_to_loc(I, src)
				scan = I
		authenticated = 0

	if(href_list["dept"])
		var/lastdpt = dpt
		dpt = tgui_input_list(usr, "Which department?", "Choose a department", alldepartments)
		if(!dpt) dpt = lastdpt

	if(href_list["auth"])
		if ( (!( authenticated ) && (scan)) )
			if (check_access(scan))
				authenticated = 1

	if(href_list["logout"])
		authenticated = 0

	updateUsrDialog()

/obj/structure/machinery/faxmachine/attackby(obj/item/O as obj, mob/user as mob)

	if(istype(O, /obj/item/paper))
		if(!tofax)
			user.drop_inv_item_to_loc(O, src)
			tofax = O
			to_chat(user, SPAN_NOTICE("You insert the paper into \the [src]."))
			flick("faxsend", src)
			updateUsrDialog()
		else
			to_chat(user, SPAN_NOTICE("There is already something in \the [src]."))

	else if(istype(O, /obj/item/card/id))

		var/obj/item/card/id/idcard = O
		if(!scan)
			user.drop_inv_item_to_loc(idcard, src)
			scan = idcard

	else if(HAS_TRAIT(O, TRAIT_TOOL_WRENCH))
		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
		anchored = !anchored
		to_chat(user, SPAN_NOTICE("You [anchored ? "wrench" : "unwrench"] \the [src]."))
	return

/obj/structure/machinery/faxmachine/verb/eject_id()
	set category = "Object"
	set name = "Eject ID Card"
	set src in view(1)

	if(!usr || usr.stat || usr.lying)	return

	if(ishuman(usr) && scan)
		to_chat(usr, "You remove \the [scan] from \the [src].")
		scan.forceMove(get_turf(src))
		if(!usr.get_active_hand() && istype(usr,/mob/living/carbon/human))
			usr.put_in_hands(scan)
		scan = null
		authenticated = FALSE
	else
		to_chat(usr, "There is nothing to remove from \the [src].")
	return

/obj/structure/machinery/faxmachine/get_vv_options()
	. = ..()
	. += "<option value>-----FAX-----</option>"
	. += "<option value='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];USCMFaxReply=\ref[usr];originfax=\ref[src]'>Send USCM fax message</option>"
	. += "<option value='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];CLFaxReply=\ref[usr];originfax=\ref[src]'>Send CL fax message</option>"

/proc/highcom_fax(var/originfax, var/sent, var/sentname, var/mob/Sender)
	var/faxcontents = "[sent]"
	GLOB.fax_contents += faxcontents

	var/msg_admin = SPAN_NOTICE("<b><font color='#006100'>USCM FAX: </font>[key_name(Sender, 1)] ")
	msg_admin += "(<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];ahelp=mark=\ref[Sender]'>Mark</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayeropts=\ref[Sender]'>PP</A>) "
	msg_admin += "(<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];subtlemessage=\ref[Sender]'>SM</A>) "
	msg_admin += "(<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservejump=\ref[Sender]'>JMP</A>) "
	msg_admin += "(<a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];USCMFaxReply=\ref[Sender];originfax=\ref[originfax]'>RPLY</a>)</b>: "
	msg_admin += "Receiving '[sentname]' via secure connection ... <a href='?FaxView=\ref[faxcontents]'>view message</a>"

	var/msg_ghost = SPAN_NOTICE("<b><font color='#006100'>USCM FAX: </font></b>")
	msg_ghost += "Receiving '[sentname]' via secure connection ... <a href='?FaxView=\ref[faxcontents]'>view message</a>"

	GLOB.USCMFaxes.Add("<a href='?FaxView=\ref[faxcontents]'>\[view message at [world.timeofday]\]</a> <a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];USCMFaxReply=\ref[Sender];originfax=\ref[originfax]'>REPLY</a>")
	announce_fax(msg_admin, msg_ghost)

/proc/provost_fax(var/originfax, var/sent, var/sentname, var/mob/Sender)
	var/faxcontents = "[sent]"
	GLOB.fax_contents += faxcontents

	var/msg_admin = SPAN_NOTICE("<b><font color='#006100'>PROVOST FAX: </font>[key_name(Sender, 1)] ")
	msg_admin += "(<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];ahelp=mark=\ref[Sender]'>Mark</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayeropts=\ref[Sender]'>PP</A>) "
	msg_admin += "(<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];subtlemessage=\ref[Sender]'>SM</A>) "
	msg_admin += "(<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservejump=\ref[Sender]'>JMP</A>) "
	msg_admin += "(<a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];USCMFaxReply=\ref[Sender];originfax=\ref[originfax]'>RPLY</a>)</b>: "
	msg_admin += "Receiving '[sentname]' via secure connection ... <a href='?FaxView=\ref[faxcontents]'>view message</a>"

	var/msg_ghost = SPAN_NOTICE("<b><font color='#006100'>USCM FAX: </font></b>")
	msg_ghost += "Receiving '[sentname]' via secure connection ... <a href='?FaxView=\ref[faxcontents]'>view message</a>"

	GLOB.ProvostFaxes.Add("<a href='?FaxView=\ref[faxcontents]'>\[view message at [world.timeofday]\]</a> <a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];USCMFaxReply=\ref[Sender];originfax=\ref[originfax]'>REPLY</a>")
	announce_fax(msg_admin, msg_ghost)


/proc/company_fax(var/originfax, var/sent, var/sentname, var/mob/Sender)
	var/faxcontents = "[sent]"
	GLOB.fax_contents += faxcontents
	var/msg_admin = SPAN_NOTICE("<b><font color='#1F66A0'>WEYLAND-YUTANI FAX: </font>[key_name(Sender, 1)] ")
	msg_admin += "(<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];ccmark=\ref[Sender]'>Mark</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayeropts=\ref[Sender]'>PP</A>) "
	msg_admin += "(<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];subtlemessage=\ref[Sender]'>SM</A>) "
	msg_admin += "(<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservejump=\ref[Sender]'>JMP</A>) "
	msg_admin += "(<a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];CLFaxReply=\ref[Sender];originfax=\ref[originfax]'>RPLY</a>)</b>: "
	msg_admin += "Receiving '[sentname]' via secure connection ... <a href='?FaxView=\ref[faxcontents]'>view message</a>"
	var/msg_ghost = SPAN_NOTICE("<b><font color='#1F66A0'>WEYLAND-YUTANI FAX: </font></b>")
	msg_ghost += "Receiving '[sentname]' via secure connection ... <a href='?FaxView=\ref[faxcontents]'>view message</a>"
	GLOB.WYFaxes.Add("<a href='?FaxView=\ref[faxcontents]'>\[view message at [world.timeofday]\]</a> <a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];CLFaxReply=\ref[Sender];originfax=\ref[originfax]'>REPLY</a>")
	announce_fax(msg_admin, msg_ghost)

/proc/announce_fax(var/msg_admin, var/msg_ghost)
	log_admin(msg_admin) //Always irked me the replies do show up but the faxes themselves don't
	for(var/client/C in GLOB.admins)
		if((R_ADMIN|R_MOD) & C.admin_holder.rights)
			if(msg_admin)
				to_chat(C, msg_admin)
			else
				to_chat(C, msg_ghost)
			C << 'sound/effects/sos-morse-code.ogg'
	if(msg_ghost)
		for(var/i in GLOB.observer_list)
			var/mob/dead/observer/g = i
			if(!g.client)
				continue
			var/client/C = g.client
			if(C && C.admin_holder)
				if((R_ADMIN|R_MOD) & C.admin_holder.rights) //staff don't need to see the fax twice
					continue
			to_chat(C, msg_ghost)
			C << 'sound/effects/sos-morse-code.ogg'

/proc/general_fax(var/originfax, var/sent, var/sentname, var/mob/Sender)
	var/faxcontents = "[sent]"
	GLOB.fax_contents += faxcontents
	GLOB.GeneralFaxes.Add("<a href='?FaxView=\ref[faxcontents]'>\[view message at [world.timeofday]\]</a> <a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];CLFaxReply=\ref[Sender];originfax=\ref[originfax]'>REPLY</a>")

/proc/SendFax(var/sent, var/sentname, var/mob/Sender, var/dpt, var/network, var/obj/structure/machinery/faxmachine/origin)
	for(var/obj/structure/machinery/faxmachine/F in allfaxes)
		if(F != origin && F.department == dpt)
			if(! (F.inoperable() ) )

				flick("faxreceive", F)

				// give the sprite some time to flick
				spawn(20)
					var/obj/item/paper/P = new /obj/item/paper( F.loc )
					P.name = "[sentname]"
					P.info = "[sent]"
					P.update_icon()

					switch(network)
						if("USCM High Command Quantum Relay")
							var/image/stampoverlay = image('icons/obj/items/paper.dmi')
							stampoverlay.icon_state = "paper_stamp-uscm"
							if(!P.stamped)
								P.stamped = new
							P.stamped += /obj/item/tool/stamp
							P.overlays += stampoverlay
							P.stamps += "<HR><i>This paper has been stamped by the USCM High Command Quantum Relay.</i>"
						if("Weyland-Yutani Quantum Relay")
							var/image/stampoverlay = image('icons/obj/items/paper.dmi')
							stampoverlay.icon_state = "paper_stamp-cent"
							if(!P.stamped)
								P.stamped = new
							P.stamped += /obj/item/tool/stamp
							P.overlays += stampoverlay
							P.stamps += "<HR><i>This paper has been stamped and encrypted by the Weyland-Yutani Quantum Relay (tm).</i>"

					playsound(F.loc, "sound/items/polaroid1.ogg", 15, 1)


/obj/structure/machinery/faxmachine/corporate
	name = "W-Y Corporate Fax Machine"
	department = "W-Y Local Office"
	network = "Weyland-Yutani Secure Network"

/obj/structure/machinery/faxmachine/corporate/liaison
	department = "W-Y Liaison"

/obj/structure/machinery/faxmachine/corporate/highcom
	department = "Weyland-Yutani"
	dpt = "W-Y Liaison"
	network = "Weyland-Yutani Quantum Relay"

/obj/structure/machinery/faxmachine/uscm
	name = "USCM Military Fax Machine"
	department = "USCM Local Operations"
	network = "USCM Encrypted Network"
	dpt = "USCM High Command"

/obj/structure/machinery/faxmachine/uscm/command
	department = "CIC"

/obj/structure/machinery/faxmachine/uscm/command/capt
	department = "Commanding Officer"

/obj/structure/machinery/faxmachine/uscm/command/highcom
	department = "USCM High Command"
	dpt = "Commanding Officer"
	network = "USCM High Command Quantum Relay"

/obj/structure/machinery/faxmachine/uscm/brig
	name = "USCM Provost Fax Machine"
	department = "Brig"
	dpt = "USCM Provost Office"

/obj/structure/machinery/faxmachine/uscm/brig/chief
	department = "Chief MP"

/obj/structure/machinery/faxmachine/uscm/brig/provost
	department = "USCM Provost Office"
	dpt = "Brig"
	network = "USCM High Command Quantum Relay"
