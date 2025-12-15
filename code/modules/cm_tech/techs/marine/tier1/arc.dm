/datum/tech/arc
	name = "M540-B Armored Recon Carrier"
	desc = "Purchase an M540-B Armored Recon Carrier, specialized in assisting groundside command. Able to be driven by Staff Officers, Executive Officers, and Commanding Officers."
	icon_state = "upgrade"

	required_points = 5

	tier = /datum/tier/one

	announce_name = "M540-B ARC ACQUIRED"
	announce_message = "An M540-B Armored Recon Carrier has been authorized and will be delivered in the vehicle bay."

	flags = TREE_FLAG_MARINE


/datum/tech/arc/can_unlock(mob/unlocking_mob)
	. = ..()

	var/obj/structure/machinery/cm_vending/gear/vehicle_crew/gearcomp = GLOB.VehicleGearConsole

	if(gearcomp.selected_vehicle == "TANK")
		to_chat(unlocking_mob, SPAN_WARNING ("A vehicle has already been selected for this operation."))
		return FALSE

	return TRUE


/datum/tech/arc/on_unlock()
	. = ..()

	var/obj/structure/machinery/computer/supply/asrs/vehicle/comp = GLOB.VehicleElevatorConsole
	var/obj/structure/machinery/cm_vending/gear/vehicle_crew/gearcomp = GLOB.VehicleGearConsole

	if(!comp || !gearcomp)
		return FALSE

	comp.spent = FALSE
	QDEL_NULL_LIST(comp.vehicles)
	comp.vehicles = list(
		new /datum/vehicle_order/arc()
	)
	comp.allowed_roles = list(JOB_SYNTH, JOB_SEA, JOB_SO, JOB_XO, JOB_CO, JOB_GENERAL)
	comp.req_access = list(ACCESS_MARINE_COMMAND)
	comp.req_one_access = list()
	comp.spent = FALSE

	gearcomp.req_access = list(ACCESS_MARINE_COMMAND)
	gearcomp.req_one_access = list()
	gearcomp.vendor_role = list()
	gearcomp.selected_vehicle = "ARC"
	gearcomp.available_categories = VEHICLE_ALL_AVAILABLE

	return TRUE
