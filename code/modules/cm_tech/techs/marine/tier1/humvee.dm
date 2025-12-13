/datum/tech/humvee
	name = "M24 Series JTMV Vehicle"
	desc = "Purchase an M24 Series JTMV, a M2420 JTMV-HWC Heavy Weapon Carrier, M2421 JTMV-Ambulance, or M2422 JTMV-Utility variant may be selected."
	icon_state = "humvee"

	required_points = 0

	tier = /datum/tier/one

	announce_name = "M24 Series JTMV ACQUIRED"
	announce_message = "An M24 Series JTMV has been authorized and will be delivered in the vehicle bay."

	flags = TREE_FLAG_MARINE


/datum/tech/humvee/can_unlock(mob/unlocking_mob)
	. = ..()

	var/obj/structure/machinery/cm_vending/gear/vehicle_crew/gearcomp = GLOB.VehicleGearConsole

	if(gearcomp.selected_vehicle == "TANK" || gearcomp.selected_vehicle == "ARC")
		to_chat(unlocking_mob, SPAN_WARNING ("A vehicle has already been selected for this operation."))
		return FALSE

	return TRUE


/datum/tech/humvee/on_unlock()
	. = ..()

	var/obj/structure/machinery/computer/supply/asrs/vehicle/comp = GLOB.VehicleElevatorConsole
	var/obj/structure/machinery/cm_vending/gear/vehicle_crew/gearcomp = GLOB.VehicleGearConsole

	if(!comp || !gearcomp)
		return FALSE

	comp.spent = FALSE
	QDEL_NULL_LIST(comp.vehicles)
	comp.vehicles = list(
		new /datum/vehicle_order/humvee(),
		new /datum/vehicle_order/humvee/medical(),
		new /datum/vehicle_order/humvee/transport()
	)
	comp.allowed_roles = list(JOB_SYNTH, JOB_SEA, JOB_SO, JOB_XO, JOB_CO, JOB_GENERAL)
	comp.req_access = list(ACCESS_MARINE_COMMAND)
	comp.req_one_access = list()
	comp.spent = FALSE

	gearcomp.req_access = list(ACCESS_MARINE_COMMAND)
	gearcomp.req_one_access = list()
	gearcomp.vendor_role = list()
	gearcomp.selected_vehicle = "HUMVEE"
	gearcomp.available_categories = VEHICLE_ALL_AVAILABLE

	return TRUE
