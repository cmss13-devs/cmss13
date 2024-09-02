GLOBAL_LIST_INIT_TYPED(allfaxes, /obj/structure/machinery/faxmachine, list())
GLOBAL_LIST_EMPTY(alldepartments)

#define DEPARTMENT_WY "Weyland-Yutani"
#define DEPARTMENT_HC "USCM High Command"
#define DEPARTMENT_CMB "CMB Incident Command Center, Local Operations"
#define DEPARTMENT_PROVOST "USCM Provost Office"
#define DEPARTMENT_PRESS "Various Press Organizations"
#define DEPARTMENT_TWE "Three World Empire"
#define DEPARTMENT_UPP "Union of Progress Peoples"
#define DEPARTMENT_CLF "Colonial Liberation Front"
#define HIGHCOM_DEPARTMENTS list(DEPARTMENT_WY, DEPARTMENT_HC, DEPARTMENT_CMB, DEPARTMENT_PROVOST, DEPARTMENT_PRESS, DEPARTMENT_TWE, DEPARTMENT_UPP, DEPARTMENT_CLF)

/obj/structure/machinery/faxmachine // why not fax_machine?
	name = "\improper General Purpose Fax Machine"
	icon = 'icons/obj/structures/machinery/library.dmi'
	icon_state = "fax"
	anchored = TRUE
	density = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 200
	power_channel = POWER_CHANNEL_EQUIP

	var/obj/item/card/id/scan // identification
	var/authenticated = FALSE

	var/obj/item/paper/original_fax // what we're sending

	// copy of the original fax in paper format, we want the original item (i.e. photo, paper bundle) not be changed as the user will need to eject it.
	var/obj/item/paper/fax_paper_copy

	///Our department
	var/department = "General Public"

	///Target department
	var/target_department = DEPARTMENT_WY

	// list for img and their photo reference to be stored into the admin's cache.
	var/list/photo_list = list()

	///Fluff network shown by fax machine when logged in
	var/network = "Weyland-Yutani Public Network"

	///storer var for cooldown on sending faxes
	var/fax_cooldown = 300
	COOLDOWN_DECLARE(send_cooldown)

/obj/structure/machinery/faxmachine/Initialize(mapload, ...)
	. = ..()
	GLOB.allfaxes += src
	update_departments()

/obj/structure/machinery/faxmachine/Destroy()
	GLOB.allfaxes -= src
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

	if(istype(O, /obj/item/paper) || istype(O, /obj/item/paper_bundle) || istype(O, /obj/item/photo))
		if(original_fax)
			to_chat(user, SPAN_NOTICE("There is already something in \the [src]."))
			return

		var/jammed = FALSE
		if(istype(O, /obj/item/paper_bundle))
			var/obj/item/paper_bundle/bundle = O
			if(bundle.amount > 5)
				jammed = TRUE

		user.drop_inv_item_to_loc(O, src)
		original_fax = O
		if(!jammed)
			to_chat(user, SPAN_NOTICE("You insert the [O.name] into \the [src]."))
		else
			to_chat(user, SPAN_NOTICE("\The [src] jammed! It can only accept up to five papers at once."))
			playsound(src, "sound/machines/terminal_insert_disc.ogg", 50, TRUE)
		flick("[initial(icon_state)]send", src)
		updateUsrDialog()
		return

	if(istype(O, /obj/item/card/id))

		var/obj/item/card/id/idcard = O
		if(scan)
			to_chat(user, SPAN_NOTICE("There is already an id in \the [src]."))
			return

		user.drop_inv_item_to_loc(idcard, src)
		scan = idcard
		to_chat(usr, SPAN_NOTICE("You put \the [scan] into \the [src]."))
		playsound(src, 'sound/machines/pda_button1.ogg', 15, TRUE)
		return

	if(HAS_TRAIT(O, TRAIT_TOOL_WRENCH))
		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
		anchored = !anchored
		to_chat(user, SPAN_NOTICE("You [anchored ? "wrench" : "unwrench"] \the [src]."))

