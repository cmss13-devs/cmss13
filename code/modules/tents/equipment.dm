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
	if(!located_tent)
		return COMPONENT_INCOMPATIBLE
	linked_tent = located_tent
	machine.needs_power = FALSE
	RegisterSignal(linked_tent, COMSIG_PARENT_QDELETING, PROC_REF(enable_power_requirement))

/datum/component/tent_powered_machine/proc/enable_power_requirement()
	SIGNAL_HANDLER
	var/obj/structure/machinery/machine = parent
	machine.needs_power = TRUE

/// Groundside console
/obj/structure/machinery/computer/overwatch/tent/Initialize(mapload, ...)
	AddComponent(/datum/component/tent_powered_machine)
	return ..()
