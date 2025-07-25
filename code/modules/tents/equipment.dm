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
/obj/structure/transmitter/tent
	layer = INTERIOR_WALLMOUNT_LAYER
/obj/structure/transmitter/tent/Initialize(mapload, ...)
	AddComponent(/datum/component/tent_supported_object)
	return ..()

/// ASRS request console
/obj/structure/machinery/computer/supply/tent
	icon_state = "request_wall"
	density = FALSE
	deconstructible = FALSE
	needs_power = FALSE
	explo_proof = TRUE // Goes with the tent instead
	layer = INTERIOR_WALLMOUNT_LAYER
/obj/structure/machinery/computer/supply/tent/Initialize()
	AddComponent(/datum/component/tent_supported_object)
	return ..()

/// NanoMED
/obj/structure/machinery/cm_vending/sorted/medical/wall_med/tent
	unacidable = FALSE
	layer = INTERIOR_WALLMOUNT_LAYER
	needs_power = FALSE
/obj/structure/machinery/cm_vending/sorted/medical/wall_med/tent/Initialize()
	AddComponent(/datum/component/tent_supported_object)
	return ..()

/// Closeable curtains
/obj/structure/tent_curtain
	icon = 'icons/obj/structures/tents_equipment.dmi'
	icon_state = "curtains-classic-o"
	desc = "USCM Curtains for USCM Tents used by USCM Personnel. Close this with right-click to ensure USCM Contents are contained."
	flags_atom = ON_BORDER
	layer = INTERIOR_DOOR_INSIDE_LAYER
	dir = SOUTH
	density = FALSE
	alpha = 180

/obj/structure/tent_curtain/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/tent_supported_object)
	update_icon()

/obj/structure/tent_curtain/get_projectile_hit_boolean(obj/projectile/P)
	return FALSE

/obj/structure/tent_curtain/update_icon()
	. = ..()
	var/camo = SSmapping.configs[GROUND_MAP].camouflage_type
	if(density)
		icon_state = "curtains-[camo]"
	else
		icon_state = "curtains-[camo]-o"

/obj/structure/tent_curtain/attack_hand(mob/user)
	. = ..()
	if(!.)
		playsound(loc, "rustle", 10, TRUE, 4)
		density = !density
		update_icon()
		return TRUE

/obj/structure/tent_curtain/attack_alien(mob/living/carbon/xenomorph/M)
	if(unslashable)
		return
	visible_message(SPAN_BOLDWARNING("[src] gets torn to shreds!"))
	qdel(src)

/// Microwave
/obj/structure/machinery/microwave/tent
	unacidable = FALSE
	density = TRUE
	layer = ABOVE_TABLE_LAYER
	needs_power = FALSE
/obj/structure/machinery/microwave/tent/Initialize()
	AddComponent(/datum/component/tent_supported_object)
	return ..()

/// Hotdrinks vendor
/obj/structure/machinery/vending/coffee/tent
	unacidable = FALSE
	needs_power = FALSE
/obj/structure/machinery/vending/coffee/tent/Initialize()
	AddComponent(/datum/component/tent_supported_object)
	return ..()

/// Ingredients vendor
/obj/structure/machinery/vending/ingredients/tent
	unacidable = FALSE
	needs_power = FALSE
/obj/structure/machinery/vending/ingredients/tent/Initialize()
	AddComponent(/datum/component/tent_supported_object)
	return ..()

/// Food Processor
/obj/structure/machinery/processor/tent
	unacidable = FALSE
	density = TRUE
	layer = ABOVE_TABLE_LAYER
	needs_power = FALSE
/obj/structure/machinery/processor/tent/Initialize()
	AddComponent(/datum/component/tent_supported_object)
	return ..()