/obj/structure/machinery/faxmachine/verb/eject_id()
	set category = "Object"
	set name = "Eject ID Card"
	set src in view(1)
	if(usr.is_mob_incapacitated())
		return

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
	if( !("[department]" in GLOB.alldepartments) ) //Initialize departments. This will work with multiple fax machines.
		GLOB.alldepartments += department
	if(!(DEPARTMENT_WY in GLOB.alldepartments))
		GLOB.alldepartments += DEPARTMENT_WY
	if(!(DEPARTMENT_HC in GLOB.alldepartments))
		GLOB.alldepartments += DEPARTMENT_HC
	if(!(DEPARTMENT_PROVOST in GLOB.alldepartments))
		GLOB.alldepartments += DEPARTMENT_PROVOST
	if(!(DEPARTMENT_CMB in GLOB.alldepartments))
		GLOB.alldepartments += DEPARTMENT_CMB
	if(!(DEPARTMENT_PRESS in GLOB.alldepartments))
		GLOB.alldepartments += DEPARTMENT_PRESS
	if(!(DEPARTMENT_TWE in GLOB.alldepartments))
		GLOB.alldepartments += DEPARTMENT_TWE
	if(!(DEPARTMENT_UPP in GLOB.alldepartments))
		GLOB.alldepartments += DEPARTMENT_UPP
	if(!(DEPARTMENT_CLF in GLOB.alldepartments))
		GLOB.alldepartments += DEPARTMENT_CLF

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
	data["paper"] = original_fax
	if(original_fax)
		data["paper_name"] = original_fax.name

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
			if(!original_fax)
				to_chat(ui.user, SPAN_NOTICE("No paper loaded."))
				return

			if(istype(original_fax, /obj/item/paper_bundle))
				var/obj/item/paper_bundle/bundle = original_fax
				if(bundle.amount > 5)
					to_chat(ui.user, SPAN_NOTICE("\The [src] is jammed!"))
					return

			copy_fax_paper()

			outgoing_fax_message(ui.user)

			COOLDOWN_START(src, send_cooldown, fax_cooldown)
			to_chat(ui.user, "Message transmitted successfully.")
			. = TRUE

		if("ejectpaper")
			if(!original_fax)
				to_chat(ui.user, SPAN_NOTICE("No paper loaded."))
			if(!ishuman(ui.user))
				to_chat(ui.user, SPAN_NOTICE("You can't do that."))
				return

			original_fax.forceMove(ui.user.loc)
			ui.user.put_in_hands(original_fax)
			to_chat(ui.user, SPAN_NOTICE("You take \the [original_fax.name] out of \the [src]."))
			original_fax = null
			fax_paper_copy = null
			photo_list = null
			. = TRUE

		if("insertpaper")
			var/jammed = FALSE
			var/obj/item/I = ui.user.get_active_hand()
			if(istype(I, /obj/item/paper_bundle))
				var/obj/item/paper_bundle/bundle = I
				if(bundle.amount > 5)
					jammed = TRUE
				// Repeating code? This is not ideal. Why not put this functionality inside of a proc?
			if(istype(I, /obj/item/paper) || istype(I, /obj/item/paper_bundle) || istype(I, /obj/item/photo))
				ui.user.drop_inv_item_to_loc(I, src)
				original_fax = I
				if(!jammed)
					to_chat(ui.user, SPAN_NOTICE("You put \the [original_fax.name] into \the [src]."))
				else
					to_chat(ui.user, SPAN_NOTICE("\The [src] jammed! It can only accept up to five papers at once."))
					playsound(src, "sound/machines/terminal_insert_disc.ogg", 50, TRUE)
				flick("[initial(icon_state)]send", src)
			. = TRUE

		if("ejectid")
			if(!scan || !ishuman(ui.user))
				to_chat(ui.user, SPAN_WARNING("You can't do that."))
				return
			to_chat(ui.user, SPAN_NOTICE("You take \the [scan] out of \the [src]."))
			scan.forceMove(ui.user.loc)
			if(!ui.user.get_active_hand())
				ui.user.put_in_hands(scan)
				scan = null
			else
				scan.forceMove(src.loc)
				scan = null
			authenticated = FALSE
			playsound(src, 'sound/machines/terminal_eject.ogg', 15, TRUE)
			. = TRUE

		if("select")
			var/last_target_department = target_department
			target_department = tgui_input_list(ui.user, "Which department?", "Choose a department", GLOB.alldepartments)
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

	add_fingerprint(ui.user)

