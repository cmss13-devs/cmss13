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

/obj/structure/machinery/ares/Initialize(mapload, ...)
	link_systems(override = FALSE)
	. = ..()

/obj/structure/machinery/ares/Destroy()
	delink()
	return ..()

/obj/structure/machinery/ares/update_icon()
	..()
	icon_state = initial(icon_state)
	// Broken
	if(stat & BROKEN)
		icon_state += "_broken"

	// Powered
	else if(stat & NOPOWER)
		icon_state = initial(icon_state)
		icon_state += "_off"

/// Handles linking and de-linking the ARES systems.
/obj/structure/machinery/ares/proc/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	if(!new_link)
		log_debug("Error: link_systems called without a link datum")
	if(link && !override)
		return FALSE
	if(new_link.link_id == link_id)
		link = new_link
		log_debug("[name] linked to Ares Link [link_id]")
		new_link.linked_systems += src
		return TRUE

/obj/structure/machinery/ares/proc/delink()
	log_debug("[name] delinked from Ares Link [link.link_id]")
	link.linked_systems -= src
	link = null

/obj/structure/machinery/ares/processor
	name = "ARES Processor"
	desc = "An external processor for ARES, used to process vast amounts of information."
	icon_state = "processor"

/obj/structure/machinery/ares/processor/apollo
	name = "ARES Processor (APOLLO)"
	desc = "The external component of ARES' APOLLO processor. Primarily responsible for coordinating Working Joes and Maintenance Drones. It definitely wasn't stolen from Seegson."
	icon_state = "apollo_processor"

/obj/structure/machinery/ares/processor/apollo/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	..()
	new_link.p_apollo = src

/obj/structure/machinery/ares/processor/apollo/delink()
	if(link && link.p_apollo == src)
		link.p_apollo = null
	..()

/obj/structure/machinery/ares/processor/interface
	name = "ARES Processor (Interface)"
	desc = "An external processor for ARES; this one handles core processes for interfacing with the crew, including radio transmissions and broadcasts."
	icon_state = "int_processor"

/obj/structure/machinery/ares/processor/interface/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	..()
	new_link.p_interface = src

/obj/structure/machinery/ares/processor/interface/delink()
	if(link && link.p_interface == src)
		link.p_interface = null
	..()

/obj/structure/machinery/ares/processor/bioscan
	name = "ARES Processor (Bioscan)"
	desc = "The external component of ARES' Bioscan systems. Without this, the USS Almayer would be incapable of running bioscans!"
	icon_state = "bio_processor"

/obj/structure/machinery/ares/processor/bioscan/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	..()
	new_link.p_bioscan = src

/obj/structure/machinery/ares/processor/bioscan/delink()
	if(link && link.p_bioscan == src)
		link.p_bioscan = null
	..()

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
/obj/structure/machinery/computer/ares_console
	name = "ARES Interface"
	desc = "A console built to interface with ARES, allowing for 1:1 communication."
	icon = 'icons/obj/structures/machinery/ares.dmi'
	icon_state = "console"
	exproof = TRUE

	var/current_menu = "login"
	var/last_menu = ""

	var/authentication = ARES_ACCESS_LOGOUT

	/// The last person to login.
	var/last_login = "No User"
	/// The person pretending to be last_login
	var/sudo_holder
	/// A record of who logged in and when.
	var/list/access_list = list()

	/// The ID used to link all devices.
	var/link_id = MAIN_SHIP_DEFAULT_NAME
	var/datum/ares_link/link

	/// The current deleted chat log of 1:1 conversations being read.
	var/list/deleted_1to1 = list()

	/// Holds all (/datum/ares_record/announcement)s
	var/list/records_announcement = list()
	/// Holds all (/datum/ares_record/bioscan)s
	var/list/records_bioscan = list()
	/// Holds all (/datum/ares_record/bombardment)s
	var/list/records_bombardment = list()
	/// Holds all (/datum/ares_record/deletion)s
	var/list/records_deletion = list()
	/// Holds all (/datum/ares_record/talk_log)s
	var/list/records_talking = list()
	/// Holds all (/datum/ares_record/requisition_log)s
	var/list/records_asrs = list()
	/// Holds all (/datum/ares_record/security)s (including AA)
	var/list/records_security = list()
	/// Holds all (/datum/ares_record/flight)s
	var/list/records_flight = list()
	/// Is nuke request usable or not?
	var/nuke_available = TRUE


	COOLDOWN_DECLARE(ares_distress_cooldown)
	COOLDOWN_DECLARE(ares_nuclear_cooldown)

/obj/structure/machinery/computer/ares_console/proc/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	if(link && !override)
		return FALSE
	if(new_link.link_id == link_id)
		new_link.interface = src
		link = new_link
		log_debug("[name] linked to Ares Link [link_id]")
		new_link.linked_systems += src
		return TRUE

/obj/structure/machinery/computer/ares_console/Initialize(mapload, ...)
	link_systems(override = FALSE)
	. = ..()

/obj/structure/machinery/computer/ares_console/proc/delink()
	if(link && link.interface == src)
		link.interface = null
		link.linked_systems -= src
	link = null

/obj/structure/machinery/computer/ares_console/Destroy()
	delink()
	return ..()

// #################### Working Joe Ticket Console #####################
/obj/structure/machinery/computer/working_joe
	name = "APOLLO Maintenance Controller"
	desc = "A console built to facilitate Working Joes and their operation, allowing for simple allocation of resources."
	icon = 'icons/obj/structures/machinery/ares.dmi'
	icon_state = "console"
	exproof = TRUE

	/// The ID used to link all devices.
	var/link_id = MAIN_SHIP_DEFAULT_NAME
	var/datum/ares_link/link
	var/obj/structure/machinery/ares/processor/interface/processor

	var/current_menu = "login"
	var/last_menu = ""

	var/authentication = APOLLO_ACCESS_LOGOUT
	/// The last person to login.
	var/last_login = "No User"
	/// A record of who logged in and when.
	var/list/login_list = list()


	/// If this is used to create AI Core access tickets
	var/ticket_console = FALSE
	var/obj/item/card/id/authenticator_id
	var/ticket_authenticated = FALSE
	var/obj/item/card/id/target_id

/obj/structure/machinery/computer/working_joe/proc/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	if(link && !override)
		return FALSE
	if(new_link.link_id == link_id)
		new_link.ticket_computers += src
		link = new_link
		log_debug("[name] linked to Ares Link [link_id]")
		new_link.linked_systems += src
		return TRUE

/obj/structure/machinery/computer/working_joe/Initialize(mapload, ...)
	link_systems(override = FALSE)
	. = ..()

/obj/structure/machinery/computer/working_joe/proc/delink()
	if(link)
		link.ticket_computers -= src
		link.linked_systems -= src
		link = null

/obj/structure/machinery/computer/working_joe/Destroy()
	delink()
	return ..()
