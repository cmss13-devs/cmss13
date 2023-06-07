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
	name = "ARES Processor (Apollo)"
	desc = "The external component of ARES' Apollo processor. Primarily responsible for coordinating Working Joes and Maintenance Drones. It definitely wasn't stolen from Seegson."
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

	var/authentication = ARES_ACCESS_BASIC

	/// The last person to login.
	var/last_login
	/// The person pretending to be last_login
	var/sudo_holder
	/// A record of who logged in and when.
	var/list/access_list = list()

	/// The ID used to link all devices.
	var/link_id = MAIN_SHIP_DEFAULT_NAME
	var/datum/ares_link/link
	var/obj/structure/machinery/ares/processor/interface/processor

	/// The chat log of the apollo link. Timestamped.
	var/list/apollo_log = list()
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
	/// Holds all (/datum/ares_record//datum/ares_record/requisition_log)s
	var/list/records_asrs = list()
	/// Holds all (/datum/ares_record/security)s and (/datum/ares_record/antiair)s
	var/list/records_security = list()
	/// Is nuke request usable or not?
	var/nuke_available = FALSE


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

/obj/effect/step_trigger/ares_alert
	layer = 5
	/// Link alerts to ARES Link
	var/datum/ares_link/link
	var/link_id
	/// Alert message to report unless area based.
	var/alert_message = "ALERT: Unauthorized movement detected in ARES Core!"
	/// Connect alerts to use same cooldowns
	var/alert_id
	/// Set to true if it should report area name and not specific alert.
	var/area_based = FALSE
	/// Cooldown duration and next time.
	var/cooldown_duration = 45 SECONDS
	var/cooldown = 0
	/// The job on a mob to enter
	var/list/pass_jobs = list(JOB_WORKING_JOE, JOB_CHIEF_ENGINEER, JOB_CO)
	/// The accesses on an ID card to enter
	var/pass_accesses = list(ACCESS_ARES_DEBUG)

/obj/effect/step_trigger/ares_alert/Crossed(mob/living/passer)
	if(!passer)
		return FALSE
	if(!(ishuman(passer) || isxeno(passer)))
		return FALSE
	if(cooldown > world.time)//Don't want alerts spammed.
		return FALSE
	if(passer.alpha <= 100)//Can't be seen/detected to trigger alert.
		return FALSE
	if(pass_jobs)
		if(passer.job in pass_jobs)
			return FALSE
		if(isxeno(passer) && (JOB_XENOMORPH in pass_jobs))
			return FALSE
	if(ishuman(passer))
		var/mob/living/carbon/human/trespasser = passer
		if(pass_accesses && (trespasser.wear_id))
			for(var/tag in pass_accesses)
				if(tag in trespasser.wear_id.access)
					return FALSE
	Trigger(passer)
	return TRUE


/obj/effect/step_trigger/ares_alert/Initialize(mapload, ...)
	link_systems(override = FALSE)
	. = ..()
/obj/effect/step_trigger/ares_alert/Destroy()
	delink()
	return ..()
/obj/effect/step_trigger/ares_alert/proc/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	if(link && !override)
		return FALSE
	if(new_link.link_id == link_id)
		link = new_link
		new_link.linked_alerts += src
		return TRUE
/obj/effect/step_trigger/ares_alert/proc/delink()
	if(link)
		link.linked_alerts -= src
		link = null


/obj/effect/step_trigger/ares_alert/Trigger(mob/living/passer)
	var/broadcast_message = alert_message
	if(area_based)
		var/area_name = get_area_name(src, TRUE)
		broadcast_message = "ALERT: Unauthorized movement detected in [area_name]!"

	var/datum/ares_link/link = GLOB.ares_link
	if(link.p_apollo.inoperable())
		return FALSE
	else
		to_chat(passer, SPAN_BOLDWARNING("You hear a soft beeping sound as you cross the threshold."))
		var/datum/language/apollo/apollo = GLOB.all_languages[LANGUAGE_APOLLO]
		for(var/mob/living/silicon/decoy/ship_ai/ai in ai_mob_list)
			apollo.broadcast(ai, broadcast_message)
		for(var/mob/listener in (GLOB.human_mob_list + GLOB.dead_mob_list))
			if(listener.hear_apollo())//Only plays sound to mobs and not observers, to reduce spam.
				playsound_client(listener.client, sound('sound/misc/interference.ogg'), listener, vol = 45)
		var/new_cooldown = (world.time + cooldown_duration)
		if(alert_id && link)
			for(var/obj/effect/step_trigger/ares_alert/alert in link.linked_alerts)
				alert.cooldown = new_cooldown
		cooldown = new_cooldown
	return TRUE

/obj/effect/step_trigger/ares_alert/core
	alert_id = "AresCore"
/obj/effect/step_trigger/ares_alert/mainframe
	alert_id = "AresMainframe"
	alert_message = "ALERT: Unauthorized movement detected in ARES Mainframe!"

/obj/effect/step_trigger/ares_alert/terminals
	alert_id = "AresTerminals"
	alert_message = "ALERT: Unauthorized movement detected in ARES' Operations Center!"

/obj/effect/step_trigger/ares_alert/comms
	area_based = TRUE
	alert_id = "TComms"
	pass_accesses = list(ACCESS_MARINE_CE)