/obj/structure/machinery/faxmachine/vv_get_dropdown()
	. = ..()
	. += "<option value>-----FAX-----</option>"
	. += "<option value='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];USCMFaxReply=\ref[usr];originfax=\ref[src]'>Send USCM fax message</option>"
	. += "<option value='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];WYFaxReply=\ref[usr];originfax=\ref[src]'>Send CL fax message</option>"
	. += "<option value='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];CMBFaxReply=\ref[usr];originfax=\ref[src]'>Send CMB fax message</option>"
	. += "<option value='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];PressFaxReply=\ref[usr];originfax=\ref[src]'>Send Press fax message</option>"
	. += "<option value='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];UPPFaxReply=\ref[usr];originfax=\ref[src]'>Send UPP fax message</option>"
	. += "<option value='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];CLFFaxReply=\ref[usr];originfax=\ref[src]'>Send CLF fax message</option>"
	. += "<option value='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];TWEFaxReply=\ref[usr];originfax=\ref[src]'>Send TWE fax message</option>"

// converting whatever type the fax is into a single paper with all the information on it.
/obj/structure/machinery/faxmachine/proc/copy_fax_paper(mob/living/user)

	if(fax_paper_copy)
		return

	if(istype(original_fax, /obj/item/paper))
		fax_paper_copy = original_fax
		return

	fax_paper_copy = new()
	fax_paper_copy.name = original_fax.name

	if(istype(original_fax, /obj/item/photo))
		var/obj/item/photo/faxed_photo = original_fax
		photo_list += list("tmp_photo.png" = faxed_photo.img )
		fax_paper_copy.info  += "<img src='tmp_photo.png' width='192'/>"
		return

	// type bundle
	var/obj/item/paper_bundle/papers = original_fax
	for(var/content in 1 to papers.amount)
		fax_paper_copy.info += "<h1>Page #[content]</h1>"
		fax_paper_copy.info += "<hr>"
		if(istype(papers[content], /obj/item/paper))
			var/obj/item/paper/faxed_paper = papers[content]
			fax_paper_copy.info += faxed_paper.info
		else // type photo
			var/obj/item/photo/faxed_photo = papers[content]
			if(!isicon(faxed_photo.img))
				return
			photo_list += list("tmp_photo[content].png" = (faxed_photo.img))
			fax_paper_copy.info  += "<img src='tmp_photo[content].png' width='192'/>"

