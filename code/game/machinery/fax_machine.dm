var/list/obj/structure/machinery/faxmachine/allfaxes = list()
var/list/alldepartments = list()

#define DEPARTMENT_WY "Weyland-Yutani"
#define DEPARTMENT_HC "USCM High Command"
#define DEPARTMENT_PROVOST "USCM Provost Office"

//This fax machine will become a colonial one after I have mapped it onto the Almayer.
/obj/structure/machinery/faxmachine
	name = "General Purpose Fax Machine"
	icon = 'icons/obj/structures/machinery/library.dmi'
	icon_state = "fax"
	anchored = TRUE
	density = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 200
	power_channel = POWER_CHANNEL_EQUIP

	var/obj/item/card/id/scan = null // identification
	var/authenticated = FALSE

	var/obj/item/paper/tofax = null // what we're sending

	///Our department
	var/department = "General Public"

	///Target department
	var/target_department = DEPARTMENT_WY

	///Fluff network shown by fax machine when logged in
	var/network = "Weyland-Yutani Public Network"

	///storer var for cooldown on sending faxes
	var/fax_cooldown = 300
	COOLDOWN_DECLARE(send_cooldown)

/obj/structure/machinery/faxmachine/Initialize(mapload, ...)
	. = ..()
	allfaxes += src
	update_departments()

/obj/structure/machinery/faxmachine/Destroy()
	allfaxes -= src
	. = ..()

/obj/structure/machinery/faxmachine/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM


/obj/structure/machinery/faxmachine/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/faxmachine/attack_hand(mob/user)
	tgui_interact(user)

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
			to_chat(usr, SPAN_NOTICE("You put \the [scan] into \the [src]."))
			playsound(src, 'sound/machines/pda_button1.ogg', 15, TRUE)

	else if(HAS_TRAIT(O, TRAIT_TOOL_WRENCH))
		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
		anchored = !anchored
		to_chat(user, SPAN_NOTICE("You [anchored ? "wrench" : "unwrench"] \the [src]."))
	return

/obj/structure/machinery/faxmachine/verb/eject_id()
	set category = "Object"
	set name = "Eject ID Card"
	set src in view(1)

	if(!usr || usr.stat || usr.lying) return

	if(ishuman(usr) && scan)
		to_chat(usr, "You remove \the [scan] from \the [src].")
		playsound(src, 'sound/machines/terminal_eject.ogg', 15, TRUE)
		scan.forceMove(get_turf(src))
		if(!usr.get_active_hand() && istype(usr,/mob/living/carbon/human))
			usr.put_in_hands(scan)
		scan = null
		authenticated = FALSE
	else
		to_chat(usr, "There is nothing to remove from \the [src].")
	return

/obj/structure/machinery/faxmachine/proc/update_departments()
	if( !("[department]" in alldepartments) ) //Initialize departments. This will work with multiple fax machines.
		alldepartments += department
	if(!(DEPARTMENT_WY in alldepartments))
		alldepartments += DEPARTMENT_WY
	if(!(DEPARTMENT_HC in alldepartments))
		alldepartments += DEPARTMENT_HC
	if(!(DEPARTMENT_PROVOST in alldepartments))
		alldepartments += DEPARTMENT_PROVOST
// TGUI SHIT \\

/obj/structure/machinery/faxmachine/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FaxMachine", "[src.name]")
		ui.open()

/obj/structure/machinery/faxmachine/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/faxmachine/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/faxmachine/ui_static_data(mob/user)
	var/list/data = list()

	data["department"] = department
	data["network"] = network

	return data

/obj/structure/machinery/faxmachine/ui_data(mob/user)
	var/list/data = list()

	data["idcard"] = scan
	data["paper"] = tofax
	if(tofax)
		data["paper_name"] = tofax.name

	data["authenticated"] = authenticated
	data["target_department"] = target_department

	data["worldtime"] = world.time
	data["nextfaxtime"] = send_cooldown
	data["faxcooldown"] = fax_cooldown

	return data

