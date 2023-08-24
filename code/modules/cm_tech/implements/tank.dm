/datum/supply_packs/vc_kit
	name = "Vehicle Crewman Kits"
	contains = list(
		/obj/item/pamphlet/skill/vc,
		/obj/item/pamphlet/skill/vc,
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

/obj/item/tank_coupon
	name = "tank coupon"
	desc = "A coupon to be used for ASRS Vehicle Consoles to grant the wearer a TANK! One use only."
	icon = 'icons/obj/items/pamphlets.dmi'
	icon_state = "pamphlet_written"
	item_state = "pamphlet_written"

/obj/item/tank_coupon/attack_self(mob/user)
	if(QDELETED(src))
		return
	if(redeem_tank())
		to_chat(user, SPAN_WARNING("\The [src] catches fire as it is read, resetting the ASRS Vehicle system!"))
		qdel(src)
	return ..()

/obj/item/tank_coupon/proc/redeem_tank(mob/user)
	SHOULD_NOT_SLEEP(TRUE)
	. = FALSE
	var/obj/structure/machinery/computer/supplycomp/vehicle/comp = VehicleElevatorConsole
	var/obj/structure/machinery/cm_vending/gear/vehicle_crew/gearcomp = VehicleGearConsole

	if(!comp || !gearcomp)
		return

	. = TRUE

	QDEL_LIST_ASSOC_VAL(comp.vehicles)
	comp.vehicles = list(
		/datum/vehicle_order/tank = new /datum/vehicle_order/tank()
	)

	return TRUE