/obj/structure/machinery/faxmachine/proc/outgoing_fax_message(mob/user)

	var/datum/fax/faxcontents = new(fax_paper_copy.info, photo_list)

	GLOB.fax_contents += faxcontents

	var/scan_department = target_department
	if(department in HIGHCOM_DEPARTMENTS)
		scan_department = department

	var/msg_admin = SPAN_STAFF_IC("<b><font color='#006100'>[target_department]: </font>[key_name(user, 1)] ")
	msg_admin += "[CC_MARK(user)] [ADMIN_PP(user)] [ADMIN_VV(user)] [ADMIN_SM(user)] [ADMIN_JMP_USER(user)] "

	switch(scan_department)
		if(DEPARTMENT_HC)
			GLOB.USCMFaxes.Add("<a href='?FaxView=\ref[faxcontents]'>\['[original_fax.name]' from [key_name(usr)], [scan] at [time2text(world.timeofday, "hh:mm:ss")]\]</a> <a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];USCMFaxReply=\ref[user];originfax=\ref[src]'>REPLY</a>")
			msg_admin += "(<a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];USCMFaxReply=\ref[user];originfax=\ref[src]'>RPLY</a>)</b>: "
		if(DEPARTMENT_PROVOST)
			GLOB.ProvostFaxes.Add("<a href='?FaxView=\ref[faxcontents]'>\['[original_fax.name]' from [key_name(usr)], [scan] at [time2text(world.timeofday, "hh:mm:ss")]\]</a> <a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];USCMFaxReply=\ref[user];originfax=\ref[src]'>REPLY</a>")
			msg_admin += "(<a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];USCMFaxReply=\ref[user];originfax=\ref[src]'>RPLY</a>)</b>: "
		if(DEPARTMENT_CMB)
			GLOB.CMBFaxes.Add("<a href='?FaxView=\ref[faxcontents]'>\['[original_fax.name]' from [key_name(usr)], [scan] at [time2text(world.timeofday, "hh:mm:ss")]\]</a> <a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];CMBFaxReply=\ref[user];originfax=\ref[src]'>REPLY</a>")
			msg_admin += "(<a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];CMBFaxReply=\ref[user];originfax=\ref[src]'>RPLY</a>)</b>: "
		if(DEPARTMENT_WY)
			GLOB.WYFaxes.Add("<a href='?FaxView=\ref[faxcontents]'>\['[original_fax.name]' from [key_name(usr)], [scan] at [time2text(world.timeofday, "hh:mm:ss")]\]</a> <a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];WYFaxReply=\ref[user];originfax=\ref[src]'>REPLY</a>")
			msg_admin += "(<a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];WYFaxReply=\ref[user];originfax=\ref[src]'>RPLY</a>)</b>: "
		if(DEPARTMENT_PRESS)
			GLOB.PressFaxes.Add("<a href='?FaxView=\ref[faxcontents]'>\['[original_fax.name]' from [key_name(usr)], [scan] at [time2text(world.timeofday, "hh:mm:ss")]\]</a> <a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];PressFaxReply=\ref[user];originfax=\ref[src]'>REPLY</a>")
			msg_admin += "(<a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];PressFaxReply=\ref[user];originfax=\ref[src]'>RPLY</a>)</b>: "
		if(DEPARTMENT_TWE)
			GLOB.TWEFaxes.Add("<a href='?FaxView=\ref[faxcontents]'>\['[original_fax.name]' from [key_name(usr)], [scan] at [time2text(world.timeofday, "hh:mm:ss")]\]</a> <a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];TWEFaxReply=\ref[user];originfax=\ref[src]'>REPLY</a>")
			msg_admin += "(<a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];TWEFaxReply=\ref[user];originfax=\ref[src]'>RPLY</a>)</b>: "
		if(DEPARTMENT_UPP)
			GLOB.UPPFaxes.Add("<a href='?FaxView=\ref[faxcontents]'>\['[original_fax.name]' from [key_name(usr)], [scan] at [time2text(world.timeofday, "hh:mm:ss")]\]</a> <a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];UPPFaxReply=\ref[user];originfax=\ref[src]'>REPLY</a>")
			msg_admin += "(<a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];UPPFaxReply=\ref[user];originfax=\ref[src]'>RPLY</a>)</b>: "
		if(DEPARTMENT_CLF)
			GLOB.CLFFaxes.Add("<a href='?FaxView=\ref[faxcontents]'>\['[original_fax.name]' from [key_name(usr)], [scan] at [time2text(world.timeofday, "hh:mm:ss")]\]</a> <a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];CLFFaxReply=\ref[user];originfax=\ref[src]'>REPLY</a>")
			msg_admin += "(<a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];CLFFaxReply=\ref[user];originfax=\ref[src]'>RPLY</a>)</b>: "
		else
			GLOB.GeneralFaxes.Add("<a href='?FaxView=\ref[faxcontents]'>\['[original_fax.name]' from [key_name(usr)], [scan] at [time2text(world.timeofday, "hh:mm:ss")]\]</a> <a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];WYFaxReply=\ref[user];originfax=\ref[src]'>REPLY</a>")
			msg_admin += "(<a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];USCMFaxReply=\ref[user];originfax=\ref[src]'>RPLY</a>)</b>: "

	msg_admin += SPAN_STAFF_IC("Receiving fax via secure connection ... <a href='?FaxView=\ref[faxcontents]'>view message</a>")

	var/msg_ghost = SPAN_NOTICE("<b><font color='#006100'>[target_department]: </font></b>")
	msg_ghost += "Receiving fax via secure connection ... <a href='?FaxView=\ref[faxcontents]'>view message</a>"

	send_fax(faxcontents)

	announce_fax(msg_admin, msg_ghost)