/obj/structure/machinery/faxmachine/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("send")
			if(tofax)
				if(target_department == DEPARTMENT_HC)
					highcom_fax(src, tofax.info, tofax.name, usr)
					fax_cooldown = 600

				else if(target_department == DEPARTMENT_PROVOST)
					provost_fax(src, tofax.info, tofax.name, usr)
					fax_cooldown = 600

				else if(target_department == DEPARTMENT_WY)
					company_fax(src, tofax.info, tofax.name, usr)
					fax_cooldown = 600

				else
					general_fax(src, tofax.info, tofax.name, usr)
					fax_cooldown = 600

				COOLDOWN_START(src, send_cooldown, fax_cooldown)
				SendFax(tofax.info, tofax.name, usr, target_department, network, src)
				to_chat(usr, "Message transmitted successfully.")
				. = TRUE

		if("ejectpaper")
			if(tofax)
				if(!ishuman(usr))
					to_chat(usr, SPAN_WARNING("You can't do it."))
				else
					tofax.forceMove(usr.loc)
					usr.put_in_hands(tofax)
					to_chat(usr, SPAN_NOTICE("You take \the [tofax] out of \the [src]."))
					tofax = null
				. = TRUE

		if("insertpaper")
			var/obj/item/I = usr.get_active_hand()
			if(istype(I, /obj/item/paper))
				usr.drop_inv_item_to_loc(I, src)
				tofax = I
				to_chat(usr, SPAN_NOTICE("You put \the [tofax] into \the [src]."))
			. = TRUE

		if("ejectid")
			if(scan)
				if(ishuman(usr))
					scan.forceMove(usr.loc)
					if(!usr.get_active_hand())
						usr.put_in_hands(scan)
					scan = null
				else
					scan.forceMove(src.loc)
					scan = null
				to_chat(usr, SPAN_NOTICE("You take \the [scan] out of \the [src]."))
				authenticated = FALSE
				playsound(src, 'sound/machines/terminal_eject.ogg', 15, TRUE)
				. = TRUE

		if("select")
			var/last_target_department = target_department
			target_department = tgui_input_list(usr, "Which department?", "Choose a department", alldepartments)
			if(!target_department) target_department = last_target_department
			. = TRUE

		if("auth")
			if ( (!( authenticated ) && (scan)) )
				if (check_access(scan))
					authenticated = TRUE
					playsound(src, 'sound/machines/terminal_on.ogg', 20, FALSE)
				. = TRUE

		if("logout")
			authenticated = FALSE
			. = TRUE

	add_fingerprint(usr)

/obj/structure/machinery/faxmachine/vv_get_dropdown()
	. = ..()
	. += "<option value>-----FAX-----</option>"
	. += "<option value='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];USCMFaxReply=\ref[usr];originfax=\ref[src]'>Send USCM fax message</option>"
	. += "<option value='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];CLFaxReply=\ref[usr];originfax=\ref[src]'>Send CL fax message</option>"

/proc/highcom_fax(originfax, sent, sentname, mob/Sender)
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

/proc/provost_fax(originfax, sent, sentname, mob/Sender)
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


/proc/company_fax(originfax, sent, sentname, mob/Sender)
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

/proc/announce_fax(msg_admin, msg_ghost)
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

/proc/general_fax(originfax, sent, sentname, mob/Sender)
	var/faxcontents = "[sent]"
	GLOB.fax_contents += faxcontents
	GLOB.GeneralFaxes.Add("<a href='?FaxView=\ref[faxcontents]'>\[view message at [world.timeofday]\]</a> <a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];CLFaxReply=\ref[Sender];originfax=\ref[originfax]'>REPLY</a>")

/proc/SendFax(sent, sentname, mob/Sender, target_department, network, obj/structure/machinery/faxmachine/origin)
	for(var/obj/structure/machinery/faxmachine/F in allfaxes)
		if(F != origin && F.department == target_department)
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
	department = DEPARTMENT_WY
	target_department = "W-Y Liaison"
	network = "Weyland-Yutani Quantum Relay"

/obj/structure/machinery/faxmachine/uscm
	name = "USCM Military Fax Machine"
	department = "USCM Local Operations"
	network = "USCM Encrypted Network"
	target_department = DEPARTMENT_HC

/obj/structure/machinery/faxmachine/uscm/command
	department = "CIC"

/obj/structure/machinery/faxmachine/uscm/command/capt
	department = "Commanding Officer"

/obj/structure/machinery/faxmachine/uscm/command/highcom
	department = DEPARTMENT_HC
	target_department = "Commanding Officer"
	network = "USCM High Command Quantum Relay"

/obj/structure/machinery/faxmachine/uscm/brig
	name = "USCM Provost Fax Machine"
	department = "Brig"
	target_department = DEPARTMENT_PROVOST

/obj/structure/machinery/faxmachine/uscm/brig/chief
	department = "Chief MP"

/obj/structure/machinery/faxmachine/uscm/brig/provost
	department = DEPARTMENT_PROVOST
	target_department = "Brig"
	network = "USCM High Command Quantum Relay"
