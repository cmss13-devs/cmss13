/obj/structure/machinery/biogenerator
	name = "Biogenerator"
	desc = ""
	icon = 'icons/obj/structures/machinery/biogenerator.dmi'
	icon_state = "biogen-stand"
	density = TRUE
	anchored = TRUE
	wrenchable = TRUE
	use_power = 1
	idle_power_usage = 40
	flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM

var/list/obj/structure/machinery/faxmachine/allfaxes = list()
var/list/alldepartments = list()


/obj/structure/machinery/computer3
	name = "computer"
	icon = 'icons/obj/structures/machinery/computer3.dmi'
	icon_state = "frame"
	density = TRUE
	anchored = TRUE
	projectile_coverage = PROJECTILE_COVERAGE_LOW
	flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM

	idle_power_usage	= 20
	active_power_usage	= 50

/obj/structure/machinery/computer3/New(var/L, var/built = 0)
	..()
	spawn(2)
		power_change()

	update_icon()
	start_processing()


/obj/structure/machinery/computer3/laptop/secure_data
	icon_state = "laptop"

/obj/structure/machinery/computer3/powermonitor
	icon_state = "frame-eng"

/obj/structure/machinery/faxmachine
	name = "fax machine"
	icon = 'icons/obj/structures/machinery/library.dmi'
	icon_state = "fax"
//	req_one_access = list(ACCESS_MARINE_BRIDGE) //Warden needs to be able to Fax solgov too.
	anchored = TRUE
	density = TRUE
	use_power = 1
	idle_power_usage = 30
	active_power_usage = 200
	power_channel = POWER_CHANNEL_EQUIP
	flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM

	var/obj/item/card/id/scan = null // identification
	var/authenticated = 0

	var/obj/item/paper/tofax = null // what we're sending
	var/sendcooldown = 0 // to avoid spamming fax messages

	var/department = "Liaison" // our department

	var/dpt = "Weston-Yamada" // the department we're sending to


/obj/structure/machinery/faxmachine/New()
	..()
	allfaxes += src

	if( !("[department]" in alldepartments) ) //Initialize departments. This will work with multiple fax machines.
		alldepartments += department
	if(!("Weston-Yamada" in alldepartments))
		alldepartments += "Weston-Yamada"
	if(!("USCM High Command" in alldepartments))
		alldepartments += "USCM High Command"

/obj/structure/machinery/faxmachine/Dispose()
	allfaxes -= src
	. = ..()

/obj/structure/machinery/faxmachine/process()
	return 0

/obj/structure/machinery/faxmachine/attack_ai(mob/user as mob)
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
		dat += "<b>Logged in to:</b> Weston-Yamada Private Corporate Network<br><br>"

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
	if(href_list["send"])
		if(tofax)

			if(dpt == "USCM High Command")
				Centcomm_fax(src, tofax.info, tofax.name, usr)
				sendcooldown = 1200

			else if(dpt == "Weston-Yamada")
				Solgov_fax(src, tofax.info, tofax.name, usr)
				sendcooldown = 1200
			else
				SendFax(tofax.info, tofax.name, usr, dpt)
				sendcooldown = 600

			to_chat(usr, "Message transmitted successfully.")

			spawn(sendcooldown) // cooldown time
				sendcooldown = 0

	if(href_list["remove"])
		if(tofax)
			if(!ishuman(usr))
				to_chat(usr, SPAN_WARNING("You can't do it."))
			else
				tofax.loc = usr.loc
				usr.put_in_hands(tofax)
				to_chat(usr, SPAN_NOTICE("You take the paper out of \the [src]."))
				tofax = null

	if(href_list["scan"])
		if (scan)
			if(ishuman(usr))
				scan.loc = usr.loc
				if(!usr.get_active_hand())
					usr.put_in_hands(scan)
				scan = null
			else
				scan.loc = src.loc
				scan = null
		else
			var/obj/item/I = usr.get_active_hand()
			if (istype(I, /obj/item/card/id))
				usr.drop_inv_item_to_loc(I, src)
				scan = I
		authenticated = 0

	if(href_list["dept"])
		var/lastdpt = dpt
		dpt = input(usr, "Which department?", "Choose a department", "") as null|anything in alldepartments
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

	else if(istype(O, /obj/item/tool/wrench))
		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
		anchored = !anchored
		to_chat(user, SPAN_NOTICE("You [anchored ? "wrench" : "unwrench"] \the [src]."))
	return

/proc/Centcomm_fax(var/originfax, var/sent, var/sentname, var/mob/Sender)
	var/faxcontents = "[sent]"
	fax_contents += faxcontents

	var/msg_admin = SPAN_NOTICE("<b><font color='#006100'>USCM FAX: </font>[key_name(Sender, 1)] ")
	msg_admin += "(<A HREF='?_src_=admin_holder;ahelp=mark=\ref[src]'>Mark</A>) (<A HREF='?_src_=admin_holder;ahelp=adminplayeropts;extra=\ref[Sender]'>PP</A>) "
	msg_admin += "(<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=admin_holder;subtlemessage=\ref[Sender]'>SM</A>) "
	msg_admin += "(<A HREF='?_src_=admin_holder;adminplayerobservejump=\ref[Sender]'>JMP</A>) "
	msg_admin += "(<a href='?_src_=admin_holder;USCMFaxReply=\ref[Sender];originfax=\ref[originfax]'>RPLY</a>)</b>: "
	msg_admin += "Receiving '[sentname]' via secure connection ... <a href='?FaxView=\ref[faxcontents]'>view message</a>"

	var/msg_ghost = SPAN_NOTICE("<b><font color='#006100'>USCM FAX: </font></b>")
	msg_ghost += "Receiving '[sentname]' via secure connection ... <a href='?FaxView=\ref[faxcontents]'>view message</a>"

	USCMFaxes.Add("<a href='?FaxView=\ref[faxcontents]'>\[view message at [world.timeofday]\]</a> <a href='?_src_=admin_holder;USCMFaxReply=\ref[Sender];originfax=\ref[originfax]'>REPLY</a>")
	announce_fax(msg_admin, msg_ghost)

