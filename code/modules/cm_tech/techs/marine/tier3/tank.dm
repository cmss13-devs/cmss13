/datum/tech/tank
	name = "Armored Support"
	desc = "Gives the marines the ability to send a tank up by ASRS and 2 kits to make vehicle crewmen, freeing the vehicle vendors. The kits will be delivered by ASRS."
	icon_state = "ltb"

	flags = TREE_FLAG_MARINE

	required_points = 30
	tier = /datum/tier/three

	var/list/to_order

/datum/tech/tank/New()
	. = ..()
	// I have to write this abomination because of ASRS
	var/datum/supply_packs/VK = /datum/supply_packs/vc_kit

	to_order = list(
		initial(VK.name)
	)

/datum/tech/tank/on_unlock()
	. = ..()

	var/obj/structure/machinery/computer/supplycomp/vehicle/comp = VehicleElevatorConsole
	var/obj/structure/machinery/cm_vending/gear/vehicle_crew/gearcomp = VehicleGearConsole

	if(!comp || !gearcomp)
		return

	comp.spent = FALSE
	QDEL_NULL_LIST(comp.vehicles)
	comp.vehicles = list(
		new /datum/vehicle_order/tank()
	)
	comp.allowed_roles = null
	comp.req_access = list()
	comp.req_one_access = list()
	comp.spent = FALSE

	gearcomp.req_access = list()
	gearcomp.req_one_access = list()
	gearcomp.vendor_role = list()
	gearcomp.selected_vehicle = "TANK"
	gearcomp.available_categories = VEHICLE_ALL_AVAILABLE

	for(var/order in to_order)
		var/datum/supply_order/O = new /datum/supply_order()
		O.ordernum = supply_controller.ordernum
		supply_controller.ordernum++
		O.object = supply_controller.supply_packs[order]
		O.orderedby = MAIN_AI_SYSTEM
		O.approvedby = MAIN_AI_SYSTEM

		supply_controller.shoppinglist += O

/datum/supply_packs/vc_kit
	name = "Vehicle Crewman Kits"
	contains = list(
		/obj/item/pamphlet/skill/vc,
		/obj/item/pamphlet/skill/vc
	)
	cost = 0
	containertype = /obj/structure/closet/crate/supply
	containername = "vehicle crewman kits crate"
	buyable = 0
	group = "Operations"
	iteration_needed = null

/obj/item/pamphlet/skill/vc
	name = "vehicle training manual"
	desc = "A manual used to quickly impart vital knowledge on driving vehicles."
	icon_state = "pamphlet_vehicle"
	trait = /datum/character_trait/skills/vc
	bypass_pamphlet_limit = TRUE
