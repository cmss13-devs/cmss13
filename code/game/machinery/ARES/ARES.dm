/obj/structure/machinery/ares
	name = "ARES Machinery"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 600
	icon = 'icons/obj/structures/machinery/ares.dmi'
	unslashable = TRUE
	unacidable = TRUE

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
	if(new_link)
		link = new_link
		new_link.linked_systems += src
		return TRUE

/obj/structure/machinery/ares/proc/delink()
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
	new_link.processor_apollo = src

/obj/structure/machinery/ares/processor/apollo/delink()
	if(link && link.processor_apollo == src)
		link.processor_apollo = null
	..()

/obj/structure/machinery/ares/processor/interface
	name = "ARES Processor (Interface)"
	desc = "An external processor for ARES; this one handles core processes for interfacing with the crew, including radio transmissions and broadcasts."
	icon_state = "int_processor"

/obj/structure/machinery/ares/processor/interface/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	..()
	new_link.processor_interface = src

/obj/structure/machinery/ares/processor/interface/delink()
	if(link && link.processor_interface == src)
		link.processor_interface = null
	..()

/obj/structure/machinery/ares/processor/bioscan
	name = "ARES Processor (Bioscan)"
	desc = "The external component of ARES' Bioscan systems. Without this, the USS Almayer would be incapable of running bioscans!"
	icon_state = "bio_processor"

/obj/structure/machinery/ares/processor/bioscan/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	..()
	new_link.processor_bioscan = src

/obj/structure/machinery/ares/processor/bioscan/delink()
	if(link && link.processor_bioscan == src)
		link.processor_bioscan = null
	..()

/// Central Core
/obj/structure/machinery/ares/cpu
	name = "ARES CPU"
	desc = "This is ARES' central processor. Made of a casing designed to withstand nuclear blasts, the CPU also contains ARES' blackbox recorder."
	icon_state = "CPU"

/obj/structure/machinery/ares/cpu/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	..()
	new_link.central_processor = src

/obj/structure/machinery/ares/cpu/delink()
	if(link && link.central_processor == src)
		link.central_processor = null
	..()

/// Memory Substrate,
/obj/structure/machinery/ares/substrate
	name = "ARES Substrate"
	desc = "The memory substrate of ARES, containing complex protocols and information. Limited capabilities can operate on substrate alone, without the main ARES Unit operational."
	icon_state = "substrate"

/// Sentry
/obj/structure/machinery/defenses/sentry/premade/deployable/almayer/mini/ares
	name = "UA X512-S mini sentry"
	faction_group = FACTION_LIST_ARES_MARINE

/obj/structure/machinery/defenses/sentry/premade/deployable/almayer/mini/ares/Initialize()
	link_sentry()
	. = ..()

/obj/structure/machinery/defenses/sentry/premade/deployable/almayer/mini/ares/Destroy()
	delink_sentry()
	. = ..()

/obj/structure/machinery/defenses/sentry/premade/deployable/almayer/mini/ares/start_processing()
	sync_iff()
	..()

/obj/structure/machinery/defenses/sentry/premade/deployable/almayer/mini/ares/proc/sync_iff()
	var/datum/ares_link/ares_link = GLOB.ares_link
	if(!ares_link || !ares_link.faction_group)
		faction_group = FACTION_LIST_ARES_MARINE
	faction_group = ares_link.faction_group

/obj/structure/machinery/defenses/sentry/premade/deployable/almayer/mini/ares/proc/link_sentry()
	var/datum/ares_link/link = GLOB.ares_link
	link.core_sentries += src

/obj/structure/machinery/defenses/sentry/premade/deployable/almayer/mini/ares/proc/delink_sentry()
	var/datum/ares_link/link = GLOB.ares_link
	link.core_sentries -= src
