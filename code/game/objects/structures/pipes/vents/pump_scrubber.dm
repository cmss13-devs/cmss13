/obj/structure/pipes/vents/scrubber
	icon = 'icons/obj/pipes/vent_scrubber.dmi'
	icon_state = "map_vent"
	name = "Air Scrubber"
	vent_icon = "scrubber"

/obj/structure/pipes/vents/scrubber/no_boom
	name = "Reinforced Air Scrubber"
	explodey = FALSE

/obj/structure/pipes/vents/scrubber/on
	icon_state = "on"


/obj/structure/pipes/vents/pump
	icon = 'icons/obj/pipes/vent_pump.dmi'
	icon_state = "map_vent"
	name = "Air Vent"

/obj/structure/pipes/vents/pump/no_boom
	name = "Reinforced Air Vent"
	explodey = FALSE

/// Vents that are linked to ARES Security Protocols, allowing the ARES Interface to trigger security measures.
/obj/structure/pipes/vents/pump/no_boom/gas
	name = "Security Air Vent"
	var/datum/ares_link/link
	var/vent_tag
	COOLDOWN_DECLARE(vent_trigger_cooldown)

/obj/structure/pipes/vents/pump/no_boom/gas/Initialize()
	link_systems(override = FALSE)
	. = ..()

/obj/structure/pipes/vents/pump/no_boom/gas/Destroy()
	delink()
	return ..()

/obj/structure/pipes/vents/pump/no_boom/gas/proc/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	if(link && !override)
		return FALSE
	delink()
	if(new_link)
		link = new_link
		new_link.linked_vents += src
		return TRUE

/obj/structure/pipes/vents/pump/no_boom/gas/proc/delink()
	if(link)
		link.linked_vents -= src
		link = null

/obj/structure/pipes/vents/pump/on
	icon_state = "on"

/obj/structure/pipes/vents/pump/siphon/on
	icon_state = "in"

/obj/structure/pipes/vents/pump/high_volume
	name = "Large Air Vent"

/obj/structure/pipes/vents/pump/engine
	name = "Engine Core Vent"

// Hybrisa pump (Same but different appearance)

/obj/structure/pipes/vents/scrubber_hybrisa
	icon = 'icons/obj/pipes/vent_pump_hybrisa.dmi'
	icon_state = "map_vent"
	name = "Air Scrubber"
	vent_icon = "scrubber"

/obj/structure/pipes/vents/scrubber_hybrisa/no_boom
	name = "Reinforced Air Scrubber"
	explodey = FALSE

/obj/structure/pipes/vents/scrubber_hybrisa/on
	icon_state = "on"


/obj/structure/pipes/vents/pump_hybrisa
	icon = 'icons/obj/pipes/vent_pump_hybrisa.dmi'
	icon_state = "map_vent"
	name = "Air Vent"

/obj/structure/pipes/vents/pump_hybrisa/no_boom
	name = "Reinforced Air Vent"
	explodey = FALSE

/// Vents that are linked to ARES Security Protocols, allowing the ARES Interface to trigger security measures.
/obj/structure/pipes/vents/pump_hybrisa/no_boom/gas
	name = "Security Air Vent"
	var/datum/ares_link/link
	var/vent_tag
	COOLDOWN_DECLARE(vent_trigger_cooldown)

/obj/structure/pipes/vents/pump_hybrisa/no_boom/gas/Initialize()
	link_systems(override = FALSE)
	. = ..()

/obj/structure/pipes/vents/pump_hybrisa/no_boom/gas/Destroy()
	delink()
	return ..()

/obj/structure/pipes/vents/pump_hybrisa/no_boom/gas/proc/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	if(link && !override)
		return FALSE
	delink()
	if(new_link)
		link = new_link
		new_link.linked_vents += src
		return TRUE

/obj/structure/pipes/vents/pump_hybrisa/no_boom/gas/proc/delink()
	if(link)
		link.linked_vents -= src
		link = null

/obj/structure/pipes/vents/pump_hybrisa/on
	icon_state = "on"

/obj/structure/pipes/vents/pump_hybrisa/siphon/on
	icon_state = "in"

/obj/structure/pipes/vents/pump_hybrisa/high_volume
	name = "Large Air Vent"

/obj/structure/pipes/vents/pump_hybrisa/engine
	name = "Engine Core Vent"
