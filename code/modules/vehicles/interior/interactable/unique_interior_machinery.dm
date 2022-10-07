//This file contains unique miscellaneous modules and machinery for each type of APC

//---------------------------MED APC------------------------

//MED APC version of medevac stretcher for interior
//can only be used when vehicle is not moving and only under allowed ceiling
/obj/structure/bed/medevac_stretcher/vehicle
	name = "medevac stretcher"
	desc = "A medevac stretcher for rapid evacuation of an injured patient via dropship lift. Can only be used when vehicle is stationary and under glass or no ceiling. Accepts patients and body bags. Completely useless for surgery."
	icon = 'icons/obj/vehicles/interiors/apc.dmi'
	icon_state = "stretcher_down"
	foldabletype = null
	base_bed_icon = "stretcher"

	unslashable = FALSE
	indestructible = FALSE
	unacidable = FALSE

	// The vehicle this sretcher is tied to
	var/obj/vehicle/multitile/vehicle = null

/obj/structure/bed/medevac_stretcher/vehicle/toggle_medevac_beacon(mob/user)
	if(!ishuman(user))
		return

	if(!vehicle)
		to_chat(user, SPAN_WARNING("Something went really wrong, tell a dev!"))
		return

	if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		to_chat(user, SPAN_WARNING("You don't know how to use [src]."))
		return

	if(user == buckled_mob)
		to_chat(user, SPAN_WARNING("You can't reach the beacon activation button while buckled to [src]."))
		return

	if(stretcher_activated)
		stretcher_activated = FALSE
		activated_medevac_stretchers -= src
		if(linked_medevac)
			linked_medevac.linked_stretcher = null
			linked_medevac = null
		to_chat(user, SPAN_NOTICE("You deactivate [src]'s beacon."))
		update_icon()

	else
		if(!is_ground_level(vehicle.z))
			to_chat(user, SPAN_WARNING("You can't activate [src]'s beacon here."))
			return

		var/area/AR = get_area(vehicle)
		if(CEILING_IS_PROTECTED(AR.ceiling, CEILING_PROTECTION_TIER_1))
			to_chat(user, SPAN_WARNING("The vehicle must be in the open or under a glass roof."))
			return

		if(buckled_mob || buckled_bodybag)
			stretcher_activated = TRUE
			activated_medevac_stretchers += src
			to_chat(user, SPAN_NOTICE("You activate [src]'s beacon."))
			update_icon()
		else
			to_chat(user, SPAN_WARNING("You need to attach something to [src] before you can activate its beacon yet."))

//MED APC version of crew monitor. Only sprite and fluff difference
/obj/structure/machinery/computer/crew/vehicle
	name = "marines vitals monitoring computer"
	desc = "Used to monitor active health sensors built into the USCM personnel uniforms. The console highlights ship areas with BLUE and other locations with RED."
	icon = 'icons/obj/vehicles/interiors/apc.dmi'
	icon_state = "crew_monitor"
	density = FALSE
	use_power = 0
	idle_power_usage = 1
	active_power_usage = 1
	faction = FACTION_MARINE

	unslashable = FALSE
	indestructible = FALSE
	unacidable = FALSE

/obj/structure/machinery/computer/crew/vehicle/update_icon()
	return

//MED APC version of recharger. Only sprite and fluff difference
/obj/structure/machinery/recharger/vehicle
	name = "recharger"
	desc = "Recharger, hooked up directly to vehicle's power relay."
	icon = 'icons/obj/vehicles/interiors/apc.dmi'
	icon_state = "recharger"
	anchored = 1
	use_power = 0
	idle_power_usage = 1
	active_power_usage = 1

	unslashable = FALSE
	indestructible = FALSE
	unacidable = FALSE

/obj/structure/machinery/recharger/vehicle/attackby(obj/item/G as obj, mob/user as mob)
	if(HAS_TRAIT(G, TRAIT_TOOL_WRENCH))
		to_chat(user, SPAN_WARNING("It doesn't seem that [src] can be unwrenched."))
		return

	. = ..()

//---------------------------MED APC------------------------