/datum/proc/announce_fax(msg_admin, msg_ghost)
	log_admin(msg_admin)
	for(var/client/C in GLOB.admins)
		if((R_ADMIN|R_MOD) & C.admin_holder.rights)
			if(msg_admin)
				to_chat(C, msg_admin)
			else
				to_chat(C, msg_ghost)
			if(C.prefs?.toggles_sound & SOUND_FAX_MACHINE)
				C << 'sound/effects/incoming-fax.ogg'
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
			if(C.prefs?.toggles_sound & SOUND_FAX_MACHINE)
				C << 'sound/effects/incoming-fax.ogg'


/obj/structure/machinery/faxmachine/proc/send_fax(datum/fax/faxcontents)
	for(var/obj/structure/machinery/faxmachine/F in GLOB.allfaxes)
		if(F != src && F.department == target_department)
			if(!faxcontents)
				return
			if(! (F.inoperable() ) )

				flick("[initial(icon_state)]receive", F)

				// give the sprite some time to flick
				spawn(30)
					var/obj/item/paper/P = new(F.loc,faxcontents.photo_list)
					P.name = "faxed message"
					P.info = "[faxcontents.data]"
					P.update_icon()

					switch(network)
						if("USCM High Command Quantum Relay")
							var/image/stampoverlay = image('icons/obj/items/paper.dmi')
							stampoverlay.icon_state = "paper_stamp-uscm"
							P.stamps += "<HR><i>This paper has been stamped by the USCM High Command Quantum Relay.</i>"
						if("NC4 UA Federal Secure Network - CMB Relay")
							var/image/stampoverlay = image('icons/obj/items/paper.dmi')
							stampoverlay.icon_state = "paper_stamp-cmb"
							if(!P.stamped)
								P.stamped = new
							P.stamped += /obj/item/tool/stamp
							P.overlays += stampoverlay
							P.stamps += "<HR><i>This paper has been stamped by The Office of Colonial Marshals.</i>"
						if("Weyland-Yutani Quantum Relay")
							var/image/stampoverlay = image('icons/obj/items/paper.dmi')
							stampoverlay.icon_state = "paper_stamp-weyyu"
							if(!P.stamped)
								P.stamped = new
							P.stamped += /obj/item/tool/stamp
							P.overlays += stampoverlay
							P.stamps += "<HR><i>This paper has been stamped and encrypted by the Weyland-Yutani Quantum Relay (tm).</i>"
						if("TWE Royal Marines Commando Quantum Relay")
							var/image/stampoverlay = image('icons/obj/items/paper.dmi')
							stampoverlay.icon_state = "paper_stamp-twe"
							if(!P.stamped)
								P.stamped = new
							P.stamped += /obj/item/tool/stamp
							P.overlays += stampoverlay
							P.stamps += "<HR><i>This paper has been stamped by the TWE Royal Marines Commando Quantum Relay.</i>"
						if("UPP High Kommand Quantum Relay")
							var/image/stampoverlay = image('icons/obj/items/paper.dmi')
							stampoverlay.icon_state = "paper_stamp-upp"
							if(!P.stamped)
								P.stamped = new
							P.stamped += /obj/item/tool/stamp
							P.overlays += stampoverlay
							P.stamps += "<HR><i>This paper has been stamped by the UPP High Kommand Quantum Relay.</i>"
						if("CLF Gureilla Command Quantum Relay")
							var/image/stampoverlay = image('icons/obj/items/paper.dmi')
							stampoverlay.icon_state = "paper_stamp-clf"
							if(!P.stamped)
								P.stamped = new
							P.stamped += /obj/item/tool/stamp
							P.overlays += stampoverlay
							P.stamps += "<HR><i>This paper has been stamped and encrypted by the CLF Gureilla Command Quantum Relay.</i>"

					playsound(F.loc, "sound/items/polaroid1.ogg", 15, 1)
		qdel(faxcontents)

/obj/structure/machinery/faxmachine/cmb
	name = "\improper CMB Incident Command Center Fax Machine"
	department = "Colonial Marshal Bureau, Anchorpoint Station"
	network = "NC4 UA Federal Secure Network - CMB Relay"
	department = DEPARTMENT_CMB

/obj/structure/machinery/faxmachine/corporate
	name = "\improper W-Y Corporate Fax Machine"
	department = "W-Y Local Office"
	network = "Weyland-Yutani Secure Network"

/obj/structure/machinery/faxmachine/corporate/liaison
	department = "W-Y Liaison"

