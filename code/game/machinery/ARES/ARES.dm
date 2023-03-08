/obj/structure/machinery/ares
	name = "ARES Machinery"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 600
	icon = 'icons/obj/structures/machinery/ares.dmi'
	unslashable = TRUE
	unacidable = TRUE

	var/link_id = MAIN_SHIP_DEFAULT_NAME
	var/datum/ares_link/link

/obj/structure/machinery/ares/ex_act(severity)
	return

/obj/structure/machinery/ares/processor
	name = "ARES Processor"
	desc = "An external processor for ARES, used to process vast amounts of information."
	icon_state = "processor"

/obj/structure/machinery/ares/processor/Initialize(mapload, ...)
	link_systems(override = FALSE)
	. = ..()

/obj/structure/machinery/ares/processor/proc/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	if(!new_link)
		log_debug("Error: link_systems called without a link datum")
	if(link && !override)
		return FALSE
	if(new_link.link_id == link_id)
		link = new_link
		log_debug("[name] linked to Ares Link [link_id]")
		return TRUE

/obj/structure/machinery/ares/processor/apollo
	name = "ARES Processor (Apollo)"
	desc = "The external component of ARES' Apollo processor. Primarily responsible for coordinating Working Joes and Maintenance Drones. It definitely wasn't stolen from Seegson."
	icon_state = "apollo_processor"

/obj/structure/machinery/ares/processor/apollo/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	..()
	new_link.p_apollo = src

/obj/structure/machinery/ares/processor/interface
	name = "ARES Processor (Interface)"
	desc = "An external processor for ARES; this one handles core processes for interfacing with the crew, including radio transmissions and broadcasts."

/obj/structure/machinery/ares/processor/interface/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	..()
	new_link.p_interface = src

/obj/structure/machinery/ares/processor/bioscan
	name = "ARES Processor (Bioscan)"
	desc = "The external component of ARES' Bioscan systems. Without this, the USS Almayer would be incapable of running bioscans!"
	icon_state = "bio_processor"

/obj/structure/machinery/ares/processor/bioscan/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	..()
	new_link.p_bioscan = src

/// Central Core
/obj/structure/machinery/ares/cpu
	name = "ARES CPU"
	desc = "This is ARES' central processor. Made of a casing designed to withstand nuclear blasts, the CPU also contains ARES' blackbox recorder."
	icon_state = "CPU"

/// Memory Substrate,
/obj/structure/machinery/ares/substrate
	name = "ARES Substrate"
	desc = "The memory substrate of ARES, containing complex protocols and information. Limited capabilities can operate on substrate alone, without the main ARES Unit operational."
	icon_state = "substrate"

// #################### ARES Interface Console #####################
/// I wonder what this does.
#define ARES_ACCESS_NONE 0
/// Generic access for 1:1 conversations with ARES and unrestricted commands.
#define ARES_ACCESS_BASIC 1
/// Secure Access, can read ARES Announcements and Bioscans.
#define ARES_ACCESS_COMMAND 2
/// CL, can read Apollo Log and also Delete Announcements.
#define ARES_ACCESS_CORPORATE 3
/// Senior Command, can Delete Bioscans.
#define ARES_ACCESS_SENIOR 4
/// Commanding Officer, can read the access log.
#define ARES_ACCESS_CO 5
/// High Command, can read the deletion log.
#define ARES_ACCESS_HIGH 6

#define MODE_MENU 1
#define MODE_APOLLO 2
#define MODE_ACCESS_LOG 3
#define MODE_ANNOUNCE_L 4//List
#define MODE_ANNOUNCE_V 5//View
#define MODE_ANNOUNCE_D 6//Delete
#define MODE_BIOSCAN_L 7
#define MODE_BIOSCAN_V 8
#define MODE_BIOSCAN_D 9
#define MODE_DELETED_L 10
#define MODE_DELETED_V 11

/obj/structure/machinery/computer/ares_console
	name = "ARES Interface"
	desc = "A console built to interface with ARES, allowing for 1:1 communication."
	icon = 'icons/obj/structures/machinery/ares.dmi'
	icon_state = "console"
	exproof = TRUE

	var/mode = MODE_MENU
	var/authentication = ARES_ACCESS_NONE
	var/current_message = 0

	/// The last person to login.
	var/last_login
	/// A record of who logged in and when.
	var/list/access_list = list()

	/// The ID used to link all devices.
	var/link_id = MAIN_SHIP_DEFAULT_NAME
	var/datum/ares_link/link
	var/obj/structure/machinery/ares/processor/interface/processor

	/// The title of any ARES shipwide or Comms announcement, and timestamp.
	var/list/announcement_title = list()
	/// Contents of the announcements made.
	var/list/announcement_text = list()

	/// Title and timestamp of any bioscans.
	var/list/bioscan_title = list()
	/// Contents of bioscan.
	var/list/bioscan_details = list()

	/// The chat log of the apollo link. Timestamped.
	var/list/apollo_log = list()

	/// Title of any deleted announcements or bioscans. Timestamped.
	var/list/deleted_title = list()
	/// Details of anything deleted.
	var/list/deleted_details = list()
	/// Who did the deed, and when.
	var/list/deleted_user = list()