/proc/Solgov_fax(var/originfax, var/sent, var/sentname, var/mob/Sender)
	var/faxcontents = "[sent]"
	fax_contents += faxcontents
	var/msg_admin = SPAN_NOTICE("<b><font color='#1F66A0'>WESTON-YAMADA FAX: </font>[key_name(Sender, 1)] ")
	msg_admin += "(<A HREF='?_src_=admin_holder;ccmark=\ref[Sender]'>Mark</A>) (<A HREF='?_src_=admin_holder;ahelp=adminplayeropts;extra=\ref[Sender]'>PP</A>) "
	msg_admin += "(<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=admin_holder;subtlemessage=\ref[Sender]'>SM</A>) "
	msg_admin += "(<A HREF='?_src_=admin_holder;adminplayerobservejump=\ref[Sender]'>JMP</A>) "
	msg_admin += "(<a href='?_src_=admin_holder;CLFaxReply=\ref[Sender];originfax=\ref[originfax]'>RPLY</a>)</b>: "
	msg_admin += "Receiving '[sentname]' via secure connection ... <a href='?FaxView=\ref[faxcontents]'>view message</a>"
	var/msg_ghost = SPAN_NOTICE("<b><font color='#1F66A0'>WESTON-YAMADA FAX: </font></b>")
	msg_ghost += "Receiving '[sentname]' via secure connection ... <a href='?FaxView=\ref[faxcontents]'>view message</a>"
	CLFaxes.Add("<a href='?FaxView=\ref[faxcontents]'>\[view message at [world.timeofday]\]</a> <a href='?_src_=admin_holder;CLFaxReply=\ref[Sender];originfax=\ref[originfax]'>REPLY</a>")
	announce_fax(msg_admin, msg_ghost)

/proc/announce_fax(var/msg_admin, var/msg_ghost)
	log_admin(msg_admin) //Always irked me the replies do show up but the faxes themselves don't
	for(var/client/C in admins)
		if((R_ADMIN|R_MOD) & C.admin_holder.rights)
			if(msg_admin)
				to_chat(C, msg_admin)
			else
				to_chat(C, msg_ghost)
			C << 'sound/effects/sos-morse-code.ogg'
	if(msg_ghost)
		for(var/mob/dead/observer/g in player_list)
			if(!g.client)
				continue
			var/client/C = g.client
			if(C && C.admin_holder)
				if((R_ADMIN|R_MOD) & C.admin_holder.rights) //staff don't need to see the fax twice
					continue
			to_chat(C, msg_ghost)
			C << 'sound/effects/sos-morse-code.ogg'

proc/SendFax(var/sent, var/sentname, var/mob/Sender, var/dpt)

	for(var/obj/structure/machinery/faxmachine/F in allfaxes)
		if( F.department == dpt )
			if(! (F.inoperable() ) )

				flick("faxreceive", F)

				// give the sprite some time to flick
				spawn(20)
					var/obj/item/paper/P = new /obj/item/paper( F.loc )
					P.name = "[sentname]"
					P.info = "[sent]"
					P.update_icon()

					playsound(F.loc, "sound/items/polaroid1.ogg", 15, 1)

/obj/structure/machinery/computer3/server
	name			= "server"
	icon			= 'icons/obj/structures/machinery/computer3.dmi'
	icon_state		= "serverframe"

/obj/structure/machinery/computer3/server/rack
	name = "server rack"
	icon_state = "rackframe"

	update_icon()
		//overlays.Cut()
		return

	attack_hand() // Racks have no screen, only AI can use them
		return


/obj/structure/machinery/lapvend
	name = "Laptop Vendor"
	desc = "A generic vending machine."
	icon = 'icons/obj/structures/machinery/vending.dmi'
	icon_state = "robotics"
	layer = BELOW_OBJ_LAYER
	anchored = TRUE
	density = TRUE
	flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM

/obj/structure/machinery/mech_bay_recharge_port
	name = "Mech Bay Power Port"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/structures/props/mech.dmi'
	icon_state = "recharge_port"
	flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM

/obj/structure/machinery/mecha_part_fabricator
	icon = 'icons/obj/structures/machinery/robotics.dmi'
	icon_state = "fab-idle"
	name = "Exosuit Fabricator"
	desc = "Nothing is being built."
	density = TRUE
	anchored = TRUE
	use_power = 1
	idle_power_usage = 20
	active_power_usage = 5000
	flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM

/obj/structure/machinery/computer/mecha
	name = "Exosuit Control"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "mecha"
	req_one_access = list(ACCESS_MARINE_ENGINEERING, ACCESS_CIVILIAN_ENGINEERING)
	circuit = "/obj/item/circuitboard/computer/mecha_control"