/obj/structure/machinery/faxmachine/corporate/highcom
	department = DEPARTMENT_WY
	target_department = "W-Y Liaison"
	network = "Weyland-Yutani Quantum Relay"

/obj/structure/machinery/faxmachine/uscm
	name = "\improper USCM Military Fax Machine"
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
	name = "\improper USCM Provost Fax Machine"
	department = "Brig"
	target_department = DEPARTMENT_PROVOST

/obj/structure/machinery/faxmachine/uscm/brig/chief
	department = "Chief MP"

/obj/structure/machinery/faxmachine/uscm/brig/provost
	department = DEPARTMENT_PROVOST
	target_department = "Brig"
	network = "USCM High Command Quantum Relay"


///The deployed fax machine backpack
/obj/structure/machinery/faxmachine/backpack
	name = "\improper Portable Press Fax Machine"
	desc = "A standard issue portable fax machine for civilian reporters. Functions off of an internal battery. Cannot receive faxes while being worn. It is currently deployed. Click-drag the device towards you to pick it up."
	icon_state = "fax_backpack"
	needs_power = FALSE
	use_power = USE_POWER_NONE
	health = 150

///The wearable and deployable part of the fax machine backpack
/obj/item/device/fax_backpack
	name = "\improper Portable Press Fax Machine"
	desc = "A standard issue portable fax machine for civilian reporters. Functions off of an internal battery. Cannot receive faxes while being worn. It is currently undeployed. Activate the device inhand to deploy it."
	icon = 'icons/obj/structures/machinery/library.dmi'
	icon_state = "fax_backpack"
	item_state = "fax_backpack"
	w_class = SIZE_HUGE
	flags_equip_slot = SLOT_BACK
	flags_item = ITEM_OVERRIDE_NORTHFACE

/obj/item/device/fax_backpack/attack_self(mob/user) //activate item version fax inhand to deploy
	if(!ishuman(user))
		return
	var/turf/deployturf = get_turf(user)
	if(istype(deployturf, /turf/open))
		var/turf/open/floor = deployturf
		if(!floor.allow_construction)
			to_chat(user, SPAN_WARNING("You cannot deploy [src] here, find a more secure surface!"))
			return FALSE
	var/fail = FALSE
	if(deployturf.density)
		fail = TRUE
	else
		var/static/list/blocking_types = typecacheof(list(
			/obj/structure/machinery/defenses,
			/obj/structure/window,
			/obj/structure/windoor_assembly,
			/obj/structure/machinery/door,
		))
		for(var/obj/blockingobj in deployturf.contents)
			if(blockingobj.density && !(blockingobj.flags_atom & ON_BORDER))
				fail = TRUE
				break
			if(is_type_in_typecache(blockingobj, blocking_types))
				fail = TRUE
				break
	if(fail)
		to_chat(user, SPAN_WARNING("You can't deploy [src] here, something is in the way."))
		return
	to_chat(user,  SPAN_NOTICE("You begin to deploy [src]..."))
	if(do_after(user, 4.5 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		to_chat(user, SPAN_NOTICE("You deploy [src]."))
		var/obj/structure/machinery/faxmachine/backpack/deployedfax = new(deployturf)
		transfer_label_component(deployedfax)
		playsound(src.loc, 'sound/machines/print.ogg', 40, 1)
		qdel(src)
		return
	return ..()

/obj/structure/machinery/faxmachine/backpack/MouseDrop(over_object, src_location, over_location) //Drag the deployed fax onto you to pick it up.
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	if(over_object == user && in_range(src, user))
		if(original_fax || scan)
			to_chat(user, SPAN_NOTICE("There is still something in [src]. Remove it before you pick it up."))
			return
		to_chat(user, SPAN_NOTICE("You begin to pick up [src]..."))
		if(do_after(user, 4.5 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
			to_chat(user, SPAN_NOTICE("You pick up [src]."))
			var/obj/item/device/fax_backpack/faxbag = new(loc)
			transfer_label_component(faxbag)
			user.put_in_hands(faxbag)
			qdel(src)
			return
		return ..()

/datum/fax
	var/data
	var/list/photo_list

/datum/fax/New(data, photo_list)
	. = ..()
	src.data = data
	src.photo_list = photo_list
