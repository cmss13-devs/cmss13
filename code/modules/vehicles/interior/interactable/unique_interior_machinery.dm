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

	unslashable = TRUE
	indestructible = TRUE
	unacidable = TRUE

	// The vehicle this sretcher is tied to
	var/obj/vehicle/multitile/vehicle = null

/obj/structure/bed/medevac_stretcher/vehicle/is_zlevel_allowed()
	if(!vehicle || vehicle.health < (initial(vehicle.health) * 0.5) || vehicle.next_move > world.time || !is_ground_level(vehicle.z))
		return FALSE
	return TRUE

/obj/structure/bed/medevac_stretcher/vehicle/toggle_medevac_beacon(mob/user)
	if(!ishuman(user))
		return

	if(!vehicle)
		to_chat(user, SPAN_WARNING("Something went really wrong, tell a dev!"))
		return

	if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		to_chat(user, SPAN_WARNING("You don't know how to use \the [src]."))
		return

	if(user == buckled_mob)
		to_chat(user, SPAN_WARNING("You can't reach the beacon activation button while buckled to \the [src]."))
		return

	if(stretcher_activated)
		stretcher_activated = FALSE
		activated_medevac_stretchers -= src
		if(linked_medevac)
			linked_medevac.linked_stretcher = null
			linked_medevac = null
		to_chat(user, SPAN_NOTICE("You deactivate \the [src]'s beacon."))
		update_icon()

	else
		if(!is_ground_level(vehicle.z))
			to_chat(user, SPAN_WARNING("You can't activate \the [src]'s beacon here."))
			return

		var/area/AR = get_area(vehicle)
		if(CEILING_IS_PROTECTED(AR.ceiling, CEILING_PROTECTION_TIER_1))
			to_chat(user, SPAN_WARNING("The vehicle must be in the open or under a glass roof."))
			return

		if(buckled_mob || buckled_bodybag)
			stretcher_activated = TRUE
			activated_medevac_stretchers += src
			to_chat(user, SPAN_NOTICE("You activate \the [src]'s beacon."))
			update_icon()
		else
			to_chat(user, SPAN_WARNING("You need to attach something to \the [src] before you can activate its beacon yet."))

//MED APC version of crew monitor. Only sprite and fluff difference
/obj/structure/machinery/computer/crew/vehicle
	name = "marines vitals monitoring computer"
	desc = "Used to monitor active health sensors built into the USCM personnel uniforms. The console highlights ship areas with BLUE and other locations with RED."
	icon = 'icons/obj/vehicles/interiors/apc.dmi'
	icon_state = "crew_monitor"
	density = FALSE
	use_power = 0

	unslashable = TRUE
	indestructible = TRUE
	unacidable = TRUE

/obj/structure/machinery/computer/crew/vehicle/update_icon()
	return

//MED APC version of recharger. Only sprite and fluff difference
/obj/structure/machinery/recharger/vehicle
	name = "recharger"
	desc = "Recharger, hooked up directly to vehicle's power relay."
	icon = 'icons/obj/vehicles/interiors/apc.dmi'
	icon_state = "recharger"
	use_power = 0
	wrenchable = FALSE
	unslashable = TRUE
	indestructible = TRUE
	unacidable = TRUE

//---------------------------MED APC------------------------
