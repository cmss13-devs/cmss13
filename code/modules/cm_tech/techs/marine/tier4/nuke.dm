#define NUKE_UNLOCK_TIME 90 MINUTES

/datum/tech/nuke
	name = "Nuclear Device"
	desc = "Purchase a nuclear device. Only armable after 90 minutes into the operation. It's the only way to be sure."
	icon_state = "nuke"
	icon = 'icons/obj/structures/machinery/nuclearbomb.dmi' //temp, yell at me if you ever see this

	required_points = 20

	tier = /datum/tier/four

	announce_name = "NUCLEAR ARSENAL ACQUIRED"
	announce_message = "A nuclear device has been purchased and will be delivered to requisitions via ASRS."

	flags = TREE_FLAG_MARINE

/datum/tech/nuke/on_unlock()
	. = ..()

	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = supply_controller.ordernum
	supply_controller.ordernum++
	O.object = supply_controller.supply_packs["Intel Operational Nuke"]
	O.orderedby = MAIN_AI_SYSTEM

	supply_controller.shoppinglist += O

/datum/tech/nuke/can_unlock(mob/unlocking_mob)
	. = ..()

	if(!.)
		return

	if(world.time < SSticker.mode.round_time_lobby + NUKE_UNLOCK_TIME)
		return

	return TRUE

#undef NUKE_UNLOCK_TIME