/obj/structure/machinery/computer/ares_console/proc/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	if(link && !override)
		return FALSE
	if(new_link.link_id == link_id)
		new_link.interface = src
		link = new_link
		log_debug("[name] linked to Ares Link [link_id]")
		return TRUE

/obj/structure/machinery/computer/ares_console/Initialize(mapload, ...)
	link_systems(override = FALSE)
	. = ..()

/obj/structure/machinery/computer/ares_console/attack_hand(mob/user as mob)
	user.set_interaction(src)
	var/dat = "<body>"

	switch(mode)
		if(MODE_MENU)
			if(authentication)
				dat += "Logged in as <B>[last_login], Access level [authentication]:</B>"
				dat += "<BR><A HREF='?src=\ref[src];aresconsole=logout'>LOG OUT</A>"

				if(authentication >= ARES_ACCESS_COMMAND)
					dat += "<BR><BR><hr>"
					dat += "<BR><A HREF='?src=\ref[src];aresconsole=list_announce'>ARES Announcements</A>"
					dat += "<BR><A HREF='?src=\ref[src];aresconsole=list_bio'>Bioscans</A>"
				if(authentication >= ARES_ACCESS_CORPORATE)
					dat += "<BR><BR><hr>"
					dat += "<BR><A HREF='?src=\ref[src];aresconsole=apollo'>View Apollo Log</A>"
				if(authentication >= ARES_ACCESS_CO)
					dat += "<BR><BR><hr>"
					dat += "<BR><A HREF='?src=\ref[src];aresconsole=accesslog'>View Access Log</A>"
				if(authentication >= ARES_ACCESS_HIGH)
					dat += "<BR><BR><hr>"
					dat += "<BR><A HREF='?src=\ref[src];aresconsole=list_delete'>View Deletion Log</A>"
				dat += "<BR><hr>"

			else
				dat += "<BR><A HREF='?src=\ref[src];aresconsole=login'>LOG IN</A>"

		if(MODE_APOLLO)
			dat += "<B>Apollo Logbook:</B>"
			for(var/msg in apollo_log)
				dat += "<BR>[msg]"

		if(MODE_ACCESS_LOG)
			dat += "<B>Access Log:</B>"
			for(var/log in access_list)
				dat += "<BR>[log]"

		if(MODE_ANNOUNCE_L)
			dat += "Announcements:"
			for(var/i = 1; i<=announcement_title.len; i++)
				dat += "<BR><A HREF='?src=\ref[src];aresconsole=view_announce;message-num=[i]'>[announcement_title[i]]</A>"

		if(MODE_ANNOUNCE_V)
			if(current_message)
				dat += "<B>[announcement_title[current_message]]</B><BR><BR>[announcement_text[current_message]]"
				if(authentication >= ARES_ACCESS_CORPORATE)
					dat += "<BR><BR><A HREF='?src=\ref[src];aresconsole=del_announce'>Delete"
			else
				mode = MODE_ANNOUNCE_L
				attack_hand(user)
				return FALSE

		if(MODE_ANNOUNCE_D)
			if(current_message)
				dat += "Are you sure you want to delete this record? <A HREF='?src=\ref[src];aresconsole=del_announce2'>OK</A>|<A HREF='?src=\ref[src];aresconsole=view_announce'>Cancel</A>"
			else
				mode = MODE_ANNOUNCE_L
				attack_hand(user)
				return FALSE

		if(MODE_BIOSCAN_L)
			dat += "Bioscans:"
			for(var/i = 1; i<=bioscan_title.len; i++)
				dat += "<BR><A HREF='?src=\ref[src];aresconsole=view_bio;message-num=[i]'>[bioscan_title[i]]</A>"

		if(MODE_BIOSCAN_V)
			if(current_message)
				dat += "<B>[bioscan_title[current_message]]</B><BR><BR>[bioscan_details[current_message]]"
				if(authentication >= ARES_ACCESS_SENIOR)
					dat += "<BR><BR><A HREF='?src=\ref[src];aresconsole=del_bio'>Delete"
			else
				mode = MODE_BIOSCAN_L
				attack_hand(user)
				return FALSE

		if(MODE_BIOSCAN_D)
			if(current_message)
				dat += "Are you sure you want to delete this record? <A HREF='?src=\ref[src];aresconsole=del_bio2'>OK</A>|<A HREF='?src=\ref[src];aresconsole=view_bio'>Cancel</A>"
			else
				mode = MODE_BIOSCAN_L
				attack_hand(user)
				return FALSE

		if(MODE_DELETED_L)
			dat += "Deletion Log:"
			for(var/i = 1; i<=deleted_title.len; i++)
				dat += "<BR><A HREF='?src=\ref[src];aresconsole=view_delete;message-num=[i]'>[deleted_title[i]]</A>"

		if(MODE_DELETED_V)
			if(current_message)
				dat += "<B>[deleted_title[current_message]]</B><BR><BR>[deleted_details[current_message]]<BR><BR><B>Deleted by [deleted_user[current_message]].</B>"

	dat += "<BR>[(mode != MODE_MENU) ? "<A HREF='?src=\ref[src];aresconsole=main'>Main Menu</A>|" : ""]<A HREF='?src=\ref[user];mach_close=aresinterface'>Close</A>"
	show_browser(user, dat, "ARES Interface", "aresinterface", "size=400x500")
	onclose(user, "aresinterface")

