#define NUKE_UNLOCK_TIME (120 MINUTES)

/datum/tech/nuke
	name = "Nuclear Device"
	//desc = "Purchase a nuclear device. Only able to purchase after X minutes into the operation. It's the only way to be sure." //See New()
	icon_state = "nuke"

	required_points = 20

	tier = /datum/tier/four

	announce_name = "NUCLEAR ARSENAL ACQUIRED"
	announce_message = "A nuclear device has been purchased and will be delivered to requisitions via ASRS."

	flags = TREE_FLAG_MARINE

/datum/tech/nuke/New()
	desc = "Purchase a nuclear device. Only able to purchase [NUKE_UNLOCK_TIME / (1 MINUTES)] minutes into the operation. It's the only way to be sure."

/datum/tech/nuke/on_unlock()
	. = ..()

	var/datum/supply_order/new_order = new /datum/supply_order()
	new_order.ordernum = supply_controller.ordernum
	supply_controller.ordernum++
	new_order.object = supply_controller.supply_packs["Intel Operational Nuke"]
	new_order.orderedby = MAIN_AI_SYSTEM

	supply_controller.shoppinglist += new_order

/datum/tech/nuke/can_unlock(mob/unlocking_mob)
	. = ..()

	if(!.)
		return

	if(ROUND_TIME < NUKE_UNLOCK_TIME)
		to_chat(unlocking_mob, SPAN_WARNING("You cannot purchase this node before [NUKE_UNLOCK_TIME / (1 MINUTES)] minutes into the operation."))
		return FALSE

	return TRUE

#undef NUKE_UNLOCK_TIME
