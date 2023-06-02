/// Component to handle power requirements following removal of the tent
/datum/component/tent_powered_machine
	dupe_mode = COMPONENT_DUPE_HIGHLANDER
	var/obj/structure/tent/linked_tent

/datum/component/tent_powered_machine/Initialize(...)
	. = ..()
	if(!istype(parent, /obj/structure/machinery))
		return COMPONENT_INCOMPATIBLE
	var/obj/structure/machinery/machine = parent
	var/obj/structure/tent/located_tent = locate(/obj/structure/tent) in machine.loc
	if(located_tent)
		linked_tent = located_tent
		machine.needs_power = FALSE
		RegisterSignal(linked_tent, COMSIG_PARENT_QDELETING, PROC_REF(enable_power_requirement))

/datum/component/tent_powered_machine/proc/enable_power_requirement()
	SIGNAL_HANDLER
	var/obj/structure/machinery/machine = parent
	machine.needs_power = TRUE

/// Component to handle destruction of objects following removal of the tent
/datum/component/tent_supported_object
	dupe_mode = COMPONENT_DUPE_HIGHLANDER
	var/obj/structure/tent/linked_tent

/datum/component/tent_supported_object/Initialize(...)
	. = ..()
	if(!istype(parent, /atom/movable))
		return COMPONENT_INCOMPATIBLE
	var/atom/movable/source = parent
	var/obj/structure/tent/located_tent = locate(/obj/structure/tent) in source.loc
	if(located_tent)
		linked_tent = located_tent
		RegisterSignal(linked_tent, COMSIG_PARENT_QDELETING, PROC_REF(tent_collapse))

/datum/component/tent_supported_object/proc/tent_collapse()
	SIGNAL_HANDLER
	qdel(parent)

/// Groundside console
/obj/structure/machinery/computer/overwatch/tent/Initialize(mapload, ...)
	AddComponent(/datum/component/tent_supported_object)
	return ..()

/// Telephone
/obj/structure/transmitter/tent/Initialize(mapload, ...)
	AddComponent(/datum/component/tent_supported_object)
	return ..()

/// NanoMED
/obj/structure/machinery/cm_vending/sorted/medical/wall_med/tent
	unacidable = FALSE
	layer = INTERIOR_WALLMOUNT_LAYER
/obj/structure/machinery/cm_vending/sorted/medical/wall_med/tent/Initialize()
	AddComponent(/datum/component/tent_supported_object)
	return ..()

