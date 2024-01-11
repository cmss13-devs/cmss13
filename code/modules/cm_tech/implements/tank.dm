/obj/item/pamphlet/skill/vc
	name = "vehicle training manual"
	desc = "A manual used to quickly impart vital knowledge on driving vehicles."
	icon_state = "pamphlet_vehicle"
	trait = /datum/character_trait/skills/vc
	bypass_pamphlet_limit = TRUE

/obj/item/vehicle_coupon
	name = "vehicle coupon"
	desc = "A coupon to be used for ASRS Vehicle Consoles to grant the wearer an actual APC! Yeah baby, we're done walking! One use only. The ASRS elevator must be manually sent to lower level. Special restrictions may apply. No warranty."
	icon = 'icons/obj/items/pamphlets.dmi'
	icon_state = "pamphlet_written"
	item_state = "pamphlet_written"
	var/vehicle_type = /datum/vehicle_order/apc
	var/vehicle_category = "APC"

/obj/item/vehicle_coupon/tank
	name = "tank coupon"
	desc = "We're done playing! This coupon allows the ship crew to retrieve a complete Longstreet tank from Vehicle ASRS. Make sure to send the ASRS lift down so it can be retrieved. One use only. LTB not included. Comes with free friendly fire."
	vehicle_type = /datum/vehicle_order/tank
	vehicle_category = "TANK"

/obj/item/vehicle_coupon/attack_self(mob/user)
	if(QDELETED(src))
		return
	if(redeem_vehicle())
		to_chat(user, SPAN_WARNING("\The [src] catches fire as it is read and resets the ASRS Vehicle system! Send the lift down and haul your prize up."))
		qdel(src)
	return ..()

/obj/item/vehicle_coupon/proc/redeem_vehicle(mob/user)
	SHOULD_NOT_SLEEP(TRUE)
	. = FALSE
	var/obj/structure/machinery/computer/supplycomp/vehicle/comp = GLOB.VehicleElevatorConsole
	var/obj/structure/machinery/cm_vending/gear/vehicle_crew/gearcomp = GLOB.VehicleGearConsole

	if(!comp || !gearcomp)
		return

	. = TRUE

	QDEL_LIST_ASSOC_VAL(comp.vehicles)
	comp.vehicles = list(
		/datum/vehicle_order/tank = new /datum/vehicle_order/tank()
	)

	return TRUE