/obj/structure/machinery/computer/ares_console/Topic(href, href_list)
	if(..()) return FALSE

	usr.set_interaction(src)
	switch(href_list["aresconsole"])
		if("main") mode = MODE_MENU

		if("apollo") mode = MODE_APOLLO
		if("accesslog") mode = MODE_ACCESS_LOG

		if("login")
			if(isRemoteControlling(usr))
				return
			var/mob/living/carbon/human/C = usr
			var/obj/item/card/id/I = C.get_active_hand()
			if(istype(I))
				authentication = get_ares_access(I)
				last_login = I.registered_name
			else
				I = C.wear_id
				if(istype(I))
					authentication = get_ares_access(I)
					last_login = I.registered_name
			if(authentication)
				access_list += "[last_login] at [worldtime2text()], Access Level [authentication]."

		if("logout")
			authentication = ARES_ACCESS_NONE

		if("list_announce")
			current_message = 0
			mode = MODE_ANNOUNCE_L

		if("view_announce")
			mode = MODE_ANNOUNCE_V
			if (!current_message)
				if(href_list["message-num"]) current_message = text2num(href_list["message-num"])
				else mode = MODE_ANNOUNCE_L

		if("del_announce")
			mode = (current_message) ? MODE_ANNOUNCE_D : MODE_ANNOUNCE_L

		if("del_announce2")
			if(authentication)
				if(current_message)
					var/title = announcement_title[current_message]
					var/text  = announcement_text[current_message]
					/// Adds to deletion log
					deleted_title += title
					deleted_details += text
					deleted_user += "[last_login] at [worldtime2text()]"

					/// Actually deletes it
					announcement_title.Remove(title)
					announcement_text.Remove(text)
					current_message = 0
				mode = MODE_ANNOUNCE_L
			else mode = MODE_ANNOUNCE_V

		if("list_bio")
			current_message = 0
			mode = MODE_BIOSCAN_L

		if("view_bio")
			mode = MODE_BIOSCAN_V
			if (!current_message)
				if(href_list["message-num"]) current_message = text2num(href_list["message-num"])
				else mode = MODE_BIOSCAN_L

		if("del_bio")
			mode = (current_message) ? MODE_BIOSCAN_D : MODE_BIOSCAN_L

		if("del_bio2")
			if(authentication)
				if(current_message)
					var/title = bioscan_title[current_message]
					var/text  = bioscan_details[current_message]
					/// Adds to deletion log
					deleted_title += title
					deleted_details += text
					deleted_user += "[last_login] at [worldtime2text()]"

					/// Actually deletes it
					bioscan_title.Remove(title)
					bioscan_details.Remove(text)
					current_message = 0
				mode = MODE_BIOSCAN_L
			else mode = MODE_BIOSCAN_V

		if("list_delete")
			current_message = 0
			mode = MODE_DELETED_L

		if("view_delete")
			mode = MODE_DELETED_V
			if (!current_message)
				if(href_list["message-num"]) current_message = text2num(href_list["message-num"])
				else mode = MODE_DELETED_L

		else return FALSE

	updateUsrDialog()


#undef MODE_MENU
#undef MODE_APOLLO
#undef MODE_ACCESS_LOG
#undef MODE_ANNOUNCE_L//List
#undef MODE_ANNOUNCE_V//View
#undef MODE_ANNOUNCE_D//Delete
#undef MODE_BIOSCAN_L
#undef MODE_BIOSCAN_V
#undef MODE_BIOSCAN_D
#undef MODE_DELETED_L
#undef MODE_DELETED_V
