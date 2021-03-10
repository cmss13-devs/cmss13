/datum/tech/ltb
	name = "Armored Support"
	desc = "Gives the marines the LTB tank and 2 kits to make vehicle crewmen. The kits will be delivered by ASRS."
	icon_state = "ltb"

	flags = TREE_FLAG_MARINE

	required_points = 30
	tier = /datum/tier/three

	var/list/to_order

/datum/tech/ltb/New()
	. = ..()
	// I have to write this abomination because of ASRS
	var/datum/supply_packs/VK = /datum/supply_packs/vc_kit
	var/datum/supply_packs/ALC =  /datum/supply_packs/ammo_ltb_cannon
	var/datum/supply_packs/AGL = /datum/supply_packs/ammo_glauncher

	to_order = list(
		initial(VK.name),
		initial(ALC.name),
		initial(AGL.name)
	)


/datum/tech/ltb/on_unlock()
	. = ..()

	var/obj/structure/machinery/computer/supplycomp/vehicle/comp = VehicleElevatorConsole

	if(!comp)
		return

	comp.spent = FALSE
	QDEL_NULL_LIST(comp.vehicles)
	comp.vehicles = list(
		new/datum/vehicle_order/tank/ltb()
	)
	comp.allowed_roles = null
	comp.req_access = list()
	comp.req_one_access = list()

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
		/obj/item/pamphlet/vc,
		/obj/item/pamphlet/vc
	)
	cost = 0
	containertype = /obj/structure/closet/crate/supply
	containername = "vehicle crewman kits crate"
	buyable = 0
	group = "Operations"
	iteration_needed = null

/datum/vehicle_order/tank/ltb
	name = "M34A2 Longstreet Light Tank (LTB)"
	ordered_vehicle = /obj/vehicle/multitile/tank/fixed_ltb

/datum/vehicle_order/tank/ltb/has_vehicle_lock()
	return FALSE

/datum/vehicle_order/tank/ltb/on_created(var/obj/vehicle/multitile/tank/fixed_ltb/tank)
	tank.req_one_access = list()

/obj/item/pamphlet/vc
	name = "vehicle training manual"
	desc = "A manual used to quickly impart vital knowledge on driving vehicles."
	skill_increment = SKILL_VEHICLE_CREWMAN
	skill_to_increment = SKILL_VEHICLE
	secondary_skill = SKILL_ENGINEER

	bypass_pamphlet_limit = TRUE

/obj/vehicle/multitile/tank/fixed_ltb/load_hardpoints(var/obj/vehicle/multitile/R)
	..()

	add_hardpoint(new /obj/item/hardpoint/support/artillery_module)
	add_hardpoint(new /obj/item/hardpoint/armor/ballistic)
	add_hardpoint(new /obj/item/hardpoint/locomotion/treads)

	var/obj/item/hardpoint/holder/tank_turret/T = locate() in hardpoints
	if(!T)
		return

	T.add_hardpoint(new /obj/item/hardpoint/primary/cannon)
	T.add_hardpoint(new /obj/item/hardpoint/secondary/grenade_launcher)